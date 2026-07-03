@istest
public class Test_P45SyncB2F{

    static void dataSetup(){   
        Account account = TestDataFactory.createCandidateAccount(2)[1]; 
        insert account; 
         insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= false);
        Contact cont = TestDataFactory.createCandidate(account.id, 4)[3];
          insert cont;
        
        
           id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('PAYE').getRecordTypeId();
           insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
            insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= true);
         IP_PayProfile__c payprofile = new IP_PayProfile__c();
         payprofile.RecordTypeId = payRTId;
          
       payprofile.IP_Candidate__c = cont.id;
         payprofile.IP_CompanyName__c='sfdc';
         payprofile.IP_Status__c = 'Active'; 
         payprofile.IP_CompanyRegNo__c  = 'ad123456';
         payprofile.IP_VATNumber__c     = '123456789';
         payprofile.IP_PayrollID__c  = 'testpay';
         payprofile.IP_VATRegistered__c=true;
         payprofile.IP_OkToSupply__c=1;
         payprofile.IP_BusinessAddressLine1__c='test address 1';
         payprofile.IP_BusinessAddressLine2__c='test address 2';
         payprofile.IP_BusinessAddressTown__c='town city';
         payprofile.IP_BusinessAddressPostcode__c='12345678';
         payprofile.IP_PayFrequency__c='Weekly';
         payprofile.IP_PaymentType__c='BACS';
         insert payprofile;
        
        
      
        Batch_header__c batchheader = new Batch_header__c();
        batchheader.IP_Status__c = 'Approved';
        batchheader.IP_State__c ='Closed';
        batchheader.IP_BatchType__c ='P45 Sync';
        insert batchheader;
        
        IP_BatchLine__c batchline = new IP_BatchLine__c();
        
        batchline.IP_BatchHeader__c = batchheader.id;
        batchline.IP_Status__c = 'Open';
        batchline.IP_State__c  = 'Open';
        
        batchline.IP_DateField1__c = system.today();
        batchline.IP_TextField1__c = 'testpaynew';
        
     
        
        
        insert batchline;
    
     
    }
    
       static void data()
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
                                          IP_CategoryOfWork__c='Catering' );
           
        insert con;
        
               Contact con2 = new Contact(AccountID = account1.id, 
                                          RecordTypeId=condRec.id,
                                          FirstName ='Tajindersingh',
                                          Salutation ='Mr',
                                          MailingCity='ggn',
                                          MailingCountry='india',
                                          MailingPostalCode='110094',
                                          MailingState='Delhi',
                                          LastName ='Singh',  
                                          sirenum__National_Insurance__c='AA323232A', 
                                          IP_CandidateIDlegacy__c='test12',
                                          MailingStreet='abc',
                                          P45_Requested__c=true,
                                          PayrollLeaver__c=null,
                                          Title = 'Doctor',
                                          Initials__c = 'TestLastName1',
                                          Birthdate = Date.valueOf('1992-02-20'),
                                          Phone = '9879879877',
                                          EEO_Gender__c = 'M',
                                          P45_Date_by_Head_Office__c=Date.valueOf('2018-04-29'),
                                          IP_CategoryOfWork__c='Catering' );
           
        insert con2;
        
        
           insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
           insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= true);
           
        id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('PAYE').getRecordTypeId();

         IP_PayProfile__c payprofile1 = new IP_PayProfile__c();
         payprofile1.RecordTypeId = payRTId;
          
       payprofile1.IP_Candidate__c = con.id;
         payprofile1.IP_CompanyName__c='sfdc';
         payprofile1.IP_Status__c = 'Active'; 
         payprofile1.IP_CompanyRegNo__c  = 'ad123456';
         payprofile1.IP_VATNumber__c     = '123456789';
         payprofile1.IP_PayrollID__c  = 'test123';
         payprofile1.IP_VATRegistered__c=true;
         payprofile1.IP_OkToSupply__c=1;
         payprofile1.IP_BusinessAddressLine1__c='test address 1';
         payprofile1.IP_BusinessAddressLine2__c='test address 2';
         payprofile1.IP_BusinessAddressTown__c='town city';
         payprofile1.IP_BusinessAddressPostcode__c='12345678';
         payprofile1.IP_PayFrequency__c='Weekly';
         payprofile1.IP_PaymentType__c='BACS';
      //  payprofile1
         insert payprofile1;
         
          IP_PayProfile__c payprofile2 = new IP_PayProfile__c();
         payprofile2.RecordTypeId = payRTId;
          
       payprofile2.IP_Candidate__c = con2.id;
         payprofile2.IP_CompanyName__c='sfdc';
         payprofile2.IP_Status__c = 'Active'; 
         payprofile2.IP_CompanyRegNo__c  = 'ad123456';
         payprofile2.IP_VATNumber__c     = '123456789';
         payprofile2.IP_PayrollID__c  = 'test12';
         payprofile2.IP_VATRegistered__c=true;
         payprofile2.IP_OkToSupply__c=1;
         payprofile2.IP_BusinessAddressLine1__c='test address 1';
         payprofile2.IP_BusinessAddressLine2__c='test address 2';
         payprofile2.IP_BusinessAddressTown__c='town city';
         payprofile2.IP_BusinessAddressPostcode__c='12345678';
         payprofile2.IP_PayFrequency__c='Weekly';
         payprofile2.IP_PaymentType__c='BACS';
         payprofile2.P45_Date_by_Head_Office__c= Date.valueOf('2018-04-29');
      //  payprofile1
         insert payprofile2;
        
           Batch_header__c batchheader1 = new Batch_header__c();
        batchheader1.IP_Status__c = 'Approved';
        batchheader1.IP_State__c ='Closed';
        batchheader1.IP_BatchType__c ='P45 Sync';
        insert batchheader1;
        
           IP_BatchLine__c batchline1 = new IP_BatchLine__c();
        
        batchline1.IP_BatchHeader__c = batchheader1.id;
        batchline1.IP_Status__c = 'Open';
        batchline1.IP_State__c  = 'Open';
        
        batchline1.IP_DateField1__c = system.today();
        batchline1.IP_TextField1__c = 'test123';
        
        insert batchline1;
        
        
          IP_BatchLine__c batchline2 = new IP_BatchLine__c();
        
        batchline2.IP_BatchHeader__c = batchheader1.id;
        batchline2.IP_Status__c = 'Open';
        batchline2.IP_State__c  = 'Open';
        
        batchline2.IP_DateField1__c = Date.valueOf('2018-04-29');
        batchline2.IP_TextField1__c = 'test12';
        
        insert batchline2;
    }
     static void dataSetup123(){   
        Account account = TestDataFactory.createCandidateAccount(2)[1]; 
        insert account; 
                 insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= false);

        Contact cont = TestDataFactory.createCandidate(account.id, 4)[3];
          insert cont;
        
        
           id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('PAYE').getRecordTypeId();
           insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
            insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c= true);
         IP_PayProfile__c payprofile = new IP_PayProfile__c();
         payprofile.RecordTypeId = payRTId;
          
       payprofile.IP_Candidate__c = cont.id;
         payprofile.IP_CompanyName__c='sfdc';
         payprofile.IP_Status__c = 'Active'; 
         payprofile.IP_CompanyRegNo__c  = 'ad123456';
         payprofile.IP_VATNumber__c     = '123456789';
         payprofile.IP_PayrollID__c  = 'testpay';
         payprofile.IP_VATRegistered__c=true;
         payprofile.IP_OkToSupply__c=1;
         payprofile.IP_BusinessAddressLine1__c='test address 1';
         payprofile.IP_BusinessAddressLine2__c='test address 2';
         payprofile.IP_BusinessAddressTown__c='town city';
         payprofile.IP_BusinessAddressPostcode__c='12345678';
         payprofile.IP_PayFrequency__c='Weekly';
         payprofile.IP_PaymentType__c='BACS';
         payprofile.P45_Requested__c = true;
         insert payprofile;
        
        
      
        Batch_header__c batchheader = new Batch_header__c();
        batchheader.IP_Status__c = 'Approved';
        batchheader.IP_State__c ='Closed';
        batchheader.IP_BatchType__c ='P45 Sync';
        insert batchheader;
        
        IP_BatchLine__c batchline = new IP_BatchLine__c();
        
        batchline.IP_BatchHeader__c = batchheader.id;
        batchline.IP_Status__c = 'Open';
        batchline.IP_State__c  = 'Open';
        
        batchline.IP_DateField1__c = system.today();
        batchline.IP_TextField1__c = 'testpay';
        
     
        
        
        insert batchline;
    
     
    }

    @istest static void P45syncTest(){
        
        
   //    datasetup();
     //   data();
        Test.startTest();
        ScheduleBatchHeaderP45sync sh1 = new ScheduleBatchHeaderP45sync();
        String sch = '0 0 23 * * ?';
        system.schedule('Test P45 Sync', sch, sh1);
        Test.stopTest();
    }
     @istest static void P45batchtest(){
        
        
   //    datasetup();
        data();
        Test.startTest();
        P45SyncB2F batchInstance = new P45SyncB2F(); 
        database.executebatch(batchInstance,2);
        Test.stopTest();
    }
      @istest static void P45batchtest2(){
        
        
       datasetup();
      
        Test.startTest();
        P45SyncB2F batchInstance = new P45SyncB2F(); 
        database.executebatch(batchInstance,1);
        Test.stopTest();
    }
    @istest static void P45batchtest3(){
        
        
       dataSetup123();
      
        Test.startTest();
        P45SyncB2F batchInstance = new P45SyncB2F(); 
        database.executebatch(batchInstance,1);
        Test.stopTest();
    }
   
   
}