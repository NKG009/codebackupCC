/**Test Class - InvokeSitePersonaActionTest*/
public class InvokeSitePersonaAction {
    
     @InvocableMethod(callout=true label='Get Job Roles')    
  public static List<List<String>> getJobRoles(List<Id> siteIdLst) {
   List<List<String>> jobRoleListOut = new List<List<String>>();
      List<String> jobRoleLst = new List<String>();
      Map<Id,List<String>> jobRoleMap = new Map<Id,List<String>>();
    List<sirenum__Timesheet__c> timesheetLst = [SELECT Id,sirenum__Site__c,sirenum__Team__r.Job_Category_Text__c FROM sirenum__Timesheet__c WHERE sirenum__Site__c in :siteIdLst AND sirenum__Team__c != NULL];
      for (sirenum__Timesheet__c eachTimeSheet : timesheetLst) {
          if(jobRoleLst.isEmpty() || !jobRoleLst.contains(eachTimeSheet.sirenum__Team__r.Job_Category_Text__c))
              jobRoleLst.add(eachTimeSheet.sirenum__Team__r.Job_Category_Text__c);
      }
      System.debug('jobRoleLst:::'+jobRoleLst);
     jobRoleListOut.add(jobRoleLst);
      System.debug('jobRoleListOut:::'+jobRoleListOut);
      return jobRoleListOut;
  } 

}