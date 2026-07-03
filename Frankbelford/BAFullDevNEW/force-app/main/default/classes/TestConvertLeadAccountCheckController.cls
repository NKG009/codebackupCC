@istest
private class TestConvertLeadAccountCheckController{
    
    @testSetup static void setup(){
        
        Profile ProfSysAdmin=[SELECT Id FROM Profile WHERE Name='System Administrator' limit 1];
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account'];
        
        
        
        Account acc1 = new Account();
        acc1.name='Test Account Inquiry';
        acc1.Phone='111111111';
        acc1.BillingStreet='Street1';
        acc1.IP_Business_Type__c='catering';
        //acc1.BillingCity ='City1';
        //acc1.BillingPostalCode = '101911';
        //acc1.BillingState='State1';
        //acc1.BillingCountry='Country1';
        acc1.RecordTypeId=accountRec.id;
        insert acc1;
        system.debug('Account Inserted');
        
        Account accPhone = new Account();
        accPhone.name='Test Account phone';
        accPhone.Phone='76757657';
        accPhone.BillingStreet='Street1';
        accPhone.IP_Business_Type__c='catering';
        //accPhone.BillingCity ='City1';
        //accPhone.BillingPostalCode = '101911';
        //accPhone.BillingState='State1';
        //accPhone.BillingCountry='Country1';
        accPhone.RecordTypeId=accountRec.id;
        insert accPhone;
        system.debug('Account Inserted');
        
        Account accComReg = new Account();
        accComReg.name='Test Account registration';
        accComReg.Phone='66666';
        accComReg.BillingStreet='Street1';
        accComReg.IP_Business_Type__c='catering';
        //accComReg.BillingCity ='City1';
        //accComReg.BillingPostalCode = '101911';
        //accComReg.BillingState='State1';
        //accComReg.BillingCountry='Country1';
        accComReg.IP_CompanyRegistrationNo__c = '12345678';
        accComReg.RecordTypeId=accountRec.id;
        insert accComReg;
        system.debug('Account Inserted');
        
        Account acc6 = new Account();
        acc6.name='Test Account Company Limited';
        acc6.Phone='6767676';
        acc6.RecordTypeId=accountRec.id;
        insert acc6;
        system.debug('Account Inserted');
        
        Account acc2 = new Account();
        acc2.name='Account Company';
        acc2.Phone='44444';
        acc2.BillingStreet='Street1';
        acc2.IP_Business_Type__c='catering';
        //acc2.BillingCity ='City1';
        //acc2.BillingPostalCode = '101911';
        //acc2.BillingState='State1';
        //acc2.BillingCountry='Country1';
        acc2.RecordTypeId=accountRec.id;
        insert acc2;
        system.debug('Account Inserted');
        
        Account acc4 = new Account();
        acc4.name='Test';
        acc4.Phone='222222';
        acc4.BillingStreet='Street1';
        acc4.IP_Business_Type__c='catering';
        //acc4.BillingCity ='City1';
        //acc4.BillingPostalCode = '101911';
        //acc4.BillingState='State1';
        //acc4.BillingCountry='Country1';
        acc4.RecordTypeId=accountRec.id;
        insert acc4;
        system.debug('Account Inserted');
        
        Inquiry__c inquiry = new Inquiry__c();
        inquiry.Name = 'Test Account Inquiry';
        //inquiry.Business_Type__c ='Commercial';
        inquiry.Phone_Number__c = '76757657';
        inquiry.Contact_First_Name__c = 'Test';
        inquiry.Contact_Last_Name__c  = 'Test';
        inquiry.Company_Registration_No__c = '12345678';
        inquiry.Lead_Source__c = 'Blue Arrow Website';
        insert inquiry;
        system.debug('inquiry++++++++'+inquiry);
        
        Inquiry__c inquiry1 = new Inquiry__c();
        inquiry1.Name = 'Account Inquiry Insert';
        inquiry.Lead_Source__c = 'Blue Arrow Website';
        //inquiry1.Business_Type__c ='Commercial';
        
        inquiry1.Phone_Number__c = '76757657';
        inquiry1.Contact_First_Name__c = 'Test';
        inquiry1.Contact_Last_Name__c     = 'Test';
        inquiry1.Company_Registration_No__c = '12345678';
        inquiry1.Lead_Source__c = 'Blue Arrow Website';
        insert inquiry1;    
        
        
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
    }
    
    private static testmethod void convertleadAccountPositive(){
        List<Inquiry__c> inquiry = [Select id from Inquiry__c limit 1];
        List<Account> acc = [Select id from Account where Name='Test Account Inquiry' limit 1];
        User usr = [Select id from User where LastName = 'UserSalesforce12' limit 1];
        System.runas(usr){
            ApexPages.StandardController sc = new ApexPages.StandardController(inquiry[0]);
            PageReference pageRef = Page.ConvertNewBusiness; // Add your VF page Name here
            pageRef.getParameters().put('id', String.valueOf(inquiry[0].Id));
            Test.setCurrentPage(pageRef);
            Test.StartTest();
            ConvertLeadAccountCheckController convertLeadAccountCheck = new ConvertLeadAccountCheckController(sc);
            ConvertLeadAccountCheckController.wrapAccount cmp = new ConvertLeadAccountCheckController.wrapAccount(acc[0]);
            convertLeadAccountCheck.wrapAccountList[0].Selected=true;
            convertLeadAccountCheck.selectedAccountId = acc[0].id;
            convertLeadAccountCheck.Cancel();
            convertLeadAccountCheck.selectedAccountId = acc[0].id;
            convertLeadAccountCheck.ConvertToNewAccount();
            convertLeadAccountCheck.ConvertToSelectedAccount();
            Test.StopTest();
        }
    }
    
    private static testmethod void convertleadAccountPositiveInsert(){
        List<Inquiry__c> inquiry = [Select id from Inquiry__c where Name='Account Inquiry Insert' limit 1];
        User usr = [Select id from User where LastName = 'UserSalesforce12' limit 1];
        List<Account> acc = [Select id from Account];
        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);
        System.runas(usr){
            ApexPages.StandardController sc = new ApexPages.StandardController(inquiry[0]);
            PageReference pageRef = Page.ConvertNewBusiness; // Add your VF page Name here
            pageRef.getParameters().put('id', String.valueOf(inquiry[0].Id));
            Test.setCurrentPage(pageRef);
            
            Test.StartTest();
            ConvertLeadAccountCheckController convertLeadAccountCheck = new ConvertLeadAccountCheckController(sc);
            convertLeadAccountCheck.ConvertToNewAccount();  
            Test.StopTest();            
        }
    }
    
    private static testmethod void CustomAccountLookupControllerPositive(){
        List<Inquiry__c> inquiry = [Select id from Inquiry__c where Name='Account Inquiry Insert' limit 1];
        User usr = [Select id from User where LastName = 'UserSalesforce12' limit 1];
        System.runas(usr){           
            Test.StartTest();       
            CustomAccountLookupController customAccountLookup = new CustomAccountLookupController();
            customAccountLookup.searchString = 'Test';
            customAccountLookup.search();
            customAccountLookup.getFormTag();
            customAccountLookup.getTextBox();
            Test.StopTest();
        }
    }
    
    private static testmethod void convertleadAccountNegative(){
        List<Inquiry__c> inquiry = [Select id from Inquiry__c limit 1];
        List<Account> acc = [Select id from Account where Name='Test Account Inquiry' limit 1];
        User usr = [Select id from User where LastName = 'UserSalesforce12' limit 1];
        System.runas(usr){
            ApexPages.StandardController sc = new ApexPages.StandardController(inquiry[0]);
            PageReference pageRef = Page.ConvertNewBusiness; // Add your VF page Name here
            pageRef.getParameters().put('id', String.valueOf(inquiry[0].Id));
            Test.setCurrentPage(pageRef);
            
            Test.StartTest();
            ConvertLeadAccountCheckController convertLeadAccountCheck = new ConvertLeadAccountCheckController(sc);
            convertLeadAccountCheck.Cancel();
            Test.StopTest();
        }
    }
}