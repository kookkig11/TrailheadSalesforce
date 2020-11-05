@isTest
private class TestRestrictContactByName {
    @isTest static void testInsert(){
        Contact c = new Contact(LastName = 'INVALIDNAME', FirstName = 'Error');
        
        Test.startTest();
        // use try catch >> c.AddError
        try {
            insert c;
        } catch(Exception e) {
            Test.stopTest();
        }
		
        /*
        Test.startTest();
        insert c;
        Test.stopTest();
		*/
    }
}