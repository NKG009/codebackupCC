@IsTest 
public class Test_ContactTriggerHandler {
    
    //jyothi.start
    @IsTest
    public static void UpdatePayProfileTest(){
        Id profileId = [SELECT Id from Profile Where Name ='System Administrator' limit 1].Id ;
        User consultantUser = TestDataFactory.createUsers(profileId, 1)[0];
        consultantUser.IP_TempestDepartment__c = '1107';
        insert consultantUser;
        system.runAs(consultantUser){
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Candidate').getRecordTypeId();
            Account account1 = new Account(Name='Candidates',RecordTypeId=accRecId);
            insert account1;
    
            insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = false);
            insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = true);
    
            Id condRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Candidate').getRecordTypeId();
            
            Contact con = new Contact(AccountID = account1.id, 
                RecordTypeId=condRecId,
                FirstName ='ABC',
                Salutation ='Mr',
                IP_LastPassedToTempest2ndTier__c = system.Now(),
                MailingCity='ggn',
                MailingCountry='india',
                MailingPostalCode='110092',
                MailingState='Haryana',
                LastName ='XYZ',  
                sirenum__National_Insurance__c='AA323232A', 
                IP_CandidateIDlegacy__c='test123',
                MailingStreet='abc',
                P45_Requested__c=true,
                PayrollLeaver__c=null,
                Title = 'TestLastName1',
                Initials__c = 'TestLastName1',
                Birthdate = Date.valueOf('1992-02-20'),
                Phone = '9879879877',
                ts2__EEO_Gender__c = 'M',
                // P45_Date_by_Head_Office__c= System.today(),
                IP_CategoryOfWork__c='Catering' );
    
            insert con;
                    
            Id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('PAYE').getRecordTypeId();
    
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
            
            test.startTest();
            PersonProcessBuilder.UpdatePass2ndtiertoTempest(new Set<Id>{con.id});  
            PersonProcessBuilder.UpdatepayProfile(new Set<Id>{con.id});              
            PersonProcessBuilder.UpdatepayepayProfile(new Set<Id>{con.id});
            test.stopTest();
        }
    }
    //jyothi.stop
    @IsTest
    public static void createContact() {
  //       RecordType contRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'IP_2ndTierCandidate'];
   
     List<Account> acc = TestDataFactory.createCandidateAccount(1);
        insert acc;
        TestDataFactory.setupUserProfileCustomSettings();
        TestDataFactory.setupCustomSettings(acc[0].Id);
        
        List<Contact> con =  TestDataFactory.createCandidate(acc[0].id, 1) ;
        insert con;


        
        List<Account> acct = TestDataFactory.create2ndTierSupplierAccount(1); 
        insert acct;
        List<Contact> con2 =  TestDataFactory.createCandidate2ndTier(acct[0].id, 1) ;
        insert con2;
        
           insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
        IP_PayProfile__c payProfile = TestDataFactory.createPayProfilePaye(con[0].id,1)[0];
        insert payProfile;
        
         checkRecursivecontact.run=true;
        
        con[0].MailingStreet = 'qqqqqqqqqqqqqqqqqqq qqqqqqqqqqqqqqqqqqqqq qqqqqqqqqqqqqqq qqqqqqqqqqqqqqqqqqqqq qqqqqqqqq qqqqqqqqqqqqqqqq qqqqqqqqqqqq qqqqqqqqq';
        update con;
        
        con[0].MailingStreet = 'qqqqqqqqqq qqqqqqqqqqqqqq qqqqqqqqqq qqqqqqqqqqqqqqqqqq qqqqqqqqqqqqqqqq qqqqqqqqqqqq';
        update con;
        
        con[0].MailingStreet = 'qqqqqqqqqqq qqqqqqqqqqqqqqq qqqqqqqqqqq qqqqqqqq';
        update con;
        
        con[0].MailingStreet = 'qqqqqqqq qqqqqqqqq';
        update con;
        
        system.debug('IN TEST '+con2[0].RecordTypeId);
        system.debug('IN TEST '+con2[0].IP_MailingAddressLine3__c);
       con2[0].MailingStreet = 'qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq';
       con2[0].IP_LastPassedToTempest2ndTier__c =datetime.newInstance(2014, 9, 15, 12, 30, 0);

       update con2;
        
     
        
        delete con;
    } 
}