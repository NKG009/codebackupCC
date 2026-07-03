/*Author: Abu Talib(14/12/23)
* Trigger Name : updateRatesFromDealSheetToJobTrigger
* Description: Trigger to Update field values on job object from DealSheet
* https://targetrecruit.atlassian.net/browse/UPP-44
*/
trigger updateRatesFromDealSheetToJobTrigger on AVTRRT__Job__c (after insert,after update,before insert) {
    if(AVTRRT__Config_Settings__c.getInstance('Default').Enable_UpdateratesFromDealSheetToJob__c) {
        //return;
        
        if((trigger.isafter && trigger.isInsert) || (trigger.isafter && trigger.isUpdate)){
            UpdateratesFromDealSheetToJobHelper helper = new UpdateratesFromDealSheetToJobHelper();
            helper.updateRates(trigger.new, false);
            
        }
    }
    // Commenting out because it is clearing important fields
    /*
    if (Trigger.isBefore && Trigger.isInsert) {
        for (AVTRRT__Job__c job : Trigger.new) {
            job.Category__c = null;
            job.Specialty_NEW__c = null;
            job.Seniority_NEW__c = null;
            job.Sub_Specialty_New__c = null;
            job.Job_Attribute__c = null;
            job.Employment_Preference__c = null;
        }
    }
    */
}