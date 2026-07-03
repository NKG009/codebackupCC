@isTest
public class CreateAttachmentFromVFPageInvocableTest {
    public static final String TEST_BLOB_CONTENT = 'test content';
    
	@testSetup
    static void setup() {
        General_Settings__c setting = new General_Settings__c();
        setting.Name = 'Internal Contract Delivery Email';
        setting.Internal_Contract_Delivery_Email__c = 'test@test.com';
        insert setting;
		
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
            Name = 'Test Wholesale Account',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Wholesale').getRecordTypeId()
        );
        insert customerAccountRecord;
		            
        Contact contactRecord = new Contact(
            Title = 'Job',
            FirstName = 'Test Firstname',
            LastName = 'Test Lastname',
            Phone = '12341234123',
            MobilePhone = '12344112123',
            Fax = '12121212121',
            Email = 'test@test.com',
            AccountId = customerAccountRecord.Id
        );
        insert contactRecord;
        
        Opportunity opportunityRecord = new Opportunity(
            Name = 'TestOpportunity',
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
    }
    
    @isTest
    static void testCreateAttachmentFromVisualforcePage() {
        EmailWrapper emailWrapper = new EmailWrapper();
        emailWrapper.visualforcePageName = ApexConstants.VLOCITY_VF_PAGE_QUOTEDOCUMENTPDF;
        emailWrapper.attachmentName = ApexConstants.CONTENT_DOCUMENT_TITLE_LIKE_EN_PREFIX;
        emailWrapper.relatedRecordId = [SELECT Id FROM Quote LIMIT 1].Id;
        
        List<EmailWrapper> emailWrappers = new List<EmailWrapper>{ emailWrapper };
        
        Test.startTest();
        
        CreateAttachmentFromVFPageInvocable.createAttachmentFromVisualforcePage(emailWrappers);
        
        Test.stopTest();
        
        ContentVersion contentVersionResult = [SELECT Id, Title FROM ContentVersion LIMIT 1];
        
        System.assertEquals(true, contentVersionResult.Title.startsWith(ApexConstants.CONTENT_DOCUMENT_TITLE_LIKE_EN_PREFIX));
    }
}