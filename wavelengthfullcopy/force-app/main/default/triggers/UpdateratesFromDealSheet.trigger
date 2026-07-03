/*Author: Ranjith
* Trigger Name : UpdateratesFromDealSheet
* Description: Trigger to Update field values on Placement from DealSheet
*/
trigger UpdateratesFromDealSheet on AVTRRT__Placement__c (before insert, before update, after insert, after update) {
    /*
if(!AVTRRT__Config_Settings__c.getInstance('Default').Enable_UpdateratesFromDealSheet__c) {
return;
}   
UpdateratesFromDealSheetHelper helper = new UpdateratesFromDealSheetHelper();
helper.updateRates(trigger.new, false);
*/
    if (Trigger.isBefore) {
        if(!AVTRRT__Config_Settings__c.getInstance('Default').Enable_UpdateratesFromDealSheet__c) {
            return;
        }
        UpdateratesFromDealSheetHelper helper = new UpdateratesFromDealSheetHelper();
        helper.updateRates(trigger.new, false);
    }
    
    
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            if(!TR_CustomSettings__c.getInstance().Disable_Placement_CredentialRequirements__c) {
            PlacementTriggerHelper.handleInsert(Trigger.new);
        }
            
        }
        
      /*  if (Trigger.isUpdate) {
            PlacementTriggerHelper.handleUpdate(Trigger.oldMap, Trigger.new); https://targetrecruit.atlassian.net/browse/WAVE-380 , 
commneting as we are implementing button as per chnage request(09/12/2024)
        }*/
    }
}