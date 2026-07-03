@istest
public class Test_timeextension {
    
    @testSetup
    public static void testSetup(){
        Profile adminProf = [SELECT Id from Profile where Name='System Administrator' LIMIT 1];
        List<User> userLst = TestDataFactory.createUsers(adminProf.Id,1);
        userLst[0].Brand__c = 'MGG';
        insert userLst[0];
    }

    public static testmethod void test1()
    {
      User user = [SELECT Id,Name FROM User LIMIT 1];
        System.runAs(user){
      Account acc =  TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
         
   
        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
          insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= true);
        
           RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;
         
        
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
                                          EEO_Gender__c = 'M',
                                          IP_CategoryOfWork__c='Catering',
                                        IP_ThirdPartyID__c='testpay1'         );
        
        insert con;
         
         id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('LTD').getRecordTypeId();
       
         IP_PayProfile__c payprofile = new IP_PayProfile__c();
         payprofile.RecordTypeId = payRTId;
          
       payprofile.IP_Candidate__c = con.id;
         payprofile.IP_CompanyName__c='sfdc';
         payprofile.IP_Status__c = 'Active'; 
         payprofile.IP_CompanyRegNo__c  = 'ad123456';
         payprofile.IP_VATNumber__c     = '123456789';
         payprofile.IP_PayrollID__c  = 'testpaynew';
         payprofile.IP_VATRegistered__c=true;
         payprofile.IP_OkToSupply__c=1;
        // payprofile.IP_BuildingSocietyNumber__c='building 123';
         payprofile.IP_BusinessAddressLine1__c='test address 1';
         payprofile.IP_BusinessAddressLine2__c='test address 2';
         payprofile.IP_BusinessAddressTown__c='town city';
         payprofile.IP_BusinessAddressPostcode__c='12345678';
         payprofile.IP_PayFrequency__c='Weekly';
         payprofile.IP_PaymentType__c='BACS';
         payprofile.IP_PassToTempest__c=true;
        payprofile.IP_LastPassedToTempest__c = null;
        payprofile.IP_BankAccountName__c = 'Bank 1';
        payprofile.IP_AccountNumber__c = '89786756';
        payprofile.IP_SortCode__c = '998866';
        payprofile.IP_EmergencyPull__c = TRUE;
        payprofile.recordtypeid = Schema.getGlobalDescribe().get('IP_PayProfile__c').getDescribe().getRecordTypeInfosByDeveloperName().get('PAYE').getRecordTypeId();
         insert payprofile;
        
             IP_TopazGlobalClientInformation__c globalclient = new IP_TopazGlobalClientInformation__c();
        globalclient.Name='Test global topaz';
        globalclient.IP_StatusID__c=2;
       globalclient.IP_SalesLedgerNumber__c='123';
         insert globalclient;
             sirenum__Site__c site = new sirenum__Site__c();
         
         site.Name = 'testsite';
         site.sirenum__Operating_Company__c= acc1.id;
         site.IP_ClientIDLegacy__c='123';
        site.GlobalClientName__c=globalclient.id;
        site.IP_ClientInvoiceName__c='Testclient';
        site.IP_InvoiceAddressStreet__c='101';
        site.IP_InvoiceAddressCity__c = 'Delhi';
        site.IP_InvoiceAddressPostcode__c = '110035';
        
        site.IP_InvoiceContact__c = maincon.id;
        site.IP_MainContact__c = maincon.id;
        site.IP_PublicSector__c = 'No';
         insert site;
         
        
          sirenum__Payroll_Cycle__c paycycle = new sirenum__Payroll_Cycle__c();
       paycycle.Name = 'Monday - Sunday';
        paycycle.sirenum__periodLength__c =7;
        paycycle.sirenum__CyclePeriodUnits__c='Weeks';
        paycycle.sirenum__StartingDate__c = Date.newInstance(2017,11,20);
        insert paycycle;
         
         sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
         
         contract.Name                 = 'test contract';
         contract.sirenum__Client__c   = acc.id;
         contract.sirenum__Employee__c = con.id;
         contract.sirenum__PayrollCycle__c = paycycle.Id;
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
         jobroll.sirenum__Rota__c = sector.id;
        jobroll.IP_OPWIPSRole__c = 'No';
         insert jobroll;
              
         sirenum__Placement__c spleacement = new sirenum__Placement__c();
         
                 spleacement.Name = 'test placment';
                 spleacement.sirenum__Contact__c = con.id;
                 spleacement.sirenum__Start_Date__c = system.today()-5;
                 spleacement.sirenum__End_Date__c=system.today()+10;
                 spleacement.sirenum__Contract__c = contract.id;
                 spleacement.sirenum__Job_Role__c = jobroll.id;
                 spleacement.sirenum__Site__c = site.Id;
                 spleacement.sirenum__Status__c   = 'Active';
                 spleacement.IP_PayMethod__c = payprofile.id;
                 spleacement.IP_Consultant1PercentageSplit__c=100;
             //spleacement.Missing_Placement_Details__c = '';
             spleacement.sirenum__Rota__c = sector.id;
                 insert spleacement;
        
        system.debug('Start Date1'+spleacement.sirenum__Start_Date__c);
        system.debug('End Date1'+spleacement.sirenum__End_Date__c);
         
         sirenum__Shift__c shft = TestDataFactory.createShift(spleacement.id, site.id,1)[0];
   shft.sirenum__Scheduled_Start_Time__c = Date.newInstance(2019,11,18);
        shft.sirenum__Scheduled_End_Time__c =  Date.newInstance(2019,11,18);
         shft.sirenum__Cancelled__c = FALSE;
        shft.sirenum__Contact__c = con.id;
        shft.sirenum__Team__c = jobroll.id;
       
       // shft.sirenum__Placement__c = spleacement.id;
       // update shft;
        system.debug('**Shift created 1**'+shft);
          Test.startTest();
         insert shft;  
          ApexPages.StandardController sc = new ApexPages.StandardController(spleacement);
        
        
       timeextension tm = new timeextension(sc);
       PageReference pageRef = Page.TimesheetDesign;
        pageRef.getParameters().put('id', String.valueOf(spleacement.Id));
        Test.setCurrentPage(pageRef);   
        system.debug('**Shift created 1 inside**'+shft);
          Database.executeBatch(new manualtimesheetbatch(),1);
        Test.stopTest();
        }
    }
    
        public static testmethod void test2()
    {
        User user = [SELECT Id,Name FROM User LIMIT 1];
        System.runAs(user){
      Account acc =  TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
        
        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
         insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= true);
       
            RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;
         
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
                                          EEO_Gender__c = 'M',
                                          IP_CategoryOfWork__c='Catering',
                                        IP_ThirdPartyID__c='testpay1'         );
        
        insert con;
         
         id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('LTD').getRecordTypeId();
        
         IP_PayProfile__c payprofile = new IP_PayProfile__c();
         payprofile.RecordTypeId = payRTId;
          
       payprofile.IP_Candidate__c = con.id;
         payprofile.IP_CompanyName__c='sfdc';
         payprofile.IP_Status__c = 'Active'; 
         payprofile.IP_CompanyRegNo__c  = 'ad123456';
         payprofile.IP_VATNumber__c     = '123456789';
         payprofile.IP_PayrollID__c  = 'testpaynew';
         payprofile.IP_VATRegistered__c=true;
         payprofile.IP_OkToSupply__c=1;
        // payprofile.IP_BuildingSocietyNumber__c='building 123';
         payprofile.IP_BusinessAddressLine1__c='test address 1';
         payprofile.IP_BusinessAddressLine2__c='test address 2';
         payprofile.IP_BusinessAddressTown__c='town city';
         payprofile.IP_BusinessAddressPostcode__c='12345678';
         payprofile.IP_PayFrequency__c='Weekly';
         payprofile.IP_PaymentType__c='BACS';
         payprofile.IP_PassToTempest__c=true;
        payprofile.IP_LastPassedToTempest__c = null;
        payprofile.IP_BankAccountName__c = 'Bank 1';
        payprofile.IP_AccountNumber__c = '89786756';
        payprofile.IP_SortCode__c = '998866';
        payprofile.IP_EmergencyPull__c = TRUE;
            payprofile.recordtypeid = Schema.getGlobalDescribe().get('IP_PayProfile__c').getDescribe().getRecordTypeInfosByDeveloperName().get('PAYE').getRecordTypeId();
         insert payprofile;
        
             IP_TopazGlobalClientInformation__c globalclient = new IP_TopazGlobalClientInformation__c();
        globalclient.Name='Test global topaz';
        globalclient.IP_StatusID__c=2;
       globalclient.IP_SalesLedgerNumber__c='123';
         insert globalclient;
              sirenum__Site__c site = new sirenum__Site__c();
         
         site.Name = 'testsite';
         site.sirenum__Operating_Company__c= acc1.id;
         site.IP_ClientIDLegacy__c='123';
        site.GlobalClientName__c=globalclient.id;
        site.IP_ClientInvoiceName__c='Testclient';
        site.IP_InvoiceAddressStreet__c='101';
        site.IP_InvoiceAddressCity__c = 'Delhi';
        site.IP_InvoiceAddressPostcode__c = '110035';
        
        site.IP_InvoiceContact__c = maincon.id;
        site.IP_MainContact__c = maincon.id;
        site.IP_PublicSector__c = 'No';
         insert site;
         
        
          sirenum__Payroll_Cycle__c paycycle = new sirenum__Payroll_Cycle__c();
       paycycle.Name = 'Monday - Sunday';
        paycycle.sirenum__periodLength__c =7;
        paycycle.sirenum__CyclePeriodUnits__c='Weeks';
        paycycle.sirenum__StartingDate__c = Date.newInstance(2017,11,21);
        insert paycycle;
         
         sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
         
         contract.Name                 = 'test contract';
         contract.sirenum__Client__c   = acc.id;
         contract.sirenum__Employee__c = con.id;
         contract.sirenum__PayrollCycle__c = paycycle.Id;
         insert contract;
         
         // to create job roll need to create job type and  Imappelam Sector
         
         sirenum__Rota__c sector = new sirenum__Rota__c();
         
         sector.Name = 'driving';
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
         jobroll.sirenum__Rota__c =sector.id;
        jobroll.IP_OPWIPSRole__c = 'No';
         insert jobroll;
              
         sirenum__Placement__c spleacement = new sirenum__Placement__c();
         
                 spleacement.Name = 'test placment';
                 spleacement.sirenum__Contact__c = con.id;
                 spleacement.sirenum__Start_Date__c =  System.today()-5;
                 spleacement.sirenum__End_Date__c= System.today()+10;
                 spleacement.sirenum__Contract__c = contract.id;
                 spleacement.sirenum__Job_Role__c = jobroll.id;
                 spleacement.sirenum__Site__c = site.Id;
                 spleacement.sirenum__Status__c   = 'Active';
                 spleacement.IP_PayMethod__c = payprofile.id;
                 spleacement.IP_Consultant1PercentageSplit__c=100;
         spleacement.sirenum__Rota__c = sector.id;
                 insert spleacement;
        
          system.debug('Start Date2'+spleacement.sirenum__Start_Date__c);
        system.debug('End Date2'+spleacement.sirenum__End_Date__c);
        
        sirenum__Shift__c shft = TestDataFactory.createShift(spleacement.id, site.id,1)[0];
   shft.sirenum__Scheduled_Start_Time__c = system.today();
        shft.sirenum__Scheduled_End_Time__c =  system.today();
        shft.sirenum__Contact__c = con.id;
         shft.sirenum__Cancelled__c = FALSE;
        shft.sirenum__Team__c = jobroll.id;
        
       //shft.sirenum__Placement__c = spleacement.id;
      //  update shft;
        system.debug('**Shift created 2**'+shft);
          Test.startTest();
         insert shft; 
          ApexPages.StandardController sc = new ApexPages.StandardController(spleacement);
        
        
       timeextension tm = new timeextension(sc);
       PageReference pageRef = Page.TimesheetDesign2;
        pageRef.getParameters().put('id', String.valueOf(spleacement.Id));
        Test.setCurrentPage(pageRef);
                  Database.executeBatch(new manualtimesheetbatch(),1);
        
        Test.stopTest();
        
    }
    }
      public static testmethod void test3()
    {
        User user = [SELECT Id,Name FROM User LIMIT 1];
        System.runAs(user){
      Account acc =  TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
        
        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
          insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= true);
        
         RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;
         
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
                                          Person_Status__c = 'Active',
                                          EEO_Gender__c = 'M',
                                            Email = 'singh.taji26@gmail.com',
                                          IP_CategoryOfWork__c='Catering',
                                        IP_ThirdPartyID__c='testpay1'         );
        
        insert con;
         
         id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('LTD').getRecordTypeId();
       
  //   insert new IP_Shift_Template__c(name = '1620', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='1234',Branch_Address__c='street1',Email__c='singh.taji26@gmail.com',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');
  insert new IP_Shift_Template__c(name = '1062', Email__c = 'singh.taji26@gmail.com');  
        
        IP_PayProfile__c payprofile = new IP_PayProfile__c();
         payprofile.RecordTypeId = payRTId;
          
       payprofile.IP_Candidate__c = con.id;
         payprofile.IP_CompanyName__c='sfdc';
         payprofile.IP_Status__c = 'Active'; 
         payprofile.IP_CompanyRegNo__c  = 'ad123456';
         payprofile.IP_VATNumber__c     = '123456789';
         payprofile.IP_PayrollID__c  = 'testpaynew';
         payprofile.IP_VATRegistered__c=true;
         payprofile.IP_OkToSupply__c=1;
        // payprofile.IP_BuildingSocietyNumber__c='building 123';
         payprofile.IP_BusinessAddressLine1__c='test address 1';
         payprofile.IP_BusinessAddressLine2__c='test address 2';
         payprofile.IP_BusinessAddressTown__c='town city';
         payprofile.IP_BusinessAddressPostcode__c='12345678';
         payprofile.IP_PayFrequency__c='Weekly';
         payprofile.IP_PaymentType__c='BACS';
         payprofile.IP_PassToTempest__c=true;
        payprofile.IP_LastPassedToTempest__c = null;
        payprofile.IP_BankAccountName__c = 'Bank 1';
        payprofile.IP_AccountNumber__c = '89786756';
        payprofile.IP_SortCode__c = '998866';
        payprofile.IP_EmergencyPull__c = TRUE;
        payprofile.recordtypeid = Schema.getGlobalDescribe().get('IP_PayProfile__c').getDescribe().getRecordTypeInfosByDeveloperName().get('PAYE').getRecordTypeId();
         insert payprofile;
        
             IP_TopazGlobalClientInformation__c globalclient = new IP_TopazGlobalClientInformation__c();
        globalclient.Name='Test global topaz';
        globalclient.IP_StatusID__c=2;
       globalclient.IP_SalesLedgerNumber__c='123';
         insert globalclient;
        
            sirenum__Site__c site = new sirenum__Site__c();
         
         site.Name = 'testsite';
        site.Ip_Timesheet_Method__c = 'Manual';
         site.sirenum__Operating_Company__c= acc1.id;
         site.IP_ClientIDLegacy__c='123';
        site.GlobalClientName__c=globalclient.id;
        site.IP_ClientInvoiceName__c='Testclient';
        site.IP_InvoiceAddressStreet__c='101';
        site.IP_InvoiceAddressCity__c = 'Delhi';
        site.IP_InvoiceAddressPostcode__c = '110035';
        
        site.IP_InvoiceContact__c = maincon.id;
        site.IP_MainContact__c = maincon.id;
        site.IP_PublicSector__c = 'No';
         insert site;
        
          sirenum__Payroll_Cycle__c paycycle = new sirenum__Payroll_Cycle__c();
       paycycle.Name = 'Monday - Sunday';
        paycycle.sirenum__periodLength__c =7;
        paycycle.sirenum__CyclePeriodUnits__c='Weeks';
        paycycle.sirenum__StartingDate__c = Date.newInstance(2017,11,22);
        insert paycycle;
         
         sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
         
         contract.Name                 = 'test contract';
         contract.sirenum__Client__c   = acc.id;
         contract.sirenum__Employee__c = con.id;
         contract.sirenum__PayrollCycle__c = paycycle.Id;
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
        jobroll.sirenum__Rota__c = sector.id;
        jobroll.IP_OPWIPSRole__c = 'No';
         
         insert jobroll;
              
         sirenum__Placement__c spleacement = new sirenum__Placement__c();
         
                 spleacement.Name = 'test placment';
                 spleacement.sirenum__Contact__c = con.id;
                 spleacement.sirenum__Start_Date__c =  System.today();
                 spleacement.sirenum__End_Date__c= System.today()+10;
                 spleacement.sirenum__Contract__c = contract.id;
                 spleacement.sirenum__Job_Role__c = jobroll.id;
                 spleacement.sirenum__Site__c = site.Id;
                 spleacement.sirenum__Status__c   = 'Active';
                 spleacement.IP_PayMethod__c = payprofile.id;
                 spleacement.IP_Consultant1PercentageSplit__c=100;
                 spleacement.IP_Consultant1LookupSplitShare__c = UserInfo.getUserId();
         spleacement.sirenum__Rota__c = sector.id;
                 insert spleacement;
        
        system.debug('Start Date3 '+spleacement.sirenum__Start_Date__c);
        system.debug('End Date3 '+spleacement.sirenum__End_Date__c);
        system.debug('ContactEmailoptout3 '+spleacement.sirenum__Contact__r.HasOptedOutOfEmail);
      
        system.debug('ContactEmail '+con.Email);
        system.debug('ContactStatus '+con.Person_Status__c);
        
        sirenum__Shift__c shft = TestDataFactory.createShift(spleacement.id, site.id,1)[0];
   shft.sirenum__Scheduled_Start_Time__c = system.today();
        shft.sirenum__Scheduled_End_Time__c =  system.today();
        shft.sirenum__Cancelled__c = FALSE;
        shft.sirenum__Contact__c = con.id;
        shft.sirenum__Team__c = jobroll.id;
        shft.sirenum__Placement__c = spleacement.id;
        insert shft; 

        system.debug('**Shift created 3**'+shft);
          Test.startTest();
      update shft;
          ApexPages.StandardController sc = new ApexPages.StandardController(spleacement);
        
        
       timeextension tm = new timeextension(sc);
       PageReference pageRef = Page.TimesheetDesign;
        pageRef.getParameters().put('id', String.valueOf(spleacement.Id));
        Test.setCurrentPage(pageRef);
        manualtimesheetbatch manualtime = new manualtimesheetbatch();
        manualtime.sendMail = True;
          Database.executeBatch(manualtime,1);
        Test.stopTest();
        }
    }
}