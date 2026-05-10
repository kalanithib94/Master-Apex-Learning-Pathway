/**
 * Handler for Public_Enquiry__c trigger.
 *
 * Before insert:
 *   1. Reject true idempotency-key collisions (definite duplicate retries).
 *   2. Flag fuzzy duplicates on email + programme within 30 days
 *      (probable duplicate human re-asks).
 *
 * After insert:
 *   3. Write Integration_Log__c entry for every inbound submission
 *      (including duplicates — full audit trail).
 *   4. Fire outbound mock callout for non-duplicates via @future.
 */
public with sharing class PublicEnquiryTriggerHandler {

    private static final Integer FUZZY_MATCH_WINDOW_DAYS = 30;
    private static final String INBOUND_SOURCE = 'Public Enquiry Form';
    private static final String TARGET_SYSTEM_INTERNAL = 'Salesforce CRM';

    @TestVisible
    private static Boolean inProgress = false;

    /**
     * Before-insert entry point.
     * Jira: V2-8418
     */
    public static void handleBeforeInsert(List<Public_Enquiry__c> newEnquiries) {
        if (inProgress) return;
        inProgress = true;
        try {
            rejectIdempotencyDuplicates(newEnquiries);
            flagFuzzyDuplicates(newEnquiries);
        } finally {
            inProgress = false;
        }
    }

    /**
     * After-insert entry point. Logs every public enquiry submission, sends
     * the enquirer an acknowledgement email, and fires outbound notification
     * for non-duplicates.
     * Jira: V2-8418
     */
    public static void handleAfterInsert(List<Public_Enquiry__c> newEnquiries) {
        if (inProgress) return;
        inProgress = true;
        try {
            logInboundSubmissions(newEnquiries);
            sendAcknowledgementEmails(newEnquiries);

            Set<Id> nonDuplicateIds = collectNonDuplicateIds(newEnquiries);
            if (!nonDuplicateIds.isEmpty()) {
                fireOutboundCallout(nonDuplicateIds);
            }
        } finally {
            inProgress = false;
        }
    }

    /**
     * Sends a plain-text acknowledgement email to each enquirer.
     * Per-record send (not batched per address) so we can vary the body
     * with the enquiry's specific reference number.
     * Failures are caught and logged to Integration_Log__c — they must not
     * abort the trigger transaction.
     * Jira: V2-8418
     */
    private static void sendAcknowledgementEmails(List<Public_Enquiry__c> newEnquiries) {
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        for (Public_Enquiry__c e : newEnquiries) {
            if (String.isBlank(e.Enquirer_Email__c)) continue;
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            msg.setToAddresses(new List<String>{ e.Enquirer_Email__c });
            msg.setSubject('Your enquiry — reference ' + e.Name);
            msg.setPlainTextBody(buildAcknowledgementBody(e));
            msg.setSaveAsActivity(false);
            messages.add(msg);
        }
        if (messages.isEmpty()) return;

        try {
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(messages, false);
            // Log any per-message failures without aborting the transaction
            List<Integration_Log__c> failureLogs = new List<Integration_Log__c>();
            Integer i = 0;
            for (Messaging.SendEmailResult res : results) {
                if (!res.isSuccess()) {
                    failureLogs.add(new Integration_Log__c(
                        Direction__c = 'Outbound',
                        Source_System__c = 'Salesforce CRM',
                        Target_System__c = 'Email',
                        Operation__c = 'Send Acknowledgement Email',
                        Status__c = 'Failure',
                        Related_Record_Id__c = newEnquiries[i].Id,
                        Error_Message__c = (res.getErrors().isEmpty() ? 'unknown' : res.getErrors()[0].getMessage()),
                        Last_Attempt_At__c = DateTime.now(),
                        Attempt_Count__c = 1
                    ));
                }
                i++;
            }
            if (!failureLogs.isEmpty()) {
                insert failureLogs;
            }
        } catch (Exception ex) {
            // Email orchestration completely failed — record one log per enquiry so the team knows
            List<Integration_Log__c> orchFailures = new List<Integration_Log__c>();
            for (Public_Enquiry__c e : newEnquiries) {
                orchFailures.add(new Integration_Log__c(
                    Direction__c = 'Outbound',
                    Source_System__c = 'Salesforce CRM',
                    Target_System__c = 'Email',
                    Operation__c = 'Send Acknowledgement Email',
                    Status__c = 'Failure',
                    Related_Record_Id__c = e.Id,
                    Error_Message__c = ex.getTypeName() + ': ' + ex.getMessage(),
                    Last_Attempt_At__c = DateTime.now(),
                    Attempt_Count__c = 1
                ));
            }
            if (!orchFailures.isEmpty()) {
                insert orchFailures;
            }
        }
    }

    /**
     * Plain-text body for the acknowledgement email, with reference number
     * and the SLA promise.
     * Jira: V2-8418
     */
    private static String buildAcknowledgementBody(Public_Enquiry__c e) {
        return 'Dear ' + (String.isNotBlank(e.Enquirer_Name__c) ? e.Enquirer_Name__c : 'Applicant') + ',\n\n'
            + 'Thank you for your enquiry. We have received your message and a member '
            + 'of our admissions team will respond within 5 working days.\n\n'
            + 'Your reference number: ' + e.Name + '\n'
            + 'Please quote this number in any future correspondence.\n\n'
            + 'Kind regards,\n'
            + 'The Admissions Team\n\n'
            + '---\n'
            + 'This is an automated acknowledgement. Please do not reply directly to this email. '
            + 'Your data is processed under the lawful basis recorded with this enquiry. You can request '
            + 'access, correction or erasure at any time by contacting our Data Protection Officer.';
    }

    /**
     * Hard-rejects new enquiries whose Idempotency_Key__c already exists.
     * Jira: V2-8418
     */
    private static void rejectIdempotencyDuplicates(List<Public_Enquiry__c> newEnquiries) {
        Set<String> keys = new Set<String>();
        for (Public_Enquiry__c e : newEnquiries) {
            if (String.isNotBlank(e.Idempotency_Key__c)) {
                keys.add(e.Idempotency_Key__c);
            }
        }
        if (keys.isEmpty()) return;

        Set<String> existingKeys = new Set<String>();
        for (Public_Enquiry__c existing : [
            SELECT Idempotency_Key__c
            FROM Public_Enquiry__c
            WHERE Idempotency_Key__c IN :keys
        ]) {
            existingKeys.add(existing.Idempotency_Key__c);
        }

        if (existingKeys.isEmpty()) return;

        for (Public_Enquiry__c e : newEnquiries) {
            if (String.isNotBlank(e.Idempotency_Key__c)
                && existingKeys.contains(e.Idempotency_Key__c)) {
                e.addError('Duplicate submission detected. This enquiry has already been received.');
            }
        }
    }

    /**
     * Flags new enquiries as duplicates when an existing recent open enquiry
     * shares the same email and programme within the fuzzy-match window.
     * Jira: V2-8418
     */
    private static void flagFuzzyDuplicates(List<Public_Enquiry__c> newEnquiries) {
        Set<String> emails = new Set<String>();
        for (Public_Enquiry__c e : newEnquiries) {
            if (String.isNotBlank(e.Enquirer_Email__c)) {
                emails.add(e.Enquirer_Email__c.toLowerCase());
            }
        }
        if (emails.isEmpty()) return;

        DateTime cutoff = DateTime.now().addDays(-FUZZY_MATCH_WINDOW_DAYS);

        Map<String, Id> existingByFuzzyKey = new Map<String, Id>();
        for (Public_Enquiry__c existing : [
            SELECT Id, Enquirer_Email__c, Programme_Of_Interest__c
            FROM Public_Enquiry__c
            WHERE Enquirer_Email__c IN :emails
              AND CreatedDate >= :cutoff
              AND Status__c != 'Closed'
            ORDER BY CreatedDate ASC
        ]) {
            String key = buildFuzzyKey(existing.Enquirer_Email__c, existing.Programme_Of_Interest__c);
            if (!existingByFuzzyKey.containsKey(key)) {
                existingByFuzzyKey.put(key, existing.Id);
            }
        }

        if (existingByFuzzyKey.isEmpty()) return;

        for (Public_Enquiry__c e : newEnquiries) {
            if (String.isBlank(e.Enquirer_Email__c)) continue;
            String key = buildFuzzyKey(e.Enquirer_Email__c, e.Programme_Of_Interest__c);
            if (existingByFuzzyKey.containsKey(key)) {
                e.Is_Duplicate__c = true;
                e.Related_Enquiry__c = existingByFuzzyKey.get(key);
            }
        }
    }

    /**
     * Builds normalized matching key. Lowercases email, treats null
     * programme as empty so null=null counts as a match.
     * Jira: V2-8418
     */
    private static String buildFuzzyKey(String email, String programme) {
        String emailPart = (email == null) ? '' : email.toLowerCase();
        String programmePart = (programme == null) ? '' : programme;
        return emailPart + '||' + programmePart;
    }

    /**
     * Writes one Inbound Integration_Log__c per enquiry as audit trail.
     * Duplicates are logged too — every submission visible.
     * Jira: V2-8418
     */
    private static void logInboundSubmissions(List<Public_Enquiry__c> newEnquiries) {
        List<Integration_Log__c> logs = new List<Integration_Log__c>();
        for (Public_Enquiry__c e : newEnquiries) {
            logs.add(new Integration_Log__c(
                Direction__c = 'Inbound',
                Source_System__c = INBOUND_SOURCE,
                Target_System__c = TARGET_SYSTEM_INTERNAL,
                Operation__c = e.Is_Duplicate__c ? 'Create Public Enquiry (duplicate)' : 'Create Public Enquiry',
                Status__c = 'Success',
                Related_Record_Id__c = e.Id,
                Last_Attempt_At__c = DateTime.now(),
                Attempt_Count__c = 1,
                Payload__c = buildInboundPayload(e)
            ));
        }
        if (!logs.isEmpty()) {
            insert logs;
        }
    }

    /**
     * Returns IDs of enquiries that are NOT flagged as duplicates.
     * Jira: V2-8418
     */
    private static Set<Id> collectNonDuplicateIds(List<Public_Enquiry__c> newEnquiries) {
        Set<Id> ids = new Set<Id>();
        for (Public_Enquiry__c e : newEnquiries) {
            if (e.Is_Duplicate__c != true) {
                ids.add(e.Id);
            }
        }
        return ids;
    }

    /**
     * Fires the outbound notification to the mock external system.
     * Async via @future because callouts forbidden in synchronous trigger context.
     * Jira: V2-8418
     */
    private static void fireOutboundCallout(Set<Id> enquiryIds) {
        if (System.isFuture() || System.isBatch() || System.isQueueable()) {
            return;
        }
        OutboundCalloutFuture.sendEnquiryNotification(enquiryIds);
    }

    /**
     * Serialises the enquiry fields we want to persist on the inbound log.
     * Jira: V2-8418
     */
    private static String buildInboundPayload(Public_Enquiry__c e) {
        Map<String, Object> payload = new Map<String, Object>{
            'enquiryId' => e.Id,
            'idempotencyKey' => e.Idempotency_Key__c,
            'enquirerName' => e.Enquirer_Name__c,
            'enquirerEmail' => e.Enquirer_Email__c,
            'enquirerPhone' => e.Enquirer_Phone__c,
            'country' => e.Country__c,
            'countryOther' => e.Country_Other__c,
            'programmeLevel' => e.Programme_Level__c,
            'programmeOfInterest' => e.Programme_Of_Interest__c,
            'consentGiven' => e.Consent_Given__c,
            'lawfulBasis' => e.Lawful_Basis__c,
            'isDuplicate' => e.Is_Duplicate__c,
            'submittedAt' => e.CreatedDate
        };
        return JSON.serializePretty(payload);
    }
}
