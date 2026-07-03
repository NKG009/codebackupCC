@isTest public class UncontactedCandidateRemovalTest {
    static testMethod void testMethod1(){
            Date dt = System.today();   
     Date dt1 = dt.addDays(-10); 
        Profile P1=[SELECT Id FROM Profile WHERE Name='JS Recruiter - Hybrid' limit 1];
insert new IP_ImpellamGDPRSettings__c (Name='Impellam GDPR settings',IP_ActivityTypesThatQualifyAsContact__c='Visit,Registration,General Call ,Send Email ,Send Contract',IP_UncontactedCandidateRetentionPeriod__c=-10); 
          Account acc =  TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
        
        Account acc1 = TestDataFactory.createClients(1)[0];
        insert acc1;
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        Recordtype rt= [Select id from Recordtype where sobjecttype='contact' and Name='Candidate'];
        contact con = new contact();
        con.IP_GDPRContactedCandidate__c=FALSE;
        //con.CreatedDate=dt1;
        //con.IP_MarkedForDeletion__c=NULL;
        con.IP_Consent_from_Data_Store__c=NULL;
        con.RecordTypeId=rt.id;
        con.AccountId=acc.id;
        con.FirstName='Vandita';
        con.LastName='Kakkar';
        insert con;
        
         contact con2 = new contact();
        con2.IP_GDPRContactedCandidate__c=FALSE;
        //con.CreatedDate=dt1;
        //con.IP_MarkedForDeletion__c=NULL;
        con2.IP_Consent_from_Data_Store__c=NULL;
        con2.RecordTypeId=rt.id;
        con2.AccountId=acc.id;
        con2.FirstName='Vandita42';
        con2.LastName='Kakkar123';
        insert con2;
        
          contact con3 = new contact();
        con2.IP_GDPRContactedCandidate__c=FALSE;
        //con.CreatedDate=dt1;
        //con.IP_MarkedForDeletion__c=NULL;
        con3.IP_Consent_from_Data_Store__c=NULL;
        con3.RecordTypeId=rt.id;
        con3.AccountId=acc.id;
        con3.FirstName='Vandita421';
        con3.LastName='Kakkar1234';
        insert con3;
        
          contact con4 = new contact();
        con2.IP_GDPRContactedCandidate__c=FALSE;
        //con.CreatedDate=dt1;
        //con.IP_MarkedForDeletion__c=NULL;
        con4.IP_Consent_from_Data_Store__c=NULL;
        con4.RecordTypeId=rt.id;
        con4.AccountId=acc.id;
        con4.FirstName='Vandita4211';
        con4.LastName='Kakkar12345';
        insert con4;
        
        Recordtype rt1= [Select id from Recordtype where sobjecttype='contact' and Name='Contact'];
        contact con1 = new contact();
       // con.IP_GDPRContactedCandidate__c=FALSE;
        //con.CreatedDate=dt1;
        //con.IP_MarkedForDeletion__c=NULL;
      //  con.IP_Consent_from_Data_Store__c=NULL;
        con1.RecordTypeId=rt1.id;
        con1.AccountId=acc1.id;
        con1.FirstName='Vandita Test';
        con1.LastName='Kakkar Test';
       // con1.IP_ContactType__c='Invoice Contact';
        insert con1;
        
        Task activitylinked=new Task ();
        activitylinked.IP_ActivityType__c='Visit';
        activitylinked.Subject = 'Call';
        //activitylinked.AccountId=acc.id;
        activitylinked.WhoId=con.id;
        insert activitylinked;
        
          IP_TopazGlobalClientInformation__c createtopaz = new IP_TopazGlobalClientInformation__c();
        createtopaz.name = 'TestClient2';
        createtopaz.IP_StatusID__c = 1;
        createtopaz.IP_SalesLedgerNumber__c='123456';
        insert createtopaz;
        
        
        User user = new User();
        DateTime dt2 = DateTime.newInstance(2017, 6, 23, 4, 2, 3);
        Long gettime = dt2.getTime();
        user.LastName = 'Virmani';
        user.FirstName='Swati';
        user.Alias = 'svir';
        user.Email = 'swati.virmani@outlook.com';
        user.Username = 'Email'+gettime+'@js.com.uk';
        user.ProfileId = P1.id; 
        user.TimeZoneSidKey = 'GMT';
        user.LanguageLocaleKey = 'en_US';
        user.EmailEncodingKey = 'UTF-8'; 
        user.LocaleSidKey = 'en_US';
        user.IP_TempestDepartment__c='2043';
        user.IP_TempestID__c='1084675';
       // user.IP_TempestDivision__c='NTS';
        user.Department='1069';
       // user.IP_PassToTempest__c=true;
        insert user;
        system.debug('Value in user'+ user); 
        
        sirenum__Site__c site = new sirenum__Site__c();
        
        site.Name = 'NewSite';
        site.sirenum__Operating_Company__c= acc1.id;
        site.IP_ClientIDLegacy__c ='QAWWSED34';
        site.IP_ClientInvoiceName__c='Test Invoice';
        site.IP_InvoiceAddressStreet__c='Test Street';
        site.IP_PublicSector__c='No';
        site.GlobalClientName__c= createtopaz.Id;
        //site.IP_PassClientToTempest__c=true;
        //site.IP_ClientLastPassedToTempest__c=null;
        //site.IP_PassClientAddressToTempest__c=true;
        site.sirenum__Postal_Code__c='124678';
        site.sirenum__City__c='New Delhi';
        site.IP_PublicSector__c='NO';
  // site.IP_TempestDepartment__c ='2043';
       // site.IP_TempestDivision__c='1234';
     site.IP_MainContact__c=con1.id;
        site.IP_InvoiceContact__c=con1.id;
       // site.IP_PreAWRWTRValue__c=4;
       // site.IP_PostAWRWTRValue__c=5;
        site.OwnerId=user.id;
        site.IP_InvoiceAddressCity__c='Delhi';
        insert site;
        system.debug('Value in site'+ site);
        
        
        sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
        
        contract.Name = 'test contract New';
        contract.sirenum__Client__c   = acc1.id;
        contract.sirenum__Employee__c = con1.id;
        insert contract;
        
        sirenum__Rota__c sector = new sirenum__Rota__c();
        sector.Name = 'new sector';
        insert sector;
        
         sirenum__Job_Type__c jobtype = new sirenum__Job_Type__c();
        jobtype.name = 'testjobtype';
        jobtype.Impellam_Sector__c = sector.id;
        jobtype.Impellam_Core_Category__c = 'Administration -ADM';
        jobtype.Impellam_Job_Category__c ='Data Entry -OA002';
        
        insert jobtype;
        
        sirenum__Team__c jobroll = new sirenum__Team__c();
        
        jobroll.name = 'testjobroll new';
        //jobroll.IP_Fixed__c=3;
        jobroll.sirenum__Account__c = contract.id; 
        jobroll.sirenum__Job_Type__c = jobtype.id;
        jobroll.sirenum__AWR_Group__c='Group 2';
        jobroll.IP_OPWIPSRole__c='No';
        jobroll.sirenum__Rota__c=sector.id;
        insert jobroll;
        
             Test.startTest();
        
        sirenum__Placement__c splacement = new sirenum__Placement__c();
        
        splacement.Name = 'test placement new';
        splacement.sirenum__Contact__c = con.id;
        splacement.sirenum__Start_Date__c = system.today();
        splacement.sirenum__Site__c= site.Id;
        splacement.IP_Consultant1LookupSplitShare__c= user.Id;
        splacement.IP_Consultant1PercentageSplit__c=100;
        splacement.sirenum__Contract__c = contract.id;
        splacement.sirenum__Job_Role__c = jobroll.id;
        insert splacement;
        System.debug('Value in Consultantidno1' + splacement.IP_Consultant1IDnumberSplitShare__c);
        System.debug('Value in Consultantidno1' + splacement.IP_Consultant1LookupSplitShare__c);
        
        System.debug('Value in Consultantidno1' + splacement.IP_Consultant1LookupSplitShare__r.IP_TempestID__c);
        
        sirenum__Placement__c plcs = [select id, IP_Consultant1IDnumberSplitShare__c, IP_Consultant1LookupSplitShare__c 
                                      from sirenum__Placement__c
                                     where id=:splacement.id];
        System.debug('Value in Consultantidno1swati' + plcs);
        
        
           sirenum__Timesheet__c createtimeshsheet = new sirenum__Timesheet__c();
        
        createtimeshsheet.sirenum__Client__c= acc1.id;
        
        createtimeshsheet.sirenum__Worker__c=con.id;
        
        createtimeshsheet.sirenum__Team__c=jobroll.id;
        
        createtimeshsheet.sirenum__Site__c=site.id;
        
        createtimeshsheet.sirenum__Week_Ending__c=system.today();
        
        createtimeshsheet.sirenum__Non_Taxed_Expenses__c=34.2;
        
        createtimeshsheet.sirenum__Taxed_Expenses__c=22.2;
        
        createtimeshsheet.sirenum__Non_Taxed_Deductions__c=22.0;
        
        createtimeshsheet.sirenum__Taxed_Deductions__c=22.1;
        
        insert createtimeshsheet;
        
        system.debug('Value in createtimeshsheet'+ createtimeshsheet);
        
        sirenum__Shift__c sshift =new sirenum__Shift__c();
        sshift.sirenum__Placement__c = plcs.id;
        sshift.sirenum__Rota__c = sector.Id;
        sshift.sirenum__Team__c = jobroll.id;
        sshift.sirenum__Site__c=site.id;
        sshift.sirenum__Contact__c=con3.id;
        sshift.sirenum__Cancelled__c= FALSE;
        sshift.sirenum__Published_Ever__c=TRUE;
        sshift.sirenum__Timesheet_summaries__c=createtimeshsheet.id;
        insert sshift;
        system.debug('value in shift'+sshift);
        system.debug('value in Placement on shift'+ sshift.sirenum__Placement__c);
        
        
    
    ts2__Job__c job1 = new ts2__Job__c();
     RecordType perms = [Select Id From RecordType Where DeveloperName='Perm' and sObjectType='ts2__Job__c'];
    job1.Name = 'Test Job1';
    job1.IP_Fixed_Fee__c = 120;
    job1.ts2__Account__c = acc.id;
    job1.ts2__Contact__c = con.id;
    job1.sirenum_js__Site__c = site.id;
    job1.Recordtypeid = perms.id;
    insert job1;
    
    ts2__Placement__c permplacement = new ts2__Placement__c();
        RecordType perms1 = [Select Id From RecordType Where DeveloperName='Perm' and sObjectType='ts2__Placement__c'];
    permplacement.ts2extams__Substatus__c = 'Hired';
           permplacement.ts2__Job__c=job1.id;
               permplacement.sirenum_js__Site__c=site.id;
              permplacement.ts2__Employee__c = con2.id;
               permplacement.ts2__Hiring_Manager__c=con1.id;
    permplacement.ts2__Salary__c = 100;
        permplacement.IP_FixedFeeValue__c = 120;
    permplacement.ts2__Filled_By__c = user.id;
          permplacement.RecordTypeId=perms1.id;
         permplacement.ts2__Start_Date__c=system.today();
    insert permplacement;
  
        
        
     
       
        UncontactedCandidateRemoval obj = new UncontactedCandidateRemoval();
        DataBase.executeBatch(obj);
        Test.stopTest();

    }
}