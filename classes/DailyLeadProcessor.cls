public class DailyLeadProcessor implements Schedulable{
    public void execute(SchedulableContext ctx){
        // find the first 200 Leads with a blank LeadSource field
        List<Lead> leads = [SELECT Id, LeadSource FROM Lead WHERE LeadSource = '' LIMIT 200];
        
        if(leads.size() > 0){
            List<Lead> newLeads = new List<Lead>();
            
            for(Lead lead : leads){
                // update them with the LeadSource value of 'Dreamforce'
                lead.LeadSource = 'DreamForce';
                newLeads.add(lead);
            }
            
            update newLeads;
        }
    }
}