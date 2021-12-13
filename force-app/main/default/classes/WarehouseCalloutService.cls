public with sharing class WarehouseCalloutService {
    public static void WarehouseCalloutService() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-superbadge-apex.herokuapp.com/equipment?_ga=2.176356197.1571974749.1639408598-1398714461.1634652208');
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200){
            List<Product2> newEquipment = new list<Product2>();

            System.debug(JSON.deserializeUntyped(response.getBody()));
            List<Object> listEquipment = (List<Object>) JSON.deserializeUntyped(response.getBody());
            System.debug('equipment: ' + listEquipment);
            // Map<String,Object> mapEquipment = new Map<String,Object>();
            
            for(Object e: listEquipment){
                Map<String,Object> mapE = (Map<String,Object>)e;
                System.debug('map e: ' + mapE.get('_id'));
                Product2 newEquip = new Product2( replacement_part__c=(Boolean)mapE.get('replacement'), Current_Inventory__c=(decimal)mapE.get('quantity'), 
                                    Name=(string)mapE.get('name'), Maintenance_Cycle__c=(decimal)mapE.get('maintenanceperiod'), 
                                    Lifespan_Months__c=(decimal)mapE.get('lifespan'), Cost__c=(decimal)mapE.get('cost'), Warehouse_SKU__c=(string)mapE.get('sku'));

                newEquipment.add(newEquip);    
            }

            upsert newEquipment;

        }
    }
}
