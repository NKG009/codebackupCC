@isTest
public class AccountTriggerHelperTest {
    @testSetup
    static void setup() {
        Manage_Triggers__c cs1 = new Manage_Triggers__c();
        cs1.Name = 'AccountTrigger';
        cs1.isActive__c = true;
        insert cs1;
    }

    static testMethod void apiAgentChangeTest() {
        RecordType PropertyRecordType = [Select Id From RecordType Where sObjectType = 'Account'
            And DeveloperName = 'Property'
        ];
        RecordType AgencyRecordType = [Select Id From RecordType Where sObjectType = 'Account'
            And Name = 'Real Estate Office'                                
        ];
        Account accFirstAgency = new Account(
        Name = 'FirstAgency',
        RecordTypeId = AgencyRecordType.Id 
        );
        insert accFirstAgency;
        Account acc = new Account(
            Name = 'FirstTestAccount',
            RecordTypeId = PropertyRecordType.Id,
            ParentId=accFirstAgency.id
        );
        insert acc;
        Account accSecond = new Account(
            Name = 'FirstTestAccount',
            RecordTypeId = PropertyRecordType.Id,
            ParentId=accFirstAgency.id
        );
        insert accSecond;
        AccountContactId__c accnt = new AccountContactId__c(
            Name = acc.Id
        );
        insert accnt;
        AccountContactId__c accntSecond = new AccountContactId__c(
            Name = accSecond.Id
        );
        insert accntSecond;
        AccountContactId__c accntThird = new AccountContactId__c(
            Name = accSecond.Id
        );
        insert accntThird;
        System.assertEquals(accnt.name,acc.id);
        System.assertEquals(accntSecond.name,accSecond.id);
    }
    static testMethod void HandleChangesOnNewAccountListTest() {
        RecordType PropertyRecordType = [Select Id From RecordType Where sObjectType = 'Account'
            And DeveloperName = 'Property'
        ];
        RecordType AgencyRecordType = [Select Id From RecordType Where sObjectType = 'Account'
            And Name = 'Real Estate Office'                                
        ];
        Test.startTest();
        
        Account accFirstAgency = new Account(
        Name = 'FirstAgency',
        RecordTypeId = AgencyRecordType.Id,  
        Invoice_Recipient_Preferences__c = 'Both Agency and Property Manager',
        Document_Receipt_Preferences__c = 'Both Agency and Property Manager'
        );
        insert accFirstAgency;
        Account accFirstProperty = new Account(
        Name = 'FirstProperty',
        RecordTypeId = PropertyRecordType.Id, //Set this account to the Property Record Type 
        ParentId = accFirstAgency.Id
        );
        insert accFirstProperty;
        Account accSecondAgency = new Account(
        Name = 'SecondAgency',
        RecordTypeId = AgencyRecordType.Id,  
        Invoice_Recipient_Preferences__c = 'Agency Address Only',
        Document_Receipt_Preferences__c = 'Agency Address Only'
        );
        insert accSecondAgency;
        Account accSecondProperty = new Account(
        Name = 'SecondProperty',
        RecordTypeId = PropertyRecordType.Id, //Set this account to the Property Record Type 
        ParentId = accSecondAgency.Id
        );
        insert accSecondProperty;  
        Account accThirdAgency = new Account(
        Name = 'ThirdAgency',
        RecordTypeId = AgencyRecordType.Id,  
        Invoice_Recipient_Preferences__c = 'Property Manager Only',
        Document_Receipt_Preferences__c = 'Property Manager Only'
        );
        insert accThirdAgency;
        Account accThirdProperty = new Account(
        Name = 'ThirdProperty',
        RecordTypeId = PropertyRecordType.Id, //Set this account to the Property Record Type 
        ParentId = accThirdAgency.Id
        );
        insert accThirdProperty; 
        Account accForthAgency = new Account(
        Name = 'ForthAgency',
        RecordTypeId = AgencyRecordType.Id, //Set this account to the Agency Record Type 
        Invoice_Recipient_Preferences__c ='Post to Property Me Only',
        Document_Receipt_Preferences__c = 'Post to Property Me Only'
        );
        insert accForthAgency;
        Account accForthProperty = new Account(
        Name = 'ForthProperty',
        RecordTypeId = PropertyRecordType.Id, //Set this account to the Property Record Type 
        ParentId = accForthAgency.Id
        );
        insert accForthProperty;

        Test.stopTest();
        Account result = [SELECT invoice_preference_formula__c,Document_Receipt_Preferences_Formula__c from Account where Id =:accFirstProperty.Id];
        System.assertEquals('Both Agency and Property Manager', result.Document_Receipt_Preferences_Formula__c,result.invoice_preference_formula__c);
        Account secondResult = [SELECT invoice_preference_formula__c,Document_Receipt_Preferences_Formula__c from Account where Id =:accSecondProperty.Id];
        System.assertEquals('Agency Address Only',secondResult.invoice_preference_formula__c);
        System.assertEquals('Agency Address only',secondResult.Document_Receipt_Preferences_Formula__c);
        Account thirdResult = [SELECT invoice_preference_formula__c,Document_Receipt_Preferences_Formula__c from Account where Id =:accThirdProperty.Id];
        System.assertEquals('Property Manager Only', thirdResult.invoice_preference_formula__c);
        System.assertEquals('Property Manager only', thirdResult.Document_Receipt_Preferences_Formula__c);
        Account forthResult = [SELECT invoice_preference_formula__c,Document_Receipt_Preferences_Formula__c from Account where Id =:accForthProperty.Id];
        System.assertEquals('Post to Property Me Only',forthResult.invoice_preference_formula__c, forthResult.Document_Receipt_Preferences_Formula__c);
    }
    static testMethod void HandleUpdatingChildRecordsTest() {
        RecordType PropertyRecordType = [Select Id From RecordType Where sObjectType = 'Account'
            And DeveloperName = 'Property'
        ];
        RecordType AgencyRecordType = [Select Id From RecordType Where sObjectType = 'Account'
            And Name = 'Real Estate Office'                                
        ];
        Test.startTest();
        Account accFirstAgency = new Account(
        Name = 'FirstAgency',
        RecordTypeId = AgencyRecordType.Id, //Set this account to the Agency Record Type 
        Invoice_Recipient_Preferences__c = 'Both Agency and Property Manager',
        Document_Receipt_Preferences__c = 'Both Agency and Property Manager'
        );
        insert accFirstAgency;
        Account accFirstProperty = new Account(
        Name = 'FirstProperty',
        RecordTypeId = PropertyRecordType.Id, //Set this account to the Property Record Type 
        ParentId = accFirstAgency.Id
        );
        insert accFirstProperty;
        accFirstAgency.Invoice_Recipient_Preferences__c = 'Agency Address Only';
        accFirstAgency.Document_Receipt_Preferences__c = 'Agency Address only';
        update accFirstAgency;

        Test.stopTest();
        Account firstResult = [SELECT invoice_preference_formula__c,Document_Receipt_Preferences_Formula__c from Account where Id =:accFirstProperty.Id];
        System.assertEquals('Agency Address Only', firstResult.invoice_preference_formula__c);
        System.assertEquals('Agency Address only', firstResult.Document_Receipt_Preferences_Formula__c);
        
    }
       static testMethod void HandleUpdatingChildRecordsSecondTest() {
        RecordType PropertyRecordType = [Select Id From RecordType Where sObjectType = 'Account'
            And DeveloperName = 'Property'
        ];
        RecordType AgencyRecordType = [Select Id From RecordType Where sObjectType = 'Account'
            And Name = 'Real Estate Office'                                
        ];
        Test.startTest();
        Account accSecondAgency = new Account(
        Name = 'SecondAgency',
        RecordTypeId = AgencyRecordType.Id, //Set this account to the Agency Record Type 
        Invoice_Recipient_Preferences__c = 'Agency Address Only',
        Document_Receipt_Preferences__c = 'Agency Address Only'
        );
        insert accSecondAgency;
        Account accSecondProperty = new Account(
        Name = 'SecondProperty',
        RecordTypeId = PropertyRecordType.Id, //Set this account to the Property Record Type 
        ParentId = accSecondAgency.Id
        );
        insert accSecondProperty;
        accSecondAgency.Invoice_Recipient_Preferences__c = 'Property Manager Only';
        accSecondAgency.Document_Receipt_Preferences__c = 'Property Manager only';
        update accSecondAgency;

        Test.stopTest();
        Account secondResult = [SELECT invoice_preference_formula__c,Document_Receipt_Preferences_Formula__c from Account where Id =:accSecondProperty.Id];
        System.assertEquals('Property Manager Only', secondResult.invoice_preference_formula__c);
        System.assertEquals('Property Manager only', secondResult.Document_Receipt_Preferences_Formula__c);
        
    }
    static testMethod void HandleUpdatingChildRecordsThirdTest() {
        RecordType PropertyRecordType = [Select Id From RecordType Where sObjectType = 'Account'
            And DeveloperName = 'Property'
        ];
        RecordType AgencyRecordType = [Select Id From RecordType Where sObjectType = 'Account'
            And Name = 'Real Estate Office'                                
        ];
        Test.startTest();
        Account accThirdAgency = new Account(
        Name = 'ThirdAgency',
        RecordTypeId = AgencyRecordType.Id, //Set this account to the Agency Record Type 
        Invoice_Recipient_Preferences__c = 'Property Manager Only',
        Document_Receipt_Preferences__c = 'Property Manager Only'
        );
        insert accThirdAgency;
        Account accThirdProperty = new Account(
        Name = 'ThirdProperty',
        RecordTypeId = PropertyRecordType.Id, //Set this account to the Property Record Type 
        ParentId = accThirdAgency.Id
        );
        insert accThirdProperty; 
        accThirdAgency.Invoice_Recipient_Preferences__c = 'Post to Property Me Only';
        accThirdAgency.Document_Receipt_Preferences__c = 'Post to Property Me Only';
        update accThirdAgency;
        Test.stopTest();
        Account thirdResult = [SELECT invoice_preference_formula__c,Document_Receipt_Preferences_Formula__c from Account where Id =:accThirdProperty.Id];
        System.assertEquals('Post to Property Me Only', thirdResult.invoice_preference_formula__c,thirdResult.Document_Receipt_Preferences_Formula__c);
    }
    static testMethod void HandleUpdatingChildRecordsForthTest() {
        RecordType PropertyRecordType = [Select Id From RecordType Where sObjectType = 'Account'
            And DeveloperName = 'Property'
        ];
        
        RecordType AgencyRecordType = [Select Id From RecordType Where sObjectType = 'Account'
            And Name = 'Real Estate Office'                                
        ];

        Test.startTest();
        Account accForthAgency = new Account(
        Name = 'ForthAgency',
        RecordTypeId = AgencyRecordType.Id, //Set this account to the Agency Record Type 
        Invoice_Recipient_Preferences__c = 'Post to Property Me Only',
        Document_Receipt_Preferences__c = 'Post to Property Me Only'
        );
        insert accForthAgency;
        Account accForthProperty = new Account(
        Name = 'ForthProperty',
        RecordTypeId = PropertyRecordType.Id, //Set this account to the Property Record Type 
        ParentId = accForthAgency.Id
        );
        insert accForthProperty; 
        accForthAgency.Invoice_Recipient_Preferences__c = 'Both Agency and Property Manager';
        accForthAgency.Document_Receipt_Preferences__c = 'Both Agency and Property Manager';
        update accForthAgency;

        Test.stopTest();
        Account forthResult = [SELECT invoice_preference_formula__c,Document_Receipt_Preferences_Formula__c from Account where Id =:accForthProperty.Id];
        System.assertEquals('Both Agency and Property Manager', forthResult.invoice_preference_formula__c,forthResult.Document_Receipt_Preferences_Formula__c);
    }
    static testMethod void AccountSharingforPowerUserOnUpdateTest() {
        RecordType PropertyRecordType = [Select Id From RecordType Where sObjectType = 'Account'
            And DeveloperName = 'Property'
        ];
        RecordType AgencyRecordType = [Select Id From RecordType Where sObjectType = 'Account'
            And Name = 'Real Estate Office'                                
        ];
        Profile profileId = [Select ID from Profile where name ='PS360 Community Plus User'];
        Account accAgency = new Account(
        Name = 'Agency',
        RecordTypeId = AgencyRecordType.Id  
        );
        insert accAgency;
        Account accProperty = new Account(
        Name = 'ForthProperty',
        RecordTypeId = PropertyRecordType.Id, //Set this account to the Property Record Type 
        ParentId = accAgency.Id,
        Last_Service_Date__c = Date.today()
        );
        insert accProperty; 
        Account accSecondProperty = new Account(
        Name = 'ForthProperty',
        RecordTypeId = PropertyRecordType.Id, //Set this account to the Property Record Type 
        ParentId = accAgency.Id,
        Last_Service_Date__c = Date.today()
        );
        insert accSecondProperty; 
        Contact con = new Contact(
        AccountId = accAgency.id,
        Lastname = 'testcontact',
        Firstname ='testdata1',
        OwnerId = Userinfo.getUserid(),
        email = 'newtest123@firstname.com'
        );
        insert con;
        User PowerUser = new User(LastName = 'LIVESTON',
        FirstName='JASON',
        Alias = 'jliv',
        Email = 'jason.liveston@asdf.com',
        Username = 'jason.liveston@asdf.com',
        ProfileId = profileId.id,
        TimeZoneSidKey = 'GMT',
        LanguageLocaleKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        LocaleSidKey = 'en_US',
        contactid=con.id                         
        );
        insert PowerUser;
        Contact conSecond = new Contact(
        AccountId = accAgency.id,
        Lastname = 'testSecondcontact',
        Firstname ='testSeconddata1',
        OwnerId = Userinfo.getUserid(),
        email = 'newtest123Second@firstname.com'
        );
        insert conSecond;
        User PowerUserSecond = new User(LastName = 'LIVESTON',
        FirstName='David',
        Alias = 'jlivoy',
        Email = 'david.liveston5@asdf.com',
        Username = 'david.liveston5@asdf.com',
        ProfileId = profileId.id,
        TimeZoneSidKey = 'GMT',
        LanguageLocaleKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        LocaleSidKey = 'en_US',
        contactid=conSecond.id                         
        );
        insert PowerUserSecond;
        accAgency.Power_User__c = PowerUser.Id;
        Update accAgency;
        accProperty.Power_User__c=accAgency.Power_User__c;
        accSecondProperty.Power_User__c = accAgency.Power_User__c;
        Update accProperty;
        Update accSecondProperty;
        AccountShare ash = new AccountShare(
            AccountId =accProperty.Id,
         	UserOrGroupId = accProperty.Power_User__c,
        	AccountAccessLevel= 'Edit',
        	OpportunityAccessLevel='None',
        	CaseAccessLevel='None');
        insert ash;
        AccountShare ashSecond = new AccountShare(
            AccountId =accSecondProperty.Id,
         	UserOrGroupId = accSecondProperty.Power_User__c,
        	AccountAccessLevel= 'Edit',
        	OpportunityAccessLevel='None',
        	CaseAccessLevel='None');
        insert ashSecond;
        System.assertEquals('None',ashSecond.CaseAccessLevel);
        accAgency.Power_User__c = PowerUserSecond.Id;
        Update accAgency;
        Order ordFirst = new Order(
        AccountId = accProperty.Id,
        EffectiveDate = Date.today(),
            Status = 'Draft'
        );
        Insert ordFirst;
        Order ordSecond = new Order(
        AccountId = accSecondProperty.Id,
        EffectiveDate = Date.today(),
            Status = 'Draft'
        );
        Insert ordSecond;
        Bread_Winner__Invoice__c Invoice = new Bread_Winner__Invoice__c(
        	Name= 'Test',
            Bread_Winner__Account__c = accProperty.Id,
            Order_Lookup__c = ordFirst.Id
        );
            Insert Invoice;
        Bread_Winner__Invoice__c secondInvoice = new Bread_Winner__Invoice__c(
        	Name= 'TestTwo',
            Bread_Winner__Account__c = accSecondProperty.Id,
            Order_Lookup__c = ordFirst.Id
        );
            Insert secondInvoice;
  		Bread_Winner__Invoice__Share ishSecondToInsert = new Bread_Winner__Invoice__Share(
        	AccessLevel = 'Read',
            ParentId = secondInvoice.Id,
            UserOrGroupId = PowerUser.id
        );
		Insert ishSecondToInsert;
        WorkOrder WO = new WorkOrder(
        	AccountId =accProperty.Id,
            Street = 'Burley Street'
        );
        Insert WO;
        ContentVersion version = new ContentVersion(
          Title='File Name',
          PathOnClient='sample.pdf',
          VersionData=EncodingUtil.base64Decode('AA=='),
          Origin='H'
        );
        insert version;
        ContentVersion versionSecond = new ContentVersion(
          Title='File Name two',
          PathOnClient='sample2.pdf',
          VersionData=EncodingUtil.base64Decode('AA=='),
          Origin='H'
        );
        insert versionSecond;
        ContentVersion docVersion = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :version.Id];
        ContentVersion docVersionSecond = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :versionSecond.Id];
        ContentDocumentLink cdlTo = new ContentDocumentLink(
            ContentDocumentId = docVersion.ContentDocumentId,
            LinkedEntityId = Invoice.Id,
            Visibility = 'AllUsers',
             ShareType = 'V'
            );
        Insert cdlTo;
        ContentDocumentLink cdlToSecond = new ContentDocumentLink(
            ContentDocumentId = docVersion.ContentDocumentId,
            LinkedEntityId = secondInvoice.Id,
            Visibility = 'AllUsers',
             ShareType = 'V'
            );
        Insert cdlToSecond;
    }
}