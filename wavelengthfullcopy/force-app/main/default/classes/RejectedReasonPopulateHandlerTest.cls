@isTest
private class RejectedReasonPopulateHandlerTest {

   
     @isTest
    static void testUpdateReason1() {
        AVTRRT__Config_Settings__c cs = new AVTRRT__Config_Settings__c();
        cs.Name = 'Default';
        cs.AVTRRT__Trigger_Placement__c = true;
        cs.AVTRRT__Trigger_Disabled_Contact__c  = true;
        cs.AVTRRT__Trigger_Disabled_Trigger_JobApplicants__c = true;
        cs.AVTRRT__Trigger_Disabled_Trigger_Job__c= true;
        cs.AVTRRT__Enable_Geosearch_for_Account__c = False;
        cs.AVTRRT__Trigger_Disabled_Trigger_JobApplicants__c = true;
        cs.Disable_update_Acc_Addres_To_Job_Address__c = true;
        cs.Enable_UpdateratesFromDealSheet__c = true;
        cs.Enable_UpdateratesFromDealSheetDLTrigger__c = true;
        cs.Enable_UpdateratesFromDealSheetToJob__c = true;
        cs.Enable_UpdateratesFromDStoJobTrigger__c = true;
        cs.Disable_update_Acc_Addres_To_Job_Address__c = true;
        cs.Job_Applicant_Rejected_Stages__c='Rejected by Candidate=Candidate;Rejected by Client=Client';
        //cs.Disabled_UpdateRejectedReasonTrigger__c = true;
        
        
        insert cs;
        
        AVTRRT__ConfigSettingsHierarchy__c csH = new AVTRRT__ConfigSettingsHierarchy__c();
        //csH.Name = 'Default';
        csH.AVTRRT__Enable_Set_Job_Fields_On_Creation__c = False;
        
        Account acc = new Account();
        acc.Name = 'Test Account';          
        insert acc;
        
        /*AVTRRT__Config_Settings__c configSettings = new AVTRRT__Config_Settings__c(Name='Default', Job_Applicant_Rejected_Stages__c='Rejected by Candidate=Candidate;Rejected by Client=Client');
        insert configSettings;*/

        AVTRRT__Job_Applicant__c jobApplicant1 = new AVTRRT__Job_Applicant__c(
            AVTRRT__Stage__c='Rejected by Account Manager',
            AVTRRT__Reject_Qualifiers__c='ABCD'  
        );
        //insert jobApplicant1;
        AVTRRT__Job_Applicant__c jobApplicant2 = new AVTRRT__Job_Applicant__c(
            AVTRRT__Stage__c='Rejected by Recruiter',
            AVTRRT__Reject_Qualifiers__c='EFGH'  
        );
        
        AVTRRT__Job_Applicant__c jobApplicant3 = new AVTRRT__Job_Applicant__c(
            AVTRRT__Stage__c='Rejected by Client',
            AVTRRT__Reject_Qualifiers__c='IJKL' 
        );
        
        
        List<AVTRRT__Job_Applicant__c> jobApplicantList = new List<AVTRRT__Job_Applicant__c>{jobApplicant1, jobApplicant2, jobApplicant3};

        Test.startTest();

        RejectedReasonPopulateHandler handler = new RejectedReasonPopulateHandler();
        handler.updateReason(jobApplicantList);
        

        Test.stopTest();

        
        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Candidate').getRecordTypeId();
        Contact con = new Contact();
        con.LastName = 'Test Candidate';          
        con.RecordTypeId = RecordTypeIdContact;
        con.AccountId = acc.Id;
        con.AVTRRT__Candidate_Status__c = 'Prospect';
        insert con; 
        
        Contact con2 = new Contact();
        con2.LastName = 'Test2 Candidate';          
        con2.RecordTypeId = RecordTypeIdContact;
        con2.AccountId = acc.Id;
        con2.AVTRRT__Candidate_Status__c = 'Prospect';
        insert con2; 
        
        Profile pObj = [select id from Profile limit 1];
        User userObj = new User(FirstName = 'Dev',
                                LastName = 'Smith',
                                Email = 'smith@gmail.com',
                                Username = 'smith@gmail.com.JBC',
                                ProfileId = pObj.id,
                                Alias = 'dSmith',
                                CommunityNickname = 'dSmith',
                                TimeZoneSidKey = 'America/Chicago',
                                LocaleSidKey = 'en_IN',
                                EmailEncodingKey='UTF-8',
                                LanguageLocaleKey = 'en_US');
        insert userObj;
        
        AVTRRT__Job__c job = new AVTRRT__Job__c();
        job.AVTRRT__Job_Title__c = 'Test';
        job.AVTRRT__Recruiter__c = userObj.Id;
        job.AVTRRT__Stage__c = 'Test3';
        insert job;
        
        List<AVTRRT__Job_Applicant__c> JaList = new List<AVTRRT__Job_Applicant__c>();
        
        AVTRRT__Job_Applicant__c jobapp = new AVTRRT__Job_Applicant__c();
        jobapp.AVTRRT__Job_Title__c = 'Test';
        jobapp.AVTRRT__Contact_Candidate__c = con.Id;
        jobapp.AVTRRT__Account_Job__c = acc.Id;
        jobapp.AVTRRT__Stage__c = 'Waiting for Approval';
        JaList.add(jobapp);
        
        AVTRRT__Job_Applicant__c jobapp2 = new AVTRRT__Job_Applicant__c();
        jobapp2.AVTRRT__Job_Title__c = 'Test';
        jobapp2.AVTRRT__Contact_Candidate__c = con2.Id;
        jobapp2.AVTRRT__Account_Job__c = acc.Id;
        jobapp2.AVTRRT__Stage__c = 'Short Listed';
        JaList.add(jobapp2);
        
        Insert JaList;
        
        
        try{
            for(AVTRRT__Job_Applicant__c k : JaList) {
            AVTRRT__Job_Applicant__c st = new AVTRRT__Job_Applicant__c();
            st.Id = k.Id;
            st.AVTRRT__Stage__c = 'Rejected by Account Manager';
            
            if (k.AVTRRT__Reject_Qualifiers__c == null) {
                st.AVTRRT__Reject_Qualifiers__c = '';
            }

            update st;
        }
        }
            catch(Exception e){
               
            }
        
        
    }
}