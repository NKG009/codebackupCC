@isTest
public class TestCandidateP45ActionControlerLightning {
    
    @testsetup
    static void splacementDetails(){
        
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
        Account acc = TestDataFactory.createClients(1)[0]; 
        insert acc;
         Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
         
        insert acc1;
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

        RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
        Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc.id);

        insert maincon;
        
        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
        
         Contact con = new Contact(AccountID = acc1.Id, 
                                           RecordTypeId=condRec.id,
                                          FirstName ='Manish',
                                          Salutation ='Mr',
                                          MailingCity='ggn',
                                          MailingCountry='india',
                                          MailingPostalCode='110092',
                                          MailingState='Haryana',
                                          LastName ='candidate',  
                                          sirenum__National_Insurance__c='AA323232A', 
                                          IP_CandidateIDlegacy__c='dsdsdsdd', 
                                          MailingStreet='abc',
                                          P45_Requested__c=true,
                                          PayrollLeaver__c=null,
                                          Title = 'TestLastName',
                                          Initials__c = 'TestLastName',
                                          Birthdate = Date.valueOf('1990-02-20'),
                                          Phone = '9879879877',
                                   IP_WorkerStartDate__c=Date.valueOf('2017-02-20'),
                                         EEO_Gender__c = 'M',
                                          IP_CategoryOfWork__c='Catering;Industrial',
                                        IP_ThirdPartyID__c='testpay12',
                                  IP_IsInvoicecontact__c=true
                                  );
        
         insert con;

        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        
        RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'PAYE'];

        IP_PayProfile__c pay= new IP_PayProfile__c();
        pay.RecordTypeId=rt.id;
        pay.IP_Candidate__c = con.id;
        pay.IP_PayrollID__c='Testpayrol';
        pay.IP_Status__c='Active';
        pay.IP_Candidate__c=c.Id;
        pay.IP_CompanyRegNo__c='12345678';
        pay.IP_VATRegistered__c=true;
        pay.IP_VATNumber__c='123456789';
        pay.P45_Initiated__c=true;
        pay.IP_LastPassedTotempest__c = Date.newInstance(2017, 01, 01);
        insert pay;

        
         id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('LTD').getRecordTypeId();
   
         IP_PayProfile__c payprofile = new IP_PayProfile__c();
         payprofile.RecordTypeId = payRTId;
          
       payprofile.IP_Candidate__c = con.id;
         payprofile.IP_CompanyName__c='sfdc';
         payprofile.IP_Status__c = 'Active'; 
         payprofile.IP_CompanyRegNo__c  = 'ad123456';
         payprofile.IP_VATNumber__c     = '123456789';
         payprofile.IP_PayrollID__c  = 'testpay1';
         payprofile.IP_VATRegistered__c=true;
         payprofile.IP_OkToSupply__c=1;
         payprofile.IP_BuildingSocietyNumber__c='23123';
         payprofile.IP_BusinessAddressLine1__c='test address 1';
         payprofile.IP_BusinessAddressLine2__c='test address 2';
         payprofile.IP_BusinessAddressTown__c='town city';
         payprofile.IP_BusinessAddressPostcode__c='12345678';
         payprofile.IP_PayFrequency__c='Weekly';
         payprofile.IP_PaymentType__c='BACS';
         payprofile.IP_BankAccountName__c = 'testname';
         payprofile.IP_AccountNumber__c = '98958987';
         payprofile.IP_SortCode__c = '887788';
        //payprofile.IP_PassToTempest__c=true;
         insert payprofile;
        
        con.AccountId = acc.id;
        update con;

        Profile p = [SELECT Id FROM Profile where name='System Administrator'];
        User usr = TestDataFactory.createUsers(p.Id,1)[0];
        usr.username = 'hgd89809@cko.com';
        usr.IP_TempestDepartment__c = '1062';
        usr.IP_TempestID__c = '2342341';
        usr.IP_PassToTempest__c = TRUE;
        insert usr; 

        Test.startTest();

        IP_TopazGlobalClientInformation__c globalclient = new IP_TopazGlobalClientInformation__c();
        globalclient.Name='Test global topaz';
        globalclient.IP_StatusID__c=2;
        globalclient.IP_SalesLedgerNumber__c='123';
        insert globalclient;

        sirenum__Site__c site = new sirenum__Site__c();
        site.Name = 'testsite';
        site.sirenum__Operating_Company__c= acc.id;
        site.IP_ClientIDLegacy__c='123';
        site.GlobalClientName__c=globalclient.id;
        site.IP_ClientInvoiceName__c='Testclient';
        site.IP_InvoiceAddressStreet__c='101';
        site.IP_InvoiceAddressCity__c = 'Delhi';
        site.IP_InvoiceAddressPostcode__c = '110035';
        site.IP_MainContact__c = maincon.id;
        site.IP_InvoiceContact__c = maincon.id;
        site.Ownerid = usr.id;
        site.IP_PublicSector__c = 'No';
        insert site;

        sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
        contract.Name                 = 'test contract';
        contract.sirenum__Client__c   = acc.id;
        contract.sirenum__Employee__c = c.id;
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
        jobroll.IP_OPWIPSRole__c = 'No';
        jobroll.sirenum__Rota__c =  sector.id;
        insert jobroll;

        sirenum__Placement__c spleacement = new sirenum__Placement__c();
        spleacement.Name = 'testing placment';
        spleacement.sirenum__Contact__c = c.id;
        spleacement.sirenum__Start_Date__c =  Date.newInstance(2018,11,01);
        spleacement.sirenum__End_Date__c= Date.newInstance(2019,12,20);
        spleacement.sirenum__Contract__c = contract.id;
        spleacement.sirenum__Job_Role__c = jobroll.id;
        spleacement.sirenum__Site__c = site.Id;
        spleacement.sirenum__Status__c   = 'Active';
        spleacement.IP_PayMethod__c = pay.id;
        spleacement.sirenum__Rota__c = sector.id;
        spleacement.IP_Consultant1PercentageSplit__c=100;
        spleacement.IP_Consultant1LookupSplitShare__c = usr.id;
        insert spleacement;
        System.debug('**Test class check**'+spleacement);
        sirenum__placement__C p56 = [Select id,IP_Consultant1IDnumberSplitShare__c from sirenum__placement__C where id =:spleacement.id ];
        System.debug('**Test class check**'+p56.IP_Consultant1IDnumberSplitShare__c);  

        sirenum__Timesheet__c newTimeSheet1 = new sirenum__Timesheet__c();
        newTimeSheet1.sirenum__Worker__c = c.id;
        newTimesheet1.sirenum__Client__c=acc.id;
        newTimesheet1.sirenum__Team__c=jobroll.id;
        newTimesheet1.sirenum__Site__c=site.Id;
        newTimesheet1.sirenum__Week_Ending__c =Date.newInstance(2018,11,24);
        insert newTimeSheet1;

        sirenum__Shift__c shift = new sirenum__Shift__c();
        shift.sirenum__Site__c = site.id;
        shift.sirenum__Placement__c = spleacement.Id;
        shift.sirenum__Team__c = jobroll.id;
        shift.sirenum__Contact__c = c.id;
        shift.sirenum__Published__c = true;
        shift.sirenum__cancelled__c = false;
        shift.sirenum__Rota__c = sector.id;
        // shift.sirenum__Timesheet_summaries__c = newTimesheet1.Id;
        insert shift;
        system.debug('**Test class check shift**'+shift);

        sirenum__Timesheet_Line__c stl = new sirenum__Timesheet_Line__c();
        stl.sirenum__Timesheet__c=newTimeSheet1.id;
        stl.sirenum__Rate__c=22.0;
        stl.sirenum__Hours__c=1;
        stl.IP_PassToTempest__c=true;     
        stl.IP_RateCodes__c='Taxable Expenses /TX';
        stl.sirenum__Shift__c=shift.id;
        insert stl;     
        Test.stopTest();
    }
        
    static testmethod void P45action2(){
        
        List<Contact> listContact = [Select id from Contact limit 1];   
        
        system.debug('++++1111111++++++++++++'+listContact[0].id);
        List<IP_PayProfile__c> listPayProfile = [Select id from IP_PayProfile__c where IP_PayrollID__c='Testpayrol' limit 1];
        System.debug('check test class list--->'+listPayProfile);
        String str = JSON.serialize(listPayProfile[0]);
        str = '['+str+']';
        System.debug('check test class string'+str);
        CandidateP45ActionControllerLightning testAccPlan = new CandidateP45ActionControllerLightning();
        testAccPlan.getItems();
        testAccPlan.getleavingoptions();
        testAccPlan.setleavingoptions('Switching Pay Profile (e.g. PAYE transferring to LTD Co)');
        testAccPlan.getpps();
        testAccPlan.getpayitems();
        testAccPlan.getpayprofileoptions();
        testAccPlan.setpayprofileoptions('PAYE');
        testAccPlan.selectOnClick();
        CandidateP45ActionControllerLightning.buttonsDisplayed();
        CandidateP45ActionControllerLightning.checkSelectedValue('Leaving',listContact[0].id);
        CandidateP45ActionControllerLightning.checkandproceed(str, 'Leaving' , listContact[0].Id);
        CandidateP45ActionControllerLightning.wraperpp wr = new CandidateP45ActionControllerLightning.wraperpp(listPayProfile[0]);
        //CandidateP45ActionControllerLightning.ppwrap[0].selected=True; 
    }
    
    static testmethod void P45action1(){
        
        List<Contact> listContact = [Select id from Contact limit 1];
        
        List<sirenum__Timesheet_Line__c> listTimesheetLine = [Select id from sirenum__Timesheet_Line__c limit 1];
        delete listTimesheetLine;
        
        system.debug('++++1111111++++++++++++'+listContact[0].id);
        List<IP_PayProfile__c> listPayProfile = [Select id from IP_PayProfile__c where IP_PayrollID__c='Testpayrol' limit 1];
        System.debug('check test class list--->'+listPayProfile);
        String str = JSON.serialize(listPayProfile[0]);
        str = '['+str+']';
        System.debug('check test class string'+str);
        CandidateP45ActionControllerLightning testAccPlan = new CandidateP45ActionControllerLightning();
        testAccPlan.getItems();
        testAccPlan.getleavingoptions();
        testAccPlan.setleavingoptions('Switching Pay Profile (e.g. PAYE transferring to LTD Co)');
        testAccPlan.getpps();
        testAccPlan.getpayitems();
        testAccPlan.getpayprofileoptions();
        testAccPlan.setpayprofileoptions('PAYE');
        testAccPlan.selectOnClick();
        CandidateP45ActionControllerLightning.buttonsDisplayed();
        CandidateP45ActionControllerLightning.checkSelectedValue('Leaving',listContact[0].id);
        CandidateP45ActionControllerLightning.checkandproceed(str, 'Leaving' , listContact[0].Id);
        CandidateP45ActionControllerLightning.wraperpp wr = new CandidateP45ActionControllerLightning.wraperpp(listPayProfile[0]);
    }
    
    static testmethod void P45actionExceptLeavingOptions(){
        
        List<Contact> listContact = [Select id from Contact where FirstName ='Manish' limit 1];
        
        id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('LTD').getRecordTypeId();
        
        system.debug('++++1111111++++++++++++'+listContact[0].id);
        List<IP_PayProfile__c> listPayProfileLTD = [Select id from IP_PayProfile__c where IP_PayrollID__c='testpay1' limit 1];
        System.debug('check test class list--->'+listPayProfileLTD);
        String str = JSON.serialize(listPayProfileLTD);
        //str = '['+str+']';
        str = '[{"conp":{"Id":"'+listPayProfileLTD[0].id+'","RecordTypeId":"'+payRTId+'","Name":"IN00001395","IP_PrimaryPayMethod__c":true,"P45_Initiated__c":false,"IP_Status__c":"Active","Reason_for_Leaving1__c":"Automatic","IP_Candidate__c":"'+listContact[0].id+'"},"selected":true}]';
        System.debug('check test class string'+str);
        CandidateP45ActionControllerLightning testAccPlan = new CandidateP45ActionControllerLightning();
        testAccPlan.getItems();
        testAccPlan.getleavingoptions();
        testAccPlan.setleavingoptions('Switching Pay Profile (e.g. PAYE transferring to LTD Co)');
        testAccPlan.getpps();
        testAccPlan.getpayitems();
        testAccPlan.getpayprofileoptions();
        testAccPlan.setpayprofileoptions('PAYE');
        testAccPlan.selectOnClick();
        CandidateP45ActionControllerLightning.buttonsDisplayed();
        CandidateP45ActionControllerLightning.checkSelectedValue('Switching Pay Profile (e.g. PAYE transferring to LTD Co)',listContact[0].id);
        CandidateP45ActionControllerLightning.checkandproceed(str, 'Switching Pay Profile (e.g. PAYE transferring to LTD Co)' , listContact[0].Id);
        CandidateP45ActionControllerLightning.wraperpp wr = new CandidateP45ActionControllerLightning.wraperpp(listPayProfileLTD[0]);
        //CandidateP45ActionControllerLightning.ppwrap[0].selected=True; 
    }
    
    static testmethod void P45action3(){
        
        List<Contact> listContact = [Select id from Contact limit 1];
        
        List<sirenum__Placement__c> listSplacement = [Select id from sirenum__Placement__c limit 1];
        delete listSplacement;
        
        List<sirenum__Shift__c> listShift = [Select id from sirenum__Shift__c limit 1];
        delete listShift;
        
        system.debug('++++1111111++++++++++++'+listContact[0].id);
        List<IP_PayProfile__c> listPayProfile = [Select id from IP_PayProfile__c where IP_PayrollID__c='Testpayrol' limit 1];
        System.debug('check test class list--->'+listPayProfile);
        String str = JSON.serialize(listPayProfile[0]);
        str = '['+str+']';
        System.debug('check test class string'+str);
        CandidateP45ActionControllerLightning testAccPlan = new CandidateP45ActionControllerLightning();
        testAccPlan.getItems();
        testAccPlan.getleavingoptions();
        testAccPlan.setleavingoptions('Switching Pay Profile (e.g. PAYE transferring to LTD Co)');
        testAccPlan.getpps();
        testAccPlan.getpayitems();
        testAccPlan.getpayprofileoptions();
        testAccPlan.setpayprofileoptions('PAYE');
        testAccPlan.selectOnClick();
        CandidateP45ActionControllerLightning.buttonsDisplayed();
        CandidateP45ActionControllerLightning.checkSelectedValue('Leaving',listContact[0].id);
        CandidateP45ActionControllerLightning.checkandproceed(str, 'Leaving' , listContact[0].Id);
        CandidateP45ActionControllerLightning.wraperpp wr = new CandidateP45ActionControllerLightning.wraperpp(listPayProfile[0]);
        //CandidateP45ActionControllerLightning.ppwrap[0].selected=True; 
    }
    
    static testmethod void P45action4(){
        
        List<Contact> listContact = [Select id from Contact limit 1];
        
        List<sirenum__Placement__c> listSplacement = [Select id from sirenum__Placement__c limit 1];
        delete listSplacement;
        
        List<sirenum__Shift__c> listShift = [Select id from sirenum__Shift__c limit 1];
        delete listShift;
        
        List<sirenum__Timesheet_Line__c> listTimesheetLine = [Select id from sirenum__Timesheet_Line__c limit 1];
        delete listTimesheetLine;
        
        system.debug('++++1111111++++++++++++'+listContact[0].id);
        List<IP_PayProfile__c> listPayProfile = [Select id from IP_PayProfile__c where IP_PayrollID__c='Testpayrol' limit 1];
        System.debug('check test class list--->'+listPayProfile);
        String str = JSON.serialize(listPayProfile[0]);
        str = '['+str+']';
        System.debug('check test class string'+str);
        CandidateP45ActionControllerLightning testAccPlan = new CandidateP45ActionControllerLightning();        
        testAccPlan.getItems();
        testAccPlan.getleavingoptions();
        testAccPlan.setleavingoptions('Switching Pay Profile (e.g. PAYE transferring to LTD Co)');
        testAccPlan.getpps();
        testAccPlan.getpayitems();
        testAccPlan.getpayprofileoptions();
        testAccPlan.setpayprofileoptions('PAYE');
        testAccPlan.selectOnClick();        
        CandidateP45ActionControllerLightning.buttonsDisplayed();    
        testAccPlan.flag = 'test';
        testAccPlan.flag1 = 'test';
        CandidateP45ActionControllerLightning.wraperpp wr = new CandidateP45ActionControllerLightning.wraperpp(listPayProfile[0]);
        wr.selected=true;
        CandidateP45ActionControllerLightning.checkSelectedValue('Switching Pay Profile (e.g. PAYE transferring to LTD Co)',listContact[0].id);
        //CandidateP45ActionControllerLightning.checkandproceed(str, 'Switching Pay Profile (e.g. PAYE transferring to LTD Co)' , listContact[0].Id);
    }

}