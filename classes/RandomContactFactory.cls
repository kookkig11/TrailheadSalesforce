public class RandomContactFactory {
    // returns a list of contacts 
    public static List<Contact> generateRandomContacts(integer n_Contact, string LastNameGen){
        List<Contact> con = new List<Contact>();
        for (Integer i=0; i<n_Contact; i++){
            Contact acc = new Contact(FirstName = 'Test' + i, LastName = LastNameGen);
            con.add(acc);
        }
        // should NOT be inserted into the system, only returned
        return con;
    }
}