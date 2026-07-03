/*
* Class Name: UpdateDivisionOnSPlacementHandler
* Description: Incident - 11081
* Test Class: TestUpdateDivisionOnSPlacementHandler
* Date : 20th March 2020
*/
public class UpdateDivisionOnSPlacementHandler{
    
    /*
    * Method Name: handleBeforeUpdate
    * Description: To Process all record
    * Parameters : Map<Id, SObject> newItems, Map<Id, SObject> oldItems
    * Return Type: void
    * Date : 20th March 2020
    */
    public static void handleBeforeUpdate(Map<Id, sirenum__Placement__c> newItems, Map<Id, sirenum__Placement__c> oldItems) {
        Map<String,IP_BranchStatus__c> mapUserIdUserProfile = new Map<String,IP_BranchStatus__c>();
        
        for(IP_BranchStatus__c branchStatus : [Select id,IP_BranchID__c,IP_Division__c,IP_Payroll_to_Process__c,
                                                IP_Region__c,IP_Status__c from IP_BranchStatus__c]){
            mapUserIdUserProfile.put(branchStatus.IP_BranchID__c,branchStatus);
        }
        
        for(sirenum__Placement__c splacement : newItems.values()){
            if(String.IsNotBlank(splacement.IP_Costcode__c) && splacement.IP_Costcode__c!=olditems.get(splacement.id).IP_Costcode__c){
                if(!mapUserIdUserProfile.isEmpty() && mapUserIdUserProfile.containskey(splacement.IP_Costcode__c) && mapUserIdUserProfile.get(splacement.IP_Costcode__c).IP_Division__c!=null){
                    splacement.IP_Division__c = mapUserIdUserProfile.get(splacement.IP_Costcode__c).IP_Division__c;
                }
            }
        }
    }
    
     /*
    * Method Name: handleBeforeInsert
    * Description: To Process all record
    * Parameters : List<sirenum__Placement__c> listSPlacement
    * Return Type: void
    * Date : 20th March 2020
    */
    public static void handleBeforeInsert(List<sirenum__Placement__c> listSPlacement) {
        Map<String,IP_BranchStatus__c> mapUserIdUserProfile = new Map<String,IP_BranchStatus__c>();
        
        for(IP_BranchStatus__c branchStatus : [Select id,IP_BranchID__c,IP_Division__c,IP_Payroll_to_Process__c,
                                                IP_Region__c,IP_Status__c from IP_BranchStatus__c]){
            mapUserIdUserProfile.put(branchStatus.IP_BranchID__c,branchStatus);
        }
        
        for(sirenum__Placement__c splacement : listSPlacement){
            if(String.IsNotBlank(splacement.IP_Costcode__c)){
                if(!mapUserIdUserProfile.isEmpty() && mapUserIdUserProfile.containskey(splacement.IP_Costcode__c) && mapUserIdUserProfile.get(splacement.IP_Costcode__c).IP_Division__c!=null){
                    splacement.IP_Division__c = mapUserIdUserProfile.get(splacement.IP_Costcode__c).IP_Division__c;
                }
            }
        }
    }
}