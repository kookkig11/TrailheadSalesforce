// create a Routine Maintenance request every time a maintenance request of 'type Repair or Routine Maintenance' is updated to Closed
// >> update to close <<

trigger MaintenanceRequest on Case (before update, after update) {
    // ToDo: Call MaintenanceRequestHelper.updateWorkOrders
    List<Case> closeCase = new List<Case>();
    if(Trigger.isAfter && Trigger.isUpdate){
        for (Case i: Trigger.New) {
            if (i.Status == 'Closed' & (i.Type == 'Repair' | i.type == 'Routine Maintenance')) {
                closeCase.add(i);
            }
        }
    }   
    MaintenanceRequestHelper.updateWorkOrders(closeCase);
}