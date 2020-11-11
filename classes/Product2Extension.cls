/**
 * @File Name          : Product2Extension.cls
 * @Description        : 
 * @Author             : wbatista@moldsoft.com.br
 * @Group              : 
 * @Last Modified By   : wbatista@moldsoft.com.br
 * @Last Modified On   : 01/02/2020 11:35:16
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    19/01/2020   wbatista@moldsoft.com.br     Initial Version
**/
public class Product2Extension {

    public List<ProductWrapper> productsToInsert {get;set;}

    public Product2Extension(ApexPages.StandardController controller){
        productsToInsert = new List<ProductWrapper>();
        AddRows();
    }

    public void AddRows(){
        for ( Integer i=0; i<Constants.DEFAULT_ROWS; i++ ){
            ProductWrapper prodWrapper = new ProductWrapper();
            productsToInsert.add( prodWrapper );
        }
    }

    @AuraEnabled
    public List<ChartHelper.ChartData> GetInventory(){
        return ChartHelper.GetInventory();
    }

    public  List<SelectOption> GetFamilyOptions(){
         List<SelectOption> familyOptions = new  List<SelectOption>();
         familyOptions.add(new SelectOption(Constants.SELECT_ONE, Constants.SELECT_ONE));
         
        for(Schema.PicklistEntry familyEntry: Constants.PRODUCT_FAMILY){
            familyOptions.add(new SelectOption(familyEntry.getLabel(), familyEntry.getValue()));
        }

        return familyOptions;
    }

    public PageReference Save(){
        Savepoint sp = Database.setSavepoint();
        try {
            List<Product2> prodToInsert = new List<Product2>();
            List<PriceBookEntry> pbEntriesInsert = new List<PriceBookEntry>();
            Map<Integer, Integer> mapPbIndexProducIndex = new Map<Integer, Integer>();

            for(ProductWrapper prd: productsToInsert){
                if(
                    String.isNotBlank(prd.productRecord.Name) &&
                    prd.productRecord.Family != null &&
                    prd.productRecord.isActive != null &&
                    prd.productRecord.Initial_Inventory__c != 0 &&
                    prd.pricebookEntryRecord.UnitPrice != 0.0
                ){
                    prd.pricebookEntryRecord.PriceBook2Id = Constants.STANDARD_PRICEBOOK_ID;
                    prd.pricebookEntryRecord.IsActive = true;
                    
                    pbEntriesInsert.add(prd.pricebookEntryRecord);
                    prodToInsert.add(prd.productRecord);

                    mapPbIndexProducIndex.put(pbEntriesInsert.size()-1, prodToInsert.size()-1);
                }
            }

            insert prodToInsert;
            
            for (Integer i = 0; i < pbEntriesInsert.size(); i++) {
                pbEntriesInsert[i].Product2Id = prodToInsert[mapPbIndexProducIndex.get(i)].Id;
            }

            insert pbEntriesInsert;

            //If successful clear the list and display an informational message
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,productsToInsert.size()+' Inserted'));
            productsToInsert.clear();   //Do not remove
            addRows();  //Do not remove
        } catch (Exception e){
            Database.rollback(sp);
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Constants.ERROR_MESSAGE));        
        }
        return null;
    }

    public class ProductWrapper {
        public Product2 productRecord {get; set;}
        public PriceBookEntry pricebookEntryRecord {get; set;}

        public ProductWrapper() {
            productRecord = new Product2(Initial_Inventory__c =0);
            pricebookEntryRecord = new PricebookEntry(Unitprice=0.0);
        }
    }

}