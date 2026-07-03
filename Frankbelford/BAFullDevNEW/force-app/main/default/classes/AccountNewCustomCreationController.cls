/**
* @File Name : AccountNewCustomCreationController.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : April 17, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | April 17, 2025 |   | Initial Version
**/

public class AccountNewCustomCreationController {

	@AuraEnabled
	public static List<RecordType> fetchAllRecordType(String objName){
		return [SELECT Id, Name, SobjectType, DeveloperName FROM RecordType WHERE SobjectType=:objName AND IsActive=true];
	}

	@AuraEnabled
	public static Id fetchRecordTypeId(String recordTypeName){
		return [SELECT Id, Name, SobjectType, IsActive FROM RecordType WHERE Name =:recordTypeName LIMIT 1 ].Id;
	}
    
    @AuraEnabled
    public static String fetchUserInfo(){
        String ProfileName = [SELECT Id, Name, ProfileId, Profile.Name FROM User WHERE Id =: userInfo.getUserId()].Profile.Name;
        return ProfileName;
    }
    
    @AuraEnabled
    public static List<String> fetchRTPermission(String objName){
        System.debug('======================== objName : '+objName);
        List<String> lstOption = new List<String>(); 
        Schema.SObjectType sObjType = Schema.getGlobalDescribe().get('Account');
        Schema.DescribeSObjectResult describeResult = sObjType.getDescribe();
        for(RecordTypeInfo info: describeResult.getRecordTypeInfos()) {
            System.debug('================== info : '+info);
            if(info.isAvailable() && info.getName() != 'Master') {
                lstOption.add(info.getName());
            }
        } 
        System.debug('================== lstOption : '+lstOption);
        return lstOption;
    }
}