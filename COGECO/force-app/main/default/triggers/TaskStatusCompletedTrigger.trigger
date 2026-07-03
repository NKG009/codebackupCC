trigger TaskStatusCompletedTrigger on Task (after update) {

    Set<id> oppids=new Set<Id>();
    Set<id> accids=new Set<Id>();
    Set<id> tkids=new Set<Id>();
    Set<Id> taskToProcess=new Set<id>();
    Set<Id> OPPOwner=new Set<id>();   
    
    Map<Id,Id> leadToOwnerId=new Map<Id,Id>();

    for(Task tk:Trigger.new){
    
         Task oldTask = Trigger.oldMap.get(tk.Id);
    
         System.debug('The trigger is fired for Task: ' + tk.Id);
            if(string.valueof(tk.status) == 'Completed' && oldTask.Status != 'Completed' && tk.WhatId != null){
                   Schema.SObjectType sObjType = tk.WhatId.getSObjectType();
                   System.debug ('Related WhatId: ' + tk.WhatId);
                   System.debug ('Related Object: ' + sObjType.getDescribe().getName());
                   if(sObjType == Opportunity.SObjectType){
                   oppids.add(tk.Whatid);
                   tkids.add(tk.id);
               }
            else if (sObjType == Account.SObjectType){
                   accids.add(tk.WhatId);
                   tkids.add(tk.id);
               }
            }    
    }
        
    for(Opportunity ld:[Select id, owner.email, name, StageName, Account_Name_Desc__c, owner.firstname, owner.lastname, owner.LanguageLocaleKey, Installation_Date__c from Opportunity where id in: oppids and ownerid in (select ID from user) ]){
        //leadToOwnerId.put(ld.Id,ld.Owner.name) ;
        //OPPowner.add(string.valueof(ld.owner.name));
         

    for(Task ts:[Select id, Subject, Status, Description, ActivityDate from Task where id IN: tkids ]){
            TaskCompletionSendEmail.sendOpportunityEmail(ld, ts);    
    
     }
    
    System.debug('leadToOwnerId**'+leadToOwnerId);

    for(Task tsk:Trigger.new){
       if(leadToOwnerId.containsKey(tsk.WhatID)){
                taskToProcess.add(tsk.Whatid);
             }
        }
}


  for (Account acc : [SELECT Id, Name, Owner.Email, Owner.FirstName, Owner.LastName, owner.LanguageLocaleKey, Owner.Profile.Name FROM Account WHERE Id IN :accids AND ( Owner.Profile.Name = 'Wholesale' OR Owner.Id IN ('005Dp000003v66hIAA', '005Dp000003v691', '005Dp000003v7Po', '005Dp000003v7Py') ) ]){

       for(Task ts:[Select id, Subject, Status, Description, ActivityDate from Task where id IN: tkids ]){
            TaskCompletionSendEmail.sendAccountEmail(acc, ts);    

          }
      }

}