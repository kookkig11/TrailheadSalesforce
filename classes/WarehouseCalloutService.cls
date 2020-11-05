public with sharing class WarehouseCalloutService {
    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';

    public class Equipment {
        public String eqId;
        public Boolean replacement;
        public Integer quantity;
        public String name;
        public Integer maintenancePeriod;
        public Integer lifespan;
        public Integer cost;
        public String sku;    
    }
    
    @future(callout=true)
    public static void runWarehouseEquipmentSync() {
        //ToDo: complete this method to make the callout (using @future) to the
        //      'REST endpoint' and update equipment on hand.
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(WAREHOUSE_URL);
        req.setMethod('GET');   // pull data
        // {"_id":"55d66226726b611100aaf740","replacement":true,"quantity":194,"name":"Fuse 8A","maintenanceperiod":0,"lifespan":0,"cost":5,"sku":"100002"}
        
        HttpResponse res = http.send(req);
        if (res.getStatusCode() == 200) {
            String JSONbody = res.getBody();
            String JSONContent = JSONbody.replaceAll('_id', 'eqId');
            List<Equipment> result = (List<Equipment>) JSON.deserialize(JSONContent, List<Equipment>.class);
            
            // Equipment to be Serviced >> releated to Product2
            List<Product2> productList = new List<Product2>();
            for (Equipment i : result) {
                System.debug(i);
                Product2 product = new Product2(ProductCode = i.eqId,
                                                Name = i.name,
                                                Maintenance_Cycle__c = i.maintenanceperiod,
                                                Cost__c = i.cost,
                                                Current_Inventory__c = i.quantity,
                                                Lifespan_Months__c = i.lifespan,
                                                Replacement_Part__c = i.replacement,
                                                Warehouse_SKU__c = i.sku);
                productList.add(product);
            }
            System.debug(productList);

            if (productList.size() > 0){
                upsert productList Warehouse_SKU__c;
            }
            
        }
    }
}

/*
List<Object> result = (List<Object>) JSON.deserializeUntyped(res.getBody());
            
// Equipment to be Serviced >> releated to Product2
List<Product2> productList = new List<Product2>();
for (Object i : result) {
    Map<String, Object> mapProduct = (Map<String, Object>) i;
    Product2 product = new Product2(ProductCode = (String)mapProduct.get('_id'),
                                    Name = (String)mapProduct.get('name'),
                                    Maintenance_Cycle__c = (Integer)mapProduct.get('maintenanceperiod'),
                                    Cost__c = (Integer)mapProduct.get('cost'),
                                    Current_Inventory__c = (Integer)mapProduct.get('quantity'),
                                    Lifespan_Months__c = (Integer)mapProduct.get('lifespan'),
                                    Replacement_Part__c = (Boolean)mapProduct.get('replacement'),
                                    Warehouse_SKU__c = (String)mapProduct.get('sku'));
    productList.add(product);
}
System.debug(productList);
*/