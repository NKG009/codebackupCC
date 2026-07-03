public with sharing class CaseTriggerHandler {

    public static void beforeInsert(){
        
        List<Case> casList = new List<Case>();
        Map<Id, Id> agentMap = new Map<Id, Id>();

        for(Case cas : (List<Case>) Trigger.new){
            if(cas.ContactId != null){
                casList.add(cas);
                agentMap.put(cas.ContactId, cas.AccountId);
            }
        }

        System.debug('casList' + casList);
        if(!casList.isEmpty()){
            CaseTriggerHelper.validateContacts(casList, agentMap);
        }

    }

    public static void beforeUpdate(){
  
        List<Case> casList = new List<Case>();
        Map<Id, Id> agentMap = new Map<Id, Id>();

        for(Case cas : (List<Case>) Trigger.new){
            Case oldCas = (Case) Trigger.oldMap.get(cas.Id);
            if(cas.ContactId != null
            && cas.AccountId != null
            && (cas.ContactId != oldCas.ContactId || cas.AccountId != oldCas.AccountId)){
                casList.add(cas);
                agentMap.put(cas.ContactId, cas.AccountId);
            }
        }
        System.debug('casList' + casList);

        if(!casList.isEmpty()){
            CaseTriggerHelper.validateContacts(casList, agentMap);
        }

    }    

}