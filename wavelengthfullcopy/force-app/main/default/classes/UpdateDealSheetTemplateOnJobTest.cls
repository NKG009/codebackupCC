/**
* Date: 20/12/2023
* Description: UpdateDealSheetTemplaeOnJobBatch Test class
* Case No. : UPP-61   
**/
@isTest
public class UpdateDealSheetTemplateOnJobTest {
    
    private static testMethod void updateDealsheet() {
        
        AVTRRT__Config_Settings__c config = new AVTRRT__Config_Settings__c();
        config.Name = 'Default';
        config.AVTRRT__Do_not_heck_Candidates_for_Duplicates__c = true;
        config.Disable_update_Acc_Addres_To_Job_Address__c = true;
        config.Update_DealSheet_Template_Job_Stages__c = 'Open;Offer Made;';
        insert config;
         
        AVTRRT__Connector__c conn = new AVTRRT__Connector__c();
        conn.AVTRRT__Class__c = 'ConnectorGsaService';
        conn.AVTRRT__Namespace__c = 'TRINTG';
        conn.Name = 'GsaService';
        insert conn;
        
        AVTRRT__Scratch_Sheet__c dealSheet = new AVTRRT__Scratch_Sheet__c();
        dealSheet.Name = 'Standard US - w/Orientation';
        dealSheet.AVTRRT__Regular_Bill_Rate__c = 100;
        dealSheet.AVTRRT__Regular_Pay_Rate__c  = 120;
        dealSheet.AVTRRT__Adjusted_M_I__c  =100;
        dealSheet.AVTRRT__Adjusted_Lodging__c  = 100;
        dealSheet.AVTRRT__State__c = 'NY';
        dealSheet.AVTRRT__Postal_Code__c = '098779';
        dealSheet.AVTRRT__Pay_Lodging_Adjustment_Complete__c = true;
        dealSheet.RecordTypeId = Schema.SObjectType.AVTRRT__Scratch_Sheet__c.getRecordTypeInfosByName().get('Deal Sheet Template').getRecordTypeId();
        insert dealSheet;
        
        
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Industry = 'Real Estate';
        acc.Deal_Sheet_Template__c= dealSheet.Id;
        acc.ShippingStreet = 'commercial street';
        acc.ShippingCity  = 'CA';
        acc.ShippingState = 'CA';
        acc.ShippingPostalCode = '34677';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Contact 01';
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        con.Email = 'testcon@gmail.com';
        con.Title = 'Test Title';
        con.LeadSource = 'Cold Call';
        insert con;
        
        AVTRRT__Job__c job = new AVTRRT__Job__c();
        job.AVTRRT__Account_Job__c = acc.Id;
        job.AVTRRT__Job_Title__c = 'Test Job01';
        job.AVTRRT__Start_Date__c = System.today()-10;
        job.AVTRRT__End_Date__c = System.today();
        job.AVTRRT__State__c = 'Test';
        job.AVTRRT__Hiring_Manager__c = con.Id;
        job.AVTRRT__Stage__c = 'Open';
        job.AVTRRT__Bill_Rate__c = 12;
        job.AVTRRT__Closed__c = false;
        job.AVTRRT__Job_Postal_Code__c = '112233';
        job.AVTRRT__Department__c = 'Therapy';
        insert job;
        
        job.AVTRRT__Job_Postal_Code__c = '112244';
        
        Update job;
        
        AVTRRT__Job__c job1 = new AVTRRT__Job__c();
        job1.AVTRRT__Account_Job__c = acc.Id;
        job1.AVTRRT__Job_Title__c = 'Test Job02';
        job1.AVTRRT__Start_Date__c = System.today()-10;
        job1.AVTRRT__End_Date__c = System.today();
        job1.AVTRRT__State__c = 'Test';
        job1.AVTRRT__Hiring_Manager__c = con.Id;
        job1.AVTRRT__Stage__c = 'Open';
        job1.AVTRRT__Bill_Rate__c = 12;
        job1.AVTRRT__Closed__c = false;
        job1.AVTRRT__Job_Postal_Code__c = '112233';
        job1.AVTRRT__Department__c = 'Nursing';
        insert job1;
        
        job1.AVTRRT__Job_Postal_Code__c = '112255';
        
        Update job1;
        
        UpdateDealSheetTemplateOnJobScheduler scheduler = new UpdateDealSheetTemplateOnJobScheduler();
        String sch = '0 0 23 * * ?'; 
        system.schedule('UpdateDealSheetTemplaeOnJobScheduler', sch, scheduler);
        
        UpdateDealSheetTemplateOnJobBatch batch = new UpdateDealSheetTemplateOnJobBatch();
        Database.executeBatch(batch, 5);
    }
}