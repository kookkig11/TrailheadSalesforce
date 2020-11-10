({
    onSearch : function(component,choosenboat,event,helper) {
        var action=component.get("c.getBoats");
        action.setParams({"boatTypeId":component.get("v.boatTypeId")});
        action.setCallback(this,function(response) {
            var state= response.getState();
            if(state==='SUCCESS'){ 
                var temp=response.getReturnValue();
                component.set("v.boats",temp);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);   
    },
})