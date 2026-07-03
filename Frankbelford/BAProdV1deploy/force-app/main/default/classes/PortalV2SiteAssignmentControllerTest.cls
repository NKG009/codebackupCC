@IsTest
public with sharing class PortalV2SiteAssignmentControllerTest {
  @TestSetup
  static void setup() {
    Payroll_Swtich__c objCustomPayrol = new Payroll_Swtich__c();
    objCustomPayrol.Batch_check__c = false;
    objCustomPayrol.Name = 'Stoppayroll';
    insert objCustomPayrol;

    IP_JSToFrostSwtich__c FrostIntegration = new IP_JSToFrostSwtich__c(
      Name = 'JSToFrost',
      IP_RunJSToFrost__c = false
    );
    insert FrostIntegration;
    // insert new User_Profile_Id__c(
    //   Name = 'User Portal',
    //   Profile_Id__c = [SELECT Id FROM Profile WHERE Name = 'User Portal']
    //   .Id
    // );
  }

  @IsTest
  public static void GetSites() {
    insert new User_Profile_Id__c(
      Name = 'User Portal',
      Profile_Id__c = [SELECT Id FROM Profile WHERE Name = 'User Portal']
      .Id
    );

    /*
            Setup 
        */
    Account acc = new Account(Name = 'Test Account');
    insert acc;

    Account acc2 = new Account(Name = 'Test Account 2');
    insert acc2;

    sirenum__Site__c site = new sirenum__Site__c(
      Name = 'Test Site',
      sirenum__Operating_Company__c = acc.Id,
      IP_ClientInvoiceName__c = 'Test Account'
    );
    insert site;

    sirenum__Site__c site2 = new sirenum__Site__c(
      Name = 'Test Site 2',
      sirenum__Operating_Company__c = acc.Id,
      IP_ClientInvoiceName__c = 'Test Account'
    );
    insert site2;

    //Belongs to a different account
    sirenum__Site__c site3 = new sirenum__Site__c(
      Name = 'Test Site 3',
      sirenum__Operating_Company__c = acc2.Id,
      IP_ClientInvoiceName__c = 'Test Account'
    );
    insert site3;

    /*
            Execution
        */
    List<sirenum__Site__c> output = PortalV2SiteAssignmentController.getAccountSites(
      acc.Id
    );

    /*
            Assertions
        */
    System.assertEquals(2, output.size());
  }

  @IsTest
  public static void GetContacts() {
    /*
            Setup 
        */

    insert new User_Profile_Id__c(
      Name = 'User Portal',
      Profile_Id__c = [SELECT Id FROM Profile WHERE Name = 'User Portal']
      .Id
    );
    Account acc = new Account(Name = 'Test Account');
    insert acc;

    Account acc2 = new Account(Name = 'Test Account 2');
    insert acc2;

    Contact con1 = new Contact(
      FirstName = 'Test',
      LastName = 'Test',
      AccountId = acc.Id
    );
    insert con1;

    Contact con2 = new Contact(
      FirstName = 'Test',
      LastName = 'Test2',
      AccountId = acc.Id
    );
    insert con2;

    //Belongs to another account
    Contact con3 = new Contact(
      FirstName = 'Test',
      LastName = 'Test3',
      AccountId = acc2.Id
    );
    insert con3;

    /*
            Execution
        */
    List<Contact> output = PortalV2SiteAssignmentController.getAccountContacts(
      acc.Id
    );

    /*
            Assertions
        */
    System.assertEquals(2, output.size());
  }

  @IsTest
  public static void GetSiteAssignments() {
    /*
            Setup 
        */
    insert new User_Profile_Id__c(
      Name = 'User Portal',
      Profile_Id__c = [SELECT Id FROM Profile WHERE Name = 'User Portal']
      .Id
    );
    Account acc = new Account(Name = 'Test Account');
    insert acc;

    sirenum__Site__c site = new sirenum__Site__c(
      Name = 'Test Site',
      sirenum__Operating_Company__c = acc.Id,
      IP_ClientInvoiceName__c = 'Test Account'
    );
    insert site;

    sirenum__Site__c site2 = new sirenum__Site__c(
      Name = 'Test Site 2',
      sirenum__Operating_Company__c = acc.Id,
      IP_ClientInvoiceName__c = 'Test Account'
    );
    insert site2;

    Contact con1 = new Contact(
      FirstName = 'Test',
      LastName = 'Test',
      AccountId = acc.Id
    );
    insert con1;

    Contact con2 = new Contact(
      FirstName = 'Test',
      LastName = 'Test2',
      AccountId = acc.Id
    );
    insert con2;

    Contact_Site_link__c link = new Contact_Site_link__c(
      IP_Site__c = site.Id,
      IP_Contact__c = con1.Id,
      Account__c = acc.Id
    );
    insert link;
    /*
            Execution
        */
    List<Contact_Site_link__c> output1 = PortalV2SiteAssignmentController.getSiteAssignments(
      new List<Id>{ con1.Id }
    );
    List<Contact_Site_link__c> output2 = PortalV2SiteAssignmentController.getSiteAssignments(
      new List<Id>{ con2.Id }
    );

    /*
            Assertions
        */
    System.assertEquals(1, output1.size());
    System.assertEquals(0, output2.size());
  }

  @IsTest
  public static void GetTimesheetsWithPONumber() {
    /*
            Setup
        */
    insert new User_Profile_Id__c(
      Name = 'User Portal',
      Profile_Id__c = [SELECT Id FROM Profile WHERE Name = 'User Portal']
      .Id
    );
    Account client = TestDataFactory.createCandidateAccount(1)[0];
    insert client;

    Account act = TestDataFactory.createAccounts(1)[0];
    insert act;

    //insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);

    Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
    insert candidate;
    //  insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
    // id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('LTD').getRecordTypeId();
    IP_PayProfile__c payprofile = new IP_PayProfile__c();
    //  payprofile.RecordTypeId = payRTId;
    payprofile.IP_Candidate__c = candidate.id;
    payprofile.IP_CompanyName__c = 'sfdc';
    payprofile.IP_Status__c = 'Active';
    payprofile.IP_CompanyRegNo__c = 'ad123456';
    payprofile.IP_VATNumber__c = '123456789';
    payprofile.IP_PayrollID__c = 'testpay1';
    payprofile.IP_VATRegistered__c = true;
    payprofile.IP_OkToSupply__c = 1;
    payprofile.IP_BusinessAddressLine1__c = 'test address 1';
    payprofile.IP_BusinessAddressLine2__c = 'test address 2';
    payprofile.IP_BusinessAddressTown__c = 'town city';
    payprofile.IP_BusinessAddressPostcode__c = '12345678';
    payprofile.IP_PayFrequency__c = 'Weekly';
    payprofile.IP_PaymentType__c = 'BACS';
    //  payprofile.IP_PassToTempest__c=true;
    payprofile.IP_BankAccountName__c = 'Test name1';
    payprofile.IP_AccountNumber__c = '98567497';
    payprofile.IP_SortCode__c = '645362';
    insert payprofile;

    sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(
      act.Id,
      candidate.Id,
      1
    )[0];
    insert pac;

    sirenum__Rota__c sector = TestDataFactory.createSector(1)[0];
    insert sector;

    sirenum__Job_Type__c jobType = TestDataFactory.createJobType(
      sector.id,
      1
    )[0];
    insert jobType;

    sirenum__Team__c jrole = TestDataFactory.createJobRole(
      pac.Id,
      jobType.Id,
      1
    )[0];
    insert jrole;

    Profile p = [SELECT Id FROM Profile WHERE name = 'System Administrator'];
    User usr = TestDataFactory.createUsers(p.Id, 1)[0];
    usr.username = 'acfgd.test@test.com';
    insert usr;
    // IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0];
    // insert tpz;

    sirenum__Site__c ssite = TestDataFactory.createSites(act.id, null, 1)[0];
    insert ssite;

    sirenum__Placement__c splace = TestDataFactory.createSPlacement1(
      candidate.Id,
      pac.Id,
      jrole.Id,
      usr.Id,
      1
    )[0];
    splace.IP_PayMethod__c = payprofile.id;
    splace.sirenum__site__c = ssite.id;
    insert splace;

    sirenum__Shift__c shft = TestDataFactory.createShift(
      splace.id,
      ssite.id,
      1
    )[0];
    shft.sirenum__Contact__c = candidate.id;
    shft.sirenum__Team__c = jrole.id;
    insert shft;

    sirenum__Timesheet__c sts = TestDataFactory.createTimeSheet(
      client.id,
      candidate.Id,
      1
    )[0];
    sts.sirenum__Week_Ending__c = date.newInstance(2017, 12, 31);
    sts.IP_Client_Invoice_PO__c = '12345';
    insert sts;

    sirenum__Timesheet_Line__c stsl = TestDataFactory.createTimeSheetLine(
      sts.Id,
      shft.id,
      1
    )[0];
    insert stsl;

    /*
            Execution
        */
    List<sirenum__Timesheet__c> poNumberOutput = PortalV2SiteAssignmentController.getTimesheets(
      '12345',
      null
    );

    /*
            Assertions  
        */
    System.assertEquals(1, poNumberOutput.Size());
  }

  @IsTest
  public static void GetTimesheetsWithUnitId() {
    /*
            Setup
        */
    insert new User_Profile_Id__c(
      Name = 'User Portal',
      Profile_Id__c = [SELECT Id FROM Profile WHERE Name = 'User Portal']
      .Id
    );
    Account client = TestDataFactory.createCandidateAccount(1)[0];
    insert client;

    Account act = TestDataFactory.createAccounts(1)[0];
    insert act;

    //insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);

    Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
    insert candidate;
    //  insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
    // id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('LTD').getRecordTypeId();
    IP_PayProfile__c payprofile = new IP_PayProfile__c();
    //  payprofile.RecordTypeId = payRTId;
    payprofile.IP_Candidate__c = candidate.id;
    payprofile.IP_CompanyName__c = 'sfdc';
    payprofile.IP_Status__c = 'Active';
    payprofile.IP_CompanyRegNo__c = 'ad123456';
    payprofile.IP_VATNumber__c = '123456789';
    payprofile.IP_PayrollID__c = 'testpay1';
    payprofile.IP_VATRegistered__c = true;
    payprofile.IP_OkToSupply__c = 1;
    payprofile.IP_BusinessAddressLine1__c = 'test address 1';
    payprofile.IP_BusinessAddressLine2__c = 'test address 2';
    payprofile.IP_BusinessAddressTown__c = 'town city';
    payprofile.IP_BusinessAddressPostcode__c = '12345678';
    payprofile.IP_PayFrequency__c = 'Weekly';
    payprofile.IP_PaymentType__c = 'BACS';
    //  payprofile.IP_PassToTempest__c=true;
    payprofile.IP_BankAccountName__c = 'Test name1';
    payprofile.IP_AccountNumber__c = '98567497';
    payprofile.IP_SortCode__c = '645362';
    insert payprofile;

    sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(
      act.Id,
      candidate.Id,
      1
    )[0];
    insert pac;

    sirenum__Rota__c sector = TestDataFactory.createSector(1)[0];
    insert sector;

    sirenum__Job_Type__c jobType = TestDataFactory.createJobType(
      sector.id,
      1
    )[0];
    insert jobType;

    sirenum__Team__c jrole = TestDataFactory.createJobRole(
      pac.Id,
      jobType.Id,
      1
    )[0];
    insert jrole;

    Profile p = [SELECT Id FROM Profile WHERE name = 'System Administrator'];
    User usr = TestDataFactory.createUsers(p.Id, 1)[0];
    usr.username = 'acfgd.test@test.com';
    insert usr;
    // IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0];
    // insert tpz;

    sirenum__Site__c ssite = TestDataFactory.createSites(act.id, null, 1)[0];
    ssite.Unit_Id__c = '12345';
    insert ssite;

    sirenum__Placement__c splace = TestDataFactory.createSPlacement1(
      candidate.Id,
      pac.Id,
      jrole.Id,
      usr.Id,
      1
    )[0];
    splace.IP_PayMethod__c = payprofile.id;
    splace.sirenum__site__c = ssite.id;
    insert splace;

    sirenum__Shift__c shft = TestDataFactory.createShift(
      splace.id,
      ssite.id,
      1
    )[0];
    shft.sirenum__Contact__c = candidate.id;
    shft.sirenum__Team__c = jrole.id;
    insert shft;

    sirenum__Timesheet__c sts = TestDataFactory.createTimeSheet(
      client.id,
      candidate.Id,
      1
    )[0];
    sts.sirenum__Site__c = ssite.id;
    sts.sirenum__Week_Ending__c = date.newInstance(2017, 12, 31);

    insert sts;

    sirenum__Timesheet_Line__c stsl = TestDataFactory.createTimeSheetLine(
      sts.Id,
      shft.id,
      1
    )[0];
    insert stsl;

    /*
            Execution
        */
    List<sirenum__Timesheet__c> poNumberOutput = PortalV2SiteAssignmentController.getTimesheets(
      null,
      '12345'
    );

    /*
            Assertions  
        */
    System.assertEquals(1, poNumberOutput.Size());
  }
}