@isTest
private class Test_CPMySkills {
    @testSetup 
    static void sSetup() {
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile pProfile = [Select Id from Profile where name = 'System Administrator'];
        User userP = new User(Username = System.now().millisecond() + 'portalUser123@test.com', ProfileId = pProfile.Id,
                              UserRoleId = portalRole.Id, Alias = 'pt123', Email = 'manish.mishra@espire.com', EmailEncodingKey = 'UTF-8', LastName = 'l4848',
                              CommunityNickname = 'chec', IP_TempestDepartment__c='1062',IP_TempestID__c='1062',
                              IP_TempestDivision__c='NTS',Department='1062',IP_PassToTempest__c=true, TimeZoneSidKey = 'GMT', LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US');
        insert userP;   
        contact con;
        Contact c1 ;
        sirenum__Timesheet__c sts;
        System.runAs(userP) {
            Account acc1 = new Account(Name = 'TestAccount', OwnerId = userP.Id );
            insert acc1;
                    insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);

            c1 = new Contact( FirstName = 'tt', Lastname = 'mm', AccountId = acc1.Id, Email = System.now().millisecond() + 'as@test.com');
            Database.insert(c1);            
        }
        
        Profile dProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User userd = new User( Username = System.now().millisecond() + 'portalUser123@test.com',    ProfileId = dProfile.Id,
                              Alias = 'klkl', Email = 'user1@espire.com', EmailEncodingKey = 'UTF-8', LastName = 'lnamemm',
                              ContactId=c1.id, CommunityNickname = 'checked', TimeZoneSidKey = 'America/Los_Angeles', 
                              LocaleSidKey = 'en_US', LanguageLocaleKey = 'en_US');
        Database.insert(userd);                       
    }
    @isTest
    static void get_skills(){
       // User u = [select id , contactId from user where lastname = 'lnamemm' limit 1];
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate'];     
        Account client = new Account(Name='candidates',RecordTypeId=accountRec.id);
        Database.insert(client);
        
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Client']; 
        Account Clnt = new Account(IP_Business_Type__c='Catering', Name='Client Name', RecordTypeId=accountRec1.id);    
        Database.insert(Clnt);    
        
        RecordType accRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
        Account acct = new Account(IP_Business_Type__c ='Catering', Name = 'Account Name', RecordTypeId=accRec.id, IP_BusinessIncorporationNumber__c='12345678');    
        Database.insert(acct);
                insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);

        RecordType contRec1 = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
        Contact cont = new Contact(FirstName = 'cFirstName', LastName = 'cLastName', AccountID = acct.Id, RecordTypeId = contRec1.Id,  MailingStreet = 'Mailing Street details', Salutation='Mr', MailingPostalCode='hgf 23', sirenum__National_Insurance__c='AA123456A', EEO_Gender__c='M', Birthdate =Date.newInstance(2000, 12, 9));            
        Database.insert(cont);
        
        RecordType condRec22 = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
        Contact cond = new Contact(AccountID = acct.Id, RecordTypeId=condRec22.id, FirstName ='Manish', Salutation ='Mr', MailingCity='ggn',
                                   MailingCountry='india', MailingPostalCode='110092', MailingState='Haryana', LastName ='candidate',
                                   sirenum__National_Insurance__c='AA323232A', IP_CandidateIDlegacy__c='dsdsdsdd', MailingStreet='abc',
                                   P45_Requested__c=true, PayrollLeaver__c=null, Title = 'TestLastName', Initials__c = 'TestLastName',
                                   Birthdate = Date.valueOf('1990-02-20'), Phone = '9879879877', EEO_Gender__c = 'M', IP_CategoryOfWork__c='Catering;Industrial' );              
        Database.insert(cond);    
        sirenum__TicketType__c TT = new sirenum__TicketType__c(Name='test type');
        insert TT;
        sirenum__Ticket__c Competency = new sirenum__Ticket__c(sirenum__TicketType__c=TT.Id,
                                                               sirenum__Owner__c=cond.Id,
                                                               sirenum__Valid_from__c=system.today(),
                                                               sirenum__Valid_until__c=system.today()
                                                              );
        insert Competency;
                    insert new IP_Shift_Template__c(name = '1062', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='1234',Branch_Address__c='street1',Email__c='singh.taji26@gmail.com',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');
        String comments='me and my luck';
         Profile dProfile = [SELECT Id FROM Profile WHERE Name LIKE '%User Portal%' Limit 1];
        User userd = new User( Username = System.now().millisecond() + 'portalUserjhh123@test.com',    ProfileId = dProfile.Id,
                              Alias = 'lkhftvd', Email = 'Testuser1utu@espire.com', EmailEncodingKey = 'UTF-8', LastName = 'ljhjhnamemm',
                              ContactId=cond.id, CommunityNickname = 'checkedtest', TimeZoneSidKey = 'America/Los_Angeles', 
                              LocaleSidKey = 'en_US', LanguageLocaleKey = 'en_US');
        Database.insert(userd); 
        System.runAs(userd) {
            CPMySkills.getSkills();
            CPMySkills.sendQuery(comments);
        }
        
    }
}