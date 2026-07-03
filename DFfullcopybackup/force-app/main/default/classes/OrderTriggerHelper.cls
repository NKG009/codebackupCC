/****************************
* Name : OrderTriggerHelper
* Description : Class to perform operations on trigger events on order object record.
* Created By: Sumit Mishra
* Created Date: 14-04-2020
* Last Modified Date: 14-04-2020
****************************/

public class OrderTriggerHelper {
    
    private Map<Id, Apttus_Proposal__Proposal__c> proposalDetailsMap;
    
    //Method to set map of Quote/Proposal records available on given list of Order records.
    public void setProposalDetailsMap(List<Apttus_Config2__Order__c> newOrderList) {
        proposalDetailsMap = new Map<Id, Apttus_Proposal__Proposal__c>(getProposalDetailsList(getProposalIdSet(newOrderList)));
    }
    
    //Method to get set of Quote/Proposal ID from give list of Order records.
    private Set<Id> getProposalIdSet(List<Apttus_Config2__Order__c> newOrderList) {
        Set<Id> proposalIdSet = new Set<Id>();
        
        for(Apttus_Config2__Order__c order : newOrderList) {
            if(String.isNotBlank(order.Apttus_QPConfig__ProposalId__c)) {
                proposalIdSet.add(order.Apttus_QPConfig__ProposalId__c);
            }
        }
        
        return proposalIdSet;
    }
    
    //Method to get list of Quote/Proposal records with their details for given set of Quote/Proposal IDs.
    private List<Apttus_Proposal__Proposal__c> getProposalDetailsList(Set<Id> proposalIdSet) {
        List<Apttus_Proposal__Proposal__c> proposalDetailsList = [SELECT Id, Name, Apttus_Proposal__Proposal_Name__c, Apttus_QPConfig__ShipToAccountId__c,
                                                                  Apttus_QPConfig__PricingDate__c, Apttus_Proposal__Primary_Contact__c,
                                                                  Apttus_QPConfig__PriceListId__c, APTS_Sold_To_Acct_Number__c, APTS_Quote_Date__c,
                                                                  APTS_Ship_To_Acct_Number__c, APTS_Complete_Dlvry__c, APTS_Email__c,
                                                                  APTS_Inquiry_Number__c, APTS_Total_Net_Price__c, APTS_Total_Ext_Cost__c,
                                                                  APTS_Sales_Order_Type__c, APTS_Consignee_PO_Num__c, APTS_Ship_To_Name__c,
                                                                  APTS_Ship_To_Addr_1__c, APTS_Ship_To_Addr_2__c, APTS_Ship_To_City__c,
                                                                  APTS_Ship_To_State__c, APTS_Ship_to_ZipCode__c, APTS_Ship_to_Country__c,
                                                                  APTS_Ship_to_Region__c, APTS_Freight_Terms__c, APTS_Whse_Instr__c,
                                                                  APTS_Pricing_Notes__c, APTS_Total_Ext_Profit__c, APTS_Total_Ext_Profit_Percent__c,
                                                                  Apttus_QPConfig__PONumber__c
                                                                  FROM Apttus_Proposal__Proposal__c
                                                                  WHERE Id IN :proposalIdSet];
        
        return proposalDetailsList;
    }
    
    //Method to populate values on Order record from Proposal.
    public void populateValuesOnOrder(List<Apttus_Config2__Order__c> newOrderList) {
        
        for(Apttus_Config2__Order__c order : newOrderList) {
            
            if(proposalDetailsMap != null && proposalDetailsMap.containsKey(order.Apttus_QPConfig__ProposalId__c)) {
                
                Apttus_Proposal__Proposal__c proposal = proposalDetailsMap.get(order.Apttus_QPConfig__ProposalId__c);
                
                order.APTS_Proposal_Name__c = proposal.Apttus_Proposal__Proposal_Name__c;
                order.APTS_Quote_Date__c = proposal.APTS_Quote_Date__c;
                order.APTS_Complete_Dlvry__c = proposal.APTS_Complete_Dlvry__c;
                order.APTS_Sold_To_Acct_Number__c = proposal.APTS_Sold_To_Acct_Number__c;
                order.APTS_Ship_To_Acct_Number__c = proposal.APTS_Ship_To_Acct_Number__c;
                order.APTS_Inquiry_Number__c = proposal.APTS_Inquiry_Number__c;
                order.APTS_Total_Net_Price__c = proposal.APTS_Total_Net_Price__c;
                order.APTS_Total_Ext_Cost__c = proposal.APTS_Total_Ext_Cost__c;
                order.APTS_Sales_Order_Type__c = proposal.APTS_Sales_Order_Type__c;
                order.APTS_Consignee_PO_Num__c = proposal.APTS_Consignee_PO_Num__c;
                order.APTS_Ship_To_Name__c = proposal.APTS_Ship_To_Name__c;
                order.APTS_Ship_To_Addr_1__c = proposal.APTS_Ship_To_Addr_1__c;
                order.APTS_Ship_To_Addr_2__c = proposal.APTS_Ship_To_Addr_2__c;
                order.APTS_Ship_To_City__c = proposal.APTS_Ship_To_City__c;
                order.APTS_Ship_To_State__c = proposal.APTS_Ship_To_State__c;
                order.APTS_Ship_to_ZipCode__c = proposal.APTS_Ship_to_ZipCode__c;
                order.APTS_Ship_to_Country__c = proposal.APTS_Ship_to_Country__c;
                order.APTS_Ship_to_Region__c = proposal.APTS_Ship_to_Region__c;
                order.APTS_Freight_Terms__c = proposal.APTS_Freight_Terms__c;
                order.APTS_Whse_Instr__c = proposal.APTS_Whse_Instr__c;
                order.APTS_Pricing_Notes__c = proposal.APTS_Pricing_Notes__c;
                order.APTS_Total_Ext_Profit__c = proposal.APTS_Total_Ext_Profit__c;
                order.APTS_Total_Ext_Profit_Percent__c = proposal.APTS_Total_Ext_Profit_Percent__c;
                order.Apttus_Config2__PONumber__c = proposal.Apttus_QPConfig__PONumber__c;
            }
        }
    }
}