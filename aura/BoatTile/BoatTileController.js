({
    doInit : function(component, event, helper) {
        var data=component.get("v.boat");
        console.log("data received in boattile"+data);
    },
   
    onBoatClick : function(component, event, helper) {
        var data = event.getSource().get("v.value")
        //var temp=data.id;
        console.log("data received in boattilecontroller : " + data);
            var BoatSelect = component.getEvent("BoatSelect");
            BoatSelect.setParams({
                "boatId": data
            });
            BoatSelect.fire();
    }
})
