public with sharing class WarehouseCalloutService {
    public static void WarehouseCalloutService() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-superbadge-apex.herokuapp.com/equipment?_ga=2.176356197.1571974749.1639408598-1398714461.1634652208');
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200){
            List<Product2> newEquipment = new list<Product2>(); //starts an empty list for the new equipment to be updated 

            List<Object> listEquipment = (List<Object>) JSON.deserializeUntyped(response.getBody()); //sets the callout data to a list
            
            for(Object e: listEquipment){// for each object in the listEquipment
                Map<String,Object> mapE = (Map<String,Object>)e; //sets the object equal to a map 

                //creates a new product sObject and adds the paramaters from the JSON object to the sObject
                Product2 newEquip = new Product2( replacement_part__c=(Boolean)mapE.get('replacement'), Current_Inventory__c=(decimal)mapE.get('quantity'), 
                                    Name=(string)mapE.get('name'), Maintenance_Cycle__c=(decimal)mapE.get('maintenanceperiod'), 
                                    Lifespan_Months__c=(decimal)mapE.get('lifespan'), Cost__c=(decimal)mapE.get('cost'), Warehouse_SKU__c=(string)mapE.get('sku'));

                newEquipment.add(newEquip); // adds the new equipment to the list 
            }

            upsert newEquipment; //updates the equipment list to the org

        }
    }
}
