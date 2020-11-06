public class ProjectCalloutService {
    //Complete the implementation for business and callout logic
    @future(callout=true)
    public static void postOpportunityToPMS(List<Id> oppoIds){
        Opportunity opp = [SELECT Id, Name, Account.Name, CloseDate,Amount FROM Opportunity WHERE Id = :oppoIds[0]];
        String serviceToken = ServiceTokens__c.getValues('ProjectServiceToken').Token__c;
        String inputJSON =    '{\n' +
                            ' "opportunityId" : "' + opp.Id + '",\n'+
                            ' "opportunityName": "' + opp.Name + '",\n'+
                            ' "accountName": "' + opp.Account.Name + '",\n'+
                            ' "closeDate": "' + String.ValueOf(opp.CloseDate).mid(0,10) + '",\n'+
                            ' "amount": ' + opp.Amount +
                            '\n}';

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:ProjectService');
        req.setMethod('POST');
        req.setHeader('token', serviceToken);
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setBody(inputJSON);
        HttpResponse res = http.send(req);

        Opportunity newOpp = new Opportunity(Id=opp.Id);
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