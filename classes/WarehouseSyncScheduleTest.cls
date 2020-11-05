@isTest
public class WarehouseSyncScheduleTest {
    
    @isTest
    static void test() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());   		
        String sch =  '0 50 16 * * ?';
        Test.startTest();
        
        // Schedule the test job
        String jobId = System.schedule('test WarehouseSyncSchedule', sch, new WarehouseSyncSchedule());
        
        Test.stopTest();
        
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                          NextFireTime FROM CronTrigger WHERE id = :jobId];
        
        // Verify the expressions are the same
        System.assertEquals(sch,ct.CronExpression);
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
    }
}
