trigger Product2Trigger on Product2 (before insert, before update, before delete, 
                                     after insert, after update, after delete, after undelete) {
    if (Trigger.isBefore)
        if (Trigger.isUpdate)
            Product2Helper.beforeUpdate(Trigger.new, Trigger.old);
        else if (Trigger.isInsert)
            Product2Helper.beforeInsert(Trigger.new, Trigger.old);
        else
            Product2Helper.beforeDelete(Trigger.new, Trigger.old);
    else
        if (Trigger.isUpdate)
            Product2Helper.afterUpdate(Trigger.new, Trigger.old);
        else if (Trigger.isInsert)
            Product2Helper.afterInsert(Trigger.new, Trigger.old);
        else
            Product2Helper.afterDelete(Trigger.new, Trigger.old);
}
