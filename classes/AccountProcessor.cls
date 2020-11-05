public class AccountProcessor{
    // accepts a List of Account IDs
    @future
    public static void countContacts(List<Id> accountIds){
        List<Account> vAccountList = new List<Account>();
        List<Account> acc = [SELECT Id,Name,
                             (SELECT Id,Name FROM Contacts) 
                             FROM Account WHERE Id IN :accountIds];
        System.debug('total contact in Account: ' + acc);
        
        if(acc.size() > 0){
            for(Account a: acc){
                List<Contact> con = [SELECT Id,Name FROM Contact WHERE accountId = :a.Id];
                a.Number_of_Contacts__c = con.size();
                vAccountList.add(a);
            }
            if(vAccountList.size()>0)
            {
                update vAccountList;
            }
        }
    }
}