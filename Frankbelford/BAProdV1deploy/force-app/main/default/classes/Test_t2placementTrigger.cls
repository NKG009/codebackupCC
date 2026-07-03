@isTest
public class Test_t2placementTrigger {
    static testMethod void TestTrue() {
        insert new IP_CompanyCode__c(name = 'CompanyCode', IP_CompanyCodeValue__c = 'BAL');
        insert new IP_Parallel_Payroll_Check__c(name = 'RunParallelCheck', Run_Parallel_Payroll__c = false);
        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=true);
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new List<User_Profile_Id__c> {
            new User_Profile_Id__c(Name = 'Client Portal User', Profile_Id__c = '00e3H000000DkrQQAS'),
            new User_Profile_Id__c(Name = 'User Portal', Profile_Id__c = '00e0Y000000QNyxQAG')
		};
        
        IP_ImpellamGlobalSetting__c setting = new IP_ImpellamGlobalSetting__c();
        setting.IP_LastTransmissionDate__c = Date.newInstance(2019,07,01);
        setting.IP_OutboundErrorEmailAddress__c = 'test@test.com';
        insert setting;
        
        IP_BranchStatus__c b  = new IP_BranchStatus__c ();
        b.IP_BranchID__c = '1062';
        b.Name = 'Test';
        insert b;
        
        Account client = TestDataFactory.createClients(1)[0]; 
        Insert client;
        
        Account account = TestDataFactory.createAccounts(1)[0];
        Insert account;
        
        Account accountcan = TestDataFactory.createCandidateAccount(1)[0];
        Insert accountcan;

        Contact cont = TestDataFactory.createContact(client.id, 1)[0];
        cont.PPE_Type__c = 'Polo shirt';
        Insert cont;
        
        Recordtype rt1= [Select id from Recordtype where sobjecttype='contact' and Name='Contact'];
        contact con1 = new contact();
        con1.RecordTypeId=rt1.id;
        con1.AccountId=account.id;
        con1.FirstName='Vandita Test';
        con1.LastName='Kakkar Test';
        con1.IP_ContactType__c='Invoice Contact';
        con1.PPE_Type__c = 'Polo shirt';
        insert con1;

        Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
        candidate.PPE_Type__c = 'Polo shirt';
        Insert candidate;
        
        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0]; 
        Insert tpz;

        Profile p = [SELECT Id FROM Profile where name='System Administrator'];

        User usr = TestDataFactory.createUsers(p.Id,1)[0];
        usr.username = 'pokygj123@yts.com';
        usr.IP_TempestDepartment__c='1062';
        usr.IP_TempestID__c='1084675';
        usr.Brand__c = 'Blue Arrow';
        usr.IP_TempestDivision__c='NTS';
        insert usr; 
        
        sirenum__Site__c site = new sirenum__Site__c();
        site.Name = 'NewSite';
        site.sirenum__Operating_Company__c= account.id;
        site.IP_ClientIDLegacy__c ='QAWWSED34';
        site.IP_ClientInvoiceName__c='Test Invoice';
        site.IP_InvoiceAddressStreet__c='Test Street';
        site.IP_PublicSector__c='No';
        site.GlobalClientName__c= tpz.Id;
        site.sirenum__Postal_Code__c='124678';
        site.sirenum__City__c='New Delhi';
        site.IP_PublicSector__c='NO';
        site.IP_MainContact__c=con1.id;
        site.IP_InvoiceContact__c=con1.id;
        site.OwnerId=usr.id;
        site.IP_InvoiceAddressCity__c='Delhi';
        insert site;

        ts2__Job__c jb = TestDataFactory.createT2Job(usr.id, 1)[0];
        jb.ts2__Account__c = accountcan.id;
        jb.ts2__Contact__c = candidate.id;
        jb.sirenum_js__Site__c = site.id;
        jb.IP_Fixed_Fee__c = 100;  
        jb.OwnerId = usr.Id;
        Insert jb;
        
        ts2__Placement__c ts2p = TestDataFactory.createTs2Placement(client.Id, candidate.Id, cont.Id, jb.Id, site.id,'Perm', 1)[0]; 
        ts2p.Item__c='Testabc'; 
        ts2p.IP_PassToTempest__c=true;
        ts2p.ts2extams__Substatus__c = 'Hired';
        ts2p.ts2__Start_Date__c = System.today();
        Insert ts2p;
        
        Placementprocessupdate.sendMail = true;
        
        ts2__Placement__c plc = [select Id,ts2__Employee__c, IP_PassToTempest__c from ts2__Placement__c where Id=:ts2p.Id];
        if(plc.IP_PassToTempest__c==true){
            candidate.t2placement_PassToTempest__c=true;
        }else{
            candidate.t2placement_PassToTempest__c=false;
        }
        ts2p.ts2extams__Substatus__c = 'No Show';
        update ts2p;
        update candidate;
    }
    
    static testMethod void Testfalse(){
        insert new IP_CompanyCode__c(name = 'CompanyCode', IP_CompanyCodeValue__c = 'BAL');
        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=true);        
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new IP_Parallel_Payroll_Check__c(name = 'RunParallelCheck', Run_Parallel_Payroll__c = false); 
        insert new List<User_Profile_Id__c> {
			new User_Profile_Id__c(Name = 'Client Portal User', Profile_Id__c = '00e3H000000DkrQQAS'),
            new User_Profile_Id__c(Name = 'User Portal', Profile_Id__c = '00e0Y000000QNyxQAG')
        };

        Account client = TestDataFactory.createClients(1)[0]; 
        Insert client;
        
        Account account = TestDataFactory.createAccounts(1)[0];
        Insert account;
        
        Account accountcan = TestDataFactory.createCandidateAccount(1)[0];
        Insert accountcan;

        Contact cont = TestDataFactory.createContact(client.id, 1)[0];
        cont.PPE_Type__c = 'Polo shirt';
        Insert cont;

        Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];        
        candidate.PPE_Type__c = 'Polo shirt';
        Insert candidate;

        Recordtype rt1= [Select id from Recordtype where sobjecttype='contact' and Name='Contact'];
        contact con2 = new contact();
        con2.RecordTypeId=rt1.id;
        con2.AccountId=account.id;
        con2.FirstName='Vandita Test';
        con2.LastName='Kakkar Test';
        con2.IP_ContactType__c='Invoice Contact';
        con2.PPE_Type__c = 'Polo shirt';
        insert con2;
        
        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0]; 
        Insert tpz;

        Profile p1 = [SELECT Id FROM Profile where name='System Administrator'];

        User usr1 = TestDataFactory.createUsers(p1.Id,1)[0];
        usr1.username = 'pokygj123@yts.com';
        usr1.IP_TempestDepartment__c='2043';
        usr1.IP_TempestID__c='1084675';
        usr1.Brand__c = 'Blue Arrow';
        usr1.IP_TempestDivision__c='NTS';
        insert usr1; 

        sirenum__Site__c site1 = new sirenum__Site__c();
        site1.Name = 'NewSite';
        site1.sirenum__Operating_Company__c= account.id;
        site1.IP_ClientIDLegacy__c ='QAWWSED34';
        site1.IP_ClientInvoiceName__c='Test Invoice';
        site1.IP_InvoiceAddressStreet__c='Test Street';
        site1.IP_PublicSector__c='No';
        site1.GlobalClientName__c= tpz.Id;
        site1.sirenum__Postal_Code__c='124678';
        site1.sirenum__City__c='New Delhi';
        site1.IP_PublicSector__c='NO';
        site1.IP_MainContact__c=con2.id;
        site1.IP_InvoiceContact__c=con2.id;
        site1.OwnerId=usr1.id;
        site1.IP_InvoiceAddressCity__c='Delhi';
        insert site1;

        ts2__Job__c jb1 = TestDataFactory.createT2Job(usr1.id, 1)[0];
        jb1.ts2__Account__c = accountcan.id;
        jb1.ts2__Contact__c = candidate.id;
        jb1.sirenum_js__Site__c = site1.id;
        jb1.IP_Fixed_Fee__c = 100;  
        Insert jb1;
        
        IP_BranchStatus__c b  = new IP_BranchStatus__c ();
        b.IP_BranchID__c = '2043';
        b.Name = 'Test';
        insert b;
        
        ts2__Job__c jb = TestDataFactory.createT2Job(usr1.id, 1)[0];
        jb.ts2__Account__c = accountcan.id;
        jb.ts2__Contact__c = candidate.id;
        jb.sirenum_js__Site__c = site1.id;
        jb.IP_Fixed_Fee__c = 100;  
        Insert jb;
        
        ts2__Placement__c ts2p = TestDataFactory.createTs2Placement(client.Id, candidate.Id, cont.Id, jb.Id, site1.id,'Perm', 1)[0]; 
        ts2p.Item__c='Testabc'; 
        ts2p.IP_PassToTempest__c=false;
        Insert ts2p;

        ts2__Placement__c plc = [select Id,ts2__Employee__c, IP_PassToTempest__c from ts2__Placement__c where Id=:ts2p.Id];
        if(plc.IP_PassToTempest__c==true){
            candidate.t2placement_PassToTempest__c=true;
        }else{
            candidate.t2placement_PassToTempest__c=false;
        }
        update candidate;
    }
    
    static testMethod void test(){          
        System.runAs(new User(Id = UserInfo.getUserId())) {
			insert new List<User_Profile_Id__c>{
                new User_Profile_Id__c(Name = 'Client Portal User', Profile_Id__c = '00e3H000000DkrQQAS'),
                new User_Profile_Id__c(Name = 'User Portal', Profile_Id__c = '00e0Y000000QNyxQAG')
			};
		}
        
        Profile Prof = [SELECT Id FROM Profile WHERE Name='System Administrator' limit 1];

        User user = new User();
        DateTime dt2 = DateTime.newInstance(2017, 6, 23, 4, 2, 3);
        Long gettime = dt2.getTime();
        user.LastName = 'Data1';
        user.FirstName='TestUser';
        user.Alias = 'TstUrD';
        user.Email = 'abc.efg@GHI.com';
        user.Username = 'Email'+gettime+'@js.com.uk';
        user.ProfileId = Prof.id;
        user.TimeZoneSidKey = 'GMT';
        user.LanguageLocaleKey = 'en_US';
        user.EmailEncodingKey = 'UTF-8';
        user.LocaleSidKey = 'en_US';
        user.IP_TempestDepartment__c='1062';
        user.IP_TempestID__c='1084675';
        user.Brand__c = 'Blue Arrow';
        user.IP_TempestDivision__c ='NTS';
        user.Department='1062';
        user.IP_PassToTempest__c=true;
        insert user;
        system.debug('Value in user'+ user);
        
        system.runas(user)
        {
            insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
            insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=true);
            insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);

            Account client = TestDataFactory.createClients(1)[0]; 
            Insert client;
            
            Account account = TestDataFactory.createAccounts(1)[0];
            Insert account;
            
            Account accountcan = TestDataFactory.createCandidateAccount(1)[0];
            Insert accountcan;
            
            Contact cont = TestDataFactory.createContact(client.id, 1)[0];
            cont.PPE_Type__c = 'Polo shirt';
            Insert cont;
            
            Recordtype rt1= [Select id from Recordtype where sobjecttype='contact' and Name='Contact'];
            contact con1 = new contact();
            con1.RecordTypeId = rt1.id;
            con1.AccountId = account.id;
            con1.FirstName = 'Vandita Test';
            con1.LastName = 'Kakkar Test';
            con1.IP_ContactType__c = 'Invoice Contact';
            con1.PPE_Type__c = 'Polo shirt';
            insert con1;
            
            Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
            candidate.PORTW_Completed__c =true;     
            candidate.Medical_Completed__c =true;       
            candidate.Declaration_Completed__c=true;        
            candidate.TOE_Completed__c =true;       
            candidate.New_Starter_Form__c=true;     
            candidate.Equal_Opportunity_Completed__c=true;
            candidate.PPE_Type__c = 'Polo shirt';
            Insert candidate;
            
            IP_TopazGlobalClientInformation__c createtopaz = new IP_TopazGlobalClientInformation__c();
            createtopaz.name = 'TestClient2';
            createtopaz.IP_StatusID__c = 1;
            createtopaz.IP_SalesLedgerNumber__c='123456';
            insert createtopaz;
            
            id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('PAYE').getRecordTypeId();
            
            IP_PayProfile__c payprofile2 = new IP_PayProfile__c();
            payprofile2.RecordTypeId = payRTId;
            payprofile2.IP_Candidate__c = candidate.id;
            payprofile2.IP_CompanyName__c='sfdc';
            payprofile2.IP_Status__c = 'Active'; 
            payprofile2.IP_CompanyRegNo__c  = 'ad123456';
            payprofile2.IP_VATNumber__c     = '123456789';
            payprofile2.IP_PayrollID__c  = 'testpaynew';
            payprofile2.IP_VATRegistered__c=true;
            payprofile2.IP_OkToSupply__c=1;
            payprofile2.IP_BuildingSocietyNumber__c='12f';
            payprofile2.IP_BusinessAddressLine1__c='test address 1';
            payprofile2.IP_BusinessAddressLine2__c='test address 2';
            payprofile2.IP_BusinessAddressTown__c='town city';
            payprofile2.IP_BusinessAddressPostcode__c='12345678';
            payprofile2.IP_PayFrequency__c='Weekly';
            payprofile2.IP_PaymentType__c='BACS';
            payprofile2.IP_PrimaryPayMethod__c=true;
            payprofile2.IP_BankAccountName__c ='Vandita';
            payprofile2.IP_AccountNumber__c ='12345678';
            payprofile2.IP_SortCode__c = '123456';
            insert payprofile2;

            sirenum__site__c site = new sirenum__site__c();
            site.Name='my site';
            site.IP_InvoiceAddressCity__c='ballia';
            site.IP_InvoiceAddressStreet__c='street1';
            site.GlobalClientName__c = createtopaz.id;
            site.IP_ClientIDLegacy__c='eww3';
            site.IP_Clientinvoicename__c='invoice name';
            site.IP_InvoiceAddressCountry__c='ind';
            site.IP_InvoiceAddressCounty__c='cnt';
            site.IP_InvoiceAddressPostcode__c='23d fdd';
            site.IP_PublicSector__c='No';
            site.IP_ClientLastPassedToTempest__c=null;
            site.Credit_Status__c='Credit Approved';
            site.IP_MainContact__c = con1.id;
            site.sirenum__Postal_Code__c = '12345';
            site.sirenum__City__c = 'City1';
            site.Email_Shifts_to_Client__c = true;
            site.sirenum__Street_Address__c = 'Address 1';
            site.sirenum__Operating_Company__c = account.id;
            site.IP_InvoiceContact__c = con1.id;
            insert site;
            
            sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
            contract.Name = 'test contract New';
            contract.sirenum__Client__c   = account.id;
            contract.sirenum__Employee__c = con1.id;
            insert contract;
            
            sirenum__Rota__c sector = new sirenum__Rota__c();
            sector.Name = 'new sector';
            insert sector;
            
            sirenum__Job_Type__c jobtype = new sirenum__Job_Type__c();
            jobtype.name = 'testjobtype';
            jobtype.Impellam_Sector__c = sector.id;
            jobtype.Impellam_Core_Category__c = 'Administration -ADM';
            jobtype.Impellam_Job_Category__c ='Administrator -OA001';
            insert jobtype;
            
            sirenum__Team__c jobroll = new sirenum__Team__c();
            jobroll.name = 'testjobroll new';
            jobroll.sirenum__Account__c = contract.id; 
            jobroll.sirenum__Job_Type__c = jobtype.id;
            jobroll.sirenum__AWR_Group__c='Group 2';
            jobroll.IP_OPWIPSRole__c='No';
            jobroll.sirenum__Rota__c=sector.id;
            insert jobroll;
            
            sirenum__Placement__c splacement = new sirenum__Placement__c();
            splacement.Name = 'test placement new';
            splacement.sirenum__Contact__c = con1.id;
            splacement.sirenum__Start_Date__c = system.today();
            splacement.sirenum__Site__c= site.Id;
            splacement.IP_Consultant1LookupSplitShare__c= user.Id;
            splacement.IP_Consultant1PercentageSplit__c=100;
            splacement.sirenum__Contract__c = contract.id;
            splacement.sirenum__Job_Role__c = jobroll.id;
            insert splacement;
            
            sirenum__Placement__c plcs = [select id, IP_Consultant1IDnumberSplitShare__c, IP_Consultant1LookupSplitShare__c 
                                          from sirenum__Placement__c
                                          where id=:splacement.id];
            
            sirenum__Shift__c sshift = new sirenum__Shift__c();
            sshift.sirenum__Placement__c = plcs.id;
            sshift.sirenum__Rota__c = sector.Id;
            sshift.sirenum__Team__c = jobroll.id;
            sshift.sirenum__Site__c=site.id;
            sshift.sirenum__Contact__c=con1.id;
            sshift.sirenum__Cancelled__c= FALSE;
            sshift.sirenum__Published_Ever__c=TRUE;
            insert sshift;

            ts2__Job__c job1 = new ts2__Job__c();
            RecordType perms = [Select Id From RecordType Where DeveloperName='Perm' and sObjectType='ts2__Job__c'];
            job1.Name = 'Test Job1';
            job1.IP_Fixed_Fee__c = 120;
            job1.ts2__Account__c = account.id;
            job1.ts2__Contact__c = con1.id;
            job1.sirenum_js__Site__c = site.id;
            job1.Recordtypeid = perms.id;
            job1.ts2__Recruiter__c = user.Id;
            insert job1;
            
            ts2__Placement__c permplacement = new ts2__Placement__c();
            RecordType perms1 = [Select Id From RecordType Where DeveloperName='Perm_Credits' and sObjectType='ts2__Placement__c'];
            permplacement.ts2extams__Substatus__c = 'Rebate Period';
            permplacement.ts2__Job__c=job1.id;
            permplacement.sirenum_js__Site__c=site.id;
            permplacement.ts2__Employee__c = con1.id;
            permplacement.ts2__Hiring_Manager__c=con1.id;
            permplacement.ts2__Salary__c = 100;
            permplacement.ts2__Fee_Pct__c=30;
            permplacement.IP_FixedFeeValue__c = 120;
            permplacement.ts2__Filled_By__c = user.id;
            permplacement.RecordTypeId=perms1.id;
            permplacement.GUID_Placement_js__c ='abcd';
            permplacement.ts2__Start_Date__c=system.today();
            permplacement.ts2__Filled_Pct__c = 10;
            insert permplacement;
            
            Test.startTest();
            try {  
                delete permplacement;  
            }
            catch(DMLException e){  
            }

            Test.stopTest();
        }
    }
}