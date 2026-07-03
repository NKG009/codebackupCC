@isTest
public class test_RateCardDeletePage {
    
    @isTest
    public static void deleteRateCardPageByAdmin(){
        Test.startTest();
        
        /*Profile JSId = [SELECT Id from Profile where Name='JS Recruiter - Hybrid' LIMIT 1];
        Profile BRId = [SELECT Id from Profile where Name='JS Admin (Branch Admin)' LIMIT 1];
        Profile BRMGId = [SELECT Id from Profile where Name='JS Admin Tier 1 (Branch Mgr)' LIMIT 1];
        Profile SAID = [SELECT Id from Profile where Name='Senior Admin' LIMIT 1];
        Profile BOID = [SELECT Id from Profile where Name='Back Office' LIMIT 1];*/
        
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Client'];
        
        Account acc = new Account();
        acc.IP_Business_Type__c='Catering';
        acc.Name='ClientNew';
        acc.IP_InvoicingMethod__c='Standard';
        acc.recordTypeId=accountRec.id;
        acc.Managed_Account__c = false;
        insert acc; 
        
        User user = [Select id from user where Id=:UserInfo.getuserId()];
        
        sirenum__Rate_Card__c rtc = new sirenum__Rate_Card__c();
        rtc.Name ='New Rate Card';
        rtc.IP_AcountLinkCustom__c= acc.id;
        insert rtc;
        
        sirenum__Rate_Card_Page__c rpc = new sirenum__Rate_Card_Page__c();
        rpc.Name ='Default';
        rpc.sirenum__Rate_Card__c = rtc.id;
        rpc.sirenum__SortOrder__c = 126;
        insert rpc;
        System.runAs(user){
            
            try{
            delete rpc;
            }catch(DMLException e){
                System.assert(e.getMessage().contains('You are not allowed to delete the Default Rate Card Page.'), 'You are not allowed to delete the Default Rate Card Page.'); 
            }
        }
       Test.stopTest();
                                  
    }
    
    @isTest
    public static void deleteRateCardPageByHybrid(){
        Test.startTest();
        
        /*Profile JSId = [SELECT Id from Profile where Name='JS Recruiter - Hybrid' LIMIT 1];
        Profile BRId = [SELECT Id from Profile where Name='JS Admin (Branch Admin)' LIMIT 1];
        Profile BRMGId = [SELECT Id from Profile where Name='JS Admin Tier 1 (Branch Mgr)' LIMIT 1];
        Profile SAID = [SELECT Id from Profile where Name='Senior Admin' LIMIT 1];
        Profile BOID = [SELECT Id from Profile where Name='Back Office' LIMIT 1];*/
        
        ProfilesUsed__c profileUsed = new ProfilesUsed__c();
        profileUsed.Name = 'JS Recruiter - Hybrid';
        insert profileUsed;
        
        Profile JSId = [SELECT Id from Profile where Name=:profileUsed.Name LIMIT 1];
        
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Client'];
        
        Account acc = new Account();
        acc.IP_Business_Type__c='Catering';
        acc.Name='ClientNew';
        acc.IP_InvoicingMethod__c='Standard';
        acc.recordTypeId=accountRec.id;
        acc.Managed_Account__c = false;
        insert acc; 
        
        User user = new User();
        DateTime dt = DateTime.newInstance(2017, 6, 23, 3, 3, 3);
        Long gettime = dt.getTime();
        user.LastName = 'Virmani';
        user.FirstName='Swati';
        user.Alias = 'svir';
        user.Email = 'swati.vir@outlook.com';
        user.Username = 'Email'+gettime+'@js.com';
        user.ProfileId = JSId.id; 
        user.TimeZoneSidKey = 'GMT';
        user.LanguageLocaleKey = 'en_US';
        user.EmailEncodingKey = 'UTF-8'; 
        user.LocaleSidKey = 'en_US';
        /*user.IP_TempestDepartment__c='1287';
        user.IP_TempestId__c='1287';
        user.IP_TempestDivision__c='NTS';
        user.Department='1287';
        user.IP_PassToTempest__c=false;*/
        insert user;
        system.debug('Value in user'+ user);
        
        
        sirenum__Rate_Card__c rtc = new sirenum__Rate_Card__c();
        rtc.Name ='New Rate Card';
        rtc.IP_AcountLinkCustom__c= acc.id;
        insert rtc;
        
        sirenum__Rate_Card_Page__c rpc = new sirenum__Rate_Card_Page__c();
        rpc.Name ='Default';
        rpc.sirenum__Rate_Card__c = rtc.id;
        rpc.sirenum__SortOrder__c = 126;
        insert rpc;
        System.runAs(user){
            
            try{
            delete rpc;
            }catch(DMLException e){
                System.assert(e.getMessage().contains('You are not allowed to delete the Default Rate Card Page.'), 'You are not allowed to delete the Default Rate Card Page.'); 
            }
        }
       Test.stopTest();
                                  
    }
    
}