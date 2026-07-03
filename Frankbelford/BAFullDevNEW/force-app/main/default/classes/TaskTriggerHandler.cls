/*
* Class Name: TaskTriggerHandler
* Description: JPC- 1645
* Date : 18th July 2019
*/
public class TaskTriggerHandler{

    public static void handleBeforeInsert(List<Task> lstInsertTask){
    
        Map<Id,Id> mapTaskIdBusinessId = new Map<Id,Id>();
        Map<Id,Id> mapLeadIdSetId = new Map<Id,Id>();
        String objectName = 'Inquiry__c';
        String keyPrefix = getKeyPrefixObject(objectName);
        
        for(task t:lstInsertTask){
            if(t.WhatId!=null && string.valueof(t.WhatId).startswith(keyPrefix)){
                mapTaskIdBusinessId.put(t.id,t.WhatId);
            }
       }
        
        if(!mapTaskIdBusinessId.isEmpty()){    
            List<Inquiry__c> leadlist = [Select id,Converted__c,Site__c from Inquiry__c where Converted__c = TRUE 
                                                and id in:mapTaskIdBusinessId.values()];
            if(!leadlist.isEmpty() && leadlist!=null){
                for(Inquiry__c lead:leadlist){
                    mapLeadIdSetId.put(lead.id,lead.Site__c);
                }
                
                for(task tk:lstInsertTask){
                    if(mapLeadIdSetId.containsKey(tk.WhatID)){
                        tk.Whatid = mapLeadIdSetId.get(tk.WhatID);
                    }
                }
            }
        }
    }
    
    private Static String getKeyPrefixObject(String objectName){
        Map<String, Schema.SObjectType> m  = Schema.getGlobalDescribe() ;
        Schema.SObjectType s = m.get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        String keyPrefix = r.getKeyPrefix();
        return keyPrefix;
    }
    
}