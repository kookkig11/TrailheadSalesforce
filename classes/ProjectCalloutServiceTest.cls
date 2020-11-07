@isTest
private class ProjectCalloutServiceTest {
  //Implement mock callout tests here
  @testSetup static void testSetup(){
    // initial data
    Opportunity opp1 = new Opportunity(Name='Test Opp 1',
                                      Amount=100,
                                      Type='New Project',
                                      StageName = 'Submitted Project',
                                      CloseDate=System.today());
    insert opp1;
    Opportunity opp2 = new Opportunity(Name='Test Opp 2',
                                      Amount=200,
                                      Type='New Project',
                                      StageName = 'Resubmit Project',
                                      CloseDate=System.today());
    insert opp2;
    ServiceTokens__c servToken = new ServiceTokens__c(Name = 'ProjectServiceToken',
                                                      Token__c = 'qwertyuiopnjhgft');
    insert servToken;
  }

  @isTest static void testSuccess() {
    Opportunity opp = [SELECT Id, Name, StageName FROM Opportunity WHERE Name = 'Test Opp 1' LIMIT 1];
    List<Id> oppIdList = new List<Id>();
    oppIdList.add(opp.Id);

    Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
    Test.startTest();
    ProjectCalloutService.postOpportunityToPMS(oppIdList);
    Test.stopTest();

    // check 'stage name'
    System.assertEquals('Submitted Project', opp.StageName);
  }

  @isTest static void testFailure() {
    Opportunity opp = [SELECT Id, Name, StageName FROM Opportunity WHERE Name = 'Test Opp 2' LIMIT 1];
    List<Id> oppIdList = new List<Id>();
    oppIdList.add(opp.Id);

    Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
    Test.startTest();
    ProjectCalloutService.postOpportunityToPMS(oppIdList);
    Test.stopTest();

    // check 'stage name'
    System.assertEquals('Resubmit Project', opp.StageName);
  }
}