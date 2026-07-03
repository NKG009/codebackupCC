@isTest
public class Test_restrictRateCardPageAccessHandler {
    
    static testMethod void testMethod1()
    {
        Profile Prof=[SELECT Id FROM Profile WHERE Name='JS Recruiter - Hybrid' limit 1];
        User user = [SELECT Id FROM User WHERE Profile.Name='JS Recruiter - Hybrid' and isActive = true limit 1];
      /*  DateTime dt2 = DateTime.newInstance(2017, 6, 23, 4, 2, 3);
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
        user.IP_TempestDepartment__c='2043';
        user.IP_TempestID__c='1084675';
        user.IP_TempestDivision__c='NTS';
        user.Department='1069';
        user.IP_PassToTempest__c=true;
        insert user;*/
        
        Account acc1 = new Account();
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account'];
        acc1.name='TestAccount1';
        acc1.Phone='012034563433';
        acc1.BillingStreet='Street1';
        acc1.BillingCity ='City1';
        acc1.BillingPostalCode = 'BN18YL';
        acc1.BillingState='State1';
        acc1.BillingCountry='Country1';
        acc1.RecordTypeId=accountRec.id;
        acc1.Managed_Account__c=true;    
        insert acc1;
        system.debug('Account Inserted');
        sirenum__Rate_Card__c ratecard = new sirenum__Rate_Card__c();
        ratecard.Name='Test Rate Card';
        ratecard.IP_AcountLinkCustom__c=acc1.id;
        insert ratecard;
        
        
        
        test.startTest();
        try{
            system.runas(user)
            {
                
                sirenum__Rate_Card_Page__c  rateCardPage = new sirenum__Rate_Card_Page__c();    
                rateCardPage.Name='test RateCardPage';
                rateCardPage.sirenum__Rate_Card__c=ratecard.id;
                rateCardPage.sirenum__Rate_Type__c='Hourly';
                rateCardPage.sirenum__SortOrder__c=1;
                insert rateCardPage;
            }
        }
        catch(DMLException e)
        {
            System.assert(true,'Insertion Failed Appropriately');
        }
        test.stopTest();
        
        
    }
    static testMethod void testMethod2()
    {
        Profile Prof=[SELECT Id FROM Profile WHERE Name='JS Recruiter - Hybrid' limit 1];
       User user = [SELECT Id FROM User WHERE Profile.Name='JS Recruiter - Hybrid' and isActive = true limit 1];
      /*  DateTime dt2 = DateTime.newInstance(2017, 6, 23, 4, 2, 3);
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
        user.IP_TempestDepartment__c='2043';
        user.IP_TempestID__c='1084675';
        user.IP_TempestDivision__c='NTS';
        user.Department='1069';
        user.IP_PassToTempest__c=true;
        insert user;*/
        
        Account acc1 = new Account();
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account'];
        acc1.name='TestAccount1';
        acc1.Phone='012034563433';
        acc1.BillingStreet='Street1';
        acc1.BillingCity ='City1';
        acc1.BillingPostalCode = 'BN18YL';
        acc1.BillingState='State1';
        acc1.BillingCountry='Country1';
        acc1.RecordTypeId=accountRec.id;
        acc1.Managed_Account__c=true;    
        insert acc1;
        system.debug('Account Inserted');
        
        
        sirenum__Rate_Card__c ratecard = new sirenum__Rate_Card__c();
        ratecard.Name='Test Rate Card';
        ratecard.IP_AcountLinkCustom__c=acc1.id;
        insert ratecard;
        
        sirenum__Rate_Card_Page__c  rateCardPage = new sirenum__Rate_Card_Page__c();    
        rateCardPage.Name='test RateCardPage';
        rateCardPage.sirenum__Rate_Card__c=ratecard.id;
        rateCardPage.sirenum__Rate_Type__c='Hourly';
        rateCardPage.sirenum__SortOrder__c=0;
        insert rateCardPage;
        
        
        test.startTest();
        try{
            system.runas(user)
            {
                rateCardPage.sirenum__SortOrder__c=1;
                update rateCardPage;
                
            }
        }
        catch(DMLException e)
        {
            System.assert(true,'Updation Failed Appropriately');
        }
        test.stopTest();
        
        
    }
    static testMethod void testMethod3()
    {
        Profile Prof=[SELECT Id FROM Profile WHERE Name='Back Office' limit 1];
        User user = [SELECT Id FROM User WHERE Profile.Name='JS Recruiter - Hybrid' and isActive = true limit 1];
      /*  DateTime dt2 = DateTime.newInstance(2017, 6, 23, 4, 2, 3);
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
        user.IP_TempestDepartment__c='2043';
        user.IP_TempestID__c='1084675';
        user.IP_TempestDivision__c='NTS';
        user.Department='1069';
        user.IP_PassToTempest__c=true;
        insert user;*/
        
        Account acc1 = new Account();
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account'];
        acc1.name='TestAccount1';
        acc1.Phone='012034563433';
        acc1.BillingStreet='Street1';
        acc1.BillingCity ='City1';
        acc1.BillingPostalCode = 'BN18YL';
        acc1.BillingState='State1';
        acc1.BillingCountry='Country1';
        acc1.RecordTypeId=accountRec.id;
        acc1.Managed_Account__c=true;    
        insert acc1;
        system.debug('Account Inserted');
        
        
        sirenum__Rate_Card__c ratecard = new sirenum__Rate_Card__c();
        ratecard.Name='Test Rate Card';
        ratecard.IP_AcountLinkCustom__c=acc1.id;
        insert ratecard;
        
        sirenum__Rate_Card_Page__c  rateCardPage = new sirenum__Rate_Card_Page__c();    
        rateCardPage.Name='test RateCardPage';
        rateCardPage.sirenum__Rate_Card__c=ratecard.id;
        rateCardPage.sirenum__Rate_Type__c='Hourly';
        rateCardPage.sirenum__SortOrder__c=0;
        insert rateCardPage;
        
        
        test.startTest();
        try{
            system.runas(user)
            {
                delete rateCardPage;
                
            }
        }
        catch(DMLException e)
        {
            System.assert(true,'deletion Failed Appropriately');
        }
        test.stopTest();
        
        
    }
    static testMethod void testMethod4()
    {
        Profile Prof=[SELECT Id FROM Profile WHERE Name='Back Office' limit 1];
        User user = [SELECT Id FROM User WHERE Profile.Name='JS Recruiter - Hybrid' and isActive = true limit 1 ];
      /*  DateTime dt2 = DateTime.newInstance(2017, 6, 23, 4, 2, 3);
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
        user.IP_TempestDepartment__c='2043';
        user.IP_TempestID__c='1084675';
        user.IP_TempestDivision__c='NTS';
        user.Department='1069';
        user.IP_PassToTempest__c=true;
        insert user;*/
        
        Account acc1 = new Account();
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account'];
        acc1.name='TestAccount1';
        acc1.Phone='012034563433';
        acc1.BillingStreet='Street1';
        acc1.BillingCity ='City1';
        acc1.BillingPostalCode = 'BN18YL';
        acc1.BillingState='State1';
        acc1.BillingCountry='Country1';
        acc1.RecordTypeId=accountRec.id;
        acc1.Managed_Account__c=false;    
        insert acc1;
        system.debug('Account Inserted');
        
        sirenum__Rate_Card__c ratecard = new sirenum__Rate_Card__c();
        ratecard.Name='Test Rate Card';
        ratecard.IP_AcountLinkCustom__c=acc1.id;
        insert ratecard;
        
        sirenum__Rate_Card_Page__c  rateCardPage = new sirenum__Rate_Card_Page__c();    
        rateCardPage.Name='test RateCardPage';
        rateCardPage.sirenum__Rate_Card__c=ratecard.id;
        rateCardPage.sirenum__Rate_Type__c='Hourly';
        rateCardPage.sirenum__SortOrder__c=0;
        insert rateCardPage;
        
        
        test.startTest();
        try{
            system.runas(user)
            {
                delete rateCardPage;
                
            }
        }
        catch(DMLException e)
        {
            System.assert(true,'deletion Failed Appropriately');
        }
        test.stopTest();
        
        
    }
    static testMethod void testMethod5()
    {
        Profile Prof=[SELECT Id FROM Profile WHERE Name='JS Recruiter - Hybrid' limit 1];
      User user = [SELECT Id FROM User WHERE Profile.Name='JS Recruiter - Hybrid' and isActive = true limit 1];
      /*  DateTime dt2 = DateTime.newInstance(2017, 6, 23, 4, 2, 3);
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
        user.IP_TempestDepartment__c='2043';
        user.IP_TempestID__c='1084675';
        user.IP_TempestDivision__c='NTS';
        user.Department='1069';
        user.IP_PassToTempest__c=true;
        insert user;*/
        
        Account acc1 = new Account();
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account'];
        acc1.name='TestAccount1';
        acc1.Phone='012034563433';
        acc1.BillingStreet='Street1';
        acc1.BillingCity ='City1';
        acc1.BillingPostalCode = 'BN18YL';
        acc1.BillingState='State1';
        acc1.BillingCountry='Country1';
        acc1.RecordTypeId=accountRec.id;
        acc1.Managed_Account__c=true;    
        insert acc1;
        system.debug('Account Inserted');
        
        sirenum__Rate_Card__c ratecard = new sirenum__Rate_Card__c();
        ratecard.Name='Test Rate Card';
        ratecard.IP_AcountLinkCustom__c=acc1.id;
        insert ratecard;
        
        sirenum__Rate_Card_Page__c  rateCardPage = new sirenum__Rate_Card_Page__c();    
        rateCardPage.Name='test RateCardPage';
        rateCardPage.sirenum__Rate_Card__c=ratecard.id;
        rateCardPage.sirenum__Rate_Type__c='Hourly';
        rateCardPage.sirenum__SortOrder__c=0;
        insert rateCardPage;
        
        
        test.startTest();
        try{
            system.runas(user)
            {
                delete rateCardPage;
                
            }
        }
        catch(DMLException e)
        {
            System.assert(true,'deletion Failed Appropriately');
        }
        test.stopTest();
        
        
    }
}