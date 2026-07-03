trigger PreventCostMatrixdeleetion on sirenum__PayrollCostMatrix__c(before delete)  
{  

    Profile adminId = [SELECT Id from Profile where Name='System Administrator' LIMIT 1];
        if(Trigger.IsDelete && UserInfo.getProfileId() != adminId.id)           
    {
    for(sirenum__PayrollCostMatrix__c pcc : [SELECT Id FROM sirenum__PayrollCostMatrix__c WHERE Id IN (SELECT sirenum__Cost_Matrix__c FROM sirenum__Timesheet_Line__c) AND Id IN :Trigger.oldMap.KeySet()]){
        Trigger.oldMap.get(pcc.Id).adderror('Cost Matrix cannot be deleted as it has TimesheetLine associated');
    }
    }
}