trigger restrictRateLineAccess on sirenum__Rate_Line__c (before delete) {
    if(Trigger.isUpdate) {
		// restrictRateLineAccessHandler.accountUserConditionInsert(Trigger.new);
    }
    if(Trigger.isDelete) {
		restrictRateLineAccessHandler.accountUserConditionInsert(Trigger.old);
    }
    if(Trigger.isInsert) {
		// restrictRateLineAccessHandler.accountUserConditionInsert(Trigger.new);
    }
}