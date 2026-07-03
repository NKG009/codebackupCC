trigger NoDeleteOfTimeSheetLineAfterPassToPayroll on sirenum__Timesheet_Line__c (before delete) {
Profile adminId = [SELECT Id from Profile where Name='System Administrator' LIMIT 1];
    if(Trigger.IsDelete && UserInfo.getProfileId() != adminId.id)
    {
    for(sirenum__Timesheet_Line__c sheetline : [SELECT Id,sirenum__Timesheet__r.IP_TSLinesWithGUIDs__c,sirenum__Timesheet__r.IP_TSLinesPassedToTempest__c FROM sirenum__Timesheet_Line__c WHERE Id IN :Trigger.oldMap.KeySet()]){
        if(sheetline.sirenum__Timesheet__r.IP_TSLinesWithGUIDs__c>0 || sheetline.sirenum__Timesheet__r.IP_TSLinesPassedToTempest__c>0 )
        {
        Trigger.oldMap.get(sheetline.Id).adderror('Timesheet line is locked, data is passed to Payroll');
        }
    }
    }
}