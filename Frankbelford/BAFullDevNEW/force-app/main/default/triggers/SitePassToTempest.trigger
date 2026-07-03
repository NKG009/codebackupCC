trigger SitePassToTempest on sirenum__Site__c (before update,after insert, after update) {
    Payroll_Swtich__c Payroll = Payroll_Swtich__c.getValues('Stoppayroll'); 
    if(!Payroll.Batch_check__c)
    {
        if(trigger.isBefore && (Trigger.isUpdate)){ 
            for (SObject so : Trigger.old)
            {
                
                sirenum__Site__c oldsite = (sirenum__Site__c)so;
                sirenum__Site__c newsite = Trigger.newMap.get(so.Id);
                if( ( newsite.IP_PassClientToTempest__c != oldsite.IP_PassClientToTempest__c)  && newsite.IP_EmergencyPullClient__c == False && newsite.IP_PassClientToTempest__c == True  && newsite.IP_TempestDepartment__c!= '0000')
                {
                    system.debug('Value being PAssed' +so);
                    PassClient.passclienttemp(Trigger.newMap.get(so.Id));
                }
                if( (newsite.IP_PassClientAddressToTempest__c != oldsite.IP_PassClientAddressToTempest__c ) && newsite.IP_EmergencyPullClientAddress__c == False && newsite.IP_PassClientAddressToTempest__c == True && newsite.IP_TempestDepartment__c!= '0000')
                {
                    system.debug('Value being PAssed' +so);
                    PassClient.passclientaddresstemp(Trigger.newMap.get(so.Id));
                }
                if((newsite.IP_EmergencyPullClient__c != oldsite.IP_EmergencyPullClient__c )  && newsite.IP_EmergencyPullClient__c == True && newsite.IP_TempestDepartment__c!= '0000'){
                    PassClient.passEmergencyClient(Trigger.newMap.get(so.Id));
                    
                }
                if((newsite.IP_EmergencyPullClientAddress__c != oldsite.IP_EmergencyPullClientAddress__c )  && newsite.IP_EmergencyPullClientAddress__c == True && newsite.IP_TempestDepartment__c!= '0000'){
                    PassClient.passEmergencyclientadd(Trigger.newMap.get(so.Id));
                    
                }
            }
            
        }
    }
    
    if(Trigger.isAfter && (Trigger.isUpdate || Trigger.isInsert)) {
        Set<Id> siteAccIdSet = new Set<Id>();
        for(sirenum__Site__c eachSite : Trigger.new){
            System.debug('======================= Trigger eachSite'+eachSite);
            if(eachSite.Estimated_Temp_Requirements__c != null || eachSite.Estimated_Perm_Vacancies__c != null)
                siteAccIdSet.add(eachSite.sirenum__Operating_Company__c);
        }
        System.debug('======================= Trigger .siteAccIdSet :'+siteAccIdSet);
        if(!siteAccIdSet.isEmpty())
            SiteTriggerHelper.populateVacancies(siteAccIdSet);
    }
    
}