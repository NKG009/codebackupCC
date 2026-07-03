@isTest
public class TestShiftTrigger {
    static testMethod void TestAccount1() {
        Id consProfId=User_Profile_Id__c.getValues('JS Recruiter - Hybrid').Profile_Id__c;
        User consultantUser = [SELECT Id, Username FROM User WHERE IP_TempestDepartment__c = '1355'
        AND IP_TempestDivision__c = 'BA'
        AND IP_TempestID__c = '135512009'
        AND Profile.Id =: consProfId
        LIMIT 1];
        system.debug('Value in user>>>'+ consultantUser);

        sirenum__Shift__c sshift = [SELECT Id, Name, sirenum__Allow_pay__c, sirenum__Cancelled__c
        FROM sirenum__Shift__c LIMIT 1];

        system.runas(consultantUser){
            try{
                sshift.sirenum__Allow_pay__c=true;
                sshift.sirenum__Cancelled__c=true;
                update sshift;
            }
            catch(exception e)
            {}
        }
    }

    //user perspect
    static testMethod void TestAccount2() {
        Id consProfId=User_Profile_Id__c.getValues('JS Recruiter - Hybrid').Profile_Id__c;
        User consultantUser = [SELECT Id, Username FROM User WHERE IP_TempestDepartment__c = '1355'
        AND IP_TempestDivision__c = 'BA'
        AND IP_TempestID__c = '135512009'
        AND Profile.Id =: consProfId
        LIMIT 1];
        system.debug('Value in user>>>'+ consultantUser);

        sirenum__Shift__c sshift = [SELECT Id, Name, sirenum__Allow_pay__c, sirenum__Cancelled__c
        FROM sirenum__Shift__c LIMIT 1];

        System.runas(consultantUser){
            try{
                sshift.sirenum__Allow_pay__c=true;
                update sshift;
            }
            catch(exception e)
            {}
        }
    }

    static testMethod void TestAccount3() {
        Id consProfId=User_Profile_Id__c.getValues('JS Recruiter - Hybrid').Profile_Id__c;
        User consultantUser = [SELECT Id, Username FROM User WHERE IP_TempestDepartment__c = '1355'
        AND IP_TempestDivision__c = 'BA'
        AND IP_TempestID__c = '135512009'
        AND Profile.Id =: consProfId
        LIMIT 1];
        system.debug('Value in user>>>'+ consultantUser);

        sirenum__Shift__c sshift1 = [SELECT Id, Name, sirenum__Allow_pay__c, sirenum__Cancelled__c
        FROM sirenum__Shift__c LIMIT 1];
        sirenum__Shift__c sshift2 = sshift1.clone();
        sshift2.sirenum__Published_Ever__c=true;
        insert sshift2;
        system.debug('Value in insertes shift----->'+ sshift2);

        system.runas(consultantUser){
            try{
                //sshift.sirenum__Allow_pay__c=true;
                sshift2.sirenum__Cancelled__c=true;
                update sshift2;
            }
            catch(exception e)
            {}
        }
    }

    @TestSetup
    static void setUpTestData() {
        Account client = TestDataFactory.createClients(1)[0];
        Insert client;
        Account account = TestDataFactory.createAccounts(1)[0];
        Insert account;
        Account accountcan = TestDataFactory.createCandidateAccount(1)[0];
        Insert accountcan;
        TestDataFactory.setupCustomSettings(accountcan.Id);
        TestDataFactory.setupUserProfileCustomSettings();
        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=true);

        Id consProfId=User_Profile_Id__c.getValues('JS Recruiter - Hybrid').Profile_Id__c;
        User consultantUser = TestDataFactory.createUsers(consProfId, 1)[0];
        consultantUser.IP_TempestDepartment__c = '1355';
        consultantUser.IP_TempestDivision__c = 'BA';
        consultantUser.IP_TempestID__c = '135512009';
        consultantUser.IP_PassToTempest__c = false;
        insert consultantUser;
        system.debug('Value in user>>>'+ consultantUser);

        Contact cont = TestDataFactory.createContact(client.id, 1)[0];
        Insert cont;

        Recordtype rt1= [Select id from Recordtype where sobjecttype='contact' and Name='Contact'];
        contact con1 = new contact();
        con1.RecordTypeId=rt1.id;
        con1.AccountId=account.id;
        con1.FirstName='Vandita Test';
        con1.LastName='Kakkar Test';
        con1.IP_ContactType__c='Invoice Contact';
        insert con1;


        Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
        candidate.PORTW_Completed__c =true;
        candidate.Medical_Completed__c =true;
        candidate.Declaration_Completed__c=true;
        candidate.TOE_Completed__c =true;
        candidate.New_Starter_Form__c=true;
        candidate.Equal_Opportunity_Completed__c=true;


        //candidate.t2placement_PassToTempest__c=null;
        Insert candidate;

        id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('LTD').getRecordTypeId();


        IP_PayProfile__c payprofile = new IP_PayProfile__c();
        payprofile.RecordTypeId = payRTId;

        payprofile.IP_Candidate__c = candidate.id;
        payprofile.IP_CompanyName__c='sfdc';
        payprofile.IP_Status__c = 'Active';
        payprofile.IP_CompanyRegNo__c  = 'ad123456';
        payprofile.IP_VATNumber__c     = '123456789';
        payprofile.IP_PayrollID__c  = 'testpaynew';
        payprofile.IP_VATRegistered__c=true;
        payprofile.IP_OkToSupply__c=1;
        payprofile.IP_BuildingSocietyNumber__c='12f';
        payprofile.IP_BusinessAddressLine1__c='test address 1';
        payprofile.IP_BusinessAddressLine2__c='test address 2';
        payprofile.IP_BusinessAddressTown__c='town city';
        payprofile.IP_BusinessAddressPostcode__c='12345678';
        payprofile.IP_PayFrequency__c='Weekly';
        payprofile.IP_PaymentType__c='BACS';
        payprofile.IP_PrimaryPayMethod__c=true;
        payprofile.IP_BankAccountName__c ='Vandita';
        payprofile.IP_AccountNumber__c ='12345678';
        payprofile.IP_SortCode__c = '123456';
        insert payprofile;

        System.debug('check pay profile'+payprofile.IP_MissingPayrollDetail__c);
        system.debug('check pay profile candidate'+payprofile.IP_Candidate__r.IP_MCLTD__c);

        sirenum__Site__c site = new sirenum__Site__c();
        site.Name = 'testsite';
        site.sirenum__Operating_Company__c= account.id;
        site.IP_ClientIDLegacy__c ='QAWWSED12';
        site.IP_PublicSector__c='No';
        site.IP_ClientInvoiceName__c = 'Testinvoice';
        insert site;

        sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
        contract.Name                 = 'test contract';
        contract.sirenum__Client__c   = account.id;
        contract.sirenum__Employee__c = con1.id;
        insert contract;

        // to create job roll need to create job type and  Imappelam Sector
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
        jobroll.name = 'testjobroll';
        jobroll.sirenum__Account__c = contract.id;
        jobroll.sirenum__Job_Type__c = jobtype.id;
        jobroll.IP_OPWIPSRole__c='No';
        jobroll.sirenum__Rota__c=sector.id;
        insert jobroll;

        sirenum__Placement__c splacement = new sirenum__Placement__c();
        splacement.Name = 'test placement new';
        splacement.sirenum__Contact__c = candidate.id;
        splacement.sirenum__Start_Date__c = Datetime.now().addDays(-60).date().toStartOfWeek();
        splacement.sirenum__Site__c= site.Id;
        splacement.IP_Consultant1LookupSplitShare__c= consultantUser.Id;
        splacement.IP_Consultant1PercentageSplit__c=100;
        splacement.sirenum__Contract__c = contract.id;
        splacement.sirenum__Job_Role__c = jobroll.id;
        splacement.sirenum__Rota__c = sector.id;

        insert splacement;
        system.debug('--splacement--'+splacement.Id);
        System.debug('--splacement Missing Details------>'+splacement.Missing_Placement_Details__c);
        System.debug('--splacement MCLTD Details------>'+splacement.sirenum__Contact__r.IP_MCLTD__c);

        sirenum__Timesheet__c createtimeshsheet = new sirenum__Timesheet__c();
        createtimeshsheet.sirenum__Client__c= account.id;
        createtimeshsheet.sirenum__Worker__c= con1.id;
        createtimeshsheet.sirenum__Team__c=jobroll.id;
        createtimeshsheet.sirenum__Site__c=site.id;
        createtimeshsheet.sirenum__Week_Ending__c=system.today();
        createtimeshsheet.sirenum__Non_Taxed_Expenses__c=34.2;
        createtimeshsheet.sirenum__Taxed_Expenses__c=22.2;
        createtimeshsheet.sirenum__Non_Taxed_Deductions__c=22.0;
        createtimeshsheet.sirenum__Taxed_Deductions__c=22.1;
        insert createtimeshsheet;

        system.debug('Value in createtimeshsheet'+ createtimeshsheet);
        sirenum__Shift__c sshift =new sirenum__Shift__c();
        sshift.sirenum__Placement__c = splacement.id;
        sshift.sirenum__Team__c = jobroll.id;
        sshift.sirenum__Site__c=site.id;
        sshift.sirenum__Contact__c=con1.id;
        sshift.sirenum__Published_Ever__c=true;
        sshift.sirenum__Published__c=true;
        sshift.sirenum__Timesheet_summaries__c = createtimeshsheet.id;
        sshift.sirenum__Rota__c = sector.id;
        insert sshift;
        system.debug('Value in shift'+ sshift);

        sirenum__Timesheet_Line__c stsl = new sirenum__Timesheet_Line__c();
        stsl.sirenum__Timesheet__c=createtimeshsheet.id;
        stsl.sirenum__Rate__c=22.0;
        stsl.sirenum__Hours__c=1;
        stsl.IP_RateCodes__c='Standard Hours /P1';
        stsl.sirenum__Shift__c=sshift.id;
        stsl.IP_PurchaseOrderNumber__c='1234';
        Insert stsl;
        system.debug('Value in timesheetline'+ stsl);
    }
}