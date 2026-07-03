trigger AddTime on LWCCaseTimer__Session_Time__c (after insert) {
	List <Task> ActList = new List <Task>();
    for (LWCCaseTimer__Session_Time__c LWC : Trigger.new) {
        Task t =  new Task ();
        t.Time__c = LWC.LWCCaseTimer__Duration__c / 3600;
        t.Chargeability__c='Billable';
        t.OwnerId = UserInfo.getUserId();
        Case caseList= [SELECT Id,AccountId FROM Case WHERE Id=: LWC.LWCCaseTimer__Case__c LIMIT 1];
        t.WhatId = caseList.AccountId;
        t.Subject = 'Billable Time';
        t.Status = 'Completed';
        t.ActivityDate = System.today();
   		ActList.add(t);
    }
insert ActList;
        
        
}