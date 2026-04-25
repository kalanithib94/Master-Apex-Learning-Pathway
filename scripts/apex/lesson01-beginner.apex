// 1. Declare one variable of each type

Integer intNum = 6;
Long longNum = 979797999L;
Double doubleNum = 3.808;
Decimal decimalNum = 2.99;
String text = 'Text';
Boolean boolVal = true;
Date todayDate = Date.today();
Datetime currentDateTime = Datetime.now();
Time currentTime = Time.newInstance(14, 45, 30, 0);
Id accountId = '001345678998765AAA'; // valid 18-char Id


// 2. Perform operations

// Integer: Add two integers
Integer a = 10, b = 12;
Integer intSum = a + b;

// Decimal: Calculate 15% tax on 1200.50
Decimal amount = 1200.50;
Decimal tax = amount * 15 / 100;

// Double: Multiply two doubles
Double d1 = 3.24, d2 = 6.77;
Double doubleResult = d1 * d2;

// String: Combine first and last name
String firstName = 'Master';
String lastName = 'Blaster';
String fullName = firstName + ' ' + lastName;

// Boolean: Check if number > 100
Integer checkNum = 150;
Boolean isGreaterThan100 = checkNum > 100;

// Date: Add 30 days to today
Date futureDate = Date.today().addDays(30);

// Datetime: Current datetime
Datetime nowDT = Datetime.now();


// 3. Print each result

System.debug('Integer: ' + intNum);
System.debug('Long: ' + longNum);
System.debug('Double: ' + doubleNum);
System.debug('Decimal: ' + decimalNum);
System.debug('String: ' + text);
System.debug('Boolean: ' + boolVal);
System.debug('Date: ' + todayDate);
System.debug('Datetime: ' + currentDateTime);
System.debug('Time: ' + currentTime);
System.debug('Id: ' + accountId);

System.debug('Integer Sum: ' + intSum);
System.debug('Tax (15%): ' + tax);
System.debug('Double Multiplication: ' + doubleResult);
System.debug('Full Name: ' + fullName);
System.debug('Is > 100: ' + isGreaterThan100);
System.debug('Future Date (+30 days): ' + futureDate);
System.debug('Current Datetime: ' + nowDT);


// 4. Constant using final

final Integer CONST_VALUE = 10;
Integer result = CONST_VALUE * 5;

System.debug('Constant Calculation: ' + result);
