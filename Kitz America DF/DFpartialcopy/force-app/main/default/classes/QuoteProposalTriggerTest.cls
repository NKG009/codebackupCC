/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This is Apex Class used to check the code coverage of QuoteProposalTrigger
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Ravi Rajeev   <ravi.rajeev@mainspringcg.com>
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/
@isTest
public class QuoteProposalTriggerTest {
    @isTest 
    static void testBeforeInsertQuoteTrigger(){
        Account acc = Testutility.createAccount();
        insert acc;
        contact con = Testutility.createContact(acc.Id);
        insert con;
        
        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
        pricelist.Name =  'Standard USD PriceList';
        insert priceList;
        
        Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c();
        testProposal.Apttus_Proposal__Account__c = acc.Id;
        insert testproposal;
    }
    
    @isTest 
    static void testBeforeUpdateQuoteTrigger(){
        Account acc = Testutility.createAccount();
        insert acc;
        contact con = Testutility.createContact(acc.Id);
        insert con;
        
        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
        pricelist.Name =  'Standard USD PriceList';
        insert priceList;
        
        Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c();
        testProposal.Apttus_Proposal__Account__c = acc.Id;
        testProposal.Apttus_Proposal__Approval_Stage__c = 'Approved';
        insert testproposal;
        
        testproposal.Apttus_QPConfig__ConfigurationFinalizedDate__c = system.now();
        testproposal.APTS_Freight_Terms__c = 'Collect';
        testproposal.Apttus_QPConfig__PONumber__c = 'RR282';
        testproposal.Apttus_Proposal__Approval_Stage__c = 'Accepted';
        update testProposal;
    }
    
     @isTest 
    static void testBeforeUpdateQuoteTrigger2(){
        Account acc = Testutility.createAccount();
        insert acc;
        contact con = Testutility.createContact(acc.Id);
        insert con;
        
        Product2 prod = Testutility.createProduct();
        insert prod;
        
        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
        pricelist.Name =  'Standard USD PriceList';
        insert priceList;
        
        Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c();
        testProposal.Apttus_Proposal__Account__c = acc.Id;
        testProposal.APTS_Sales_Order_Type__c = 'Standard Order';
        insert testproposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = Testutility.createProductConfig(acc.Id, testProposal.Id);
        prodConfig.Apttus_Config2__Status__c = 'New';
		insert prodConfig;   
        
        Apttus_Config2__LineItem__c lineItem = Testutility.createLineItem(prodConfig.Id, prod.Id);
        insert lineItem;
        
        testproposal.Apttus_QPConfig__ConfigurationFinalizedDate__c = system.now();
        testproposal.APTS_Freight_Terms__c = 'Collect';
        testproposal.Apttus_QPConfig__PONumber__c = 'RR282';
        testproposal.APTS_Sales_Order_Type__c = 'Project Order';
        update testProposal;
        
    }
     
}