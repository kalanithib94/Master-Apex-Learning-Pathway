trigger PublicEnquiryTrigger on Public_Enquiry__c (before insert, after insert) {
    if (Trigger.isBefore && Trigger.isInsert) {
        PublicEnquiryTriggerHandler.handleBeforeInsert(Trigger.new);
    } else if (Trigger.isAfter && Trigger.isInsert) {
        PublicEnquiryTriggerHandler.handleAfterInsert(Trigger.new);
    }
}
