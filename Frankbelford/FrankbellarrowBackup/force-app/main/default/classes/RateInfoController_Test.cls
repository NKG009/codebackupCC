@isTest
public class RateInfoController_Test{
@testSetup 
    static void shiftSetup() {
        //Create portal account owner
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner11 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test3@test.com',
            Alias = 'batman',
            Email='bruce.wayne@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
            
        );
        Database.insert(portalAccountOwner11);
        Contact contact1 ;
        Contact contact2 ;
        Contact contact3 ;
        System.runAs(portalAccountOwner11) {
            //Create account
            Account portalAccount1 = new Account(
                Name = 'TestAccount',
                OwnerId = portalAccountOwner11.Id,
                    Invoice_PO_Number_Format__c='AAAA'
            );
            Database.insert(portalAccount1);
            
            //Create contact
            insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);
            
            contact1 = new Contact(
                FirstName = 'Test1',
                Lastname = 'McTesty',
                AccountId = portalAccount1.Id,
                IP_IsInvoicecontact__c=true,
                //IP_ContactType__c='Invoice Contact',
                Email = System.now().millisecond() + 'test@test.com'
            );
            Database.insert(contact1);
          
        }
        //Create user
        
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Customer Community User%' Limit 1];
        User user1 = new User(
            Username = System.now().millisecond() + 'test12345@test.com',
            ContactId = contact1.Id,
            ProfileId = portalProfile.Id,
            Alias = 'test123',
            Email = 'amit.kohli@espire.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            IP_TempestDepartment__c = '1062'
        );
        Database.insert(user1); 
        
    }
    
    public static testmethod void Test1(){
    
        insert new IP_Shift_Template__c(name = '1233', Email__c = 'singh.taji26@gmail.com');  
        User u = [select id , contactId,contact.AccountId from user where lastname = 'McTesty' limit 1];
        ID ConTID = u.contactId;
        ID accDID = u.Contact.AccountId;
        
        Account acct1 = TestDataFactory.createAccounts(3)[2]; 
        insert acct1;
        Account acct = TestDataFactory.createCandidateAccount(1)[0];
        insert acct;
        Contact cond = TestDataFactory.createCandidate(acct.id, 1)[0];  
        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);
        
        Insert cond;  
        
        
        
        IP_TopazGlobalClientInformation__c tgci = TestDataFactory.createTopaz(1)[0]; 
        tgci.IP_SalesLedgerNumber__c = '1112244';   
        Insert tgci;  
        
        sirenum__Site__c sites =  TestDataFactory.createSites(acct.id, tgci.id, 1)[0];     
        sites.ownerId = u.id;
        sites.sirenum__Operating_Company__c = accDID;
        sites.IP_MainContact__c = ConTID;
        sites.sirenum__Postal_Code__c = '10234';
        sites.sirenum__Street_Address__c = '1231';
        sites.IP_PassClientToTempest__c=false;
        sites.IP_Timesheet_Method__c = 'eTimesheet';
        sites.IP_InvoiceContact__c = ConTID;
        Insert sites;
        
        Contact_Site_link__c stlink = new Contact_Site_link__c();
        stlink.IP_Site__c = sites.id;
        stlink.IP_Contact__c = ConTID;
        stlink.Account__c = accDID;
        stlink.IP_PortalType__c ='Primary Hours Approver';
        insert stlink;
        
        sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(acct.id, cond.id,1)[0];
        insert pac;    
        
        sirenum__Rota__c rota = TestDataFactory.createSector(1)[0];
        Insert rota;
        
        sirenum__Job_Type__c job = TestDataFactory.createJobType(rota.id, 1)[0]; 
        Insert job;
        
        sirenum__Rate_Card__c  ratecard = new sirenum__Rate_Card__c();
        ratecard.name = 'TestRateCard';
        insert ratecard;
        sirenum__Rate_Card_Page__c ratecardpage = new sirenum__Rate_Card_Page__c();
        ratecardpage.name='rate card page';
        ratecardpage.sirenum__Rate_Card__c=ratecard.id;
        ratecardpage.sirenum__SortOrder__c =123;
        insert ratecardpage;
        
        sirenum__Rate_Line__c ratecardline = new sirenum__Rate_Line__c();
        ratecardline.sirenum__Rate_Card_Page__c=ratecardpage.id;
        ratecardline.sirenum__Charge_Rate__c =12.56;
        ratecardline.sirenum__Overtime_Charge_Rate__c = 13.45;
        ratecardline.sirenum__Day_Type__c = 'Monday';
        ratecardline.sirenum__Start_Hour__c = '10';
        ratecardline.sirenum__End_Hour__c = '18';
        ratecardline.sirenum__Code__c = 'test';
        ratecardline.sirenum__Pay_Rate__c=12.3;
        ratecardline.sirenum__SortOrder__c=123;
        insert ratecardline;
        
        /*
        SELECT Id,IP_TextChargeRate__c,IP_TextOTchrg__c,sirenum__Day_Type__c,sirenum__Start_Hour__c,
            sirenum__End_Hour__c,sirenum__Charge_Rate__c,sirenum__Overtime_Charge_Rate__c,sirenum__Code__c,
            sirenum__Standard_Rate_Name__c
            FROM sirenum__Rate_Line__c where sirenum__Rate_Card_Page__c =: ratecardId
        
        */
        
        sirenum__Team__c tm = TestDataFactory.createJobRole(pac.id, job.id,1)[0];
        tm.sirenum__Rate_Card__c = ratecard.id;
        Insert tm;
        
 
        sirenum__Rate_Card_Page__c ratepage = new sirenum__Rate_Card_Page__c();
        ratepage.name = 'TestRatePage';
        ratepage.sirenum__Rate_Card__c = ratecard.id;
        ratepage.sirenum__SortOrder__c = 10;
        insert ratepage;
        
        sirenum__Placement__c splacement = TestDataFactory.createSPlacement1(cond.id, pac.id, tm.id, u.id,1)[0];
        splacement.sirenum__Site__c = sites.id;
        splacement.IP_Consultant1LookupSplitShare__c = u.id;
        splacement.IP_Costcode__c = '1233';
        splacement.IP_PurchaseOrderNumber__c = 'LALA';
        Insert splacement;
        test.startTest();
      System.runAs(u) {
        RateInfoController.getRateLneList2(ratecardpage.id);
        RateInfoController.getRateLneList(ratecardpage.id);
        RateInfoController.getSiteList();
        RateInfoController.getJobRoleList();
        RateInfoController.getSitesOfLoggedInUser();
        RateInfoController.fetchUser();
        RateInfoController.getRateCardList(tm.id);
        }
        test.stoptest();
    }
    
}