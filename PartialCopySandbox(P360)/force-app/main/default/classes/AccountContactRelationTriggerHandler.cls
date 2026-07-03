public class AccountContactRelationTriggerHandler {
    
    public static void afterInsert(List<AccountContactRelation> newList) {
        updatePropertyAgentOnAccount(getAccountIdsToUpdate(newList, null));
    }

    public static void afterUpdate(List<AccountContactRelation> newList, Map<Id, AccountContactRelation> oldMap) {
        updatePropertyAgentOnAccount(getAccountIdsToUpdate(newList, oldMap));
    }

    public static void afterDelete(List<AccountContactRelation> oldList) {
        updatePropertyAgentOnAccount(getAccountIdsToUpdate(oldList, null));
    }

    public static void updatePropertyAgentOnAccount(Set<Id> accountIdSet) {
        if(accountIdSet != null && !accountIdSet.isEmpty()) {
            Set<Id> contactIdSet = new Set<Id>();
            List<Account> accList = [Select Id, Current_PM_Email__c, PM_First_Name__c, PM_Last_Name__c, Property_Manager_Name__c, 
                                     PM_ID__c, Property_Office_Agent__c, 
                                     (Select Id, Contact.Email, Contact.FirstName, Contact.LastName, Contact.Name, ContactId 
                                      FROM AccountContactRelations WHERE 
                                      Roles includes ('Property Manager', 'Investment Manager') AND IsDirect = false LIMIT 1) 
                                     FROM Account WHERE Id IN: accountIdSet];
            for(Account accRec : accList) {
                if(!accRec.AccountContactRelations.isEmpty()) {
                    contactIdSet.add(accRec.AccountContactRelations[0].ContactId);
                }
            }
            Map<Id, Id> contactIdToUserIdMap = new Map<Id, Id>();
            if(!contactIdSet.isEmpty()) {
                for(User userRec : [Select Id, ContactId FROM User WHERE ContactId IN: contactIdSet]) {
                    contactIdToUserIdMap.put(userRec.ContactId, userRec.Id);
                }
            }
            Map<Id, Account> accIdToRecMapToUpdate = new Map<Id, Account>(); 
            for(Account accRec : accList) {
                String previousPropertyAgent = accRec.Property_Office_Agent__c;
                Account accToUpdate = new Account(Id = accRec.Id);
                if(accRec.AccountContactRelations.isEmpty()) {
                    accToUpdate.Current_PM_Email__c = null;
                    accToUpdate.PM_First_Name__c = null;
                    accToUpdate.PM_Last_Name__c = null;
                    accToUpdate.Property_Manager_Name__c = null;
                    accToUpdate.PM_ID__c = null;
                    accToUpdate.Property_Office_Agent__c = null;
                } else {
                    Contact contactRec = accRec.AccountContactRelations[0].Contact;
                    accToUpdate.Current_PM_Email__c = contactRec.Email;
                    accToUpdate.PM_First_Name__c = contactRec.FirstName;
                    accToUpdate.PM_Last_Name__c = contactRec.LastName;
                    accToUpdate.Property_Manager_Name__c = contactRec.Name;
                    accToUpdate.PM_Id__c = contactRec.Id;
                    if(contactIdToUserIdMap.containsKey(contactRec.Id)) {
                        accToUpdate.Property_Office_Agent__c = contactIdToUserIdMap.get(contactRec.Id);
                    }
                }
                if(hasPMDetailsChanged(accRec, accToUpdate)) {
                    accIdToRecMapToUpdate.put(accToUpdate.Id, accToUpdate);
                }
            }
            if(!accIdToRecMapToUpdate.isEmpty()) {
                update accIdToRecMapToUpdate.values();
            }
        }
    }

    private static Set<Id> getAccountIdsToUpdate(List<AccountContactRelation> acrList, Map<Id, AccountContactRelation> oldMap) {
        Set<Id> accountIdSet = new Set<Id>();
        if(acrList != null) {
            for(AccountContactRelation acrRec : acrList) {
                accountIdSet.add(acrRec.AccountId);
            }
        }
        if(oldMap != null) {
            for(AccountContactRelation acrRec : oldMap.values()) {
                accountIdSet.add(acrRec.AccountId);
            }
        }
        accountIdSet.remove(null);
        return accountIdSet;
    }
    
    private static Boolean hasPMDetailsChanged(Account oldAcc, Account newAcc) {
        Boolean hasChanged = false;
        if(oldAcc != null && newAcc != null && 
           (oldAcc.Current_PM_Email__c != newAcc.Current_PM_Email__c || oldAcc.PM_First_Name__c != newAcc.PM_First_Name__c || 
            oldAcc.PM_Last_Name__c != newAcc.PM_Last_Name__c || oldAcc.Property_Manager_Name__c != newAcc.Property_Manager_Name__c || 
            oldAcc.PM_ID__c != newAcc.PM_ID__c || oldAcc.Property_Office_Agent__c != newAcc.Property_Office_Agent__c)) {
                hasChanged = true;
            }
        return hasChanged;
    }
}