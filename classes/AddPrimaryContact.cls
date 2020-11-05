public class AddPrimaryContact implements Queueable {
    // Create a constructor that accept Contact sObject and string State
    private Contact c;
    private String state;

    public  AddPrimaryContact(Contact c, String state) {
        this.c = c;
        this.state = state;
    }
    public void execute(QueueableContext context) {
        //  query for a maximum of 200 Accounts with the BillingState specified by the State
        List<Account> ListAccount = [SELECT ID, Name ,(Select id,FirstName,LastName from contacts ) FROM ACCOUNT WHERE BillingState = :state LIMIT 200];
        
        // passed into the constructor
        List<Contact> lstContact = new List<Contact>();
        for (Account acc:ListAccount) {
            Contact cont = c.clone(false, false, false, false);
            cont.AccountId =  acc.id;
            lstContact.add(cont);
        }
         
        if (lstContact.size() >0 ) {
            insert lstContact;
        }  
    }
}