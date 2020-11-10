public class BoatSearchResults {
    @AuraEnabled
    public static List<BoatType__c> getBoatType() {
        return [select id,Name from BoatType__c];
    } 
   
    @AuraEnabled
    public static List<Boat__c> getBoats(String boatTypeId){
        if(boatTypeId==null || boatTypeId==''){
            return [select id,Name,BoatType__c,Contact__c,Picture__c from Boat__c];  
        } else {
            return [select id,Name,BoatType__c,Contact__c,Picture__c from Boat__c where BoatType__c=:boatTypeId];       
        }
    }
}
