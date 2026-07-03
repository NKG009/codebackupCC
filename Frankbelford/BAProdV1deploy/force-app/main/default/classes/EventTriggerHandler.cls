/*
* Class Name: EventTriggerHandler
* Description: JPC- 1645
* Date : 18th July 2019
*/
public class EventTriggerHandler{

    public static void handleBeforeInsert(List<Event> lstInsertEvent){

        Map<Id,Id> mapEventIdBusinessId = new Map<Id,Id>();
        Map<Id,id> mapEventIdSetID = new Map<Id,id>();       
        
        String objectName = 'jsinq__Inquiry__c';
        String keyPrefix = getKeyPrefixObject(objectName);
        
        for(Event evt : lstInsertEvent){
            if(evt.WhatId!=null && string.valueof(evt.WhatId).startswith(keyPrefix)){
                mapEventIdBusinessId.put(evt.id,evt.WhatId);
            }
        }
        
        if(!mapEventIdBusinessId.isEmpty()){
            List<jsinq__Inquiry__c> leadlist = [Select id,jsinq__Converted__c,Site__c from jsinq__Inquiry__c where jsinq__Converted__c = TRUE 
                                                    and id in:mapEventIdBusinessId.values()];
            if(!leadlist.isEmpty() && leadlist!=null){
                for(jsinq__Inquiry__c lead:leadlist){
                    mapEventIdSetID.put(lead.id,lead.Site__c);
                }
                
                for(Event tk:lstInsertEvent){
                    if(mapEventIdSetID.containsKey(tk.WhatID)){
                        tk.Whatid = mapEventIdSetID.get(tk.WhatID);             
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