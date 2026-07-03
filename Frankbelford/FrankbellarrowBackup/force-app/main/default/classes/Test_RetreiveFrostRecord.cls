@isTest
public class Test_RetreiveFrostRecord {
    
  /*  static testMethod void RetreiveFrostRecordsTest() 
    {
        Id recordTypeId = [select Id from RecordType where DeveloperName = 'IP_2ndTierCandidate' limit 1].Id;
        system.debug('recordType-->'+recordTypeId);
        Contact con = new Contact();
        con.LastName = 'TestLastName';
        con.Title = 'TestLastName';
        con.Initials__c = 'TestLastName';
        con.FirstName = 'TestLastName';
        con.sirenum__National_Insurance__c = 'AA123456A';
        con.Birthdate = Date.valueOf('1990-02-20');
        con.MailingStreet = 'TestLastName';
        con.MailingCity = 'TestLastName';
        con.MailingCountry = 'TestLastName';
        con.MailingPostalCode = 'TestLastName';
        con.Phone = '9879879877';
        con.Phone_Type__c = '1';
        con.Salutation = 'Mr.';
        con.RecordTypeId = recordTypeId;
        con.ts2__EEO_Gender__c = 'M';
        con.IP_CategoryOfWork__c='Catering;Industrial';        
        system.debug('contact created-->'+con);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        insert con;
        update con;
        //delete con;
        Test.stopTest();
    }*/
    
    static testMethod void RetreiveFrostRecordsPayProfileTest() 
    {
        List<Account> acc = TestDataFactory.createCandidateAccount(1);
        insert acc;
        Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Candidate').getRecordTypeId();//[select Id from RecordType where DeveloperName = 'Candidate' and  limit 1].Id;
        Contact con = new Contact();
        con.LastName = 'TestLastName';
        con.Title = 'TestLastName';
        con.Initials__c = 'TestLastName';
        con.FirstName = 'TestLastName';
        con.sirenum__National_Insurance__c = 'AA123456A';
        con.Birthdate = Date.valueOf('1990-02-20');
        con.MailingStreet = 'TestLastName';
        con.MailingCity = 'TestLastName';
        con.MailingCountry = 'TestLastName';
        con.MailingPostalCode = 'TestLastName';
        con.Phone = '9879879877';
        //con.Phone_Type__c = '1';
        con.Salutation = 'Mr.';
        con.RecordTypeId = recordTypeId;
        con.ts2__EEO_Gender__c = 'M';
        con.IP_CategoryOfWork__c='Catering;Industrial';
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        insert con;
        
             insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
        IP_PayProfile__c payProfile = new IP_PayProfile__c();
        payProfile.IP_Candidate__c = con.Id;
        payProfile.IP_CompanyRegNo__c= 'AS123456';
        //payProfile.IP_PayrollID__c = 'EL13063';
        insert payProfile;
        Test.stopTest();
    }
    static testMethod void RetreiveFrostRecordsCoverUpUpdateAndDelete() 
    {        
        List<Account> acc = TestDataFactory.createCandidateAccount(1);
        insert acc;
        
        Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Candidate').getRecordTypeId();//[select Id from RecordType where DeveloperName = 'Candidate' and  limit 1].Id;
        Contact con = new Contact();
        con.LastName = 'TestLastName';
        con.Title = 'TestLastName';
        con.Initials__c = 'TestLastName';
        con.FirstName = 'TestLastName';
        con.sirenum__National_Insurance__c = 'AA123456A';
        con.Birthdate = Date.valueOf('1990-02-20');
        con.MailingStreet = 'TestLastName';
        con.MailingCity = 'TestLastName';
        con.MailingCountry = 'TestLastName';
        con.MailingPostalCode = 'TestLastName';
        con.Phone = '9879879877';
        //con.Phone_Type__c = '1';
        con.Salutation = 'Mr.';
        con.RecordTypeId = recordTypeId;
        con.ts2__EEO_Gender__c = 'M';
        con.IP_CategoryOfWork__c='Catering;Industrial';
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        insert con;
             insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
       IP_PayProfile__c payProfile = new IP_PayProfile__c();
        payProfile.IP_Candidate__c = con.Id;
        payProfile.IP_CompanyRegNo__c= 'AS123456';
        payProfile.IP_VATRegistered__c = true;
        insert payProfile;
        update payProfile;
        delete payProfile;
        
        update con;
        delete con;
        Test.stopTest();
    }
     static testMethod void umbrellalist1() 
    {        
        List<Account> acc = TestDataFactory.createCandidateAccount(1);
        insert acc;
        
        Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Candidate').getRecordTypeId();//[select Id from RecordType where DeveloperName = 'Candidate' and  limit 1].Id;
        Contact con = new Contact();
        con.LastName = 'TestLastNamedcs';
        con.Title = 'TestLastName';
        con.Initials__c = 'TestLastName';
        con.FirstName = 'TestLastNamesdcs';
        con.sirenum__National_Insurance__c = 'AA123456A';
        con.Birthdate = Date.valueOf('1990-02-20');
        con.MailingStreet = 'TestLastName';
        con.MailingCity = 'TestLastName';
        con.MailingCountry = 'TestLastName';
        con.MailingPostalCode = 'TestLastName';
        con.Phone = '69063679191';
        //con.Phone_Type__c = '1';
        con.Salutation = 'Mr.';
        con.RecordTypeId = recordTypeId;
        con.ts2__EEO_Gender__c = 'M';
        con.IP_CategoryOfWork__c='Catering;Industrial';
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        insert con;
		
		IP_Umbrellalist__c umblist = new IP_Umbrellalist__c();
		umblist.Name = 'Test Name';
		umblist.IP_AddressLine1__c = 'Line1';
		umblist.IP_AddressLine2__c = 'Line 2';
		umblist.IP_AddressLine3__c = 'Line3';
		umblist.IP_Postcode__c = '6gqjh7';
		umblist.IP_BankAccountName__c = 'Name1';
		umblist.IP_BankAccountNumber__c = '12345678';
		umblist.IP_BankSortCode__c = '123456';
		umblist.IP_BuildingSocietyNo__c = '12345n';
		umblist.IP_CompanyRegNo__c = '11111111';
		umblist.IP_OkToSupply__c = 1;
		umblist.IP_SupplierReference__c = '576';
		umblist.IP_VATRegistered__c = 1;
		umblist.VAT_Number__c = '123456789';
        umblist.IP_PaymentType__c = 'B';
		insert umblist;
        
        IP_Umbrellalist__c umblist1 = new IP_Umbrellalist__c();
		umblist1.Name = 'Test Name111';
		umblist1.IP_AddressLine1__c = 'Line1';
		umblist1.IP_AddressLine2__c = 'Line 2';
		umblist1.IP_AddressLine3__c = 'Line3';
		umblist1.IP_Postcode__c = '6gqjh7';
		umblist1.IP_BankAccountName__c = 'Name1';
		umblist1.IP_BankAccountNumber__c = '12345678';
		umblist1.IP_BankSortCode__c = '123456';
		umblist1.IP_BuildingSocietyNo__c = '12345n';
		umblist1.IP_CompanyRegNo__c = '11111111';
		umblist1.IP_OkToSupply__c = 1;
		umblist1.IP_SupplierReference__c = '576';
		umblist1.IP_VATRegistered__c = 1;
		umblist1.VAT_Number__c = '123456789';
        umblist1.IP_PaymentType__c = 'B';
		insert umblist1;
        		
      
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = false); 
    insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= false);
        RecordType condRec1 = [Select Id  From RecordType Where sObjectType = 'IP_PayProfile__c' And DeveloperName='Umbrella'];
        
        IP_PayProfile__c pp1 = new IP_PayProfile__c();
        pp1.IP_Candidate__c=con.id;
        pp1.RecordTypeId = condRec1.id;
        pp1.IP_UmbrellaName__c = umblist.id;                                         
        
        insert pp1;
        pp1.IP_UmbrellaName__c = umblist1.id;
        update pp1;
     //   insert payProfile;
      //  update payProfile;
       // delete payProfile;
        
        update con;
        delete con;
        Test.stopTest();
    }
}