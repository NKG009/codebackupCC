public class restrictRateLineAccessHandler {
    public static void accountUserConditionInsert(List<sirenum__Rate_Line__c> rateLineNewList) {
        Id userId = UserInfo.getUserId();
        Set<String> allowedProfileNames = new Set<String> {
            'System Administrator',
			'Back Office',
			'JS Admin tier 1'
        };

        List<User> userInProf = [SELECT ProfileId FROM User WHERE Profile.Name IN :allowedProfileNames AND Id = :userId];

        List<Id> rateLineIds = new List<Id>();
        Map<Id, Boolean> checkAccountMap = new Map<Id, Boolean>();
        for(sirenum__Rate_Line__c theRateLine : rateLineNewList) {
			rateLineIds.add(theRateLine.sirenum__Rate_Card_Page__c);
        }

        for(sirenum__Rate_Card_Page__c theRateCardPage : [SELECT
															sirenum__Rate_Card__r.IP_AcountLinkCustom__c,
															sirenum__Rate_Card__r.IP_AcountLinkCustom__r.Managed_Account__c,
															sirenum__Rate_Card__r.Staging_Job_Role__c,
															sirenum__Rate_Card__r.Job_Role_ID__c
												   		  FROM sirenum__Rate_Card_Page__c
                                                          WHERE Id IN :rateLineIds]) {
            if(
                theRateCardPage.sirenum__Rate_Card__r.IP_AcountLinkCustom__r.Managed_Account__c &&
				userInProf.isEmpty() &&
				(
                    (theRateCardPage.sirenum__Rate_Card__r.Staging_Job_Role__c == null && theRateCardPage.sirenum__Rate_Card__r.Job_Role_ID__c == null) ||
                	(theRateCardPage.sirenum__Rate_Card__r.Staging_Job_Role__c == null && theRateCardPage.sirenum__Rate_Card__r.Job_Role_ID__c != null) ||
					(theRateCardPage.sirenum__Rate_Card__r.Staging_Job_Role__c != null && theRateCardPage.sirenum__Rate_Card__r.Job_Role_ID__c != null)
                )
			) {
				checkAccountMap.put(theRateCardPage.Id, true);
            }
        }

        for(sirenum__Rate_Line__c rateLineRecord : rateLineNewList) {
            if(checkAccountMap.containsKey(rateLineRecord.sirenum__Rate_Card_Page__c)) {
				rateLineRecord.addError('For managed account, you do not have permission to perform this action.');
            }
        }
    }
}