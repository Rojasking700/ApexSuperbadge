@isTest
public with sharing class MaintenanceRequestTest {

    @isTest static void MaintenanceRequestTest() {
        List<Id> ids = new List<String>{'5005f000001qJQgAAM','5005f000001qJQhAAM','5005f0000078YYyAAM','5005f0000078YYzAAM',
        '5005f0000078YZ0AAM','5005f0000078YZ1AAM','5005f0000078YZ2AAM','5005f0000078YZ3AAM','5005f0000078YZ4AAM','5005f0000078YZ5AAM',
        '5005f0000078YZ6AAM','5005f0000078YZ7AAM','5005f0000078YZ8AAM','5005f0000078YZ9AAM','5005f0000078YZAAA2'};
        List<Case> newTestCases = new List<Case>();

        for(Integer i=0; i<10; i++){
            Case newCase = new Case( Id=Id.valueOf(ids[i]) ,type='Routine Maintenance', status='Closed', origin='Web',
                                    subject='Needs routine maintenance', Vehicle__c=Id.valueOf('a025f0000054AmOAAU'), 
                                    Date_Due__c=System.TODAY(), Date_Reported__c=System.TODAY());
            newTestCases.add(newCase);
        }
        
        upsert(newTestCases);

        List<Equipment_Maintenance_Item__c> emiList = new List<Equipment_Maintenance_Item__c>();
        for(case a: newTestCases){
            Equipment_Maintenance_Item__c newEquip = new Equipment_Maintenance_Item__c(Maintenance_Request__c=a.id, Equipment__c=Id.valueOf('01t5f000000rSj8AAE'), Quantity__c=4);
            emiList.add(newEquip);
        }
        
        upsert(emiList);

        Test.startTest();
        Test.stopTest();
    }
}
//account=Id.valueOf('0015f00000EoHwHAAV'), contact=Id.valueOf('0035f00000C743eAAB'), 