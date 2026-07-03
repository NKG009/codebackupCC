trigger restrictRateModifierAccess on sirenum__Rate_Modifier__c (before delete) {
    if(Trigger.isUpdate) {
		// restrictRateModifierAccessHandler.accountUserConditionInsert(Trigger.new);
    }
    if(Trigger.isDelete) {
		restrictRateModifierAccessHandler.accountUserConditionInsert(Trigger.old);
    }
    if(Trigger.isInsert) {
		// restrictRateModifierAccessHandler.accountUserConditionInsert(Trigger.new);
    }
}