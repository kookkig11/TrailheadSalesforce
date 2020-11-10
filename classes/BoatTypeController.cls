public with sharing class BoatTypeController{
    @AuraEnabled
    public static List<BoatType__c> getBoatTypes(){
        return [SELECT Id, Name FROM BoatType__c ORDER BY Name];
    }
}