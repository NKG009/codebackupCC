/*Author: Abu Talib(14/12/23)
* Helper Name : UpdateratesFromDealSheetToJobHelper
* Description: Trigger to Update field values on job object from DealSheet
* https://targetrecruit.atlassian.net/browse/UPP-44
*/public class UpdateratesFromDealSheetToJobHelper {
    public void updateRates(List<AVTRRT__Job__c> jobs, boolean dealSheetUpdate) {
        Set<Id> jobIds=New Set<ID>();
        for(AVTRRT__Job__c job : jobs)
        {
            jobIds.add(job.Id);
        }
        List<AVTRRT__Job__c> jobList =[select AVTRRT__Deal_Sheet__c,Regular_Pay_Rate__c,Regular_Bill_Rate__c
                                               from AVTRRT__Job__c where Id IN : jobIds];
        Set<Id> dealSheetIds = new Set<Id>();
        List<dealsheetRateFieldWIthJobRateFieldMappin__mdt> metadataRecords = [SELECT Id, Dealsheet_Field__c, Job_Field__c
                                                            FROM dealsheetRateFieldWIthJobRateFieldMappin__mdt
                                                            WHERE Dealsheet_Field__c != null AND
                                                            Job_Field__c != null];
        
        if (!metadataRecords.isEmpty()) {
            for (AVTRRT__Job__c job : jobList) {
                if (job.AVTRRT__Deal_Sheet__c != null) {
                    dealSheetIds.add(job.AVTRRT__Deal_Sheet__c);
                }
                
            }
            
            if (!dealSheetIds.isEmpty()) {
                string query = 'SELECT '+getAllObjectFields('AVTRRT__Scratch_Sheet__c')+' FROM AVTRRT__Scratch_Sheet__c WHERE ID IN : dealSheetIds';
                List<AVTRRT__Scratch_Sheet__c> deelsheetRecordsList = Database.query(query);
                Map<Id, AVTRRT__Scratch_Sheet__c> dealSheetRecordsMap = new Map<Id, AVTRRT__Scratch_Sheet__c>(deelsheetRecordsList);
                
                for (AVTRRT__Job__c job : jobList) {
                    if (job.AVTRRT__Deal_Sheet__c != null) {
                        for (dealsheetRateFieldWIthJobRateFieldMappin__mdt mdt : metadataRecords) {
                            job.put(mdt.Job_Field__c, dealSheetRecordsMap.get(job.AVTRRT__Deal_Sheet__c).get(mdt.Dealsheet_Field__c));
                        }
                    }
                    
                    
                }
                
                if (dealSheetUpdate) {
                    update jobList;
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