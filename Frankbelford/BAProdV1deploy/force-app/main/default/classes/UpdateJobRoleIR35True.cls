/*
* Class Name: UpdateJobRoleIR35True
* Description: Class to update IR35 to true if Public Sector field on Site is set to No
* Test Class : TestUpdateJobRoleIR35True
*/
public class UpdateJobRoleIR35True{
    
    /*
    * Method Name: updateJobRoleIR35
    * Description: Method to update IR35 to true if Public Sector field on Site is set to No
    * Parameters : List<String> listAccountId
    * Return Type: nothing
    */
    @InvocableMethod
    public static void updateJobRoleIR35(List<String> listAccountId){
        List<sirenum__Team__c> listJobRoleUpdate = new List<sirenum__Team__c>();
        try{
            if(!listAccountId.isEmpty()){
                for(sirenum__Team__c jobRole : [Select id,IP_OPWIPSRole__c,sirenum__Account__r.sirenum__Client__c 
                                                from sirenum__Team__c where sirenum__Account__r.sirenum__Client__c IN:listAccountId]){
                    jobRole.IP_OPWIPSRole__c = 'Yes';
                    listJobRoleUpdate.add(jobRole);
                }
                if(!listAccountId.isEmpty()){    
                    update listJobRoleUpdate;
                }
            }
        }
        catch(Exception e) {
            system.debug('++++++++++++++'+e);
        }
    }
    
}