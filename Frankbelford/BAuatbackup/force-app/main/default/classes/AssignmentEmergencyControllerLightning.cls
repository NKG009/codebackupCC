/**********************************************************************************************
* @Author:         Espire
* @Date:           17/09/2019
* @Description:    This class is used to update S-placement  Details. 
* @Requirement Id:  JPC-1987
* @Test Class:     Test_AssignmentEmergencyLightning
* @Revision(s):    [Date] - [Change Reference] - [Changed By] - [Description]
**********************************************************************************************/
public class AssignmentEmergencyControllerLightning {
/*
    * Method Name: sPlacementDetailsUpdate
    * Description: To update S-Placement Details
    * Parameters : String sPlacementId
    * Return Type: String
    * Date : 17/09/2019
    */
	@AuraEnabled
	public Static String sPlacementDetailsUpdate(String sPlacementId){
		Id loggedInUserProfileid = Userinfo.getProfileId();
		Profile profile = [Select id, Name from Profile where Id=:loggedInUserProfileid];
		if(profile.Name.equals('JS Recruiter - Hybrid')){
			return 'recruiterUser';
		}
		else{
			sirenum__Placement__c sPlacement = new sirenum__Placement__c(id=sPlacementId);
			sPlacement.IP_EmergencyPull__c = true; 
			sPlacement.IP_PassToTempest__c = true; 
			try{
                system.debug('+++++sPlacement+++'+sPlacement);
				update sPlacement;
                system.debug('+++++sPlacement+++'+sPlacement.IP_EmergencyPull__c);
                system.debug('+++++sPlacement+++'+sPlacement.IP_PassToTempest__c);
				return 'successMessage';
			}
			catch(Exception e){
				String message = e.getmessage();                message = message.substringAfter(',');            	message = message.substringBefore(':');				return message;
			}
		}
	}
}