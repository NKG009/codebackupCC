@isTest
public class AutolaunchFlowTest {

    @IsTest
    static void testAutolaunchFlow() {

        Product2 product= new Product2(
            Name = 'TestProduct',
            IsActive = true
        );
        
        insert product;
        
        Id priceBookId = Test.getStandardPricebookId();
        
        PricebookEntry pbeRecord = new PricebookEntry(
            Pricebook2Id = priceBookId, 
            Product2Id = product.Id, 
            UnitPrice = 10000, 
            IsActive = true
        );
        
        insert pbeRecord;
        
        Account customerAccountRecord = new Account(
            Name = 'Test SMB Account',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SMB').getRecordTypeId()
        );
        
        Account billingAccountRecord = new Account(
            Name = 'Test Billing Account',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Billing').getRecordTypeId(),
            ParentId = customerAccountRecord.Id
        );
        
        insert new List<Account>{ billingAccountRecord, customerAccountRecord };
        
        Opportunity opportunityRecord = new Opportunity(
            Name = 'TestOpportunity',
            Billing_Account_Number__c = billingAccountRecord.Id,
            AccountId = customerAccountRecord.Id,
            CloseDate = Date.today().addDays(30),
            StageName = 'Qualification',
            Amount = 6,
            Pricebook2Id = priceBookId,
            Opp_Customer_Category__c ='SMB', 
            Sale_Type_Details__c = 'Move'
        );
        
        insert opportunityRecord;
        
        Quote quoteRecord = new Quote(
            Name = 'Test Quote',
            OpportunityId = opportunityRecord.Id,
            ExpirationDate = Date.today().addDays(30),
            Status = 'Draft'
        );        
        insert quoteRecord;

		
		ContentVersion contentVesion = new ContentVersion(
            Title = 'EN-Test2 Document',
            PathOnClient = '2023 Test',
            VersionData = Blob.valueOf('Test Attachment Body2')
        );
        
        insert contentVesion;
        
        ContentVersion testContent = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :contentVesion.Id];
        
        ContentDocumentLink contentLink = new ContentDocumentLink(
            LinkedEntityId = quoteRecord.Id,
            ContentDocumentId = testContent.ContentDocumentId,
            Visibility = 'AllUsers'
        );
		
		insert contentLink;        
       
        new AutolaunchFlow(
                new Map<String, Object>{ ApexConstants.FLOW_RECORD_ID_KEY => quoteRecord.Id },
                ApexConstants.FLOW_EMAIL_DOCUMENT_TO_CUSTOMER
            ).start();
        
    }
    
}