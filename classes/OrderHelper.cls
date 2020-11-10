public without sharing class OrderHelper {

    /**
     * @name AfterUpdate
     * @description 
     * @param List<Order> newList
     * @param List<Order> oldList
     * @return void
    **/
    public static void AfterUpdate(List<Order> newList, List<Order> oldList){
        Set<Id> orderIds = new Set<Id>();
        
        for ( Integer i=0; i<newList.size(); i++ ){
            if ( newList[i].Status == Constants.ACTIVATED_ORDER_STATUS 
            && oldList[i].Status != Constants.ACTIVATED_ORDER_STATUS ){
                orderIds.add(newList[i].Id);
            }
        }

        if(orderIds.size() > 0){
            RollUpOrderItems(orderIds);
        }
    }

     /**
     * @name AfterInsert
     * @description 
     * @param List<Order> newList
     * @param List<Order> oldList
     * @return void
    **/
    public static void AfterInsert(List<Order> newList, List<Order> oldList){
        
    }

     /**
     * @name AfterDelete
     * @description 
     * @param List<Order> newList
     * @param List<Order> oldList
     * @return void
    **/
    public static void AfterDelete(List<Order> newList, List<Order> oldList){
        
    }

    /**
     * @name BeforeUpdate
     * @description 
     * @param List<Order> newList
     * @param List<Order> oldList
     * @return void
    **/
    public static void BeforeUpdate(List<Order> newList, List<Order> oldList){
        
    }

     /**
     * @name BeforeInsert
     * @description 
     * @param List<Order> newList
     * @param List<Order> oldList
     * @return void
    **/
    public static void BeforeInsert(List<Order> newList, List<Order> oldList){
        
    }

     /**
     * @name BeforeDelete
     * @description 
     * @param List<Order> newList
     * @param List<Order> oldList
     * @return void
    **/
    public static void BeforeDelete(List<Order> newList, List<Order> oldList){
        
    }

    /**
     * @name RollUpOrderItems
     * @description Given a set of Activated Order ids, query the child Order Items and related Products to calculate Inventory levels
     * @param Set<Id> activatedOrderIds
     * @return void
    **/
    public static void RollUpOrderItems(Set<Id> activatedOrderIds){
        List<Id> productIds = new List<Id>();

        for(OrderItem item : [Select id,quantity,Product2Id from OrderItem where orderId in :activatedOrderIds]) {
            productIds.add(item.Product2Id);
        }

        Map<Id, Product2> productMap = new Map<Id,Product2>([
            Select id, Quantity_Ordered__c from product2 where id in :productIds
        ]);

        AggregateResult[] groupedResult = [
            Select Product2Id,sum(Quantity) totalQuantity from OrderItem where product2Id in :productMap.keySet() group by product2Id
        ];
        
        for(AggregateResult result : groupedResult) {
            if(productMap.containsKey((String)result.get('Product2Id'))) {
                Product2  p = productMap.get((String)result.get('Product2Id'));
                p.Quantity_Ordered__c = Integer.valueOf(result.get('totalQuantity'));
                productMap.put(p.Id, p);
            }
        }

        if(!productMap.isEmpty()){
            update productMap.values();
        }
        
    }

}