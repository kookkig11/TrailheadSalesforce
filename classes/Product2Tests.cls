@isTest(seeAllData = false) private class Product2Tests {
	/**
	 * @name product2Extension_UnitTest
	 * @description UnitTest for product2Extension
	 **/
	private static TestMethod void Product2Extension_UnitTest() {
		Test.startTest();
        PageReference pageRef = Page.Product2New;
        
		Product2 prod = new Product2(Name='test', isActive= true);
		ApexPages.StandardController sc = new ApexPages.StandardController(prod);

		Product2Extension ext = new Product2Extension(sc);
        
        System.assertEquals(Constants.DEFAULT_ROWS, ext.productsToInsert.size());
        ext.AddRows();
        System.assertEquals(Constants.DEFAULT_ROWS * 2, ext.productsToInsert.size());

        for(Integer i=0; i< Constants.DEFAULT_ROWS; i++){
            
            List<Product2> newProd = TestDataFactory.ConstructProducts(1);
            ext.productsToInsert[i].productRecord = newProd[0];

            PriceBookEntry pbEntry = new PriceBookEntry(Unitprice = 100, isActive = true);
            ext.productsToInsert[i].pricebookEntryRecord = pbEntry;
        }
        
		ext.Save();
        ext.GetFamilyOptions();
		ext.GetInventory();

        List<Product2> selectedProd = [Select id from Product2];
        System.assertEquals(Constants.DEFAULT_ROWS, selectedProd.size());

		Test.stopTest();
    }
    
    @IsTest
    private static void Product2Trigger_UnitTest(){
        
        Test.startTest();
        CollaborationGroup c = TestDataFactory.ConstructCollaborationGroup();
        insert c;

        Product2 newProduct = TestDataFactory.ConstructProducts(1)[0];
        newProduct.Quantity_Ordered__c = 5;
        insert newProduct;
        
        
        newProduct.Quantity_Ordered__c=96;
        update newProduct;

        delete newProduct;
        Test.stopTest();
        
    }

}