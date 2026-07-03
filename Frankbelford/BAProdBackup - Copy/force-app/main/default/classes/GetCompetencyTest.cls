@isTest public class GetCompetencyTest {
      @testSetup
    static void test1()
    {
    
           Profile profile1 = [Select Id from Profile where name = 'JS Recruiter - Hybrid'];
        User testuser = new User(
           // UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test2@test.com',
            Alias = 'batman',
            Email='bruce.wayne@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
         Database.insert(testuser);
        
         User testuser2 = new User(
           // UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test2@test.com',
            Alias = 'batman',
            Email='bruce.wayne@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='TAJI',
            Lastname='TAJITEST',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
         Database.insert(testuser2);
        
        PermissionSet ps1 = [SELECT ID From PermissionSet WHERE Name = 'Branch_Managers'];
        // PermissionSet ps2 = [SELECT ID From PermissionSet WHERE Name='National_Regional_Managers' ];
    insert new PermissionSetAssignment(AssigneeId = testuser.id, PermissionSetId = ps1.Id );
    //    insert new PermissionSetAssignment(AssigneeId = testuser.id, PermissionSetId = ps2.Id );
        
    }
    
    static testMethod void testMethod1(){
     insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
 insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= true);
        
     //Profile P1=[SELECT Id FROM Profile WHERE Name='System Administrator' limit 1];
 
           
        Account acc1 = new Account();
        
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Client'];
        
        acc1.name='Vandita Kakkar';
        
        acc1.Phone='9818352973';
        
        acc1.BillingStreet='Street';
        
        acc1.IP_Business_Type__c='catering';
        
        acc1.BillingCity ='City';
        
        acc1.BillingPostalCode = '110075';
        
        acc1.BillingState='State';
        
        acc1.BillingCountry='Country';
        
        acc1.RecordTypeId=accountRec.id;
            acc1.IP_CompetencyRestriction__c=true;
        
        
        insert acc1;
        
        system.debug('Account');
        
        
        
        
        
        Account acc = new Account();
        
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate'];
        
        acc.Name='Candidates';
        
        acc.RecordTypeId=accountRec1.id;
        
        acc.Phone='9810078124';
        
        acc.BillingStreet='dwarka';
        
        acc.BillingCity ='delhi';
        
        acc.BillingPostalCode = '110072';
        
        acc.BillingState='new delhi';
        
        acc.BillingCountry='india';
        acc.IP_CompetencyRestriction__c=true;
        
        insert acc;
        
        
        system.debug('Account1');
        
        
        
        Recordtype recType = [Select id from Recordtype where sobjecttype='contact' and Name='Contact'];
        
        contact con2 = new contact();
        
        con2.RecordTypeId=recType.id;
        
        con2.AccountId=acc1.id;
        
        con2.FirstName='Vandita';
        
        con2.LastName='Kakkar';
        
       // con2.IP_ContactType__c='Invoice Contact';
        
        insert con2;
        
        
        RecordType contRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
        
        List<Contact> testContacts = new List<Contact>();
        for ( Integer i = 0 ; i < 6 ; i++ )
        {
            Contact contact = new Contact( Firstname='Test'+i,
                                          
                                          Lastname='Candidate'+i,
                                          
                                          accountId=acc.Id,
                                          
                                          Person_Status__c='Active',
                                          
                                          IP_CategoryOfWork__c='Catering',
                                          RecordTypeId=contRec.Id);
            
            
            testContacts.add(contact);
            
        }
        insert testContacts;
        
        system.debug('test data factory  Candidate--'+testContacts);
        
        
        IP_TopazGlobalClientInformation__c createtopaz = new IP_TopazGlobalClientInformation__c();
        
        createtopaz.name = 'Test';
        
        createtopaz.IP_StatusID__c = 1;
        
        createtopaz.IP_SalesLedgerNumber__c='110016';
        
        insert createtopaz;
        
        
        
        
        
        User user = new User();
        
     /*   DateTime dt2 = DateTime.newInstance(2017, 6, 23, 4, 2, 3);
        
        Long gettime = dt2.getTime();
        
        user.LastName = 'Sharma';
        
        user.FirstName='Abhinav';
        
        user.Alias = 'Abhsh';
        
        user.Email = 'abc.efg@gmail.com';
        
        user.Username = 'Email'+gettime+'@js.com.uk';
        
        user.ProfileId = P1.id;
        
        user.TimeZoneSidKey = 'GMT';
        
        user.LanguageLocaleKey = 'en_US';
        
        user.EmailEncodingKey = 'UTF-8';
        
        user.LocaleSidKey = 'en_US';
        
        user.IP_TempestDepartment__c='2043';
        
        user.IP_TempestID__c='1084675';
        
        user.IP_TempestDivision__c='NTS';
        
        user.Department='1069';
        
        user.IP_PassToTempest__c=true;
        
        insert user;
        
        system.debug('Value in user'+ user);*/
        
        
        
        
        
        sirenum__Rota__c sector = new sirenum__Rota__c();
        
        sector.Name = 'new sector';
        
        insert sector;
        
        
        
        sirenum__Site__c site1 = new sirenum__Site__c();
        
        site1.Name = 'testsite';
        
        site1.sirenum__Operating_Company__c= acc1.id;
        
        site1.IP_ClientIDLegacy__c='1234';
        
        site1.IP_ClientInvoiceName__c='Test Invoice';
        
        site1.IP_InvoiceAddressStreet__c='Test Street';
        
        site1.IP_PublicSector__c='No';
        
        site1.GlobalClientName__c= createtopaz.Id;
        
        site1.sirenum__Postal_Code__c='1246789';
        
        site1.sirenum__City__c='New Delhi';
        
        site1.IP_PublicSector__c='NO';
        
        site1.IP_MainContact__c=con2.id;
        
        site1.IP_InvoiceContact__c=con2.id;
        
      //  site1.OwnerId=user.id;
        
        site1.IP_InvoiceAddressCity__c='Delhi';
        
        insert site1;
        
        
        sirenum__Site__c site = new sirenum__Site__c();
        
        site.Name = 'testsite';
        
        site.sirenum__Operating_Company__c= acc1.id;
        
        site.IP_ClientIDLegacy__c='123';
        
        site.IP_ClientInvoiceName__c='Test Invoice';
        
        site.IP_InvoiceAddressStreet__c='Test Street';
        
        site.IP_PublicSector__c='No';
        
        site.GlobalClientName__c= createtopaz.Id;
        
        site.sirenum__Postal_Code__c='124678';
        
        site.sirenum__City__c='New Delhi';
        
        site.IP_PublicSector__c='NO';
        
        site.IP_MainContact__c=con2.id;
        
        site.IP_InvoiceContact__c=con2.id;
        
       // site.OwnerId=user.id;
        
        site.IP_InvoiceAddressCity__c='Delhi';
        
        insert site;
        
        
        system.debug('Value in site'+ site);
        
        
        
        
        
        sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
        
        contract.Name                 = 'test contract';
        
        contract.sirenum__Client__c   = acc1.id;
        
        contract.sirenum__Employee__c = testContacts[0].id;
        
        insert contract;
        
        
        
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
        
        jobroll.sirenum__Rota__c=sector.id;
        
        jobroll.sirenum__AWR_Group__c='Group 2';
        
        jobroll.IP_OPWIPSRole__c='No';
          insert jobroll;
        
       
        
      
         sirenum__TicketType__c CompetenceType =new sirenum__TicketType__c();
        CompetenceType.Name = 'Safety Boots';
        insert CompetenceType;
        
        sirenum__Sirenum_Condition_Membership__c something = new sirenum__Sirenum_Condition_Membership__c();
        something.sirenum__TicketType__c=CompetenceType.id;
        something.sirenum__Severity__c='High';
       something.sirenum__Site__c=site.id;
        insert something;
        
                sirenum__Sirenum_Condition_Membership__c something1 = new sirenum__Sirenum_Condition_Membership__c();
        something1.sirenum__TicketType__c=CompetenceType.id;
        something1.sirenum__Severity__c='High';
       something1.sirenum__Site__c=site.id;
        insert something1;
        
          sirenum__Sirenum_Condition_Membership__c competencyAcc = new sirenum__Sirenum_Condition_Membership__c();
        competencyAcc.sirenum__TicketType__c=CompetenceType.id;
        competencyAcc.sirenum__Severity__c='Medium';
        competencyAcc.sirenum__Client__c=acc1.id;
        insert competencyAcc;
        
        sirenum__Sirenum_Condition_Membership__c competencySite = new sirenum__Sirenum_Condition_Membership__c();
        competencySite.sirenum__TicketType__c=CompetenceType.id;
        competencySite.sirenum__Severity__c='Low';
        competencySite.sirenum__Site__c=site.id;
        insert competencySite;
        
            
        sirenum__Sirenum_Condition_Membership__c something2 = new sirenum__Sirenum_Condition_Membership__c();
        something2.sirenum__TicketType__c=CompetenceType.id;
        something2.sirenum__Severity__c='Low';
        something2.sirenum__Site__c=site.id;
         something2.sirenum__Team__c=null;
        insert something2;
        
        sirenum__Sirenum_Condition_Membership__c competencyJobRoledup = new sirenum__Sirenum_Condition_Membership__c();
        competencyJobRoledup.sirenum__TicketType__c=CompetenceType.id;
        competencyJobRoledup.sirenum__Severity__c='High';
        competencyJobRoledup.sirenum__Client__c=acc1.id;
        insert competencyJobRoledup;        
        
          Apexpages.StandardController sc = new Apexpages.standardController(site);
        ApexPages.currentPage().getParameters().put('Id', site.id);
        
 PermissionSetAssignment psm =[SELECT Id,PermissionSet.Name,AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Name IN ('National_Regional_Managers','Branch_Managers') Limit 1]; 
System.debug('psm '+psm);   
User u = [select id,Email from user where id=:psm.AssigneeId limit 1];   
        test.startTest();
        System.runAs(u){
        GetCompetency ext = new GetCompetency(sc);
        ext.newcomp.sirenum__TicketType__c = CompetenceType.id;
        ext.newcomp.sirenum__Severity__c = 'High';
        ext.newcomp.sirenum__Site__c =site.id;
        PageReference testPageResults1 = ext.validateRecord();
        }
         test.stopTest();
    }
    static testMethod void testMethod2(){
     insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
 insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= true);
          Profile P1=[SELECT Id FROM Profile WHERE Name='System Administrator' limit 1];
        Account acc1 = new Account();
        
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Client'];
        
        acc1.name='TestAccount1';
        
        acc1.Phone='012034563433';
        
        acc1.BillingStreet='Street1';
        
        acc1.IP_Business_Type__c='catering';
        
        acc1.BillingCity ='City1';
        
        acc1.BillingPostalCode = '101911';
        
        acc1.BillingState='State1';
        
        acc1.BillingCountry='Country1';
        
        acc1.RecordTypeId=accountRec.id;
        
        insert acc1;
        
        system.debug('Account Inserted');
        
        
        
        
        
        Account acc = new Account();
        
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate'];
        
        acc.Name='Candidates';
        
        acc.RecordTypeId=accountRec1.id;
        
        acc.Phone='012034563436';
        
        acc.BillingStreet='Street2';
        
        acc.BillingCity ='City2';
        
        acc.BillingPostalCode = '101912';
        
        acc.BillingState='State2';
        
        acc.BillingCountry='Country2';
        
        insert acc;
        
        system.debug('Account Inserted');
        
        
        
        Recordtype recType = [Select id from Recordtype where sobjecttype='contact' and Name='Contact'];
        
        contact con2 = new contact();
        
        con2.RecordTypeId=recType.id;
        
        con2.AccountId=acc1.id;
        
        con2.FirstName='Test';
        
        con2.LastName='Data';
        
     //   con2.IP_ContactType__c='Invoice Contact';
        
        insert con2;
        
        
        RecordType contRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
        
        List<Contact> testContacts = new List<Contact>();
        for ( Integer i = 0 ; i < 6 ; i++ )
        {
            Contact contact = new Contact( Firstname='Test'+i,
                                          
                                          Lastname='Candidate'+i,
                                          
                                          accountId=acc.Id,
                                          
                                          Person_Status__c='Active',
                                          
                                          IP_CategoryOfWork__c='Catering',
                                          
                                          
                                          
                                         
                                          
                                          RecordTypeId=contRec.Id);
            
            
            testContacts.add(contact);
            
        }
        insert testContacts;
        
        system.debug('test data factory  Candidate--'+testContacts);
        
        
        IP_TopazGlobalClientInformation__c createtopaz = new IP_TopazGlobalClientInformation__c();
        
        createtopaz.name = 'TestClient2';
        
        createtopaz.IP_StatusID__c = 1;
        
        createtopaz.IP_SalesLedgerNumber__c='123456';
        
        insert createtopaz;
        
        
        
        
        
        User user = new User();
        
      /*  DateTime dt2 = DateTime.newInstance(2017, 6, 23, 4, 2, 3);
        
        Long gettime = dt2.getTime();
        
        user.LastName = 'Data1';
        
        user.FirstName='TestUser';
        
        user.Alias = 'TstUrD';
        
        user.Email = 'abc.efg@GHI.com';
        
        user.Username = 'Email'+gettime+'@js.com.uk';
        
        user.ProfileId = P1.id;
        
        user.TimeZoneSidKey = 'GMT';
        
        user.LanguageLocaleKey = 'en_US';
        
        user.EmailEncodingKey = 'UTF-8';
        
        user.LocaleSidKey = 'en_US';
        
        user.IP_TempestDepartment__c='2043';
        
        user.IP_TempestID__c='1084675';
        
        user.IP_TempestDivision__c='NTS';
        
        user.Department='1069';
        
        user.IP_PassToTempest__c=true;
        
        insert user;
        
        system.debug('Value in user'+ user);*/
        

        
        
        
        sirenum__Rota__c sector = new sirenum__Rota__c();
        
        sector.Name = 'new sector';
        
        insert sector;
        
        
    
        
        sirenum__Site__c site = new sirenum__Site__c();
        
        site.Name = 'testsite';
        
        site.sirenum__Operating_Company__c= acc1.id;
        
        site.IP_ClientIDLegacy__c='123';
        
        site.IP_ClientInvoiceName__c='Test Invoice';
        
        site.IP_InvoiceAddressStreet__c='Test Street';
        
        site.IP_PublicSector__c='No';
        
        site.GlobalClientName__c= createtopaz.Id;
        
        site.sirenum__Postal_Code__c='124678';
        
        site.sirenum__City__c='New Delhi';
        
        site.IP_PublicSector__c='NO';
        
        site.IP_MainContact__c=con2.id;
        
        site.IP_InvoiceContact__c=con2.id;
        
       // site.OwnerId=user.id;
        
        site.IP_InvoiceAddressCity__c='Delhi';
        
        insert site;
        
        system.debug('Value'+ site);
        sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
        contract.Name                 = 'test contract';
        contract.sirenum__Client__c   = acc1.id;
        contract.sirenum__Employee__c = testContacts[0].id;
        insert contract;
        
        
        
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
        jobroll.sirenum__Rota__c=sector.id;
        jobroll.sirenum__AWR_Group__c='Group 2';
        jobroll.IP_OPWIPSRole__c='No';
        insert jobroll;
        
        sirenum__Team__c jobroll1 = new sirenum__Team__c();
        jobroll1.name = 'testjobroll';
        jobroll1.sirenum__Account__c = contract.id;
        jobroll1.sirenum__Job_Type__c = jobtype.id;
        jobroll1.sirenum__Rota__c=sector.id;
        jobroll1.sirenum__AWR_Group__c='Group 2';
        jobroll1.IP_OPWIPSRole__c='No';
        insert jobroll1;
        
           
        sirenum__Team__c jobroll2 = new sirenum__Team__c();
        jobroll2.name = 'testjobroll';
        jobroll2.sirenum__Account__c = contract.id;
        jobroll2.sirenum__Job_Type__c = jobtype.id;
        jobroll2.sirenum__Rota__c=sector.id;
        jobroll2.sirenum__AWR_Group__c='Group 2';
        jobroll2.IP_OPWIPSRole__c='No';
        insert jobroll2;
        
        sirenum__TicketType__c CompetenceType =new sirenum__TicketType__c();
        CompetenceType.Name = 'Test Competence 1';
        insert CompetenceType;
        
        sirenum__TicketType__c CompetenceType2 =new sirenum__TicketType__c();
        CompetenceType2.Name = 'Test Competence 2';
        insert CompetenceType2;
        
        sirenum__Sirenum_Condition_Membership__c competencyJobRole = new sirenum__Sirenum_Condition_Membership__c();
        competencyJobRole.sirenum__TicketType__c=CompetenceType.id;
        competencyJobRole.sirenum__Severity__c='High';
        competencyJobRole.sirenum__Team__c=jobroll.id;
        insert competencyJobRole;
        
        sirenum__Sirenum_Condition_Membership__c competencyAcc = new sirenum__Sirenum_Condition_Membership__c();
        competencyAcc.sirenum__TicketType__c=CompetenceType.id;
        competencyAcc.sirenum__Severity__c='Medium';
        competencyAcc.sirenum__Client__c=acc1.id;
        insert competencyAcc;
        
        sirenum__Sirenum_Condition_Membership__c competencySite = new sirenum__Sirenum_Condition_Membership__c();
        competencySite.sirenum__TicketType__c=CompetenceType.id;
        competencySite.sirenum__Severity__c='Low';
        competencySite.sirenum__Site__c=site.id;
        insert competencySite;
        
        sirenum__Sirenum_Condition_Membership__c competencyJobRoledup = new sirenum__Sirenum_Condition_Membership__c();
        competencyJobRoledup.sirenum__TicketType__c=CompetenceType.id;
        competencyJobRoledup.sirenum__Severity__c='High';
        competencyJobRoledup.sirenum__Client__c=acc1.id;
        insert competencyJobRoledup;
        test.startTest();
        Apexpages.StandardController sc = new Apexpages.standardController(site);
        ApexPages.currentPage().getParameters().put('Id', site.id);
        GetCompetency ext = new GetCompetency(sc);
        ext.newcomp.sirenum__TicketType__c = CompetenceType.id;
        ext.newcomp.sirenum__Severity__c = 'Medium';
        ext.newcomp.sirenum__Site__c =site.id;
        PageReference testPageResults1 = ext.validateRecord();
        test.stopTest();
    }
    static testMethod void testMethod3(){
     insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
 insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= true);
         Profile P1=[SELECT Id FROM Profile WHERE Name='System Administrator' limit 1];
        Account acc1 = new Account();
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Client'];
        acc1.name='TestAccount1';
        acc1.Phone='012034563433';
        acc1.BillingStreet='Street1';
        acc1.IP_Business_Type__c='catering';
        acc1.BillingCity ='City1';
        acc1.BillingPostalCode = '101911';
        acc1.BillingState='State1';
        acc1.BillingCountry='Country1';
        acc1.RecordTypeId=accountRec.id;
        insert acc1;
        system.debug('Account Inserted');
        
        Account acc = new Account();
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate'];
        acc.Name='Candidates';
        acc.RecordTypeId=accountRec1.id;
        acc.Phone='012034563436';
        acc.BillingStreet='Street2';
        acc.BillingCity ='City2';
        acc.BillingPostalCode = '101912';
        acc.BillingState='State2';
        acc.BillingCountry='Country2';
        insert acc;
        system.debug('Account Inserted');
        
        
        Recordtype recType = [Select id from Recordtype where sobjecttype='contact' and Name='Contact'];
        contact con2 = new contact();
        con2.RecordTypeId=recType.id;
        con2.AccountId=acc1.id;
        con2.FirstName='Test';
        con2.LastName='Data';
       // con2.IP_ContactType__c='Invoice Contact';
        insert con2;
        
        RecordType contRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
        List<Contact> testContacts = new List<Contact>();
        for ( Integer i = 0 ; i < 6 ; i++ )
        {
            Contact contact = new Contact( Firstname='Test'+i,
                                          Lastname='Candidate'+i,
                                          accountId=acc.Id,
                                          Person_Status__c='Active',
                                          IP_CategoryOfWork__c='Catering',
                                          
                                         
                                          RecordTypeId=contRec.Id);
            testContacts.add(contact);
            
        }
        insert testContacts;
        
        system.debug('test data factory  Candidate--'+testContacts);
        
        IP_TopazGlobalClientInformation__c createtopaz = new IP_TopazGlobalClientInformation__c();
        createtopaz.name = 'TestClient2';
        createtopaz.IP_StatusID__c = 1;
        createtopaz.IP_SalesLedgerNumber__c='123456';
        insert createtopaz;
        
        
        
        
        User user = new User();
      /*  DateTime dt2 = DateTime.newInstance(2017, 6, 23, 4, 2, 3);
        Long gettime = dt2.getTime();
        user.LastName = 'Data1';
        user.FirstName='TestUser';
        user.Alias = 'TstUrD';
        user.Email = 'abc.efg@GHI.com';
        user.Username = 'Email'+gettime+'@js.com.uk';
        user.ProfileId = P1.id;
        user.TimeZoneSidKey = 'GMT';
        user.LanguageLocaleKey = 'en_US';
        user.EmailEncodingKey = 'UTF-8';
        user.LocaleSidKey = 'en_US';
        user.IP_TempestDepartment__c='2043';
        user.IP_TempestID__c='1084675';
        user.IP_TempestDivision__c='NTS';
        user.Department='1069';
        user.IP_PassToTempest__c=true;
        insert user;
        
        system.debug('Value in user'+ user);*/
        sirenum__Rota__c sector = new sirenum__Rota__c();
        sector.Name = 'new sector';
        insert sector;
        
        
     
        
        sirenum__Site__c site = new sirenum__Site__c();
        site.Name = 'testsite';
        site.sirenum__Operating_Company__c= acc1.id;
        site.IP_ClientIDLegacy__c='123';
        site.IP_ClientInvoiceName__c='Test Invoice';
        site.IP_InvoiceAddressStreet__c='Test Street';
        site.IP_PublicSector__c='No';
        site.GlobalClientName__c= createtopaz.Id;
        site.sirenum__Postal_Code__c='124678';
        site.sirenum__City__c='New Delhi';
        site.IP_PublicSector__c='NO';
        site.IP_MainContact__c=con2.id;
        site.IP_InvoiceContact__c=con2.id;
      //  site.OwnerId=user.id;
        site.IP_InvoiceAddressCity__c='Delhi';
        insert site;
        
        system.debug('Value in site'+ site);
        sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
        contract.Name                 = 'test contract';
        contract.sirenum__Client__c   = acc1.id;
        contract.sirenum__Employee__c = testContacts[0].id;
        insert contract;
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
        jobroll.sirenum__Rota__c=sector.id;
        jobroll.sirenum__AWR_Group__c='Group 2';
        jobroll.IP_OPWIPSRole__c='No';
        insert jobroll;
        
        sirenum__TicketType__c CompetenceType =new sirenum__TicketType__c();
        CompetenceType.Name = 'Test Competence 1';
        insert CompetenceType;
        
        sirenum__TicketType__c CompetenceType2 =new sirenum__TicketType__c();
        CompetenceType2.Name = 'Test Competence 2';
        insert CompetenceType2;
        
        sirenum__Sirenum_Condition_Membership__c competencyJobRole = new sirenum__Sirenum_Condition_Membership__c();
        competencyJobRole.sirenum__TicketType__c=CompetenceType.id;
        competencyJobRole.sirenum__Severity__c='High';
        competencyJobRole.sirenum__Team__c=jobroll.id;
        insert competencyJobRole;
        
        sirenum__Sirenum_Condition_Membership__c competencyAcc = new sirenum__Sirenum_Condition_Membership__c();
        competencyAcc.sirenum__TicketType__c=CompetenceType.id;
        competencyAcc.sirenum__Severity__c='Medium';
        competencyAcc.sirenum__Client__c=acc1.id;
        insert competencyAcc;
        
        sirenum__Sirenum_Condition_Membership__c competencySite = new sirenum__Sirenum_Condition_Membership__c();
        competencySite.sirenum__TicketType__c=CompetenceType.id;
        competencySite.sirenum__Severity__c='Low';
        competencySite.sirenum__Site__c=site.id;
        insert competencySite;
        
        sirenum__Sirenum_Condition_Membership__c competencyJobRoledup = new sirenum__Sirenum_Condition_Membership__c();
        competencyJobRoledup.sirenum__TicketType__c=CompetenceType.id;
        competencyJobRoledup.sirenum__Severity__c='High';
        competencyJobRoledup.sirenum__Client__c=acc1.id;
        insert competencyJobRoledup;
        test.startTest();
        Apexpages.StandardController sc = new Apexpages.standardController(site);
        ApexPages.currentPage().getParameters().put('Id', site.id);
        GetCompetency ext = new GetCompetency(sc);
        ext.newcomp.sirenum__TicketType__c = CompetenceType2.id;
        ext.newcomp.sirenum__Severity__c = 'Medium';
        ext.newcomp.sirenum__Site__c =site.id;
        PageReference testPageResults1 = ext.SaveAndNew();
        test.stopTest();
    }
    
    static testMethod void testMethod4(){
     insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
 insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= true);
          Profile P1=[SELECT Id FROM Profile WHERE Name='System Administrator' limit 1];
        Account acc1 = new Account();
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Client'];
        acc1.name='TestAccount1';
        acc1.Phone='012034563433';
        acc1.BillingStreet='Street1';
        acc1.IP_Business_Type__c='catering';
        acc1.BillingCity ='City1';
        acc1.BillingPostalCode = '101911';
        acc1.BillingState='State1';
        acc1.BillingCountry='Country1';
        acc1.RecordTypeId=accountRec.id;
        insert acc1;
        system.debug('Account Inserted');
        
        Account acc = new Account();
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate'];
        acc.Name='Candidates';
        acc.RecordTypeId=accountRec1.id;
        acc.Phone='012034563436';
        acc.BillingStreet='Street2';
        acc.BillingCity ='City2';
        acc.BillingPostalCode = '101912';
        acc.BillingState='State2';
        acc.BillingCountry='Country2';
        insert acc;
        system.debug('Account Inserted');
        
        
        Recordtype recType = [Select id from Recordtype where sobjecttype='contact' and Name='Contact'];
        contact con2 = new contact();
        con2.RecordTypeId=recType.id;
        con2.AccountId=acc1.id;
        con2.FirstName='Test';
        con2.LastName='Data';
      //  con2.IP_ContactType__c='Invoice Contact';
        insert con2;
        
        RecordType contRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
        List<Contact> testContacts = new List<Contact>();
        for ( Integer i = 0 ; i < 6 ; i++ )
        {
            Contact contact = new Contact( Firstname='Test'+i,
                                          Lastname='Candidate'+i,
                                          accountId=acc.Id,
                                          Person_Status__c='Active',
                                          IP_CategoryOfWork__c='Catering',
                                          
                                         
                                          RecordTypeId=contRec.Id);
            testContacts.add(contact);
            
        }
        insert testContacts;
        
        system.debug('test data factory  Candidate--'+testContacts);
        
        IP_TopazGlobalClientInformation__c createtopaz = new IP_TopazGlobalClientInformation__c();
        createtopaz.name = 'TestClient2';
        createtopaz.IP_StatusID__c = 1;
        createtopaz.IP_SalesLedgerNumber__c='123456';
        insert createtopaz;
        
        
        
        
        User user = new User();
     /*   DateTime dt2 = DateTime.newInstance(2017, 6, 23, 4, 2, 3);
        Long gettime = dt2.getTime();
        user.LastName = 'Data1';
        user.FirstName='TestUser';
        user.Alias = 'TstUrD';
        user.Email = 'abc.efg@GHI.com';
        user.Username = 'Email'+gettime+'@js.com.uk';
        user.ProfileId = P1.id;
        user.TimeZoneSidKey = 'GMT';
        user.LanguageLocaleKey = 'en_US';
        user.EmailEncodingKey = 'UTF-8';
        user.LocaleSidKey = 'en_US';
        user.IP_TempestDepartment__c='2043';
        user.IP_TempestID__c='1084675';
        user.IP_TempestDivision__c='NTS';
        user.Department='1069';
        user.IP_PassToTempest__c=true;
        insert user;
        
        system.debug('Value in user'+ user);*/
        sirenum__Rota__c sector = new sirenum__Rota__c();
        sector.Name = 'new sector';
        insert sector;
        
             
        sirenum__Site__c site = new sirenum__Site__c();
        site.Name = 'testsite';
        site.sirenum__Operating_Company__c= acc1.id;
        site.IP_ClientIDLegacy__c='123';
        site.IP_ClientInvoiceName__c='Test Invoice';
        site.IP_InvoiceAddressStreet__c='Test Street';
        site.IP_PublicSector__c='No';
        site.GlobalClientName__c= createtopaz.Id;
        site.sirenum__Postal_Code__c='124678';
        site.sirenum__City__c='New Delhi';
        site.IP_PublicSector__c='NO';
        site.IP_MainContact__c=con2.id;
        site.IP_InvoiceContact__c=con2.id;
       // site.OwnerId=user.id;
        site.IP_InvoiceAddressCity__c='Delhi';
        insert site;
           sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
        contract.Name                 = 'test contract';
        contract.sirenum__Client__c   = acc1.id;
        contract.sirenum__Employee__c = testContacts[0].id;
        insert contract;
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
        jobroll.sirenum__Rota__c=sector.id;
        jobroll.sirenum__AWR_Group__c='Group 2';
        jobroll.IP_OPWIPSRole__c='No';
        insert jobroll;
        
        sirenum__TicketType__c CompetenceType =new sirenum__TicketType__c();
        CompetenceType.Name = 'Test Competence 1';
        insert CompetenceType;
        
        sirenum__TicketType__c CompetenceType2 =new sirenum__TicketType__c();
        CompetenceType2.Name = 'Test Competence 2';
        insert CompetenceType2;
        
        sirenum__Sirenum_Condition_Membership__c competencyJobRole = new sirenum__Sirenum_Condition_Membership__c();
        competencyJobRole.sirenum__TicketType__c=CompetenceType.id;
        competencyJobRole.sirenum__Severity__c='High';
        competencyJobRole.sirenum__Team__c=jobroll.id;
        insert competencyJobRole;
        
        sirenum__Sirenum_Condition_Membership__c competencyAcc = new sirenum__Sirenum_Condition_Membership__c();
        competencyAcc.sirenum__TicketType__c=CompetenceType.id;
        competencyAcc.sirenum__Severity__c='Medium';
        competencyAcc.sirenum__Rota__c=sector.id;
        insert competencyAcc;
        test.startTest();
        Apexpages.StandardController sc = new Apexpages.standardController(site);
        ApexPages.currentPage().getParameters().put('Id', site.id);
        GetCompetency ext = new GetCompetency(sc);
        ext.newcomp.sirenum__TicketType__c = CompetenceType.id;
        ext.newcomp.sirenum__Severity__c = 'Medium';
        ext.newcomp.sirenum__Site__c =site.id;
        PageReference testPageResults1 = ext.SaveAndNew();
        test.stopTest();
 

    }
    static testMethod void testMethod5(){
     insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
 insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= true);
          Profile P1=[SELECT Id FROM Profile WHERE Name='System Administrator' limit 1];
        Account acc1 = new Account();
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Client'];
        acc1.name='TestAccount1';
        acc1.Phone='012034563433';
        acc1.BillingStreet='Street1';
        acc1.IP_Business_Type__c='catering';
        acc1.BillingCity ='City1';
        acc1.BillingPostalCode = '101911';
        acc1.BillingState='State1';
        acc1.BillingCountry='Country1';
        acc1.RecordTypeId=accountRec.id;
        insert acc1;
        system.debug('Account Inserted');
        
        Account acc = new Account();
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate'];
        acc.Name='Candidates';
        acc.RecordTypeId=accountRec1.id;
        acc.Phone='012034563436';
        acc.BillingStreet='Street2';
        acc.BillingCity ='City2';
        acc.BillingPostalCode = '101912';
        acc.BillingState='State2';
        acc.BillingCountry='Country2';
        insert acc;
        system.debug('Account Inserted');
        
        
        Recordtype recType = [Select id from Recordtype where sobjecttype='contact' and Name='Contact'];
        contact con2 = new contact();
        con2.RecordTypeId=recType.id;
        con2.AccountId=acc1.id;
        con2.FirstName='Test';
        con2.LastName='Data';
       // con2.IP_ContactType__c='Invoice Contact';
        insert con2;
        
        RecordType contRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
        List<Contact> testContacts = new List<Contact>();
        for ( Integer i = 0 ; i < 6 ; i++ )
        {
            Contact contact = new Contact( Firstname='Test'+i,
                                          Lastname='Candidate'+i,
                                          accountId=acc.Id,
                                          Person_Status__c='Active',
                                          IP_CategoryOfWork__c='Catering',
                                          
                                         
                                          RecordTypeId=contRec.Id);
            testContacts.add(contact);
            
        }
        insert testContacts;
        
        system.debug('test data factory  Candidate--'+testContacts);
        
        IP_TopazGlobalClientInformation__c createtopaz = new IP_TopazGlobalClientInformation__c();
        createtopaz.name = 'TestClient2';
        createtopaz.IP_StatusID__c = 1;
        createtopaz.IP_SalesLedgerNumber__c='123456';
        insert createtopaz;
        
        
        
        
        User user = new User();
     /*   DateTime dt2 = DateTime.newInstance(2017, 6, 23, 4, 2, 3);
        Long gettime = dt2.getTime();
        user.LastName = 'Data1';
        user.FirstName='TestUser';
        user.Alias = 'TstUrD';
        user.Email = 'abc.efg@GHI.com';
        user.Username = 'Email'+gettime+'@js.com.uk';
        user.ProfileId = P1.id;
        user.TimeZoneSidKey = 'GMT';
        user.LanguageLocaleKey = 'en_US';
        user.EmailEncodingKey = 'UTF-8';
        user.LocaleSidKey = 'en_US';
        user.IP_TempestDepartment__c='2043';
        user.IP_TempestID__c='1084675';
        user.IP_TempestDivision__c='NTS';
        user.Department='1069';
        user.IP_PassToTempest__c=true;
        insert user;
        
        system.debug('Value in user'+ user);*/
        sirenum__Rota__c sector = new sirenum__Rota__c();
        sector.Name = 'new sector';
        
        insert sector;
        
             
        sirenum__Site__c site = new sirenum__Site__c();
        site.Name = 'testsite';
        site.sirenum__Operating_Company__c= acc1.id;
        site.IP_ClientIDLegacy__c='123';
        site.IP_ClientInvoiceName__c='Test Invoice';
        site.IP_InvoiceAddressStreet__c='Test Street';
        site.IP_PublicSector__c='No';
        site.GlobalClientName__c= createtopaz.Id;
        site.sirenum__Postal_Code__c='124678';
        site.sirenum__City__c='New Delhi';
        site.IP_PublicSector__c='NO';
        site.IP_MainContact__c=con2.id;
        site.IP_InvoiceContact__c=con2.id;
       // site.OwnerId=user.id;
        site.IP_InvoiceAddressCity__c='Delhi';
        insert site;
           sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
        contract.Name                 = 'test contract';
        contract.sirenum__Client__c   = acc1.id;
        contract.sirenum__Employee__c = testContacts[0].id;
        insert contract;
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
        jobroll.sirenum__Rota__c=sector.id;
        jobroll.sirenum__AWR_Group__c='Group 2';
        jobroll.IP_OPWIPSRole__c='No';
        insert jobroll;
        
        sirenum__TicketType__c CompetenceType =new sirenum__TicketType__c();
        CompetenceType.Name = 'Test Competence 1';
        insert CompetenceType;
        
        sirenum__TicketType__c CompetenceType2 =new sirenum__TicketType__c();
        CompetenceType2.Name = 'Test Competence 2';
        insert CompetenceType2;
        
        sirenum__Sirenum_Condition_Membership__c competencyJobRole = new sirenum__Sirenum_Condition_Membership__c();
        competencyJobRole.sirenum__TicketType__c=CompetenceType.id;
        competencyJobRole.sirenum__Severity__c='High';
        competencyJobRole.sirenum__Team__c=jobroll.id;
        insert competencyJobRole;
        
        sirenum__Sirenum_Condition_Membership__c competencyAcc = new sirenum__Sirenum_Condition_Membership__c();
        competencyAcc.sirenum__TicketType__c=CompetenceType.id;
        competencyAcc.sirenum__Severity__c='Medium';
        competencyAcc.sirenum__Rota__c=sector.id;
        insert competencyAcc;
        test.startTest();
        Apexpages.StandardController sc = new Apexpages.standardController(site);
        ApexPages.currentPage().getParameters().put('Id', site.id);
        GetCompetency ext = new GetCompetency(sc);
        ext.newcomp.sirenum__TicketType__c = CompetenceType2.id;
        ext.newcomp.sirenum__Severity__c = 'Medium';
        ext.newcomp.sirenum__Site__c =site.id;
        PageReference testPageResults1 = ext.validateRecord();
        test.stopTest();
 

    }
    }