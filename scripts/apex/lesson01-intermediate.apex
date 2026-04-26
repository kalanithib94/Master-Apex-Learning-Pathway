// Requirement 1: String manipulation on rawInput

String rawInput = '  John Michael Doe  ';
String trimmedOutput = rawInput.trim();
System.debug('The Trimmed Output is: ' + trimmedOutput);

String upperCaseOutput = rawInput.toUpperCase();
System.debug('The Upper Cased Output is: ' + upperCaseOutput);

String lowerCaseOutput = rawInput.toLowerCase();
System.debug('The Lower Cased Output is: ' + lowerCaseOutput);

Integer lengthOfRawInput = rawInput.length();
System.debug('The Length of Raw Input is: ' + lengthOfRawInput);

Boolean rawInputContainsMichael = rawInput.contains('Michael');
System.debug('Raw Input Contains Michael? ' + rawInputContainsMichael);

Integer spacePosition = trimmedOutput.indexOf(' ');
String firstName = trimmedOutput.substring(0, spacePosition);
System.debug('First name from Raw Input: ' + firstName);


// Requirement 2: Email processing

String email = 'John.Doe@Example.COM';
String lowerCaseEmail = email.toLowerCase();

Boolean emailContainsAt = lowerCaseEmail.contains('@');
System.debug('Email contains @? ' + emailContainsAt);

Integer atPosition = lowerCaseEmail.indexOf('@');
String userName = lowerCaseEmail.substring(0, atPosition);
System.debug('UserName = ' + userName);
Integer afterAtPosition = atPosition + 1;
String domain = lowerCaseEmail.substring(afterAtPosition);
System.debug('Domain = ' + domain);


// Requirement 3: Null safety

String emptyStr = '';
String nullStr = null;

System.debug('emptyStr isBlank: ' + String.isBlank(emptyStr));
System.debug('nullStr isBlank: ' + String.isBlank(nullStr));

System.debug('emptyStr isEmpty: ' + String.isEmpty(emptyStr));

// nullStr.length() would throw a NullPointerException — you cannot call methods on null

if (nullStr != null) {
    System.debug('Length of nullStr: ' + nullStr.length());
} else {
    System.debug('null string detected');
}


// Requirement 4: String comparison

String a = 'Salesforce';
String b = 'salesforce';

System.debug('Using == : ' + (a == b));
System.debug('Using equals(): ' + a.equals(b));

System.debug('Using equalsIgnoreCase(): ' + a.equalsIgnoreCase(b));

// In Apex, == compares string values and is case-insensitive.
// equals() is case-sensitive and should be used when exact match is required.
// equalsIgnoreCase() should be used when case differences should be ignored.
