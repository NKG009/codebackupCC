public with sharing class UserTriggerHandler {

    public static void afterInsert(){
        Set<Id> usrIdSet = new Set<Id>();        
        for(User usr : (List<User>) Trigger.new){  
            if(usr.ContactId != null
            && 'PowerCustomerSuccess'.equalsIgnoreCase(usr.UserType)){
                usrIdSet.add(usr.Id);
            }
        }
        if(!usrIdSet.isEmpty()){
            UserTriggerHelper.assignAccounts(usrIdSet);
        }
    }

}