@isTest
public class Test_RestrictEditActionController {
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
         PermissionSet ps2 = [SELECT ID From PermissionSet WHERE Name='National_Regional_Managers' ];
        insert new PermissionSetAssignment(AssigneeId = testuser.id, PermissionSetId = ps1.Id );
        insert new PermissionSetAssignment(AssigneeId = testuser.id, PermissionSetId = ps2.Id );
        
    }
    
    static testmethod void restrictTest1()
    {
      insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = true);
         RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
    RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
 Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
         
        insert acc1;
     Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id, IP_CompetencyRestriction__c = True);
          insert acc;
     Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc.id);
      
        insert maincon;
        
        
       

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
         
         
          IP_TopazGlobalClientInformation__c globalclient = new IP_TopazGlobalClientInformation__c();
        globalclient.Name='Test global topaz';
        globalclient.IP_StatusID__c=2;
       globalclient.IP_SalesLedgerNumber__c='123';
         insert globalclient;
         
              sirenum__Site__c site = new sirenum__Site__c();
         
         site.Name = 'testsite';
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
         jobtype.name = 'testjobtype';
         jobtype.Impellam_Sector__c = sector.id;
         jobtype.Impellam_Core_Category__c = 'Administration -ADM';
         jobtype.Impellam_Job_Category__c ='Administrator -OA001';
         
         insert jobtype;
         
         sirenum__Team__c jobroll = new sirenum__Team__c();
         
         jobroll.name = 'testjobroll';
         jobroll.sirenum__Account__c = contract.id; 
         jobroll.sirenum__Job_Type__c = jobtype.id;
         jobroll.IP_OPWIPSRole__c = 'No';
         insert jobroll; 
        
        sirenum__TicketType__c cmp = new sirenum__TicketType__c();
        cmp.name = 'Test Comp';
        insert cmp;
        
        sirenum__Sirenum_Condition_Membership__c comp = new sirenum__Sirenum_Condition_Membership__c();
        comp.sirenum__Severity__c = 'Fatal';
        comp.sirenum__Team__c = jobroll.id;
        comp.sirenum__TicketType__c = cmp.Id;
        insert comp;
         
PermissionSetAssignment psm =[SELECT Id,PermissionSet.Name,AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Name IN ('National_Regional_Managers','Branch_Managers') Limit 1]; 
System.debug('psm '+psm);   
User u = [select id,Email from user where id=:psm.AssigneeId limit 1];   
        PageReference pageRef = Page.RestrictDeleteAction;
        pageRef.getParameters().put('retURL','/'+jobroll.id);
        pageRef.getParameters().put('id',comp.Id);
        Test.setCurrentPage(pageRef);

        Test.startTest();
          System.runAs(u) {
        ApexPages.StandardController sc = new ApexPages.StandardController(comp);
       RestrictEditActionController rst = new RestrictEditActionController(sc);
       rst.deletemethod();
          }
        Test.stopTest();

    }
    
     static testmethod void restrictTest2()
    {
      insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = true);

         RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
    RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
 Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
         
        insert acc1;
     Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id, IP_CompetencyRestriction__c = True);
          insert acc;
     Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc.id);
      
        insert maincon;
        
        
       
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
         
         
          IP_TopazGlobalClientInformation__c globalclient = new IP_TopazGlobalClientInformation__c();
        globalclient.Name='Test global topaz';
        globalclient.IP_StatusID__c=2;
       globalclient.IP_SalesLedgerNumber__c='123';
         insert globalclient;
         
              sirenum__Site__c site = new sirenum__Site__c();
         
         site.Name = 'testsite';
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
         jobtype.name = 'testjobtype';
         jobtype.Impellam_Sector__c = sector.id;
         jobtype.Impellam_Core_Category__c = 'Administration -ADM';
         jobtype.Impellam_Job_Category__c ='Administrator -OA001';
         
         insert jobtype;
         
         sirenum__Team__c jobroll = new sirenum__Team__c();
         
         jobroll.name = 'testjobroll';
         jobroll.sirenum__Account__c = contract.id; 
         jobroll.sirenum__Job_Type__c = jobtype.id;
         jobroll.IP_OPWIPSRole__c = 'No';
         insert jobroll; 
        
        sirenum__TicketType__c cmp = new sirenum__TicketType__c();
        cmp.name = 'Test Comp';
        insert cmp;
        
        sirenum__Sirenum_Condition_Membership__c comp = new sirenum__Sirenum_Condition_Membership__c();
        comp.sirenum__Severity__c = 'Fatal';
        comp.sirenum__Team__c = jobroll.id;
        comp.sirenum__TicketType__c = cmp.Id;
        insert comp;
        
        PageReference pageRef = Page.RestrictDeleteAction;
        pageRef.getParameters().put('retURL','/'+jobroll.id);
        pageRef.getParameters().put('ID',comp.Id);
        Test.setCurrentPage(pageRef);

        Test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(comp);
       RestrictEditActionController rst = new RestrictEditActionController(sc);
       rst.Updaterecord();
        
        Test.stopTest();

    }
    
      static testmethod void restrictTest3()
    {
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
  
     Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id, IP_CompetencyRestriction__c = True);
          insert acc;
   
        
        sirenum__TicketType__c cmp = new sirenum__TicketType__c();
        cmp.name = 'Test Comp';
        insert cmp;
        
        sirenum__Sirenum_Condition_Membership__c comp = new sirenum__Sirenum_Condition_Membership__c();
        comp.sirenum__Severity__c = 'Fatal';
        comp.sirenum__Client__c = acc.id;
        comp.sirenum__TicketType__c = cmp.Id;
        insert comp;
        
        PageReference pageRef = Page.RestrictDeleteAction;
        pageRef.getParameters().put('retURL','/'+acc.id);
        pageRef.getParameters().put('id',comp.Id);
        Test.setCurrentPage(pageRef);

        Test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(comp);
       RestrictEditActionController rst = new RestrictEditActionController(sc);
       rst.Updaterecord();
       rst.move(); 
        Test.stopTest();

    }
    
  
}