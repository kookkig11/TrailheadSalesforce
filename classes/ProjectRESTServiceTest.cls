@isTest
private class ProjectRESTServiceTest {
  //Implement Apex REST service tests here
  @isTest static void testRESTservice(){
  Opportunity opp = new Opportunity(Name = 'Test Opportunity',
                                    DeliveryInstallationStatus__c = 'Yet to begin',
                                    CloseDate = (Date.today()).addDays(20),
                                    StageName = 'Submitted Project');
  insert opp;
  Project__c newProject = new Project__c(ProjectRef__c = 'ProjectRef',
                                         Name = 'ProjectName',
                                         Opportunity__c = opp.Id,
                                         Start_Date__c = Date.today(),
                                         End_Date__c = (Date.today()).addDays(10),
                                         Billable_Amount__c = 1000,
                                         Status__c = 'Running');
  insert newProject;

  Test.startTest();
  /*
  global static String postProjectData(String ProjectRef, String ProjectName, String OpportunityId,
                                        Date StartDate, Date EndDate, Double Amount, String Status)
  */
  ProjectRESTService.postProjectData('ProjectRef', 'ProjectName', String.valueOf(opp.Id), Date.today(), Date.today(), 1000, 'Running');
  Test.stopTest();
  }
}