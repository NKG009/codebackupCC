public with sharing class CaseTriggerHelper {

    public static void validateContacts(List<Case> aCasList, Map<Id, Id> aAgentMap) {

        Map<Id, Contact> conMap = new Map<Id, Contact>([SELECT Id, 
                                                               RecordType.DeveloperName,
                                                               Contact.AccountId
                                                        FROM Contact 
                                                        WHERE Id =: aAgentMap.keySet()]);

        Map<Id, Account> accMap = new Map<Id, Account>([SELECT Id,
                                                               ParentId,
                                                               Parent.ParentId,
                                                               Parent.Parent.ParentId,
                                                               Parent.Parent.Parent.ParentId,
                                                               Parent.Parent.Parent.Parent.ParentId,
                                                               Parent.Parent.Parent.Parent.Parent.ParentId
                                                        FROM Account
                                                        WHERE Id =: aAgentMap.values()]);
                                                    
        for(Case cas : aCasList){
            System.debug('cas: ' + cas);
            Contact con = conMap.get(cas.ContactId);
            Account acc = accMap.get(cas.AccountId);
            System.debug('con: ' + con);
            System.debug('acc: ' + acc);
            if(con != null
            && acc != null){
                System.debug('type: ' + con.RecordType.DeveloperName);
                if(con.RecordType != null
                && 'Agent'.equalsIgnoreCase(con.RecordType.DeveloperName)){
                    Set<Id> accIdSet = new Set<Id>{acc.Id};                    
                    if(acc.ParentId != null){
                        accIdSet.add(acc.ParentId);
                        if(acc.Parent.ParentId != null){
                            accIdSet.add(acc.Parent.ParentId);
                            if(acc.Parent.Parent.ParentId != null){
                                accIdSet.add(acc.Parent.Parent.ParentId);
                                if(acc.Parent.Parent.Parent.ParentId != null){
                                    accIdSet.add(acc.Parent.Parent.Parent.ParentId);
                                    if(acc.Parent.Parent.Parent.Parent.ParentId != null){
                                        accIdSet.add(acc.Parent.Parent.Parent.Parent.ParentId);
                                        if(acc.Parent.Parent.Parent.Parent.Parent.ParentId != null){
                                            accIdSet.add(acc.Parent.Parent.Parent.Parent.Parent.ParentId);
                                        }
                                    }
                                }                                
                            }
                        }
                    }            
                    if(accIdSet.contains(con.AccountId) == false){
                        cas.addError('The Contact(agent) does not belongs to the same real estate of the property that you are trying to add.');                        
                    }   
                }
            }
                                    
        }

    }

}