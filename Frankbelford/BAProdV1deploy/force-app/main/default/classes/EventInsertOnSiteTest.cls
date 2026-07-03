@isTest public class EventInsertOnSiteTest {
      static testMethod void Test() {
        
  
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
        
        
        jsinq__Inquiry__c business = new jsinq__Inquiry__c();
        business.Name ='Test';
        business.Business_Type__c = 'Commercial';
        business.jsinq__Converted__c = false;
        business.jsinq__Contact_First_Name__c ='Vandita';
        business.jsinq__Contact_Last_Name__c ='Kakkar';
        business.jsinq__Phone_Number__c ='9818352973';
        insert business;
          
          
        jsinq__Inquiry__c business1 = new jsinq__Inquiry__c();
        business1.Name ='Test1';
        business1.Business_Type__c = 'Commercial';
        business1.jsinq__Converted__c = true;
        business1.jsinq__Contact_First_Name__c ='Vandita';
        business1.jsinq__Contact_Last_Name__c ='Kakkar';
        business1.jsinq__Phone_Number__c ='9818352973';
          business1.Site__c = site.id;
        insert business1;
          
          Event e = new Event();
           e.Subject='Test for trigger';
            e.DurationInMinutes=60;
            e.activitydatetime=system.now();
        e.WhatId=business1.id;
          e.WhoId = con1.id;
      //  e.StartDateTime=system.today();
        //  e.EndDateTime=system.today()+5;

          insert e;
      }

}