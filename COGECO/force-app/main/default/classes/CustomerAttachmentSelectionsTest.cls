@isTest
public class CustomerAttachmentSelectionsTest {
    private static final String TEST_ENGLISH = 'test english';
    private static final String TEST_FRENCH = 'test french';
    
	@testSetup
    static void setup() {
        ContentFolder folderEnglish = new ContentFolder(Name = 'test folder english');
        ContentFolder folderFrench = new ContentFolder(Name = 'test folder french');
        
        insert new List<ContentFolder>{ folderEnglish, folderFrench };
            
        ContentVersion documentEnglish = new ContentVersion(Description = TEST_ENGLISH, Title = TEST_ENGLISH, PathOnClient = '<a target="_blank" href="http://www.google.com/" rel="nofollow">http://www.google.com/</a>', VersionData = Blob.valueOf(TEST_ENGLISH));
        ContentVersion documentFrench = new ContentVersion(Description = TEST_FRENCH, Title = TEST_FRENCH, PathOnClient = '<a target="_blank" href="http://www.google.com/" rel="nofollow">http://www.google.com/</a>', VersionData = Blob.valueOf(TEST_FRENCH));
        
        insert new List<ContentVersion>{ documentEnglish, documentFrench };
            
        String contentVersionEnglishId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Title = :TEST_ENGLISH].ContentDocumentId;
        String contentVersionFrenchId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Title = :TEST_FRENCH].ContentDocumentId;
            
        ContentFolderMember folderMemberEnglish = [SELECT Id, ParentContentFolderId FROM ContentFolderMember WHERE ChildRecordId = :contentVersionEnglishId];
        ContentFolderMember folderMemberFrench = [SELECT Id, ParentContentFolderId FROM ContentFolderMember WHERE ChildRecordId = :contentVersionFrenchId];
        
        folderMemberEnglish.ParentContentFolderId = folderEnglish.Id;
        folderMemberFrench.ParentContentFolderId = folderFrench.Id;
        
        update new List<ContentFolderMember>{ folderMemberEnglish, folderMemberFrench };
        
        List<System_Values__c> systemValues = new List<System_Values__c>{
            new System_Values__c(Name = ApexConstants.SYSTEM_VALUES_CUSTOMER_ATTACHMENT_FOLDER_ENGLISH_ID, Value__c = folderEnglish.Id),
            new System_Values__c(Name = ApexConstants.SYSTEM_VALUES_CUSTOMER_ATTACHMENT_FOLDER_FRENCH_ID, Value__c = folderFrench.Id)
        };
            
        insert systemValues;
        
        List<Customer_Email_Attachment__c> emailAttachmentRules = new List<Customer_Email_Attachment__c>{
            new Customer_Email_Attachment__c(Name = TEST_ENGLISH, Active__c = true, Attachment_Id__c = contentVersionEnglishId),
            new Customer_Email_Attachment__c(Name = TEST_FRENCH, Active__c = true, Attachment_Id__c = contentVersionFrenchId)
        };
            
        insert emailAttachmentRules;
        
        Account accountRecord = new Account(
        	RecordTypeId = ApexConstants.ACCOUNT_SMB_RECORD_TYPE_ID,
            Name = 'test account',
            ShippingState = 'ON'
        );
        
        insert accountRecord;
        
        Opportunity opportunityRecord = new Opportunity(
        	Name = 'test opportunity',
            Amount = 0,
            StageName = 'Qualification',
            CloseDate = Date.today().addDays(30)
        );
        
        insert opportunityRecord;
        
        Quote quoteRecord = new Quote(
        	OpportunityId = opportunityRecord.Id,
            Name = 'test quote',
            Communication_Language__c = ApexConstants.ENGLISH
        );
        
        insert quoteRecord;
    }
    
    @isTest
    static void testGetCustomerEmailAttachmentsEnglish() {
        Quote quoteRecord = [SELECT Id FROM Quote LIMIT 1];
        
        Test.startTest();
        
        String result = CustomerAttachmentSelectionsController.getCustomerEmailAttachments(quoteRecord.Id);
        
        Test.stopTest();
        
        List<CustomerEmailAttachmentDto> emailAttachmentResults = (List<CustomerEmailAttachmentDto>)JSON.deserialize(result, List<CustomerEmailAttachmentDto>.class);
        
        System.assertEquals(TEST_ENGLISH, emailAttachmentResults[0].attachmentName);
        System.assertEquals(TEST_ENGLISH, emailAttachmentResults[0].attachmentDescription);
    }
    
    @isTest
    static void testGetCustomerEmailAttachmentsFrench() {
        Quote quoteRecord = [SELECT Id, Communication_Language__c FROM Quote LIMIT 1];
        quoteRecord.Communication_Language__c = ApexConstants.FRENCH;
        
        update quoteRecord;
        
        Test.startTest();
        
        String result = CustomerAttachmentSelectionsController.getCustomerEmailAttachments(quoteRecord.Id);
        
        Test.stopTest();
        
        List<CustomerEmailAttachmentDto> emailAttachmentResults = (List<CustomerEmailAttachmentDto>)JSON.deserialize(result, List<CustomerEmailAttachmentDto>.class);
        
        System.assertEquals(TEST_FRENCH, emailAttachmentResults[0].attachmentName);
        System.assertEquals(TEST_FRENCH, emailAttachmentResults[0].attachmentDescription);
    }
}