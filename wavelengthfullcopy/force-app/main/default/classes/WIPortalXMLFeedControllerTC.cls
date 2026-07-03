@isTest
public class WIPortalXMLFeedControllerTC 
{
    @isTest
    public static void test1(){
        
        AVTRRT__Config_Settings__c cusSet = new AVTRRT__Config_Settings__c();
        cusSet.Name = 'Default';
        //  cusSet.put('Enable_UpdateratesFromDealSheetToJob__c',false);
        insert cusSet;
        
        
        
        TR_CustomSettings__c customSetting = new TR_CustomSettings__c(WIPortalXMLFeedPageRecordCount__c ='50');
        insert customSetting;
        
        User user = new User();
        user.FirstName = 'Test9';
        user.LastName = 'User9';
        user.Alias = 'test9';
        user.Email = 'testuser432@targetrecruit.net';
        user.Username = 'testuser923@targetrecruit.net';
        user.CommunityNickname = 'tNickName9';
        user.ProfileId = [SELECT Id FROM Profile WHERE name =: 'System Administrator'].Id;
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.LocaleSidKey = 'en_US';
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.Phone='75678987667';
        insert user;
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.BillingState = 'Texas';
        acc.Type = 'Other';
        acc.ShippingCity = 'ORLANDO';
        acc.Shippingcountry = 'United States';
        
        
        
        AVTRRT__Job__c job=New AVTRRT__Job__c();
        //job.AVTRRT__Account_Job__c = acc.Id;
        job.AVTRRT__Job_Title__c = 'Test Job01';
        job.AVTRRT__Start_Date__c = System.today() + 10;
        job.AVTRRT__Publish__c = true;
        job.AVTRRT__Stage__c = 'Open';
      
        job.AVTRRT__Closed_Qualifiers__c = 'On Hold';
        job.Regular_Bill_Rate__c  = 10;
        job.AVTRRT__Job_Time_Zone__c = '-CST';
        job.AVTRRT__Job_Summary__c = 'Test';
        job.AVTRRT__Salary_Range__c = '';
        job.AVTRRT__Department__c = 'Therapy';
        job.AVTRRT__Job_Term__c = '1';
        job.AVTRRT__Account_Job__c = acc.id;
        job.AVTRRT__Number_of_Positions__c = 2;
        job.AVTRRT__Job_Postal_Code__c = '60195';
        job.AVTRRT__DealSheet_Hours_Per_Day__c = 1;
        job.AVTRRT__Deal_Sheet_Hours_Per_Week__c = 1;
        job.AVTRRT__Job_Description_Rich__c = 'Test Description';
        job.Salary__c = 100;
        job.RecordTypeId = [select id, name from RecordType where name = 'Staffing Job' limit 1].id;
        job.AVTRRT__Job_State__c = 'Alabama';
        job.AVTRRT__Job_City__c = 'San Francisco';
        job.AVTRRT__Job_Postal_Code__c = '94115';
        job.Job_Type__c = 'Locum';
        job.AVTRRT__Closed__c = false;
        job.Primary_Specialty__c ='Diabetes';
        job.AVTRRT__End_Date__c = System.today() + 10;
        job.Business_Entity__c='Wavelength International';
        job.Regular_Pay_Rate__c=100;
        job.Rate_Type__c='Per day';
        job.Requirements__c='Test';
        job.Inclusions__c='Test';
        job.Category__c='Doctor';
        job.Sub_Specialty_New__c='Gynae-oncology'; 
        job.Specialty_NEW__c='Obstetrics & Gynaecology'; 
        job.Seniority_NEW__c='Intern'; 
        job.AVTRRT__Recruiter__c=user.id;
        job.AVTRRT__AutoPopulated_Skills__c='Test';
        
        insert job;
        
        
        
        ApexPages.currentPage().getParameters().put('page','1');
        
        test.startTest();
        
        WIPortalXMLFeedController xml1 =New WIPortalXMLFeedController();
        test.stopTest();
    }
    
 

}