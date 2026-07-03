@isTest
public class ShopDirectBatchHeaderdisplay_Test {
@istest static void ShopBatchHeaderclassmethod1(){
    
    
    RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
    RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        
     Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
         
        insert acc1;
     Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc;
          insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
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
                                         ts2__EEO_Gender__c = 'M',
                                          IP_CategoryOfWork__c='Catering;Industrial',
                                        IP_ThirdPartyID__c='testpay12',
                                  IP_IsInvoicecontact__c=true
                                  );
        
         insert con;
   //   con.AccountId = acc.id;
     //   update con;
         
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
        
      //  Contact c = [Select id,Account.name from Contact where id =: con.id];
       // System.debug(' @@ ' + c.account.name);
        
     IP_TopazGlobalClientInformation__c globalclient = new IP_TopazGlobalClientInformation__c();
        globalclient.Name='Test global topaz';
        globalclient.IP_StatusID__c=2;
       globalclient.IP_SalesLedgerNumber__c='123';
         insert globalclient;
         
              sirenum__Site__c site = new sirenum__Site__c();
         
         site.Name = 'Shop Direct - Shaw Key';
         site.sirenum__Operating_Company__c= acc.id;
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
         jobtype.name = 'testjobtype -IA223';
         jobtype.Impellam_Sector__c = sector.id;
         jobtype.Impellam_Core_Category__c = 'Administration -ADM';
         jobtype.Impellam_Job_Category__c ='Administrator -OA001';
         
         insert jobtype;
         
         sirenum__Team__c jobroll = new sirenum__Team__c();
         
         jobroll.name = 'W2';
         jobroll.sirenum__Account__c = contract.id; 
         jobroll.sirenum__Job_Type__c = jobtype.id;
         jobroll.IP_OPWIPSRole__c = 'No';
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
                 spleacement.IP_PassToTempest__c=true;
                 insert spleacement;
               
        Batch_header__c batchheader = new Batch_header__c();
        
               batchheader.IP_Status__c = 'Approved';
               //batchheader.IP_State__c ='open';
               batchheader.IP_BatchType__c ='Shop Direct - Shaw';
               
               insert batchheader;
       
     
        IP_BatchLine__c batchline2 = new IP_BatchLine__c();
        
                batchline2.IP_BatchHeader__c = batchheader.id;
                batchline2.IP_Status__c = 'Open';
                batchline2.IP_State__c  = 'Open';
                batchline2.IP_TextField2__c = 'testpay12';
                batchline2.IP_TextField1__c = 'Test Name';
                batchline2.IP_DateField1__c = Date.newInstance(2017,11,20);
                batchline2.IP_CurrencyField1__c = 10;
                batchline2.IP_CurrencyField2__c = 11;
                batchline2.IP_TextField4__c = 'W2';
                batchline2.IP_TextField9__c = 'P1';
                batchline2.IP_Number12d4Field1__c =12;
                insert batchline2; 
  
        Test.startTest();

    PageReference pageRef = Page.ShopDirectBatchHeader;         
    Test.setCurrentPage(pageRef); 
    ShopDirectBatchHeaderdisplay testAccPlan = new ShopDirectBatchHeaderdisplay();
    testAccPlan.selectedbatchId = batchheader.id;
    testAccPlan.getbatchOptions();
    testAccPlan.getSortDirection();
    testAccPlan.getbatchline();
    testAccPlan.displaylines();
    testAccPlan.showerroredlines();
    testAccPlan.checkstatus();
    testAccPlan.showlines();
   testAccPlan.approvebatch();
    testAccPlan.rejectbatch();
    
            
        Test.stopTest();
                
}
@istest static void ShopBatchHeaderclassmethod2(){
    
    
    RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
    RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        
     Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
         
        insert acc1;
     Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc;
          insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
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
                                         ts2__EEO_Gender__c = 'M',
                                          IP_CategoryOfWork__c='Catering;Industrial',
                                        IP_ThirdPartyID__c='testpay12',
                                  IP_IsInvoicecontact__c=true
                                  );
        
         insert con;
   //   con.AccountId = acc.id;
     //   update con;
         
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
        
      //  Contact c = [Select id,Account.name from Contact where id =: con.id];
       // System.debug(' @@ ' + c.account.name);
        
     IP_TopazGlobalClientInformation__c globalclient = new IP_TopazGlobalClientInformation__c();
        globalclient.Name='Test global topaz';
        globalclient.IP_StatusID__c=2;
       globalclient.IP_SalesLedgerNumber__c='123';
         insert globalclient;
         
              sirenum__Site__c site = new sirenum__Site__c();
         
         site.Name = 'Shop Direct - Shaw Key';
         site.sirenum__Operating_Company__c= acc.id;
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
         jobtype.name = 'testjobtype -IA223';
         jobtype.Impellam_Sector__c = sector.id;
         jobtype.Impellam_Core_Category__c = 'Administration -ADM';
         jobtype.Impellam_Job_Category__c ='Administrator -OA001';
         
         insert jobtype;
         
         sirenum__Team__c jobroll = new sirenum__Team__c();
         
         jobroll.name = 'W2';
         jobroll.sirenum__Account__c = contract.id; 
         jobroll.sirenum__Job_Type__c = jobtype.id;
         jobroll.IP_OPWIPSRole__c = 'No';
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
                 spleacement.IP_PassToTempest__c=true;
                 insert spleacement;
               
        Batch_header__c batchheader = new Batch_header__c();
        
               batchheader.IP_Status__c = 'Pending Approval';
               batchheader.IP_State__c ='open';
               batchheader.IP_BatchType__c ='Shop Direct - Shaw Amendments';
               
               insert batchheader;
       
     
        IP_BatchLine__c batchline2 = new IP_BatchLine__c();
        
                batchline2.IP_BatchHeader__c = batchheader.id;
                batchline2.IP_Status__c = 'open';
                batchline2.IP_State__c  = 'open';
                batchline2.IP_TextField2__c = 'testpay12';
                batchline2.IP_TextField1__c = 'Test Name';
                batchline2.IP_DateField1__c = Date.newInstance(2017,11,20);
                batchline2.IP_CurrencyField1__c = 10;
                batchline2.IP_CurrencyField2__c = 11;
                batchline2.IP_TextField4__c = 'W2';
                batchline2.IP_TextField9__c = 'P1';
                batchline2.IP_Number12d4Field1__c =12;
                insert batchline2; 
  
        Test.startTest();

    PageReference pageRef = Page.ShopDirectBatchHeader;         
    Test.setCurrentPage(pageRef); 
    ShopDirectBatchHeaderdisplay testAccPlan = new ShopDirectBatchHeaderdisplay();
    testAccPlan.selectedbatchId = batchheader.id;
    testAccPlan.getbatchOptions();
    testAccPlan.getSortDirection();
    testAccPlan.getbatchline();
    testAccPlan.displaylines();
    testAccPlan.showerroredlines();
    testAccPlan.checkstatus();
    testAccPlan.showlines();
    testAccPlan.approvebatch();
    testAccPlan.rejectbatch();
    
            
        Test.stopTest();
                
}
@istest static void ShopBatchHeaderclassmethod3(){
    
    
    RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
    RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        
     Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
         
        insert acc1;
     Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc;
          insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
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
                                         ts2__EEO_Gender__c = 'M',
                                          IP_CategoryOfWork__c='Catering;Industrial',
                                        IP_ThirdPartyID__c='testpay12',
                                  IP_IsInvoicecontact__c=true
                                  );
        
         insert con;
   //   con.AccountId = acc.id;
     //   update con;
         
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
        
      //  Contact c = [Select id,Account.name from Contact where id =: con.id];
       // System.debug(' @@ ' + c.account.name);
        
     IP_TopazGlobalClientInformation__c globalclient = new IP_TopazGlobalClientInformation__c();
        globalclient.Name='Test global topaz';
        globalclient.IP_StatusID__c=2;
       globalclient.IP_SalesLedgerNumber__c='123';
         insert globalclient;
         
              sirenum__Site__c site = new sirenum__Site__c();
         
         site.Name = 'Shop Direct - Shaw Key';
         site.sirenum__Operating_Company__c= acc.id;
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
         jobtype.name = 'testjobtype -IA223';
         jobtype.Impellam_Sector__c = sector.id;
         jobtype.Impellam_Core_Category__c = 'Administration -ADM';
         jobtype.Impellam_Job_Category__c ='Administrator -OA001';
         
         insert jobtype;
         
         sirenum__Team__c jobroll = new sirenum__Team__c();
         
         jobroll.name = 'W2';
         jobroll.sirenum__Account__c = contract.id; 
         jobroll.sirenum__Job_Type__c = jobtype.id;
         jobroll.IP_OPWIPSRole__c = 'No';
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
                 spleacement.IP_PassToTempest__c=true;
                 insert spleacement;
               
        Batch_header__c batchheader = new Batch_header__c();
        
               batchheader.IP_Status__c = 'Pending Approval';
               batchheader.IP_State__c ='open';
               batchheader.IP_BatchType__c ='Shop Direct - Ravenmill';
               
               insert batchheader;
       
     
        IP_BatchLine__c batchline2 = new IP_BatchLine__c();
        
                batchline2.IP_BatchHeader__c = batchheader.id;
                batchline2.IP_Status__c = 'open';
                batchline2.IP_State__c  = 'open';
                batchline2.IP_TextField2__c = 'testpay12';
                batchline2.IP_TextField1__c = 'Test Name';
                batchline2.IP_DateField1__c = Date.newInstance(2017,11,20);
                batchline2.IP_CurrencyField1__c = 10;
                batchline2.IP_CurrencyField2__c = 11;
                batchline2.IP_TextField4__c = 'W2';
                batchline2.IP_TextField9__c = 'P1';
                batchline2.IP_Number12d4Field1__c =12;
                insert batchline2; 
  
        Test.startTest();

    PageReference pageRef = Page.ShopDirectBatchHeader;         
    Test.setCurrentPage(pageRef); 
    ShopDirectBatchHeaderdisplay testAccPlan = new ShopDirectBatchHeaderdisplay();
    testAccPlan.selectedbatchId = batchheader.id;
    testAccPlan.getbatchOptions();
    testAccPlan.getSortDirection();
    testAccPlan.getbatchline();
    testAccPlan.displaylines();
    testAccPlan.showerroredlines();
    testAccPlan.checkstatus();
    testAccPlan.showlines();
    testAccPlan.approvebatch();
    testAccPlan.rejectbatch();
    
            
        Test.stopTest();
                
}
@istest static void ShopBatchHeaderclassmethod6(){
    
    
    RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
    RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        
     Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
         
        insert acc1;
     Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc;
          insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
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
                                         ts2__EEO_Gender__c = 'M',
                                          IP_CategoryOfWork__c='Catering;Industrial',
                                        IP_ThirdPartyID__c='testpay12',
                                  IP_IsInvoicecontact__c=true
                                  );
        
         insert con;
   //   con.AccountId = acc.id;
     //   update con;
         
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
        
      //  Contact c = [Select id,Account.name from Contact where id =: con.id];
       // System.debug(' @@ ' + c.account.name);
        
     IP_TopazGlobalClientInformation__c globalclient = new IP_TopazGlobalClientInformation__c();
        globalclient.Name='Test global topaz';
        globalclient.IP_StatusID__c=2;
       globalclient.IP_SalesLedgerNumber__c='123';
         insert globalclient;
         
              sirenum__Site__c site = new sirenum__Site__c();
         
         site.Name = 'Shop Direct - Shaw Key';
         site.sirenum__Operating_Company__c= acc.id;
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
         jobtype.name = 'testjobtype -IA223';
         jobtype.Impellam_Sector__c = sector.id;
         jobtype.Impellam_Core_Category__c = 'Administration -ADM';
         jobtype.Impellam_Job_Category__c ='Administrator -OA001';
         
         insert jobtype;
         
         sirenum__Team__c jobroll = new sirenum__Team__c();
         
         jobroll.name = 'W2';
         jobroll.sirenum__Account__c = contract.id; 
         jobroll.sirenum__Job_Type__c = jobtype.id;
         jobroll.IP_OPWIPSRole__c = 'No';
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
                 spleacement.IP_PassToTempest__c=true;
                 insert spleacement;
               
        Batch_header__c batchheader = new Batch_header__c();
        
               batchheader.IP_Status__c = 'Pending Approval';
               batchheader.IP_State__c ='open';
               batchheader.IP_BatchType__c ='Shop Direct - Ravenmill Amendments';
               
               insert batchheader;
       
     
        IP_BatchLine__c batchline2 = new IP_BatchLine__c();
        
                batchline2.IP_BatchHeader__c = batchheader.id;
                batchline2.IP_Status__c = 'open';
                batchline2.IP_State__c  = 'open';
                batchline2.IP_TextField2__c = 'testpay12';
                batchline2.IP_TextField1__c = 'Test Name';
                batchline2.IP_DateField1__c = Date.newInstance(2017,11,20);
                batchline2.IP_CurrencyField1__c = 10;
                batchline2.IP_CurrencyField2__c = 11;
                batchline2.IP_TextField4__c = 'W2';
                batchline2.IP_TextField9__c = 'P1';
                batchline2.IP_Number12d4Field1__c =12;
                insert batchline2; 
  
        Test.startTest();

    PageReference pageRef = Page.ShopDirectBatchHeader;         
    Test.setCurrentPage(pageRef); 
    ShopDirectBatchHeaderdisplay testAccPlan = new ShopDirectBatchHeaderdisplay();
    testAccPlan.selectedbatchId = batchheader.id;
    testAccPlan.getbatchOptions();
    testAccPlan.getSortDirection();
    testAccPlan.getbatchline();
    testAccPlan.displaylines();
    testAccPlan.showerroredlines();
    testAccPlan.checkstatus();
    testAccPlan.showlines();
   testAccPlan.approvebatch();
    testAccPlan.rejectbatch();
    
            
        Test.stopTest();
                
}
@istest static void ShopBatchHeaderclassmethod7(){
    
    
    RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
    RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        
     Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
         
        insert acc1;
     Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc;
          insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
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
                                         ts2__EEO_Gender__c = 'M',
                                          IP_CategoryOfWork__c='Catering;Industrial',
                                        IP_ThirdPartyID__c='testpay12',
                                  IP_IsInvoicecontact__c=true
                                  );
        
         insert con;
   //   con.AccountId = acc.id;
     //   update con;
         
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
        
      //  Contact c = [Select id,Account.name from Contact where id =: con.id];
       // System.debug(' @@ ' + c.account.name);
        
     IP_TopazGlobalClientInformation__c globalclient = new IP_TopazGlobalClientInformation__c();
        globalclient.Name='Test global topaz';
        globalclient.IP_StatusID__c=2;
       globalclient.IP_SalesLedgerNumber__c='123';
         insert globalclient;
         
              sirenum__Site__c site = new sirenum__Site__c();
         
         site.Name = 'Shop Direct - Shaw Key';
         site.sirenum__Operating_Company__c= acc.id;
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
         jobtype.name = 'testjobtype -IA223';
         jobtype.Impellam_Sector__c = sector.id;
         jobtype.Impellam_Core_Category__c = 'Administration -ADM';
         jobtype.Impellam_Job_Category__c ='Administrator -OA001';
         
         insert jobtype;
         
         sirenum__Team__c jobroll = new sirenum__Team__c();
         
         jobroll.name = 'W2';
         jobroll.sirenum__Account__c = contract.id; 
         jobroll.sirenum__Job_Type__c = jobtype.id;
         jobroll.IP_OPWIPSRole__c = 'No';
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
                 spleacement.IP_PassToTempest__c=true;
                 insert spleacement;
               
        Batch_header__c batchheader = new Batch_header__c();
        
               batchheader.IP_Status__c = 'Pending Approval';
               batchheader.IP_State__c ='open';
               batchheader.IP_BatchType__c ='Shop Direct - Speke';
               
               insert batchheader;
       
     
        IP_BatchLine__c batchline2 = new IP_BatchLine__c();
        
                batchline2.IP_BatchHeader__c = batchheader.id;
                batchline2.IP_Status__c = 'open';
                batchline2.IP_State__c  = 'open';
                batchline2.IP_TextField2__c = 'testpay12';
                batchline2.IP_TextField1__c = 'Test Name';
                batchline2.IP_DateField1__c = Date.newInstance(2017,11,20);
                batchline2.IP_CurrencyField1__c = 10;
                batchline2.IP_CurrencyField2__c = 11;
                batchline2.IP_TextField4__c = 'W2';
                batchline2.IP_TextField9__c = 'P1';
                batchline2.IP_Number12d4Field1__c =12;
                insert batchline2; 
  
        Test.startTest();

    PageReference pageRef = Page.ShopDirectBatchHeader;         
    Test.setCurrentPage(pageRef); 
    ShopDirectBatchHeaderdisplay testAccPlan = new ShopDirectBatchHeaderdisplay();
    testAccPlan.selectedbatchId = batchheader.id;
    testAccPlan.getbatchOptions();
    testAccPlan.getSortDirection();
    testAccPlan.getbatchline();
    testAccPlan.displaylines();
    testAccPlan.showerroredlines();
    testAccPlan.checkstatus();
    testAccPlan.showlines();
    testAccPlan.approvebatch();
    testAccPlan.rejectbatch();
    
            
        Test.stopTest();
                
}
@istest static void ShopBatchHeaderclassmethod8(){
    
    
    RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
    RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        
     Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
         
        insert acc1;
     Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc;
          insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
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
                                         ts2__EEO_Gender__c = 'M',
                                          IP_CategoryOfWork__c='Catering;Industrial',
                                        IP_ThirdPartyID__c='testpay12',
                                  IP_IsInvoicecontact__c=true
                                  );
        
         insert con;
   //   con.AccountId = acc.id;
     //   update con;
         
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
         insert payprofile;
        
         con.AccountId = acc.id;
        update con;
     IP_TopazGlobalClientInformation__c globalclient = new IP_TopazGlobalClientInformation__c();
        globalclient.Name='Test global topaz';
        globalclient.IP_StatusID__c=2;
       globalclient.IP_SalesLedgerNumber__c='123';
         insert globalclient;
         
              sirenum__Site__c site = new sirenum__Site__c();
         
         site.Name = 'Shop Direct - Shaw Key';
         site.sirenum__Operating_Company__c= acc.id;
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
         sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();         
         contract.Name                 = 'test contract';
         contract.sirenum__Client__c   = acc.id;
         contract.sirenum__Employee__c = con.id;         
         insert contract;                 
         sirenum__Rota__c sector = new sirenum__Rota__c();         
         sector.Name = 'new sector';
         insert sector;         
         sirenum__Job_Type__c jobtype = new sirenum__Job_Type__c();
         jobtype.name = 'testjobtype -IA223';
         jobtype.Impellam_Sector__c = sector.id;
         jobtype.Impellam_Core_Category__c = 'Administration -ADM';
         jobtype.Impellam_Job_Category__c ='Administrator -OA001';         
         insert jobtype;         
         sirenum__Team__c jobroll = new sirenum__Team__c();         
         jobroll.name = 'W2';
         jobroll.sirenum__Account__c = contract.id; 
         jobroll.sirenum__Job_Type__c = jobtype.id;
         jobroll.IP_OPWIPSRole__c = 'No';
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
                 spleacement.IP_PassToTempest__c=true;
                 insert spleacement;              
        Batch_header__c batchheader = new Batch_header__c();        
               batchheader.IP_Status__c = 'Pending Approval';
               batchheader.IP_State__c ='open';
               batchheader.IP_BatchType__c ='Shop Direct - Speke Amendments';              
               insert batchheader;    
        IP_BatchLine__c batchline2 = new IP_BatchLine__c();      
                batchline2.IP_BatchHeader__c = batchheader.id;
                batchline2.IP_Status__c = 'open';
                batchline2.IP_State__c  = 'open';
                batchline2.IP_TextField2__c = 'testpay12';
                batchline2.IP_TextField1__c = 'Test Name';
                batchline2.IP_DateField1__c = Date.newInstance(2017,11,20);
                batchline2.IP_CurrencyField1__c = 10;
                batchline2.IP_CurrencyField2__c = 11;
                batchline2.IP_TextField4__c = 'W2';
                batchline2.IP_TextField9__c = 'P1';
                batchline2.IP_Number12d4Field1__c =12;
                insert batchline2; 
  
        Test.startTest();

    PageReference pageRef = Page.ShopDirectBatchHeader;         
    Test.setCurrentPage(pageRef); 
    ShopDirectBatchHeaderdisplay testAccPlan = new ShopDirectBatchHeaderdisplay();
    testAccPlan.selectedbatchId = batchheader.id;
    testAccPlan.getbatchOptions();
    testAccPlan.getSortDirection();
    testAccPlan.getbatchline();
    testAccPlan.displaylines();
    testAccPlan.showerroredlines();
    testAccPlan.checkstatus();
    testAccPlan.showlines();
    testAccPlan.approvebatch();
    testAccPlan.rejectbatch();     
        Test.stopTest();                
}
@istest static void ShopBatchHeaderclassmethod9(){
    
    
    RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
    RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        
     Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
         
        insert acc1;
     Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc;
          insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
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
                                         ts2__EEO_Gender__c = 'M',
                                          IP_CategoryOfWork__c='Catering;Industrial',
                                        IP_ThirdPartyID__c='testpay12',
                                  IP_IsInvoicecontact__c=true
                                  );
        
         insert con;
   //   con.AccountId = acc.id;
     //   update con;
         
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
         insert payprofile;
        
         con.AccountId = acc.id;
        update con;
     IP_TopazGlobalClientInformation__c globalclient = new IP_TopazGlobalClientInformation__c();
        globalclient.Name='Test global topaz';
        globalclient.IP_StatusID__c=2;
       globalclient.IP_SalesLedgerNumber__c='123';
         insert globalclient;
         
              sirenum__Site__c site = new sirenum__Site__c();
         
         site.Name = 'Shop Direct - Shaw Key';
         site.sirenum__Operating_Company__c= acc.id;
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
         sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();         
         contract.Name                 = 'test contract';
         contract.sirenum__Client__c   = acc.id;
         contract.sirenum__Employee__c = con.id;         
         insert contract;                 
         sirenum__Rota__c sector = new sirenum__Rota__c();         
         sector.Name = 'new sector';
         insert sector;         
         sirenum__Job_Type__c jobtype = new sirenum__Job_Type__c();
         jobtype.name = 'testjobtype -IA223';
         jobtype.Impellam_Sector__c = sector.id;
         jobtype.Impellam_Core_Category__c = 'Administration -ADM';
         jobtype.Impellam_Job_Category__c ='Administrator -OA001';         
         insert jobtype;         
         sirenum__Team__c jobroll = new sirenum__Team__c();         
         jobroll.name = 'W2';
         jobroll.sirenum__Account__c = contract.id; 
         jobroll.sirenum__Job_Type__c = jobtype.id;
         jobroll.IP_OPWIPSRole__c = 'No';
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
                 spleacement.IP_PassToTempest__c=true;
                 insert spleacement;              
        Batch_header__c batchheader = new Batch_header__c();        
               batchheader.IP_Status__c = 'Pending Approval';
               batchheader.IP_State__c ='open';
               batchheader.IP_BatchType__c ='Shop Direct - Little Hulton';              
               insert batchheader;    
        IP_BatchLine__c batchline2 = new IP_BatchLine__c();      
                batchline2.IP_BatchHeader__c = batchheader.id;
                batchline2.IP_Status__c = 'open';
                batchline2.IP_State__c  = 'open';
                batchline2.IP_TextField2__c = 'testpay12';
                batchline2.IP_TextField1__c = 'Test Name';
                batchline2.IP_DateField1__c = Date.newInstance(2017,11,20);
                batchline2.IP_CurrencyField1__c = 10;
                batchline2.IP_CurrencyField2__c = 11;
                batchline2.IP_TextField4__c = 'W2';
                batchline2.IP_TextField9__c = 'P1';
                batchline2.IP_Number12d4Field1__c =12;
                insert batchline2; 
  
        Test.startTest();

    PageReference pageRef = Page.ShopDirectBatchHeader;         
    Test.setCurrentPage(pageRef); 
    ShopDirectBatchHeaderdisplay testAccPlan = new ShopDirectBatchHeaderdisplay();
    testAccPlan.selectedbatchId = batchheader.id;
    testAccPlan.getbatchOptions();
    testAccPlan.getSortDirection();
    testAccPlan.getbatchline();
    testAccPlan.displaylines();
    testAccPlan.showerroredlines();
    testAccPlan.checkstatus();
    testAccPlan.showlines();
    testAccPlan.approvebatch();
    testAccPlan.rejectbatch();     
        Test.stopTest();                
}
@istest static void ShopBatchHeaderclassmethod10(){
    
    
    RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
    RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        
     Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
         
        insert acc1;
     Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc;
          insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
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
                                         ts2__EEO_Gender__c = 'M',
                                          IP_CategoryOfWork__c='Catering;Industrial',
                                        IP_ThirdPartyID__c='testpay12',
                                  IP_IsInvoicecontact__c=true
                                  );
        
         insert con;
   //   con.AccountId = acc.id;
     //   update con;
         
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
         insert payprofile;
        
         con.AccountId = acc.id;
        update con;
     IP_TopazGlobalClientInformation__c globalclient = new IP_TopazGlobalClientInformation__c();
        globalclient.Name='Test global topaz';
        globalclient.IP_StatusID__c=2;
       globalclient.IP_SalesLedgerNumber__c='123';
         insert globalclient;
         
              sirenum__Site__c site = new sirenum__Site__c();
         
         site.Name = 'Shop Direct - Shaw Key';
         site.sirenum__Operating_Company__c= acc.id;
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
         sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();         
         contract.Name                 = 'test contract';
         contract.sirenum__Client__c   = acc.id;
         contract.sirenum__Employee__c = con.id;         
         insert contract;                 
         sirenum__Rota__c sector = new sirenum__Rota__c();         
         sector.Name = 'new sector';
         insert sector;         
         sirenum__Job_Type__c jobtype = new sirenum__Job_Type__c();
         jobtype.name = 'testjobtype -IA223';
         jobtype.Impellam_Sector__c = sector.id;
         jobtype.Impellam_Core_Category__c = 'Administration -ADM';
         jobtype.Impellam_Job_Category__c ='Administrator -OA001';         
         insert jobtype;         
         sirenum__Team__c jobroll = new sirenum__Team__c();         
         jobroll.name = 'W2';
         jobroll.sirenum__Account__c = contract.id; 
         jobroll.sirenum__Job_Type__c = jobtype.id;
         jobroll.IP_OPWIPSRole__c = 'No';
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
                 spleacement.IP_PassToTempest__c=true;
                 insert spleacement;              
        Batch_header__c batchheader = new Batch_header__c();        
               batchheader.IP_Status__c = 'Pending Approval';
               batchheader.IP_State__c ='open';
               batchheader.IP_BatchType__c ='Shop Direct - Little Hulton Amendments';              
               insert batchheader;    
        IP_BatchLine__c batchline2 = new IP_BatchLine__c();      
                batchline2.IP_BatchHeader__c = batchheader.id;
                batchline2.IP_Status__c = 'open';
                batchline2.IP_State__c  = 'open';
                batchline2.IP_TextField2__c = 'testpay12';
                batchline2.IP_TextField1__c = 'Test Name';
                batchline2.IP_DateField1__c = Date.newInstance(2017,11,20);
                batchline2.IP_CurrencyField1__c = 10;
                batchline2.IP_CurrencyField2__c = 11;
                batchline2.IP_TextField4__c = 'W2';
                batchline2.IP_TextField9__c = 'P1';
                batchline2.IP_Number12d4Field1__c =12;
                insert batchline2; 
  
        Test.startTest();

    PageReference pageRef = Page.ShopDirectBatchHeader;         
    Test.setCurrentPage(pageRef); 
    ShopDirectBatchHeaderdisplay testAccPlan = new ShopDirectBatchHeaderdisplay();
    testAccPlan.selectedbatchId = batchheader.id;
    testAccPlan.getbatchOptions();
    testAccPlan.getSortDirection();
    testAccPlan.getbatchline();
    testAccPlan.displaylines();
    testAccPlan.showerroredlines();
    testAccPlan.checkstatus();
    testAccPlan.showlines();
    testAccPlan.approvebatch();
    testAccPlan.rejectbatch();     
        Test.stopTest();                
}
@istest static void ShopBatchHeaderclassmethod11(){
    
    
    RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
    RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        
     Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
         
        insert acc1;
     Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc;
          insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
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
                                         ts2__EEO_Gender__c = 'M',
                                          IP_CategoryOfWork__c='Catering;Industrial',
                                        IP_ThirdPartyID__c='testpay12',
                                  IP_IsInvoicecontact__c=true
                                  );
        
         insert con;
   //   con.AccountId = acc.id;
     //   update con;
         
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
         insert payprofile;
        
         con.AccountId = acc.id;
        update con;
     IP_TopazGlobalClientInformation__c globalclient = new IP_TopazGlobalClientInformation__c();
        globalclient.Name='Test global topaz';
        globalclient.IP_StatusID__c=2;
       globalclient.IP_SalesLedgerNumber__c='123';
         insert globalclient;
         
              sirenum__Site__c site = new sirenum__Site__c();
         
         site.Name = 'Shop Direct - Shaw Key';
         site.sirenum__Operating_Company__c= acc.id;
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
         sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();         
         contract.Name                 = 'test contract';
         contract.sirenum__Client__c   = acc.id;
         contract.sirenum__Employee__c = con.id;         
         insert contract;                 
         sirenum__Rota__c sector = new sirenum__Rota__c();         
         sector.Name = 'new sector';
         insert sector;         
         sirenum__Job_Type__c jobtype = new sirenum__Job_Type__c();
         jobtype.name = 'testjobtype -IA223';
         jobtype.Impellam_Sector__c = sector.id;
         jobtype.Impellam_Core_Category__c = 'Administration -ADM';
         jobtype.Impellam_Job_Category__c ='Administrator -OA001';         
         insert jobtype;         
         sirenum__Team__c jobroll = new sirenum__Team__c();         
         jobroll.name = 'W2';
         jobroll.sirenum__Account__c = contract.id; 
         jobroll.sirenum__Job_Type__c = jobtype.id;
         jobroll.IP_OPWIPSRole__c = 'No';
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
                 spleacement.IP_PassToTempest__c=true;
                 insert spleacement;              
        Batch_header__c batchheader = new Batch_header__c();        
               batchheader.IP_Status__c = 'Pending Approval';
               batchheader.IP_State__c ='open';
               batchheader.IP_BatchType__c ='Shop Direct - Croal Mill';              
               insert batchheader;    
        IP_BatchLine__c batchline2 = new IP_BatchLine__c();      
                batchline2.IP_BatchHeader__c = batchheader.id;
                batchline2.IP_Status__c = 'open';
                batchline2.IP_State__c  = 'open';
                batchline2.IP_TextField2__c = 'testpay12';
                batchline2.IP_TextField1__c = 'Test Name';
                batchline2.IP_DateField1__c = Date.newInstance(2017,11,20);
                batchline2.IP_CurrencyField1__c = 10;
                batchline2.IP_CurrencyField2__c = 11;
                batchline2.IP_TextField4__c = 'W2';
                batchline2.IP_TextField9__c = 'P1';
                batchline2.IP_Number12d4Field1__c =12;
                insert batchline2; 
  
        Test.startTest();

    PageReference pageRef = Page.ShopDirectBatchHeader;         
    Test.setCurrentPage(pageRef); 
    ShopDirectBatchHeaderdisplay testAccPlan = new ShopDirectBatchHeaderdisplay();
    testAccPlan.selectedbatchId = batchheader.id;
    testAccPlan.getbatchOptions();
    testAccPlan.getSortDirection();
    testAccPlan.getbatchline();
    testAccPlan.displaylines();
    testAccPlan.showerroredlines();
    testAccPlan.checkstatus();
    testAccPlan.showlines();
    testAccPlan.approvebatch();
    testAccPlan.rejectbatch();     
        Test.stopTest();                
}
@istest static void ShopBatchHeaderclassmethod12(){
    
    
    RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
    RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        
     Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
         
        insert acc1;
     Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc;
          insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
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
                                         ts2__EEO_Gender__c = 'M',
                                          IP_CategoryOfWork__c='Catering;Industrial',
                                        IP_ThirdPartyID__c='testpay12',
                                  IP_IsInvoicecontact__c=true
                                  );
        
         insert con;
   //   con.AccountId = acc.id;
     //   update con;
         
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
         insert payprofile;
        
         con.AccountId = acc.id;
        update con;
     IP_TopazGlobalClientInformation__c globalclient = new IP_TopazGlobalClientInformation__c();
        globalclient.Name='Test global topaz';
        globalclient.IP_StatusID__c=2;
       globalclient.IP_SalesLedgerNumber__c='123';
         insert globalclient;
         
              sirenum__Site__c site = new sirenum__Site__c();
         
         site.Name = 'Shop Direct - Shaw Key';
         site.sirenum__Operating_Company__c= acc.id;
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
         sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();         
         contract.Name                 = 'test contract';
         contract.sirenum__Client__c   = acc.id;
         contract.sirenum__Employee__c = con.id;         
         insert contract;                 
         sirenum__Rota__c sector = new sirenum__Rota__c();         
         sector.Name = 'new sector';
         insert sector;         
         sirenum__Job_Type__c jobtype = new sirenum__Job_Type__c();
         jobtype.name = 'testjobtype -IA223';
         jobtype.Impellam_Sector__c = sector.id;
         jobtype.Impellam_Core_Category__c = 'Administration -ADM';
         jobtype.Impellam_Job_Category__c ='Administrator -OA001';         
         insert jobtype;         
         sirenum__Team__c jobroll = new sirenum__Team__c();         
         jobroll.name = 'W2';
         jobroll.sirenum__Account__c = contract.id; 
         jobroll.sirenum__Job_Type__c = jobtype.id;
         jobroll.IP_OPWIPSRole__c = 'No';
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
                 spleacement.IP_PassToTempest__c=true;
                 insert spleacement;              
        Batch_header__c batchheader = new Batch_header__c();        
               batchheader.IP_Status__c = 'Pending Approval';
               batchheader.IP_State__c ='open';
               batchheader.IP_BatchType__c ='Shop Direct - Croal Mill Amendments';              
               insert batchheader;    
        IP_BatchLine__c batchline2 = new IP_BatchLine__c();      
                batchline2.IP_BatchHeader__c = batchheader.id;
                batchline2.IP_Status__c = 'open';
                batchline2.IP_State__c  = 'open';
                batchline2.IP_TextField2__c = 'testpay12';
                batchline2.IP_TextField1__c = 'Test Name';
                batchline2.IP_DateField1__c = Date.newInstance(2017,11,20);
                batchline2.IP_CurrencyField1__c = 10;
                batchline2.IP_CurrencyField2__c = 11;
                batchline2.IP_TextField4__c = 'W2';
                batchline2.IP_TextField9__c = 'P1';
                batchline2.IP_Number12d4Field1__c =12;
                insert batchline2; 
  
        Test.startTest();

    PageReference pageRef = Page.ShopDirectBatchHeader;         
    Test.setCurrentPage(pageRef); 
    ShopDirectBatchHeaderdisplay testAccPlan = new ShopDirectBatchHeaderdisplay();
    testAccPlan.selectedbatchId = batchheader.id;
    testAccPlan.getbatchOptions();
    testAccPlan.getSortDirection();
    testAccPlan.getbatchline();
    testAccPlan.displaylines();
    testAccPlan.showerroredlines();
    testAccPlan.checkstatus();
    testAccPlan.showlines();
    testAccPlan.approvebatch();
    testAccPlan.rejectbatch();     
        Test.stopTest();                
}
@istest static void ShopBatchHeaderclassmethod65(){
    
    
    RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
    RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        
     Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
         
        insert acc1;
     Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc;
          insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
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
                                         ts2__EEO_Gender__c = 'M',
                                          IP_CategoryOfWork__c='Catering;Industrial',
                                        IP_ThirdPartyID__c='testpay12',
                                  IP_IsInvoicecontact__c=true
                                  );
        
         insert con;
   //   con.AccountId = acc.id;
     //   update con;
         
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
         insert payprofile;
        
         con.AccountId = acc.id;
        update con;
     IP_TopazGlobalClientInformation__c globalclient = new IP_TopazGlobalClientInformation__c();
        globalclient.Name='Test global topaz';
        globalclient.IP_StatusID__c=2;
       globalclient.IP_SalesLedgerNumber__c='123';
         insert globalclient;
         
              sirenum__Site__c site = new sirenum__Site__c();
         
         site.Name = 'Other Branches (Internal)';
         site.sirenum__Operating_Company__c= acc.id;
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
         sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();         
         contract.Name                 = 'test contract';
         contract.sirenum__Client__c   = acc.id;
         contract.sirenum__Employee__c = con.id;         
         insert contract;                 
         sirenum__Rota__c sector = new sirenum__Rota__c();         
         sector.Name = 'new sector';
         insert sector;         
         sirenum__Job_Type__c jobtype = new sirenum__Job_Type__c();
         jobtype.name = 'testjobtype -IA223';
         jobtype.Impellam_Sector__c = sector.id;
         jobtype.Impellam_Core_Category__c = 'Administration -ADM';
         jobtype.Impellam_Job_Category__c ='Administrator -OA001';         
         insert jobtype;         
         sirenum__Team__c jobroll = new sirenum__Team__c();         
         jobroll.name = 'W2';
         jobroll.sirenum__Account__c = contract.id; 
         jobroll.sirenum__Job_Type__c = jobtype.id;
         jobroll.IP_OPWIPSRole__c = 'No';
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
                 spleacement.IP_PassToTempest__c=true;
                 insert spleacement;              
        Batch_header__c batchheader = new Batch_header__c();        
               batchheader.IP_Status__c = 'Pending Approval';
               batchheader.IP_State__c ='open';
               batchheader.IP_BatchType__c ='Shop Direct - Internals';              
               insert batchheader;    
        IP_BatchLine__c batchline2 = new IP_BatchLine__c();      
                batchline2.IP_BatchHeader__c = batchheader.id;
                batchline2.IP_Status__c = 'open';
                batchline2.IP_State__c  = 'open';
                batchline2.IP_TextField2__c = 'testpay12';
                batchline2.IP_TextField1__c = 'Test Name';
                batchline2.IP_DateField1__c = Date.newInstance(2017,11,20);
                batchline2.IP_CurrencyField1__c = 10;
                batchline2.IP_CurrencyField2__c = 11;
                batchline2.IP_TextField4__c = 'W2';
                batchline2.IP_TextField9__c = 'P1';
                batchline2.IP_Number12d4Field1__c =12;
                insert batchline2; 
  
        Test.startTest();

    PageReference pageRef = Page.ShopDirectBatchHeader;         
    Test.setCurrentPage(pageRef); 
    ShopDirectBatchHeaderdisplay testAccPlan = new ShopDirectBatchHeaderdisplay();
    testAccPlan.selectedbatchId = batchheader.id;
    testAccPlan.getbatchOptions();
    testAccPlan.getSortDirection();
    testAccPlan.getbatchline();
    testAccPlan.displaylines();
    testAccPlan.showerroredlines();
    testAccPlan.checkstatus();
    testAccPlan.showlines();
    testAccPlan.approvebatch();
    testAccPlan.rejectbatch();     
        Test.stopTest();                
}
@istest static void ShopBatchHeaderclassmethod66(){
    
    
    RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
    RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        
     Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
         
        insert acc1;
     Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc;
          insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
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
                                         ts2__EEO_Gender__c = 'M',
                                          IP_CategoryOfWork__c='Catering;Industrial',
                                        IP_ThirdPartyID__c='testpay12',
                                  IP_IsInvoicecontact__c=true
                                  );
        
         insert con;
   //   con.AccountId = acc.id;
     //   update con;
         
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
         insert payprofile;
        
         con.AccountId = acc.id;
        update con;
     IP_TopazGlobalClientInformation__c globalclient = new IP_TopazGlobalClientInformation__c();
        globalclient.Name='Test global topaz';
        globalclient.IP_StatusID__c=2;
       globalclient.IP_SalesLedgerNumber__c='123';
         insert globalclient;
         
              sirenum__Site__c site = new sirenum__Site__c();
         
         site.Name = 'Other Branches (Internal)';
         site.sirenum__Operating_Company__c= acc.id;
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
         sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();         
         contract.Name                 = 'test contract';
         contract.sirenum__Client__c   = acc.id;
         contract.sirenum__Employee__c = con.id;         
         insert contract;                 
         sirenum__Rota__c sector = new sirenum__Rota__c();         
         sector.Name = 'new sector';
         insert sector;         
         sirenum__Job_Type__c jobtype = new sirenum__Job_Type__c();
         jobtype.name = 'testjobtype -IA223';
         jobtype.Impellam_Sector__c = sector.id;
         jobtype.Impellam_Core_Category__c = 'Administration -ADM';
         jobtype.Impellam_Job_Category__c ='Administrator -OA001';         
         insert jobtype;         
         sirenum__Team__c jobroll = new sirenum__Team__c();         
         jobroll.name = 'W2';
         jobroll.sirenum__Account__c = contract.id; 
         jobroll.sirenum__Job_Type__c = jobtype.id;
         jobroll.IP_OPWIPSRole__c = 'No';
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
                 spleacement.IP_PassToTempest__c=true;
                 insert spleacement;              
        Batch_header__c batchheader = new Batch_header__c();        
               batchheader.IP_Status__c = 'Pending Approval';
               batchheader.IP_State__c ='open';
               batchheader.IP_BatchType__c ='Shop Direct - Internals Amendments';              
               insert batchheader;    
        IP_BatchLine__c batchline2 = new IP_BatchLine__c();      
                batchline2.IP_BatchHeader__c = batchheader.id;
                batchline2.IP_Status__c = 'open';
                batchline2.IP_State__c  = 'open';
                batchline2.IP_TextField2__c = 'testpay12';
                batchline2.IP_TextField1__c = 'Test Name';
                batchline2.IP_DateField1__c = Date.newInstance(2017,11,20);
                batchline2.IP_CurrencyField1__c = 10;
                batchline2.IP_CurrencyField2__c = 11;
                batchline2.IP_TextField4__c = 'W2';
                batchline2.IP_TextField9__c = 'P1';
                batchline2.IP_Number12d4Field1__c =12;
                insert batchline2; 
  
        Test.startTest();

    PageReference pageRef = Page.ShopDirectBatchHeader;         
    Test.setCurrentPage(pageRef); 
    ShopDirectBatchHeaderdisplay testAccPlan = new ShopDirectBatchHeaderdisplay();
    testAccPlan.selectedbatchId = batchheader.id;
    testAccPlan.getbatchOptions();
    testAccPlan.getSortDirection();
    testAccPlan.getbatchline();
    testAccPlan.displaylines();
    testAccPlan.showerroredlines();
    testAccPlan.checkstatus();
    testAccPlan.showlines();
    testAccPlan.approvebatch();
    testAccPlan.rejectbatch();     
        Test.stopTest();                
}
}