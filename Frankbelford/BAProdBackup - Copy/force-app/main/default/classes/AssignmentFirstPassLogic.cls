global class AssignmentFirstPassLogic {
    @InvocableMethod
    global static void CancelShiftSiteOnHold(List<ID> ids){
        Set<ID> conID = new Set<ID>();
        
        List<sirenum__Timesheet__c> timeSheetPlacement = [select id,name,sirenum__Worker__c from sirenum__Timesheet__c where id in: ids];
        for(sirenum__Timesheet__c tmsht : timeSheetPlacement)
            conID.add(tmsht.sirenum__Worker__c);
        List<sirenum__Placement__c> placementRecords = [select id,name,IP_LastPassedToTempest__c,IP_PassToTempest__c from sirenum__Placement__c where sirenum__Contact__r.id in: conID];
        for(sirenum__Placement__c plc: placementRecords){
            if(plc.IP_LastPassedToTempest__c==null){
                plc.IP_PassToTempest__c = true;
            }
        }
        update placementRecords;
    }
}