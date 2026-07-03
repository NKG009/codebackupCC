@Istest
public class UpdateratesFromDealSheetDLTriggerTC 
{
    public static testMethod void dealsheet()
    {  
        AVTRRT__Config_Settings__c cs = new AVTRRT__Config_Settings__c();
        cs.Name = 'Default';
        cs.Enable_UpdateratesFromDealSheet__c = true;
        cs.Enable_UpdateratesFromDealSheetDLTrigger__c = true;
        insert cs;
        
        AVTRRT__Connector__c conn = new AVTRRT__Connector__c();
        conn.AVTRRT__Class__c = 'ConnectorGsaService';
        conn.AVTRRT__Namespace__c = 'TRINTG';
        conn.Name = 'GsaService';
        insert conn;
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Contact 01';
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        con.Email = 'testcon@gmail.com';
        con.Title = 'Test Title';
        con.LeadSource = 'Cold Call';
        insert con;
        
        Contact can = new Contact();
        can.FirstName = 'Test';
        can.LastName = 'Candidate 01';
        can.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Candidate').getRecordTypeId();
        can.Email = 'test01@gmail.com';
        insert can;
        
        AVTRRT__Job__c job = new AVTRRT__Job__c();
        job.AVTRRT__Account_Job__c = acc.Id;
        job.AVTRRT__Job_Title__c = 'Test Job01';
        job.AVTRRT__Job_State__c = 'Active';
        job.AVTRRT__Hiring_Manager__c = con.Id;
        job.AVTRRT__Start_Date__c = System.today();
        insert job;
        
        AVTRRT__Job_Applicant__c ja = new AVTRRT__Job_Applicant__c();
        ja.AVTRRT__Job__c = job.Id;
        ja.AVTRRT__Job_Title__c = 'Test Job Title';
        ja.AVTRRT__Contact_Candidate__c = can.Id;
        ja.AVTRRT__Account_Job__c = acc.Id;
        ja.AVTRRT__Hiring_Manager__c = con.Id;
        insert ja;
        
        
        
        AVTRRT__Scratch_Sheet__c ssheet = new AVTRRT__Scratch_Sheet__c();
        ssheet.Name = can.FirstName;
        insert ssheet;
        
        update ssheet;
        
        AVTRRT__Scratch_Sheet__c dealSheet = new AVTRRT__Scratch_Sheet__c();
        dealSheet.RecordTypeId = Schema.SObjectType.AVTRRT__Scratch_Sheet__c.getRecordTypeInfosByName().get('Applicant Deal Sheet').getRecordTypeId();
        dealSheet.Name = 'Test Deal Sheet';
        insert dealSheet;
        
        AVTRRT__Placement__c pl = new AVTRRT__Placement__c();
        pl.AVTRRT__Employer__c = acc.Id;
        
        pl.AVTRRT__Hiring_Manager__c = con.Id;
        pl.AVTRRT__Contact_Candidate__c = can.Id;
        pl.AVTRRT__Job__c = job.Id;
        pl.AVTRRT__Applicant_Deal_Sheet__c = ssheet.Id;
        pl.AVTRRT__Job_Applicant__c = ja.Id;
        pl.AVTRRT__Contract__c = 'Project Deployment';
        pl.AVTRRT__Job_Title__c = 'Test Job Title';
        pl.AVTRRT__Start_Date__c = System.now().Date();
        pl.AVTRRT__Date_Accepted__c = System.now().Date();
        pl.AVTRRT__End_Date__c = System.now().Date() + 10;
        pl.AVTRRT__Bill_Rate__c = '100';
        insert pl ;
        
        pl.AVTRRT__Bill_Rate__c = '200';
        update pl;
    }
}