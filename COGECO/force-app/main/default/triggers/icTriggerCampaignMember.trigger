trigger icTriggerCampaignMember on CampaignMember(before insert, before update, before delete, after insert, after update, after delete, after undelete) {

	icHandlerCampaignMemberTrigger.IClass handler = (icHandlerCampaignMemberTrigger.IClass) icObjectFactory.GetSingletonInstance('icHandlerCampaignMemberTrigger');

	
	//insert
/*
	if(Trigger.isBefore && Trigger.isInsert) {
		handler.onBeforeInsert(Trigger.new, Trigger.newMap);
	}
*/
	if(Trigger.isAfter && Trigger.isInsert) {
		handler.onAfterInsert(Trigger.old, Trigger.new, Trigger.newMap);
	}

	//update
/*
	if(Trigger.isBefore && Trigger.isUpdate) {
		handler.onBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap);
	}
*/

	if(Trigger.isAfter && Trigger.isUpdate) {
		handler.onAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap);
	}

/*
	//delete
	if(Trigger.isBefore && Trigger.isDelete) {
		handler.onBeforeDelete(Trigger.old, Trigger.oldMap);
	}
	if(Trigger.isAfter && Trigger.isDelete) {
		handler.onAfterDelete(Trigger.old, Trigger.oldMap);
	}

	//undelete
	if(Trigger.isAfter && Trigger.isUndelete) {
		handler.onAfterUndelete(Trigger.old, Trigger.new, Trigger.newMap);
	}
*/
}