trigger ShiftDelete on sirenum__Shift__c (before delete) {
    if(Trigger.isDelete){
        List<sirenum__Shift__c> shiftid =new List<sirenum__Shift__c>();
        Set<id> sftid = new Set<id>();
        for(sirenum__Shift__c sft:Trigger.old){
            sftid.add(sft.id) ;
        }
        
        Map<Id, sirenum__Shift__c> shifts = new Map<Id, sirenum__Shift__c>();
       
        for(sirenum__Shift__c sht:[Select Id,sirenum__Placement__c, (Select Id,IP_PassToTempest__c,IP_LastPassedToTempest__c from sirenum__Timesheet_Lines__r where IP_PassToTempest__c =true or IP_LastPassedToTempest__c!=null)
                                   from sirenum__Shift__c where id in :sftid ]){
                                      
            
            if(sht.Id!=null ||sht.Id!='' )
            {
                                                       
                for(sirenum__Timesheet_Line__c tsl:sht.sirenum__Timesheet_Lines__r)
                {  
                    if((tsl.IP_PassToTempest__c == TRUE || tsl.IP_LastPassedToTempest__c!= NULL) && sht.sirenum__Placement__c!= NULL)
                    { 
                        Trigger.oldMap.get(sht.Id).addError('You can not delete shift associated with Placement and corresponding Timesheetline Pass to tempest is true');
                    }  
                                  
                }
            }
            
        }
   /* Profile adminId = [SELECT Id from Profile where Name='System Administrator' LIMIT 1];
    if(UserInfo.getProfileId() != adminId.id)
    {
    for(sirenum__Shift__c shft : [SELECT Id,sirenum__Published__c From sirenum__Shift__c WHERE Id IN :Trigger.oldMap.KeySet()]){
        if(shft.sirenum__Published__c)
        {
        Trigger.oldMap.get(shft.Id).adderror('You cannot delete a published shift');
        }
    }
    }*/
    }
}