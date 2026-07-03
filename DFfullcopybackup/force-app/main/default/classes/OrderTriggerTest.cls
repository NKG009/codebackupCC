/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This is Test Class for Order Trigger
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Sumit   <sumit.m@standav.com>
* @modifiedBy     Sumit   <sumit.m@standav.com>
* @maintainedBy   Sumit   <sumit.m@standav.com>
* @version        1.0
* @created        2020-04-29
* @modified       2020-04-29
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/

@isTest
public class OrderTriggerTest {
    
    @isTest
    static void testBeforeInsertOrderTrigger(){
        
        SAP_Order_Integration_Settings__c Setting = new SAP_Order_Integration_Settings__c();
        Setting = Testutility.createSAP_Order_Integration_Settings(true);
        
        Account acc = Testutility.createAccount();
        insert acc;
        
        contact con = Testutility.createContact(acc.Id);
        insert con;
        
        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
        pricelist.Name =  'Standard USD PriceList';
        insert priceList;
        
        Product2 prod = Testutility.createProduct();
        insert prod;
        
        Apttus_Proposal__Proposal__c testProposal = Testutility.createProposal(acc.Id);
        testProposal.Apttus_Proposal__Proposal_Name__c = 'test 1';
        testProposal.APTS_Quote_Date__c = System.today();
        
        insert testProposal;
        
        Apttus_Config2__Order__c testOrder = new Apttus_Config2__Order__c();
        testOrder.Apttus_QPConfig__ProposalId__c = testProposal.Id;
        
        insert testOrder;        
        
        Test.setMock(HttpCalloutMock.class, new SaporderCalloutMock()); 
        
    }
    
    @isTest
    static void testBeforeInsertOrderTrigger400(){
        
        SAP_Order_Integration_Settings__c Setting = new SAP_Order_Integration_Settings__c();
        Setting = Testutility.createSAP_Order_Integration_Settings(true);
        
        Account acc = Testutility.createAccount();
        insert acc;
        
        contact con = Testutility.createContact(acc.Id);
        insert con;
        
        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
        pricelist.Name =  'Standard USD PriceList';
        insert priceList;
        
        Product2 prod = Testutility.createProduct();
        insert prod;
        
        Apttus_Proposal__Proposal__c testProposal = Testutility.createProposal(acc.Id);
        testProposal.Apttus_Proposal__Proposal_Name__c = 'test 1';
        testProposal.APTS_Quote_Date__c = System.today();
        
        insert testProposal;
        
        Apttus_Config2__Order__c testOrder = new Apttus_Config2__Order__c();
        testOrder.Apttus_QPConfig__ProposalId__c = testProposal.Id;
        
        insert testOrder;        
        
        Test.setMock(HttpCalloutMock.class, new SaporderCalloutMock400()); 
    }
}