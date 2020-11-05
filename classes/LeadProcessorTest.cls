@isTest
public class LeadProcessorTest {
    public static testMethod void test(){
        // insert 200 record
        List<Lead> leadList = new List<Lead>();
        for (Integer i=0; i<200; i++) {
            Lead l = new Lead();
            l.LastName='last' + i;
            l.Company='Company';
            l.Status='Closed-Converted';
            l.LeadSource='Dreamforce';
            leadList.add(l);
        }
        insert leadList;

        Test.startTest();
        LeadProcessor leadProcess = new LeadProcessor();
        Id batchid = Database.executeBatch(leadProcess);
        Test.stopTest();
    }
}
