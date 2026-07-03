@isTest
public class CustomerContractEmailPreviewerTest {
    public static final String EMAIL_DEVELOPER_NAME = 'CustomerContractEmailPreviewerTest_Test_Template';
    
    @testSetup
    static void setup() {
        System.runAs(new User(Id = UserInfo.getUserId())) {
            EmailTemplate emailTemplate = new EmailTemplate(
                IsActive = true,
                Name = 'Test Template',
                DeveloperName = EMAIL_DEVELOPER_NAME,
                TemplateType = 'text',
                FolderId = UserInfo.getUserId(),
                Subject = 'Test Subject',
                HtmlValue = '<div>test html template</div>'
            );
            
        	insert emailTemplate;
        }
        
        Product2 product = new Product2(
            Name = 'TestProduct',
            IsActive = true
        );
        
        insert product;
        
        Id priceBookId = Test.getStandardPricebookId();
        
        PricebookEntry pricebookEntryRecord = new PricebookEntry(
            Pricebook2Id = priceBookId, 
            Product2Id = product.Id, 
            UnitPrice = 10000, 
            IsActive = true
        );
        
        insert pricebookEntryRecord;
        
        Territory__c territoryRecord = new Territory__c(
            Name = 'Test Territory',
            Description__c = 'Test territory description',
            TerritoryOwnerRole_RPT__c = 'ON - Account Executive Central',
            Sales_Rep__c = UserInfo.getUserId()
        );
        
        insert territoryRecord;
        
        Account accountRecord = new Account(
            Name = 'Test Account',
            Territory__c = territoryRecord.Id
        );
        
        insert accountRecord;

        Opportunity opportuntyRecord = new Opportunity(
            Name = 'TestOpportunity',
            Billing_Account_Number__c = accountRecord.Id,
            CloseDate = System.today().addDays(30),
            StageName = 'Qualification',
            Amount = 6,
            Pricebook2Id = priceBookId,
            Opp_Customer_Category__c = 'SMB', 
            Sale_Type_Details__c = 'Move'
        );
        
        insert opportuntyRecord;
        
        Quote quoteRecord = new Quote(
            Pricebook2Id = priceBookId,
            Name = 'Quote Test',
            OpportunityId = opportuntyRecord.Id
        );
        
        insert quoteRecord;
		
    }
    
    @isTest
    static void testGetEmailTemplate() {
        try{
		
        EmailTemplate templateRecord = [SELECT Id, Subject, HtmlValue FROM EmailTemplate WHERE DeveloperName = :EMAIL_DEVELOPER_NAME LIMIT 1];
        Test.startTest();
        
        CustomerContractEmailPreviewerDto resultDto = CustomerContractEmailPreviewerController.getEmailTemplateBasedOnLanguage(ApexConstants.CONTENT_DOCUMENT_TITLE_EN_PREFIX);
        EmailTemplate retrievedTemplate = EmailTemplateSelector.getSingleEmailTemplateSubjectAndHtmlValue(templateRecord.Id);
            system.debug('resultDto testGetEmailTemplate-->'+resultDto);
        Test.stopTest();
        
        System.assertEquals(templateRecord.Subject, resultDto.subject);
    }
        catch (Exception e) {
            System.assert(false, 'Exception caught in testGetEmailTemplate: ' + e.getMessage());
        }
    }    
    @isTest
    static void testCustomerContractEmailPreviewerException() {
     
       EmailTemplate templateRecord = [SELECT Id, Subject, HtmlValue FROM EmailTemplate WHERE DeveloperName = :EMAIL_DEVELOPER_NAME LIMIT 1];
        Test.startTest();
        try {
               
             CustomerContractEmailPreviewerController.getEmailTemplateBasedOnLanguage('RR');
             
            
        } catch (CustomerContractEmailPreviewerController.CustomerContractEmailPreviewerException e) {
            // Ensure that the exception was caught
            System.assertEquals('Attempt to de-reference a null object', e.getMessage());
        }
        Test.stopTest();
            
        
    }
     
      
     

}