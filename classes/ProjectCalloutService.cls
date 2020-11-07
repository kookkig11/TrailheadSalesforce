public class ProjectCalloutService {
    //Complete the implementation for business and callout logic
    @InvocableMethod
    public static void postOpportunityToPMS(List<Id> oppId) {
        Opportunity opp = [SELECT Id, Name, Account.Name, CloseDate, Amount FROM Opportunity WHERE Id =: oppId[0]];
        String serviceToken = ServiceTokens__c.getValues('ProjectServiceToken').Token__c;
        String inputJSON =  '{\n' +
                            ' "opportunityId" : "' + opp.Id + '",\n'+
                            ' "opportunityName": "' + opp.Name + '",\n'+
                            ' "accountName": "' + opp.Account.Name + '",\n'+
                            ' "closeDate": "' + String.ValueOf(opp.CloseDate).mid(0,10) + '",\n'+
                            ' "amount": ' + opp.Amount +
                            '\n}';
            
        System.enqueueJob(new QueueablePMSCall(serviceToken, inputJSON, opp.Id));
    }    

    class QueueablePMSCall implements System.Queueable, Database.AllowsCallouts {
        private String serviceToken;
        private String jsonInput;
        private Id oppId;
        
        // Queueable
        public QueueablePMSCall(String serviceToken, String jsonInput, Id oppId) {
            this.serviceToken = serviceToken;
            this.jsonInput = jsonInput;
            this.oppId = oppId;
        }
        public void execute(QueueableContext qc) {
            postToPMS(serviceToken, jsonInput, oppId);        
        }
    }

    @future(callout=true)
    public static void postToPMS(String serviceToken, String jsonInput, Id oppId) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:ProjectService');
        req.setMethod('POST');
        req.setHeader('token', serviceToken);
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setBody(jsonInput);
        HttpResponse res = http.send(req);

        Opportunity newOpp = new Opportunity(Id=oppId);
        if(res.getStatusCode() == 201){
            newOpp.StageName = 'Submitted Project';                
            System.debug('Success: ' + res.getStatusCode() + ' ' + res.getStatus());
        } else {
            newOpp.StageName = 'Resubmit Project';
            System.debug('Failure: ' + res.getStatusCode() + ' ' + res.getStatus());
        }
        update newOpp;
    }
}