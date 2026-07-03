trigger restrictRateCardPageAccess on sirenum__Rate_Card_Page__c (before delete) {
	if(Trigger.isUpdate && Limits.getQueries() < 90) {
		// restrictRateCardPageAccessHandler.accountUserConditionInsert(Trigger.new);
    }
    if(Trigger.isDelete && Limits.getQueries() < 90) {
		restrictRateCardPageAccessHandler.accountUserConditionDelete(Trigger.old);
    }
    if(Trigger.isInsert && Limits.getQueries() < 90) {
    	// restrictRateCardPageAccessHandler.accountUserConditionInsert(Trigger.new);
	}
    if((trigger.isinsert || Trigger.isUpdate) && Limits.getQueries() < 90) {
        // restrictRateCardPageAccessHandler.validationmessage(Trigger.new);
    }
}