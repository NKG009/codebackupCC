trigger WorkOrderTrigger on WorkOrder (before update,after insert, after update) {
if(Trigger.isBefore){
        if(Trigger.isUpdate){
            WorkOrderTriggerHandler.beforeUpdate();
        }
    }
     if(Trigger.isafter){
        if(Trigger.isinsert){
            WorkOrderTriggerHandler.WorkorderSharingToPowerUserOnInsert(trigger.newmap);
            WorkOrderTriggerHandler.UpdateFastFieldIdOfInsertedWO(Trigger.newMap);
            
        }
          if(Trigger.isupdate){
              WorkOrderTriggerHandler.WorkOrderIdaddtoCustomsettingforPMe(trigger.new,Trigger.newmap,Trigger.oldmap);
              WorkOrderTriggerHandler.AddingErroredrecordforPost(trigger.new,trigger.oldmap);
              WorkOrderTriggerHandler.WorkorderidtocustomsettingPropertyTree(trigger.new,trigger.oldmap);
          }
    }
}