@isTest
private class OrderTests {
	@TestSetup
	static void setupTestData() {
		TestDataFactory.insertTestData(1);
	}

	@isTest
	private static void orderUpdate_UnitTest() {
		Order o = [SELECT Id FROM Order LIMIT 1];
		Product2 oldProduct = [SELECT Id, Family, Name, Quantity_Ordered__c, Quantity_Remaining__c FROM Product2 LIMIT 1];

		o.Status = Constants.ACTIVATED_ORDER_STATUS;

		Test.startTest();

		update o;

		Test.stopTest();

		Product2 newProduct = [SELECT Quantity_Ordered__c FROM Product2 WHERE Id = :oldProduct.Id];
		TestDataFactory.verifyQuantityOrdered(oldProduct, newProduct, Constants.DEFAULT_ROWS);
	}

	@isTest
	private static void OrderExtension_UnitTest() {
		Test.startTest();
		PageReference pageRef = Page.OrderEdit;
		Account acct = [select id from Account limit 1];

		Order ord = new Order(
			AccountId = acct.Id,
			Name='Test',
		 	Status=Constants.DRAFT_ORDER_STATUS,
		    EffectiveDate = Date.today()
		);

		OrderItem ordItemExistent = [select id, OrderId from OrderItem limit 1];

		ApexPages.StandardController sc = new ApexPages.StandardController(ord);

		OrderExtension ext = new OrderExtension(sc);

		Order ordExistent = new Order(id=ordItemExistent.OrderId);
		ApexPages.StandardController scExistent = new ApexPages.StandardController(ordExistent);

		OrderExtension extExistent = new OrderExtension(scExistent);
		extExistent.orderItemMap.values().get(0).Quantity = 2;
		extExistent.Save();

		extExistent.orderItemMap.values().get(0).Quantity = 0;
		extExistent.Save();

		ext.selectedFamily =  Constants.PRODUCT_FAMILY[0].getValue();
		ext.SelectFamily();
		ext.Save();
		ext.orderRecord.AccountId = null;
		ext.Save();

		ext.GetFamilyOptions();
		ext.GetPageNumber();
		ext.GetHasNext();
		ext.GetHasPrevious();
		ext.GetTotalPages();
		ext.Next();
		ext.Last();
		ext.First();
		ext.Previous();

		Test.stopTest();
	}

	@IsTest
    private static void OrderTrigger_UnitTest(){
        
        Test.startTest();
		Order ord = [select id from Order limit 1];
		delete ord;
        Test.stopTest();
        
    }
}