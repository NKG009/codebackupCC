@Istest
public class ActiveVacancyControlller_Test {
    @IsTest static void testActiveVacanyController(){
        Payroll_Swtich__c ps = new Payroll_Swtich__c();
        ps.Name = 'Stoppayroll';
        ps.Batch_check__c = false;
        
        insert ps;
        
        sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
        insert sec;
        
        sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
        insert jobcate;
        
        Account acc = TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
        
        Contact con = TestDataFactory.createCandidate(acc.id,1)[0]; 
        insert con;
        
       // Contact con1 = TestDataFactory.createCandidate(acc.id,1)[0]; 
        //insert con1;
        
        sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
        pc.Name = 'Saturday - Friday';
        pc.sirenum__CyclePeriodUnits__c= 'Weeks';
        pc.sirenum__periodLength__c = Decimal.valueOf(7);
        pc.sirenum__StartingDate__c = Date.newInstance(2036, 03, 15);  
        insert pc;
        
        sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
        ct.sirenum__PayrollCycle__c = pc.id;
        insert ct;
        
        sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
        insert job;
        
        IP_TopazGlobalClientInformation__c topzClientInfo = TestDataFactory.createTopaz(1)[0];
        topzClientInfo.Name = acc.Name;
        topzClientInfo.IP_SalesLedgerNumber__c='345432';
        insert topzClientInfo;
        
        List<sirenum__Site__c> siteList = new List<sirenum__Site__c>();
        sirenum__Site__c ssite = new sirenum__Site__c();
        ssite.Name = 'my site';
        ssite.IP_InvoiceAddressCity__c = 'ballia';
        ssite.IP_InvoiceAddressStreet__c = 'street1';
        ssite.sirenum__Operating_Company__c = acc.Id;
        ssite.IP_InvoiceContact__c = con.id;
        ssite.GlobalClientName__c = topzClientInfo.Id;
        ssite.IP_ClientIDLegacy__c = 'eww3';
        ssite.IP_Clientinvoicename__c = 'invoice name';
        ssite.IP_InvoiceAddressCountry__c = 'ind';
        ssite.IP_InvoiceAddressCounty__c = 'cnt';
        ssite.IP_InvoiceAddressPostcode__c = 'E12 3DD';
        ssite.IP_PublicSector__c = 'No';
        ssite.IP_PassClientToTempest__c = true;
        ssite.IP_ClientLastPassedToTempest__c = null;
        ssite.Credit_Status__c = 'Credit Approved';
        //sirenum__Postal_Code__c = 'TE12 3AA',
        ssite.IP_PassClientAddressToTempest__c = true;
        
        insert ssite; 
        siteList.add(ssite);
        
        
        sirenum__Site__c siteSF = siteList[0];
        siteSF.Name='Test site one - Saturday to Friday';
        siteSF.Process_TS_Line_Automatically__c=true;
        
        Contact_Site_link__c siteLinkSF = new Contact_Site_link__c(Account__c=acc.Id
                                                                   ,IP_Contact__c =con.Id
                                                                   ,IP_PortalType__c='Primary Hours Approver'
                                                                   ,IP_Site__c = siteSF.Id);
        insert siteLinkSF;
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Customer Community Login User' LIMIT 1];
        User usr = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser@example.com' + System.currentTimeMillis(),
            Alias = 'tuser',
            ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ContactId = con.Id  
        );
        insert usr;
        
        
        Test.startTest();
        
        System.runAs(usr) {
            User ur = ActiveVacancyControlller.getUserInformation();
            List<sirenum__Site__c> lstSite = ActiveVacancyControlller.getSites();
            System.debug('================ lst site : '+lstSite);
            List<sirenum__Shift__c> lstShift = ActiveVacancyControlller.getAllShifts(siteList[0].Id, job.Name, 'Mon, 6 May 15 - Thu, 6 Jun 19');
            List<sirenum__Shift__c> lstShift1 = ActiveVacancyControlller.getAllShifts(siteList[0].Id, job.Name, 'Mon, 6 May 15');
            List<sirenum__Shift__c> lstShift2 = ActiveVacancyControlller.getAllShifts(siteList[0].Id, job.Name, 'From today...');
            List<sirenum__Team__c> lstTeam = ActiveVacancyControlller.getJobRoleList(siteList[0].Id);
        }
        
        Test.stopTest();
    }
}