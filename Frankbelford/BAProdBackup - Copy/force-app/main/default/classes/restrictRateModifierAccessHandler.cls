public class restrictRateModifierAccessHandler {
	public static void accountUserConditionInsert(List<sirenum__Rate_Modifier__c> rateModNewList) {
		Id userId = UserInfo.getUserId();
		Set<String> allowedProfileNames = new Set<String> {
			'System Administrator',
			'Back Office',
			'JS Admin tier 1'
        };
		List<User> userInProf = [SELECT ProfileId FROM User WHERE Profile.Name IN :allowedProfileNames AND Id = :userId];

        List<Id> rateModIds = new List<Id>();
        for(sirenum__Rate_Modifier__c rateModRecord : rateModNewList) {
			rateModIds.add(rateModRecord.sirenum__Rate_Line__c);
        }

		Map<Id, Boolean> checkAccountMap = new Map<Id, Boolean>();
        for(sirenum__Rate_Line__c rateLine : [SELECT
                                              	sirenum__Rate_Card_Page__r.sirenum__Rate_Card__r.IP_AcountLinkCustom__r.Managed_Account__c,
                                              	sirenum__Rate_Card_Page__r.sirenum__Rate_Card__r.Staging_Job_Role__c,
                                              	sirenum__Rate_Card_Page__r.sirenum__Rate_Card__r.Job_Role_ID__c
                                              FROM sirenum__Rate_Line__c
                                              WHERE Id IN :rateModIds]) {
			if(
                rateLine.sirenum__Rate_Card_Page__r.sirenum__Rate_Card__r.IP_AcountLinkCustom__r.Managed_Account__c == true &&
				userInProf.isEmpty() &&
				(
                    (rateLine.sirenum__Rate_Card_Page__r.sirenum__Rate_Card__r.Staging_Job_Role__c == null && rateLine.sirenum__Rate_Card_Page__r.sirenum__Rate_Card__r.Job_Role_ID__c == null) ||
                	(rateLine.sirenum__Rate_Card_Page__r.sirenum__Rate_Card__r.Staging_Job_Role__c == null && rateLine.sirenum__Rate_Card_Page__r.sirenum__Rate_Card__r.Job_Role_ID__c != null) ||
					(rateLine.sirenum__Rate_Card_Page__r.sirenum__Rate_Card__r.Staging_Job_Role__c != null && rateLine.sirenum__Rate_Card_Page__r.sirenum__Rate_Card__r.Job_Role_ID__c != null)
                )
            ) {
				checkAccountMap.put(rateLine.Id, true);
            }
        }

        for(sirenum__Rate_Modifier__c rateModRecord : rateModNewList) {
            if(checkAccountMap.containsKey(rateModRecord.sirenum__Rate_Line__c)) {
				rateModRecord.addError('For managed account, you do not have permission to perform this action.');
            }
        }
    }
}