/*Author: Ranjith
* Class Name : UpdateratesFromDealSheetHelper
* Description: 1. Helper class to Update field values on Placement from DealSheet
			   2. Used in triggers UpdateratesFromDealSheet and UpdateratesFromDealSheetDLTrigger
*/
public class UpdateratesFromDealSheetHelper {
    
    public void updateRates(List<AVTRRT__Placement__c> placements, boolean dealSheetUpdate) {
        Set<Id> dealSheetIds = new Set<Id>();
        
        List<DealSheetRatesMapping__mdt> metadataRecords = [SELECT Id, Dealsheet_Field__c, Placement_Field__c
                                                            FROM DealSheetRatesMapping__mdt
                                                            WHERE Dealsheet_Field__c != null AND
                                                            Placement_Field__c != null];
        
        if (!metadataRecords.isEmpty()) {
            for (AVTRRT__Placement__c placement : placements) {
                if (placement.AVTRRT__Placement_Deal_Sheet__c != null) {
                    dealSheetIds.add(placement.AVTRRT__Placement_Deal_Sheet__c);
                }
                else if (placement.AVTRRT__Applicant_Deal_Sheet__c != null) {
                    dealSheetIds.add(placement.AVTRRT__Applicant_Deal_Sheet__c);
                }
            }
            
            if (!dealSheetIds.isEmpty()) {
                string query = 'SELECT '+getAllObjectFields('AVTRRT__Scratch_Sheet__c')+' FROM AVTRRT__Scratch_Sheet__c WHERE ID IN : dealSheetIds';
                List<AVTRRT__Scratch_Sheet__c> deelsheetRecordsList = Database.query(query);
                Map<Id, AVTRRT__Scratch_Sheet__c> dealSheetRecordsMap = new Map<Id, AVTRRT__Scratch_Sheet__c>(deelsheetRecordsList);
                
                for (AVTRRT__Placement__c placement : placements) {
                    if (placement.AVTRRT__Placement_Deal_Sheet__c != null) {
                        for (DealSheetRatesMapping__mdt mdt : metadataRecords) {
                            placement.put(mdt.Placement_Field__c, dealSheetRecordsMap.get(placement.AVTRRT__Placement_Deal_Sheet__c).get(mdt.Dealsheet_Field__c));
                        }
                    }
                    else if (placement.AVTRRT__Applicant_Deal_Sheet__c != null) {
                        for (DealSheetRatesMapping__mdt mdt : metadataRecords) {
                            placement.put(mdt.Placement_Field__c, dealSheetRecordsMap.get(placement.AVTRRT__Applicant_Deal_Sheet__c).get(mdt.Dealsheet_Field__c));
                        }
                    }
                }
                
                if (dealSheetUpdate) {
                        update placements;
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