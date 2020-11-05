@isTest
public class AccountProcessorTest {
    @isTest public static void testNoOfContacts(){
        Account a = new Account(Name = 'Acme1');
        Insert a;
        Account b = new Account(Name = 'Acme2');
        insert b;
        Contact c = new Contact(FirstName = 'Gk', LastName = 'Gupta', accountId = a.Id);
        insert c;
        Contact c1 = new Contact(FirstName = 'Gk1', LastName = 'Gupta1', accountId = b.Id);
        insert c1;
        
        List<account> acnt = [SELECT Id FROM Account WHERE Name = :a.Name OR Name = :b.Name];
        System.debug('size of acnt: ' + acnt);
        List<ID> acntIDLST = new List<Id>();
        for(Account ac: acnt){
            acntIDLST.add(ac.Id);
        }
        Test.startTest();
        AccountProcessor.countContacts(acntIDLST);
        Test.stopTest();
    }
}