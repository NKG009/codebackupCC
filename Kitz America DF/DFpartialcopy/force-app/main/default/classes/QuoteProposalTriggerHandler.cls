/************************************
* Name : QuoteProposalTriggerHandler
* Description : Class to handle trigger events.
* 				 Methods of "QuoteProposalTriggerHelper" class will be called to perform actions.
************************************/

public class QuoteProposalTriggerHandler {
    
    //Method that gets called before inserting record through trigger.
    public static void onBeforeInsert(List<Apttus_Proposal__Proposal__c> newProposalList) {
        QuoteProposalTriggerHelper helper = new QuoteProposalTriggerHelper();
        helper.Setproposalvalues(newProposalList);
        helper.setAccountDetailsMap(newProposalList);
        helper.defaultPriceListOnProposalHeader(newProposalList);
        helper.populateFieldsFromSoldToAccount(newProposalList, null);
        helper.populateFieldsFromShipToAccount(newProposalList, null);
    }
    
    //Method that gets called before updating record through trigger.
    public static void onBeforeUpdate(Map<Id, Apttus_Proposal__Proposal__c> newProposalMap, Map<Id, Apttus_Proposal__Proposal__c> oldProposalMap) {
        QuoteProposalTriggerHelper helper = new QuoteProposalTriggerHelper();
        
        helper.setAccountDetailsMap(newProposalMap.values());
        helper.populateFieldsFromSoldToAccount(newProposalMap.values(), oldProposalMap);
        helper.populateFieldsFromShipToAccount(newProposalMap.values(), oldProposalMap);
        helper.updateApprovalStageOnCartFinalization(newProposalMap.values(), oldProposalMap);
        helper.setLineItemValues(newProposalMap.values(), oldProposalMap);

    }
    
    // Method that gets called after updating record through trigger.
    public static void onAfterUpdate(Map<Id, Apttus_Proposal__Proposal__c> newProposalMap, Map<Id, Apttus_Proposal__Proposal__c> oldProposalMap) {
        QuoteProposalTriggerHelper helper = new QuoteProposalTriggerHelper();
            

        //helper.callAcceptedproposalwebservice(newProposalMap.values(), oldProposalMap); 
        
        //helper.SetProductConfigvalues(newProposalMap.values(), oldProposalMap);
    }
}