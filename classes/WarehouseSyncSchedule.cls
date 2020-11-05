global class WarehouseSyncSchedule implements Schedulable{
    global void execute(SchedulableContext sc){
        WarehouseCalloutService.runWarehouseEquipmentSync();

        // WarehouseSyncSchedule reminder = new WarehouseSyncSchedule();
        // String sch = '0 0 8 * * ? *';
        // String jobID = System.schedule('WarehouseSyncSchedule', sch, reminder);
        
    }
}