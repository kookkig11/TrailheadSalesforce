@isTest
public with sharing class MaintenanceRequestTest {
    public static testMethod void testMaintenanceRequest() {
        List<Product2> eqList = new List<Product2>();
        Product2 eqip = new Product2(Name = 'Equipment', 
                                     Maintenance_Cycle__c = 10,
                                     Cost__c = 100,
                                     Current_Inventory__c = 10,
                                     Lifespan_Months__c = 10,
                                     Replacement_Part__c = true,
                                     Warehouse_SKU__c = 'abc');
        eqList.add(eqip);
        insert eqList;

        List<Case> insertList = new List<Case>();
        List<Case> updateList = new List<Case>();
        Id equipId = [SELECT Id FROM Product2 LIMIT 1].get(0).Id;
        
        for(Integer i=0; i<300; i++){
            Case caseInsert = new Case(Type = 'Routine Maintenance', Status = 'New', Origin = 'Phone');
            caseInsert.Equipment__c = equipId;
            insertList.add(caseInsert);
        }
        
        Test.startTest();
        insert insertList;
        System.assertEquals(300, insertList.size());
        
        for(Case caseUpdate : insertList){
            caseUpdate.Status = 'Closed';
            updateList.add(caseUpdate);
        }
        update updateList;
        
        System.assertEquals(300, updateList.size());
        Test.stopTest();
    }
}
