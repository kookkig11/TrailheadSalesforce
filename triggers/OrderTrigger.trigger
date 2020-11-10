/**
 * @name orderTrigger
 * @description
**/
trigger OrderTrigger on Order (
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {

    if (Trigger.isBefore)
        if (Trigger.isUpdate)
            OrderHelper.beforeUpdate(Trigger.new, Trigger.old);
        else if (Trigger.isInsert)
            OrderHelper.beforeInsert(Trigger.new, Trigger.old);
        else
            OrderHelper.beforeDelete(Trigger.new, Trigger.old);
    else
        if (Trigger.isUpdate)
            OrderHelper.afterUpdate(Trigger.new, Trigger.old);
        else if (Trigger.isInsert)
            OrderHelper.afterInsert(Trigger.new, Trigger.old);
        else
            OrderHelper.afterDelete(Trigger.new, Trigger.old);
}