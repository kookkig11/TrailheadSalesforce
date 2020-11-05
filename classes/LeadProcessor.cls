public class LeadProcessor implements Database.Batchable <SObject> {

    public Database.QueryLocator start(Database.BatchableContext bc){
        String Query='Select Id,LeadSource from Lead';
        return Database.getQueryLocator(Query);
    }

    public void execute(Database.BatchableContext bc, List<Lead> scope){
        // update all Lead records in the org with the LeadSource value of 'Dreamforce'
        for(Lead i: scope){
            i.LeadSource = 'DreamForce';
        }
        update scope;
    }

    public void finish(Database.BatchableContext bc){
        Id job= bc.getJobId();
        System.debug(job);
    }
}
