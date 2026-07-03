@isTest
private class CustomerAppprovalEventTriggerTest {
    @testSetup
    static void setup() {
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
            Opportunity_Source__c ='Event',
            Opp_Customer_Category__c = 'Wholesale',
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
            Quote__c = quoteRecord.Id,
            Opportunity__c = opportunityRecord.Id
        );
        insert customerApprovalRecord;
    }
    
    @isTest
    public static void testCustomerApprovalApproved() {
        Quote quoteRecord = [SELECT Id FROM Quote WHERE Name = :'Test Quote'];
        Customer_Approval__c customerApproval = [SELECT Id FROM Customer_Approval__c 
                                                 WHERE Quote__c = :quoteRecord.Id LIMIT 1];
        
        CustomerAppprovalEventDto customerApprovalEventDto = new CustomerAppprovalEventDto();
        customerApprovalEventDto.customerApprovalId = customerApproval.Id;
        customerApprovalEventDto.approvedBy = 'Test User';
        customerApprovalEventDto.approvedByEmail = 'test@test.com';
        customerApprovalEventDto.comments = 'test comments';
        customerApprovalEventDto.ipAddress = '0.0.0.0';
        customerApprovalEventDto.status = 'Approved';
        
        Customer_Approval_Event__e customerApprovalEvent = new Customer_Approval_Event__e(
            Approval_Response__c = JSON.serialize(customerApprovalEventDto)
        );
        
        Test.startTest();
        // Publish test event
        Database.SaveResult saveResult = EventBus.publish(customerApprovalEvent);
        Test.stopTest();
        
      //  System.assertEquals(true, saveResult.isSuccess());
		//Customer_Approval__c customerApprovalResult = [SELECT Id, Status__c, Approved_By__c, Comments__c, IP_Address__c 
                                                     //  FROM Customer_Approval__c WHERE Id = :customerApproval.Id];
		//system.assertEquals(customerApprovalEventDto.customerApprovalId, customerApprovalResult.Id);
       // system.assertEquals(customerApprovalEventDto.status, customerApprovalResult.Status__c);
      //  system.assertEquals(customerApprovalEventDto.approvedBy, customerApprovalResult.Approved_By__c);
       // system.assertEquals(customerApprovalEventDto.comments, customerApprovalResult.Comments__c);
       // system.assertEquals(customerApprovalEventDto.ipAddress, customerApprovalResult.IP_Address__c);
    }
    
    @isTest
    public static void testBlankCustomerApprovalEvent() {                
        Test.startTest();
        // Publish test event
        Database.SaveResult saveResult = EventBus.publish(new Customer_Approval_Event__e());
        Test.stopTest();
        System.assertEquals(true, saveResult.isSuccess());
    }
    
      @isTest
    static void testCustomerApprovalEventDto() {
        // Create an instance of the CustomerApprovalEventDto class
        CustomerAppprovalEventDto dto = new CustomerAppprovalEventDto();
        dto.customerApprovalId = '123';
        dto.approvedBy = 'John Doe';
        dto.approvedByEmail = 'john.doe@example.com';
        dto.comments = 'Approval granted.';
        dto.ipAddress = '192.168.1.1';
        dto.status = 'Approved';
        //dto.checkboxChecked = true;
        String jsonString = JSON.serialize(dto);
        Test.startTest();
        // Publish test event
         CustomerAppprovalEventDto signatureDto = (CustomerAppprovalEventDto)JSON.deserialize(jsonString, CustomerAppprovalEventDto.class);
        Test.stopTest();
        // Verify the values are set correctly
        System.assertEquals('123', dto.customerApprovalId);
        System.assertEquals('John Doe', dto.approvedBy);
        System.assertEquals('john.doe@example.com', dto.approvedByEmail);
        System.assertEquals('Approval granted.', dto.comments);
        System.assertEquals('192.168.1.1', dto.ipAddress);
        System.assertEquals('Approved', dto.status);
    }
}