/**************************************
* Name : QuoteProposalTriggerHelper
* Description : Class to perform operations for trigger events received by "QuoteProposalTrigger".
**************************************/

public class QuoteProposalTriggerHelper {
    
    private Map<String, Account> accountDetailsMap;    
    
    //Default constructor to perform initialization.
    public QuoteProposalTriggerHelper() {
        
    }
    
    // Method to populate Approval Stage to Draft on Creation
    public void Setproposalvalues(List<Apttus_Proposal__Proposal__c> newProposalList) {        
        for(Apttus_Proposal__Proposal__c newProposal : newProposalList) {
            if(newProposal.isClone()){
                newProposal.Apttus_Proposal__Approval_Stage__c = 'Draft';
            }
        }
    }
    
    // Method to set map of account details associated with Sold-To and Ship-To accounts of given list of proposals.
    public void setAccountDetailsMap(List<Apttus_Proposal__Proposal__c> proposalList) {
        accountDetailsMap = new Map<String, Account>(getAccountDetailsList(getAccountIdSet(proposalList)));
    }
    
    // Method to get set of IDs of Sold-To and Ship-To accounts of given list of Proposal records.
    private Set<String> getAccountIdSet(List<Apttus_Proposal__Proposal__c> proposalList) {
        Set<String> accountIdSet = new Set<String>();
        
        for(Apttus_Proposal__Proposal__c proposal : proposalList) {
            
            if(String.isNotBlank(proposal.Apttus_Proposal__Account__c)) {
                accountIdSet.add(proposal.Apttus_Proposal__Account__c);
            }
            
            if(String.isNotBlank(proposal.Apttus_QPConfig__ShipToAccountId__c)) {
                accountIdSet.add(proposal.Apttus_QPConfig__ShipToAccountId__c);
            }
        }
        
        return accountIdSet;
    }
    
    //Method to get list of account details for given set of account IDs.
    private List<Account> getAccountDetailsList(Set<String> accountIdSet) {
        List<Account> accountDetailsList = [SELECT Id, Name, AccountNumber, BillingStreet, BillingCity, BillingState,
                                            BillingPostalCode, BillingCountry, APTS_Billing_Address_Line_2__c, APTS_Pricing_Notes__c
                                            FROM Account
                                            WHERE Id IN :accountIdSet];
        
        return accountDetailsList;
    }
    
    // Method to populate default price list of header when Quote is created.
    public void defaultPriceListOnProposalHeader(List<Apttus_Proposal__Proposal__c> newProposalList) {
        String defaultPriceListId = [SELECT Id FROM Apttus_Config2__PriceList__c WHERE Name = 'Standard USD PriceList'].Id;
        system.debug('defaultPriceListId'+defaultPriceListId);
        for(Apttus_Proposal__Proposal__c newProposal : newProposalList) {
            newProposal.Apttus_QPConfig__PriceListId__c = defaultPriceListId;
            newProposal.Apttus_QPConfig__ReadyForFulfillmentDate__c=system.now();
            /* Set Project Order Sub Type to default Actual product on insert if Sales Order Type is Project Order */
            if(newProposal.APTS_Sales_Order_Type__c == 'Project Order'){
                newProposal.APTS_Project_Order_Sub_Type__c = 'Actual Product';
                
            }
        }
    }   
    
    // Method to populate fields from Sold To account when it is changed.
    public void populateFieldsFromSoldToAccount(List<Apttus_Proposal__Proposal__c> newProposalList, Map<Id, Apttus_Proposal__Proposal__c> oldProposalMap) {
        
        for(Apttus_Proposal__Proposal__c newProposal : newProposalList) {
            Apttus_Proposal__Proposal__c oldProposal = oldProposalMap != null ? oldProposalMap.get(newProposal.Id) : null;
            
            String accountId = newProposal.Apttus_Proposal__Account__c;
            
            if(oldProposal == null || isChanged('Apttus_Proposal__Account__c', newProposal, oldProposal)) {
                Account soldToAccount = (accountDetailsMap != null && accountDetailsMap.containsKey(accountId)) ? accountDetailsMap.get(accountId) : null;
                
                newProposal.APTS_Sold_To_Acct_Number__c = soldToAccount != null ? soldToAccount.AccountNumber : null;
                newProposal.APTS_Pricing_Notes__c = soldToAccount != null ? soldToAccount.APTS_Pricing_Notes__c : null;
            }
        }
    }
    
    //Method to populate fields from Ship To account when it is changed.
    public void populateFieldsFromShipToAccount(List<Apttus_Proposal__Proposal__c> newProposalList, Map<Id, Apttus_Proposal__Proposal__c> oldProposalMap) {
        
        for(Apttus_Proposal__Proposal__c newProposal : newProposalList) {
            Apttus_Proposal__Proposal__c oldProposal = oldProposalMap != null ? oldProposalMap.get(newProposal.Id) : null;
            
            String shipToAccountId = newProposal.Apttus_QPConfig__ShipToAccountId__c;
            
            if(oldProposal == null || isChanged('Apttus_QPConfig__ShipToAccountId__c', newProposal, oldProposal)) {
                Account shipToAccount = (accountDetailsMap != null && accountDetailsMap.containsKey(shipToAccountId)) ? accountDetailsMap.get(shipToAccountId) : null;
                
                newProposal.APTS_Ship_To_Name__c = shipToAccount != null ? shipToAccount.Name : null;
                newProposal.APTS_Ship_To_Acct_Number__c = shipToAccount != null ? shipToAccount.AccountNumber : null;
                newProposal.APTS_Ship_To_Addr_1__c = shipToAccount != null ? shipToAccount.BillingStreet : null;
                newProposal.APTS_Ship_To_Addr_2__c = shipToAccount != null ? shipToAccount.APTS_Billing_Address_Line_2__c : null;
                newProposal.APTS_Ship_To_City__c = shipToAccount != null ? shipToAccount.BillingCity : null;
                newProposal.APTS_Ship_To_State__c = shipToAccount != null ? shipToAccount.BillingState : null;
                newProposal.APTS_Ship_to_Region__c = shipToAccount != null ? shipToAccount.BillingState : null;
                newProposal.APTS_Ship_to_ZipCode__c = shipToAccount != null ? shipToAccount.BillingPostalCode : null;
                newProposal.APTS_Ship_to_Country__c = shipToAccount != null ? shipToAccount.BillingCountry : null;
            }
        }
    }
    
    // Method to set Approval Stage to Approved when cart is finalized.
    public void updateApprovalStageOnCartFinalization(List<Apttus_Proposal__Proposal__c> newProposalList, Map<Id, Apttus_Proposal__Proposal__c> oldProposalMap) {
        
        for(Apttus_Proposal__Proposal__c newProposal : newProposalList) {
            Apttus_Proposal__Proposal__c oldProposal = oldProposalMap != null ? oldProposalMap.get(newProposal.Id) : null;
            
            if(oldProposal != null && isChanged('Apttus_QPConfig__ConfigurationFinalizedDate__c', newProposal, oldProposal) && 'Draft'.equals(newProposal.Apttus_Proposal__Approval_Stage__c)) {
                newProposal.Apttus_Proposal__Approval_Stage__c = 'Approved';
            }
        }
    }
    
    // Method to call webservice
    public void callAcceptedproposalwebservice(List<Apttus_Proposal__Proposal__c> newProposalList, Map<Id, Apttus_Proposal__Proposal__c> oldProposalMap) {
        
        for(Apttus_Proposal__Proposal__c newProposal : newProposalList) {
            Apttus_Proposal__Proposal__c oldProposal = oldProposalMap.get(newProposal.Id);            
            
            if(isChanged('Apttus_Proposal__Approval_Stage__c', newProposal, oldProposal) && 'Accepted'.equals(newProposal.Apttus_Proposal__Approval_Stage__c) 
               && 'Approved'.equals(oldProposal.Apttus_Proposal__Approval_Stage__c)) {
                   Apttus_QPConfig.QPConfigWebService.acceptQuote(newProposal.Id);
                   system.debug('ProposalId'+newProposal.Id);
               }
        }
    }
    
    // Method to set line item values
    public void setLineItemValues(List<Apttus_Proposal__Proposal__c> newProposalList, Map<Id, Apttus_Proposal__Proposal__c> oldProposalMap) {
        set<id>proposalids = new set<id>();
        map<id,Apttus_Config2__ProductConfiguration__c> configurationDetailsmap = new map<id,Apttus_Config2__ProductConfiguration__c> ();
        list<Apttus_Config2__LineItem__c> lineItemList = new list<Apttus_Config2__LineItem__c>();
        list<Apttus_Config2__LineItem__c> newlineItemList = new list<Apttus_Config2__LineItem__c>();
        
        for(Apttus_Proposal__Proposal__c newProposal : newProposalList) {
            Apttus_Proposal__Proposal__c oldProposal = oldProposalMap.get(newProposal.Id);  
            
            if(isChanged('APTS_Sales_Order_Type__c', newProposal, oldProposal) && 'Project Order'.equals(newProposal.APTS_Sales_Order_Type__c) ) {
                proposalids.add(newProposal.id);
                system.debug('proposalids'+proposalids);
                
            }
        }//for()
        
        if(proposalids.size() > 0){
            configurationDetailsmap =new map<id,Apttus_Config2__ProductConfiguration__c> ([SELECT Id, Apttus_QPConfig__Proposald__c 
                                                                                           FROM Apttus_Config2__ProductConfiguration__c 
                                                                                           WHERE Apttus_QPConfig__Proposald__c IN :proposalids 
                                                                                           AND (Apttus_Config2__Status__c = 'New' OR Apttus_Config2__Status__c = 'Saved')]);       
        }
        
        if(configurationDetailsmap.size() > 0){
            lineItemList = [select id, APTS_Warehouse_Number__c, APTS_Warehouse_Name__c, APTS_Warehouse_Location__c, APTS_Item_Category__c
                            from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c IN :configurationDetailsmap.keyset()];            
        }
        
        if(lineItemList.size() > 0){
            for(Apttus_Config2__LineItem__c lineItem : lineItemList) {
                lineItem.APTS_Warehouse_Number__c = '3099';
                lineItem.APTS_Warehouse_Name__c = 'In Transit';
                lineItem.APTS_Warehouse_Location__c = null;
                lineItem.APTS_Item_Category__c = 'Project w/ Spec';
                newlineItemList.add(lineItem);
            }
            system.debug('newlineItemList size'+newlineItemList.size());
            update newlineItemList;
        }
        
    }
    
    //Method to identify if value of given field is changed.
    private Boolean isChanged(String fieldName, SObject newRecord, SObject oldRecord) {
        if(newRecord != null && oldRecord != null && newRecord.get(fieldName) != oldRecord.get(fieldName)) {
            return TRUE;
        } else {
            return FALSE;
        }
    }
}