public without sharing class UserTriggerHelper {
    
    public static void assignAccounts(Id aUsrId) {
        assignAccounts(new Set<Id>{aUsrId});
    }   

    @future
    public static void assignAccounts(Set<Id> aUsrIdSet) {

        Map<Id, Id> userMap = new Map<Id, Id>();
        for(User usr : getUsersById(aUsrIdSet)){
            if(usr.ContactId != null){
                userMap.put(usr.ContactId, usr.Id);
            }
        }

        if(!userMap.isEmpty()){ 
            
            List<Account> accToUpdateList = new List<Account>();
            List<AccountShare> ashToInsertList = new List<AccountShare>();
            List<Bread_Winner__Invoice__share> ishToInsertList = new List<Bread_Winner__Invoice__share>();
            List<WorkOrderShare> wshToInsertList = new List<WorkOrderShare>();

            List<AccountContactRelation> acrList = getAccountContactRelationshipsByContactId(userMap.keyset(), 
                                                                                             new Set<String>{'Property Manager', 
                                                                                                             'Investment Manager'});
            Set<Id> accIdSet = new Set<Id>();
            for(AccountContactRelation acr : acrList){   
                if(acr.AccountId != null){
                    accIdSet.add(acr.AccountId);
                }
            }

            Map<Id, List<Id>> invoiceMap = new Map<Id, List<Id>>();
            Map<Id, List<Id>> workOrderMap = new Map<Id, List<Id>>();

            System.debug('accIdSet: ' + accIdSet);

            if(!accIdSet.isEmpty()){
                for(Order ord : [SELECT AccountId, (SELECT Id FROM Invoices__r) FROM Order WHERE AccountId =: accIdSet]){
                    System.debug('ordId: ' + ord.Id);
                    System.debug('ord: ' + ord);
                    if(invoiceMap.get(ord.AccountId) == null){
                        invoiceMap.put(ord.AccountId, new List<Id>());
                    }
                    for(Bread_Winner__Invoice__c inv : ord.Invoices__r){
                        invoiceMap.get(ord.AccountId).add(inv.Id);
                    }
                }
                for(WorkOrder wor : [SELECT Id, AccountId FROM WorkOrder WHERE AccountId =: accIdSet]){
                    if(workOrderMap.get(wor.AccountId) == null){
                        workOrderMap.put(wor.AccountId, new List<Id>());
                    }
                    workOrderMap.get(wor.AccountId).add(wor.Id);
                }                
            }

            for(Id accId : invoiceMap.keySet()){
                System.debug('accId: ' + accId);
                List<Id> idList = invoiceMap.get(accId);
                System.debug('idList: ' + idList);
                if(idList != null){
                    for(Id invId : idList){
                        System.debug('invId: ' + invId);
                    }
                }   
            }



            for(AccountContactRelation acr : acrList){   

                Id usrId = userMap.get(acr.ContactId);                                                                                           

                AccountShare ashToInsert = new AccountShare();
                ashToInsert.AccountId = acr.AccountId;
                ashToInsert.CaseAccessLevel = 'Edit';
                ashToInsert.AccountAccessLevel = 'Edit';
                ashToInsert.OpportunityAccessLevel = 'Edit';
                ashToInsert.RowCause = 'Manual';
                ashToInsert.UserOrGroupId = usrId;
                ashToInsertList.add(ashToInsert);

                Account accToUpdate = new Account();
                accToUpdate.Id = acr.AccountId;
                accToUpdate.Property_Office_Agent__c = usrId;
                accToUpdate.PM_ID__c = acr.ContactId;
                accToUpdateList.add(accToUpdate);

                List<Id> invIdList = invoiceMap.get(acr.AccountId);
                if(invIdList != null){
                    for(Id invId : invIdList){
                        Bread_Winner__Invoice__share ishToInsert = new Bread_Winner__Invoice__share();
                        ishToInsert.ParentId = invId;
                        ishToInsert.AccessLevel = 'Edit';
                        ishToInsert.RowCause = 'Manual';
                        ishToInsert.UserOrGroupId = usrId;
                        ishToInsertList.add(ishToInsert);                        
                    }
                }

                List<Id> worIdList = workOrderMap.get(acr.AccountId);
                if(worIdList != null){
                    for(Id worId : worIdList){
                        WorkOrderShare wshToInsert = new WorkOrderShare();
                        wshToInsert.ParentId = worId;
                        wshToInsert.AccessLevel = 'Edit';
                        wshToInsert.RowCause = 'Manual';
                        wshToInsert.UserOrGroupId = usrId;
                        wshToInsertList.add(wshToInsert);                        
                    }
                }

            }

            if(!ashToInsertList.isEmpty()){
                Database.insert(ashToInsertList, true);
            }

            if(!ishToInsertList.isEmpty()){
                Database.insert(ishToInsertList, true);
            }

            if(!wshToInsertList.isEmpty()){
                Database.insert(wshToInsertList, true);
            }

            if(!accToUpdateList.isEmpty()){
                Database.update(accToUpdateList, true);
            }            

        }

    }

    public static List<USer> getUsersById(Set<Id> aUsrIdSet){
        return [
            SELECT 
                Id,
                ContactId,
                Contact.Name,
                Contact.AccountId
            FROM User
            WHERE Id =: aUsrIdSet
              AND UserType = 'PowerCustomerSuccess'
        ];
    }

    public static List<AccountContactRelation> getAccountContactRelationshipsByContactId(Set<Id> aConIdSet, Set<String> aRoleSet){
        Set<Id> conIdSet = aConIdSet;    
        Set<String> roleSet = aRoleSet;
        String soqlQuery = 'SELECT Id, AccountId, Account.Name, ContactId, Contact.Account.Name, IsActive';
        soqlQuery += ' FROM AccountContactRelation ';
        soqlQuery += ' WHERE ContactId =: conIdSet';
        soqlQuery += '   AND IsActive = true';
        if(!aRoleSet.isEmpty()){
            String includeRoles = '';
            for(String role : aRoleSet){
                if(String.isBlank(includeRoles)){
                    includeRoles = '\'' + role + '\'';
                }
                else{
                    includeRoles += ',' + '\'' + role + '\'';
                }               
            }
            soqlQuery += ' AND Roles includes (' + includeRoles + ')';
        }  
        return Database.query(soqlQuery);
    }
 
}