// will add a task to any opportunity inserted or updated with the stage of 'Closed Won'
trigger ClosedOpportunityTrigger on Opportunity (before insert, before update) {
	List<Task> listTask = new  List<Task>();
    
    for(Opportunity opp : Trigger.New){
        if(opp.StageName == 'Closed Won'){
            Task t= new Task();
            t.subject = 'Follow Up Test Task';
            t.WhatId = opp.Id;
            listTask.add(t);
        }
    }
    insert listTask;
}