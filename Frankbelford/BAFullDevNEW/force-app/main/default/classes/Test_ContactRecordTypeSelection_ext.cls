@isTest
public class Test_ContactRecordTypeSelection_ext {
 public static testmethod void checkrecordtype()
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
                                          EEO_Gender__c = 'M'
                                         // P45_Date_by_Head_Office__c= System.today()
                                          //IP_CategoryOfWork__c='Catering;Industrial' 
                                     );
           
        insert con;
  
        Test.startTest();
     ApexPages.StandardController sc = new ApexPages.StandardController(con);               
    ContactRecordTypeSelection_ext  permgenerate = new ContactRecordTypeSelection_ext (sc);
    List<SelectOption> selectedrecordtype=permgenerate.allrecordtype;
    permgenerate.nextpage();
           
        Test.stopTest();
    }
     public static testmethod void checkrecordtype2()
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
                                          EEO_Gender__c = 'M'
                                         // P45_Date_by_Head_Office__c= System.today(),
                                          //IP_CategoryOfWork__c='Catering;Industrial'
                                     );
           
        insert con;
  
        Test.startTest();
     ApexPages.StandardController sc = new ApexPages.StandardController(con);               
    ContactRecordTypeSelection_ext  permgenerate = new ContactRecordTypeSelection_ext (sc);
    permgenerate.selectedrecordtype= 'Contact';
    permgenerate.nextpage();
           
        Test.stopTest();
    }
     public static testmethod void checkrecordtype1()
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
                                          EEO_Gender__c = 'M'
                                         // P45_Date_by_Head_Office__c= System.today(),
                                         // IP_CategoryOfWork__c='Catering;Industrial'
                                     );
           
        insert con;
  
        Test.startTest();
     ApexPages.StandardController sc = new ApexPages.StandardController(con);               
    ContactRecordTypeSelection_ext  permgenerate = new ContactRecordTypeSelection_ext (sc);
    permgenerate.selectedrecordtype='Candidate';
    permgenerate.nextpage();
           
        Test.stopTest();
    }
}