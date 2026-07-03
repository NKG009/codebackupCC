@isTest public class SiteAddressTest {
 
    static testMethod void test(){
        Profile Prof=[SELECT Id FROM Profile WHERE Name='System Administrator' limit 1];
        User user = new User();
        DateTime dt2 = DateTime.newInstance(2017, 6, 23, 4, 2, 3);
        Long gettime = dt2.getTime();
        user.LastName = 'Data1';
        user.FirstName='TestUser';
        user.Alias = 'TstUrD';
        user.Email = 'abc.efg@GHI.com';
        user.Username = 'Email'+gettime+'@js.com.uk';
        user.ProfileId = Prof.id;
        user.TimeZoneSidKey = 'GMT';
        user.LanguageLocaleKey = 'en_US';
        user.EmailEncodingKey = 'UTF-8';
        user.LocaleSidKey = 'en_US';
        user.IP_TempestDepartment__c='0000';
        user.IP_TempestID__c='1084675';
        user.IP_TempestDivision__c ='NTS';
        user.Department='0000';
       // user.IP_PassToTempest__c=true;
        insert user;
        system.debug('Value in user'+ user);
        
        system.runas(user)
        {
            Account client = TestDataFactory.createClients(1)[0]; 
            Insert client;
            
            Account account = TestDataFactory.createAccounts(1)[0];
            Insert account;
            
            Account accountcan = TestDataFactory.createCandidateAccount(1)[0];
            Insert accountcan;
            
            insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
            Contact cont = TestDataFactory.createContact(client.id, 1)[0];
            
            insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);
            
            Insert cont;
            
            Recordtype rt1= [Select id from Recordtype where sobjecttype='contact' and Name='Contact'];
            contact con1 = new contact();
        
            con1.RecordTypeId=rt1.id;
            con1.AccountId=account.id;
            con1.FirstName='Vandita Test';
            con1.LastName='Kakkar Test';
         //   con1.IP_ContactType__c='Invoice Contact';
            insert con1;
            
            
            
            
            insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
            Contact candidate = TestDataFactory.createCandidate(accountcan.id, 1)[0];
            candidate.PORTW_Completed__c =true;     
            candidate.Medical_Completed__c =true;       
            candidate.Declaration_Completed__c=true;        
            candidate.TOE_Completed__c =true;       
            candidate.New_Starter_Form__c=true;     
            candidate.Equal_Opportunity_Completed__c=true;
            insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);
            
            Insert candidate;
            
            IP_TopazGlobalClientInformation__c createtopaz = new IP_TopazGlobalClientInformation__c();
            createtopaz.name = 'TestClient2';
            createtopaz.IP_StatusID__c = 1;
            createtopaz.IP_SalesLedgerNumber__c='123456';
            insert createtopaz;
            
            
            
            id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('PAYE').getRecordTypeId();
            insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
            
            IP_PayProfile__c payprofile2 = new IP_PayProfile__c();
            payprofile2.RecordTypeId = payRTId;
            
            payprofile2.IP_Candidate__c = candidate.id;
            payprofile2.IP_CompanyName__c='sfdc';
            payprofile2.IP_Status__c = 'Active'; 
            payprofile2.IP_CompanyRegNo__c  = 'ad123456';
            payprofile2.IP_VATNumber__c     = '123456789';
            payprofile2.IP_PayrollID__c  = 'testpaynew';
            payprofile2.IP_VATRegistered__c=true;
            payprofile2.IP_OkToSupply__c=1;
            payprofile2.IP_BuildingSocietyNumber__c='12f';
            payprofile2.IP_BusinessAddressLine1__c='test address 1';
            payprofile2.IP_BusinessAddressLine2__c='test address 2';
            payprofile2.IP_BusinessAddressTown__c='town city';
            payprofile2.IP_BusinessAddressPostcode__c='12345678';
            payprofile2.IP_PayFrequency__c='Weekly';
            payprofile2.IP_PaymentType__c='BACS';
            payprofile2.IP_PrimaryPayMethod__c=true;
            payprofile2.IP_BankAccountName__c ='Vandita';
            payprofile2.IP_AccountNumber__c ='12345678';
            payprofile2.IP_SortCode__c = '123456';
            insert payprofile2;
            
            sirenum__site__c site = new sirenum__site__c();
            site.Name='my site';
           site.sirenum__Operating_Company__c = account.id;
            site.sirenum__Inactive__c = false;
            site.IP_MainContact__c = con1.id;
                site.IP_Costcode__c ='1010';
            site.HSContact__c = '9818352973';
            site.IP_Timesheet_Method__c ='Manual';
            site.sirenum__Phone1__c ='9818352973';
            site.Drivers_Negligence__c= true;
            site.IP_PublicSector__c = 'No';
            site.sirenum__Travel_Instructions__c ='abcd';
            site.Email_Shifts_to_Client__c = true;
            site.sirenum__Comments__c ='abcde';
            site.GlobalClientName__c = createtopaz.id;
            site.sirenum__Site_PO__c ='123456';
            site.IP_ClientInvoiceName__c ='Vandita';
            site.IP_InvoiceContactText__c = 'Invoice Con123';
            site.IP_PassClientToTempest__c = true;
            site.IP_PassClientAddressToTempest__c = true;
            site.IP_InvoiceAddressCity__c='ballia';
            site.IP_InvoiceAddressStreet__c='street1';
            
            site.IP_ClientIDLegacy__c='eww3';
            site.IP_Clientinvoicename__c='invoice name';
            site.IP_InvoiceAddressCountry__c='ind';
            site.IP_InvoiceAddressCounty__c='cnt';
            site.IP_InvoiceAddressPostcode__c='23d fdd';
       site.IP_ClientLastPassedToTempest__c=null;
            site.Credit_Status__c='Credit Approved';
        site.sirenum__Postal_Code__c = '12345';
            site.sirenum__City__c = 'City1';
         site.sirenum__Street_Address__c = 'Address 1';   
            site.OwnerId = user.id;
            insert site;
            
           system.debug('Value in site'+ site);
            test.startTest();
        Apexpages.StandardController sc = new Apexpages.standardController(site);
        ApexPages.currentPage().getParameters().put('Id', site.id);
        SiteAddressController ext = new SiteAddressController(sc);
            //  PageReference testPageResults1 = ext.saveandredirect();
             PageReference testPageResults2 = ext.cancelredirect();
       
        test.stopTest();
 
     }
    }
    
    static testMethod void test1(){
     Account client = TestDataFactory.createClients(1)[0]; 
        Insert client;
        
        Account account = TestDataFactory.createAccounts(1)[0];
        Insert account;
        
        Account accountcan = TestDataFactory.createCandidateAccount(1)[0];
        Insert accountcan;
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        Contact cont = TestDataFactory.createContact(client.id, 1)[0];
        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);
        
        Insert cont;
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        Contact candidate = TestDataFactory.createCandidate(accountcan.id, 1)[0];
        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);
        
        //candidate.t2placement_PassToTempest__c=null;
        Insert candidate;
        Recordtype rt1= [Select id from Recordtype where sobjecttype='contact' and Name='Contact'];
        contact con2 = new contact();
        // con.IP_GDPRContactedCandidate__c=FALSE;
        //con.CreatedDate=dt1;
        //con.IP_MarkedForDeletion__c=NULL;
        //  con.IP_Consent_from_Data_Store__c=NULL;
        con2.RecordTypeId=rt1.id;
        con2.AccountId=account.id;
        con2.FirstName='Vandita Test';
        con2.LastName='Kakkar Test';
      //  con2.IP_ContactType__c='Invoice Contact';
        insert con2;
        
        
        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0]; 
        Insert tpz;
        
        
        
        Profile p1 = [SELECT Id FROM Profile where name='System Administrator'];
        User usr1 = TestDataFactory.createUsers(p1.Id,1)[0];
        usr1.username = 'pokygj123@yts.com';
        usr1.IP_TempestDepartment__c='0000';
        usr1.IP_TempestID__c='1084675';
        usr1.IP_TempestDivision__c='NTS';
        insert usr1; 
        
        
        
        sirenum__Site__c site1 = new sirenum__Site__c();
        site1.OwnerId = usr1.id;
        site1.Name = 'NewSite';
        site1.sirenum__Operating_Company__c= account.id;
        site1.IP_ClientIDLegacy__c ='QAWWSED34';
        site1.IP_ClientInvoiceName__c='Test Invoice';
        site1.IP_InvoiceAddressStreet__c='Test Street';
        site1.IP_InvoiceAddressCity__c ='Dwarka';
        site1.IP_PublicSector__c='No';
        site1.GlobalClientName__c= tpz.Id;
        //site.IP_PassClientToTempest__c=true;
        //site.IP_ClientLastPassedToTempest__c=null;
        //site.IP_PassClientAddressToTempest__c=true;
        site1.sirenum__Postal_Code__c='124678';
        site1.sirenum__City__c='New Delhi';
        site1.IP_PublicSector__c='NO';
        // site.IP_TempestDepartment__c ='2043';
        // site.IP_TempestDivision__c='1234';
        site1.IP_MainContact__c=con2.id;
        site1.IP_InvoiceContactText__c= 'Test contact';
        // site.IP_PreAWRWTRValue__c=4;
        // site.IP_PostAWRWTRValue__c=5;
        site1.OwnerId=usr1.id;
        site1.IP_InvoiceAddressCity__c='Delhi';
        insert site1;
        system.debug('Value in site'+ site1);
        
          
            test.startTest();
        system.debug('Value in site inside'+ site1);
     /*   Apexpages.StandardController sc = new Apexpages.standardController(site1);
       // ApexPages.currentPage().getParameters().put('Id', site1.id);
        SiteAddressController ext = new SiteAddressController(sc);
              PageReference testPageResults1 = ext.saveandredirect();
             //PageReference testPageResults2 = ext.cancelredirect();*/
           
        PageReference pageRef = Page.SiteAddress;
Test.setCurrentPage(pageRef);
ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(site1);
//ApexPages.currentPage().getParameters().put('Id',site.id);

SiteAddressController temp = new SiteAddressController(sc); 
    temp.saveandredirect();
        
        test.stopTest();
      }        
}