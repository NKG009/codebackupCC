@isTest
private class Test_CPtrackmypayController {

    @testSetup
    static void sSetup() {
        Id urId = [SELECT Id FROM UserRole WHERE Name='Impellam IT'].Id;
        Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
        User u = new User(LastName = 'l4848',FirstName='JASON',Alias = 'jliv',Email = 'mm.sf@outlook123.com',
                Username = 'dummydcwecweEmail6786367@email.com', ProfileId = p.id, TimeZoneSidKey = 'GMT',
                LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8', LocaleSidKey = 'en_US',IP_TempestDepartment__c='1010',
                IP_TempestDivision__c='NTS',Department='1010',IP_PassToTempest__c=true, Brand__c='Blue Arrow',
                UserRoleId = urId);
        insert u;

        Contact worker;
        Contact c1 ;

        System.runAs(u) {
            TestDataFactory.setupUserProfileCustomSettings();
            Account acc1 = TestDataFactory.createClients(1)[0];
            acc1.IP_Business_Type__c ='Catering';
            Account candidateAccount = TestDataFactory.createCandidateAccount(1)[0];
            insert new List<Account> {acc1, candidateAccount};
            TestDataFactory.setupCustomSettings(candidateAccount.Id);
            insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);

            c1 = TestDataFactory.createContact(acc1.Id, 1)[0];
            worker = TestDataFactory.createCandidate(candidateAccount.Id,1)[0];
            worker.IP_CategoryOfWork__c='Catering';
            insert new List<Contact>{c1, worker};
        }

        Profile dProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Customer Community User%' Limit 1];
        User userd = TestDataFactory.createCommunityUser(c1, dProfile.Id);
        Id wpId = [SELECT Id, Name FROM Profile WHERE Name='User Portal'].Id;
        User workerUsr = TestDataFactory.createCommunityUser(worker, wpId);
        insert new List<User>{userd, workerUsr};
    }

    @isTest
    static void get_timesheet(){
        User au = [select id , contactId from user where lastname = 'l4848' limit 1];
        Account candidateAccount = [SELECT Id, Name, (SELECT Id FROM Contacts) FROM Account WHERE RecordType.Name = 'Candidate'];
        Contact cont = candidateAccount.Contacts[0];

        Account clnt = [SELECT Id, Name, (SELECT Id FROM Contacts) FROM Account WHERE RecordType.Name != 'Candidate'];
        Contact contact = clnt.Contacts[0];

        Contact cond = candidateAccount.Contacts[0];

        IP_TopazGlobalClientInformation__c tgci = new IP_TopazGlobalClientInformation__c(name = 'MyClient', IP_StatusID__c = 1,IP_SalesLedgerNumber__c='1234567890');
        Database.insert(tgci);

        sirenum__Site__c sites = TestDataFactory.createSites(clnt.Id, tgci.Id, 1)[0];
        sites.IP_InvoiceContact__c = contact.Id;
        Database.insert(sites);

        sirenum__ProActiveContract__c pac = new sirenum__ProActiveContract__c( Name='contact name', sirenum__Client__c=clnt.id,
                sirenum__Employee__c=cont.id, sirenum__AWR_Eligable__c=true);
        Database.insert(pac);

        sirenum__Rota__c rota = new sirenum__Rota__c( Name='Imapellam' );
        Database.insert(rota);

        sirenum__Job_Type__c job = new sirenum__Job_Type__c( Impellam_Sector__c=rota.id,  Impellam_Core_Category__c='Administration -ADM', Impellam_Job_Category__c = 'Data Entry -OA002');
        Database.insert(job);

        sirenum__Team__c tm = new sirenum__Team__c( Name='job role', sirenum__Account__c=pac.id, sirenum__Job_Type__c=job.id, IP_OPWIPSRole__c = 'No');
        Database.insert(tm);

        id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('LTD').getRecordTypeId();
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);

        IP_PayProfile__c payprofile = new IP_PayProfile__c();
        payprofile.RecordTypeId = payRTId;
        payprofile.IP_Candidate__c = cond.Id;
        payprofile.IP_CompanyName__c='sfdc';
        payprofile.IP_Status__c = 'Active';
        payprofile.IP_CompanyRegNo__c  = 'ad123456';
        payprofile.IP_VATNumber__c     = '123456789';
        payprofile.IP_PayrollID__c  = 'testpay1';
        payprofile.IP_StudentLoan__c ='Y';
        payprofile.IP_VATRegistered__c=true;
        payprofile.IP_OkToSupply__c=1;
        payprofile.IP_BuildingSocietyNumber__c ='t1e';
        payprofile.IP_BusinessAddressLine1__c='test address 1';
        payprofile.IP_BusinessAddressLine2__c='test address 2';
        payprofile.IP_BusinessAddressTown__c='town city';
        payprofile.IP_BusinessAddressPostcode__c='E12 8AA';
        payprofile.IP_PayFrequency__c='Weekly';
        payprofile.IP_PaymentType__c='BACS';
        payprofile.IP_BankAccountName__c = 'testname';
        payprofile.IP_AccountNumber__c = '98958987';
        payprofile.IP_SortCode__c = '887788';
        payprofile.IP_OkToSupply__c =1;
        payprofile.IP_PassToTempest__c=true;
        insert payprofile;

        test.startTest();


        sirenum__Placement__c splacement = new sirenum__Placement__c(
                IP_Consultant1LookupSplitShare__c=au.id,
                sirenum__Contact__c = cond.id,
                sirenum__Contract__c = pac.id,
                sirenum__Start_Date__c = system.today(),
                sirenum__Job_Role__c = tm.id,
                Name='s-placement',
                IP_Consultant1PercentageSplit__c=100,
                IP_PassToTempest__c=true,
                IP_PurchaseOrderNumber__c='dd',
                sirenum__End_Date__c=system.today(),
                OPWIPS__c='N',
                IP_PayMethod__c=payprofile.Name,
                sirenum__Site__c=sites.Id );
        Database.insert(splacement);

        sirenum__Timesheet__c sts = TestDataFactory.createTimeSheet(Clnt.id, cond.Id,1)[0];
        Database.insert(sts);

        sirenum__Shift__c shft = TestDataFactory.createShift(splacement.id, sites.id,1)[0];
        shft.sirenum__Contact__c =  cond.id;
        shft.sirenum__Scheduled_Start_Time__c = System.now()-10;
        shft.sirenum__Scheduled_End_Time__c = System.now()-1;
        shft.sirenum__Placement__c = splacement.id;
        shft.IP_CandidateApproved__c = true;
        shft.StartTime__c = '10:30';
        shft.EndTime__c = '18:30';
        shft.sirenum__Timesheet_summaries__c=sts.Id;
        Database.insert(shft);

        sirenum__Timesheet_Line__c stsl = new sirenum__Timesheet_Line__c(
                sirenum__Timesheet__c=sts.Id,
                sirenum__Rate__c=22.0,
                sirenum__Hours__c=1,
                IP_PassToTempest__c=false,
                IP_RateCodes__c='Taxable Expenses /TX',
                sirenum__Shift__c=shft.Id
        );
        Database.insert(stsl);
        insert new IP_Shift_Template__c(name = '1010', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='W12 3SS',Branch_Address__c='street1',Email__c='no.reply@bluearrow.co.uk',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');

        String comments='test me';
        String combinedComment='add all';

        User wu = [SELECT Id FROM User WHERE ContactId =: cond.Id];
        System.runAs(wu) {
            CPtrackmypayController.getTimesheets();
            CPtrackmypayController.getTimesheetLine(sts.id);
            CPtrackmypayController.getTimesheetQuery(sts.id);
            CPtrackmypayController.SendQueryOwner(sts.id,  comments, combinedComment);
        }
        test.stopTest();
    }
}