@RestResource(urlMapping='/project/*')
global class ProjectRESTService {
    //Implement service logic here
    @HttpPost
    global static String postProjectData(String ProjectRef, String ProjectName, String OpportunityId,
                                        Date StartDate, Date EndDate, Double Amount, String Status) {
        // accepts the 'post' and inserts (or updates) a corresponding project record associated with the opportunity
        String message = '';
        Savepoint sp = Database.setSavepoint();
        try {
            List<Opportunity> oppList = new List<Opportunity>();
            // update the Delivery/Installation Status field as In Progress on the associated opportunity record
            Opportunity opp = [SELECT Id, DeliveryInstallationStatus__c FROM Opportunity WHERE Id=:OpportunityId];
            opp.DeliveryInstallationStatus__c = 'In Progress';
            oppList.add(opp);
            update oppList;

            List<Project__c> projectList = new List<Project__c>();     
            Project__c newProject = new Project__c(ProjectRef__c = ProjectRef,
                                                Name = ProjectName,
                                                Opportunity__c = OpportunityId,
                                                Start_Date__c = StartDate,
                                                End_Date__c = EndDate,
                                                Billable_Amount__c = Amount,
                                                Status__c = Status);
            projectList.add(newProject);
            upsert projectList;

            message = 'OK';
        } catch (Exception e){
            Database.RollBack(sp);
            message = e.getMessage();
        }

        return message;
    }
}