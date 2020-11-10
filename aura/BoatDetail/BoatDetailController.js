({
    init : function(component, event, helper) {
        var redirectToSObjectPageEvent = $A.get("e.force:navigateToSObject");
        if(redirectToSObjectPageEvent){
            component.set("v.displaybutton",true);
        }  
    },
   
    onFullDetails : function(component, event, helper) {
        var redirectToSObjectPageEvent = $A.get("e.force:navigateToSObject");
        var boatrecord = component.get("v.boat");
        if(boatrecord){
            redirectToSObjectPageEvent.setParams({
                "recordId" : boat.Id
            });
            redirectToSObjectPageEvent.fire();
        }
    }
})
