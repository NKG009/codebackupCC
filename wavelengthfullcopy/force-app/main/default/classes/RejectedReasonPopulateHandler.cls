public class RejectedReasonPopulateHandler {
    public void updateReason(List<AVTRRT__Job_Applicant__c> jobApplicantList){
        AVTRRT__Config_Settings__c settings = AVTRRT__Config_Settings__c.getInstance('Default');

            List<String> stagesSet = settings.Job_Applicant_Rejected_Stages__c.split(';');

            for (AVTRRT__Job_Applicant__c jobApp : jobApplicantList) {
                if (jobApp.AVTRRT__Reject_Qualifiers__c == null && stagesSet.contains(jobApp.AVTRRT__Stage__c)) {
                    jobApp.AVTRRT__Reject_Qualifiers__c.addError('Please add Reject Qualifiers');
                } 
              /*else {
                        jobApp.AVTRRT__Reject_Qualifiers__c = '';
                        jobApp.Who_Rejected__c = '';
                    }
                } */
            }
        }
    
}