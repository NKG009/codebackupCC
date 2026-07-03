public class stateToJobState {
    
    public static void updateJobState(List<AVTRRT__Job__c> Jobs, Map<Id, AVTRRT__Job__c> oldMap){
        
        List<Job_State_Automation__mdt> metadataRecords = [SELECT State__c, Job_State__c
                                                      FROM Job_State_Automation__mdt
                                                      WHERE State__c != null 
                                                      AND Job_State__c != null];
        
        Map<String, String> stateToJobStateMap = new Map<String, String>();
        for (Job_State_Automation__mdt mdt : metadataRecords) {
            stateToJobStateMap.put(mdt.State__c, mdt.Job_State__c);
        }
       
        for(AVTRRT__Job__c job : Jobs){
            if(oldMap == null || job.AVTRRT__State__c != oldMap.get(job.Id).AVTRRT__State__c){
                  String newJobState = stateToJobStateMap.get(job.AVTRRT__State__c);
                if (newJobState != null) {
                    job.AVTRRT__Job_State__c = newJobState;
                }
               }
        } 
    }
}