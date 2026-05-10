/**
 * Apex controller exposed to the public Enquiry LWC form.
 *
 * Single @AuraEnabled entry point: submitEnquiry. The LWC builds a Map of
 * field values (no SObject sent over the wire from guest users) and the
 * controller materializes the Public_Enquiry__c record. The trigger handles
 * the rest — dedup, idempotency rejection, integration log, outbound callout,
 * email acknowledgement.
 */
public with sharing class PublicEnquiryController {

    /**
     * Result envelope returned to the LWC. `success=false` means we have a
     * user-friendly error message to display; `success=true` carries the
     * generated enquiry number.
     */
    public class EnquiryResult {
        @AuraEnabled public Boolean success;
        @AuraEnabled public String enquiryNumber;
        @AuraEnabled public String enquiryId;
        @AuraEnabled public String errorMessage;
    }

    /**
     * Inserts a Public_Enquiry__c from form input. Returns a friendly
     * EnquiryResult envelope; never throws to the LWC.
     * Jira: V2-8418
     */
    @AuraEnabled
    public static EnquiryResult submitEnquiry(Map<String, Object> formData) {
        EnquiryResult result = new EnquiryResult();
        try {
            Public_Enquiry__c e = new Public_Enquiry__c(
                Enquirer_Name__c = (String) formData.get('enquirerName'),
                Enquirer_Email__c = (String) formData.get('enquirerEmail'),
                Enquirer_Phone__c = (String) formData.get('enquirerPhone'),
                Country__c = (String) formData.get('country'),
                Country_Other__c = (String) formData.get('countryOther'),
                Programme_Level__c = (String) formData.get('programmeLevel'),
                Programme_Of_Interest__c = (String) formData.get('programmeOfInterest'),
                Consent_Given__c = (Boolean) formData.get('consentGiven'),
                Lawful_Basis__c = 'Consent',
                Idempotency_Key__c = (String) formData.get('idempotencyKey'),
                Status__c = 'New'
            );

            insert e;

            Public_Enquiry__c saved = [
                SELECT Id, Name FROM Public_Enquiry__c WHERE Id = :e.Id LIMIT 1
            ];
            result.success = true;
            result.enquiryId = saved.Id;
            result.enquiryNumber = saved.Name;
        } catch (DmlException dex) {
            result.success = false;
            result.errorMessage = dex.getDmlMessage(0) != null ? dex.getDmlMessage(0) : dex.getMessage();
        } catch (Exception ex) {
            result.success = false;
            result.errorMessage = 'We could not submit your enquiry just now. Please try again in a moment.';
        }
        return result;
    }
}
