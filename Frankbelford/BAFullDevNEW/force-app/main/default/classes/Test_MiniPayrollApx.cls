@isTest
public class Test_MiniPayrollApx{

static testMethod void Test1(){
        
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
        Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);         
        insert acc1;
                RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 

        Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc;
                RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];

        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

        Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc.id);      
        insert maincon;
             
         insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);

        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
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
                                        IP_ThirdPartyID__c='testpay12'
                                  );       
         insert con;
         
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
        site.sirenum__Street_Address__c = 'ABC';
       site.sirenum__City__c = 'ABC';
        site.IP_InvoiceContact__c = maincon.id;
        site.IP_MainContact__c = maincon.id;
        site.IP_PublicSector__c = 'No';
         insert site;
         
         sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
         
         contract.Name                 = 'test contract';
         contract.sirenum__Client__c   = acc.id;
         contract.sirenum__Employee__c = con.id;
         
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
         
         jobroll.name = 'testjobroll';
         jobroll.sirenum__Account__c = contract.id; 
         jobroll.sirenum__Job_Type__c = jobtype.id;
         jobroll.IP_OPWIPSRole__c = 'No';
        jobroll.sirenum__Rota__c = sector.id;
         insert jobroll;
         
         sirenum__Placement__c spleacement = new sirenum__Placement__c();
         
                 spleacement.Name = 'testing placment';
                 spleacement.sirenum__Contact__c = con.id;
                spleacement.sirenum__Start_Date__c =  Date.newInstance(2017,11,01);
                 spleacement.sirenum__End_Date__c= Date.newInstance(2017,12,20);
                 spleacement.sirenum__Contract__c = contract.id;
                 spleacement.sirenum__Job_Role__c = jobroll.id;
                 spleacement.sirenum__Site__c = site.Id;
                 spleacement.sirenum__Status__c   = 'Active';
                 spleacement.IP_PayMethod__c = payprofile.id;
                 spleacement.IP_Consultant1PercentageSplit__c=100;
            spleacement.sirenum__Rota__c = sector.id;
                // spleacement.IP_PassToTempest__c=true;
                 insert spleacement;
                 
                 IP_ImpellamGlobalSetting__c setting = new IP_ImpellamGlobalSetting__c();
                 setting.IP_LastTransmissionDate__c =   Date.newInstance(2019,07,01);
                 insert setting;
                 
                 insert new IP_Parallel_Payroll_Check__c(name = 'RunParallelCheck', Run_Parallel_Payroll__c = false); 
                 IP_BranchStatus__c b  = new IP_BranchStatus__c ();
                 b.IP_BranchID__c = '1062';
                 b.Name = 'Test';
                 insert b;
                 
     sirenum__Timesheet__c newTimeSheet1 = new sirenum__Timesheet__c();
     newTimeSheet1.sirenum__Worker__c = con.id;
     newTimesheet1.sirenum__Client__c=acc.id;
     newTimesheet1.sirenum__Team__c=jobroll.id;
     newTimesheet1.sirenum__Site__c=site.Id;
     newTimesheet1.IP_DuplicateCheckPassOK__c = TRUE;
     newTimesheet1.IP_FlaggingCheck__c = TRUE;
     newTimesheet1.sirenum__Week_Ending__c =Date.newInstance(2017,11,24);
        insert newTimeSheet1;
        
          sirenum__Shift__c shift = new sirenum__Shift__c();
                          shift.sirenum__Site__c = site.id;
                          shift.sirenum__Placement__c = spleacement.Id;
                          shift.sirenum__Team__c = jobroll.id;
                          shift.sirenum__Contact__c = con.id;
                shift.sirenum__Rota__c = sector.id;
                          shift.sirenum__Timesheet_summaries__c = newTimesheet1.Id;
        insert shift;
        
        sirenum__Timesheet_Line__c  stsl = new sirenum__Timesheet_Line__c();
        stsl.sirenum__Timesheet__c =  newTimeSheet1.id;
        stsl.sirenum__Shift__c = shift.id;
        stsl.sirenum__Rate__c = 12;
        stsl.sirenum__Charge__c =10;
        stsl.sirenum__Hours__c = 1;
        stsl.IP_RateCodes__c =  'Standard Hours /P1';
        insert stsl;
        
        Test.startTest();
        MiniPayrollApx.MiniPayrollBtn(newTimeSheet1.id);
        Test.stopTest();
     }
	 static testMethod void Test2(){
        
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
        Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);         
        insert acc1;
                RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 

        Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc;
                RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];

        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

        Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc.id);      
        insert maincon;
             
         insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);

        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
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
                                        IP_ThirdPartyID__c='testpay12'
                                  );       
         insert con;
         
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
        site.sirenum__Street_Address__c = 'ABC';
       site.sirenum__City__c = 'ABC';
        site.IP_InvoiceContact__c = maincon.id;
        site.IP_MainContact__c = maincon.id;
        site.IP_PublicSector__c = 'No';
         insert site;
         
         sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
         
         contract.Name                 = 'test contract';
         contract.sirenum__Client__c   = acc.id;
         contract.sirenum__Employee__c = con.id;
         
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
         
         jobroll.name = 'testjobroll';
         jobroll.sirenum__Account__c = contract.id; 
         jobroll.sirenum__Job_Type__c = jobtype.id;
         jobroll.IP_OPWIPSRole__c = 'No';
        jobroll.sirenum__Rota__c = sector.id;
         insert jobroll;
         
         sirenum__Placement__c spleacement = new sirenum__Placement__c();
         
                 spleacement.Name = 'testing placment';
                 spleacement.sirenum__Contact__c = con.id;
                spleacement.sirenum__Start_Date__c =  Date.newInstance(2017,11,01);
                 spleacement.sirenum__End_Date__c= Date.newInstance(2017,12,20);
                 spleacement.sirenum__Contract__c = contract.id;
                 spleacement.sirenum__Job_Role__c = jobroll.id;
                 spleacement.sirenum__Site__c = site.Id;
                 spleacement.sirenum__Status__c   = 'Active';
                 spleacement.IP_PayMethod__c = payprofile.id;
                 spleacement.IP_Consultant1PercentageSplit__c=100;
            spleacement.sirenum__Rota__c = sector.id;
                // spleacement.IP_PassToTempest__c=true;
                 insert spleacement;
                 
                 IP_ImpellamGlobalSetting__c setting = new IP_ImpellamGlobalSetting__c();
                 setting.IP_LastTransmissionDate__c =   Date.newInstance(2019,07,01);
                 insert setting;
                 
                 insert new IP_Parallel_Payroll_Check__c(name = 'RunParallelCheck', Run_Parallel_Payroll__c = false); 
                 IP_BranchStatus__c b  = new IP_BranchStatus__c ();
                 b.IP_BranchID__c = '1062';
                 b.Name = 'Test';
                 insert b;
                 
     sirenum__Timesheet__c newTimeSheet1 = new sirenum__Timesheet__c();
     newTimeSheet1.sirenum__Worker__c = con.id;
     newTimesheet1.sirenum__Client__c=acc.id;
     newTimesheet1.sirenum__Team__c=jobroll.id;
     newTimesheet1.sirenum__Site__c=site.Id;
     newTimesheet1.IP_DuplicateCheckPassOK__c = TRUE;
     newTimesheet1.IP_FlaggingCheck__c = TRUE;
     newTimesheet1.sirenum__Week_Ending__c =Date.newInstance(2017,11,24);
        insert newTimeSheet1;
        
          sirenum__Shift__c shift = new sirenum__Shift__c();
                          shift.sirenum__Site__c = site.id;
                          shift.sirenum__Placement__c = spleacement.Id;
                          shift.sirenum__Team__c = jobroll.id;
                          shift.sirenum__Contact__c = con.id;
                shift.sirenum__Rota__c = sector.id;
                          shift.sirenum__Timesheet_summaries__c = newTimesheet1.Id;
        insert shift;
        
        sirenum__Timesheet_Line__c  stsl = new sirenum__Timesheet_Line__c();
        stsl.sirenum__Timesheet__c =  newTimeSheet1.id;
        stsl.sirenum__Shift__c = shift.id;
        stsl.sirenum__Rate__c = 12;
        stsl.sirenum__Charge__c =10;
        stsl.sirenum__Hours__c = 1;
		stsl.IP_LastPassedtoTempest__c = system.now();
        stsl.IP_RateCodes__c =  'Standard Hours /P1';
        insert stsl;
        
        Test.startTest();
        MiniPayrollApx.MiniPayrollBtn(newTimeSheet1.id);
         MiniPayrollApx.MiniPayrollBtn2(newTimeSheet1.id);
        Test.stopTest();
     }
     
     
  }