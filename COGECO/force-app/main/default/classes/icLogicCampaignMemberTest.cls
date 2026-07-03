@isTest
public class icLogicCampaignMemberTest {

    @IsTest
    static void testgetAllCampaignMemberDetailsById() {
        Campaign campaignRecord = new Campaign();
        campaignRecord.Name = 'U-ON-RT-F21-P03-N-001-BU-AE - Blog';
        campaignRecord.Status = 'Planned';
        campaignRecord.Channel__c = 'Direct Email';
        campaignRecord.IsActive = true;
        campaignRecord.Type = 'Upsell';
        insert campaignRecord;
        
        Account customerAccountRecord = new Account(
            Name = 'Test SMB Account',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SMB').getRecordTypeId()
        );
        insert customerAccountRecord;
        
        Contact conRecord = new Contact();
        conRecord.FirstName = 'Testfirstnm';
        conRecord.LastName = 'Testlastnm';
        conRecord.Phone = '7847567833';
        conRecord.AccountId = customerAccountRecord.Id;
        insert conRecord;
        
        CampaignMember campMemberRec = new CampaignMember();
        campMemberRec.CampaignId = campaignRecord.Id;
        campMemberRec.ContactId = conRecord.id;
        insert campMemberRec;
        
        Test.startTest();
        icLogicCampaignMember icLogicObj = new icLogicCampaignMember();
        icLogicCampaignMember.Impl implObj = new icLogicCampaignMember.Impl();
        implObj.getAllCampaignMemberDetailsById(campMemberRec.id);
        Test.stopTest();
        
    }
	
	@IsTest
    static void testvalidateClientAddressFromCampaignMember() {
        Campaign campaignRecord = new Campaign();
        campaignRecord.Name = 'U-ON-RT-F21-P03-N-001-BU-AE - Blog';
        campaignRecord.Status = 'Planned';
        campaignRecord.Channel__c = 'Direct Email';
        campaignRecord.IsActive = true;
        campaignRecord.Type = 'Upsell';
        insert campaignRecord;

		
        Account customerAccountRecord = new Account(
            Name = 'Test SMB Account',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SMB').getRecordTypeId()
        );
        insert customerAccountRecord;
        
        Contact conRecord = new Contact();
        conRecord.FirstName = 'Testfirstnm';
        conRecord.LastName = 'Testlastnm';
        conRecord.Phone = '7847567833';
		conRecord.MailingStreet = '57 Steeles Avenue West';
		conRecord.MailingCity = 'Toronto';
		conRecord.MailingState = 'ON';
		conRecord.MailingPostalCode = 'M2M 3Y1';
        conRecord.AccountId = customerAccountRecord.Id;

        insert conRecord;
        
        CampaignMember campMemberRec = new CampaignMember();
        campMemberRec.CampaignId = campaignRecord.Id;
        campMemberRec.ContactId = conRecord.id;
		
        insert campMemberRec;
        
        Test.startTest();
        icLogicCampaignMember icLogicObj = new icLogicCampaignMember();
        icLogicCampaignMember.Impl implObj = new icLogicCampaignMember.Impl();
        implObj.validateClientAddressFromCampaignMember(campMemberRec);
        Test.stopTest();
        
    }
	
	@IsTest
    static void testvalidateClientAddressFromCampaignMember2() {
        Campaign campaignRecord = new Campaign();
        campaignRecord.Name = 'U-ON-RT-F21-P03-N-001-BU-AE - Blog';
        campaignRecord.Status = 'Planned';
        campaignRecord.Channel__c = 'Direct Email';
        campaignRecord.IsActive = true;
        campaignRecord.Type = 'Upsell';
        insert campaignRecord;
        
		Lead leadRecord = new Lead();
		leadRecord.FirstName = 'Testleadfnm';
        leadRecord.LastName = 'Testleadlnm';
		leadRecord.Status = 'SQL';
        leadRecord.Company = 'SoluCan';
		leadRecord.Street = '57 Steeles Avenue West';
		leadRecord.City = 'Toronto';
		leadRecord.State = 'ON';
		leadRecord.PostalCode = 'M2M 3Y1';
		insert leadRecord;
		
        Account customerAccountRecord = new Account(
            Name = 'Test SMB Account',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SMB').getRecordTypeId()
        );
        insert customerAccountRecord;
        
        CampaignMember campMemberRec = new CampaignMember();
        campMemberRec.CampaignId = campaignRecord.Id;
		campMemberRec.LeadId = leadRecord.id;
		
        insert campMemberRec;
        
        Test.startTest();
        icLogicCampaignMember icLogicObj = new icLogicCampaignMember();
        icLogicCampaignMember.Impl implObj = new icLogicCampaignMember.Impl();
        implObj.validateClientAddressFromCampaignMember(campMemberRec);
        Test.stopTest();
        
    }
	
	@IsTest
    static void testgetShippingRequestDTOFromCampaignMemberContactNull() {
        Campaign campaignRecord = new Campaign();
        campaignRecord.Name = 'U-ON-RT-F21-P03-N-001-BU-AE - Blog';
        campaignRecord.Status = 'Planned';
        campaignRecord.Channel__c = 'Direct Email';
        campaignRecord.IsActive = true;
        campaignRecord.Type = 'Upsell';
        insert campaignRecord;
        
		Lead leadRecord = new Lead();
		leadRecord.Salutation = 'Mrs.';
		leadRecord.FirstName = 'Testleadfnm';
        leadRecord.LastName = 'Testleadlnm';
		leadRecord.Status = 'SQL';
        leadRecord.Company = 'SoluCan';
		leadRecord.Street = '57 Steeles Avenue West';
		leadRecord.City = 'Toronto';
		leadRecord.State = 'ON';
		leadRecord.PostalCode = 'M2M 3Y1';
		leadRecord.Country = 'Canada';
		leadRecord.Phone = '8776234512';
		leadRecord.Email = 'test@test.com';
		insert leadRecord;
        
        System.debug('Lead Country'+leadRecord.Country);
        System.debug('LeadId - '+leadRecord.Id);
		
        Account customerAccountRecord = new Account(
            Name = 'Test SMB Account',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SMB').getRecordTypeId()
        );
        insert customerAccountRecord;
        
        CampaignMember campMemberRec = new CampaignMember();
        campMemberRec.CampaignId = campaignRecord.Id;
		campMemberRec.LeadId = leadRecord.id;
		
        insert campMemberRec;
        
        CampaignMember campObj = [select id,CampaignMember.ContactId,Lead.Salutation,Lead.FirstName,Lead.LastName,Lead.Status,Lead.Company,Lead.Street,Lead.City,Lead.State,Lead.PostalCode,Lead.Country,Lead.Phone,Lead.Email from CampaignMember where id = :campMemberRec.id];
            
            
        System.debug('LeadId on Campaign member - '+campMemberRec.LeadId);
        System.debug('Country-->'+campObj.Lead.Country);
        
        Test.startTest();
        icLogicCampaignMember icLogicObj = new icLogicCampaignMember();
        icLogicCampaignMember.Impl implObj = new icLogicCampaignMember.Impl();
        implObj.getShippingRequestDTOFromCampaignMember(campObj);
        Test.stopTest();
        
    }

	@IsTest
    static void testgetShippingRequestDTOFromCampaignMemberLeadCountryNotCanada() {
        Campaign campaignRecord = new Campaign();
        campaignRecord.Name = 'U-ON-RT-F21-P03-N-001-BU-AE - Blog';
        campaignRecord.Status = 'Planned';
        campaignRecord.Channel__c = 'Direct Email';
        campaignRecord.IsActive = true;
        campaignRecord.Type = 'Upsell';
        insert campaignRecord;
        
		Lead leadRecord = new Lead();
		leadRecord.Salutation = 'Mrs.';
		leadRecord.FirstName = 'Testleadfnm';
        leadRecord.LastName = 'Testleadlnm';
		leadRecord.Status = 'SQL';
        leadRecord.Company = 'SoluCan';
		leadRecord.Street = '57 Steeles Avenue West';
		leadRecord.City = 'Toronto';
		leadRecord.State = 'ON';
		leadRecord.PostalCode = 'M2M 3Y1';
		leadRecord.Country = 'Mexico';
		leadRecord.Phone = '8776234512';
		leadRecord.Email = 'test@test.com';
		insert leadRecord;
        
        System.debug('Lead Country'+leadRecord.Country);
        System.debug('LeadId - '+leadRecord.Id);
		
        Account customerAccountRecord = new Account(
            Name = 'Test SMB Account',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SMB').getRecordTypeId()
        );
        insert customerAccountRecord;
        
        CampaignMember campMemberRec = new CampaignMember();
        campMemberRec.CampaignId = campaignRecord.Id;
		campMemberRec.LeadId = leadRecord.id;
		
        insert campMemberRec;
        
        CampaignMember campObj = [select id,CampaignMember.ContactId,Lead.Salutation,Lead.FirstName,Lead.LastName,Lead.Status,Lead.Company,Lead.Street,Lead.City,Lead.State,Lead.PostalCode,Lead.Country,Lead.Phone,Lead.Email from CampaignMember where id = :campMemberRec.id];
            
            
        System.debug('LeadId on Campaign member - '+campMemberRec.LeadId);
        System.debug('Country-->'+campObj.Lead.Country);
        
        Test.startTest();
        icLogicCampaignMember icLogicObj = new icLogicCampaignMember();
        icLogicCampaignMember.Impl implObj = new icLogicCampaignMember.Impl();
        implObj.getShippingRequestDTOFromCampaignMember(campObj);
        Test.stopTest();
        
    }

	@IsTest
    static void testgetShippingRequestDTOFromCampaignMemberContactNotNull() {
        Campaign campaignRecord = new Campaign();
        campaignRecord.Name = 'U-ON-RT-F21-P03-N-001-BU-AE - Blog';
        campaignRecord.Status = 'Planned';
        campaignRecord.Channel__c = 'Direct Email';
        campaignRecord.IsActive = true;
        campaignRecord.Type = 'Upsell';
        insert campaignRecord;
        
        Account customerAccountRecord = new Account(
            Name = 'Test SMB Account',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SMB').getRecordTypeId()
        );
        insert customerAccountRecord;		
		
		
        Contact conRecord = new Contact();
		conRecord.Salutation = 'Mrs.';
        conRecord.FirstName = 'Testfirstnm';
        conRecord.LastName = 'Testlastnm';
        conRecord.Phone = '7847567833';
		conRecord.Email = 'test1@test.com';
		conRecord.Alternate_Email__c = 'test2@test.com';
		conRecord.MailingStreet = '57 Steeles Avenue West';
		conRecord.MailingCity = 'Toronto';
		conRecord.MailingState = 'ON';
		conRecord.MailingPostalCode = 'M2M 3Y1';
		conRecord.MailingCountry = 'Canada';
        conRecord.AccountId = customerAccountRecord.Id;

        insert conRecord;
	
        
        CampaignMember campMemberRec = new CampaignMember();
        campMemberRec.CampaignId = campaignRecord.Id;
		campMemberRec.ContactId = conRecord.id;
		
        insert campMemberRec;
        
        CampaignMember campObj = [select id,ContactId,Contact.Account.Name,Contact.Salutation,Contact.FirstName,Contact.LastName,Contact.Phone,Contact.Email,Contact.Alternate_Email__c,Contact.MailingStreet,Contact.MailingCity,Contact.MailingState,Contact.MailingPostalCode,Contact.MailingCountry from CampaignMember where id = :campMemberRec.id];
                   
        Test.startTest();
        icLogicCampaignMember icLogicObj = new icLogicCampaignMember();
        icLogicCampaignMember.Impl implObj = new icLogicCampaignMember.Impl();
        implObj.getShippingRequestDTOFromCampaignMember(campObj);
        Test.stopTest();
        
    }

	@IsTest
    static void testgetShippingRequestDTOFromCampaignMemberContactcountryNotCanada() {
        Campaign campaignRecord = new Campaign();
        campaignRecord.Name = 'U-ON-RT-F21-P03-N-001-BU-AE - Blog';
        campaignRecord.Status = 'Planned';
        campaignRecord.Channel__c = 'Direct Email';
        campaignRecord.IsActive = true;
        campaignRecord.Type = 'Upsell';
        insert campaignRecord;
        
        Account customerAccountRecord = new Account(
            Name = 'Test SMB Account',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SMB').getRecordTypeId()
        );
        insert customerAccountRecord;		
		
		
        Contact conRecord = new Contact();
		conRecord.Salutation = 'Mrs.';
        conRecord.FirstName = 'Testfirstnm';
        conRecord.LastName = 'Testlastnm';
        conRecord.Phone = '7847567833';
		conRecord.Email = 'test1@test.com';
		conRecord.Alternate_Email__c = 'test2@test.com';
		conRecord.MailingStreet = '57 Steeles Avenue West';
		conRecord.MailingCity = 'Toronto';
		conRecord.MailingState = 'QC';
		conRecord.MailingPostalCode = 'M2M 3Y1';
		conRecord.MailingCountry = 'Mexico';
        conRecord.AccountId = customerAccountRecord.Id;

        insert conRecord;
	
        
        CampaignMember campMemberRec = new CampaignMember();
        campMemberRec.CampaignId = campaignRecord.Id;
		campMemberRec.ContactId = conRecord.id;
		
        insert campMemberRec;
        
        CampaignMember campObj = [select id,ContactId,Contact.Account.Name,Contact.Salutation,Contact.FirstName,Contact.LastName,Contact.Phone,Contact.Email,Contact.Alternate_Email__c,Contact.MailingStreet,Contact.MailingCity,Contact.MailingState,Contact.MailingPostalCode,Contact.MailingCountry from CampaignMember where id = :campMemberRec.id];
                   
        Test.startTest();
        icLogicCampaignMember icLogicObj = new icLogicCampaignMember();
        icLogicCampaignMember.Impl implObj = new icLogicCampaignMember.Impl();
        implObj.getShippingRequestDTOFromCampaignMember(campObj);
        Test.stopTest();
        
    }	
	
	@IsTest
    static void testgetShippingRequestDTOFromCampaignMemberContactStateDifferent() {
        Campaign campaignRecord = new Campaign();
        campaignRecord.Name = 'U-ON-RT-F21-P03-N-001-BU-AE - Blog';
        campaignRecord.Status = 'Planned';
        campaignRecord.Channel__c = 'Direct Email';
        campaignRecord.IsActive = true;
        campaignRecord.Type = 'Upsell';
        insert campaignRecord;
        
        Account customerAccountRecord = new Account(
            Name = 'Test SMB Account',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SMB').getRecordTypeId()
        );
        insert customerAccountRecord;		
		
		
        Contact conRecord = new Contact();
		conRecord.Salutation = 'Mrs.';
        conRecord.FirstName = 'Testfirstnm';
        conRecord.LastName = 'Testlastnm';
        conRecord.Phone = '7847567833';
		conRecord.Email = 'test1@test.com';
		conRecord.Alternate_Email__c = 'test2@test.com';
		conRecord.MailingStreet = '57 Steeles Avenue West';
		conRecord.MailingCity = 'Toronto';
		conRecord.MailingState = 'HD';
		conRecord.MailingPostalCode = 'M2M 3Y1';
		conRecord.MailingCountry = 'Mexico';
        conRecord.AccountId = customerAccountRecord.Id;

        insert conRecord;
	
        
        CampaignMember campMemberRec = new CampaignMember();
        campMemberRec.CampaignId = campaignRecord.Id;
		campMemberRec.ContactId = conRecord.id;
		
        insert campMemberRec;
        
        CampaignMember campObj = [select id,ContactId,Contact.Account.Name,Contact.Salutation,Contact.FirstName,Contact.LastName,Contact.Phone,Contact.Email,Contact.Alternate_Email__c,Contact.MailingStreet,Contact.MailingCity,Contact.MailingState,Contact.MailingPostalCode,Contact.MailingCountry from CampaignMember where id = :campMemberRec.id];
                   
        Test.startTest();
        icLogicCampaignMember icLogicObj = new icLogicCampaignMember();
        icLogicCampaignMember.Impl implObj = new icLogicCampaignMember.Impl();
        implObj.getShippingRequestDTOFromCampaignMember(campObj);
        Test.stopTest();
        
    }	
	
	@IsTest
    static void testgetUpdatedCampaignMemberFromCISLConfirmation(){
        Account a = new Account(Name='Account Test');
        insert a;
            
        Pricebook2 testPricebook = new Pricebook2(Name = 'TestPricebook7', IsActive = true);
        insert testPricebook;
            
        vlocity_cmt__PriceList__c pl1 = new vlocity_cmt__PriceList__c(vlocity_cmt__Pricebook2Id__c = testPricebook.Id, vlocity_cmt__IsActive__c = true, vlocity_cmt__Code__c = 'TestPricebook5');
        insert pl1;
            
            
        Order testOrder = new Order(Name='Test Order',EffectiveDate=System.today(),status='Draft',AccountId = a.Id, vlocity_cmt__PriceListId__c = pl1.Id, Pricebook2Id = testPricebook.Id);
        insert testOrder;
        
                Campaign campaignRecord = new Campaign();
        campaignRecord.Name = 'U-ON-RT-F21-P03-N-001-BU-AE - Blog';
        campaignRecord.Status = 'Planned';
        campaignRecord.Channel__c = 'Direct Email';
        campaignRecord.IsActive = true;
        campaignRecord.Type = 'Upsell';
        insert campaignRecord;
        
        Account customerAccountRecord = new Account(
            Name = 'Test SMB Account',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SMB').getRecordTypeId()
        );
        insert customerAccountRecord;
        
        Contact conRecord = new Contact();
        conRecord.FirstName = 'Testfirstnm';
        conRecord.LastName = 'Testlastnm';
        conRecord.Phone = '7847567833';
        conRecord.AccountId = customerAccountRecord.Id;
        insert conRecord;
        
        CampaignMember campMemberRec = new CampaignMember();
        campMemberRec.CampaignId = campaignRecord.Id;
        campMemberRec.ContactId = conRecord.id;
        insert campMemberRec;
        
        icDTOShippingConfirmation  dtoShippingConfirmation = new icDTOShippingConfirmation();
        dtoShippingConfirmation.deliveryRequestID=campMemberRec.Id;
        dtoShippingConfirmation.orderID=testOrder.Id;
        dtoShippingConfirmation.shippingWaybillNumber='12345';
        dtoShippingConfirmation.shippingWaybillStatus='Done';
        dtoShippingConfirmation.shippingReturnWaybillNumber='12345';
        dtoShippingConfirmation.referencecustomerRef1='';
        dtoShippingConfirmation.referencecustomerRef2='';
        dtoShippingConfirmation.resourceID='';
        dtoShippingConfirmation.resourceIDType='';
        dtoShippingConfirmation.shippingDate='2023-10-11';	

        Test.startTest();
        icLogicCampaignMember icLogicObj = new icLogicCampaignMember();
        icLogicCampaignMember.Impl implObj = new icLogicCampaignMember.Impl();
        implObj.getUpdatedCampaignMemberFromCISLConfirmation(dtoShippingConfirmation);
        Test.stopTest();	
	}
	
	@IsTest
    static void testupdateCampaignMember(){
        Campaign campaignRecord = new Campaign();
        campaignRecord.Name = 'U-ON-RT-F21-P03-N-001-BU-AE - Blog';
        campaignRecord.Status = 'Planned';
        campaignRecord.Channel__c = 'Direct Email';
        campaignRecord.IsActive = true;
        campaignRecord.Type = 'Upsell';
        insert campaignRecord;
        
        Account customerAccountRecord = new Account(
            Name = 'Test SMB Account',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SMB').getRecordTypeId()
        );
        insert customerAccountRecord;		
		
		
        Contact conRecord = new Contact();
		conRecord.Salutation = 'Mrs.';
        conRecord.FirstName = 'Testfirstnm';
        conRecord.LastName = 'Testlastnm';
        conRecord.Phone = '7847567833';
		conRecord.Email = 'test1@test.com';
		conRecord.Alternate_Email__c = 'test2@test.com';
		conRecord.MailingStreet = '57 Steeles Avenue West';
		conRecord.MailingCity = 'Toronto';
		conRecord.MailingState = 'ON';
		conRecord.MailingPostalCode = 'M2M 3Y1';
		conRecord.MailingCountry = 'Canada';
        conRecord.AccountId = customerAccountRecord.Id;

        insert conRecord;
	
        
        CampaignMember campMemberRec = new CampaignMember();
        campMemberRec.CampaignId = campaignRecord.Id;
		campMemberRec.ContactId = conRecord.id;
		
        insert campMemberRec;
		
		Test.startTest();
        icLogicCampaignMember icLogicObj = new icLogicCampaignMember();
        icLogicCampaignMember.Impl implObj = new icLogicCampaignMember.Impl();
        implObj.updateCampaignMember(campMemberRec);
        Test.stopTest();
	}		
}