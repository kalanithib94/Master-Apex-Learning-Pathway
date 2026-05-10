// Comprehensive scenario test for the Public_Enquiry__c pipeline
// Demonstrates: UK routing, EU routing, International routing, idempotency reject,
// fuzzy match flag, validation rule firing
String stamp = String.valueOf(DateTime.now().getTime());
List<String> results = new List<String>();

// SCENARIO 1: UK enquirer (fresh) - should route to Admissions UK
try {
    Public_Enquiry__c uk = new Public_Enquiry__c(
        Enquirer_Name__c = 'UK Student',
        Enquirer_Email__c = 'uk.' + stamp + '@example.co.uk',
        Country__c = 'UK',
        Programme_Level__c = 'UG',
        Programme_Of_Interest__c = 'Engineering',
        Consent_Given__c = true,
        Lawful_Basis__c = 'Consent',
        Idempotency_Key__c = 'uk-' + stamp,
        Status__c = 'New'
    );
    insert uk;
    Public_Enquiry__c saved = [SELECT Name, Owner.Name FROM Public_Enquiry__c WHERE Id = :uk.Id];
    results.add('SCENARIO 1 UK routing → ' + saved.Name + ' owned by: ' + saved.Owner.Name);
} catch (Exception e) {
    results.add('SCENARIO 1 FAILED: ' + e.getMessage());
}

// SCENARIO 2: EU enquirer (Republic of Ireland) - should route to Admissions EU
try {
    Public_Enquiry__c eu = new Public_Enquiry__c(
        Enquirer_Name__c = 'Irish Student',
        Enquirer_Email__c = 'ie.' + stamp + '@example.ie',
        Country__c = 'Republic of Ireland',
        Programme_Level__c = 'PG',
        Programme_Of_Interest__c = 'Business',
        Consent_Given__c = true,
        Lawful_Basis__c = 'Consent',
        Idempotency_Key__c = 'ie-' + stamp,
        Status__c = 'New'
    );
    insert eu;
    Public_Enquiry__c saved = [SELECT Name, Owner.Name FROM Public_Enquiry__c WHERE Id = :eu.Id];
    results.add('SCENARIO 2 EU routing → ' + saved.Name + ' owned by: ' + saved.Owner.Name);
} catch (Exception e) {
    results.add('SCENARIO 2 FAILED: ' + e.getMessage());
}

// SCENARIO 3: International (India) - should route to Admissions International
try {
    Public_Enquiry__c intl = new Public_Enquiry__c(
        Enquirer_Name__c = 'India Student',
        Enquirer_Email__c = 'in.' + stamp + '@example.in',
        Country__c = 'India',
        Programme_Level__c = 'PG',
        Programme_Of_Interest__c = 'Sciences',
        Consent_Given__c = true,
        Lawful_Basis__c = 'Consent',
        Idempotency_Key__c = 'in-' + stamp,
        Status__c = 'New'
    );
    insert intl;
    Public_Enquiry__c saved = [SELECT Name, Owner.Name FROM Public_Enquiry__c WHERE Id = :intl.Id];
    results.add('SCENARIO 3 International routing → ' + saved.Name + ' owned by: ' + saved.Owner.Name);
} catch (Exception e) {
    results.add('SCENARIO 3 FAILED: ' + e.getMessage());
}

// SCENARIO 4: Idempotency collision - retry of the UK submission, must reject
try {
    Public_Enquiry__c retry = new Public_Enquiry__c(
        Enquirer_Name__c = 'UK Student',
        Enquirer_Email__c = 'uk.' + stamp + '@example.co.uk',
        Country__c = 'UK',
        Programme_Level__c = 'UG',
        Programme_Of_Interest__c = 'Engineering',
        Consent_Given__c = true,
        Lawful_Basis__c = 'Consent',
        Idempotency_Key__c = 'uk-' + stamp,
        Status__c = 'New'
    );
    Database.SaveResult sr = Database.insert(retry, false);
    if (sr.isSuccess()) {
        results.add('SCENARIO 4 UNEXPECTED SUCCESS - dedup did not fire');
    } else {
        results.add('SCENARIO 4 Idempotency reject ✓ → ' + sr.getErrors()[0].getMessage());
    }
} catch (Exception e) {
    results.add('SCENARIO 4 caught: ' + e.getMessage());
}

// SCENARIO 5: Fuzzy match - same email + programme, different idempotency key, within 30 days
try {
    Public_Enquiry__c reAsk = new Public_Enquiry__c(
        Enquirer_Name__c = 'UK Student again',
        Enquirer_Email__c = 'uk.' + stamp + '@example.co.uk',
        Country__c = 'UK',
        Programme_Level__c = 'UG',
        Programme_Of_Interest__c = 'Engineering',
        Consent_Given__c = true,
        Lawful_Basis__c = 'Consent',
        Idempotency_Key__c = 'uk-reask-' + stamp,
        Status__c = 'New'
    );
    insert reAsk;
    Public_Enquiry__c saved = [SELECT Name, Is_Duplicate__c, Related_Enquiry__c FROM Public_Enquiry__c WHERE Id = :reAsk.Id];
    results.add('SCENARIO 5 Fuzzy match → ' + saved.Name + ' Is_Duplicate=' + saved.Is_Duplicate__c + ' linked=' + (saved.Related_Enquiry__c != null));
} catch (Exception e) {
    results.add('SCENARIO 5 FAILED: ' + e.getMessage());
}

// SCENARIO 6: Validation rule (no consent) - must reject
try {
    Public_Enquiry__c noConsent = new Public_Enquiry__c(
        Enquirer_Name__c = 'No Consent',
        Enquirer_Email__c = 'noconsent.' + stamp + '@example.com',
        Country__c = 'UK',
        Programme_Level__c = 'UG',
        Programme_Of_Interest__c = 'Engineering',
        Consent_Given__c = false,
        Idempotency_Key__c = 'noconsent-' + stamp,
        Status__c = 'New'
    );
    Database.SaveResult sr = Database.insert(noConsent, false);
    if (sr.isSuccess()) {
        results.add('SCENARIO 6 UNEXPECTED SUCCESS - VR did not fire');
    } else {
        results.add('SCENARIO 6 No-consent VR ✓ → ' + sr.getErrors()[0].getMessage());
    }
} catch (Exception e) {
    results.add('SCENARIO 6 caught: ' + e.getMessage());
}

System.debug('===========================================');
System.debug('SCENARIO TEST RESULTS');
System.debug('===========================================');
for (String r : results) {
    System.debug('| ' + r);
}
System.debug('===========================================');
