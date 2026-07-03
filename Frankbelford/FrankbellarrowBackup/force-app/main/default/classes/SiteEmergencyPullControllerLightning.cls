/**********************************************************************************************
* @Author:         Espire
* @Date:           15/08/2019
* @Description:    This class is used to update Site Emergency Pull Details. 
* @Requirement Id:  JPC-1986
* @Test Class:     
* @Revision(s):    [Date] - [Change Reference] - [Changed By] - [Description]
**********************************************************************************************/
public class SiteEmergencyPullControllerLightning {
	
	/*
    * Method Name: siteDetailsUpdate
    * Description: To update site record
    * Parameters : String siteId
    * Return Type: String
    * Date : 15/08/2019
    */
	@AuraEnabled
	public Static String siteDetailsUpdate(String siteId){
		Id loggedInUserProfileid = Userinfo.getProfileId();
		Profile profile = [Select id, Name from Profile where Id=:loggedInUserProfileid];
		if(profile.Name.equals('JS Recruiter - Hybrid')){
			return 'recruiterUser';
		}
		else{
			sirenum__Site__c site = new sirenum__Site__c(id=siteId);
			site.IP_EmergencyPullClientAddress__c = true; 
			site.IP_EmergencyPullClient__c = true; 
			site.IP_PassClientAddressToTempest__c = true; 
			site.IP_PassClientToTempest__c = true;
			try{
				update site;
				return 'successMessage';
			}
			catch(Exception e){
				String message = e.getmessage();                 message = message.substringAfter(',');				return message;
			}
		}
	}
}