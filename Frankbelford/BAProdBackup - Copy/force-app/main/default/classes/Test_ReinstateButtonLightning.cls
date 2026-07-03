/**
 * DATE: 30/07/2020
 * MR: THIS TEST CLASS NEEDS TO BE PART OF TECHNICAL DEBT STORY TO ADD ASSERTION.
 * CODE IS MODIFIED TO INCORPORATE NEW CUSTOM SETTING DefaultAccounts__c
 */

@isTest
public class Test_ReinstateButtonLightning
{

  public static testmethod void testcase1(){
      Account acc = TestDataFactory.createClients(1)[0]; 
      insert acc; 
      insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=acc.Id);
      insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
      insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
      Contact c = new Contact();
      c.FirstName='Con';
      c.lastName='Test Contact';
      c.IP_CategoryOfWork__c='Industrial';
      c.sirenum__National_Insurance__c='AA123456A';
      c.P45_Date_by_Head_Office__c=system.today();
      c.AccountID=acc.id;
      insert c;
        
      insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
       RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'PAYE'];
       
        IP_PayProfile__c pay= new IP_PayProfile__c();
        pay.RecordTypeId=rt.id;
        pay.IP_PayrollID__c='Testpayrol';
        pay.IP_Status__c='Inactive';
        pay.IP_Candidate__c=c.Id;
        pay.IP_CompanyRegNo__c='12345678';
        pay.IP_VATRegistered__c=true;
        pay.IP_VATNumber__c='123456789';
        pay.P45_Initiated__c=true;
        pay.IP_LastPassedTotempest__c = Date.newInstance(2017, 01, 01);
        pay.IP_Payroll_Leaver__c = 'PL';
        insert pay;
        
        id certId = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Driving Licence').getRecordTypeId();
        ts2__Certification__c cert = new ts2__Certification__c();
        cert.ts2__Contact__c = c.id;
        cert.RecordTypeId = certId;
        cert.Valid_From__c = System.today();
        cert.Valid_To__c = System.today().addDays(10);
        cert.Verfied__c = true;
        insert cert;
        
        sirenum__TicketType__c ttype = new sirenum__TicketType__c();
        ttype.name = 'LGV C1 Licence';
        insert ttype;
        
        sirenum__Ticket__c tt = new sirenum__Ticket__c();
        tt.sirenum__TicketType__c = ttype.id;
        tt.sirenum__Owner__c = c.id;
        tt.sirenum__Valid_from__c = System.today();
        tt.sirenum__Valid_until__c = System.today().addDays(20); 
        insert tt;
        Test.startTest();
        ReinstateButtonLightning.getPayProfileDetail(pay.id);
        ReinstateButtonLightning.updatedata(pay.id);
        Test.stopTest();
    }
    public static testmethod void testcase2(){
      Account acc = TestDataFactory.createClients(1)[0]; 
      insert acc; 
      insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=acc.Id);
      insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
      insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
      Contact c = new Contact();
      c.FirstName='Con';
      c.lastName='Test Contact';
      c.IP_CategoryOfWork__c='Industrial';
      c.sirenum__National_Insurance__c='AA123456A';
      c.P45_Date_by_Head_Office__c=system.today();
      c.AccountID=acc.id;
      insert c;

      insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
      RecordType rt1=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'PAYE'];

      IP_PayProfile__c pay1= new IP_PayProfile__c();
      pay1.RecordTypeId=rt1.id;
      pay1.IP_PayrollID__c='Testpayrol';
      pay1.IP_Status__c='Inactive';
      pay1.IP_Candidate__c=c.Id;
      pay1.IP_CompanyRegNo__c='12345678';
      pay1.IP_VATRegistered__c=true;
      pay1.IP_VATNumber__c='123456789';
      pay1.P45_Initiated__c=true;
      pay1.IP_LastPassedTotempest__c = Date.newInstance(2017, 01, 01);
      pay1.IP_Payroll_Leaver__c = 'PL';
      insert pay1;

      RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'LTD'];

      IP_PayProfile__c pay= new IP_PayProfile__c();
      pay.RecordTypeId=rt.id;
      pay.IP_PayrollID__c='Testp76rol';
      pay.IP_Status__c='Active';
      pay.IP_Candidate__c=c.Id;
      pay.IP_CompanyRegNo__c='12345678';
      pay.IP_VATRegistered__c=true;
      pay.IP_VATNumber__c='123456789';
      insert pay;

      id certId = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Driving Licence').getRecordTypeId();
      ts2__Certification__c cert = new ts2__Certification__c();
      cert.ts2__Contact__c = c.id;
      cert.RecordTypeId = certId;
      cert.Valid_From__c = System.today();
      cert.Valid_To__c = System.today().addDays(10);
      cert.Verfied__c = true;
      insert cert;

      id certId1 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Limited Company Contract').getRecordTypeId();
      ts2__Certification__c cert1 = new ts2__Certification__c();
      cert1.ts2__Contact__c = c.id;
      cert1.RecordTypeId = certId1;
      cert1.Verfied__c = true;
      insert cert1;

      id certId2 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('TOE').getRecordTypeId();
      ts2__Certification__c cert2 = new ts2__Certification__c();
      cert2.ts2__Contact__c = c.id;
      cert2.RecordTypeId = certId2;
      cert2.TOE_Agreement__c = TRUE;
      cert2.Verfied__c = true;
      insert cert2;

      sirenum__TicketType__c ttype = new sirenum__TicketType__c();
      ttype.name = 'LGV C1 Licence';
      insert ttype;

      sirenum__Ticket__c tt = new sirenum__Ticket__c();
      tt.sirenum__TicketType__c = ttype.id;
      tt.sirenum__Owner__c = c.id;
      tt.sirenum__Valid_from__c = System.today();
      tt.sirenum__Valid_until__c = System.today().addDays(20); 
      insert tt;

      Test.startTest();
      ReinstateButtonLightning.getPayProfileDetail(pay1.id);
      ReinstateButtonLightning.updatedata(pay1.id);
      Test.stopTest();
    }
     public static testmethod void testcase3()
    {
         Account acc = TestDataFactory.createClients(1)[0]; 
        insert acc;
        insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=acc.Id);
                        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
         Contact c = new Contact();
        c.FirstName='Con';
        c.lastName='Test Contact';
        c.IP_CategoryOfWork__c='Industrial';
        c.sirenum__National_Insurance__c='AA123456A';
        c.P45_Date_by_Head_Office__c=system.today();
        c.AccountID=acc.id;
        insert c;
        
         insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
       RecordType rt1=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'PAYE'];
       
        IP_PayProfile__c pay1= new IP_PayProfile__c();
        pay1.RecordTypeId=rt1.id;
        pay1.IP_PayrollID__c='Testpayrol';
        pay1.IP_Status__c='Inactive';
        pay1.IP_Candidate__c=c.Id;
        pay1.IP_CompanyRegNo__c='12345678';
        pay1.IP_VATRegistered__c=true;
        pay1.IP_VATNumber__c='123456789';
        pay1.P45_Initiated__c=true;
        pay1.IP_LastPassedTotempest__c = Date.newInstance(2017, 01, 01);
        pay1.IP_Payroll_Leaver__c = 'PL';
        insert pay1;
    
        
        RecordType rt2=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'Umbrella'];
       
        IP_PayProfile__c pay2= new IP_PayProfile__c();
        pay2.RecordTypeId=rt2.id;
        pay2.IP_PayrollID__c='Test65rol';
        pay2.IP_Status__c='Active';
        pay2.IP_Candidate__c=c.Id;
        pay2.IP_CompanyRegNo__c='12345678';
        pay2.IP_VATRegistered__c=true;
        pay2.IP_VATNumber__c='123456789';
        pay2.IP_OkToSupply__c = 1;
        insert pay2;
        
        id certId = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Driving Licence').getRecordTypeId();
        ts2__Certification__c cert = new ts2__Certification__c();
        cert.ts2__Contact__c = c.id;
        cert.RecordTypeId = certId;
        cert.Valid_From__c = System.today();
        cert.Valid_To__c = System.today().addDays(10);
        cert.Verfied__c = true;
        insert cert;
        
        id certId1 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Limited Company Contract').getRecordTypeId();
        ts2__Certification__c cert1 = new ts2__Certification__c();
        cert1.ts2__Contact__c = c.id;
        cert1.RecordTypeId = certId1;
        cert1.Verfied__c = true;
        insert cert1;
        
        id certId2 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('TOE').getRecordTypeId();
        ts2__Certification__c cert2 = new ts2__Certification__c();
        cert2.ts2__Contact__c = c.id;
        cert2.RecordTypeId = certId2;
        cert2.TOE_Agreement__c = TRUE;
        cert2.Verfied__c = true;
        insert cert2;
        
        sirenum__TicketType__c ttype = new sirenum__TicketType__c();
        ttype.name = 'LGV C1 Licence';
        insert ttype;
        
        sirenum__Ticket__c tt = new sirenum__Ticket__c();
        tt.sirenum__TicketType__c = ttype.id;
        tt.sirenum__Owner__c = c.id;
        tt.sirenum__Valid_from__c = System.today();
        tt.sirenum__Valid_until__c = System.today().addDays(20); 
        insert tt;
        
        ReinstateButtonLightning.getPayProfileDetail(pay1.id);
        ReinstateButtonLightning.updatedata(pay1.id);
    }
    public static testmethod void testcase4()
    {
         Account acc = TestDataFactory.createClients(1)[0]; 
        insert acc;
        insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=acc.Id);
                        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
         Contact c = new Contact();
        c.FirstName='Con';
        c.lastName='Test Contact';
        c.IP_CategoryOfWork__c='Industrial';
        c.sirenum__National_Insurance__c='AA123456A';
        c.P45_Date_by_Head_Office__c=system.today();
        c.AccountID=acc.id;
        insert c;
        
         insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
       RecordType rt2=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'Umbrella'];
       
        IP_PayProfile__c pay2= new IP_PayProfile__c();
        pay2.RecordTypeId=rt2.id;
        pay2.IP_PayrollID__c='Test65rol';
        pay2.IP_Status__c='Active';
        pay2.IP_Candidate__c=c.Id;
        pay2.IP_CompanyRegNo__c='12345678';
        pay2.IP_VATRegistered__c=true;
        pay2.IP_VATNumber__c='123456789';
        pay2.IP_OkToSupply__c = 1;
        insert pay2;
    
        
       RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'LTD'];
       
        IP_PayProfile__c pay= new IP_PayProfile__c();
        pay.RecordTypeId=rt.id;
        pay.IP_PayrollID__c='Testp76rol';
        pay.IP_Status__c='Inactive';
        pay.IP_Candidate__c=c.Id;
        pay.IP_CompanyRegNo__c='12345678';
        pay.IP_VATRegistered__c=true;
        pay.IP_VATNumber__c='123456789';
        insert pay;
        
        id certId = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Driving Licence').getRecordTypeId();
        ts2__Certification__c cert = new ts2__Certification__c();
        cert.ts2__Contact__c = c.id;
        cert.RecordTypeId = certId;
        cert.Valid_From__c = System.today();
        cert.Valid_To__c = System.today().addDays(10);
        cert.Verfied__c = true;
        insert cert;
        
        id certId1 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Limited Company Contract').getRecordTypeId();
        ts2__Certification__c cert1 = new ts2__Certification__c();
        cert1.ts2__Contact__c = c.id;
        cert1.RecordTypeId = certId1;
        cert1.Verfied__c = true;
        insert cert1;
        
        id certId2 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('TOE').getRecordTypeId();
        ts2__Certification__c cert2 = new ts2__Certification__c();
        cert2.ts2__Contact__c = c.id;
        cert2.TOE_Agreement__c = TRUE;
        cert2.RecordTypeId = certId2;
        cert2.Verfied__c = true;
        insert cert2;
        
        sirenum__TicketType__c ttype = new sirenum__TicketType__c();
        ttype.name = 'LGV C1 Licence';
        insert ttype;
        
        sirenum__Ticket__c tt = new sirenum__Ticket__c();
        tt.sirenum__TicketType__c = ttype.id;
        tt.sirenum__Owner__c = c.id;
        tt.sirenum__Valid_from__c = System.today();
        tt.sirenum__Valid_until__c = System.today().addDays(20); 
        insert tt;
        
        ReinstateButtonLightning.getPayProfileDetail(pay.id);
        ReinstateButtonLightning.updatedata(pay.id);
    }
    public static testmethod void testcase5()
    {
         Account acc = TestDataFactory.createClients(1)[0]; 
        insert acc; 
        insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=acc.Id);
                        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
         Contact c = new Contact();
        c.FirstName='Con';
        c.lastName='Test Contact';
        c.IP_CategoryOfWork__c='Industrial';
        c.sirenum__National_Insurance__c='AA123456A';
        c.P45_Date_by_Head_Office__c=system.today();
        c.AccountID=acc.id;
        insert c;
        
         insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
       RecordType rt1=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'PAYE'];
       
        IP_PayProfile__c pay1= new IP_PayProfile__c();
        pay1.RecordTypeId=rt1.id;
        pay1.IP_PayrollID__c='Testpayrol';
        pay1.IP_Status__c='Active';
        pay1.IP_Candidate__c=c.Id;
        pay1.IP_CompanyRegNo__c='12345678';
        pay1.IP_VATRegistered__c=true;
        pay1.IP_VATNumber__c='123456789';
        pay1.P45_Initiated__c=true;
        pay1.IP_LastPassedTotempest__c = Date.newInstance(2017, 01, 01);
        pay1.IP_Payroll_Leaver__c = 'PL';
        insert pay1;
    
        
       RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'LTD'];
       
        IP_PayProfile__c pay= new IP_PayProfile__c();
        pay.RecordTypeId=rt.id;
        pay.IP_PayrollID__c='Testp76rol';
        pay.IP_Status__c='Inactive';
        pay.IP_Candidate__c=c.Id;
        pay.IP_CompanyRegNo__c='12345678';
        pay.IP_VATRegistered__c=true;
        pay.IP_VATNumber__c='123456789';
        insert pay;
        
        id certId = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Driving Licence').getRecordTypeId();
        ts2__Certification__c cert = new ts2__Certification__c();
        cert.ts2__Contact__c = c.id;
        cert.RecordTypeId = certId;
        cert.Valid_From__c = System.today();
        cert.Valid_To__c = System.today().addDays(10);
        cert.Verfied__c = true;
        insert cert;
        
        id certId1 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Limited Company Contract').getRecordTypeId();
        ts2__Certification__c cert1 = new ts2__Certification__c();
        cert1.ts2__Contact__c = c.id;
        cert1.RecordTypeId = certId1;
        cert1.Verfied__c = true;
        insert cert1;
        
        id certId2 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('TOE').getRecordTypeId();
        ts2__Certification__c cert2 = new ts2__Certification__c();
        cert2.ts2__Contact__c = c.id;
        cert2.RecordTypeId = certId2;
        cert2.TOE_Agreement__c = TRUE;
        cert2.Verfied__c = true;
        insert cert2;
        
        sirenum__TicketType__c ttype = new sirenum__TicketType__c();
        ttype.name = 'LGV C1 Licence';
        insert ttype;
        
        sirenum__Ticket__c tt = new sirenum__Ticket__c();
        tt.sirenum__TicketType__c = ttype.id;
        tt.sirenum__Owner__c = c.id;
        tt.sirenum__Valid_from__c = System.today();
        tt.sirenum__Valid_until__c = System.today().addDays(20); 
        insert tt;
        
        ReinstateButtonLightning.getPayProfileDetail(pay.id);
        ReinstateButtonLightning.updatedata(pay.id);
    }
    public static testmethod void testcase6()
    {
         Account acc = TestDataFactory.createClients(1)[0]; 
        insert acc;
        insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=acc.Id);
                        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
         Contact c = new Contact();
        c.FirstName='Con';
        c.lastName='Test Contact';
        c.IP_CategoryOfWork__c='Industrial';
        c.sirenum__National_Insurance__c='AA123456A';
        c.P45_Date_by_Head_Office__c=system.today();
        c.AccountID=acc.id;
        insert c;
        
         insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
       RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'PAYE'];
       
        IP_PayProfile__c pay= new IP_PayProfile__c();
        pay.RecordTypeId=rt.id;
        pay.IP_PayrollID__c='Testpayrol';
        pay.IP_Status__c='Active';
        pay.IP_Candidate__c=c.Id;
        pay.IP_CompanyRegNo__c='12345678';
        pay.IP_VATRegistered__c=true;
        pay.IP_VATNumber__c='123456789';
        pay.P45_Initiated__c=true;
        pay.IP_LastPassedTotempest__c = Date.newInstance(2017, 01, 01);
        pay.IP_Payroll_Leaver__c = 'PL';
        insert pay;
        
        id certId = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Driving Licence').getRecordTypeId();
        ts2__Certification__c cert = new ts2__Certification__c();
        cert.ts2__Contact__c = c.id;
        cert.RecordTypeId = certId;
        cert.Valid_From__c = System.today();
        cert.Valid_To__c = System.today().addDays(10);
        cert.Verfied__c = true;
        insert cert;
        
        sirenum__TicketType__c ttype = new sirenum__TicketType__c();
        ttype.name = 'LGV C1 Licence';
        insert ttype;
        
        sirenum__Ticket__c tt = new sirenum__Ticket__c();
        tt.sirenum__TicketType__c = ttype.id;
        tt.sirenum__Owner__c = c.id;
        tt.sirenum__Valid_from__c = System.today();
        tt.sirenum__Valid_until__c = System.today().addDays(20); 
        insert tt;
        
        ReinstateButtonLightning.getPayProfileDetail(pay.id);
        ReinstateButtonLightning.updatedata(pay.id);
    }
     public static testmethod void testcase7()
    {
         Account acc = TestDataFactory.createClients(1)[0]; 
        insert acc;
        insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=acc.Id);
                        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
         Contact c = new Contact();
        c.FirstName='Con';
        c.lastName='Test Contact';
        c.IP_CategoryOfWork__c='Industrial';
        c.sirenum__National_Insurance__c='AA123456A';
        c.P45_Date_by_Head_Office__c=system.today();
        c.AccountID=acc.id;
        insert c;
        
         insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
       RecordType rt1=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'PAYE'];
       
        IP_PayProfile__c pay1= new IP_PayProfile__c();
        pay1.RecordTypeId=rt1.id;
        pay1.IP_PayrollID__c='Testpayrol';
        pay1.IP_Status__c='Active';
        pay1.IP_Candidate__c=c.Id;
        pay1.IP_CompanyRegNo__c='12345678';
        pay1.IP_VATRegistered__c=true;
        pay1.IP_VATNumber__c='123456789';
        pay1.P45_Initiated__c=true;
        pay1.IP_LastPassedTotempest__c = Date.newInstance(2017, 01, 01);
        pay1.IP_Payroll_Leaver__c = 'PL';
        insert pay1;
        
         RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'LTD'];
       
        IP_PayProfile__c pay= new IP_PayProfile__c();
        pay.RecordTypeId=rt.id;
        pay.IP_PayrollID__c='Testp76rol';
        pay.IP_Status__c='Active';
        pay.IP_Candidate__c=c.Id;
        pay.IP_CompanyRegNo__c='12345678';
        pay.IP_VATRegistered__c=true;
        pay.IP_VATNumber__c='123456789';
        insert pay;
        
        id certId = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Driving Licence').getRecordTypeId();
        ts2__Certification__c cert = new ts2__Certification__c();
        cert.ts2__Contact__c = c.id;
        cert.RecordTypeId = certId;
        cert.Valid_From__c = System.today();
        cert.Valid_To__c = System.today().addDays(10);
        cert.Verfied__c = true;
        insert cert;
        
        id certId1 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Limited Company Contract').getRecordTypeId();
        ts2__Certification__c cert1 = new ts2__Certification__c();
        cert1.ts2__Contact__c = c.id;
        cert1.RecordTypeId = certId1;
        cert1.Verfied__c = true;
        insert cert1;
        
        id certId2 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('TOE').getRecordTypeId();
        ts2__Certification__c cert2 = new ts2__Certification__c();
        cert2.ts2__Contact__c = c.id;
        cert2.RecordTypeId = certId2;
        cert2.TOE_Agreement__c = TRUE;
        cert2.Verfied__c = true;
        insert cert2;
        
        sirenum__TicketType__c ttype = new sirenum__TicketType__c();
        ttype.name = 'LGV C1 Licence';
        insert ttype;
        
        sirenum__Ticket__c tt = new sirenum__Ticket__c();
        tt.sirenum__TicketType__c = ttype.id;
        tt.sirenum__Owner__c = c.id;
        tt.sirenum__Valid_from__c = System.today();
        tt.sirenum__Valid_until__c = System.today().addDays(20); 
        insert tt;
        
       ReinstateButtonLightning.getPayProfileDetail(pay1.id);
        ReinstateButtonLightning.updatedata(pay1.id);
    }
     public static testmethod void testcase8()
    {
         Account acc = TestDataFactory.createClients(1)[0]; 
        insert acc;
        insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=acc.Id);
                        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = true);
         Contact c = new Contact();
        c.FirstName='Con';
        c.lastName='Test Contact';
        c.IP_CategoryOfWork__c='Industrial';
        c.sirenum__National_Insurance__c='AA123456A';
        c.P45_Date_by_Head_Office__c=system.today();
        c.AccountID=acc.id;
        insert c;
        
         insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
       RecordType rt1=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'PAYE'];
       
        IP_PayProfile__c pay1= new IP_PayProfile__c();
        pay1.RecordTypeId=rt1.id;
        pay1.IP_PayrollID__c='Testpayrol';
        pay1.IP_Status__c='Active';
        pay1.IP_Candidate__c=c.Id;
        pay1.IP_CompanyRegNo__c='12345678';
        pay1.IP_VATRegistered__c=true;
        pay1.IP_VATNumber__c='123456789';
        pay1.P45_Initiated__c=true;
        pay1.IP_LastPassedTotempest__c = Date.newInstance(2017, 01, 01);
        pay1.IP_Payroll_Leaver__c = 'PL';
        insert pay1;
    
        
        RecordType rt2=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'Umbrella'];
       
        IP_PayProfile__c pay2= new IP_PayProfile__c();
        pay2.RecordTypeId=rt2.id;
        pay2.IP_PayrollID__c='Test65rol';
        pay2.IP_Status__c='Active';
        pay2.IP_Candidate__c=c.Id;
        pay2.IP_CompanyRegNo__c='12345678';
        pay2.IP_VATRegistered__c=true;
        pay2.IP_VATNumber__c='123456789';
        pay2.IP_OkToSupply__c = 1;
        insert pay2;
        
        id certId = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Driving Licence').getRecordTypeId();
        ts2__Certification__c cert = new ts2__Certification__c();
        cert.ts2__Contact__c = c.id;
        cert.RecordTypeId = certId;
        cert.Valid_From__c = System.today();
        cert.Valid_To__c = System.today().addDays(10);
        cert.Verfied__c = true;
        insert cert;
        
        id certId1 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Limited Company Contract').getRecordTypeId();
        ts2__Certification__c cert1 = new ts2__Certification__c();
        cert1.ts2__Contact__c = c.id;
        cert1.RecordTypeId = certId1;
        cert1.Verfied__c = true;
        insert cert1;
        
        id certId2 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('TOE').getRecordTypeId();
        ts2__Certification__c cert2 = new ts2__Certification__c();
        cert2.ts2__Contact__c = c.id;
        cert2.RecordTypeId = certId2;
        cert2.TOE_Agreement__c = TRUE;
        cert2.Verfied__c = true;
        insert cert2;
        
        sirenum__TicketType__c ttype = new sirenum__TicketType__c();
        ttype.name = 'LGV C1 Licence';
        insert ttype;
        
        sirenum__Ticket__c tt = new sirenum__Ticket__c();
        tt.sirenum__TicketType__c = ttype.id;
        tt.sirenum__Owner__c = c.id;
        tt.sirenum__Valid_from__c = System.today();
        tt.sirenum__Valid_until__c = System.today().addDays(20); 
        insert tt;
        
        ReinstateButtonLightning.getPayProfileDetail(pay1.id);
        ReinstateButtonLightning.updatedata(pay1.id);
    }
    public static testmethod void testcase9()
    {
         Account acc = TestDataFactory.createClients(1)[0]; 
        insert acc;
        insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=acc.Id);
                        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = true);
         Contact c = new Contact();
        c.FirstName='Con';
        c.lastName='Test Contact';
        c.IP_CategoryOfWork__c='Industrial';
        c.sirenum__National_Insurance__c='AA123456A';
        c.P45_Date_by_Head_Office__c=system.today();
        c.AccountID=acc.id;
        insert c;
        
         insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
       RecordType rt2=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'Umbrella'];
       
        IP_PayProfile__c pay2= new IP_PayProfile__c();
        pay2.RecordTypeId=rt2.id;
        pay2.IP_PayrollID__c='Test65rol';
        pay2.IP_Status__c='Active';
        pay2.IP_Candidate__c=c.Id;
        pay2.IP_CompanyRegNo__c='12345678';
        pay2.IP_VATRegistered__c=true;
        pay2.IP_VATNumber__c='123456789';
        pay2.IP_OkToSupply__c = 1;
        insert pay2;
    
        
       RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'LTD'];
       
        IP_PayProfile__c pay= new IP_PayProfile__c();
        pay.RecordTypeId=rt.id;
        pay.IP_PayrollID__c='Testp76rol';
        pay.IP_Status__c='Active';
        pay.IP_Candidate__c=c.Id;
        pay.IP_CompanyRegNo__c='12345678';
        pay.IP_VATRegistered__c=true;
        pay.IP_VATNumber__c='123456789';
        insert pay;
        
        id certId = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Driving Licence').getRecordTypeId();
        ts2__Certification__c cert = new ts2__Certification__c();
        cert.ts2__Contact__c = c.id;
        cert.RecordTypeId = certId;
        cert.Valid_From__c = System.today();
        cert.Valid_To__c = System.today().addDays(10);
        cert.Verfied__c = true;
        insert cert;
        
        id certId1 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Limited Company Contract').getRecordTypeId();
        ts2__Certification__c cert1 = new ts2__Certification__c();
        cert1.ts2__Contact__c = c.id;
        cert1.RecordTypeId = certId1;
        cert1.Verfied__c = true;
        insert cert1;
        
        id certId2 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('TOE').getRecordTypeId();
        ts2__Certification__c cert2 = new ts2__Certification__c();
        cert2.ts2__Contact__c = c.id;
        cert2.RecordTypeId = certId2;
        cert2.TOE_Agreement__c = TRUE;
        cert2.Verfied__c = true;
        insert cert2;
        
        sirenum__TicketType__c ttype = new sirenum__TicketType__c();
        ttype.name = 'LGV C1 Licence';
        insert ttype;
        
        sirenum__Ticket__c tt = new sirenum__Ticket__c();
        tt.sirenum__TicketType__c = ttype.id;
        tt.sirenum__Owner__c = c.id;
        tt.sirenum__Valid_from__c = System.today();
        tt.sirenum__Valid_until__c = System.today().addDays(20); 
        insert tt;
        
        ReinstateButtonLightning.getPayProfileDetail(pay.id);
        ReinstateButtonLightning.updatedata(pay.id);
    }
    public static testmethod void testcase10()
    {
         Account acc = TestDataFactory.createClients(1)[0]; 
        insert acc;
        insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=acc.Id);
                        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
         Contact c = new Contact();
        c.FirstName='Con';
        c.lastName='Test Contact';
        c.IP_CategoryOfWork__c='Industrial';
        c.sirenum__National_Insurance__c='AA123456A';
        c.P45_Date_by_Head_Office__c=system.today();
        c.AccountID=acc.id;
        insert c;
        
         insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
       RecordType rt1=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'PAYE'];
       
        IP_PayProfile__c pay1= new IP_PayProfile__c();
        pay1.RecordTypeId=rt1.id;
        pay1.IP_PayrollID__c='Testpayrol';
        pay1.IP_Status__c='Active';
        pay1.IP_Candidate__c=c.Id;
        pay1.IP_CompanyRegNo__c='12345678';
        pay1.IP_VATRegistered__c=true;
        pay1.IP_VATNumber__c='123456789';
        pay1.P45_Initiated__c=true;
        pay1.IP_LastPassedTotempest__c = Date.newInstance(2017, 01, 01);
        pay1.IP_Payroll_Leaver__c = 'PL';
        insert pay1;
    
        
       RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'LTD'];
       
        IP_PayProfile__c pay= new IP_PayProfile__c();
        pay.RecordTypeId=rt.id;
        pay.IP_PayrollID__c='Testp76rol';
        pay.IP_Status__c='Active';
        pay.IP_Candidate__c=c.Id;
        pay.IP_CompanyRegNo__c='12345678';
        pay.IP_VATRegistered__c=true;
        pay.IP_VATNumber__c='123456789';
        insert pay;
        
        id certId = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Driving Licence').getRecordTypeId();
        ts2__Certification__c cert = new ts2__Certification__c();
        cert.ts2__Contact__c = c.id;
        cert.RecordTypeId = certId;
        cert.Valid_From__c = System.today();
        cert.Valid_To__c = System.today().addDays(10);
        cert.Verfied__c = true;
        insert cert;
        
        id certId1 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('Limited Company Contract').getRecordTypeId();
        ts2__Certification__c cert1 = new ts2__Certification__c();
        cert1.ts2__Contact__c = c.id;
        cert1.RecordTypeId = certId1;
        cert1.Verfied__c = true;
        insert cert1;
        
        id certId2 = Schema.SObjectType.ts2__Certification__c.getRecordTypeInfosByName().get('TOE').getRecordTypeId();
        ts2__Certification__c cert2 = new ts2__Certification__c();
        cert2.ts2__Contact__c = c.id;
        cert2.RecordTypeId = certId2;
        cert2.TOE_Agreement__c = TRUE;
        cert2.Verfied__c = true;
        insert cert2;
        
        sirenum__TicketType__c ttype = new sirenum__TicketType__c();
        ttype.name = 'LGV C1 Licence';
        insert ttype;
        
        sirenum__Ticket__c tt = new sirenum__Ticket__c();
        tt.sirenum__TicketType__c = ttype.id;
        tt.sirenum__Owner__c = c.id;
        tt.sirenum__Valid_from__c = System.today();
        tt.sirenum__Valid_until__c = System.today().addDays(20); 
        insert tt;
        
       ReinstateButtonLightning.getPayProfileDetail(pay.id);
        ReinstateButtonLightning.updatedata(pay.id);
    }
}