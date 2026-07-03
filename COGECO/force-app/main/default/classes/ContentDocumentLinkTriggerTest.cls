@isTest
public class ContentDocumentLinkTriggerTest {
    @testSetup
    static void setup() {
        insert new System_Values__c(Name = 'Quote Communications Language Default', Value__c = 'French');
        insert new System_Values__c(Name = 'Order Fulfillment Status Default', Value__c = 'Draft');
        insert new System_Values__c(Name = 'Asset Rollup Batch Size', Value__c = '200');
        
        insert new Run_Rules__c(Run_Triggers__c = true);
        // Create test data
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
        
        Customer_Approval__c customerApprovalRecord = new Customer_Approval__c(
            Quote__c = quoteRecord.Id
        );
        insert customerApprovalRecord;
        
        ContentVersion contentVesion = new ContentVersion(
            Title = 'EN-Test Document',
            PathOnClient = '2023 Test',
            VersionData = Blob.valueOf('Test Attachment Body')
        );
        insert contentVesion;
        
        ContentVersion testContent = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :contentVesion.Id];
        
        ContentDocumentLink contentLink = new ContentDocumentLink(
            LinkedEntityId = customerApprovalRecord.Id,
            ContentDocumentId = testContent.ContentDocumentId,
            Visibility = 'AllUsers'
        );
        insert contentLink;
    }
    
    @IsTest
    static void testProcessContentDocumentLinkSharing() {
        // Create test data
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        
        // Create ContentDocumentLink records
        List<ContentDocumentLink> testContentDocumentLinks = new List<ContentDocumentLink> {
            new ContentDocumentLink(
            LinkedEntityId = testAccount.Id,
            Visibility = ApexConstants.CONTENT_DOCUMENT_LINK_VISIBILITY_ALL_USERS)
        };
        
        Test.startTest();
        ContentDocumentLinkTriggerHandler.processContentDocumentLinkSharing(testContentDocumentLinks);
        Test.stopTest();
        
        System.assertEquals(ApexConstants.CONTENT_DOCUMENT_LINK_VISIBILITY_ALL_USERS, testContentDocumentLinks[0].Visibility);
    }
    
    @isTest
    static void testProcessContentDistributions() {
        Customer_Approval__c customerApprovalRecord = [SELECT Id FROM Customer_Approval__c LIMIT 1];
        ContentDocumentLink contentLink = [SELECT LinkedEntityId, ContentDocumentId, Visibility FROM ContentDocumentLink WHERE LinkedEntityId = :customerApprovalRecord.Id LIMIT 1];
        
        Test.startTest();
        ContentDocumentLinkTriggerHandler.processContentDistributions(new List<ContentDocumentLink> { contentLink });
        Test.stopTest();
    }
	
	@isTest
	static void testlaunchEmailCustomerFlow() {
		
		Quote qtRecord = [SELECT Id FROM Quote LIMIT 1];
		//ContentDocumentLink contentLink = [SELECT LinkedEntityId, ContentDocumentId, Visibility FROM ContentDocumentLink WHERE LinkedEntityId = :qtRecord.Id LIMIT 1];
		
		ContentVersion contentVesion = new ContentVersion(
            Title = 'EN-Test2 Document',
            PathOnClient = '2023 Test',
            VersionData = Blob.valueOf('Test Attachment Body2')
        );
        insert contentVesion;
        
        ContentVersion testContent = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :contentVesion.Id];
        
        ContentDocumentLink contentLink = new ContentDocumentLink(
            LinkedEntityId = qtRecord.Id,
            ContentDocumentId = testContent.ContentDocumentId,
            Visibility = 'AllUsers'
        );
		insert contentLink;	
	}
	
    @isTest
    static void testprocessContentDocumentLinkSharingNull() {
		List<ContentDocumentLink> listContentLink = new List<ContentDocumentLink>();
        
        Test.startTest();        
        ContentDocumentLinkTriggerHandler.processContentDistributions(listContentLink);       
        Test.stopTest();
    }

    @isTest
    static void testprocessContentDocumentLinkSharingNull2() {
		List<ContentDocumentLink> listContentLink = new List<ContentDocumentLink>();
        
        Test.startTest();        
        ContentDocumentLinkTriggerHandler.processContentDocumentLinkSharing(listContentLink);       
        Test.stopTest();
    }

    @isTest
    static void testlaunchEmailCustomerFlowNull() {
		List<ContentDocumentLink> listContentLink = new List<ContentDocumentLink>();
        
        Test.startTest();        
        ContentDocumentLinkTriggerHandler.launchEmailCustomerFlow(listContentLink);       
        Test.stopTest();
    }	
    
    @isTest
    static void testContentDocumentById() {
        ContentDocument contentDocument = [SELECT Id FROM ContentDocument LIMIT 1];
        
        Set<Id> contentDocumentId = new Set<Id>();
        contentDocumentId.add(contentDocument.Id);
        
        Test.startTest();        
        List<ContentDocument> result = FileSelector.getContentDocumentsByIds(contentDocumentId);       
        Test.stopTest();
        
        System.assertEquals(1, result.size(), 'ContentDocument is not null');
    }
    
    @isTest
    static void testContentVersionById() {
        ContentVersion contentVersion = [SELECT Id FROM ContentVersion LIMIT 1];
        
        Set<Id> contentVersionId = new Set<Id>();
        contentVersionId.add(contentVersion.Id);
        
        Test.startTest();        
        List<ContentVersion> result = FileSelector.getContentVersionsByContentVersionIds(contentVersionId);       
        Test.stopTest();
        
        System.assertEquals(1, result.size(), 'ContentVersion is not null');
    }
    
    @isTest
    static void testContentDistributionById() {
        ContentDistribution contentDistribution = [SELECT Id FROM ContentDistribution LIMIT 1];
        
        Set<Id> contentDistributionId = new Set<Id>();
        contentDistributionId.add(contentDistribution.Id);
        
        Test.startTest();        
        List<ContentDistribution> result = FileSelector.getContentDistributionByIds(contentDistributionId);       
        Test.stopTest();
        
        System.assertEquals(1, result.size(), 'ContentDistribution is not null');
    }
    
    @isTest
    static void testPublicUrls() {
        ContentDistribution contentDistribution = [SELECT ContentDocumentId FROM ContentDistribution LIMIT 1];
        
        Set<Id> contentDocumentId = new Set<Id>();
        contentDocumentId.add(contentDistribution.ContentDocumentId);
        
        Test.startTest();        
        List<ContentDistribution> result = FileSelector.getPublicUrls(contentDocumentId);       
        Test.stopTest();
        
        System.assertEquals(1, result.size(), ' ');
    }
    
    @IsTest
    static void testContentDocumentLinkForCustomerApproval() {
        Account account = [SELECT Id FROM Account LIMIT 1];
        
		ContentVersion contentVersion = new ContentVersion(
        	Title = 'EN-%',
            PathOnClient = '2023 Test',
            VersionData = Blob.valueOf('Test Attachment Body')
        );
        insert contentVersion;
        
        ContentVersion testContent = [SELECT Id, ContentDocumentId, Title FROM ContentVersion WHERE Id = :contentVersion.Id];
        
        ContentDocumentLink contentDocumentLink = new ContentDocumentLink(
            LinkedEntityId = account.Id,
            ContentDocumentId = testContent.ContentDocumentId
        );
		insert contentDocumentLink;
        
        Set<String> titleQuery = new Set<String>();
        titleQuery.add(testContent.Title);
        
        Test.startTest();
        FileSelector.getContentDocumentLinkForCustomerApproval(contentDocumentLink.LinkedEntityId);
        Test.stopTest();
        
        System.assertEquals(ApexConstants.CONTENT_DOCUMENT_TITLE_LIKE_EN_PREFIX, testContent.Title);
    }
    
}