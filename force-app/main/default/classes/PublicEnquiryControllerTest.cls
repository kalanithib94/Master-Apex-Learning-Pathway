/**
 * Tests for PublicEnquiryController.
 */
@IsTest
private class PublicEnquiryControllerTest {

    private static Map<String, Object> buildForm(String email, String key, Boolean consent) {
        return new Map<String, Object>{
            'enquirerName' => 'LWC Test User',
            'enquirerEmail' => email,
            'enquirerPhone' => '+447700900000',
            'country' => 'UK',
            'programmeLevel' => 'PG',
            'programmeOfInterest' => 'Engineering',
            'consentGiven' => consent,
            'idempotencyKey' => key
        };
    }

    @IsTest
    static void submitEnquiry_validForm_returnsSuccess() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Map<String, Object> form = buildForm('lwc@example.com', 'lwc-test-1', true);

        Test.startTest();
        PublicEnquiryController.EnquiryResult res = PublicEnquiryController.submitEnquiry(form);
        Test.stopTest();

        Assert.isTrue(res.success, 'Valid form should succeed.');
        Assert.isNotNull(res.enquiryId, 'Enquiry Id should be returned.');
        Assert.isNotNull(res.enquiryNumber, 'Enquiry Number should be returned.');
    }

    @IsTest
    static void submitEnquiry_missingConsent_returnsError() {
        Map<String, Object> form = buildForm('noconsent@example.com', 'lwc-test-2', false);

        Test.startTest();
        PublicEnquiryController.EnquiryResult res = PublicEnquiryController.submitEnquiry(form);
        Test.stopTest();

        Assert.isFalse(res.success, 'Missing consent must fail.');
        Assert.isNotNull(res.errorMessage, 'Error message should be present.');
    }

    @IsTest
    static void submitEnquiry_idempotencyCollision_returnsError() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Map<String, Object> first = buildForm('dupe@example.com', 'lwc-test-collide', true);
        PublicEnquiryController.submitEnquiry(first);

        Map<String, Object> retry = buildForm('dupe@example.com', 'lwc-test-collide', true);

        Test.startTest();
        PublicEnquiryController.EnquiryResult res = PublicEnquiryController.submitEnquiry(retry);
        Test.stopTest();

        Assert.isFalse(res.success, 'Second submission with same idempotency key must fail.');
        Assert.isTrue(
            res.errorMessage.toLowerCase().contains('duplicate'),
            'Error message should call out duplicate. Got: ' + res.errorMessage
        );
    }
}
