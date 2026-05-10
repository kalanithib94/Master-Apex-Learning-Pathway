/**
 * Async outbound notification to the mock external system (e.g., SIS).
 *
 * Fires once per enquiry submission for non-duplicate Public_Enquiry__c records.
 * Each attempt is logged to Integration_Log__c with payload, response, and
 * status — full traceability for support without log access.
 *
 * Endpoint is the public httpbin.org/post echo service, which returns the
 * request payload as JSON. Stand-in for a real SIS / Marketing Cloud receiver.
 */
public with sharing class OutboundCalloutFuture {

    private static final String ENDPOINT = 'https://httpbin.org/post';
    private static final String TARGET_SYSTEM = 'Mock External SIS';
    private static final Integer MAX_ATTEMPTS = 3;

    /**
     * Future entry point. Sends one HTTP POST per enquiry.
     * Each attempt creates an Integration_Log__c record. On success, the
     * enquiry's External_System_Sync_Status__c is set to 'Synced'; on terminal
     * failure it is set to 'Failed'.
     * Jira: V2-8418
     */
    @future(callout=true)
    public static void sendEnquiryNotification(Set<Id> enquiryIds) {
        if (enquiryIds == null || enquiryIds.isEmpty()) return;

        List<Public_Enquiry__c> enquiries = [
            SELECT Id, Name, Idempotency_Key__c, Enquirer_Email__c, Country__c,
                   Programme_Level__c, Programme_Of_Interest__c,
                   External_System_Sync_Status__c
            FROM Public_Enquiry__c
            WHERE Id IN :enquiryIds
        ];

        List<Integration_Log__c> logs = new List<Integration_Log__c>();
        List<Public_Enquiry__c> toUpdate = new List<Public_Enquiry__c>();

        for (Public_Enquiry__c e : enquiries) {
            Integration_Log__c logEntry = sendWithRetry(e);
            logs.add(logEntry);

            e.External_System_Sync_Status__c =
                (logEntry.Status__c == 'Success') ? 'Synced' : 'Failed';
            toUpdate.add(e);
        }

        if (!logs.isEmpty()) {
            insert logs;
        }
        if (!toUpdate.isEmpty()) {
            update toUpdate;
        }
    }

    /**
     * Sends one HTTP POST with up to MAX_ATTEMPTS retries on transient failure.
     * Jira: V2-8418
     */
    private static Integration_Log__c sendWithRetry(Public_Enquiry__c e) {
        String payload = buildPayload(e);
        Integration_Log__c logEntry = new Integration_Log__c(
            Direction__c = 'Outbound',
            Source_System__c = 'Salesforce CRM',
            Target_System__c = TARGET_SYSTEM,
            Operation__c = 'Notify Public Enquiry',
            Related_Record_Id__c = e.Id,
            Payload__c = payload,
            Last_Attempt_At__c = DateTime.now(),
            Attempt_Count__c = 0
        );

        Integer attempt = 0;
        Boolean success = false;
        String response = null;
        String errorMessage = null;

        while (attempt < MAX_ATTEMPTS && !success) {
            attempt++;
            try {
                Http http = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint(ENDPOINT);
                req.setMethod('POST');
                req.setHeader('Content-Type', 'application/json');
                req.setBody(payload);
                req.setTimeout(10000);

                HttpResponse resp = http.send(req);
                response = resp.getBody();

                if (resp.getStatusCode() >= 200 && resp.getStatusCode() < 300) {
                    success = true;
                } else {
                    errorMessage = 'HTTP ' + resp.getStatusCode() + ': ' + resp.getStatus();
                }
            } catch (Exception ex) {
                errorMessage = ex.getTypeName() + ': ' + ex.getMessage();
            }
        }

        logEntry.Attempt_Count__c = attempt;
        logEntry.Response__c = response;
        logEntry.Error_Message__c = errorMessage;
        logEntry.Status__c = success ? 'Success' : 'Failure';
        logEntry.Last_Attempt_At__c = DateTime.now();
        return logEntry;
    }

    /**
     * Builds the JSON envelope sent to the external system.
     * Jira: V2-8418
     */
    private static String buildPayload(Public_Enquiry__c e) {
        Map<String, Object> body = new Map<String, Object>{
            'enquiryId' => e.Id,
            'enquiryNumber' => e.Name,
            'idempotencyKey' => e.Idempotency_Key__c,
            'enquirer' => new Map<String, String>{
                'email' => e.Enquirer_Email__c,
                'country' => e.Country__c
            },
            'programme' => new Map<String, String>{
                'level' => e.Programme_Level__c,
                'interest' => e.Programme_Of_Interest__c
            },
            'submittedAt' => DateTime.now()
        };
        return JSON.serializePretty(body);
    }
}
