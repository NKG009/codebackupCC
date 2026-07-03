/*Author: Ranjith
* Trigger Name : UpdateratesFromDealSheetDLTrigger
* Description: Trigger to Update field values on Placement from DealSheet
*/

trigger UpdateratesFromDealSheetDLTrigger on AVTRRT__Scratch_Sheet__c (after update) {
    if(AVTRRT__Config_Settings__c.getInstance('Default').Enable_UpdateratesFromDealSheetDLTrigger__c) {
        Set<Id> dealSheetIds = trigger.newMap.keySet();
    string query = 'SELECT '+getAllObjectFields('AVTRRT__Placement__c')+
        ' FROM AVTRRT__Placement__c '+
        ' WHERE AVTRRT__Placement_Deal_Sheet__c IN : dealSheetIds OR'+
        ' AVTRRT__Applicant_Deal_Sheet__c IN : dealSheetIds ';
    List<AVTRRT__Placement__c> placements = Database.query(query);
    
    if (!placements.isEmpty()) {
        UpdateratesFromDealSheetHelper helper = new UpdateratesFromDealSheetHelper();
        helper.updateRates(placements, true);
    } 
    }   
    //abu: https://targetrecruit.atlassian.net/browse/UPP-44 
    if(AVTRRT__Config_Settings__c.getInstance('Default').Enable_UpdateratesFromDStoJobTrigger__c) {
        Set<Id> dealSheetIds = trigger.newMap.keySet();
    string query = 'SELECT '+getAllObjectFields('AVTRRT__Job__c')+
        ' FROM AVTRRT__Job__c '+
        ' WHERE AVTRRT__Deal_Sheet__c IN : dealSheetIds ';
        
    List<AVTRRT__Job__c> jobs = Database.query(query);
    
    if (!jobs.isEmpty()) {
        UpdateratesFromDealSheetToJobHelper helper = new UpdateratesFromDealSheetToJobHelper();
        helper.updateRates(jobs, true);
    } 
    }
    
    //salma: https://targetrecruit.atlassian.net/browse/UPP-45 
    if(!AVTRRT__Config_Settings__c.getInstance('Default').Disable_UpdateratesFromDealSheetDLToJobA__c) {
        //Set<Id> dealSheetIds = trigger.newMap.keySet();
        Set<Id> dealSheetIds = new set<Id>();
        for(AVTRRT__Scratch_Sheet__c sc : [Select Id From AVTRRT__Scratch_Sheet__c where RecordType.Name = 'Applicant Deal Sheet' AND Id in : trigger.newMap.keySet()])
            
        {
           dealSheetIds.add(sc.Id);
            system.debug('sc~>'+sc);
            system.debug('dealSheetIds~>'+dealSheetIds);
        }
    string query = 'SELECT '+getAllObjectFields('AVTRRT__Job_Applicant__c')+
        ' FROM AVTRRT__Job_Applicant__c '+
        ' WHERE AVTRRT__Applicant_Deal_Sheet__c IN : dealSheetIds';
    List<AVTRRT__Job_Applicant__c> applicants = Database.query(query);
    
    if (!applicants.isEmpty()) {
        UpdateratesFromDealSheetToJobAppHelper helper = new UpdateratesFromDealSheetToJobAppHelper();
        helper.updateAppRates(applicants, true);
    }
    }
   
    public String getAllObjectFields(String obj) {
        String fields = '';
        Map<String, Schema.SObjectField> fieldMap = schemaDesc(obj);
        for (Schema.SObjectField field : fieldMap.values()) {
            fields += ',' + field.getDescribe().Name;
        }
        return fields.substring(1);
    }
    
    public static Map<String, Schema.SObjectField> schemaDesc(String obj) {
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(obj).getDescribe().fields.getMap();
        return fieldMap;
    }
}