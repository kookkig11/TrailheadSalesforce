@isTest
private class AnimalLocatorTest{
    @isTest
    static void testAnimalNameById(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());
        
        String result = AnimalLocator.getAnimalNameById(1);
        System.assertEquals('tiger',result);
    }
}