@istest
private class TestConvertLeadSiteCheckController{
    
    @testSetup static void setup(){
        
        Profile ProfSysAdmin=[SELECT Id FROM Profile WHERE Name='System Administrator' limit 1];
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account'];
        
        
        //Create User with Sys Admin Profile
        User user1 = new User();        
        DateTime dt = DateTime.newInstance(2017, 6, 23, 4, 2, 3);
        Long gettime1 = dt.getTime();
        user1.isactive = True; 
        user1.LastName = 'UserSalesforce12';      
        user1.FirstName='Testuser1';        
        user1.Alias = 'TstUrD';        
        user1.Email = 'abc.efgee@GHIgh.com';        
        user1.username = 'EmailSalesforce'+gettime1+'@js.com.uk';        
        user1.ProfileId = ProfSysAdmin.id;        
        user1.TimeZoneSidKey = 'GMT';        
        user1.LanguageLocaleKey = 'en_US';        
        user1.EmailEncodingKey = 'UTF-8';        
        user1.LocaleSidKey = 'en_US';        
        user1.IP_TempestDepartment__c='2042';        
        user1.IP_TempestID__c='1084678';        
        user1.IP_TempestDivision__c='NTS';        
        user1.Department='1068';        
        user1.IP_PassToTempest__c=true;        
        insert user1;
        
        Account acc1 = new Account();
        acc1.name='Test Account Inquiry';
        acc1.Phone='111111111';
        acc1.BillingStreet='Street1';
        acc1.IP_Business_Type__c='catering';
        acc1.BillingCity ='City1';
        acc1.BillingPostalCode = '101911';
        acc1.BillingState='State1';
        acc1.BillingCountry='Country1';
        acc1.RecordTypeId=accountRec.id;
        acc1.Top_Prospect__c = false;
        insert acc1;
        system.debug('Account Inserted');
        
        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);
        
        sirenum__Site__c site = new sirenum__Site__c();
        site.Name = 'testsite';
        site.sirenum__Operating_Company__c= acc1.id;
        site.IP_ClientIDLegacy__c='123';
        site.IP_ClientInvoiceName__c='Test Invoice';
        site.IP_InvoiceAddressStreet__c='Test Street';
        site.IP_PublicSector__c='No';
        site.Status__c = 'Prospect';
        //site.GlobalClientName__c= createtopaz.Id;
        site.sirenum__Postal_Code__c='124678';
        site.sirenum__City__c='New Delhi';
        site.Top_Prospect__c = false;
        site.IP_PublicSector__c='NO';
        //site.IP_MainContact__c=con2.id;
        //site.IP_InvoiceContact__c=con2.id;
        site.OwnerId=user1.id;
        site.IP_InvoiceAddressCity__c='Delhi';
        site.IP_Timesheet_Method__c='eTimesheet';
        //site.IP_ScheduledAutoApproval__c= true; 
        insert site;
        
        Inquiry__c inquiry = new Inquiry__c();
        inquiry.Name = 'Test Account Inquiry';
        inquiry.Business_Type__c ='Commercial';
        inquiry.Phone_Number__c = '76757657';
        inquiry.Contact_First_Name__c = 'Test';
        inquiry.Contact_Last_Name__c  = 'Test';
        inquiry.Company_Registration_No__c = '12345678';
        insert inquiry;
        system.debug('inquiry++++++++'+inquiry);
        
        Inquiry__c inquiry1 = new Inquiry__c();
        inquiry1.Name = 'Account Inquiry Insert';
        inquiry1.Business_Type__c ='Commercial';
        inquiry1.Phone_Number__c = '76757657';
        inquiry1.Contact_First_Name__c = 'Test';
        inquiry1.Contact_Last_Name__c     = 'Test';
        inquiry1.Company_Registration_No__c = '12345678';
        insert inquiry1;
    }
    
    private static testmethod void convertleadSitePositive(){
        List<Inquiry__c> inquiry = [Select id from Inquiry__c limit 1];
        List<Account> acc = [Select id from Account where Name='Test Account Inquiry' limit 1];
        List<sirenum__Site__c> site = [Select id from sirenum__Site__c limit 1];
        User usr = [Select id from User where LastName = 'UserSalesforce12' limit 1];
        System.runas(usr){
            ApexPages.StandardController sc = new ApexPages.StandardController(inquiry[0]);
            PageReference pageRef = Page.ConvertNewBusiness; // Add your VF page Name here
            pageRef.getParameters().put('id', String.valueOf(inquiry[0].Id));
            pageRef.getParameters().put('accId', String.valueOf(acc[0].Id));
            Test.setCurrentPage(pageRef);
            Test.StartTest();
            ConvertLeadSiteCheckController convertLeadSiteCheck = new ConvertLeadSiteCheckController(sc);
            ConvertLeadSiteCheckController.wrapSite cmp = new ConvertLeadSiteCheckController.wrapSite(site[0]);
            convertLeadSiteCheck.wrapSiteList[0].Selected=true;
            convertLeadSiteCheck.selectedSiteid = site[0].id;
            convertLeadSiteCheck.Cancel();
            convertLeadSiteCheck.selectedSiteid = site[0].id;
            convertLeadSiteCheck.ConvertToNewSite();
            convertLeadSiteCheck.ConvertToSelectedSite();
            Test.StopTest();
        }
    }
    
    private static testmethod void convertleadAccountSiteInsert(){
        List<Inquiry__c> inquiry = [Select id from Inquiry__c where Name='Account Inquiry Insert' limit 1];
        User usr = [Select id from User where LastName = 'UserSalesforce12' limit 1];
        List<Account> acc = [Select id from Account];
        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);
        System.runas(usr){
            ApexPages.StandardController sc = new ApexPages.StandardController(inquiry[0]);
            PageReference pageRef = Page.ConvertNewBusiness; // Add your VF page Name here
            pageRef.getParameters().put('id', String.valueOf(inquiry[0].Id));
            pageRef.getParameters().put('accId', String.valueOf(acc[0].Id));
            Test.setCurrentPage(pageRef);
            
            Test.StartTest();
            ConvertLeadSiteCheckController convertLeadSiteCheck = new ConvertLeadSiteCheckController(sc);
            convertLeadSiteCheck.ConvertToNewSite();  
            Test.StopTest();            
        }
    }
    
    private static testmethod void convertleadSiteNegative(){
        List<Inquiry__c> inquiry = [Select id from Inquiry__c limit 1];
        List<Account> acc = [Select id from Account where Name='Test Account Inquiry' limit 1];
        User usr = [Select id from User where LastName = 'UserSalesforce12' limit 1];
        System.runas(usr){
            ApexPages.StandardController sc = new ApexPages.StandardController(inquiry[0]);
            PageReference pageRef = Page.ConvertNewBusiness; // Add your VF page Name here
            pageRef.getParameters().put('id', String.valueOf(inquiry[0].Id));
            Test.setCurrentPage(pageRef);
            
            Test.StartTest();
            ConvertLeadSiteCheckController convertLeadSiteCheck = new ConvertLeadSiteCheckController(sc);
            convertLeadSiteCheck.Cancel();
            Test.StopTest();
        }
    }
}