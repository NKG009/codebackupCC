@isTest
public class Test_RecordTypeseclection_ext
{
 public static testmethod void checkrecordtypepayprofile()
 {
      RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 

            Account account1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        insert account1;
        
               insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= false);

        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
       
            Contact con = new Contact(AccountID = account1.id, 
                                          RecordTypeId=condRec.id,
                                          FirstName ='Taji',
                                          Salutation ='Mr',
                                          MailingCity='ggn',
                                          MailingCountry='india',
                                          MailingPostalCode='110092',
                                          MailingState='Haryana',
                                          LastName ='tajicandidate',  
                                          sirenum__National_Insurance__c='AA323232A', 
                                          IP_CandidateIDlegacy__c='test123',
                                          MailingStreet='abc',
                                          P45_Requested__c=true,
                                          PayrollLeaver__c=null,
                                          Title = 'TestLastName1',
                                          Initials__c = 'TestLastName1',
                                          Birthdate = Date.valueOf('1992-02-20'),
                                          Phone = '9879879877',
                                          EEO_Gender__c = 'M',
                                          P45_Date_by_Head_Office__c= System.today(),
                                          IP_CategoryOfWork__c='Catering;Industrial' );
           
        insert con;
        
           insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        
        id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('LTD').getRecordTypeId();
        IP_PayProfile__c payprofile = new IP_PayProfile__c();
         payprofile.RecordTypeId = payRTId;
          
         payprofile.IP_Candidate__c = con.id;
         payprofile.IP_CompanyName__c='sfdc';
         payprofile.IP_Status__c = 'Active'; 
         payprofile.IP_CompanyRegNo__c  = 'ad123456';
         payprofile.IP_VATNumber__c     = '123456789';
         payprofile.IP_PayrollID__c  = 'test57861';
         payprofile.IP_VATRegistered__c=true;
         payprofile.IP_OkToSupply__c=1;
         payprofile.IP_BusinessAddressLine1__c='test address 1';
         payprofile.IP_BusinessAddressLine2__c='test address 2';
         payprofile.IP_BusinessAddressTown__c='town city';
         payprofile.IP_BusinessAddressPostcode__c='12345678';
         payprofile.IP_PayFrequency__c='Weekly';
         payprofile.IP_PaymentType__c='BACS';
        // payprofile.IP_PassToTempest__c=true;
         payprofile.IP_BankAccountName__c = 'Test name1';
         payprofile.IP_AccountNumber__c = '98567497';
         payprofile.IP_SortCode__c = '645362';
        payprofile.IP_LastPassedToTempest__c=datetime.newInstance(2014, 9, 15, 12, 30, 0);
         
         insert payprofile; 
         
         Test.startTest();
         
           Test.setCurrentPageReference(new PageReference('Page.RecordTypeselection')); 
          System.currentPageReference().getParameters().put('conID', con.id);   
          ApexPages.StandardController sc = new ApexPages.StandardController(payprofile);
          RecordTypeseclection_ext  permgenerate = new RecordTypeseclection_ext (sc);
   // List<SelectOption> selectedrecordtype=permgenerate.allrecordtype;
   permgenerate.selectedrecordtype='LTD';
    permgenerate.nextpage();
     //permgenerate.cancelredirect(); 
                
         Test.stopTest();
 }
 public static testmethod void checkrecordtypepayprofile1()
 {
      RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 

            Account account1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        insert account1;
        
               insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= false);

        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
       
            Contact con = new Contact(AccountID = account1.id, 
                                          RecordTypeId=condRec.id,
                                          FirstName ='Taji',
                                          Salutation ='Mr',
                                          MailingCity='ggn',
                                          MailingCountry='india',
                                          MailingPostalCode='110092',
                                          MailingState='Haryana',
                                          LastName ='tajicandidate',  
                                          sirenum__National_Insurance__c='AA323232A', 
                                          IP_CandidateIDlegacy__c='test123',
                                          MailingStreet='abc',
                                          P45_Requested__c=true,
                                          PayrollLeaver__c=null,
                                          Title = 'TestLastName1',
                                          Initials__c = 'TestLastName1',
                                          Birthdate = Date.valueOf('1992-02-20'),
                                          Phone = '9879879877',
                                          EEO_Gender__c = 'M',
                                         // P45_Date_by_Head_Office__c= System.today(),
                                          IP_CategoryOfWork__c='Catering;Industrial' );
           
        insert con;
        
           insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        
        id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('PAYE').getRecordTypeId();
        IP_PayProfile__c payprofile = new IP_PayProfile__c();
         payprofile.RecordTypeId = payRTId;
          
         payprofile.IP_Candidate__c = con.id;
         payprofile.IP_CompanyName__c='sfdc';
         payprofile.IP_Status__c = 'Active'; 
         payprofile.IP_CompanyRegNo__c  = 'ad123456';
         payprofile.IP_VATNumber__c     = '123456789';
         payprofile.IP_PayrollID__c  = 'test57861';
         payprofile.IP_VATRegistered__c=true;
         payprofile.IP_OkToSupply__c=1;
         payprofile.IP_BusinessAddressLine1__c='test address 1';
         payprofile.IP_BusinessAddressLine2__c='test address 2';
         payprofile.IP_BusinessAddressTown__c='town city';
         payprofile.IP_BusinessAddressPostcode__c='12345678';
         payprofile.IP_PayFrequency__c='Weekly';
         payprofile.IP_PaymentType__c='BACS';
        // payprofile.IP_PassToTempest__c=true;
         payprofile.IP_BankAccountName__c = 'Test name1';
         payprofile.IP_AccountNumber__c = '98567497';
         payprofile.IP_SortCode__c = '645362';
       // payprofile.IP_LastPassedToTempest__c=datetime.newInstance(2014, 9, 15, 12, 30, 0);
         
         insert payprofile; 
         
         Test.startTest();
         
           Test.setCurrentPageReference(new PageReference('Page.RecordTypeselection')); 
          System.currentPageReference().getParameters().put('conID', con.id);   
          ApexPages.StandardController sc = new ApexPages.StandardController(payprofile);
          RecordTypeseclection_ext  permgenerate = new RecordTypeseclection_ext (sc);
   // List<SelectOption> selectedrecordtype=permgenerate.allrecordtype;
       permgenerate.selectedrecordtype = 'PAYE';
    permgenerate.nextpage();
     //permgenerate.cancelredirect(); 
                
         Test.stopTest();
 }
 public static testmethod void checkrecordtypepayprofile2()
 {
      RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 

            Account account1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        insert account1;
        
               insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= false);

        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
       
            Contact con = new Contact(AccountID = account1.id, 
                                          RecordTypeId=condRec.id,
                                          FirstName ='Taji',
                                          Salutation ='Mr',
                                          MailingCity='ggn',
                                          MailingCountry='india',
                                          MailingPostalCode='110092',
                                          MailingState='Haryana',
                                          LastName ='tajicandidate',  
                                          sirenum__National_Insurance__c='AA323232A', 
                                          IP_CandidateIDlegacy__c='test123',
                                          MailingStreet='abc',
                                          P45_Requested__c=true,
                                          PayrollLeaver__c=null,
                                          Title = 'TestLastName1',
                                          Initials__c = 'TestLastName1',
                                          Birthdate = Date.valueOf('1992-02-20'),
                                          Phone = '9879879877',
                                          EEO_Gender__c = 'M',
                                         // P45_Date_by_Head_Office__c= System.today(),
                                          IP_CategoryOfWork__c='Catering;Industrial' );
           
        insert con;
        
           insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        
        id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('Umbrella').getRecordTypeId();
        IP_PayProfile__c payprofile = new IP_PayProfile__c();
         payprofile.RecordTypeId = payRTId;
          
         payprofile.IP_Candidate__c = con.id;
         payprofile.IP_CompanyName__c='sfdc';
         payprofile.IP_Status__c = 'Active'; 
         payprofile.IP_CompanyRegNo__c  = 'ad123456';
         payprofile.IP_VATNumber__c     = '123456789';
         payprofile.IP_PayrollID__c  = 'test57861';
         payprofile.IP_VATRegistered__c=true;
         payprofile.IP_OkToSupply__c=1;
         payprofile.IP_BusinessAddressLine1__c='test address 1';
         payprofile.IP_BusinessAddressLine2__c='test address 2';
         payprofile.IP_BusinessAddressTown__c='town city';
         payprofile.IP_BusinessAddressPostcode__c='12345678';
         payprofile.IP_PayFrequency__c='Weekly';
         payprofile.IP_PaymentType__c='BACS';
        // payprofile.IP_PassToTempest__c=true;
         payprofile.IP_BankAccountName__c = 'Test name1';
         payprofile.IP_AccountNumber__c = '98567497';
         payprofile.IP_SortCode__c = '645362';
       // payprofile.IP_LastPassedToTempest__c=datetime.newInstance(2014, 9, 15, 12, 30, 0);
         
         insert payprofile; 
         
         Test.startTest();
         
           Test.setCurrentPageReference(new PageReference('Page.RecordTypeselection')); 
          System.currentPageReference().getParameters().put('conID', con.id);   
          ApexPages.StandardController sc = new ApexPages.StandardController(payprofile);
          RecordTypeseclection_ext  permgenerate = new RecordTypeseclection_ext (sc);
   // List<SelectOption> selectedrecordtype=permgenerate.allrecordtype;
       permgenerate.selectedrecordtype = 'Umbrella';
     permgenerate.nextpage();
     //permgenerate.cancelredirect(); 
                
         Test.stopTest();
 }
public static testmethod void checkrecordtypepayprofile3()
 {
      RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 

            Account account1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        insert account1;
        
               insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= false);

        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
       
            Contact con = new Contact(AccountID = account1.id, 
                                          RecordTypeId=condRec.id,
                                          FirstName ='Taji',
                                          Salutation ='Mr',
                                          MailingCity='ggn',
                                          MailingCountry='india',
                                          MailingPostalCode='110092',
                                          MailingState='Haryana',
                                          LastName ='tajicandidate',  
                                          sirenum__National_Insurance__c='AA323232A', 
                                          IP_CandidateIDlegacy__c='test123',
                                          MailingStreet='abc',
                                          P45_Requested__c=true,
                                          PayrollLeaver__c=null,
                                          Title = 'TestLastName1',
                                          Initials__c = 'TestLastName1',
                                          Birthdate = Date.valueOf('1992-02-20'),
                                          Phone = '9879879877',
                                          EEO_Gender__c = 'M',
                                         // P45_Date_by_Head_Office__c= System.today(),
                                          IP_CategoryOfWork__c='Catering;Industrial' );
           
        insert con;
        
           insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        
        id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('LTD').getRecordTypeId();
        IP_PayProfile__c payprofile = new IP_PayProfile__c();
         payprofile.RecordTypeId = payRTId;
          
         payprofile.IP_Candidate__c = con.id;
         payprofile.IP_CompanyName__c='sfdc';
         payprofile.IP_Status__c = 'Active'; 
         payprofile.IP_CompanyRegNo__c  = 'ad123456';
         payprofile.IP_VATNumber__c     = '123456789';
         payprofile.IP_PayrollID__c  = 'test57861';
         payprofile.IP_VATRegistered__c=true;
         payprofile.IP_OkToSupply__c=1;
         payprofile.IP_BusinessAddressLine1__c='test address 1';
         payprofile.IP_BusinessAddressLine2__c='test address 2';
         payprofile.IP_BusinessAddressTown__c='town city';
         payprofile.IP_BusinessAddressPostcode__c='12345678';
         payprofile.IP_PayFrequency__c='Weekly';
         payprofile.IP_PaymentType__c='BACS';
        // payprofile.IP_PassToTempest__c=true;
         payprofile.IP_BankAccountName__c = 'Test name1';
         payprofile.IP_AccountNumber__c = '98567497';
         payprofile.IP_SortCode__c = '645362';
       // payprofile.IP_LastPassedToTempest__c=datetime.newInstance(2014, 9, 15, 12, 30, 0);
         
         insert payprofile; 
         
         Test.startTest();
         
           Test.setCurrentPageReference(new PageReference('Page.RecordTypeselection')); 
          System.currentPageReference().getParameters().put('conID', con.id);   
          ApexPages.StandardController sc = new ApexPages.StandardController(payprofile);
          RecordTypeseclection_ext  permgenerate = new RecordTypeseclection_ext (sc);
    List<SelectOption> selectedrecordtype=permgenerate.allrecordtype;
      // permgenerate.selectedrecordtype = 'Umbrella';
     //RecordTypeseclection_ext.lightningTheme = 'Theme4d';
     permgenerate.nextpage();
     //permgenerate.cancelredirect(); 
                
         Test.stopTest();
 }


}