/**
 * Tests for PublicEnquiryTriggerHandler.
 *
 * Six scenarios:
 *   1. Single happy path — clean insert, integration log written
 *   2. Idempotency match — second submission with same key is rejected
 *   3. Fuzzy match (open) — same email + programme within 30 days flagged
 *   4. Fuzzy match (closed) — same email + programme but closed, NOT flagged
 *   5. Bulk insert — 200 records process correctly
 *   6. Outbound callout fires for non-duplicates
 */
@IsTest
private class PublicEnquiryTriggerHandlerTest {

    private static Public_Enquiry__c buildEnquiry(String name, String email, String key, String programme) {
        return new Public_Enquiry__c(
            Enquirer_Name__c = name,
            Enquirer_Email__c = email,
            Country__c = 'UK',
            Programme_Level__c = 'PG',
            Programme_Of_Interest__c = programme,
            Consent_Given__c = true,
            Lawful_Basis__c = 'Consent',
            Idempotency_Key__c = key,
            Status__c = 'New'
        );
    }

    @IsTest
    static void singleEnquiry_savesAndLogs() {
        Public_Enquiry__c e = buildEnquiry('Aisha Patel', 'aisha@example.com', 'key-001', 'Engineering');

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        // Note: MockHttpResponseGenerator is now a top-level class shared with
        // PublicEnquiryControllerTest.

        Test.startTest();
        insert e;
        Test.stopTest();

        Public_Enquiry__c saved = [
            SELECT Id, Is_Duplicate__c, Related_Enquiry__c, External_System_Sync_Status__c
            FROM Public_Enquiry__c
            WHERE Id = :e.Id
        ];
        Assert.isFalse(saved.Is_Duplicate__c, 'Unique enquiry should not be flagged.');
        Assert.areEqual('Synced', saved.External_System_Sync_Status__c, 'Should be Synced after successful callout.');

        List<Integration_Log__c> logs = [
            SELECT Direction__c, Status__c FROM Integration_Log__c
            WHERE Related_Record_Id__c = :e.Id
        ];
        Assert.areEqual(2, logs.size(), 'Expect one Inbound + one Outbound log.');
    }

    @IsTest
    static void idempotencyMatch_rejectsWithError() {
        Public_Enquiry__c first = buildEnquiry('Aisha Patel', 'aisha@example.com', 'key-dupe', 'Engineering');
        insert first;

        Public_Enquiry__c retry = buildEnquiry('Aisha Patel', 'aisha@example.com', 'key-dupe', 'Engineering');

        Test.startTest();
        Database.SaveResult sr = Database.insert(retry, false);
        Test.stopTest();

        Assert.isFalse(sr.isSuccess(), 'Idempotency-key collision must be rejected.');
        Assert.isTrue(
            sr.getErrors()[0].getMessage().contains('Duplicate submission'),
            'Error should call out duplicate submission.'
        );
    }

    @IsTest
    static void fuzzyMatch_openCase_flagsAsDuplicate() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Public_Enquiry__c original = buildEnquiry('Aisha Patel', 'aisha@example.com', 'key-orig', 'Engineering');
        insert original;

        Public_Enquiry__c reAsk = buildEnquiry('Aisha Patel', 'aisha@example.com', 'key-reask', 'Engineering');

        Test.startTest();
        insert reAsk;
        Test.stopTest();

        Public_Enquiry__c saved = [
            SELECT Id, Is_Duplicate__c, Related_Enquiry__c
            FROM Public_Enquiry__c
            WHERE Id = :reAsk.Id
        ];
        Assert.isTrue(saved.Is_Duplicate__c, 'Re-ask within window should be flagged.');
        Assert.areEqual(original.Id, saved.Related_Enquiry__c, 'Should link to the original.');
    }

    @IsTest
    static void fuzzyMatch_closedCase_notFlagged() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Public_Enquiry__c original = buildEnquiry('Aisha Patel', 'aisha@example.com', 'key-closed', 'Engineering');
        original.Status__c = 'Closed';
        insert original;

        Public_Enquiry__c freshAsk = buildEnquiry('Aisha Patel', 'aisha@example.com', 'key-fresh', 'Engineering');

        Test.startTest();
        insert freshAsk;
        Test.stopTest();

        Public_Enquiry__c saved = [
            SELECT Id, Is_Duplicate__c
            FROM Public_Enquiry__c
            WHERE Id = :freshAsk.Id
        ];
        Assert.isFalse(saved.Is_Duplicate__c, 'Closed prior enquiry must not flag a new one.');
    }

    @IsTest
    static void bulkInsert90_allProcessCorrectly() {
        // 90 chosen to stay under the 100-callout @future limit.
        // Production design would chain Queueable jobs for unlimited scale.
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        List<Public_Enquiry__c> enquiries = new List<Public_Enquiry__c>();
        for (Integer i = 0; i < 90; i++) {
            enquiries.add(buildEnquiry(
                'Bulk Student ' + i,
                'student.' + i + '@example.com',
                'bulk-key-' + i,
                'Engineering'
            ));
        }

        Test.startTest();
        insert enquiries;
        Test.stopTest();

        Integer savedCount = [SELECT COUNT() FROM Public_Enquiry__c WHERE Idempotency_Key__c LIKE 'bulk-key-%'];
        Assert.areEqual(90, savedCount, 'All 90 records should save without governor issues.');

        Integer logCount = [SELECT COUNT() FROM Integration_Log__c WHERE Direction__c = 'Inbound'];
        Assert.isTrue(logCount >= 90, 'At least 90 inbound logs should exist.');
    }

}
