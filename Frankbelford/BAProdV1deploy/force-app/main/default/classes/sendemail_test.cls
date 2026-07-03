@isTest
public class sendemail_test{
    
    public static testmethod void sendemail1()
    {
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= true);
        
        insert new IP_Shift_Template__c(name = '1062', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='1234',Branch_Address__c='street1',Email__c='miltonkeynes@bluearrow.co.uk',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');
       
        Account acc =  TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
        Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
        con.email='ritu.hetawal@espire.com';
        insert con;
        
        sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
        insert ct;
        
        sirenum__Rota__c sec = new sirenum__Rota__c();
        sec.name='driving';
        insert sec;
        
        sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
        insert jobcate;
        
        sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
        job.sirenum__Rota__c = sec.id;
        insert job;
        
        //Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
        
        /*User u = new User(LastName = 'LIVESTON',FirstName='JASON',Alias = 'jliv',Email = 'mm.sf@outlook.com',
Username = 'dummyEmail6786367@email.com', ProfileId = p.id, TimeZoneSidKey = 'GMT',
LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8', LocaleSidKey = 'en_US',IP_TempestDepartment__c='1062',
IP_TempestDivision__c='NTS',Department='1062',IP_PassToTempest__c=true); 

insert u;*/
        
        IP_TopazGlobalClientInformation__c globalclient = new IP_TopazGlobalClientInformation__c();
        globalclient.Name='Test global topaz';
        globalclient.IP_StatusID__c=2;
        globalclient.IP_SalesLedgerNumber__c='123';
        insert globalclient;
        
        sirenum__Site__c site = new sirenum__Site__c();
        
        site.Name = 'Shop Direct - Shaw Key';
        site.sirenum__Operating_Company__c= acc.id;
        site.IP_ClientIDLegacy__c='123';
        site.GlobalClientName__c=globalclient.id;
        site.IP_ClientInvoiceName__c='Testclient';
        site.IP_InvoiceAddressStreet__c='101';
        site.IP_InvoiceAddressCity__c = 'Delhi';
        site.IP_InvoiceAddressPostcode__c = '110035';
        
        //   site.IP_InvoiceContact__c = maincon.id;
        //  site.IP_MainContact__c = maincon.id;
        site.IP_PublicSector__c = 'No';
        insert site;
        
        sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, UserInfo.getUserId(), 1)[0];
        ps.sirenum__site__c = site.id;
        insert ps;
        OrgWideEmailAddress[] addresses = [SELECT Id FROM OrgWideEmailAddress LIMIT 1];
        Test.startTest();
        sendemail.sendemailtimseheet(ps.id);
        pageReference pdfPage = Page.Manual_TimeSheet_Design;
        pdfPage.getParameters().put('id',String.valueOf(ps.id));
        
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
        system.assertEquals(0, invocations, 'no email sent');
 }
    
    public static testmethod void sendemail2()
    {
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= true);
        insert new IP_Shift_Template__c(name = '1062', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='1234',Branch_Address__c='street1',Email__c='miltonkeynes@bluearrow.co.uk',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');
        
        Account acc =  TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
        Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
        con.email='ritu.hetawal@espire.com';
        insert con;
        
        sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
        insert ct;
        
        sirenum__Rota__c sec = new sirenum__Rota__c();
        sec.name='impellamsector';
        insert sec;
        
        sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
        insert jobcate;
        
        sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
        job.sirenum__Rota__c = sec.id;
        insert job;
        
        /*Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
User u = new User(LastName = 'LIVESTON',FirstName='JASON1212',Alias = 'jliv',Email = 'mm.sf@outlook.com',
Username = 'dummyEmailgueghwgyte@email.com', ProfileId = p.id, TimeZoneSidKey = 'GMT',
LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8', LocaleSidKey = 'en_US',IP_TempestDepartment__c='1062',
IP_TempestDivision__c='NTS',Department='1062',IP_PassToTempest__c=true); 
insert u;*/
        
        IP_TopazGlobalClientInformation__c globalclient = new IP_TopazGlobalClientInformation__c();
        globalclient.Name='Test global topaz';
        globalclient.IP_StatusID__c=2;
        globalclient.IP_SalesLedgerNumber__c='123';
        insert globalclient;
        
        sirenum__Site__c site = new sirenum__Site__c();
        
        site.Name = 'Shop Direct - Shaw Key';
        site.sirenum__Operating_Company__c= acc.id;
        site.IP_ClientIDLegacy__c='123';
        site.GlobalClientName__c=globalclient.id;
        site.IP_ClientInvoiceName__c='Testclient';
        site.IP_InvoiceAddressStreet__c='101';
        site.IP_InvoiceAddressCity__c = 'Delhi';
        site.IP_InvoiceAddressPostcode__c = '110035';
        
        // site.IP_InvoiceContact__c = maincon.id;
        // site.IP_MainContact__c = maincon.id;
        site.IP_PublicSector__c = 'No';
        insert site;
        
        sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, UserInfo.getUserId(), 1)[0];
        ps.IP_Consultant1LookupSplitShare__c = UserInfo.getUserId();
        ps.sirenum__site__c = site.id;
        insert ps;
        
        Test.startTest();
        sendemail.sendemailtimseheet(ps.id);
        pageReference pdfPage = Page.Manual_TimeSheet_Design_2;
        pdfPage.getParameters().put('id',String.valueOf(ps.id)); 
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
        system.assertEquals(0, invocations, 'no email sent');
        
    }
    
    public static testmethod void sendemail3()
    {
        Profile adminProf = [SELECT Id from Profile where Name='System Administrator' LIMIT 1];
        List<User> userLst = TestDataFactory.createUsers(adminProf.Id,1);
        userLst[0].UserPreferencesLightningExperiencePreferred = true;
        userLst[0].IP_TempestDepartment__c = '1062';
        insert userLst[0];
        System.runAs(userLst[0]){
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= true);
        insert new IP_Shift_Template__c(name = '1062', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='1234',Branch_Address__c='street1',Email__c='miltonkeynes@bluearrow.co.uk',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');
        
        Account acc =  TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
        Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
        //con.email='ritu.hetawal@espire.com';
        insert con;
        
        sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
        insert ct;
        
        sirenum__Rota__c sec = new sirenum__Rota__c();
        sec.name='impellamsector';
        insert sec;
        
        sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
        insert jobcate;
        
        sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
        job.sirenum__Rota__c = sec.id;
        insert job;
        
        /*Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
User u = new User(LastName = 'LIVESTqwqeON',FirstName='JASON',Alias = 'jliv',Email = 'mm.sf@outlook.com',
Username = 'dummyEmail008917hnjgbjk@email.com', ProfileId = p.id, TimeZoneSidKey = 'GMT',
LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8', LocaleSidKey = 'en_US',IP_TempestDepartment__c='1062',
IP_TempestDivision__c='NTS',Department='1062',IP_PassToTempest__c=true); 
insert u;*/
        
        IP_TopazGlobalClientInformation__c globalclient = new IP_TopazGlobalClientInformation__c();
        globalclient.Name='Test global topaz';
        globalclient.IP_StatusID__c=2;
        globalclient.IP_SalesLedgerNumber__c='123';
        insert globalclient;
        
        sirenum__Site__c site = new sirenum__Site__c();
        
        site.Name = 'Shop Direct - Shaw Key';
        site.sirenum__Operating_Company__c= acc.id;
        site.IP_ClientIDLegacy__c='123';
        site.GlobalClientName__c=globalclient.id;
        site.IP_ClientInvoiceName__c='Testclient';
        site.IP_InvoiceAddressStreet__c='101';
        site.IP_InvoiceAddressCity__c = 'Delhi';
        site.IP_InvoiceAddressPostcode__c = '110035';
        
        // site.IP_InvoiceContact__c = maincon.id;
        //  site.IP_MainContact__c = maincon.id;
        site.IP_PublicSector__c = 'No';
        insert site;
        
        sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, UserInfo.getUserId(), 1)[0];
        ps.IP_Consultant1LookupSplitShare__c = UserInfo.getUserId();
        ps.sirenum__site__c = site.id;
        insert ps;
        
        Test.startTest();
        sendemail.sendemailtimseheet(ps.id);
        pageReference pdfPage = Page.Manual_TimeSheet_Design_2;
        pdfPage.getParameters().put('id',String.valueOf(ps.id)); 
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
        system.assertEquals(0, invocations, 'no email sent');
        }
    }
    public static testmethod void sendemail4()
    {
        Profile adminProf = [SELECT Id from Profile where Name='System Administrator' LIMIT 1];
        List<User> userLst = TestDataFactory.createUsers(adminProf.Id,1);
        userLst[0].UserPreferencesLightningExperiencePreferred = true;
        userLst[0].IP_TempestDepartment__c = '1062';
        insert userLst[0];
        System.runAs(userLst[0]){
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= true);
        insert new IP_Shift_Template__c(name = '1062', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='1234',Branch_Address__c='street1',Email__c='miltonkeynes@bluearrow.co.uk',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');
        
        Account acc =  TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
        Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
        // con.email='ritu.hetawal@espire.com';
        insert con;
        
        sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
        insert ct;
        
        sirenum__Rota__c sec = new sirenum__Rota__c();
        sec.name='driving';
        insert sec;
        
        sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
        insert jobcate;
        
        sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
        job.sirenum__Rota__c = sec.id;
        insert job;
        
        /*Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
User u = new User(LastName = 'LIVEwefSTON',FirstName='JAwcSON',Alias = 'jliv',Email = 'mm.sf@outlook.com',
Username = 'dummyEmailngbjui086816@email.com', ProfileId = p.id, TimeZoneSidKey = 'GMT',
LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8', LocaleSidKey = 'en_US',IP_TempestDepartment__c='1062',
IP_TempestDivision__c='NTS',Department='1062',IP_PassToTempest__c=true); 
insert u;*/
        
        IP_TopazGlobalClientInformation__c globalclient = new IP_TopazGlobalClientInformation__c();
        globalclient.Name='Test global topaz';
        globalclient.IP_StatusID__c=2;
        globalclient.IP_SalesLedgerNumber__c='123';
        insert globalclient;
        
        sirenum__Site__c site = new sirenum__Site__c();
        
        site.Name = 'Shop Direct - Shaw Key';
        site.sirenum__Operating_Company__c= acc.id;
        site.IP_ClientIDLegacy__c='123';
        site.GlobalClientName__c=globalclient.id;
        site.IP_ClientInvoiceName__c='Testclient';
        site.IP_InvoiceAddressStreet__c='101';
        site.IP_InvoiceAddressCity__c = 'Delhi';
        site.IP_InvoiceAddressPostcode__c = '110035';
        
        // site.IP_InvoiceContact__c = maincon.id;
        //  site.IP_MainContact__c = maincon.id;
        site.IP_PublicSector__c = 'No';
        insert site;
        
        sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id,userLst[0].Id , 1)[0];
        ps.sirenum__site__c = site.id;
        insert ps;
        
        Test.startTest();
        sendemail.sendemailtimseheet(ps.id);
        pageReference pdfPage = Page.Manual_TimeSheet_Design;
        pdfPage.getParameters().put('id',String.valueOf(ps.id));
        
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
        system.assertEquals(0, invocations, 'no email sent');
    }
    
    }
}