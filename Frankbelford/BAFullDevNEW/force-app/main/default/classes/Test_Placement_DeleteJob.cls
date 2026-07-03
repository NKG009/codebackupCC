@istest 
public class Test_Placement_DeleteJob{

    public testmethod static void plcementTest1(){
    
    RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
    RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        
     Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
         
        insert acc1;
     Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc;
                  insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

     Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc.id, IP_ContactType__c = 'Invoice Contact');
      
        insert maincon;
         
     
        System.debug('ACC '+acc);
         insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);

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
                                          IP_CategoryOfWork__c='Catering',
                                        IP_ThirdPartyID__c='testpay12',
                                  IP_IsInvoicecontact__c=true
                                  );
        
         insert con;
   //   con.AccountId = acc.id;
     //   update con;
                     insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = true);

         
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
        
      //   con.AccountId = acc.id;
       // update con;
        
      //  Contact c = [Select id,Account.name from Contact where id =: con.id];
       // System.debug(' @@ ' + c.account.name);
        
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
                 Datetime yesterday = Datetime.now().addDays(-31);
                Test.setCreatedDate(spleacement.Id, yesterday);
                
                 sirenum__Timesheet__c newTimeSheet1 = new sirenum__Timesheet__c();
        newTimeSheet1.sirenum__Worker__c = con.id;
        newTimesheet1.sirenum__Client__c=acc.id;
        newTimesheet1.sirenum__Team__c=jobroll.id;
        newTimesheet1.sirenum__Site__c=site.Id;
        newTimesheet1.sirenum__Week_Ending__c =Date.newInstance(2017,11,24);
        insert newTimeSheet1;
        
                sirenum__Shift__c shft = TestDataFactory.createShift(spleacement.id, site.id,1)[0];
      // shft.sirenum__Timesheet_summaries__c = newTimeSheet1.id;
        shft.sirenum__Team__c = jobroll.id;
        shft.sirenum__Published__c = TRUE;
        shft.sirenum__Contact__c = con.id;
        shft.sirenum__Rota__c = sector.id;
        shft.sirenum__Scheduled_Start_Time__c = System.now().addDays(-40);
                shft.sirenum__Scheduled_End_Time__c = System.now().addDays(-40);
        insert shft; 
        system.debug('inserted shift');
        
                 
                 sirenum__Assignment__c assign = new sirenum__Assignment__c();
                 assign.sirenum__Placement__c = spleacement.id;
                 insert assign;
                   IP_ImpellamGlobalSetting__c setting = new IP_ImpellamGlobalSetting__c();
                 setting.S_placementLimitSize__c =   'LAST_N_DAYS:30';
         setting.S_placement_Deletion_Size__c =   '100';
                 insert setting;
                 Placement_DeleteJob ab = new Placement_DeleteJob();
                 ab.sendMail = True;
                 
                   Database.executeBatch(ab,10);
        
         
                        Test.StartTest();
        splacementDeleteSchedule sh1 = new splacementDeleteSchedule();
        String sch = '0 30 * * * ?';
        system.schedule('Test placement delete', sch, sh1);
        Test.stopTest();
    
    }
  
}