@IsTest
private class WarehouseCalloutServiceTest {
    public static testMethod void test() {
        // implement your mock callout test here
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        
        Test.startTest();
        WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();
    }
}