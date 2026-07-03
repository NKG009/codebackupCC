/*
* Class Name: AmendJobroleBySysAdminHandler
* Description: JPC- 1347 - Lock Down Sector, Job Category and AWR Group in Job Role View
                Handler Class of AmendJobroleBySysAdmin Trigger
* Test Class: 
* Date : 18th June 2019
*/
public class AmendJobroleBySysAdminHandler{
    
    /*
    * Method Name: handleBeforeUpdate
    * Description: To Process all record
    * Parameters : Map<Id, SObject> newItems, Map<Id, SObject> oldItems
    * Return Type: void
    * Date : 18th June 2019
    */
    public static void handleBeforeUpdate(Map<Id, sirenum__Team__c> newItems, Map<Id, sirenum__Team__c> oldItems) {
        List<String> jobProfileList = new List<String>();
        Set<Id> setJobRoleId = new Set<Id>();
        Map<Id,Integer> mapJobRoleIdShiftSize = new Map<Id,Integer>();
        Map<Id,String> mapUserIdUserProfile = new Map<Id,String>();
        
        for(JobRoleProfileList__c jobRoleProfile : JobRoleProfileList__c.getall().values()){
            jobProfileList.add(jobRoleProfile.Name);
        }
        
        for(User user :[Select id , ProfileId, Profile.Name from User where Id=:UserInfo.getUserId()]){
            mapUserIdUserProfile.put(user.id,user.Profile.Name);
        }
        
        for(sirenum__Team__c jobRole : newItems.values()){
            if(jobRole.sirenum__Job_Type__c!=olditems.get(jobRole.id).sirenum__Job_Type__c || jobRole.sirenum__Rota__c!=olditems.get(jobRole.id).sirenum__Rota__c){
                setJobRoleId.add(jobRole.id);
            }
        }
        
        //List<sirenum__Team__c> listJobRole = [Select id,sirenum__Job_Type__c,sirenum__Rota__c,(Select id from sirenum__Shifts__r where sirenum__Published__c=True and sirenum__Cancelled__c=false) from sirenum__Team__c where Id IN :newItems.keyset()];
        List<sirenum__Team__c> listJobRole = [Select id,sirenum__Job_Type__c,sirenum__Rota__c,(Select id,sirenum__Timesheet_summaries__c from sirenum__Shifts__r where sirenum__Timesheet_summaries__c!=null) from sirenum__Team__c where Id IN :setJobRoleId];    
        for(sirenum__Team__c jobRole : listJobRole){            
            if(jobProfileList.contains(mapUserIdUserProfile.get(UserInfo.getUserId()))){
                if(!jobRole.sirenum__Shifts__r.isEmpty() && jobRole.sirenum__Shifts__r!=null){
                    mapJobRoleIdShiftSize.put(jobRole.id,jobRole.sirenum__Shifts__r.size());
                }
            }
        }
        
        for(sirenum__Team__c jobRole : newItems.values()){
            if(!mapJobRoleIdShiftSize.isEmpty() && mapJobRoleIdShiftSize.get(jobRole.id)!=null){
                jobRole.addError(Label.JobRoleErrorMessage);
            }
        }
    }
}