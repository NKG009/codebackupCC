@isTest
public class ResendShiftCnfrmCtrl_Test {
    
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
            TimeZoneSidKey='America/Chicago',
            Brand__c = 'Blue Arrow'
            
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
            IP_TempestDepartment__c = '1062',
            isActive = true
        );
        Database.insert(user1); 
        Profile jsProfile = [SELECT Id FROM Profile WHERE Name LIKE 'JS Admin tier 1' Limit 1];
        User user2 = new User(
            Username = System.now().millisecond() + 'test12345@test.com',
            ProfileId = jsProfile.Id,
            Alias = 'test123',
            Email = 'amit.kohli@espire.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = 'testJSUser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            IP_TempestDepartment__c = '1062',
            isActive = true,
            Brand__c = 'Blue Arrow'
        );
        insert user2;
    }
    
    public static testmethod void Test1(){
    
        insert new IP_Shift_Template__c(name = '1233', Email__c = 'singh.taji26@gmail.com'); 
        //Contact con = [SELECT Id,AccountId FROM Contact where lastname = 'McTesty' limit 1];
        User jsUser = [SELECT id,isActive,IP_TempestDepartment__c  FROM user WHERE profile.name = 'JS Admin tier 1' limit 1];
        System.debug('user::'+jsUser);
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
        sites.ownerId = jsUser.id;
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
        ratecardpage.sirenum__Valid_From_Date__c = System.today();
        ratecardpage.sirenum__Valid_Until_Date__c = System.today()+10;
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
        
        sirenum__Team__c tm = TestDataFactory.createJobRole(pac.id, job.id,1)[0];
        tm.sirenum__Rate_Card__c = ratecard.id;
        tm.IP_Notified_Health_Safety_Risks__c = 'Not applicable'; 
        tm.IP_Special_Induction__c = 'candidates must have a CSCS card';
        tm.IP_Job_Description__c = 'Cleaner for when shops are getting a re-furb done. MUST HOLD CSCS card';
        Insert tm;
        
         IP_BranchStatus__c b = new IP_BranchStatus__c();
         b.IP_BranchID__c = '1009';
         b.Name = 'Test';
         b.IP_Division__c = '123';
         insert b;
        
        sirenum__Placement__c splaceRec = new sirenum__Placement__c();
        splaceRec.Name = 'testing placment';
        splaceRec.sirenum__Contact__c = u.contactId;//con.id;
        splaceRec.sirenum__Start_Date__c =  System.today();
        splaceRec.sirenum__End_Date__c= System.today() + 30;
        splaceRec.sirenum__Contract__c = pac.id;
        splaceRec.sirenum__Job_Role__c = tm.id;
        splaceRec.sirenum__Site__c = sites.Id;
        splaceRec.sirenum__Status__c   = 'Active';
        splaceRec.IP_Consultant1PercentageSplit__c=100;
        splaceRec.IP_PassToTempest__c=true;
        splaceRec.IP_Costcode__c = '1062';
        splaceRec.Assignment_Email_Sent_Manually__c = false; 
        splaceRec.IP_Shift_Details_sent__c = false; 
        //splaceRec.Date_Assignment_Letter_Sent__c = ''; 
        insert splaceRec;
        System.debug('splaceRec::'+JSON.serialize(splaceRec));
        test.startTest();
        EmailMessage eMsg = new EmailMessage(Subject = 'Blue Arrow Candidate Assignment Confirmation',IsBounced=true,RelatedToId=splaceRec.Id,ToAddress='test@gmail.com');
        insert eMsg;
        ResendShiftCnfrmCtrlBatch ctrl = new ResendShiftCnfrmCtrlBatch();
		Database.executeBatch(ctrl,100);
        test.stoptest();
    }
    

}