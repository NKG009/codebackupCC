/*
* Class Name: ResetPasswordController
* Description: JPC-2570
* Test Class: TestResetPasswordController
* Date : 21st May 2020
*/
public class ResetPasswordController{
    
    /*
    * Method Name: resetPasswordForClient
    * Description: To reset the password for Client
    * Parameters : List<sirenum__Timesheet_line__c> listTimesheetLine
    * Return Type: void
    * Date : 21st May 2020
    */
    @AuraEnabled
    public static String resetPasswordForClient(String contactId) {
        String customerPortalUserProfile = System.Label.Client_Portal_User_Profile;
        String userPortal = System.Label.Candidate_Portal_User_Portal;
        List<Contact> listContact = [Select id,Email from Contact where id=:contactId limit 1];
        if(!listContact.isEmpty() && listContact!=null){
            if(String.IsBlank(listContact[0].Email)){
                return 'emailBlankMessage';
            }
            else{
                List<User> listUser = [Select id,Username from User where username=:listContact[0].Email and IsActive=true
                                        and (Profile.Name=: customerPortalUserProfile OR Profile.Name =: userPortal) and
                                        ContactId =:listContact[0].Id limit 1];
                if(!listUser.isEmpty() && listUser!=null){              
                    System.resetPassword(listUser[0].Id, true);
                    return 'passwordReset';
                }
                else{
                    return 'userNotSetUp';
                }
            }
        }
        return null;
    }
}