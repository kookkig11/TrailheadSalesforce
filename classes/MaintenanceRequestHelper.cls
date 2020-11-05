public with sharing class MaintenanceRequestHelper {
    public static void updateWorkOrders(List<Case> closedCase) {
        // TODO: Complete the method to update workorders
        List<Product2> listProduct = [select Id, Maintenance_Cycle__c from Product2];  
		Map<Id,decimal> mapProduct = new Map<Id, decimal>();
		for (Product2 p : listProduct) {
			if (p != null) {
				if(p.Maintenance_Cycle__c != null){
					mapProduct.put(p.Id, p.Maintenance_Cycle__c);
				}				
			}
        }
        
        List<Case> caseList = new List<Case>();
        for(Case c : closedCase){
            Case newCase = new Case();
            if (mapProduct.get(c.Equipment__c) != null) {
                newCase.Date_Due__c = Date.today().addDays(Integer.valueOf(mapProduct.get(c.Equipment__c)));
           }
            newCase.Type = 'Routine Maintenance';
            newCase.Status = 'New';
            newCase.Vehicle__c = c.Vehicle__c;
            newCase.Subject =  c.Subject;
            newCase.Date_Reported__c = Date.today();
            newCase.Equipment__c = c.Equipment__c;
            newCase.Product__c = c.Product__c;
			newCase.ContactId = c.ContactId;
			newCase.AccountId = c.AccountId;
			newCase.AssetId = c.AssetId;
            caseList.add(newCase);
        }
        
        if(caseList.size() > 0){
        	insert caseList;
        }
    }        
    
}