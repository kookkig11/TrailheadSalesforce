
/**
 * @name OrderExtension
 * @description This class is provided for you to facilitate the Super Badge
**/
public class OrderExtension {

    public Order orderRecord {get;set;}
    public List<OrderItem> orderItemList {get;set;}
    public String selectedFamily {get;set;}
    public List<chartHelper.chartData> pieData {get;set;}
    public Decimal total {get;set;}

    public Map<Id,OrderItem> orderItemMap;
    ApexPages.StandardSetController standardSetController;

    public OrderExtension(ApexPages.StandardController standardController){
        orderRecord = (Order)standardController.getRecord();
        orderItemMap = new Map<id,OrderItem>();
        if ( orderRecord.Id != null ){
            orderRecord = queryOrderRecord(orderRecord.Id);
            if(orderRecord.OrderItems.size()>0){
                for(OrderItem ordItem: orderRecord.OrderItems){
                    orderItemMap.put(ordItem.Product2Id, ordItem);
                }
            }
        }

        getPbEntries();
        OnFieldChange();
    }

    //ToDo: Implement your own method to populate orderItemList
    //  that you will call after pagination and/or family selection
    public void getPbEntries(){
        String query = 'SELECT Name, Id, Pricebook2Id, Product2Id, UnitPrice, Product2.Name,Product2.Quantity_Remaining__c, Product2.Family FROM PricebookEntry WHERE isActive= true';
        if (String.isNotBlank(selectedFamily) && selectedFamily != Constants.SELECT_ONE ) {
            query += ' AND Product2.Family = \''+ selectedFamily + '\'';
        }


        standardSetController = new ApexPages.StandardSetController(Database.getQueryLocator(query));
        standardSetController.setPageSize(Constants.DEFAULT_ROWS);

        getOrderItem();
    }

    public void getOrderItem(){
        orderItemList = new List<OrderItem>();
        for (PricebookEntry pbentry : (List<PricebookEntry>) standardSetController.getRecords()) {
            if(orderItemMap.containsKey(pbentry.product2Id)) {
                orderItemList.add(orderItemMap.get(pbentry.product2Id));
            } else{
                OrderItem ordItem = new OrderItem();
                ordItem.Product2Id = pbentry.Product2Id;
                ordItem.PricebookEntryId = pbentry.Id;
                ordItem.UnitPrice = pbentry.UnitPrice;
                ordItem.Product2 = pbentry.Product2;
                ordItem.Quantity = 0;

                orderItemList.add(ordItem);
                orderItemMap.put(pbentry.Product2Id, ordItem);
            }
        }
    }

    /**
     * @name OnFieldChange
     * @description
    **/
    public void OnFieldChange(){

        for(OrderItem item : orderItemList){
            orderItemMap.put(item.Product2Id, item);
        }

        this.total = 0;
        pieData = new List<ChartHelper.ChartData>();
        for(OrderItem item : orderItemMap.values()) {
            if(item.Quantity > 0){
                pieData.add(new ChartHelper.ChartData(item.Product2.Name, (item.UnitPrice * item.Quantity)));
                total = total + (item.UnitPrice*item.Quantity);
            }
        }

    }

    /**
     * @name SelectFamily
     * @description
    **/
    public void SelectFamily(){
        getPbEntries();
        OnFieldChange();
    }

    /**
     * @name Save
     * @description
    **/
    public void Save(){
        //ToDo: Implement logic to save the Order and populated OrderItems
        System.SavePoint sp = Database.setSavepoint();

        try{
            if(orderRecord.Pricebook2Id == null){
                orderRecord.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            }

            upsert orderRecord;

            List<OrderItem> ordToUpsert = new List<OrderItem>();
            List<OrderItem> ordToDelete = new List<OrderItem>();
            for(OrderItem ordItem: orderItemMap.values()){
                if(ordItem.Quantity > 0){
                    if(ordItem.OrderId == null) {
                        ordItem.OrderId = orderRecord.Id;
                    }
                    ordToUpsert.add(ordItem);
                }else{
                    if(ordItem.Id != null){
                        ordToDelete.add(ordItem);
                    }
                }
            }

            if(ordToUpsert.size() > 0){
                upsert ordToUpsert;
            }

            if(ordToDelete.size() > 0){
                delete ordToDelete;
            }

        }catch(Exception e){
            System.debug(e.getMessage());
            Database.rollback(sp);
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,Constants.ERROR_MESSAGE));
        }
        
        

    }


    /**
     * @name First
     * @description
    **/
    public void First(){
        standardSetController.first();
        getOrderItem();
    }


    /**
     * @name Next
     * @description
    **/
    public void Next(){
        standardSetController.next();
        getOrderItem();
    }


    /**
     * @name Previous
     * @description
    **/
    public void Previous(){
        standardSetController.previous();
        getOrderItem();
    }

    /**
     * @name Last
     * @description
    **/
    public void Last(){
        standardSetController.last();
        getOrderItem();
    }

    /**
     * @name GetHasPrevious
     * @description
    **/
    public Boolean GetHasPrevious(){
        return standardSetController.GetHasPrevious();
    }

    /**
     * @name GetHasNext
     * @description
    **/
    public Boolean GetHasNext(){
        return standardSetController.GetHasNext();
    }

    /**
     * @name GetTotalPages
     * @description
    **/
    public Integer GetTotalPages(){
        return (Integer)math.ceil(standardSetController.getResultSize()/(Decimal)Constants.DEFAULT_ROWS);
    }

    /**
     * @name GetPageNumber
     * @description
    **/
    public Integer GetPageNumber(){
        return standardSetController.getPageNumber();
    }

    /**
     * @name GetFamilyOptions
     * @description
    **/
    public List<SelectOption> GetFamilyOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Constants.SELECT_ONE,Constants.SELECT_ONE));
        for (Schema.PicklistEntry entry : Constants.PRODUCT_FAMILY) {
            options.add(new SelectOption(entry.getLabel(), entry.getValue()));
        }
        return options;
    }

    /**
     * @name QueryOrderRecord
     * @description
    **/
    public static Order QueryOrderRecord(Id orderId){
        return [
            SELECT Id, AccountId, EffectiveDate, Name, Status, Pricebook2Id,
                (
                    SELECT Id, OrderId, Quantity, UnitPrice, PricebookEntryId, Product2Id,
                         Product2.Name, Product2.Family, Product2.Quantity_Remaining__c
                    FROM OrderItems
                )
            FROM Order
            WHERE Id = :orderId
        ];
    }

}