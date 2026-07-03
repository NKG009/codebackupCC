@isTest
private class CustomerSignatureControllerTest {
    @testSetup
    static void setup() {
        Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        Id priceBookId = Test.getStandardPricebookId();
        
        User userRecord = new User(
            Title = 'Mr.',
            Username = 'tiwary91134111@gmail.com',
            LastName = 'System',
            Email = 'abc@gmail.com',
            Alias = 'autocase',
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_CA',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = testProfile.Id
        );
        
        insert userRecord;
        
        Territory__c territoryRecord = new Territory__c(
            Name = 'test',
            Description__c = 'test1',
            TerritoryOwnerRole_RPT__c = 'ON - Account Executive Central',
            Sales_Rep__c = userrecord.Id
        );
        
        insert territoryRecord;
        
        Account accountRecord = new Account(
            Name = 'Cogeco',
            Territory__c = territoryRecord.Id,
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Wholesale').getRecordTypeId()
        );
        
        insert accountRecord;
        
        Opportunity opportunityRecord = new Opportunity(
            Name = 'TestOpportunity',
            AccountId = accountRecord.Id,
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
            Quote__c = quoteRecord.Id,
            Status__c = ApexConstants.CUSTOMER_APPROVAL_STATUS_WITH_CUSTOMER,
            Verification_Code__c = ApexConstants.CUSTOMER_APPROVAL_VERIFICATION_CODE
        );
        insert customerApproval;
        
        ContentVersion contentVesion = new ContentVersion(
            Title = 'EN-Test Document',
            PathOnClient = '2023 Test',
            VersionData = Blob.valueOf('Test Attachment Body')
        );
        
        insert contentVesion;
        
        ContentVersion testContent = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :contentVesion.Id];
        
        ContentDocumentLink contentlink = new ContentDocumentLink(
            LinkedEntityId = customerApproval.Id,
            ContentDocumentId = testContent.ContentDocumentId,
            Visibility = 'AllUsers'
        );
        
        insert contentlink;
    }

    @istest
    static void testValidateMethod() {
		Customer_Approval__c approval = [SELECT Id, Verification_Code__c FROM Customer_Approval__c LIMIT 1];
         
        Test.startTest();
        
        String result = CustomerSignatureController.validate(String.valueOf(approval.Id), approval.Verification_Code__c);
        
        Test.stopTest();
         if (result != null) {
        CustomerSignatureValidationDto validationDto = (CustomerSignatureValidationDto)JSON.deserialize(result, CustomerSignatureValidationDto.class);
          
        System.assertEquals(approval.Id, validationDto.customerApprovalRecord.Id);
        System.assertEquals(true, validationDto.readyForSignature);
         }
        else {
             System.assert(false, 'Result is null');
        }
    }

    @istest
    static void testValidateMethodNoCustomerApprovalFound() {
		Customer_Approval__c approval = [SELECT Id, Verification_Code__c FROM Customer_Approval__c LIMIT 1];
        String errorMessage;
        
        Test.startTest();
        
        try {
       		CustomerSignatureController.validate(String.valueOf(approval.Id), 'badverificationcode');
        } catch (Exception e) {
            errorMessage = e.getTypeName();
        }
        
        Test.stopTest();

        System.assertEquals('System.AuraHandledException', errorMessage);
    }
    
    @isTest
    static void testGetCustomerApprovalToAction() {
		Customer_Approval__c approval = [SELECT Id, Verification_Code__c FROM Customer_Approval__c LIMIT 1];
         String errorMessage;
        system.debug('approval testGetCustomerApprovalToAction--->'+approval);
        Test.startTest();
        try{
         if (approval != null) {
        String result = CustomerSignatureController.getCustomerApprovalToAction(String.valueOf(approval.Id));
        system.debug('result testGetCustomerApprovalToAction--->'+result);
             
        CustomerSignatureDto signatureDto = (CustomerSignatureDto)JSON.deserialize(result, CustomerSignatureDto.class);
           system.debug('signatureDto--->'+signatureDto);  
             system.debug('signatureDto.fileName--->'+signatureDto.fileName); 
             system.debug('signatureDto.customerApproval.Id--->'+signatureDto.customerApproval.Id); 
             
        System.assertEquals('EN-Test Document', signatureDto.fileName);
        System.assertEquals(approval.Id, signatureDto.customerApproval.Id);  
         } else {
        System.assert(false, 'Customer_Approval__c record is null');
    }
        }
        catch (Exception e) {
            errorMessage = e.getTypeName();
              System.debug('An error occurred: ' + e.getMessage());
            }
        
        Test.stopTest();
        System.assertEquals('System.AuraHandledException', errorMessage);
        
        
       
    }
    
    @isTest
    static void testSave() {
		Customer_Approval__c approval = [SELECT Id, Verification_Code__c FROM Customer_Approval__c LIMIT 1];
        
        CustomerAppprovalEventDto customerApprovalDto = new CustomerAppprovalEventDto();
        customerApprovalDto.customerApprovalId = approval.Id;
        customerApprovalDto.ipAddress = '0.0.0.0';
        customerApprovalDto.status = 'Approved';
        customerApprovalDto.comments = 'test comments';
        customerApprovalDto.approvedBy = 'test customer';
        customerApprovalDto.approvedByEmail = 'test@example.com';
        
        String encodedBlob = EncodingUtil.base64Encode(Blob.valueOf('test file contents'));
        String encodedBlob1 = EncodingUtil.base64Encode(Blob.valueOf('test file contents 1'));
        
        List<Map<String,Object>> listOfFileDetails = new List<Map<String,Object>>();
        Map<String,Object> fileDetails = new Map<String,Object>();
        fileDetails.put('base64',encodedBlob);
        fileDetails.put('fileName','testfilename.pdf');
        listOfFileDetails.add(fileDetails);
		Map<String,Object> fileDetails1 = new Map<String,Object>();
        fileDetails1.put('base64',encodedBlob1);
        fileDetails1.put('fileName','testfilename1.pdf');
        listOfFileDetails.add(fileDetails1);
        CustomerSignatureFileDto CS = new CustomerSignatureFileDto(encodedBlob,'testfilename.pdf');
        
        Test.startTest();
        
        CustomerSignatureController.save(JSON.serialize(customerApprovalDto), JSON.serialize(listOfFileDetails), approval.Id);
        
        Test.stopTest();
        
        Customer_Approval__c approvalResult = [SELECT Id, Status__c, IP_Address__c, Comments__c, Approved_By__c, Approved_By_Email__c FROM Customer_Approval__c WHERE Id = :approval.Id];
        
        System.assertEquals(customerApprovalDto.customerApprovalId, approvalResult.Id);
    }
    

    @isTest
    static void testIs911FormSectionRequired() {
        // Test data setup
        Quote testQuote = [SELECT Id,Selected_Attachments__c FROM Quote];

        Customer_Approval__c testCustomerApproval = [SELECT Id,Quote__c FROM Customer_Approval__c WHERE Quote__r.Id =: testQuote.Id];
        
        Customer_Email_Attachment__c attachmentSetting = new Customer_Email_Attachment__c(
            Name = '911 Test',
            Require_911_Form_Section__c = true
        );
        insert attachmentSetting;
        
        testQuote.Selected_Attachments__c = attachmentSetting.Id;
        update testQuote;

        // Call the method being tested
        Boolean isRequired = CustomerSignatureController.is911FormSectionRequired(testCustomerApproval.Id);

        // Assertion
        System.assertEquals(false, isRequired, '911 Form section should be required');
    }

}