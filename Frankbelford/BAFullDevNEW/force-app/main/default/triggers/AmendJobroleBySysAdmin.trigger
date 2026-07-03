/*
* Class Name: AmendJobroleBySysAdmin.
* Description: JPC- 1347 - Lock Down Sector, Job Category and AWR Group in Job Role View
* Test Class: 
* Date : 18th June 2019
*/
trigger AmendJobroleBySysAdmin on sirenum__Team__c (before update,after update) {
    
    if(Trigger.isBefore||Trigger.isUpdate){
        AmendJobroleBySysAdminHandler.handleBeforeUpdate(trigger.newMap, trigger.oldMap);
    }
}