public class restrictRateCardPageAccessHandler {
    public static void accountUserConditionDelete(List<sirenum__Rate_Card_Page__c> ratePgNewList) {
        Id userId = UserInfo.getProfileId();
        Set<String> allowedProfileNames = new Set<String> {
            'System Administrator',
			'Back Office',
			'JS Admin tier 1'
        };

        List<Id> RatePgId = new List<Id>();
        Set<Id> nonManaged = new Set<Id>();
        Set<Id> managedBack = new Set<Id>();
		Set<Id> cannotDeleteRateCardIds = new Set<Id>();

        Map<Id, Boolean> checkAccountMap = new Map<Id, Boolean>();
        List<Profile> prof = [select Name FROM profile WHERE Id = :userId];

        for(sirenum__Rate_Card_Page__c RateId : ratePgNewList) {
            RatePgId.add(RateId.sirenum__Rate_Card__c);
        }

        for(sirenum__Rate_Card__c rateCard : [SELECT IP_AcountLinkCustom__r.Managed_Account__c, Staging_Job_Role__c, Job_Role_ID__c
                                              FROM sirenum__Rate_Card__c WHERE Id IN :RatePgId]) {
            if(rateCard.IP_AcountLinkCustom__r.Managed_Account__c == true && !allowedProfileNames.contains(prof[0].name)) {
				checkAccountMap.put(rateCard.Id, true);
            }

			if(rateCard.IP_AcountLinkCustom__r.Managed_Account__c == true && prof[0].name == 'Back Office') {
				managedBack.add(rateCard.Id);
            }

			if(rateCard.IP_AcountLinkCustom__r.Managed_Account__c == false && prof[0].name == 'Back Office') {
				nonManaged.add(rateCard.Id);
            }

			if(
				(
                    (rateCard.Staging_Job_Role__c == null && rateCard.Job_Role_ID__c == null) ||
                	(rateCard.Staging_Job_Role__c == null && rateCard.Job_Role_ID__c != null) ||
					(rateCard.Staging_Job_Role__c != null && rateCard.Job_Role_ID__c != null)
                ) &&
                !allowedProfileNames.contains(prof[0].name) &&
				rateCard.IP_AcountLinkCustom__r.Managed_Account__c == true
            ) {
                cannotDeleteRateCardIds.add(rateCard.Id);
			}
		}

        for(sirenum__Rate_Card_Page__c ratePageRec :ratePgNewList) {
			if(checkAccountMap.containsKey(ratePageRec.sirenum__Rate_Card__c)) {
                ratePageRec.addError('For managed account, you do not have permission to perform this action.');
            }
            else if(nonManaged.contains(ratePageRec.sirenum__Rate_Card__c) && ratePageRec.sirenum__SortOrder__c == 0) {
				ratePageRec.addError('You do not have permission to perform this action.');
            }
			else if(managedBack.contains(ratePageRec.sirenum__Rate_Card__c) && ratePageRec.sirenum__SortOrder__c == 0) {
				ratePageRec.addError('For managed account, you do not have permission to perform this action.');
            }
            else if(cannotDeleteRateCardIds.contains(ratePageRec.sirenum__Rate_Card__c)) {
                ratePageRec.addError('You do not have permission to perform this action.');
            }
        }
    }

	/*
    public static void accountUserConditionInsert(List<sirenum__Rate_Card_Page__c> ratePgNewList){
        Id userId = UserInfo.getUserId();
        List<Id> RatePgId = new List<Id>();
        Map<Id,Boolean> checkAccountMap = new Map<Id,Boolean>();
        List<user> userInProf = [select id , ProfileId ,Profile.name from user where Profile.name in ('Back Office','JS Admin tier 1','System Administrator') and id=:userId];
        for(sirenum__Rate_Card_Page__c RateId :ratePgNewList)
        {
            RatePgId.add(RateId.sirenum__Rate_Card__c);
        }
        for(sirenum__Rate_Card__c RatePage :[select Id ,IP_AcountLinkCustom__r.Managed_Account__c  from sirenum__Rate_Card__c where Id in:RatePgId]) 
        {
            if((RatePage.IP_AcountLinkCustom__r.Managed_Account__c ==true) && userInProf.isEmpty())
            {
                if(!checkAccountMap.containsKey(RatePage.Id)){
                    checkAccountMap.put(RatePage.Id,true);
                }
            }
        }
        for(sirenum__Rate_Card_Page__c RatePageRec :ratePgNewList )
        {
            if(checkAccountMap.containsKey(RatePageRec.sirenum__Rate_Card__c))
                RatePageRec.addError('For Managed Account , You do not have permission to perform this action');     
            
        }
        
    }
    public static void validationmessage(List<sirenum__Rate_Card_Page__c> ratePgNewList){
        list<id> recid =new list<id>();
        for(sirenum__Rate_Card_Page__c ratecard : ratePgNewList )
        {
            recid.add(ratecard.id);
        } 
        list<sirenum__Rate_Line__c> reclist =[select id,sirenum__Overtime_Pay_Rate__c,sirenum__Overtime_Charge_Rate__c 
                                              from sirenum__Rate_Line__c where sirenum__Rate_Card_Page__c in :recid];
        
        try{
            update reclist;
        }
        catch(exception e)
        {
            string msg = string.valueof(e.getMessage());
            if(msg.contains('Overtime Pay and Charge must be populated with a value, if overtime is selected'))
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Overtime Pay and Charge must be populated with a value, if overtime is selected.'));
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,msg));
            }
            
        }
    }
    */
}