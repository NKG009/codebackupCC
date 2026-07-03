@isTest
public class SitedetailsBatch_Test {
    public static testmethod void sitedetailsbatch1(){
        insert new IP_Shift_Template__c(name = '1062', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='AA12 3FF',Branch_Address__c='street1',Email__c='no.reply@bluearrow.co.uk',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');
        Account acc =  TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
        TestDataFactory.setupCustomSettings(acc.Id);
        TestDataFactory.setupUserProfileCustomSettings();

        Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
        User u = new User(LastName = 'LIVESTON',FirstName='JASON',Alias = 'jliv',Email = 'mm.sf@outlook123.com',
                Username = 'dummydcwecweEmail6786367@email.com', ProfileId = p.id, TimeZoneSidKey = 'GMT',
                LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8', LocaleSidKey = 'en_US',IP_TempestDepartment__c='1062',
                IP_TempestDivision__c='NTS',Department='1062',IP_PassToTempest__c=true, Brand__c='Blue Arrow');

        insert u;

        Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
        con.email='test@abc.com';
        con.IP_ContactType__c = 'Invoice Contact';
        con.IP_IsInvoicecontact__c = TRUE;
        con.OwnerId = u.Id;
        insert con;
        system.debug('Contact TYpe$$$'+con.IP_IsInvoicecontact__c);
        system.debug('Contact Account$$$'+acc.id);

        sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
        insert ct;

        sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
        insert sec;

        sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
        insert jobcate;

        sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
        job.sirenum__Rota__c = sec.id;
        insert job;

        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0];
        insert tpz;

        sirenum__site__c site = new sirenum__site__c();
        site.Name='my site';
        site.IP_InvoiceAddressCity__c='ballia';
        site.IP_InvoiceAddressStreet__c='street1';
        site.GlobalClientName__c = tpz.id;
        site.IP_ClientIDLegacy__c='eww3';
        site.IP_Clientinvoicename__c='invoice name';
        site.IP_InvoiceAddressCountry__c='ind';
        site.IP_InvoiceAddressCounty__c='cnt';
        site.IP_InvoiceAddressPostcode__c='d12 3dd';
        site.IP_PublicSector__c='No';
        // site.IP_PassClientToTempest__c=true;
        site.IP_ClientLastPassedToTempest__c=null;
        site.Credit_Status__c='Credit Approved';
//site.IP_PassClientAddressToTempest__c=true;sss
        site.IP_MainContact__c = con.id;
        site.sirenum__Postal_Code__c = 'E12 3SS';
        site.sirenum__City__c = 'City1';
        site.Email_Shifts_to_Client__c = true;
        site.sirenum__Street_Address__c = 'Address 1';
        site.sirenum__Operating_Company__c = acc.id;
        site.IP_InvoiceContact__c = con.id;
        site.OwnerId = u.Id;
        insert site;
        System.debug('Site Operation companny$$'+site.sirenum__Operating_Company__c);

        sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
        ps.sirenum__site__c = site.id;
        ps.sirenum__Rota__c = sec.id;
        ps.IP_Consultant1LookupSplitShare__c = u.Id;
        insert ps;

        system.debug('$$Placement created'+ps);
        Date todayDate1 = System.today();
        Time todayTime = Time.newInstance(18, 0, 0, 0);
        Date tomorrowDate1 = System.today().addDays(1);
        Time tomorrowTime = Time.newInstance(17, 0, 0, 0);
        sirenum__Shift__c shft = TestDataFactory.createShift(ps.id,site.id,1)[0];

        shft.sirenum__Scheduled_Start_Time__c = datetime.newInstance(todayDate1, todayTime);
        shft.sirenum__Scheduled_End_Time__c = datetime.newInstance(tomorrowDate1, tomorrowTime);
        shft.sirenum__Rota__c = sec.id;
        shft.sirenum__Contact__c = con.id;
        insert shft;
        shft.sirenum__Placement__c = ps.id;
        update shft;
        system.debug('Shift List'+shft);
        test.startTest();
        system.debug('Shift List123'+shft);
        System.runAs(u) {
            SitedetailsBatchSchedular sh1 = new SitedetailsBatchSchedular();

            String sch = '0 31 * * * ?';
            system.schedule('Test Shift batch', sch, sh1);
        }
        test.stopTest();
    }

    public static testmethod void sitedetailsbatchFailed(){
        insert new IP_Shift_Template__c(name = '1062', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='AA12 3FF',Branch_Address__c='street1',Email__c='no.reply2342@bluearrow.co.uk',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');
        Account acc =  TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
        TestDataFactory.setupCustomSettings(acc.Id);
        TestDataFactory.setupUserProfileCustomSettings();

        Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
        User u = new User(LastName = 'LIVESTON',FirstName='JASON',Alias = 'jliv',Email = 'mm.sf@outlook123.com',
                Username = 'dummydcwecweEmail6786367@email.com', ProfileId = p.id, TimeZoneSidKey = 'GMT',
                LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8', LocaleSidKey = 'en_US',IP_TempestDepartment__c='1062',
                IP_TempestDivision__c='NTS',Department='1062',IP_PassToTempest__c=true, Brand__c='Blue Arrow');

        insert u;

        Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
        con.email='test@abc.com';
        con.IP_ContactType__c = 'Invoice Contact';
        con.IP_IsInvoicecontact__c = TRUE;
        con.OwnerId = u.Id;
        insert con;
        system.debug('Contact TYpe$$$'+con.IP_IsInvoicecontact__c);
        system.debug('Contact Account$$$'+acc.id);

        sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
        insert ct;

        sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
        insert sec;

        sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
        insert jobcate;

        sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
        job.sirenum__Rota__c = sec.id;
        insert job;

        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0];
        insert tpz;

        sirenum__site__c site = new sirenum__site__c();
        site.Name='my site';
        site.IP_InvoiceAddressCity__c='ballia';
        site.IP_InvoiceAddressStreet__c='street1';
        site.GlobalClientName__c = tpz.id;
        site.IP_ClientIDLegacy__c='eww3';
        site.IP_Clientinvoicename__c='invoice name';
        site.IP_InvoiceAddressCountry__c='ind';
        site.IP_InvoiceAddressCounty__c='cnt';
        site.IP_InvoiceAddressPostcode__c='d12 3dd';
        site.IP_PublicSector__c='No';
        // site.IP_PassClientToTempest__c=true;
        site.IP_ClientLastPassedToTempest__c=null;
        site.Credit_Status__c='Credit Approved';
//site.IP_PassClientAddressToTempest__c=true;sss
        site.IP_MainContact__c = con.id;
        site.sirenum__Postal_Code__c = 'E12 3SS';
        site.sirenum__City__c = 'City1';
        site.Email_Shifts_to_Client__c = true;
        site.sirenum__Street_Address__c = 'Address 1';
        site.sirenum__Operating_Company__c = acc.id;
        site.IP_InvoiceContact__c = con.id;
        site.OwnerId = u.Id;
        insert site;
        System.debug('Site Operation companny$$'+site.sirenum__Operating_Company__c);

        sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
        ps.sirenum__site__c = site.id;
        ps.sirenum__Rota__c = sec.id;
        ps.IP_Consultant1LookupSplitShare__c = u.Id;
        insert ps;

        system.debug('$$Placement created'+ps);
        Date todayDate1 = System.today();
        Time todayTime = Time.newInstance(18, 0, 0, 0);
        Date tomorrowDate1 = System.today().addDays(1);
        Time tomorrowTime = Time.newInstance(17, 0, 0, 0);
        sirenum__Shift__c shft = TestDataFactory.createShift(ps.id,site.id,1)[0];

        shft.sirenum__Scheduled_Start_Time__c = datetime.newInstance(todayDate1, todayTime);
        shft.sirenum__Scheduled_End_Time__c = datetime.newInstance(tomorrowDate1, tomorrowTime);
        shft.sirenum__Rota__c = sec.id;
        shft.sirenum__Contact__c = con.id;
        insert shft;
        shft.sirenum__Placement__c = ps.id;
        update shft;
        system.debug('Shift List'+shft);
        test.startTest();
        system.debug('Shift List123'+shft);
        System.runAs(u) {
            SitedetailsBatchSchedular sh1 = new SitedetailsBatchSchedular();

            String sch = '0 31 * * * ?';
            system.schedule('Test Shift batch', sch, sh1);
        }
        test.stopTest();
    }

}