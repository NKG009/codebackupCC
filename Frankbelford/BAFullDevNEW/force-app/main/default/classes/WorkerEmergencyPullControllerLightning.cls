/**********************************************************************************************
* @Author:         Espire
* @Date:           15/08/2019
* @Description:    This class is used to update Pay Profile Emergency  Details. 
* @Requirement Id:  JPC-1983
* @Test Class:     
* @Revision(s):    [Date] - [Change Reference] - [Changed By] - [Description]
**********************************************************************************************/
public class WorkerEmergencyPullControllerLightning {
	/*
    * Method Name: payProfileDetailsUpdate
    * Description: To update profile record
    * Parameters : String payProfileId
    * Return Type: String
    * Date : 29/08/2019
    */
	@AuraEnabled
	public Static String payProfileDetailsUpdate(String payProfileId){
		Id loggedInUserProfileid = Userinfo.getProfileId();
		Profile profile = [Select id, Name from Profile where Id=:loggedInUserProfileid];
		if(profile.Name.equals('JS Recruiter - Hybrid')){
			return 'recruiterUser'; 
		}
		else{
			IP_PayProfile__c payProfile = new IP_PayProfile__c(id=payProfileId);
			payProfile.IP_EmergencyPull__c = true; 
			payProfile.IP_PassToTempest__c = true; 
			try{
				update payProfile;
				return 'successMessage';
			}
			catch(Exception e){
                String message = e.getmessage();                message = message.substringAfter(',');            	message = message.substringBefore(':');
				return message;
			}
		}
	}
}