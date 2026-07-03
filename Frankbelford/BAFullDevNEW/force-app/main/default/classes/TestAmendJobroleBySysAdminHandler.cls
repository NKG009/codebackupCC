@isTest
private class TestAmendJobroleBySysAdminHandler{

    @testSetup static void setup(){
        
        Profile Prof=[SELECT Id FROM Profile WHERE Name='JS Recruiter - Hybrid' limit 1];
        Profile ProfSysAdmin=[SELECT Id FROM Profile WHERE Name='System Administrator' limit 1];
        
        Account acc1 = new Account();
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Client'];
        acc1.name='TestAccount1';
        acc1.Phone='012034563433';
        acc1.BillingStreet='Street1';
        acc1.IP_Business_Type__c='catering';
        acc1.BillingCity ='City1';
        acc1.BillingPostalCode = '101911';
        acc1.BillingState='State1';
        acc1.BillingCountry='Country1';
        acc1.RecordTypeId=accountRec.id;
        insert acc1;
        system.debug('Account Inserted');

        Account acc = new Account();
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate'];
        acc.Name='Candidates';
        acc.RecordTypeId=accountRec1.id;
        acc.Phone='012034563436';
        acc.BillingStreet='Street2';
        acc.BillingCity ='City2';
        acc.BillingPostalCode = '101912';
        acc.BillingState='State2';
        acc.BillingCountry='Country2';
        insert acc;
        system.debug('Account Inserted');
        
        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);
        
        //Insert Contact
        Recordtype recType = [Select id from Recordtype where sobjecttype='contact' and Name='Contact'];
        contact con2 = new contact();
        con2.RecordTypeId=recType.id;
        con2.AccountId=acc1.id;
        con2.FirstName='Test';
        con2.LastName='Data';
       // con2.IP_ContactType__c='Invoice Contact';
        insert con2;
        
        RecordType contRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
        List<Contact> testContacts = new List<Contact>();
        for ( Integer i = 0 ; i < 6 ; i++ )
        {
            Contact contact = new Contact( Firstname='Test'+i,
                                          
                                          Lastname='Candidate'+i,
                                          
                                          accountId=acc.Id,
                                          
                                          Person_Status__c='Active',
                                          
                                          IP_CategoryOfWork__c='Catering',
                                          
                                          IP_GDPRWorkedCandidate__c=False,
                                          
                                          IP_LastContactedGDPR__c=Null,
                                          
                                          RecordTypeId=contRec.Id);
            
            
            testContacts.add(contact);
            
        }
        insert testContacts;
        system.debug('test data factory  Candidate--'+testContacts);
        
        IP_TopazGlobalClientInformation__c createtopaz = new IP_TopazGlobalClientInformation__c();
        createtopaz.name = 'TestClient2';
        createtopaz.IP_StatusID__c = 1;
        createtopaz.IP_SalesLedgerNumber__c='123456';
        insert createtopaz;
        
        User user = new User();        
        DateTime dt2 = DateTime.newInstance(2017, 6, 23, 4, 2, 3);
        Long gettime = dt2.getTime();
        user.LastName = 'UserSalesforce' ;     
        user.FirstName='TestUser';
        user.isactive = True;        
        user.Alias = 'TstUrD';        
        user.Email = 'abc.efg@GHI.com';        
        user.Username = 'Email11'+gettime+'@js.com.uk';        
        user.ProfileId = Prof.id;        
        user.TimeZoneSidKey = 'GMT';        
        user.LanguageLocaleKey = 'en_US';        
        user.EmailEncodingKey = 'UTF-8';        
        user.LocaleSidKey = 'en_US';        
        insert user;
        
        //Create User with Sys Admin Profile
        User user1 = new User();        
        DateTime dt = DateTime.newInstance(2017, 6, 23, 4, 2, 3);
        Long gettime1 = dt.getTime();
        user.isactive = True; 
        user1.LastName = 'UserSalesforce1';      
        user1.FirstName='Testuser1';        
        user1.Alias = 'TstUrD';        
        user1.Email = 'abc.efgee@GHI.com';        
        user1.username = 'EmailSalesforce'+gettime1+'@js.com.uk';        
        user1.ProfileId = ProfSysAdmin.id;        
        user1.TimeZoneSidKey = 'GMT';        
        user1.LanguageLocaleKey = 'en_US';        
        user1.EmailEncodingKey = 'UTF-8';        
        user1.LocaleSidKey = 'en_US';        
        user1.IP_TempestDepartment__c='2042';        
       // user1.IP_TempestID__c='1084678';        
        user1.IP_TempestDivision__c='NTS';        
        user1.Department='1068';        
        user1.IP_PassToTempest__c=true;        
        insert user1;
        
        system.debug('Value in user'+ user);
        
        
        //Insert Site
        sirenum__Site__c site = new sirenum__Site__c();
        site.Name = 'testsite';
        site.sirenum__Operating_Company__c= acc1.id;
        site.IP_ClientIDLegacy__c='123';
        site.IP_ClientInvoiceName__c='Test Invoice';
        site.IP_InvoiceAddressStreet__c='Test Street';
        site.IP_PublicSector__c='No';
        site.GlobalClientName__c= createtopaz.Id;
        site.sirenum__Postal_Code__c='124678';
        site.sirenum__City__c='New Delhi';
        site.IP_PublicSector__c='NO';
        site.IP_MainContact__c=con2.id;
        site.IP_InvoiceContact__c=con2.id;
        site.OwnerId=user.id;
        site.IP_InvoiceAddressCity__c='Delhi';
        site.IP_Timesheet_Method__c='eTimesheet';
        site.IP_ScheduledAutoApproval__c= true; 
        insert site;
        
        // Sector
        sirenum__Rota__c sector = new sirenum__Rota__c();
        sector.Name = 'new sector';
        insert sector;

        //Job type
        sirenum__Job_Type__c jobtype = new sirenum__Job_Type__c();
        jobtype.name = 'testjobtype';
        jobtype.Impellam_Sector__c = sector.id;
        jobtype.Impellam_Core_Category__c = 'Administration -ADM';
        jobtype.Impellam_Job_Category__c ='Data Entry -OA002';
        insert jobtype;
        
        //Insert Records in Custom Setting
        JobRoleProfileList__c jobRoleprofile = new JobRoleProfileList__c();
        jobRoleprofile.Name = 'JS Recruiter - Hybrid';
        insert jobRoleprofile;
        
        sirenum__Payroll_Cycle__c payrolcycle = new sirenum__Payroll_Cycle__c();
        payrolcycle.Name='Monday to Sunday';
        payrolcycle.sirenum__StartingDate__c=date.newInstance(2019, 3, 10);
        payrolcycle.sirenum__periodLength__c=7;
        payrolcycle.sirenum__CyclePeriodUnits__c='Weeks';
        insert payrolcycle;
        
        sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
        contract.Name                 = 'test contract';
        contract.sirenum__Client__c   = acc1.id;
        contract.sirenum__Employee__c = testContacts[0].id;
        contract.sirenum__PayrollCycle__c=payrolcycle.id;
        insert contract;
        
        // Job Roles 
        sirenum__Team__c jobroll = new sirenum__Team__c();
        jobroll.name = 'testjobroll';
        jobroll.sirenum__Account__c = contract.id;
        jobroll.sirenum__Job_Type__c = jobtype.id;
        jobroll.sirenum__Rota__c=sector.id;
        jobroll.sirenum__AWR_Group__c='Group 2';
        jobroll.IP_OPWIPSRole__c='No';
        insert jobroll;
        
        //     sirenum__Timesheet__c time = new sirenum__Timesheet__c();
        
        sirenum__Timesheet__c createtimeshsheet = new sirenum__Timesheet__c();        
        createtimeshsheet.sirenum__Client__c= acc1.id;        
        createtimeshsheet.sirenum__Worker__c=testContacts[1].id;        
        createtimeshsheet.sirenum__Team__c=jobroll.id;        
        createtimeshsheet.sirenum__Site__c=site.id;        
        createtimeshsheet.sirenum__Week_Ending__c=system.today();        
        createtimeshsheet.sirenum__Non_Taxed_Expenses__c=34.2;        
        createtimeshsheet.sirenum__Taxed_Expenses__c=22.2;        
        createtimeshsheet.sirenum__Non_Taxed_Deductions__c=22.0;        
        createtimeshsheet.sirenum__Taxed_Deductions__c=22.1;        
        insert createtimeshsheet;
        
        system.debug('Value in createtimeshsheet'+ createtimeshsheet);
        
        
        sirenum__Placement__c splacement = new sirenum__Placement__c();
        splacement.Name = 'test placement ';
        splacement.sirenum__Contact__c = testContacts[0].id;
        splacement.sirenum__Start_Date__c = system.today();
        splacement.sirenum__Site__c= site.Id;
        splacement.IP_Consultant1LookupSplitShare__c= user.Id;
        splacement.IP_Consultant1PercentageSplit__c=100;
        splacement.sirenum__Contract__c = contract.id;
        splacement.sirenum__Job_Role__c = jobroll.id;
        insert splacement;
        
        sirenum__Placement__c plcs = [select id, IP_Consultant1IDnumberSplitShare__c, IP_Consultant1LookupSplitShare__c
                              from sirenum__Placement__c where id=:splacement.id];
        
        sirenum__Shift__c sshift =new sirenum__Shift__c();        
        sshift.sirenum__Placement__c = plcs.id;       
        sshift.sirenum__Rota__c = sector.Id;        
        sshift.sirenum__Team__c = jobroll.id;        
        sshift.sirenum__Timesheet_summaries__c = createtimeshsheet.id;        
        sshift.sirenum__Site__c=site.id;
        sshift.sirenum__Published__c=true;
        sshift.sirenum__Contact__c=testContacts[2].id;        
        sshift.sirenum__Cancelled__c= FALSE;        
        sshift.sirenum__Published_Ever__c=TRUE;
        sshift.sirenum__Scheduled_Start_Time__c=datetime.newInstance(2019, 3, 15, 9, 0, 0);
        sshift.sirenum__Scheduled_End_Time__c=datetime.newInstance(2019, 3, 15, 18, 0, 0);
        sshift.sirenum__Actual_Start_Time__c=datetime.newInstance(2019, 3, 15, 9, 0, 0);
        sshift.sirenum__Actual_End_Time__c=datetime.newInstance(2019, 3, 15, 18, 0, 0);
        sshift.IP_CandidateApproved__c=true;        
        insert sshift;
    }
    
     private static testmethod void JobRolePositive(){
         User usr = [Select id from User where LastName = 'UserSalesforce1' limit 1];
         System.runas(usr){
             List<sirenum__Team__c> jobRole  = [Select id,sirenum__Rota__c from sirenum__Team__c limit 1];
             jobRole[0].sirenum__Rota__c = null;
             update jobRole[0];
         }
     }
     
     private static testmethod void JobRoleNegative(){
         User usr = [Select id from User where LastName = 'UserSalesforce' limit 1];
         System.runas(usr){
            try{
                List<sirenum__Team__c> jobRole  = [Select id,sirenum__Rota__c from sirenum__Team__c limit 1];
                jobRole[0].sirenum__Rota__c = null;
                update jobRole[0];
            }

            catch(Exception e){
                Boolean expectedExceptionThrown =  e.getMessage().contains(Label.JobRoleErrorMessage) ? true : false;
                System.AssertEquals(expectedExceptionThrown, true);
            } 
         }
     }
}