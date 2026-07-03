@istest
public class OpportunityTrigger_TEST {
    
    @testSetup
    static void setup(){
        insert new list<InvoiceAutoNumber__c> {
            new InvoiceAutoNumber__c(  Name='CON',Number__c=784546),
                new InvoiceAutoNumber__c( Name='CC',Number__c=7846),
                new InvoiceAutoNumber__c( Name='FF',Number__c=78746),
                new InvoiceAutoNumber__c( Name='OP',Number__c=78496),
                new InvoiceAutoNumber__c( Name='PS',Number__c=78146),
                 new InvoiceAutoNumber__c( Name='SS',Number__c=78146),
                 new InvoiceAutoNumber__c( Name='TL',Number__c=78146),
                 new InvoiceAutoNumber__c( Name='PP',Number__c=78146),
                 new InvoiceAutoNumber__c( Name='S',Number__c=78146)
                
                };
                    
                    
                    }
    
    @istest
    public static void InvoiceNumberUpdate(){
        Id rtpeConnext=Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('Connext').getRecordTypeId();
        Id rtpeOPCCCorporateConsultants=Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('OPCC_Corporate_Consultants').getRecordTypeId();
        Id rtpeOPCCFormations=Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('OPCC_Formations').getRecordTypeId();
        Id rtpeOPETCPDstore=Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('OPET_CPDstore').getRecordTypeId();
        Id rtpeOPSS=Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('OPSS').getRecordTypeId();
        Id rtpeProfitPro=Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('ProfitPro').getRecordTypeId();
        Id rtpeOPTLTaxandLegal=Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('OPTL_Tax_and_Legal').getRecordTypeId();
        Id rtpeOPPSPracticeSupport=Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('OPPS_Practice_Support').getRecordTypeId();
        Id rtpeSales=Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('Sales').getRecordTypeId();
        list<opportunity> opplist =new list<opportunity>();
        account acc = new account();
        acc.name='test1';
        acc.CurrencyIsoCode='EUR';
        acc.Phone='752985475';
        acc.BillingCountry='Ireland';
        acc.BillingPostalCode='789456';
        insert acc;
        
        contact con = new contact();
        con.lastname='testcon';
        con.CurrencyIsoCode='EUR';
        con.AccountId=acc.Id;
        con.MailingCountry='Ireland';
        con.MailingPostalCode='789456';
        insert con;
        
        User usr1 = new User();
        usr1.FirstName = 'Test';
        usr1.LastName = 'User1';
        usr1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;  
        usr1.Username = 'Test.User1@yopmail.com.ps360.test' + System.currentTimeMillis();    
        usr1.Email = 'test.user1@yopmail.com.ps360.test';
        usr1.LanguageLocaleKey = 'en_US';
        usr1.EmailEncodingKey = 'UTF-8';
        usr1.LocaleSidKey = 'en_US';
        usr1.TimeZoneSidKey = 'America/Los_Angeles';
        usr1.Alias = 'Alias1';
        usr1.Title = 'Title1';
        insert usr1;
        
        
        Opportunity opp = new Opportunity();
        opp.RecordTypeId=rtpeSales;
        opp.name='testopp';
        opp.AccountId=acc.id;
        opp.ContactId=con.Id;
        opp.CurrencyIsoCode='EUR';
        opp.Service_Delivery_Person__c=usr1.id;
        opp.StageName='Qualification';
        opp.Invoice_No_Required__c=true;
        opp.CloseDate=system.today();
        insert opp;
        
        
        opp.StageName='Closed Won';
        update opp;
        
        
        Opportunity opp1 = new Opportunity();
        opp1.RecordTypeId=rtpeOPCCCorporateConsultants;
        opp1.name='testopp23';
        opp1.AccountId=acc.id;
        opp1.ContactId=con.Id;
        opp1.Account_Type__c='Practice';
        opp1.CurrencyIsoCode='EUR';
        opp1.Service_Delivery_Person__c=usr1.id;
        opp1.StageName='Qualification';
        opp1.CloseDate=system.today();
        opp1.Invoice_No_Required__c=true;
        opp1.AML_Requested__c=system.today();
        opp1.AML_Received__c=system.today();
        insert opp1;
        
        opp1.StageName='Closed Won';
        update opp1;
        
        
        Opportunity opp2 = new Opportunity();
        opp2.RecordTypeId=rtpeOPETCPDstore;
        opp2.name='testopp2';
        opp2.AccountId=acc.id;
        opp2.ContactId=con.Id;
        opp2.CurrencyIsoCode='EUR';
        opp2.Service_Delivery_Person__c=usr1.id;
        opp2.StageName='Qualification';
        opp2.Invoice_No_Required__c=true;
        opp2.CloseDate=system.today();
        insert opp2;
        
        opp2.StageName='Closed Won';
        update opp2;
        
        Opportunity opp3 = new Opportunity();
        opp3.RecordTypeId=rtpeOPPSPracticeSupport;
        opp3.name='testopp2';
        opp3.AccountId=acc.id;
        opp3.ContactId=con.Id;
        opp3.CurrencyIsoCode='EUR';
        opp3.Service_Delivery_Person__c=usr1.id;
        opp3.StageName='Qualification';
        opp3.CloseDate=system.today();
        opp3.Invoice_No_Required__c=true;
        insert opp3;
        
        opp3.StageName='Closed Won';
        update opp3;
        
        Opportunity opp4 = new Opportunity();
        opp4.RecordTypeId=rtpeOPTLTaxandLegal;
        opp4.name='testopp2';
        opp4.AccountId=acc.id;
        opp4.ContactId=con.Id;
        opp4.CurrencyIsoCode='EUR';
        opp4.Service_Delivery_Person__c=usr1.id;
        opp4.StageName='Qualification';
         opp4.Invoice_No_Required__c=true;
        opp4.CloseDate=system.today();
        insert opp4;
        
        opp4.StageName='Closed Won';
        update opp4;
        
        Opportunity opp5 = new Opportunity();
        opp5.RecordTypeId=rtpeConnext;
        opp5.name='testopp2';
        opp5.AccountId=acc.id;
        opp5.ContactId=con.Id;
        opp5.CurrencyIsoCode='EUR';
        opp5.Service_Delivery_Person__c=usr1.id;
        opp5.StageName='Qualification';
        opp5.Invoice_No_Required__c=true;
        opp5.CloseDate=system.today();
        insert opp5;
        
        opp5.StageName='Closed Won';
        update opp5;
        
        Opportunity opp6 = new Opportunity();
        opp6.RecordTypeId=rtpeOPCCFormations;
        opp6.name='testopp2';
        opp6.AccountId=acc.id;
        opp6.ContactId=con.Id;
        opp6.CurrencyIsoCode='EUR';
        opp6.Service_Delivery_Person__c=usr1.id;
        opp6.StageName='Qualification';
        opp6.Invoice_No_Required__c=true;
        opp6.CloseDate=system.today();
        insert opp6;
        
        opp6.StageName='Closed Won';
        update opp6;
        
        Opportunity opp7 = new Opportunity();
        opp7.RecordTypeId=rtpeProfitPro;
        opp7.name='testopp';
        opp7.AccountId=acc.id;
        opp7.ContactId=con.Id;
        opp7.CurrencyIsoCode='EUR';
        opp7.Service_Delivery_Person__c=usr1.id;
        opp7.StageName='Qualification';
        opp7.Invoice_No_Required__c=true;
        opp7.CloseDate=system.today();
        insert opp7;
        
        
        opp7.StageName='Closed Won';
        update opp7;
        
        Opportunity opp8 = new Opportunity();
        opp8.RecordTypeId=rtpeOPSS;
        opp8.name='testopp';
        opp8.AccountId=acc.id;
        opp8.ContactId=con.Id;
        opp8.CurrencyIsoCode='EUR';
        opp8.Service_Delivery_Person__c=usr1.id;
        opp8.StageName='Qualification';
        opp8.Invoice_No_Required__c=true;
        opp8.CloseDate=system.today();
        insert opp8;
        
        
        opp8.StageName='Closed Won';
        update opp8;
        
         Opportunity oppt = new Opportunity();
        oppt.RecordTypeId=rtpeSales;
        oppt.name='testopp';
        oppt.AccountId=acc.id;
        oppt.ContactId=con.Id;
        oppt.CurrencyIsoCode='EUR';
        oppt.Service_Delivery_Person__c=usr1.id;
        oppt.StageName='Closed Won';
        oppt.Invoice_No_Required__c=true;
        oppt.CloseDate=system.today();
        insert oppt;
        
        
        
        
        
        
        
    }
    
}