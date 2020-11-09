public class BillingCalloutService {
    //Implement business and callout logic methods here
    @future(callout=true)
    public static void callBillingService(String ProjectRef, Decimal Amount){
        // BillingServiceProxy to use for your callout.
        ServiceCredentials__c userCredential = ServiceCredentials__c.getValues('BillingServiceCredential');
        BillingServiceProxy.project projectInst = new BillingServiceProxy.project();
        projectInst.username = userCredential.Username__c;
        projectInst.password = userCredential.Password__c;
        projectInst.projectid = ProjectRef;
        projectInst.billAmount = Amount;

        BillingServiceProxy.InvoicesPortSoap11 invoicePort = new BillingServiceProxy.InvoicesPortSoap11();
        String response = invoicePort.billProject(projectInst);
        
        List<Project__c> projectList = new List<Project__c>();
        if(response != null && response.equalsIgnoreCase('OK')){
            List<Project__c> lstOfPrjts = [SELECT Status__c FROM Project__c WHERE ProjectRef__c = :projectRef];
            for(Project__c i : lstOfPrjts){
                i.Status__c = 'Billed';
                projectList.add(i);
            }
            
            update projectList;
        }
    }
}