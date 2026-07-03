/*Author: Salma(21/12/23)
* Helper Name : UpdateratesFromDealSheetToJobAppHelper
* Description: Trigger to Update field values on jobApplicant object from Applicant Deal Sheet
* https://targetrecruit.atlassian.net/browse/UPP-44
*/

public class UpdateratesFromDealSheetToJobAppHelper {
    
    public void updateAppRates(List<AVTRRT__Job_Applicant__c> applicants, boolean dealSheetUpdate)
       {
        Set<Id> dealSheetIds = new Set<Id>();
        
        List<AppDealSheetRatesMappingOnJobApplicant__mdt> metadataRecords = [SELECT Id, Applicant_DealSheet_Field__c, Job_Applicant_Field__c
                                                                     FROM AppDealSheetRatesMappingOnJobApplicant__mdt
                                                                     WHERE Applicant_DealSheet_Field__c != null AND
                                                                     Job_Applicant_Field__c != null];
        
        if (!metadataRecords.isEmpty()) {
            for (AVTRRT__Job_Applicant__c applicant : applicants) {
                if (applicant.AVTRRT__Applicant_Deal_Sheet__c != null) {
                    dealSheetIds.add(applicant.AVTRRT__Applicant_Deal_Sheet__c);
                }
            }
            
            if (!dealSheetIds.isEmpty()) {
                string query = 'SELECT '+getAllObjectFields('AVTRRT__Scratch_Sheet__c')+' FROM AVTRRT__Scratch_Sheet__c WHERE ID IN : dealSheetIds';
                List<AVTRRT__Scratch_Sheet__c> deelsheetRecordsList = Database.query(query);
                Map<Id, AVTRRT__Scratch_Sheet__c> dealSheetRecordsMap = new Map<Id, AVTRRT__Scratch_Sheet__c>(deelsheetRecordsList);
                
                for (AVTRRT__Job_Applicant__c applicant : applicants) {
                    if (applicant.AVTRRT__Applicant_Deal_Sheet__c != null) {
                        for (AppDealSheetRatesMappingOnJobApplicant__mdt mdt : metadataRecords) {
                            applicant.put(mdt.Job_Applicant_Field__c, dealSheetRecordsMap.get(applicant.AVTRRT__Applicant_Deal_Sheet__c).get(mdt.Applicant_DealSheet_Field__c));
                        }
                    }
                }
                
                if (dealSheetUpdate) {
                    update applicants;
                }
            } 
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