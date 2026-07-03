@isTest

private class Test_Checkduplicatebatch{

static testMethod void testduplicate1() 
    {     
        Account acc =  TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
            RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 

        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc1;
            RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
     Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id, IP_ContactType__c = 'Invoice Contact');
      
        insert maincon;
        
        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
                 insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);

        Contact con = new Contact(AccountID = acc.Id, 
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
                                          ts2__EEO_Gender__c = 'M',
                                          IP_CategoryOfWork__c='Catering;Industrial',
                                           IP_ThirdPartyID__c='testpay12');
             insert con;  
             sirenum__Site__c site = new sirenum__Site__c();         
             site.Name = 'testsite';
             site.sirenum__Operating_Company__c= acc1.id;
             site.IP_ClientIDLegacy__c='123';
             site.IP_ClientInvoiceName__c = 'test abc';
       site.IP_PublicSector__c = 'No';
       site.IP_InvoiceContact__c = maincon.id;
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
         
         insert jobroll;
         
          Profile p = [SELECT Id FROM Profile where name='System Administrator'];
      User usr = TestDataFactory.createUsers(p.Id,1)[0];
        usr.username = 'nbjudui453@mko.com';
        usr.IP_TempestDepartment__c = '1062';
        usr.IP_TempestID__c = '65742';
        usr.IP_PassToTempest__c = TRUE;
        insert usr; 
             
         sirenum__Timesheet__c newTimeSheet = new sirenum__Timesheet__c();
         newTimeSheet.sirenum__Worker__c = con.id;
         newTimesheet.sirenum__Client__c=acc.id;
         newTimesheet.sirenum__Team__c=jobroll.id;
         newTimesheet.sirenum__Site__c=site.Id;
         newTimesheet.IP_DuplicateCheckPassOK__c = false;
         newTimesheet.IP_StandardWeeklyNumberID__c = '100013920119';
         newTimesheet.sirenum__Week_Ending__c =Date.newInstance(2017,11,24);
         insert newTimeSheet; 
        System.debug('timesheet1'+newTimeSheet);
         
          sirenum__Placement__c splace = TestDataFactory.createSPlacement1(con.Id, contract.Id, jobroll.Id,usr.Id, 1)[0]; 
        splace.sirenum__site__C = site.id;
       // splace.IP_PayMethod__c =payprofile.id;
        splace.IP_PasstoTempest__c = False;
        
        Insert splace;
        
              System.debug('check placement'+splace);
        
        sirenum__Shift__c shft = TestDataFactory.createShift(splace.id, site.id,1)[0];
        shft.sirenum__Contact__c = con.id;
        shft.sirenum__Timesheet_summaries__c = newTimeSheet.id;
        insert shft;  

         
        sirenum__Timesheet__c newTimeSheet1 = new sirenum__Timesheet__c();
         newTimeSheet1.sirenum__Worker__c = con.id;
         newTimesheet1.sirenum__Client__c=acc.id;
         newTimesheet1.sirenum__Team__c=jobroll.id;
         newTimesheet1.sirenum__Site__c=site.Id;
         newTimesheet1.IP_DuplicateCheckPassOK__c = false;
         newTimesheet1.IP_StandardWeeklyNumberID__c = '100013920119';
         newTimesheet1.sirenum__Week_Ending__c =Date.newInstance(2017,11,24);
         insert newTimeSheet1; 
         System.debug('timesheet2'+newTimeSheet1);
         
            sirenum__Timesheet_Line__c stsl = new sirenum__Timesheet_Line__c(); 
        stsl.sirenum__Timesheet__c=newTimeSheet1.id;
                stsl.sirenum__Rate__c=22.0;
                stsl.sirenum__Hours__c=1;
                stsl.IP_PassToTempest__c=true;    
                stsl.IP_RateCodes__c='Taxable Expenses /TX';
                stsl.sirenum__Shift__c=shft.id;
        stsl.IP_TimesheetSplitCheck__c = true;
     //   Insert stsl;
        
       
         
         Test.startTest();

        Database.executeBatch(new Checkduplicatebatch());
            
        Test.stopTest();
    }
static testMethod void testduplicate2() 
    {     
        Account acc =  TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
                    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 

        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc1;
            RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
     Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id, IP_ContactType__c = 'Invoice Contact');
      
        insert maincon;
        
        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
                 insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);

        Contact con = new Contact(AccountID = acc.Id, 
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
                                          ts2__EEO_Gender__c = 'M',
                                          IP_CategoryOfWork__c='Catering;Industrial',
                                           IP_ThirdPartyID__c='testpay12');
             insert con;  
             sirenum__Site__c site = new sirenum__Site__c();         
             site.Name = 'testsite';
             site.sirenum__Operating_Company__c= acc1.id;
             site.IP_ClientIDLegacy__c='123';
             site.IP_ClientInvoiceName__c = 'test abcd';
              site.IP_InvoiceContact__c = maincon.id;
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
         
         insert jobroll;
             
         sirenum__Timesheet__c newTimeSheet = new sirenum__Timesheet__c();
         newTimeSheet.sirenum__Worker__c = con.id;
         newTimesheet.sirenum__Client__c=acc.id;
         newTimesheet.sirenum__Team__c=jobroll.id;
         newTimesheet.sirenum__Site__c=site.Id;
         newTimesheet.IP_DuplicateCheckPassOK__c = false;
         newTimesheet.IP_StandardWeeklyNumberID__c = '100013920118';
         newTimesheet.sirenum__Week_Ending__c =Date.newInstance(2017,11,24);
         insert newTimeSheet; 
         
        
         
         

        Test.startTest();

        Database.executeBatch(new Checkduplicatebatch());
            
        Test.stopTest();
    }
 }