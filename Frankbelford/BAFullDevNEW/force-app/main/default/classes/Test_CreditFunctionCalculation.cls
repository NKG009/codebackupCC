@istest
public class Test_CreditFunctionCalculation {
public static testmethod void pdfgenerate1(){

    Account client1 = TestDataFactory.createClients(1)[0];
    insert client1;
    
    Account candacc = TestDataFactory.createCandidateAccount(1)[0];
    insert candacc;
    
    Account acccon = TestDataFactory.createAccounts(1)[0];
    insert acccon;
    
            insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

    Contact candidateid = TestDataFactory.createCandidate(candacc.id,1)[0];
    insert candidateid;
    
            insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

    Contact con = TestDataFactory.createContact(acccon.id,1)[0];
     //con.IP_ContactType__c = 'Invoice Contact';
    insert con;
    
    Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
  /*  User u = TestDataFactory.createUsers(p.id, 1)[0];
    u.username = 'Test.espiredev3@test.com';
     u.IP_TempestDepartment__c = '1062';
      u.IP_TempestDivision__c = 'NTS';
      u.IP_TempestID__c = '1234567';
    insert u;*/
    
    IP_TopazGlobalClientInformation__c topaz = TestDataFactory.createTopaz(1)[0];
    topaz.IP_SalesLedgerNumber__c = '645628';
    insert topaz;
    
    sirenum__Site__c site1 = TestDataFactory.createSites(acccon.id,topaz.id,1)[0];
       site1.IP_ClientIDLegacy__c = '1234'; 
        site1.IP_ClientInvoiceName__c = 'Testname';
        site1.IP_InvoiceAddressStreet__c = 'street1';
        site1.IP_InvoiceContactText__c = 'Test Invoice Text';
        site1.IP_InvoiceAddressCity__c = 'city1';
        site1.IP_InvoiceAddressPostcode__c = '7554';
        site1.IP_PublicSector__c = 'No';
        site1.IP_MainContact__c = con.id;
        site1.IP_InvoiceContact__c = con.id;
         site1.IP_PassClientToTempest__c = false;
        site1.IP_PassClientAddressToTempest__c = false;
         site1.sirenum__Street_Address__c = 'abc';
        site1.sirenum__City__c = 'xyz';
    insert site1;
    System.debug('inserted site check1'+site1.Missing_Site_Details__c);
    
    TR1__Job__c job1 = new TR1__Job__c();
     RecordType perms = [Select Id From RecordType Where DeveloperName='Perm' and sObjectType='TR1__Job__c'];
    job1.Name = 'Test Job1';
    job1.IP_Fixed_Fee__c = 120;
    job1.TR1__Account__c = candacc.id;
    job1.TR1__Contact__c = candidateid.id;
    job1.s5m__Site__c = site1.id;
    job1.Recordtypeid = perms.id;
    insert job1;
    
    TR1__Closing_Report__c permplacement = TestDataFactory.createTs2Placement(acccon.id,candidateid.id,con.id,job1.id,site1.id,'Perm',1)[0];
      permplacement.Substatus__c = 'Rebate Period';
    permplacement.TR1__Job__r.TR1__Hiring_Manager__c = con.id;
    permplacement.Tr1__Salary__c = 100;
    permplacement.IP_FixedFeeValue__c = 120;
    permplacement.Filled_By__c = UserInfo.getUserId();
    permplacement.tr1__Start_Date__c= system.today();   
   // permplacement.IP_PercentageFee__c=10;
    permplacement.Filled_Pct__c=10;
    insert permplacement;
    test.startTest();
    ApexPages.StandardController sc = new ApexPages.StandardController(permplacement);               
    CreditFunctionCalc permgenerate = new CreditFunctionCalc(sc);
    List<SelectOption> selectedreason=permgenerate.allcreditreason;
    List<SelectOption> selectedcode = permgenerate.allcreditpercent;
    List<SelectOption> selectedleavingreason = permgenerate.allleavingreason;
    permgenerate.selectedcreditreason='Candidate did not start';
    permgenerate.selectedpercentage = '10%';
    permgenerate.setadminfee();
    permgenerate.calcrecord();
    permgenerate.saverecord(); 
    permgenerate.closepage();
   
test.stopTest();

}
    public static testmethod void pdfgenerate2(){

    Account client1 = TestDataFactory.createClients(1)[0];
    insert client1;
    
    Account candacc = TestDataFactory.createCandidateAccount(1)[0];
    insert candacc;
    
    Account acccon = TestDataFactory.createAccounts(1)[0];
    insert acccon;
    
            insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

    Contact candidateid = TestDataFactory.createCandidate(candacc.id,1)[0];
    insert candidateid;
    
            insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
    
    Contact con = TestDataFactory.createContact(acccon.id,1)[0];
      //  con.IP_ContactType__c = 'Invoice Contact';
    insert con;
    
    Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
    User u = TestDataFactory.createUsers(p.id, 1)[0];
    u.username = 'Test.espiredev332@test.com';
        u.IP_TempestDepartment__c = '1062';
        u.IP_TempestDivision__c = 'NTS';
    insert u;
    
    IP_TopazGlobalClientInformation__c topaz = TestDataFactory.createTopaz(1)[0];
        topaz.IP_SalesLedgerNumber__c = '645628';
    insert topaz;
    
    sirenum__Site__c site1 = TestDataFactory.createSites(acccon.id,topaz.id,1)[0];
       site1.IP_ClientIDLegacy__c = '1234'; 
        site1.IP_ClientInvoiceName__c = 'Testname';
        site1.IP_InvoiceAddressStreet__c = 'street1';
        site1.IP_InvoiceAddressCity__c = 'city1';
            site1.IP_InvoiceContactText__c = 'Test Invoice Text';
        site1.IP_InvoiceAddressPostcode__c = '7554';
        site1.IP_PublicSector__c = 'No';
        site1.IP_MainContact__c = con.id;
        site1.IP_InvoiceContact__c = con.id;
         site1.IP_PassClientToTempest__c = false;
        site1.IP_PassClientAddressToTempest__c = false;
         site1.sirenum__Street_Address__c = 'abc';
        site1.sirenum__City__c = 'xyz';
    insert site1;
     System.debug('inserted site check2'+site1.Missing_Site_Details__c);
    
    TR1__Job__c job1 = new TR1__Job__c();
     RecordType perms = [Select Id From RecordType Where DeveloperName='Perm' and sObjectType='TR1__Job__c'];
    job1.Name = 'Test Job12';
    job1.IP_Fixed_Fee__c = 120;
    job1.tr1__Account__c = candacc.id;
    job1.tr1__Contact__c = candidateid.id;
    job1.s5m__Site__c = site1.id;
    job1.Recordtypeid = perms.id;
    insert job1;
    
    TR1__Closing_Report__c permplacement = TestDataFactory.createTs2Placement(acccon.id,candidateid.id,con.id,job1.id,site1.id,'Perm',1)[0];
   permplacement.Substatus__c = 'Rebate Period';
    permplacement.tr1__job__r.tr1__Hiring_Manager__c = con.id;
    permplacement.tr1__Salary__c = 100;
    permplacement.IP_FixedFeeValue__c = 120;
    permplacement.Filled_By__c = UserInfo.getUserId();
    permplacement.tr1__Start_Date__c= system.today();   
    //permplacement.IP_PercentageFee__c=10;
    permplacement.Filled_Pct__c=10;
    insert permplacement;
    test.startTest();
    ApexPages.StandardController sc = new ApexPages.StandardController(permplacement);               
    CreditFunctionCalc permgenerate = new CreditFunctionCalc(sc);
    List<SelectOption> selectedreason=permgenerate.allcreditreason;
    List<SelectOption> selectedcode = permgenerate.allcreditpercent;
    List<SelectOption> selectedleavingreason = permgenerate.allleavingreason;
    permgenerate.setadminfee();
    permgenerate.calcrecord();
    permgenerate.saverecord(); 
    permgenerate.closepage();
   
test.stopTest();

}
     public static testmethod void pdfgenerate3(){

    Account client1 = TestDataFactory.createClients(1)[0];
    insert client1;
    
    Account candacc = TestDataFactory.createCandidateAccount(1)[0];
    insert candacc;
    
    Account acccon = TestDataFactory.createAccounts(1)[0];
    insert acccon;
    
            insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
    Contact candidateid = TestDataFactory.createCandidate(candacc.id,1)[0];
    insert candidateid;
    
            insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
    Contact con = TestDataFactory.createContact(acccon.id,1)[0];
          //  con.IP_ContactType__c = 'Invoice Contact';

    insert con;
    
    Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
    User u = TestDataFactory.createUsers(p.id, 1)[0];
    u.username = 'Test.espiredev332@test.com';
            u.IP_TempestDepartment__c = '1062';
             u.IP_TempestDivision__c = 'NTS';

    insert u;
    
    IP_TopazGlobalClientInformation__c topaz = TestDataFactory.createTopaz(1)[0];
   topaz.IP_SalesLedgerNumber__c = '645628';
    insert topaz;
    
    sirenum__Site__c site1 = TestDataFactory.createSites(acccon.id,topaz.id,1)[0];
       site1.IP_ClientIDLegacy__c = '1234'; 
        site1.IP_ClientInvoiceName__c = 'Testname';
        site1.IP_InvoiceAddressStreet__c = 'street1';
        site1.IP_InvoiceAddressCity__c = 'city1';
        site1.IP_InvoiceAddressPostcode__c = '7554';
        site1.IP_PublicSector__c = 'No';
        site1.IP_MainContact__c = con.id;
        site1.IP_InvoiceContact__c = con.id;
            site1.IP_InvoiceContactText__c = 'Test Invoice Text';
        site1.IP_PassClientToTempest__c = false;
        site1.IP_PassClientAddressToTempest__c = false;
        site1.sirenum__Street_Address__c = 'abc';
        site1.sirenum__City__c = 'xyz';
    insert site1;
     System.debug('inserted site check3'+site1.Missing_Site_Details__c);
    
    TR1__Job__c job1 = new TR1__Job__c();
     RecordType perms = [Select Id From RecordType Where DeveloperName='Perm' and sObjectType='TR1__Job__c'];
    job1.Name = 'Test Job12';
    job1.IP_Fixed_Fee__c = 120;
    job1.tr1__Account__c = candacc.id;
    job1.tr1__Contact__c = candidateid.id;
    job1.s5m__Site__c = site1.id;
    job1.Recordtypeid = perms.id;
    insert job1;
    
    TR1__Closing_Report__c permplacement = TestDataFactory.createTs2Placement(acccon.id,candidateid.id,con.id,job1.id,site1.id,'Perm',1)[0];
    permplacement.Substatus__c = 'Rebate Period';
    permplacement.tr1__Job__r.tr1__Hiring_Manager__c = con.id;
    permplacement.tr1__Salary__c = 100;
    permplacement.IP_FixedFeeValue__c = 120;
    permplacement.Filled_By__c = UserInfo.getUserId();
    permplacement.tr1__Start_Date__c= system.today();   
    //permplacement.IP_PercentageFee__c=10;
    permplacement.Filled_Pct__c=10;
    insert permplacement;
    system.debug('check placement created***'+permplacement.Missing_Details__c);
    test.startTest();
    ApexPages.StandardController sc = new ApexPages.StandardController(permplacement);               
    CreditFunctionCalc permgenerate = new CreditFunctionCalc(sc);
    List<SelectOption> selectedreason=permgenerate.allcreditreason;
    List<SelectOption> selectedcode = permgenerate.allcreditpercent;
    List<SelectOption> selectedleavingreason = permgenerate.allleavingreason;
    permgenerate.selectedcreditreason='Candidate did not start';
    permgenerate.selectedpercentage = 'Amount £';
    permgenerate.setadminfee();
    permgenerate.calcrecord();
    permgenerate.saverecord(); 
    permgenerate.closepage();
   
test.stopTest();

}
     public static testmethod void pdfgenerate4(){

    Account client1 = TestDataFactory.createClients(1)[0];
    insert client1;
    
    Account candacc = TestDataFactory.createCandidateAccount(1)[0];
    insert candacc;
    
    Account acccon = TestDataFactory.createAccounts(1)[0];
    insert acccon;
    
            insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
    Contact candidateid = TestDataFactory.createCandidate(candacc.id,1)[0];
    insert candidateid;
    
            insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
    Contact con = TestDataFactory.createContact(acccon.id,1)[0];
          //  con.IP_ContactType__c = 'Invoice Contact';

    insert con;
    
    Profile p = [Select id from Profile where Name = 'System Administrator' LIMIT 1];
    User u = TestDataFactory.createUsers(p.id, 1)[0];
    u.username = 'Test.espiredev332@test.com';
            u.IP_TempestDepartment__c = '1062';
             u.IP_TempestDivision__c = 'NTS';

    insert u;
    
    IP_TopazGlobalClientInformation__c topaz = TestDataFactory.createTopaz(1)[0];
   topaz.IP_SalesLedgerNumber__c = '645628';
    insert topaz;
    
    sirenum__Site__c site1 = TestDataFactory.createSites(acccon.id,topaz.id,1)[0];
       site1.IP_ClientIDLegacy__c = '1234'; 
        site1.IP_ClientInvoiceName__c = 'Testname';
        site1.IP_InvoiceAddressStreet__c = 'street1';
        site1.IP_InvoiceAddressCity__c = 'city1';
        site1.IP_InvoiceAddressPostcode__c = '7554';
        site1.IP_PublicSector__c = 'No';
        site1.IP_MainContact__c = con.id;
        site1.IP_InvoiceContact__c = con.id;
            site1.IP_InvoiceContactText__c = 'Test Invoice Text';
        site1.IP_PassClientToTempest__c = false;
        site1.IP_PassClientAddressToTempest__c = false;
        site1.sirenum__Street_Address__c = 'abc';
        site1.sirenum__City__c = 'xyz';
    insert site1;
     System.debug('inserted site check3'+site1.Missing_Site_Details__c);
    
    TR1__Job__c job1 = new TR1__Job__c();
     RecordType perms = [Select Id From RecordType Where DeveloperName='Perm' and sObjectType='TR1__Job__c'];
    job1.Name = 'Test Job12';
    job1.IP_Fixed_Fee__c = 120;
    job1.tr1__Account__c = candacc.id;
    job1.tr1__Contact__c = candidateid.id;
    job1.s5m__Site__c = site1.id;
    job1.Recordtypeid = perms.id;
    insert job1;
    
    TR1__Closing_Report__c permplacement = TestDataFactory.createTs2Placement(acccon.id,candidateid.id,con.id,job1.id,site1.id,'Perm',1)[0];
    permplacement.Substatus__c = 'Rebate Period';
    permplacement.tr1__Job__r.tr1__Hiring_Manager__c = con.id;
    permplacement.tr1__Salary__c = 100;
    permplacement.IP_FixedFeeValue__c = 120;
    permplacement.Filled_By__c = UserInfo.getUserId();
    permplacement.tr1__Start_Date__c= system.today();   
    //permplacement.IP_PercentageFee__c=10;
    permplacement.Filled_Pct__c=10;
    insert permplacement;
    system.debug('check placement created***'+permplacement.Missing_Details__c);
    test.startTest();
    
   
    creditnotecontroller.getplacementDetail(permplacement.id);
   
test.stopTest();

}
    
}