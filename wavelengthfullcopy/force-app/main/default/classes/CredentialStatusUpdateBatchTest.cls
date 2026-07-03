@isTest
public class CredentialStatusUpdateBatchTest {
     @isTest
    static void testBatchLogic() {
        AVTRRT__Config_Settings__c configSettings = new AVTRRT__Config_Settings__c(Name='Default', AVTRRT__Trigger_Disabled_Trigger_JobApplicants__c= true , 
                                                                                   Disable_update_Acc_Addres_To_Job_Address__c = true,
                                                                                   Credential_Status_To_Exclude_from_Status__c ='Expired',
                                                                                   Job_Applicant_Rejected_Stages__c='Stage1=Rejected by Candidate;Stage2=Rejected by Client');
        insert configSettings;
        
        CRDNTLS__CredentialsCustomSettings__c cs = new CRDNTLS__CredentialsCustomSettings__c();
        cs.Name = 'Default';
        cs.CRDNTLS__Disable_CredentialsAnswerTrigger__c = true;
        insert cs;
        
        User user = [Select Id from User where Profile.Name = 'System Administrator' limit 1];
        
        Account acc = new Account();
        acc.Name = 'PH';
        acc.Industry = 'Real Estate';
        acc.ShippingStreet = 'commercial street';
        acc.Account_Status__c = 'Active';
        acc.AVTRRT__Required__c = false;
        acc.Payroll_Tax_Exempt__c = false;
        acc.ShippingCity  = 'CA';
        acc.CRDNTLS__Credentials_Pack__c = 'STD-Standard;STE-NSW-PH';
        acc.ShippingState = 'CA';
        acc.ShippingPostalCode = '34677';
        acc.AVTRRT__Time_Zone__c = 'Alaska';
        acc.Business_Entity__c = 'Wavelength International';
        acc.AVTRRT__Update_Gross_Values__c = false;
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
        can.AVTRRT__Recruiter__c = user.Id;
        can.AVTRRT__Candidate_Status__c = '1st Interview';
        can.AVTRRT__Source__c = 'Direct Sourced';
        insert can;
        
        CRDNTLS__CredentialQuestion__c cq = new CRDNTLS__CredentialQuestion__c();
        cq.CRDNTLS__IsActive__c = true;
        cq.CRDNTLS__Type__c = 'STD-Standard;STE-NSW-PH';
        insert cq;
        
        
        
        AVTRRT__Job__c job = new AVTRRT__Job__c(                                                                   // Grade
            AVTRRT__Job_Country__c = 'US--None--US',                                                                 // Job Country
            AVTRRT__Stage__c = 'Job Opening',                                                                     // Approval Status
            AVTRRT__Job_Description__c = 'test',                                                     // Candidate Search
            AVTRRT__Job_Title__c = 'Developer 09.01 - Demo',                // Last Update Note
            AVTRRT__Account_Job__c = acc.Id,                                                           // Deal Sheet
            AVTRRT__Hiring_Manager__c = con.id,                                                           // Client Manager
            AVTRRT__Number_of_Positions__c = 1,                                                                     // Auto-Route Job Listing?
            AVTRRT__Account_Manager__c = user.Id,                                                          // Account Manager
            AVTRRT__Closed__c = false,                                                                               // Closed
            AVTRRT__Publish__c = false,                                                                       // Urgent
            AVTRRT__Start_Date__c = System.now().Date()+1,                                                     // Expected Start Date
            AVTRRT__End_Date__c = System.now().Date()+10,                                                          // Background Check Required
            AVTRRT__Bill_Rate__c = 100.00,                                                             // Phase/Lifecycle
            AVTRRT__Street_Address__c = '2816 Blackwood Dr',                                                         // Street Address
            AVTRRT__Job_City__c = 'Arlington',                                                                       // City
            AVTRRT__Job_Time_Zone__c = 'Alaska',                                                                     // Job Time Zone
            AVTRRT__State__c = 'TX',                                                                                 // State
            AVTRRT__Job_Postal_Code__c = '76013',                                                                    // Postal Code
            AVTRRT__Country_Locale__c = 'US',                                                                        // Country
            AVTRRT__Number_of_Applicants__c = 3,                                                                   // Number of Applicants
            AVTRRT__Job_Description_Rich__c = 'test',                                                // Deal Sheet Template
            AVTRRT__DealSheet_Default_Pay_Rate__c = 40, 
            AVTRRT__Closed_Qualifiers__c = 'On Hold',
            AVTRRT__Job_State__c = 'NSW',
            Category__c = 'Doctor',
            Seniority_NEW__c = 'Intern',
            Specialty_NEW__c = 'Obstetrics & Gynaecology'
        );
        insert job;
        
        
        AVTRRT__Job_Applicant__c jobApplicant1 = new AVTRRT__Job_Applicant__c(AVTRRT__Account_Job__c = acc.Id,Business_Entity__c = 'Wavelength International',AVTRRT__Stage__c='Rejected by Candidate', AVTRRT__Job__c = job.Id,AVTRRT__Contact_Candidate__c = can.Id);
        insert jobApplicant1;
        
        Credential_Requirement__c cr = new Credential_Requirement__c(Job_Applicant__c = jobApplicant1.Id, Candidate__c = can.Id,Credential_Master__c = cq.Id);
        insert cr;
        
        CRDNTLS__Credentials_Answers__c ca = new CRDNTLS__Credentials_Answers__c();
        ca.CRDNTLS__Contact__c = can.Id;
        ca.CRDNTLS__Credentials_Question_ID__c = cq.Id;
        ca.CRDNTLS__Expiration_Date__c = System.Today()+30;
        insert ca;
        CRDNTLS__Credentials_Answers__c cb = new CRDNTLS__Credentials_Answers__c();
        cb.CRDNTLS__Contact__c = can.Id;
        cb.CRDNTLS__Credentials_Question_ID__c = cq.Id;
        cb.CRDNTLS__Expiration_Date__c = System.Today()+60;
        insert cb;
        CRDNTLS__Credentials_Answers__c cc = new CRDNTLS__Credentials_Answers__c();
        cc.CRDNTLS__Contact__c = can.Id;
        cc.CRDNTLS__Credentials_Question_ID__c = cq.Id;
        cc.CRDNTLS__Expiration_Date__c = System.Today()+90;
        insert cc;
        
        cr.Credential__c = ca.Id;
        update cr;

        
        CredentialStatusUpdateScheduler scheduler = new CredentialStatusUpdateScheduler();
        String sch = '0 0 23 * * ?'; 
        system.schedule('UpdateCredentialRequirementScheduler', sch, scheduler);
        
        Test.startTest();
        
        CredentialStatusUpdateBatch batch = new CredentialStatusUpdateBatch();
        Database.executeBatch(batch, 10);

		String result = CredentialStatusUpdateBatchController.runBatch();
        Test.stopTest();
        CRDNTLS__Credentials_Answers__c cred = [select Id,CRDNTLS__Status__c from CRDNTLS__Credentials_Answers__c where id=:ca.Id];
        CRDNTLS__Credentials_Answers__c cred2 = [select Id,CRDNTLS__Status__c from CRDNTLS__Credentials_Answers__c where id=:cb.Id];
        CRDNTLS__Credentials_Answers__c cred3 = [select Id,CRDNTLS__Status__c from CRDNTLS__Credentials_Answers__c where id=:cc.Id];


        System.assertEquals(cred.CRDNTLS__Status__c,'Expiring within 30 days');
        System.assertEquals(cred2.CRDNTLS__Status__c,'Expiring within 60 days');
        System.assertEquals(cred3.CRDNTLS__Status__c,'Expiring within 90 days');
        
    }

@IsTest
    static void testRunBatch_NoExistingBatch() {

		AVTRRT__Config_Settings__c configSettings = new AVTRRT__Config_Settings__c(Name='Default', AVTRRT__Trigger_Disabled_Trigger_JobApplicants__c= true , 
                                                                                   Disable_update_Acc_Addres_To_Job_Address__c = true,
                                                                                   Credential_Status_To_Exclude_from_Status__c ='Expired',
                                                                                   Job_Applicant_Rejected_Stages__c='Stage1=Rejected by Candidate;Stage2=Rejected by Client');
        insert configSettings;
        
        CRDNTLS__CredentialsCustomSettings__c cs = new CRDNTLS__CredentialsCustomSettings__c();
        cs.Name = 'Default';
        cs.CRDNTLS__Disable_CredentialsAnswerTrigger__c = true;
        insert cs;
        
        User user = [Select Id from User where Profile.Name = 'System Administrator' limit 1];
        
        Account acc = new Account();
        acc.Name = 'PH';
        acc.Industry = 'Real Estate';
        acc.ShippingStreet = 'commercial street';
        acc.Account_Status__c = 'Active';
        acc.AVTRRT__Required__c = false;
        acc.Payroll_Tax_Exempt__c = false;
        acc.ShippingCity  = 'CA';
        acc.CRDNTLS__Credentials_Pack__c = 'STD-Standard;STE-NSW-PH';
        acc.ShippingState = 'CA';
        acc.ShippingPostalCode = '34677';
        acc.AVTRRT__Time_Zone__c = 'Alaska';
        acc.Business_Entity__c = 'Wavelength International';
        acc.AVTRRT__Update_Gross_Values__c = false;
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
        can.AVTRRT__Recruiter__c = user.Id;
        can.AVTRRT__Candidate_Status__c = '1st Interview';
        can.AVTRRT__Source__c = 'Direct Sourced';
        insert can;
        
        CRDNTLS__CredentialQuestion__c cq = new CRDNTLS__CredentialQuestion__c();
        cq.CRDNTLS__IsActive__c = true;
        cq.CRDNTLS__Type__c = 'STD-Standard;STE-NSW-PH';
        insert cq;
        
        
        
        AVTRRT__Job__c job = new AVTRRT__Job__c(                                                                   // Grade
            AVTRRT__Job_Country__c = 'US--None--US',                                                                 // Job Country
            AVTRRT__Stage__c = 'Job Opening',                                                                     // Approval Status
            AVTRRT__Job_Description__c = 'test',                                                     // Candidate Search
            AVTRRT__Job_Title__c = 'Developer 09.01 - Demo',                // Last Update Note
            AVTRRT__Account_Job__c = acc.Id,                                                           // Deal Sheet
            AVTRRT__Hiring_Manager__c = con.id,                                                           // Client Manager
            AVTRRT__Number_of_Positions__c = 1,                                                                     // Auto-Route Job Listing?
            AVTRRT__Account_Manager__c = user.Id,                                                          // Account Manager
            AVTRRT__Closed__c = false,                                                                               // Closed
            AVTRRT__Publish__c = false,                                                                       // Urgent
            AVTRRT__Start_Date__c = System.now().Date()+1,                                                     // Expected Start Date
            AVTRRT__End_Date__c = System.now().Date()+10,                                                          // Background Check Required
            AVTRRT__Bill_Rate__c = 100.00,                                                             // Phase/Lifecycle
            AVTRRT__Street_Address__c = '2816 Blackwood Dr',                                                         // Street Address
            AVTRRT__Job_City__c = 'Arlington',                                                                       // City
            AVTRRT__Job_Time_Zone__c = 'Alaska',                                                                     // Job Time Zone
            AVTRRT__State__c = 'TX',                                                                                 // State
            AVTRRT__Job_Postal_Code__c = '76013',                                                                    // Postal Code
            AVTRRT__Country_Locale__c = 'US',                                                                        // Country
            AVTRRT__Number_of_Applicants__c = 3,                                                                   // Number of Applicants
            AVTRRT__Job_Description_Rich__c = 'test',                                                // Deal Sheet Template
            AVTRRT__DealSheet_Default_Pay_Rate__c = 40, 
            AVTRRT__Closed_Qualifiers__c = 'On Hold',
            AVTRRT__Job_State__c = 'NSW',
            Category__c = 'Doctor',
            Seniority_NEW__c = 'Intern',
            Specialty_NEW__c = 'Obstetrics & Gynaecology'
        );
        insert job;
        
        
        AVTRRT__Job_Applicant__c jobApplicant1 = new AVTRRT__Job_Applicant__c(AVTRRT__Account_Job__c = acc.Id,Business_Entity__c = 'Wavelength International',AVTRRT__Stage__c='Rejected by Candidate', AVTRRT__Job__c = job.Id,AVTRRT__Contact_Candidate__c = can.Id);
        insert jobApplicant1;
        
        Credential_Requirement__c cr = new Credential_Requirement__c(Job_Applicant__c = jobApplicant1.Id, Candidate__c = can.Id,Credential_Master__c = cq.Id);
        insert cr;
        
        CRDNTLS__Credentials_Answers__c ca = new CRDNTLS__Credentials_Answers__c();
        ca.CRDNTLS__Contact__c = can.Id;
        ca.CRDNTLS__Credentials_Question_ID__c = cq.Id;
        ca.CRDNTLS__Expiration_Date__c = System.Today()+30;
        insert ca;
        CRDNTLS__Credentials_Answers__c cb = new CRDNTLS__Credentials_Answers__c();
        cb.CRDNTLS__Contact__c = can.Id;
        cb.CRDNTLS__Credentials_Question_ID__c = cq.Id;
        cb.CRDNTLS__Expiration_Date__c = System.Today()+60;
        insert cb;
        CRDNTLS__Credentials_Answers__c cc = new CRDNTLS__Credentials_Answers__c();
        cc.CRDNTLS__Contact__c = can.Id;
        cc.CRDNTLS__Credentials_Question_ID__c = cq.Id;
        cc.CRDNTLS__Expiration_Date__c = System.Today()+90;
        insert cc;
        
        cr.Credential__c = ca.Id;
        update cr;
        
        Test.startTest();
        String result = CredentialStatusUpdateBatchController.runBatch();
        Test.stopTest();
        
        // Verify: The result should indicate that the batch was initiated
        System.assertEquals('Batch initiated successfully', result, 'Batch should have started.');

        // Verify: Check if a new batch job was created
        List<AsyncApexJob> jobs = [SELECT Id, Status FROM AsyncApexJob 
                                   WHERE JobType = 'BatchApex' 
                                   AND ApexClass.Name = 'CredentialStatusUpdateBatch'];
    }


}