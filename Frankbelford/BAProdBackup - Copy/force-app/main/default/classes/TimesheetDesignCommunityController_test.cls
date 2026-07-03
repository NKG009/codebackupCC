@istest
  public class TimesheetDesignCommunityController_test{

  public static testmethod void timeextension1(){
   insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
  Account acc =  TestDataFactory.createCandidateAccount(1)[0];
  insert acc;
  Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
  insert con;
      
           RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;

  sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
    pc.Name = 'Saturday - Friday';
    pc.sirenum__CyclePeriodUnits__c= 'Weeks';
    pc.sirenum__periodLength__c = decimal.valueof(7);
    pc.sirenum__StartingDate__c = Date.newInstance(2017, 11, 18);  
    insert pc;
    
  sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
    ct.sirenum__PayrollCycle__c = pc.id;
  insert ct;

  sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
  insert sec;
  
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

  sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
  insert jobcate;

  sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
  insert job;

  Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
  User u = TestDataFactory.createUsers(p.id,1)[0];
  u.IP_TempestDepartment__c = '1208'; insert u;

  sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
    ps.Payroll_Week__c = '47';
    ps.Payroll_Year__c = '2017';
    ps.sirenum__Site__c = site.id;
  insert ps;
    
  test.startTest();
      
  //geReference pageRef = Page.TimesheetDesignCommunity;
  PageReference pageref = new Pagereference('/apex/TimesheetDesignCommunity');
  pageRef.getParameters().put('id', String.valueOf(ps.Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(ps);
  TimesheetDesignCommunityController testextension = new TimesheetDesignCommunityController(sc);  
  test.stoptest();
  }
    public static testmethod void timeextension2(){
 insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
  Account acc =  TestDataFactory.createCandidateAccount(1)[0];
  insert acc;
  Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
  insert con;
  
       RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;

      sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
    pc.Name = 'Saturday - Friday';
    pc.sirenum__CyclePeriodUnits__c= 'Weeks';
    pc.sirenum__periodLength__c = decimal.valueof(7);
    pc.sirenum__StartingDate__c = Date.newInstance(2017, 10, 17);  
    insert pc;

  sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
      ct.sirenum__PayrollCycle__c = pc.id;
  insert ct;

  sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
  insert sec;
  
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


  sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
  insert jobcate;

  sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
  insert job;

  Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
  User u = TestDataFactory.createUsers(p.id,1)[0];
  u.IP_TempestDepartment__c = '1208'; insert u;

  sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
    ps.Payroll_Week__c = '50';
    ps.Payroll_Year__c = '2018';
      ps.sirenum__Site__c = site.id;
  insert ps;

  test.startTest();
      
  //geReference pageRef = Page.TimesheetDesignCommunity;
  PageReference pageref = new Pagereference('/apex/TimesheetDesignCommunity');
  pageRef.getParameters().put('id', String.valueOf(ps.Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(ps);
  TimesheetDesignCommunityController testextension = new TimesheetDesignCommunityController(sc);  
  test.stoptest();
  }

  public static testmethod void timeextension3(){
 insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);

  Account acc =  TestDataFactory.createCandidateAccount(1)[0];
  insert acc;
  Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
  insert con;
  
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;

  sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
    pc.Name = 'Monday to Sunday';
    pc.sirenum__CyclePeriodUnits__c= 'Weeks';
    pc.sirenum__periodLength__c = decimal.valueof(7);
    pc.sirenum__StartingDate__c = Date.newInstance(2021, 08, 12);  
    insert pc;
    
  sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
  ct.sirenum__PayrollCycle__c = pc.id;
  insert ct;

  sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
  insert sec;
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
  sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
  insert jobcate;

  sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
  insert job;

  Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
  User u = TestDataFactory.createUsers(p.id,1)[0];
  u.IP_TempestDepartment__c = '1208'; insert u;

  sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
    ps.Payroll_Week__c = '40';
    ps.Payroll_Year__c = '2021';
  ps.sirenum__Site__c = site.id; insert ps;

  test.startTest();
      
  //geReference pageRef = Page.TimesheetDesignCommunity;
  PageReference pageref = new Pagereference('/apex/TimesheetDesignCommunity');
  pageRef.getParameters().put('id', String.valueOf(ps.Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(ps);
  TimesheetDesignCommunityController testextension = new TimesheetDesignCommunityController(sc);  
  test.stoptest();
  }
  public static testmethod void timeextension4(){
 insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
  Account acc =  TestDataFactory.createCandidateAccount(1)[0];
  insert acc;
  Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
  insert con;

  
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;
  sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
    pc.Name = 'Monday to Sunday';
    pc.sirenum__CyclePeriodUnits__c= 'Weeks';
    pc.sirenum__periodLength__c = decimal.valueof(7);
    pc.sirenum__StartingDate__c = Date.newInstance(2017, 12, 04);  
    insert pc;
    
  sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
  ct.sirenum__PayrollCycle__c = pc.id;
  insert ct;

  sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
  insert sec;
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

  sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
  insert jobcate;

  sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
  insert job;

  Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
  User u = TestDataFactory.createUsers(p.id,1)[0];
  u.IP_TempestDepartment__c = '1208'; insert u;

  sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
    ps.Payroll_Week__c = '49';
    ps.Payroll_Year__c = '2017';
  ps.sirenum__Site__c = site.id; insert ps;

  test.startTest();
      
  //geReference pageRef = Page.TimesheetDesignCommunity;
  PageReference pageref = new Pagereference('/apex/TimesheetDesignCommunity');
  pageRef.getParameters().put('id', String.valueOf(ps.Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(ps);
  TimesheetDesignCommunityController testextension = new TimesheetDesignCommunityController(sc);  
  test.stoptest();
  }
  public static testmethod void timeextension5(){
 insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
  Account acc =  TestDataFactory.createCandidateAccount(1)[0];
  insert acc;
  Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
  insert con;
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;

  sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
    pc.Name = 'Sunday to Saturday';
    pc.sirenum__CyclePeriodUnits__c= 'Weeks';
    pc.sirenum__periodLength__c = decimal.valueof(7);
    pc.sirenum__StartingDate__c = Date.newInstance(2018, 01, 14);  
    insert pc;
    
  sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
  ct.sirenum__PayrollCycle__c = pc.id;
  insert ct;

  sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
  insert sec;
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

  sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
  insert jobcate;

  sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
  insert job;

  Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
  User u = TestDataFactory.createUsers(p.id,1)[0];
  u.IP_TempestDepartment__c = '1208'; insert u;

  sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
    ps.Payroll_Week__c = '20';
    ps.Payroll_Year__c = '2017';
  ps.sirenum__Site__c = site.id; insert ps;

  test.startTest();
      
  //geReference pageRef = Page.TimesheetDesignCommunity;
  PageReference pageref = new Pagereference('/apex/TimesheetDesignCommunity');
  pageRef.getParameters().put('id', String.valueOf(ps.Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(ps);
  TimesheetDesignCommunityController testextension = new TimesheetDesignCommunityController(sc);  
  test.stoptest();
  }
  public static testmethod void timeextension6(){
 insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
  Account acc =  TestDataFactory.createCandidateAccount(1)[0];
  insert acc;
  Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
  insert con;

    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;
  
  sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
    pc.Name = 'Saturday - Friday';
    pc.sirenum__CyclePeriodUnits__c= 'Weeks';
    pc.sirenum__periodLength__c = decimal.valueof(7);
    pc.sirenum__StartingDate__c = Date.newInstance(2018, 11, 30);  
    insert pc;
    
  sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
  ct.sirenum__PayrollCycle__c = pc.id;
  insert ct;

  sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
  insert sec;
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

  sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
  insert jobcate;

  sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
  insert job;

  Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
  User u = TestDataFactory.createUsers(p.id,1)[0];
  u.IP_TempestDepartment__c = '1208'; insert u;

  sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
    ps.Payroll_Week__c = '19';
    ps.Payroll_Year__c = '2017';
  ps.sirenum__Site__c = site.id; insert ps;

  test.startTest();
      
  //geReference pageRef = Page.TimesheetDesignCommunity;
  PageReference pageref = new Pagereference('/apex/TimesheetDesignCommunity');
  pageRef.getParameters().put('id', String.valueOf(ps.Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(ps);
  TimesheetDesignCommunityController testextension = new TimesheetDesignCommunityController(sc);  
  test.stoptest();
  }
  
  public static testmethod void timeextension7(){
 insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
  Account acc =  TestDataFactory.createCandidateAccount(1)[0];
  insert acc;
  Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
  insert con;
  
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;

  sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
    pc.Name = 'Monday to Sunday';
    pc.sirenum__CyclePeriodUnits__c= 'Weeks';
    pc.sirenum__periodLength__c = decimal.valueof(7);
    pc.sirenum__StartingDate__c = Date.newInstance(2021, 08, 11);  
    insert pc;
    
  sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
  ct.sirenum__PayrollCycle__c = pc.id;
  insert ct;

  sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
  insert sec;
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

  sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
  insert jobcate;

  sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
  insert job;

  Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
  User u = TestDataFactory.createUsers(p.id,1)[0];
  u.IP_TempestDepartment__c = '1208'; insert u;

  sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
    ps.Payroll_Week__c = '40';
    ps.Payroll_Year__c = '2017';
  ps.sirenum__Site__c = site.id; insert ps;

  test.startTest();
      
  //geReference pageRef = Page.TimesheetDesignCommunity;
  PageReference pageref = new Pagereference('/apex/TimesheetDesignCommunity');
  pageRef.getParameters().put('id', String.valueOf(ps.Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(ps);
  TimesheetDesignCommunityController testextension = new TimesheetDesignCommunityController(sc);  
  test.stoptest();
  }
        public static testmethod void timeextension8(){
 insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
  Account acc =  TestDataFactory.createCandidateAccount(1)[0];
  insert acc;
  Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
  insert con;
  
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;

  sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
    pc.Name = 'Monday to Sunday';
    pc.sirenum__CyclePeriodUnits__c= 'Weeks';
    pc.sirenum__periodLength__c = decimal.valueof(7);
    pc.sirenum__StartingDate__c = Date.newInstance(2018, 09, 11);  
    insert pc;
    
  sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
  ct.sirenum__PayrollCycle__c = pc.id;
  insert ct;

  sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
  insert sec;
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

  sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
  insert jobcate;

  sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
  insert job;

  Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
  User u = TestDataFactory.createUsers(p.id,1)[0];
  u.IP_TempestDepartment__c = '1208'; insert u;

  sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
    ps.Payroll_Week__c = '40';
    ps.Payroll_Year__c = '2030';
  ps.sirenum__Site__c = site.id; insert ps;

  test.startTest();
      
  //geReference pageRef = Page.TimesheetDesignCommunity;
  PageReference pageref = new Pagereference('/apex/TimesheetDesignCommunity');
  pageRef.getParameters().put('id', String.valueOf(ps.Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(ps);
  TimesheetDesignCommunityController testextension = new TimesheetDesignCommunityController(sc);  
  test.stoptest();
  }
  public static testmethod void timeextension9(){
 insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
  Account acc =  TestDataFactory.createCandidateAccount(1)[0];
  insert acc;
  Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
  insert con;
  
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;

  sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
    pc.Name = 'Monday to Sunday';
    pc.sirenum__CyclePeriodUnits__c= 'Weeks';
    pc.sirenum__periodLength__c = decimal.valueof(7);
    pc.sirenum__StartingDate__c = Date.newInstance(2020, 09, 10);  
    insert pc;
    
  sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
  ct.sirenum__PayrollCycle__c = pc.id;
  insert ct;

  sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
  insert sec;
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

  sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
  insert jobcate;

  sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
  insert job;

  Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
  User u = TestDataFactory.createUsers(p.id,1)[0];
  u.IP_TempestDepartment__c = '1208'; insert u;

  sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
    ps.Payroll_Week__c = '40';
    ps.Payroll_Year__c = '2020';
  ps.sirenum__Site__c = site.id; insert ps;

  test.startTest();
      
  //geReference pageRef = Page.TimesheetDesignCommunity;
  PageReference pageref = new Pagereference('/apex/TimesheetDesignCommunity');
  pageRef.getParameters().put('id', String.valueOf(ps.Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(ps);
  TimesheetDesignCommunityController testextension = new TimesheetDesignCommunityController(sc);  
  test.stoptest();
  }
  public static testmethod void timeextension10(){
 insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
  Account acc =  TestDataFactory.createCandidateAccount(1)[0];
  insert acc;
  Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
  insert con;
  
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;

  sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
    pc.Name = 'Monday to Sunday';
    pc.sirenum__CyclePeriodUnits__c= 'Weeks';
    pc.sirenum__periodLength__c = decimal.valueof(7);
    pc.sirenum__StartingDate__c = Date.newInstance(2023, 12, 10);  
    insert pc;
    
  sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
  ct.sirenum__PayrollCycle__c = pc.id;
  insert ct;

  sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
  insert sec;
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

  sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
  insert jobcate;

  sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
  insert job;

  Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
  User u = TestDataFactory.createUsers(p.id,1)[0];
  u.IP_TempestDepartment__c = '1208'; insert u;

  sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
    ps.Payroll_Week__c = '40';
    ps.Payroll_Year__c = '2023';
  ps.sirenum__Site__c = site.id; insert ps;

  test.startTest();
      
  //geReference pageRef = Page.TimesheetDesignCommunity;
  PageReference pageref = new Pagereference('/apex/TimesheetDesignCommunity');
  pageRef.getParameters().put('id', String.valueOf(ps.Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(ps);
  TimesheetDesignCommunityController testextension = new TimesheetDesignCommunityController(sc);  
  test.stoptest();
  }
  public static testmethod void timeextension11(){
 insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
  Account acc =  TestDataFactory.createCandidateAccount(1)[0];
  insert acc;
  Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
  insert con;
  
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;

  sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
    pc.Name = 'Saturday - Friday';
    pc.sirenum__CyclePeriodUnits__c= 'Weeks';
    pc.sirenum__periodLength__c = decimal.valueof(7);
    pc.sirenum__StartingDate__c = Date.newInstance(2024, 12, 31);  
    insert pc;
    
  sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
  ct.sirenum__PayrollCycle__c = pc.id;
  insert ct;

  sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
  insert sec;
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

  sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
  insert jobcate;

  sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
  insert job;

  Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
  User u = TestDataFactory.createUsers(p.id,1)[0];
  u.IP_TempestDepartment__c = '1208'; insert u;

  sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
    ps.Payroll_Week__c = '40';
    ps.Payroll_Year__c = '2025';
  ps.sirenum__Site__c = site.id; insert ps;

  test.startTest();
      
  //geReference pageRef = Page.TimesheetDesignCommunity;
  PageReference pageref = new Pagereference('/apex/TimesheetDesignCommunity');
  pageRef.getParameters().put('id', String.valueOf(ps.Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(ps);
  TimesheetDesignCommunityController testextension = new TimesheetDesignCommunityController(sc);  
  test.stoptest();
  }
  public static testmethod void timeextension12(){
 insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
  Account acc =  TestDataFactory.createCandidateAccount(1)[0];
  insert acc;
  Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
  insert con;
  
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;

  sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
    pc.Name = 'Saturday - Friday';
    pc.sirenum__CyclePeriodUnits__c= 'Weeks';
    pc.sirenum__periodLength__c = decimal.valueof(7);
    pc.sirenum__StartingDate__c = Date.newInstance(2037, 01, 01);  
    insert pc;
    
  sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
  ct.sirenum__PayrollCycle__c = pc.id;
  insert ct;

  sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
  insert sec;
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

  sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
  insert jobcate;

  sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
  insert job;

  Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
  User u = TestDataFactory.createUsers(p.id,1)[0];
  u.IP_TempestDepartment__c = '1208'; insert u;

  sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
    ps.Payroll_Week__c = '4';
    ps.Payroll_Year__c = '2037';
  ps.sirenum__Site__c = site.id; insert ps;

  test.startTest();
      
  //geReference pageRef = Page.TimesheetDesignCommunity;
  PageReference pageref = new Pagereference('/apex/TimesheetDesignCommunity');
  pageRef.getParameters().put('id', String.valueOf(ps.Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(ps);
  TimesheetDesignCommunityController testextension = new TimesheetDesignCommunityController(sc);  
  test.stoptest();
  }
  public static testmethod void timeextension13(){
 insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
  Account acc =  TestDataFactory.createCandidateAccount(1)[0];
  insert acc;
  Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
  insert con;
  
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;

  sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
    pc.Name = 'Saturday - Friday';
    pc.sirenum__CyclePeriodUnits__c= 'Weeks';
    pc.sirenum__periodLength__c = decimal.valueof(7);
    pc.sirenum__StartingDate__c = Date.newInstance(2033, 01, 01);  
    insert pc;
    
  sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
  ct.sirenum__PayrollCycle__c = pc.id;
  insert ct;

  sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
  insert sec;
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

  sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
  insert jobcate;

  sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
  insert job;

  Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
  User u = TestDataFactory.createUsers(p.id,1)[0];
  u.IP_TempestDepartment__c = '1208'; insert u;

  sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
    ps.Payroll_Week__c = '8';
    ps.Payroll_Year__c = '2033';
  ps.sirenum__Site__c = site.id; insert ps;

  test.startTest();
      
  //geReference pageRef = Page.TimesheetDesignCommunity;
  PageReference pageref = new Pagereference('/apex/TimesheetDesignCommunity');
  pageRef.getParameters().put('id', String.valueOf(ps.Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(ps);
  TimesheetDesignCommunityController testextension = new TimesheetDesignCommunityController(sc);  
  test.stoptest();
  }
  public static testmethod void timeextension14(){
 insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
  Account acc =  TestDataFactory.createCandidateAccount(1)[0];
  insert acc;
  Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
  insert con;
  
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;

  sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
    pc.Name = 'Saturday - Friday';
    pc.sirenum__CyclePeriodUnits__c= 'Weeks';
    pc.sirenum__periodLength__c = decimal.valueof(7);
    pc.sirenum__StartingDate__c = Date.newInstance(2031, 12, 01);  
    insert pc;
    
  sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
  ct.sirenum__PayrollCycle__c = pc.id;
  insert ct;

  sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
  insert sec;
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

  sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
  insert jobcate;

  sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
  insert job;

  Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
  User u = TestDataFactory.createUsers(p.id,1)[0];
  u.IP_TempestDepartment__c = '1208'; insert u;

  sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
    ps.Payroll_Week__c = '45';
    ps.Payroll_Year__c = '2031';
  ps.sirenum__Site__c = site.id; insert ps;

  test.startTest();
      
  //geReference pageRef = Page.TimesheetDesignCommunity;
  PageReference pageref = new Pagereference('/apex/TimesheetDesignCommunity');
  pageRef.getParameters().put('id', String.valueOf(ps.Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(ps);
  TimesheetDesignCommunityController testextension = new TimesheetDesignCommunityController(sc);  
  test.stoptest();
  }
  public static testmethod void timeextension15(){
 insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
  Account acc =  TestDataFactory.createCandidateAccount(1)[0];
  insert acc;
  Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
  insert con;
  
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;

  sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
    pc.Name = 'Saturday - Friday';
    pc.sirenum__CyclePeriodUnits__c= 'Weeks';
    pc.sirenum__periodLength__c = decimal.valueof(7);
    pc.sirenum__StartingDate__c = Date.newInstance(2032, 12, 01);  
    insert pc;
    
  sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
  ct.sirenum__PayrollCycle__c = pc.id;
  insert ct;

  sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
  insert sec;
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

  sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
  insert jobcate;

  sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
  insert job;

  Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
  User u = TestDataFactory.createUsers(p.id,1)[0];
  u.IP_TempestDepartment__c = '1208'; insert u;

  sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
    ps.Payroll_Week__c = '48';
    ps.Payroll_Year__c = '2032';
  ps.sirenum__Site__c = site.id; insert ps;

  test.startTest();
      
  //geReference pageRef = Page.TimesheetDesignCommunity;
  PageReference pageref = new Pagereference('/apex/TimesheetDesignCommunity');
  pageRef.getParameters().put('id', String.valueOf(ps.Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(ps);
  TimesheetDesignCommunityController testextension = new TimesheetDesignCommunityController(sc);  
  test.stoptest();
  }
  public static testmethod void timeextension16(){
 insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
  Account acc =  TestDataFactory.createCandidateAccount(1)[0];
  insert acc;
  Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
  insert con;
  
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;

  sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
    pc.Name = 'Saturday - Friday';
    pc.sirenum__CyclePeriodUnits__c= 'Weeks';
    pc.sirenum__periodLength__c = decimal.valueof(7);
    pc.sirenum__StartingDate__c = Date.newInstance(2019, 12, 01);  
    insert pc;
    
  sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
  ct.sirenum__PayrollCycle__c = pc.id;
  insert ct;

  sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
  insert sec;
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

  sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
  insert jobcate;

  sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
  insert job;

  Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
  User u = TestDataFactory.createUsers(p.id,1)[0];
  u.IP_TempestDepartment__c = '1208'; insert u;

  sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
    ps.Payroll_Week__c = '40';
    ps.Payroll_Year__c = '2019';
  ps.sirenum__Site__c = site.id; insert ps;

  test.startTest();
      
  //geReference pageRef = Page.TimesheetDesignCommunity;
  PageReference pageref = new Pagereference('/apex/TimesheetDesignCommunity');
  pageRef.getParameters().put('id', String.valueOf(ps.Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(ps);
  TimesheetDesignCommunityController testextension = new TimesheetDesignCommunityController(sc);  
  test.stoptest();
  }
  public static testmethod void timeextension17(){
 insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
  Account acc =  TestDataFactory.createCandidateAccount(1)[0];
  insert acc;
  Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
  insert con;
  
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;

  sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
    pc.Name = 'Saturday - Friday';
    pc.sirenum__CyclePeriodUnits__c= 'Weeks';
    pc.sirenum__periodLength__c = decimal.valueof(7);
    pc.sirenum__StartingDate__c = Date.newInstance(2036, 03, 15);  
    insert pc;
    
  sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
  ct.sirenum__PayrollCycle__c = pc.id;
  insert ct;

  sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
  insert sec;
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
  sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
  insert jobcate;

  sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
  insert job;

  Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
  User u = TestDataFactory.createUsers(p.id,1)[0];
  u.IP_TempestDepartment__c = '1208'; insert u;

  sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
    ps.Payroll_Week__c = '10';
    ps.Payroll_Year__c = '2036';
  ps.sirenum__Site__c = site.id; insert ps;

  test.startTest();
      
  //geReference pageRef = Page.TimesheetDesignCommunity;
  PageReference pageref = new Pagereference('/apex/TimesheetDesignCommunity');
  pageRef.getParameters().put('id', String.valueOf(ps.Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(ps);
  TimesheetDesignCommunityController testextension = new TimesheetDesignCommunityController(sc);  
  test.stoptest();
  }
  public static testmethod void timeextension18(){
 insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
  Account acc =  TestDataFactory.createCandidateAccount(1)[0];
  insert acc;
  Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
  insert con;
  
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;

  sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
    pc.Name = 'Saturday - Friday';
    pc.sirenum__CyclePeriodUnits__c= 'Weeks';
    pc.sirenum__periodLength__c = decimal.valueof(7);
    pc.sirenum__StartingDate__c = Date.newInstance(2019, 10, 31);  
    insert pc;
    
  sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
  ct.sirenum__PayrollCycle__c = pc.id;
  insert ct;

  sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
  insert sec;
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

  sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
  insert jobcate;

  sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
  insert job;

  Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
  User u = TestDataFactory.createUsers(p.id,1)[0];
  u.IP_TempestDepartment__c = '1208'; insert u;

  sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
    ps.Payroll_Week__c = '28';
    ps.Payroll_Year__c = '2019';
  ps.sirenum__Site__c = site.id; insert ps;

  test.startTest();
      
  //geReference pageRef = Page.TimesheetDesignCommunity;
  PageReference pageref = new Pagereference('/apex/TimesheetDesignCommunity');
  pageRef.getParameters().put('id', String.valueOf(ps.Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(ps);
  TimesheetDesignCommunityController testextension = new TimesheetDesignCommunityController(sc);  
  test.stoptest();
  }
  public static testmethod void timeextension19(){
 insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
  Account acc =  TestDataFactory.createCandidateAccount(1)[0];
  insert acc;
  Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
  insert con;
  
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;

  sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
    pc.Name = 'Saturday - Friday';
    pc.sirenum__CyclePeriodUnits__c= 'Weeks';
    pc.sirenum__periodLength__c = decimal.valueof(7);
    pc.sirenum__StartingDate__c = Date.newInstance(2034, 08,26);  
    insert pc;
    
  sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
  ct.sirenum__PayrollCycle__c = pc.id;
  insert ct;

  sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
  insert sec;
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

  sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
  insert jobcate;

  sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
  insert job;

  Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
  User u = TestDataFactory.createUsers(p.id,1)[0];
  u.IP_TempestDepartment__c = '1208'; insert u;

  sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
    ps.Payroll_Week__c = '38';
    ps.Payroll_Year__c = '2029';
  ps.sirenum__Site__c = site.id; insert ps;
  test.startTest();
  PageReference pageref = new Pagereference('/apex/TimesheetDesignCommunity');
  pageRef.getParameters().put('id', String.valueOf(ps.Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(ps);
  TimesheetDesignCommunityController testextension = new TimesheetDesignCommunityController(sc);  
  test.stoptest();
  }
  public static testmethod void timeextension20(){
 insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
  Account acc =  TestDataFactory.createCandidateAccount(1)[0];
  insert acc;
  Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
  insert con;
  
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;

  sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
    pc.Name = 'Sunday to Saturday';
    pc.sirenum__CyclePeriodUnits__c= 'Weeks';
    pc.sirenum__periodLength__c = decimal.valueof(7);
    pc.sirenum__StartingDate__c = Date.newInstance(2022, 12, 20);  
    insert pc;
    
  sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
  ct.sirenum__PayrollCycle__c = pc.id;
  insert ct;

  sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
  insert sec;
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
  sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
  insert jobcate;

  sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
  insert job;

  Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
  User u = TestDataFactory.createUsers(p.id,1)[0];
  u.IP_TempestDepartment__c = '1208'; insert u;

  sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
    ps.Payroll_Week__c = '51';
    ps.Payroll_Year__c = '2022';
  ps.sirenum__Site__c = site.id; insert ps;

  test.startTest();
      
  //geReference pageRef = Page.TimesheetDesignCommunity;
  PageReference pageref = new Pagereference('/apex/TimesheetDesignCommunity');
  pageRef.getParameters().put('id', String.valueOf(ps.Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(ps);
  TimesheetDesignCommunityController testextension = new TimesheetDesignCommunityController(sc);  
  test.stoptest();
  }
  public static testmethod void timeextension21(){
 insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
  Account acc =  TestDataFactory.createCandidateAccount(1)[0];
  insert acc;
  Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
  insert con;
  
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;

  sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
    pc.Name = 'Sunday to Saturday';
    pc.sirenum__CyclePeriodUnits__c= 'Weeks';
    pc.sirenum__periodLength__c = decimal.valueof(7);
    pc.sirenum__StartingDate__c = Date.newInstance(2025, 05, 20);  
    insert pc;
    
  sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
  ct.sirenum__PayrollCycle__c = pc.id;
  insert ct;

  sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
  insert sec;
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

  sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
  insert jobcate;

  sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
  insert job;

  Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
  User u = TestDataFactory.createUsers(p.id,1)[0];
  u.IP_TempestDepartment__c = '1208'; insert u;

  sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
    ps.Payroll_Week__c = '30';
    ps.Payroll_Year__c = '2025';
  ps.sirenum__Site__c = site.id; insert ps;

  test.startTest();
      
  //geReference pageRef = Page.TimesheetDesignCommunity;
  PageReference pageref = new Pagereference('/apex/TimesheetDesignCommunity');
  pageRef.getParameters().put('id', String.valueOf(ps.Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(ps);
  TimesheetDesignCommunityController testextension = new TimesheetDesignCommunityController(sc);  
  test.stoptest();
  }
  public static testmethod void timeextension22(){
 insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
  Account acc =  TestDataFactory.createCandidateAccount(1)[0];
  insert acc;
  Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
  insert con;
  
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;

  sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
    pc.Name = 'Saturday - Friday';
    pc.sirenum__CyclePeriodUnits__c= 'Weeks';
    pc.sirenum__periodLength__c = decimal.valueof(7);
    pc.sirenum__StartingDate__c = Date.newInstance(2032, 06, 18);  
    insert pc;
    
  sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
  ct.sirenum__PayrollCycle__c = pc.id;
  insert ct;

  sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
  insert sec;
  
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

  sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
  insert jobcate;

  sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
  insert job;

  Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
  User u = TestDataFactory.createUsers(p.id,1)[0];
  u.IP_TempestDepartment__c = '1208'; insert u;

  sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
    ps.Payroll_Week__c = '19';
    ps.Payroll_Year__c = '2032';
  ps.sirenum__Site__c = site.id; insert ps;

  test.startTest();
  PageReference pageref = new Pagereference('/apex/TimesheetDesignCommunity');
  pageRef.getParameters().put('id', String.valueOf(ps.Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(ps);
  TimesheetDesignCommunityController testextension = new TimesheetDesignCommunityController(sc);  
  test.stoptest();
  }
  public static testmethod void timeextension23(){
 insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
  Account acc =  TestDataFactory.createCandidateAccount(1)[0];
  insert acc;
  Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
  insert con;
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;

  sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
    pc.Name = 'Sunday to Saturday';
    pc.sirenum__CyclePeriodUnits__c= 'Weeks';
    pc.sirenum__periodLength__c = decimal.valueof(7);
    pc.sirenum__StartingDate__c = Date.newInstance(2028, 07, 26);  
    insert pc;
    
  sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
  ct.sirenum__PayrollCycle__c = pc.id;
  insert ct;

  sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
  insert sec;
  
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

  sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
  insert jobcate;

  sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
  insert job;

  Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
  User u = TestDataFactory.createUsers(p.id,1)[0];
  u.IP_TempestDepartment__c = '1208'; insert u;

  sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
    ps.Payroll_Week__c = '35';
    ps.Payroll_Year__c = '2028';
  ps.sirenum__Site__c = site.id; insert ps;
  test.startTest();
  PageReference pageref = new Pagereference('/apex/TimesheetDesignCommunity');
  pageRef.getParameters().put('id', String.valueOf(ps.Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(ps);
  TimesheetDesignCommunityController testextension = new TimesheetDesignCommunityController(sc);  
  test.stoptest();
  }
  public static testmethod void timeextension24(){
 insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
  Account acc =  TestDataFactory.createCandidateAccount(1)[0];
  insert acc;
  Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
  insert con;
  
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;

  sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
    pc.Name = 'Sunday to Saturday';
    pc.sirenum__CyclePeriodUnits__c= 'Weeks';
    pc.sirenum__periodLength__c = decimal.valueof(7);
    pc.sirenum__StartingDate__c = Date.newInstance(2022, 09, 04);  
    insert pc;
    
  sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
  ct.sirenum__PayrollCycle__c = pc.id;
  insert ct;

  sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
  insert sec;
  
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

  sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
  insert jobcate;

  sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
  insert job;

  Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
  User u = TestDataFactory.createUsers(p.id,1)[0];
  u.IP_TempestDepartment__c = '1208'; insert u;

  sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
    ps.Payroll_Week__c = '42';
    ps.Payroll_Year__c = '2022';
  ps.sirenum__Site__c = site.id; insert ps;

  test.startTest();
      
  //geReference pageRef = Page.TimesheetDesignCommunity;
  PageReference pageref = new Pagereference('/apex/TimesheetDesignCommunity');
  pageRef.getParameters().put('id', String.valueOf(ps.Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(ps);
  TimesheetDesignCommunityController testextension = new TimesheetDesignCommunityController(sc);  
  test.stoptest();
  }
  public static testmethod void timeextension25(){
   insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
  Account acc =  TestDataFactory.createCandidateAccount(1)[0];
  insert acc;
  Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
  insert con;
  
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;
  
  sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
    pc.Name = 'Sunday to Saturday';
    pc.sirenum__CyclePeriodUnits__c= 'Weeks';
    pc.sirenum__periodLength__c = decimal.valueof(7);
    pc.sirenum__StartingDate__c = Date.newInstance(2037, 05, 12);  
    insert pc;
    
  sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
  ct.sirenum__PayrollCycle__c = pc.id;
  insert ct;

  sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
  insert sec;
  
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

  sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
  insert jobcate;

  sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
  insert job;

  Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
  User u = TestDataFactory.createUsers(p.id,1)[0];
  u.IP_TempestDepartment__c = '1208'; insert u;

  sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
    ps.Payroll_Week__c = '14';
    ps.Payroll_Year__c = '2037';
  ps.sirenum__Site__c = site.id; insert ps;
  test.startTest();
  PageReference pageref = new Pagereference('/apex/TimesheetDesignCommunity');
  pageRef.getParameters().put('id', String.valueOf(ps.Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(ps);
  TimesheetDesignCommunityController testextension = new TimesheetDesignCommunityController(sc);  
  test.stoptest();
  }
  public static testmethod void timeextension26(){
   insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
  Account acc =  TestDataFactory.createCandidateAccount(1)[0];
  insert acc;
  Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
  insert con;
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;
  
  sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
    pc.Name = 'Saturday - Friday';
    pc.sirenum__CyclePeriodUnits__c= 'Weeks';
    pc.sirenum__periodLength__c = decimal.valueof(7);
    pc.sirenum__StartingDate__c = Date.newInstance(2034, 08,27);  
    insert pc;
    
  sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
  ct.sirenum__PayrollCycle__c = pc.id;
  insert ct;

  sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
  insert sec;
  
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

  sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
  insert jobcate;

  sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
  insert job;

  Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
  User u = TestDataFactory.createUsers(p.id,1)[0];
  u.IP_TempestDepartment__c = '1208'; insert u;

  sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
    ps.Payroll_Week__c = '38';
    ps.Payroll_Year__c = '2029';
  ps.sirenum__Site__c = site.id; insert ps;
  test.startTest();
  PageReference pageref = new Pagereference('/apex/TimesheetDesignCommunity');
  pageRef.getParameters().put('id', String.valueOf(ps.Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(ps);
  TimesheetDesignCommunityController testextension = new TimesheetDesignCommunityController(sc);  
  test.stoptest();
  }
  public static testmethod void timeextension27(){
   insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
  Account acc =  TestDataFactory.createCandidateAccount(1)[0];
  insert acc;
  Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
  insert con;
  
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;
  
  sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
    pc.Name = 'Saturday - Friday';
    pc.sirenum__CyclePeriodUnits__c= 'Weeks';
    pc.sirenum__periodLength__c = decimal.valueof(7);
    pc.sirenum__StartingDate__c = Date.newInstance(2034, 08,28);  
    insert pc;
    
  sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
  ct.sirenum__PayrollCycle__c = pc.id;
  insert ct;

  sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
  insert sec;

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
         
  sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
  insert jobcate;

  sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
  insert job;

  Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
  User u = TestDataFactory.createUsers(p.id,1)[0];
  u.IP_TempestDepartment__c = '1208'; insert u;

  sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
    ps.Payroll_Week__c = '38';
    ps.Payroll_Year__c = '2029';
  ps.sirenum__Site__c = site.id; insert ps;
  test.startTest();
  PageReference pageref = new Pagereference('/apex/TimesheetDesignCommunity');
  pageRef.getParameters().put('id', String.valueOf(ps.Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(ps);
  TimesheetDesignCommunityController testextension = new TimesheetDesignCommunityController(sc);  
  test.stoptest();
  }
  public static testmethod void timeextension28(){
   insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
  Account acc =  TestDataFactory.createCandidateAccount(1)[0];
  insert acc;
  Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
  insert con;
  
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;
  
  sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
    pc.Name = 'Saturday - Friday';
    pc.sirenum__CyclePeriodUnits__c= 'Weeks';
    pc.sirenum__periodLength__c = decimal.valueof(7);
    pc.sirenum__StartingDate__c = Date.newInstance(2034, 08,30);  
    insert pc;
    
  sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
  ct.sirenum__PayrollCycle__c = pc.id;
  insert ct;

  sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
  insert sec;
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

  sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
  insert jobcate;

  sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
  insert job;

  Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
  User u = TestDataFactory.createUsers(p.id,1)[0];
  u.IP_TempestDepartment__c = '1208'; insert u;

  sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
    ps.Payroll_Week__c = '38';
    ps.Payroll_Year__c = '2029';
  ps.sirenum__Site__c = site.id; insert ps;
  test.startTest();
  PageReference pageref = new Pagereference('/apex/TimesheetDesignCommunity');
  pageRef.getParameters().put('id', String.valueOf(ps.Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(ps);
  TimesheetDesignCommunityController testextension = new TimesheetDesignCommunityController(sc);  
  test.stoptest();
  }
  public static testmethod void timeextension29(){
   insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
  Account acc =  TestDataFactory.createCandidateAccount(1)[0];
  insert acc;
  Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
  insert con;
  
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;
  
  sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
    pc.Name = 'Saturday - Friday';
    pc.sirenum__CyclePeriodUnits__c= 'Weeks';
    pc.sirenum__periodLength__c = decimal.valueof(7);
    pc.sirenum__StartingDate__c = Date.newInstance(2034, 08,31);  
    insert pc;
    
  sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
  ct.sirenum__PayrollCycle__c = pc.id;
  insert ct;

  sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
  insert sec;
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
         
  sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
  insert jobcate;

  sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
  insert job;

  Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
  User u = TestDataFactory.createUsers(p.id,1)[0];
  u.IP_TempestDepartment__c = '1208'; insert u;

  sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
    ps.Payroll_Week__c = '38';
    ps.Payroll_Year__c = '2029';
  ps.sirenum__Site__c = site.id; insert ps;
  test.startTest();
  PageReference pageref = new Pagereference('/apex/TimesheetDesignCommunity');
  pageRef.getParameters().put('id', String.valueOf(ps.Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(ps);
  TimesheetDesignCommunityController testextension = new TimesheetDesignCommunityController(sc);  
  test.stoptest();
  }
  public static testmethod void timeextension30(){
   insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
  Account acc =  TestDataFactory.createCandidateAccount(1)[0];
  insert acc;
  Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
  insert con;
  
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
          RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc1;
          Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
      
        insert maincon;
  
  sirenum__Payroll_Cycle__c pc = new sirenum__Payroll_Cycle__c();
    pc.Name = 'Saturday - Friday';
    pc.sirenum__CyclePeriodUnits__c= 'Weeks';
    pc.sirenum__periodLength__c = decimal.valueof(7);
    pc.sirenum__StartingDate__c = Date.newInstance(2034, 09,01);  
    insert pc;
    
  sirenum__ProActiveContract__c ct = TestDataFactory.sirenumProActiveContract(acc.id,con.id,1)[0];
  ct.sirenum__PayrollCycle__c = pc.id;
  insert ct;

  sirenum__Rota__c sec = TestDataFactory.createSector(1)[0];
  insert sec;
  
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

  sirenum__Job_Type__c jobcate = TestDataFactory.createJobType(sec.id,1)[0];
  insert jobcate;

  sirenum__Team__c job = TestDataFactory.createJobRole(ct.id,jobcate.id,1)[0];
  insert job;

  Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
  User u = TestDataFactory.createUsers(p.id,1)[0];
  u.IP_TempestDepartment__c = '1208'; insert u;

  sirenum__Placement__c ps = TestDataFactory.createSPlacement1(con.id, ct.id, job.id, u.id, 1)[0];
    ps.Payroll_Week__c = '38';
    ps.Payroll_Year__c = '2029';
  ps.sirenum__Site__c = site.id; insert ps;
  test.startTest();
  PageReference pageref = new Pagereference('/apex/TimesheetDesignCommunity');
  pageRef.getParameters().put('id', String.valueOf(ps.Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(ps);
  TimesheetDesignCommunityController testextension = new TimesheetDesignCommunityController(sc);  
  test.stoptest();
  }
  }