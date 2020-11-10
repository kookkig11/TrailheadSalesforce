({
    doInit : function(component, event, helper) {
        var data=component.get("v.boat");
        console.log("data received in boattile"+data);
    },
   
    onBoatClick : function(component, event, helper) {
        var data=event.getSource().get("v.value")
        var boatid=data.Id;
        console.log("data received in boattilecontroller"+data);
        var BoatSelect=component.getEvent("BoatSelect");
        BoatSelect.setParams({
            "boatId":boatid
        });
        BoatSelect.fire();
       
        //fire BoatSelected event
        var boatselected = $A.get("e.c:BoatSelected");
        boatselected.setParams({
            "boat" : data
        });
        boatselected.fire();
    },
})