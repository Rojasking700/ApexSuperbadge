// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents
/*******Default********************************************* */
string tempvar = 'Enter_your_name_here';
System.debug('Hello World!');
System.debug('My name is ' + tempvar);
/********MiantenanceRequestHelper test******************************************** */
List<Case> newTestCases = new List<Case>();
List<Case> testCases = [SELECT id FROM Case WHERE Status!='Closed' AND (Type='Repair' OR Type='Routine Maintenance')];
for(Case a: testCases){
    case b = new Case(id=a.id,status='Closed');
    newTestCases.add(b);
}
upsert(newTestCases);
/*******MiantenanceRequestHelper test********************************************************* */
List<Case> newTestCases = new List<Case>();
case a = new Case(id='5005f000001qJQhAAM',status='Closed');
case b = new Case(id='5005f000001qJQgAAM',status='Closed');
newTestCases.add(a);
newTestCases.add(b);
upsert(newTestCases);
/********WarehouseCalloutService test******************************************************** */
WarehouseCalloutService.WarehouseCalloutService();
/**************************************************************** */