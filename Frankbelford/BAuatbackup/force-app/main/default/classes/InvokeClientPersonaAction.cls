public class InvokeClientPersonaAction {
    
    @InvocableMethod(callout=true label='Get Splacement Roles')    
  public static List<List<String>> getSplacementRoles(List<Id> accId) {
   List<List<String>> splacementRoles = new List<List<String>>();
      List<String> splacementRoleLst = new List<String>();
      Date threeMonthsAgoDate = Date.Today().addDays(-90);
      Set<Id> lastTSheetSiteIdSet = new Set<Id>();
      for(sirenum__Site__c eachSite : [Select id,name,sirenum__Operating_Company__r.name,Status__c,Estimated_Temp_Requirements__c,Estimated_Perm_Vacancies__c,Last_Timesheet__c from
                                       sirenum__Site__c where sirenum__Operating_Company__c IN :accId and Status__c = 'Active' and Last_Timesheet__c>=:threeMonthsAgoDate]){
          lastTSheetSiteIdSet.add(eachSite.Id);
      }
          
      
      for(sirenum__Placement__c splacement : [Select id,name,sirenum__Site__r.name,IP_Consultant1LookupSplitShare__r.Role_Name__c from sirenum__Placement__c where Error_Message__c != 'No valid shift found' and sirenum__Site__c in :lastTSheetSiteIdSet]){
          if(splacementRoleLst.isEmpty() || (!splacementRoleLst.isEmpty() && !splacementRoleLst.contains(splacement.IP_Consultant1LookupSplitShare__r.Role_Name__c))){
              splacementRoleLst.add(splacement.IP_Consultant1LookupSplitShare__r.Role_Name__c);
          }
      }
      System.debug('splacementRoleLst:::'+splacementRoleLst);
     splacementRoles.add(splacementRoleLst);
      System.debug('splacementRoles:::'+splacementRoles);
      return splacementRoles;
  } 
    

}