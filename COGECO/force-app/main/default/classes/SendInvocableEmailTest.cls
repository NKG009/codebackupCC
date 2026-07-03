@isTest
private class SendInvocableEmailTest {
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
        
        Customer_Approval__c customerApproval = new Customer_Approval__c(
            Quote__c = quoteRecord.Id
        );
        insert customerApproval;
        
        ContentVersion contentVersion = new ContentVersion(
            Title = 'EN-123',
            PathOnClient = 'Pic.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

    	ContentDocumentLink contentDocLink = new ContentDocumentLink(
            LinkedEntityId = customerApproval.Id,
            ContentDocumentId = documents[0].Id,
            ShareType = 'V',
            Visibility = 'AllUsers'
        );
        insert contentDocLink;
    }
    
	@isTest
    public static void sendCustomerFinalApprovalEmailTest(){
        Account accountRecord = [SELECT Id FROM Account WHERE Name = 'Test Wholesale Account'];
        Contact contactRecord = [SELECT Id FROM Contact WHERE AccountId = :accountRecord.Id];
        Opportunity opportunityRecord = [SELECT Id FROM Opportunity WHERE Name = 'TestOpportunity'];
        Quote quoteRecord = [SELECT Id FROM Quote WHERE OpportunityId = :opportunityRecord.Id];
        Customer_Approval__c customerApprovalRecord = [SELECT Id FROM Customer_Approval__c WHERE Quote__c = :quoteRecord.Id];
        EmailTemplate emailTemplateRecord = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Customer_Contract_Approved_EN'];
        
        List<EmailWrapper> emailWrapperList = new List<EmailWrapper>();
        EmailWrapper emailWrapperRecord = new EmailWrapper();
        emailWrapperRecord.strEmailTemplate = '';
        emailWrapperRecord.recordId = customerApprovalRecord.Id;
        emailWrapperRecord.templateId = emailTemplateRecord.Id;
        emailWrapperRecord.emailFrom= '';
        emailWrapperRecord.emailTo ='test@test.com';
        emailWrapperRecord.targetId = contactRecord.Id;
        emailWrapperRecord.attachmentName ='';
        emailWrapperRecord.isFromOrgEmail =false;
        emailWrapperRecord.isInternalEmail = false;
        emailWrapperRecord.sendAttachment = true;
        emailWrapperList.add(emailWrapperRecord);
        Test.startTest();
        SendInvocableEmail.sendCustomerFinalApprovalEmail(emailWrapperList);
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
        System.assertEquals(1, invocations, 'Email has been sent');
    }
    
    @isTest
    public static void sendEmailToInternalEmailTest(){
        Account accountRecord = [SELECT Id FROM Account WHERE Name = 'Test Wholesale Account'];
        Contact contactRecord = [SELECT Id FROM Contact WHERE AccountId = :accountRecord.Id];
        Opportunity opportunityRecord = [SELECT Id FROM Opportunity WHERE Name = 'TestOpportunity'];
        Quote quoteRecord = [SELECT Id FROM Quote WHERE OpportunityId = :opportunityRecord.Id];
        Customer_Approval__c customerApprovalRecord = [SELECT Id FROM Customer_Approval__c WHERE Quote__c = :quoteRecord.Id];
        EmailTemplate emailTemplateRecord = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Customer_Contract_Approved_EN'];
        
        List<EmailWrapper> emailWrapperList = new List<EmailWrapper>();
        EmailWrapper emailWrapperRecord = new EmailWrapper();
        emailWrapperRecord.strEmailTemplate = '';
        emailWrapperRecord.recordId = customerApprovalRecord.Id;
        emailWrapperRecord.templateId = emailTemplateRecord.Id;
        emailWrapperRecord.emailFrom = '';
        emailWrapperRecord.emailTo ='test@test.com';
        emailWrapperRecord.targetId = contactRecord.Id;
        emailWrapperRecord.attachmentName = '';
        emailWrapperRecord.isFromOrgEmail = false;
        emailWrapperRecord.isInternalEmail = true;
        emailWrapperRecord.sendAttachment = false;
        emailWrapperList.add(emailWrapperRecord);
        Test.startTest();
        SendInvocableEmail.sendCustomerFinalApprovalEmail(emailWrapperList);
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
        System.assertEquals(1, invocations, 'Email has been sent');
    }
    
    @isTest
    public static void nullEmailWrapperTest(){
        Test.startTest();
        SendInvocableEmail.sendCustomerFinalApprovalEmail(null);
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();        
        System.assertEquals(0, invocations, 'Email has not been sent');
    }
}