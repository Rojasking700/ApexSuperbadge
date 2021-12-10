public with sharing class MaintenanceRequestHelper {
    public static void UpdateMaintenanceRequest(List<Case> triggerNew) {

        Map <Id, Case> mapCases = new Map<Id,Case>(); // place holder for all the cases with status closed and type repair or maintenance

        for (case a : triggerNew){ //for each new case handled by the tirgger
            Decimal cycleDays = null; // place holder for the least lifecylce days 

            // if the status is closed and the type is repair or routine maintenance
            if (a.status == 'Closed' && (a.type =='Repair' || a.type == 'Routine Maintenance')){ 
                mapCases.put(a.id, a); //adds them to the map 
            }
        }

        if (!mapCases.isEmpty()){ //if the map is not empty
            newMaintenanceRequests(mapCases); //this function creates the new cases and pases in the map of cases
        }
    }

//************************************************************************************************************************************************************************************************* */

    private static void newMaintenanceRequests(Map<Id,Case> mapCases){

        List <Case> newCases = new List<Case>(); //place holder for the new cases to be made

        //list of equipment items that are related to triggers 
        List <Equipment_Maintenance_Item__c> listEquipment = [SELECT id, Maintenance_Request__c, Equipment__r.Maintenance_Cycle__c, Quantity__c 
                                                            FROM Equipment_Maintenance_item__c WHERE Maintenance_Request__c = :mapCases.keySet()];
        
        //map place holder for all the equipment items that will be associted with the new cases
        //the map consists of lists of equipment items that relate to one case 
        Map<Integer,List<Equipment_Maintenance_Item__c>> mapNewEquip = new Map<Integer,List<Equipment_Maintenance_Item__c>>();
        Integer i = 0; //this will keep track of the position of each list in the map

        for(Id key: mapCases.keySet()){ //for each id in the key set 
            Case a = mapCases.get(key); // retrieves the case sObject
            Decimal cycleDays = null; // place holder for cycle days 
            System.debug('routine maintenance current status: ' + a.status);
            
            //list place holder for all the equipment the will be a part of the new cases
            List<Equipment_Maintenance_Item__c> emiList = new List<Equipment_Maintenance_Item__c>();

            for (Equipment_maintenance_Item__c emi: listEquipment){// for each record in the listEquipment
                if (a.id == emi.Maintenance_Request__c){ //if the ids match 
                    if(cycleDays == null){ // if the lifecycle is null
                        cycleDays = emi.Equipment__r.Maintenance_Cycle__c; //the cycle will be set to the first cylce 
                        
                    }else if(emi.Equipment__r.Maintenance_Cycle__c < CycleDays){ //if the cycle is less than the previous cylce^^
                        cycleDays = emi.Equipment__r.Maintenance_Cycle__c; //it will update the cycle days to the least amount of days
                    }

                    emiList.add(emi); //adds the equipment item to a list 
                }
            }
            mapNewEquip.put(i,emiList); //adds the the list of equipment items to the map 
            i++; //adds one to the counter 
            //creates new case and carries over parameters from the previous case
            Case newCase = new Case(account=a.Account, contact=a.Contact, type='Routine Maintenance', status='New', origin='Web',
                                    subject='Needs routine maintenance', Vehicle__c= a.Vehicle__c, 
                                    Date_Due__c=System.TODAY()+Integer.valueOf(CycleDays), Date_Reported__c=System.TODAY());
            newCases.add(newCase);// adds the new case to the list 
            
        }
        
        upsert newCases; //upserts the new cases
        
        //this function updates all the previous case equipment items to the new case
        newCasesNewEquipItems(newCases,i, mapNewEquip);
    }

//************************************************************************************************************************************************************************************************* */

    //Parameters: list of new cases, I is the amount of map items, the map consists of lists of equipment items that will be translated to the new case
    private static void newCasesNewEquipItems(List<Case> newCases, Integer I, Map<Integer,List<Equipment_Maintenance_Item__c>> mapNewEquip){

        //list place holder for all the equipment the will be a part of the new cases
        List<Equipment_Maintenance_Item__c> emiList = new List<Equipment_Maintenance_Item__c>();

        for (Integer J=0; J<I; J++){ //for each items in the map 
            List<Equipment_Maintenance_Item__c> Equip = mapNewEquip.get(J); //gets the list of equpiment items associated with a case
            Case casee = newCases[J]; //gets the case that is relevant to the map list

            for (Equipment_Maintenance_Item__c e: Equip){ // for each item in the map list
                //creates a new equipment item record that is updated with the id of the new case
                Equipment_Maintenance_Item__c newEquip = new Equipment_Maintenance_Item__c(Maintenance_Request__c=casee.id, Equipment__c=e.Equipment__c, Quantity__c=e.Quantity__c);
                emiList.add(newEquip); //adds the equipment item to the list so it can be upserted 
            }
        }
        //upserts the new equipment items assigned to the new case
        upsert emiList;        
    }

//************************************************************************************************************************************************************************************************* */
}
