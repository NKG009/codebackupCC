@isTest public class TopProspectCheckTest {
    static testMethod void testMethod1() {
      
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
        user.IP_TempestDepartment__c='1062';
        user.IP_TempestID__c='1084675';
        user.IP_TempestDivision__c ='NTS';
        user.Department='1062';
        user.IP_PassToTempest__c=true;
        insert user;
        system.debug('Value in user'+ user);
        
        system.runas(user)
        {
            Account client = TestDataFactory.createClients(1)[0]; 
            Insert client;
            
            Account account = TestDataFactory.createAccounts(1)[0];
            account.Top_Prospect__c = false;
            Insert account;
            
             
          //  Account account1 = TestDataFactory.createAccounts(1)[0];
           // account1.Top_Prospect__c = true;
         //   Insert account1;
            
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
            con1.IP_ContactType__c='Invoice Contact';
            insert con1;
            
            
            
            
            insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
            Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
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
            site.IP_InvoiceContact__c = con1.id;
            site.IP_PassClientToTempest__c = true;
            site.IP_PassClientAddressToTempest__c = true;
  			site.IP_InvoiceAddressCity__c='ballia';
            site.IP_InvoiceAddressStreet__c='street1';
            site.Top_Prospect__c = false;
            
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
            
             /*  sirenum__site__c site1 = new sirenum__site__c();
            site1.Name='my site1';
           site1.sirenum__Operating_Company__c = account.id;
            site1.sirenum__Inactive__c = false;
            site1.IP_MainContact__c = con1.id;
                site1.IP_Costcode__c ='1010';
            site1.HSContact__c = '9818352973';
            site1.IP_Timesheet_Method__c ='Manual';
            site1.sirenum__Phone1__c ='9818352973';
            site1.Drivers_Negligence__c= true;
            site1.IP_PublicSector__c = 'No';
            site1.sirenum__Travel_Instructions__c ='abcd';
            site1.Email_Shifts_to_Client__c = true;
            site1.sirenum__Comments__c ='abcde';
            site1.GlobalClientName__c = createtopaz.id;
            site1.sirenum__Site_PO__c ='123456';
            site1.IP_ClientInvoiceName__c ='Vandita';
            site1.IP_InvoiceContact__c = con1.id;
            site1.IP_PassClientToTempest__c = true;
            site1.IP_PassClientAddressToTempest__c = true;
  			site1.IP_InvoiceAddressCity__c='ballia';
            site1.IP_InvoiceAddressStreet__c='street1';
            site1.Top_Prospect__c = false;
            
            site1.IP_ClientIDLegacy__c='eww3';
            site1.IP_Clientinvoicename__c='invoice name';
            site1.IP_InvoiceAddressCountry__c='ind';
            site1.IP_InvoiceAddressCounty__c='cnt';
            site1.IP_InvoiceAddressPostcode__c='23d fdd';
       site1.IP_ClientLastPassedToTempest__c=null;
            site1.Credit_Status__c='Credit Approved';
        site1.sirenum__Postal_Code__c = '12345';
            site1.sirenum__City__c = 'City1';
         site1.sirenum__Street_Address__c = 'Address 1';   
            site1.OwnerId = user.id;
              insert site1;
            system.debug('Value in site'+ site1); */
            
            
          
           
    test.startTest();
        Apexpages.StandardController sc = new Apexpages.standardController(account);
               ApexPages.currentPage().getParameters().put('Id', account.id);
         TopProspectCheck ext = new TopProspectCheck(sc);
            ext.revertTopProspect ();
            ext.updateTopProspect ();
              test.stopTest();
        }
            
        
    }

}