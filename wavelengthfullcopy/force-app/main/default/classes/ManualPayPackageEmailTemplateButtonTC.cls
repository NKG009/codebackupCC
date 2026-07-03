@isTest
public class ManualPayPackageEmailTemplateButtonTC {

    public static testMethod void testMyController() {
        AVTRRT__Config_Settings__c cusSet = new AVTRRT__Config_Settings__c();
        cusSet.Name = 'Default';
        cusSet.AVTRRT__Trigger_Placement__c = true;
        cusSet.AVTRRT__Trigger_Disabled_Trigger_JobApplicants__c = true;
        cusSet.AVTRRT__Trigger_Disabled_Contact__c = true;
        insert cusSet;
        
        Account acc = new Account();
        acc.Name = 'Test Account'; 
        
        insert acc;
        
        Account acc2 = new Account();
        acc2.Name = 'Candidate Pool'; 
        
        insert acc2;
        
        Contact can = new Contact();
        can.FirstName = 'Test';
        can.LastName = 'Candidate';
        can.Email = 'test@targetrecruit.net';
        can.AccountId = acc2.Id;
        can.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Candidate').getRecordTypeId();
        
        insert can;
        
        AVTRRT__Job__c job1 = new AVTRRT__Job__c();
        job1.AVTRRT__Job_Title__c = 'Test';
        job1.AVTRRT__Account_Job__c= acc.Id;
        job1.AVTRRT__Salary_Range__c = 'Less than 25k';
        job1.AVTRRT__Job_City__c = 'California';
        job1.AVTRRT__State__c = 'California';
        job1.AVTRRT__Country_Locale__c = 'US';
        job1.AVTRRT__Job_Postal_Code__c = '23451';
        job1.AVTRRT__Stage__c = 'Open';
        job1.AVTRRT__Job_Summary__c = 'this is job summary';
        job1.AVTRRT__Job_Description__c = 'this is job Description';
        job1.AVTRRT__Publish__c = true;
        job1.AVTRRT__Closed__c =false;
        job1.AVTRRT__Job_Description_Rich__c = 'Testing';
        job1.AVTRRT__Start_Date__c = Date.newInstance(2016, 12, 9);
        job1.AVTRRT__DealSheet_Hours_Per_Day__c = 8;
        job1.AVTRRT__Deal_Sheet_Hours_Per_Week__c = 40;
        
        insert job1;  
        
        AVTRRT__Job_Applicant__c jobApp = new AVTRRT__Job_Applicant__c();
        jobApp.AVTRRT__Contact_Candidate__c = can.Id;
        jobApp.AVTRRT__Job__c = job1.Id;
        jobApp.AVTRRT__Stage__c = 'Auto Match';
        
        insert jobApp;        
        
        // Instantiate a new controller with all parameters in the page
        Test.StartTest(); 
        
        PageReference pageRef = Page.UpdateYes; // Add your VF page Name here
        pageRef.getParameters().put('Id', jobApp.Id);
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(jobApp);
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('Id', jobApp.Id );
        ManualPayPackageEmailTemplateButtonClass ext = new ManualPayPackageEmailTemplateButtonClass(sc); 
        ext.UpdateYes();
        ext.UpdateReqAddInfo();
        ext.UpdateNo();
        
        Test.StopTest();
    }  
}