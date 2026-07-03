@isTest
private class Shifts_to_be_ApprovedCntTest{
    @testSetup 
    static void shiftSetup() {
        //Create portal account owner
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner11 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test3@test.com',
            Alias = 'batman',
            Email='bruce.wayne@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
            
        );
        Database.insert(portalAccountOwner11);
        Contact contact1 ;
        Contact contact2 ;
        Contact contact3 ;
        System.runAs(portalAccountOwner11) {
            insert new User_Profile_Id__c(
                Name = 'User Portal',
                Profile_Id__c = [SELECT Id FROM Profile WHERE Name = 'User Portal'].Id
            );

            //Create account
            Account portalAccount1 = new Account(
                Name = 'TestAccount',
                OwnerId = portalAccountOwner11.Id,
                    Invoice_PO_Number_Format__c='AAAA'
            );
            Database.insert(portalAccount1);
            
            //Create contact
            insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);
            
            contact1 = new Contact(
                FirstName = 'Test1',
                Lastname = 'McTesty',
                AccountId = portalAccount1.Id,
                IP_IsInvoicecontact__c=true,
                //IP_ContactType__c='Invoice Contact',
                Email = System.now().millisecond() + 'test@test.com'
            );
            Database.insert(contact1);
            //Create contact
           /* contact2 = new Contact(
                FirstName = 'Test2',
                Lastname = 'McTesty2',
                AccountId = portalAccount1.Id,
                Email = 'test2'+System.now().millisecond() + 'test2@test.com'
            );
            Database.insert(contact2);
            //Create contact
            contact3 = new Contact(
                FirstName = 'Test3',
                Lastname = 'McTesty3',
                AccountId = portalAccount1.Id,
                Email = 'test3'+System.now().millisecond() + 'test3@test.com'
            );
            Database.insert(contact3);*/
        }
        //Create user
        
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Customer Community User%' Limit 1];
        User user1 = new User(
            Username = System.now().millisecond() + 'test12345@test.com',
            ContactId = contact1.Id,
            ProfileId = portalProfile.Id,
            Alias = 'test123',
            Email = 'amit.kohli@espire.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            IP_TempestDepartment__c = '1062'
        );
        Database.insert(user1); 
        
    }
    
    @istest 
    static void shiftToBeApproved1() {
        
        insert new IP_Shift_Template__c(name = '1233', Email__c = 'singh.taji26@gmail.com');  
        User u = [select id , contactId,contact.AccountId from user where lastname = 'McTesty' limit 1];
        ID ConTID = u.contactId;
        ID accDID = u.Contact.AccountId;
        
        Account acct1 = TestDataFactory.createAccounts(3)[2]; 
        insert acct1;
        Account acct = TestDataFactory.createCandidateAccount(1)[0];
        insert acct;
        Contact cond = TestDataFactory.createCandidate(acct.id, 1)[0];  
        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);
        
        Insert cond;  
        
        
        
        IP_TopazGlobalClientInformation__c tgci = TestDataFactory.createTopaz(1)[0]; 
        tgci.IP_SalesLedgerNumber__c = '1112244';   
        Insert tgci;  
        
        sirenum__Site__c sites =  TestDataFactory.createSites(acct.id, tgci.id, 1)[0];     
        sites.ownerId = u.id;
        sites.sirenum__Operating_Company__c = accDID;
        sites.IP_MainContact__c = ConTID;
        sites.sirenum__Postal_Code__c = '10234';
        sites.sirenum__Street_Address__c = '1231';
        sites.IP_PassClientToTempest__c=false;
        sites.IP_Timesheet_Method__c = 'eTimesheet';
        sites.IP_InvoiceContact__c = ConTID;
        Insert sites;
        
        Contact_Site_link__c stlink = new Contact_Site_link__c();
        stlink.IP_Site__c = sites.id;
        stlink.IP_Contact__c = ConTID;
        stlink.Account__c = accDID;
        stlink.IP_PortalType__c ='Primary Hours Approver';
        insert stlink;
        
        sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(acct.id, cond.id,1)[0];
        insert pac;    
        
        sirenum__Rota__c rota = TestDataFactory.createSector(1)[0];
        Insert rota;
        
        sirenum__Job_Type__c job = TestDataFactory.createJobType(rota.id, 1)[0]; 
        Insert job;
        
        sirenum__Team__c tm = TestDataFactory.createJobRole(pac.id, job.id,1)[0];
        Insert tm;
        
        sirenum__Placement__c splacement = TestDataFactory.createSPlacement1(cond.id, pac.id, tm.id, u.id,1)[0];
        splacement.sirenum__Site__c = sites.id;
        splacement.IP_Consultant1LookupSplitShare__c = u.id;
        splacement.IP_Costcode__c = '1233';
        splacement.IP_PurchaseOrderNumber__c = 'LALA';
        Insert splacement;
        
        
        List<contact> conId = [select id, name,AccountId from contact where lastname like 'McTesty%' limit 5];
        IP_PayProfile__c pp = TestDataFactory.createPayProfilePaye(conId[0].id, 1)[0]; 
        insert pp;
        test.startTest();
        List<sirenum__Shift__c> shftList = TestDataFactory.createShift(splacement.id, sites.id,5); 
        shftList[0].sirenum__Contact__c =  conId[0].id;
        shftList[0].sirenum__Scheduled_Start_Time__c = System.now()-10;
        shftList[0].sirenum__Scheduled_End_Time__c = System.now()-1;
        shftList[0].sirenum__Placement__c = splacement.id;
        shftList[0].sirenum__Cancelled__c  = false;
        shftList[0].IP_CandidateApproved__c = true;
        shftList[0].StartTime__c = '10:30';
        shftList[0].EndTime__c = '18:30';
        shftList[0].IP_Account__c = conId[0].accountid;
        shftList[0].sirenum__Published__c=True;
        /*
        shftList[1].sirenum__Published__c=True;
        shftList[1].sirenum__Contact__c =  conId[0].id;
        shftList[1].sirenum__Scheduled_Start_Time__c = System.now()-10;
        shftList[1].sirenum__Scheduled_End_Time__c = System.now()-1;
        shftList[1].sirenum__Actual_Start_Time__c = System.now()-10;
        shftList[1].sirenum__Actual_End_Time__c = System.now()-1;
        shftList[1].sirenum__Placement__c = splacement.id;
        shftList[1].sirenum__Cancelled__c  = false;
        shftList[1].IP_CandidateApproved__c = true;
        shftList[1].StartTime__c = '10:30';
        shftList[1].EndTime__c = '18:30';
        shftList[2].sirenum__Contact__c =  conId[0].id;
        shftList[2].sirenum__Scheduled_Start_Time__c = System.now()-10;
        shftList[2].sirenum__Scheduled_End_Time__c = System.now()-1;
        shftList[2].sirenum__Actual_Start_Time__c = System.now()-10;
        shftList[2].sirenum__Actual_End_Time__c = System.now()-1;
        shftList[2].sirenum__Placement__c = splacement.id;
        shftList[2].IP_CandidateApproved__c = true;
        shftList[2].sirenum__Cancelled__c  = false;
        shftList[2].StartTime__c = '10:30';
        shftList[2].EndTime__c = '18:30';
        shftList[2].sirenum__Published__c=True;
*/
        insert shftList;
        
        List<sirenum__Shift_Break__c> breaks = new List<sirenum__Shift_Break__c>();
        breaks.add(new sirenum__Shift_Break__c(sirenum__Start_Time__c=System.now(),sirenum__End_Time__c=System.now().addminutes(10),sirenum__Paid_Break__c=false,sirenum__Shift__c=shftList[0].Id));
        insert breaks;
        
        List<wrapperBreak> omg = new List<wrapperBreak>();
        wrapperBreak obj = new wrapperBreak();
        obj.serial = '1';
        obj.Duration = '20';
        obj.breakId = 'New Record';
        omg.add(obj);
        
        
        
        
        System.runAs(u) {
            
            Shifts_to_be_ApprovedCnt.approveallshift(cond.id, 'approve', '');
            Shifts_to_be_ApprovedCnt.approveallshift(cond.id, 'reject', 'Not valid.');
            Shifts_to_be_ApprovedCnt.getUserInformation();
            /* Shifts_to_be_ApprovedCnt.updateuserwidget('Hide_Shift_Approval__c','Upd_c');
            Shifts_to_be_ApprovedCnt.updateuserwidget('Hide_Booked_temps__c','Updats__c');
            Shifts_to_be_ApprovedCnt.updateuserwidget('Hide_Contact__c','Upde_c');
            Shifts_to_be_ApprovedCnt.updateuserwidget('Hide_invoice_details__c','Upils__c');
            Shifts_to_be_ApprovedCnt.updateuserwidget('Hide_temp_hours__c','UptedH_c');
            Shifts_to_be_ApprovedCnt.updateuserwidget('Hide_temp111_hours__c','Updast');
           
            Shifts_to_be_ApprovedCnt.getAllShifts(sites.id,tm.id,cond.id,'Mon, 6 Mar 15 - Thu, 6 Apr 19');
            Shifts_to_be_ApprovedCnt.getAllShifts(sites.id,tm.id,cond.id,'Mon, 6 May 15 - Thu, 6 Jun 19');
            Shifts_to_be_ApprovedCnt.getAllShifts(sites.id,tm.id,cond.id,'Mon, 6 Jul 15 - Thu, 6 Aug 19');
            Shifts_to_be_ApprovedCnt.getAllShifts(sites.id,tm.id,cond.id,'Mon, 6 Sep 15 - Thu, 6 Oct 19');
            Shifts_to_be_ApprovedCnt.getAllShifts(sites.id,tm.id,cond.id,'Mon, 6 Nov 15 - Thu, 6 Dec 19');
            Shifts_to_be_ApprovedCnt.getAllShifts(sites.id,tm.id,cond.id,'Mon, 6 May 15');
            Shifts_to_be_ApprovedCnt.getAllShifts(sites.id,tm.id,cond.id, null);
*/
            Shifts_to_be_ApprovedCnt.getAllShifts(sites.id,tm.id,cond.id,'Mon, 6 Jan 15 - Thu, 6 Feb 19');
            Shifts_to_be_ApprovedCnt.testMethod1(omg,shftList[0].Id);
            Shifts_to_be_ApprovedCnt.getAllBreaksDB(shftList[0].Id);
            Shifts_to_be_ApprovedCnt.getBookedTimes(shftList[0].Id);
            
            
        }
        test.stoptest();
        
    }  
    
    public class wrapperBreak{
        public String serial;
        public String Duration;
        public String breakId;
    }
    
    @istest 
    static void shiftToBeApproved2() {
        insert new IP_Shift_Template__c(name = '1233', Email__c = 'singh.taji26@gmail.com');  
        User u = [select id , contactId,contact.AccountId from user where lastname = 'McTesty' limit 1];
        ID ConTID = u.contactId;
        ID accDID = u.Contact.AccountId;
        
        Account acct1 = TestDataFactory.createAccounts(3)[2]; 
        insert acct1;
        Account acct = TestDataFactory.createCandidateAccount(1)[0];
        insert acct;
        Contact cond = TestDataFactory.createCandidate(acct.id, 1)[0];  
        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=true);
        
        Insert cond;  
        
        
        
        IP_TopazGlobalClientInformation__c tgci = TestDataFactory.createTopaz(1)[0]; 
        tgci.IP_SalesLedgerNumber__c = '1112244';   
        Insert tgci;  
        
        sirenum__Site__c sites =  TestDataFactory.createSites(acct.id, tgci.id, 1)[0];     
        sites.ownerId = u.id;
        sites.sirenum__Operating_Company__c = accDID;
        sites.IP_MainContact__c = ConTID;
        sites.sirenum__Postal_Code__c = '10234';
        sites.sirenum__Street_Address__c = '1231';
        sites.IP_PassClientToTempest__c=false;
        sites.IP_Timesheet_Method__c = 'eTimesheet';
        sites.IP_InvoiceContact__c = ConTID;
        Insert sites;
        
        Contact_Site_link__c stlink = new Contact_Site_link__c();
        stlink.IP_Site__c = sites.id;
        stlink.IP_Contact__c = ConTID;
        stlink.Account__c = accDID;
        stlink.IP_PortalType__c ='Primary Hours Approver';
        insert stlink;
        
        sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(acct.id, cond.id,1)[0];
        insert pac;    
        
        sirenum__Rota__c rota = TestDataFactory.createSector(1)[0];
        Insert rota;
        
        sirenum__Job_Type__c job = TestDataFactory.createJobType(rota.id, 1)[0]; 
        Insert job;
        
        sirenum__Team__c tm = TestDataFactory.createJobRole(pac.id, job.id,1)[0];
        Insert tm;
        
        sirenum__Placement__c splacement = TestDataFactory.createSPlacement1(cond.id, pac.id, tm.id, u.id,1)[0];
        splacement.sirenum__Site__c = sites.id;
        splacement.IP_PurchaseOrderNumber__c = 'LALA';
        splacement.IP_Consultant1LookupSplitShare__c = u.id;
        splacement.IP_Costcode__c = '1233';
        Insert splacement;
        
        List<sirenum__Shift__c> shftList = TestDataFactory.createShift(splacement.id, sites.id,7); 
        List<contact> conId = [select id, name,accountId from contact where lastname like 'McTesty%' limit 5];
        shftList[0].sirenum__Contact__c =  conId[0].id;
        shftList[0].sirenum__Scheduled_Start_Time__c = System.now()-10;
        shftList[0].sirenum__Scheduled_End_Time__c = System.now()-1;
        shftList[0].sirenum__Placement__c = splacement.id;
        shftList[0].sirenum__Cancelled__c  = false;
        shftList[0].Actuals_confirmed__c = true;
        shftList[0].sirenum__Billable_Start_Time__c =System.now()-10;
        shftList[0].sirenum__Billable_End_Time__c=System.now()-1;
        
        
        shftList[0].IP_ClientRejected__c = false;
        shftList[0].IP_ClientApproved__c = false;
        shftList[0].sirenum__Actual_Start_Time__c = System.now()-10;
        shftList[0].sirenum__Actual_End_Time__c = System.now()-1;
        shftList[0].IP_CandidateApproved__c = true;
        shftList[0].sirenum__Published__c = true;
        shftList[0].StartTime__c = '10:30';
        shftList[0].EndTime__c = '18:30';
        shftList[0].sirenum__Site__c = sites.id;
        shftList[0].IP_Account__c = conId[0].accountid;
        shftList[1].sirenum__Contact__c =  conId[0].id;
        shftList[1].sirenum__Published__c = true;
        shftList[1].sirenum__Site__c = sites.id;
        shftList[1].sirenum__Scheduled_Start_Time__c = System.now();
        shftList[1].sirenum__Scheduled_End_Time__c = System.now()+1;
        shftList[1].sirenum__Actual_Start_Time__c = System.now();
        shftList[1].sirenum__Actual_End_Time__c = System.now()+1;
        shftList[1].sirenum__Placement__c = splacement.id;
        shftList[1].IP_CandidateApproved__c = true;
        shftList[1].StartTime__c = '10:30';
        shftList[1].EndTime__c = '18:30';
        shftList[2].sirenum__Contact__c =  conId[0].id;
        shftList[2].sirenum__Site__c = sites.id;
        shftList[2].sirenum__Published__c = true;
        shftList[2].sirenum__Scheduled_Start_Time__c = System.now()+1;
        shftList[2].sirenum__Scheduled_End_Time__c = System.now()+2;
        shftList[2].sirenum__Actual_Start_Time__c = System.now()+1;
        shftList[2].sirenum__Actual_End_Time__c = System.now()+2;
        shftList[2].sirenum__Placement__c = splacement.id;
        shftList[2].IP_CandidateApproved__c = true;
        shftList[2].sirenum__Cancelled__c  = false;
        shftList[3].sirenum__Contact__c =  conId[0].id;
        shftList[3].sirenum__Published__c = true;
        shftList[3].sirenum__Site__c = sites.id;
        shftList[3].sirenum__Scheduled_Start_Time__c = System.now()+3;
        shftList[3].sirenum__Scheduled_End_Time__c = System.now()+4;
        shftList[3].sirenum__Actual_Start_Time__c = System.now()+3;
        shftList[3].sirenum__Actual_End_Time__c = System.now()+4;
        shftList[3].sirenum__Placement__c = splacement.id;
        shftList[3].IP_CandidateApproved__c = true;
        shftList[3].sirenum__Cancelled__c  = false;
        shftList[4].sirenum__Contact__c =  conId[0].id;
        shftList[4].sirenum__Published__c = true;
        shftList[4].sirenum__Site__c = sites.id;
        shftList[4].sirenum__Scheduled_Start_Time__c = System.now()+20;
        shftList[4].sirenum__Scheduled_End_Time__c = System.now()+21;
        shftList[4].sirenum__Actual_Start_Time__c = System.now()+20;
        shftList[4].sirenum__Actual_End_Time__c = System.now()+21;
        shftList[4].sirenum__Placement__c = splacement.id;
        shftList[4].IP_CandidateApproved__c = true;
        shftList[4].sirenum__Cancelled__c  = false;
        shftList[5].sirenum__Contact__c =  null;
        shftList[5].sirenum__Published__c = true;
        shftList[5].sirenum__Scheduled_Start_Time__c = System.now()+20;
        shftList[5].sirenum__Scheduled_End_Time__c = System.now()+21;
        shftList[5].sirenum__Actual_Start_Time__c = System.now()+20;
        shftList[5].sirenum__Site__c = sites.id;
        shftList[5].sirenum__Actual_End_Time__c = System.now()+21;
        shftList[5].sirenum__Placement__c = splacement.id;
        shftList[5].IP_CandidateApproved__c = true;
        shftList[5].sirenum__Cancelled__c  = false;
        shftList[5].sirenum__Broadcasts__c = 2;
        shftList[6].sirenum__Contact__c =  null;
        //shftList[6].sirenum__Published__c = true;
        shftList[6].sirenum__Scheduled_Start_Time__c = System.now()+20;
        shftList[6].sirenum__Scheduled_End_Time__c = System.now()+21;
        shftList[6].sirenum__Site__c = sites.id;
        shftList[6].sirenum__Actual_Start_Time__c = System.now()+20;
        shftList[6].sirenum__Actual_End_Time__c = System.now()+21;
        shftList[6].sirenum__Placement__c = splacement.id;
        shftList[6].IP_CandidateApproved__c = true;
        shftList[6].sirenum__Cancelled__c  = false;
        
        insert shftList;
        
        IP_Shift_Template__c objCS_ShitTemp = new IP_Shift_Template__c();
        objCS_ShitTemp.Email__c = 'test@gmail.com';
        objCS_ShitTemp.Name = '1062';
        
        
        insert objCS_ShitTemp;
        
        
        
        test.startTest();
        sirenum__Timesheet__c sts = new sirenum__Timesheet__c(
            sirenum__Client__c=accDID,
            sirenum__Worker__c=conId[0].id,
            sirenum__Week_Ending__c=system.today()-5,
            sirenum__Non_Taxed_Expenses__c=34.2,
            sirenum__Taxed_Expenses__c=22.2,
            sirenum__Non_Taxed_Deductions__c=22.0,
            sirenum__Taxed_Deductions__c=22.1,
            sirenum__Site__c = sites.id
            
        );
        insert sts;
        
        	
            sirenum__Shift__c shift= [Select id,Break_Calculation_Start_Time__c,Break_Calculation_End_Time__c from sirenum__Shift__c where id =:shftList[0].id];
       /*     
        id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('PAYE').getRecordTypeId();
        
        IP_PayProfile__c payprofile = new IP_PayProfile__c();
         payprofile.RecordTypeId = payRTId;
          
         payprofile.IP_Candidate__c = cond.id;
         payprofile.IP_CompanyName__c='sfdc';
         payprofile.IP_Status__c = 'Active'; 
         payprofile.IP_CompanyRegNo__c  = 'ad123456';
         payprofile.IP_VATNumber__c     = '123456789';
         payprofile.IP_PayrollID__c  = 'test57861';
         payprofile.IP_VATRegistered__c=true;
         payprofile.IP_OkToSupply__c=1;
         payprofile.IP_BusinessAddressLine1__c='test address 1';
         payprofile.IP_BusinessAddressLine2__c='test address 2';
         payprofile.IP_BusinessAddressTown__c='town city';
         payprofile.IP_BusinessAddressPostcode__c='12345678';
         payprofile.IP_PayFrequency__c='Weekly';
         payprofile.IP_PaymentType__c='BACS';
        // payprofile.IP_PassToTempest__c=true;
         payprofile.IP_BankAccountName__c = 'Test name1';
         payprofile.IP_AccountNumber__c = '98567497';
         payprofile.IP_SortCode__c = '645362';
       // payprofile.IP_LastPassedToTempest__c=datetime.newInstance(2014, 9, 15, 12, 30, 0);
         
         insert payprofile;
*/
        
        
        sirenum__Shift_Break__c breakrec = new sirenum__Shift_Break__c();
        breakrec.sirenum__Start_Time__c = system.now()-10;
        breakrec.sirenum__End_Time__c = system.now()-5;
        breakrec.sirenum__Paid_Break__c = true;
        breakrec.sirenum__Shift__c = shift.id;
        insert breakrec;
         System.runAs(u) {
            Shifts_to_be_ApprovedCnt.getAllShiftsForCandidate(cond.id, sites.id);
            Shifts_to_be_ApprovedCnt.getSites();
            Shifts_to_be_ApprovedCnt.getCandidate();
            Shifts_to_be_ApprovedCnt.getSitesAndCandidate();
            Shifts_to_be_ApprovedCnt.getRolesAndCandidate(sites.id);
            Shifts_to_be_ApprovedCnt.getJobRoleList();
            Shifts_to_be_ApprovedCnt.getsiteContactMap();
            Shifts_to_be_ApprovedCnt.fetchTimeSheets();
            Shifts_to_be_ApprovedCnt.getChartMap(2);
            //Shifts_to_be_ApprovedCnt.getAllBreaksDB(shftList[0].id);
            //Shifts_to_be_ApprovedCnt.createNewBreaksDB('1:00','2:00','10',shift.id);
            //Shifts_to_be_ApprovedCnt.deleteBreaksDB(breakrec.id,shift.id);
            
            //Shifts_to_be_ApprovedCnt.SubmitInvoicePODB(shftList[0].Id,'12345');
        }
        test.stoptest();
        
    }
    
    
    @istest 
    static void shiftToBeApproved3() {
        
        insert new IP_Shift_Template__c(name = '1233', Email__c = 'singh.taji26@gmail.com');  
        User u = [select id , contactId,contact.AccountId from user where lastname = 'McTesty' limit 1];
        ID ConTID = u.contactId;
        ID accDID = u.Contact.AccountId;
        
        Account acct1 = TestDataFactory.createAccounts(3)[2]; 
        insert acct1;
        Account acct = TestDataFactory.createCandidateAccount(1)[0];
        insert acct;
        Contact cond = TestDataFactory.createCandidate(acct.id, 1)[0];  
        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);
        
        Insert cond;  
        
        
        
        IP_TopazGlobalClientInformation__c tgci = TestDataFactory.createTopaz(1)[0]; 
        tgci.IP_SalesLedgerNumber__c = '1112244';   
        Insert tgci;  
        
        sirenum__Site__c sites =  TestDataFactory.createSites(acct.id, tgci.id, 1)[0];     
        sites.ownerId = u.id;
        sites.sirenum__Operating_Company__c = accDID;
        sites.IP_MainContact__c = ConTID;
        sites.sirenum__Postal_Code__c = '10234';
        sites.sirenum__Street_Address__c = '1231';
        sites.IP_PassClientToTempest__c=false;
        sites.IP_Timesheet_Method__c = 'eTimesheet';
        sites.IP_InvoiceContact__c = ConTID;
        Insert sites;
        
        Contact_Site_link__c stlink = new Contact_Site_link__c();
        stlink.IP_Site__c = sites.id;
        stlink.IP_Contact__c = ConTID;
        stlink.Account__c = accDID;
        stlink.IP_PortalType__c ='Primary Hours Approver';
        insert stlink;
        
        sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(acct.id, cond.id,1)[0];
        insert pac;    
        
        sirenum__Rota__c rota = TestDataFactory.createSector(1)[0];
        Insert rota;
        
        sirenum__Job_Type__c job = TestDataFactory.createJobType(rota.id, 1)[0]; 
        Insert job;
        
        sirenum__Team__c tm = TestDataFactory.createJobRole(pac.id, job.id,1)[0];
        Insert tm;
        
        sirenum__Placement__c splacement = TestDataFactory.createSPlacement1(cond.id, pac.id, tm.id, u.id,1)[0];
        splacement.sirenum__Site__c = sites.id;
        splacement.IP_Consultant1LookupSplitShare__c = u.id;
        splacement.IP_Costcode__c = '1233';
        splacement.IP_PurchaseOrderNumber__c = 'LALA';
        Insert splacement;
        
        List<sirenum__Shift__c> shftList = TestDataFactory.createShift(splacement.id, sites.id,7); 
        List<contact> conId = [select id, name, accountId from contact where lastname like 'McTesty%' limit 5];
        shftList[0].sirenum__Contact__c =  conId[0].id;
        shftList[0].sirenum__Scheduled_Start_Time__c = System.now()-10;
        shftList[0].sirenum__Scheduled_End_Time__c = System.now()-1;
        shftList[0].sirenum__Placement__c = splacement.id;
        shftList[0].sirenum__Cancelled__c  = false;
        shftList[0].IP_ClientRejected__c = false;
        shftList[0].IP_ClientApproved__c = false;
        shftList[0].sirenum__Actual_Start_Time__c = System.now()-10;
        shftList[0].sirenum__Actual_End_Time__c = System.now()-1;
        shftList[0].IP_CandidateApproved__c = true;
        //   shftList[0].sirenum__Published__c = true;
        shftList[0].StartTime__c = '10:30';
        shftList[0].EndTime__c = '18:30';
        shftList[0].sirenum__Site__c = sites.id;
        shftList[1].sirenum__Contact__c =  conId[0].id;
        shftList[0].IP_Account__c = conId[0].accountid;
        //  shftList[1].sirenum__Published__c = true;
        shftList[1].sirenum__Site__c = sites.id;
        shftList[1].sirenum__Scheduled_Start_Time__c = System.now();
        shftList[1].sirenum__Scheduled_End_Time__c = System.now()+1;
        shftList[1].sirenum__Actual_Start_Time__c = System.now();
        shftList[1].sirenum__Actual_End_Time__c = System.now()+1;
        shftList[1].sirenum__Placement__c = splacement.id;
        shftList[1].IP_CandidateApproved__c = true;
        shftList[1].StartTime__c = '10:30';
        shftList[1].EndTime__c = '18:30';
        shftList[2].sirenum__Contact__c =  conId[0].id;
        shftList[2].sirenum__Site__c = sites.id;
        //   shftList[2].sirenum__Published__c = true;
        shftList[2].sirenum__Scheduled_Start_Time__c = System.now()+1;
        shftList[2].sirenum__Scheduled_End_Time__c = System.now()+2;
        shftList[2].sirenum__Actual_Start_Time__c = System.now()+1;
        shftList[2].sirenum__Actual_End_Time__c = System.now()+2;
        shftList[2].sirenum__Placement__c = splacement.id;
        shftList[2].IP_CandidateApproved__c = true;
        shftList[2].sirenum__Cancelled__c  = false;
        shftList[3].sirenum__Contact__c =  conId[0].id;
        //   shftList[3].sirenum__Published__c = true;
        shftList[3].sirenum__Site__c = sites.id;
        shftList[3].sirenum__Scheduled_Start_Time__c = System.now()+3;
        shftList[3].sirenum__Scheduled_End_Time__c = System.now()+4;
        shftList[3].sirenum__Actual_Start_Time__c = System.now()+3;
        shftList[3].sirenum__Actual_End_Time__c = System.now()+4;
        shftList[3].sirenum__Placement__c = splacement.id;
        shftList[3].IP_CandidateApproved__c = true;
        shftList[3].sirenum__Cancelled__c  = false;
        shftList[4].sirenum__Contact__c =  conId[0].id;
        //  shftList[4].sirenum__Published__c = true;
        shftList[4].sirenum__Site__c = sites.id;
        shftList[4].sirenum__Scheduled_Start_Time__c = System.now()+20;
        shftList[4].sirenum__Scheduled_End_Time__c = System.now()+21;
        shftList[4].sirenum__Actual_Start_Time__c = System.now()+20;
        shftList[4].sirenum__Actual_End_Time__c = System.now()+21;
        shftList[4].sirenum__Placement__c = splacement.id;
        shftList[4].IP_CandidateApproved__c = true;
        shftList[4].sirenum__Cancelled__c  = false;
        shftList[5].sirenum__Contact__c =  null;
        //  shftList[5].sirenum__Published__c = true;
        shftList[5].sirenum__Scheduled_Start_Time__c = System.now()+20;
        shftList[5].sirenum__Scheduled_End_Time__c = System.now()+21;
        shftList[5].sirenum__Actual_Start_Time__c = System.now()+20;
        shftList[5].sirenum__Site__c = sites.id;
        shftList[5].sirenum__Actual_End_Time__c = System.now()+21;
        shftList[5].sirenum__Placement__c = splacement.id;
        shftList[5].IP_CandidateApproved__c = true;
        shftList[5].sirenum__Cancelled__c  = false;
        shftList[5].sirenum__Broadcasts__c = 2;
        shftList[6].sirenum__Contact__c =  null;
        //  shftList[6].sirenum__Published__c = true;
        shftList[6].sirenum__Scheduled_Start_Time__c = System.now()+20;
        shftList[6].sirenum__Scheduled_End_Time__c = System.now()+21;
        shftList[6].sirenum__Site__c = sites.id;
        shftList[6].sirenum__Actual_Start_Time__c = System.now()+20;
        shftList[6].sirenum__Actual_End_Time__c = System.now()+21;
        shftList[6].sirenum__Placement__c = splacement.id;
        shftList[6].IP_CandidateApproved__c = true;
        shftList[6].sirenum__Cancelled__c  = false;
        
        insert shftList;
        
        IP_Shift_Template__c objCS_ShitTemp = new IP_Shift_Template__c();
        objCS_ShitTemp.Email__c = 'test@gmail.com';
        objCS_ShitTemp.Name = '1062';
        
        
        insert objCS_ShitTemp;
        
        List<sirenum__Shift_Break__c> breaks = new List<sirenum__Shift_Break__c>();
        breaks.add(new sirenum__Shift_Break__c(sirenum__Start_Time__c=System.now(),sirenum__End_Time__c=System.now().addminutes(10),sirenum__Paid_Break__c=false,sirenum__Shift__c=shftList[0].Id));
        insert breaks;
        
        IP_Shift_Template__c objCustomSettng = new IP_Shift_Template__c();
        objCustomSettng.Name = '1062';
        objCustomSettng.Email__c = 'Test@test.com';
        
        insert objCustomSettng;
        
        test.startTest();
        
        System.runAs(u) {
            String strJson = '[ { "Id": "'+shftList[0].id+'", "Scheduled_Start_Date_Text__c": "2019/5/7", "Name": "'+shftList[0].Name+'", "sirenum__Contact__c": "'+cond.id+'", "sirenum__Team__c": "'+tm.id+'", "sirenum__Site__c": "'+sites.id+'", "sirenum__Scheduled_Start_Time__c": "2019-05-07T09:29:00.000Z", "sirenum__Scheduled_End_Time__c": "2019-05-07T09:29:00.000Z", "Starttime__c": "10:29", "EndTime__c": "10:29", "Break_Length__c": "00:00", "sirenum__Break_Length__c": 0, "IP_ClientApproved__c": false, "IP_ClientRejected__c": false, "sirenum__Contact__r": { "Name": "'+cond.Name+'", "Id": "'+cond.id+'" }, "sirenum__Team__r": { "Name": "'+tm.Name+'", "Id": "'+tm.id+'" }, "sirenum__Site__r": { "Name": "'+sites.Name+'", "Id": "'+sites.id+'" } } ]';
            Shifts_to_be_ApprovedCnt.getshift(strJson);
            Shifts_to_be_ApprovedCnt.CallSaveShiftDB(strJson);
            Shifts_to_be_ApprovedCnt.SendRejectionToOwner(shftList[0].id, 'Reject Time Sheet', 'Reject');
            Shifts_to_be_ApprovedCnt.fetchUser();
            Shifts_to_be_ApprovedCnt.checkPermissionToViewAction(sites.Id);
            Shifts_to_be_ApprovedCnt.SubmitInvoicePODB(shftList[0].id,'1234');
            
        }
        test.stoptest();
        
    }
    
}