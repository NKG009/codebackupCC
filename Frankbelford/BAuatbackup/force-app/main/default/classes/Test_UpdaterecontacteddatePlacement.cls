@istest
public class Test_UpdaterecontacteddatePlacement  {

    static testMethod void updatePlacementdate() {
       
             insert new IP_Parallel_Payroll_Check__c(name = 'RunParallelCheck', Run_Parallel_Payroll__c = false); 
              insert new IP_CompanyCode__c(name = 'CompanyCode', IP_CompanyCodeValue__c = 'BAL');
              IP_BranchStatus__c b  = new IP_BranchStatus__c ();
         b.IP_BranchID__c = '1062';
           b.Name = 'Test';
           insert b;
        
        Account client = TestDataFactory.createClients(1)[0]; 
        Insert client;
        
        Account account = TestDataFactory.createAccounts(1)[0];
        Insert account;
        
        Account accountcan = TestDataFactory.createCandidateAccount(1)[0];
        Insert accountcan;
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        Contact cont = TestDataFactory.createContact(client.id, 1)[0];
        
        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=true);
        
        Insert cont;
        
        Recordtype rt1= [Select id from Recordtype where sobjecttype='contact' and Name='Contact'];
        contact con1 = new contact();
        // con.IP_GDPRContactedCandidate__c=FALSE;
        //con.CreatedDate=dt1;
        //con.IP_MarkedForDeletion__c=NULL;
        //  con.IP_Consent_from_Data_Store__c=NULL;
        con1.RecordTypeId=rt1.id;
        con1.AccountId=account.id;
        con1.FirstName='Vandita Test';
        con1.LastName='Kakkar Test';
        con1.IP_ContactType__c='Invoice Contact';
        insert con1;
        
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=true);
        
        //candidate.t2placement_PassToTempest__c=null;
        Insert candidate;
        
        
        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0]; 
        Insert tpz;
        Profile p = [SELECT Id FROM Profile where name='System Administrator'];
        User usr = TestDataFactory.createUsers(p.Id,1)[0];
        usr.username = 'pokygj123@yts.com';
        usr.IP_TempestDepartment__c='2043';
        usr.IP_TempestID__c='1084675';
        usr.IP_TempestDivision__c='NTS';
        insert usr; 
        
        
        sirenum__Site__c site = new sirenum__Site__c();
        
        site.Name = 'NewSite';
        site.sirenum__Operating_Company__c= account.id;
        site.IP_ClientIDLegacy__c ='QAWWSED34';
        site.IP_ClientInvoiceName__c='Test Invoice';
        site.IP_InvoiceAddressStreet__c='Test Street';
        site.IP_PublicSector__c='No';
        site.GlobalClientName__c= tpz.Id;
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
        site.OwnerId=usr.id;
        site.IP_InvoiceAddressCity__c='Delhi';
        insert site;
        system.debug('Value in site'+ site);
        
        
        
        ts2__Job__c jb = TestDataFactory.createT2Job(usr.id, 1)[0];
        jb.ts2__Account__c = accountcan.id;
        jb.ts2__Contact__c = candidate.id;
        jb.sirenum_js__Site__c = site.id;
        jb.IP_Fixed_Fee__c = 100;  
        Insert jb;
        
        ts2__Placement__c ts2p = TestDataFactory.createTs2Placement(client.Id, candidate.Id, cont.Id, jb.Id, site.id,'Perm', 1)[0]; 
        ts2p.Item__c='Testabc'; 
        ts2p.IP_PassToTempest__c=true;
        ts2p.ts2extams__Substatus__c = 'Hired';
        Insert ts2p;
        
        ts2p.IP_StatuschangedtoHired__c = System.today().addDays(-90);
        update ts2p;
        
        Test.startTest();
        ScheduleUpdaterecontacteddatePlacement sh2 = new ScheduleUpdaterecontacteddatePlacement();
        String sch = '0 0 23 * * ?';
        system.schedule('Testplacementdate Sync', sch, sh2);
        Test.stopTest();
    }
    }