public class portalV2VMSClientJobOrdercontroller {
	 @AuraEnabled
    public static List<Portal_V2_JobOrder_Adjust_Columns__mdt> fetchAdjustableColumns() {
        List<Portal_V2_JobOrder_Adjust_Columns__mdt> theCustomMetadata = [
            SELECT
            Display_Order__c,
            MasterLabel,
            DeveloperName,
            Field_API_Name__c,
            Selected_By_Default__c,
            Filterable__c,
            Filter_Type__c,
            Field_Display_Type__c
            FROM Portal_V2_JobOrder_Adjust_Columns__mdt
            ORDER BY Display_Order__c ASC
        ];
        return theCustomMetadata;
    }

	  @AuraEnabled(cacheable=true)
    public static List<sirenum__JobOrder__c > getAllJobOrders() {
       Id currentUserId = UserInfo.getUserId();
        User currentUser = [SELECT Id, ContactId FROM User WHERE Id =: currentUserId];
        Contact userContact = [SELECT Id, AccountId FROM Contact WHERE Id =: currentUser.ContactId];
        Id accountId = userContact.AccountId;
       return [
            SELECT Id,sirenum__Site__c, sirenum__Account__c,Job_Order_Number__c, Total_Resource_Required__c,sirenum__JobRole__c,sirenum__StartDate__c,sirenum__EndDate__c,sirenum__Status__c,sirenum__JobRole__r.Minimum_Pay__c,
            sirenum__Site__r.Name, sirenum__Site__r.Parking_information__c,sirenum__Site__r.Who_to_meet_on_arrival__c,sirenum__Site__r.Public_Transport_Information__c, sirenum__Account__r.Name, sirenum__JobRole__r.Name,
		    Name, Override__c,Quantity__c,Total_Supplier_Flat_Fee__c,Management_Fee_hr__c,JobRoleMinimum__c,Total_Client_Rate__c,
			sirenum__RateCard__c,sirenum__RateCard__r.name,sirenum__JobRole__r.IP_Notified_Health_Safety_Risks__c,sirenum__JobRole__r.IP_Job_Description__c,sirenum__WorkSchedule__c
			FROM sirenum__JobOrder__c 
            WHERE sirenum__Account__c  =:accountId  AND sirenum__Status__c='Ongoing' ORDER BY createddate DESC
        ];
    }
    
    
}