/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This is Apex Class used to check the code coverage of excel_document_generation_button
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Ravi Rajeev   <ravi.rajeev@mainspringcg.com>
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/@isTest
public class excel_document_generation_buttonTest {
    public static testMethod void test1(){
        Account acc = new Account(Name='test');
        insert acc;
        
        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
        pricelist.Name =  'Standard USD PriceList';
        pricelist.Apttus_Config2__Active__c = true;
        insert priceList;  
        
        Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c();
        testProposal.Apttus_Proposal__Proposal_Name__c = 'testing';
        testProposal.Apttus_Proposal__Account__c = acc.Id;
        insert testproposal;
        
        ApexPages.currentPage().getParameters().put('id', String.valueOf(testproposal.Id));
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(testproposal);
        
        excel_document_generation_button xyz = new excel_document_generation_button(sc);
        xyz.abc = testproposal;
        xyz.redirect();
        xyz.cancel();
    }
    
}