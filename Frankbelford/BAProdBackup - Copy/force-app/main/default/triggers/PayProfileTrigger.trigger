trigger PayProfileTrigger on IP_PayProfile__c (before insert,after insert,before update,after update, before delete, after delete) {
    Payroll_Swtich__c Payroll = Payroll_Swtich__c.getValues('Stoppayroll'); 
    if(!Payroll.Batch_check__c)
    {
        TriggerFactory.createHandler(IP_PayProfile__c.sObjectType);
    }
    
    if(trigger.isAfter && trigger.isinsert)
    {
        list<id> recids = new list<id>();
        list<contact> listtoupdte = new list<contact>();
        for(IP_PayProfile__c pay:trigger.new)
        {
            recids.add(pay.id);
        }
        list<IP_PayProfile__c> payrec = [select id,IP_PayrollID__c,IP_PrimaryPayMethod__c,IP_Candidate__c,IP_Candidate__r.Primary_Payroll_ID__c from IP_PayProfile__c where id in :recids];
        for(IP_PayProfile__c pay :payrec)
        {
            
            if(pay.IP_PayrollID__c != pay.IP_Candidate__r.Primary_Payroll_ID__c && pay.IP_PrimaryPayMethod__c )
            {
                
                listtoupdte.add(new contact(Primary_Payroll_ID__c=pay.IP_PayrollID__c, id=pay.IP_Candidate__c)); 
            }
        }
        if(listtoupdte.size() > 0)
        {
            update listtoupdte;
        }
        
    }
    if(trigger.isAfter && trigger.isupdate)
    {
        list<id> recids = new list<id>();
        list<contact> listtoupdte = new list<contact>();
        for(IP_PayProfile__c pay:trigger.new)
        {
            recids.add(pay.id);
        }
        list<IP_PayProfile__c> payrec = [select id,IP_PayrollID__c,IP_PrimaryPayMethod__c,IP_Candidate__c,IP_Candidate__r.Primary_Payroll_ID__c from IP_PayProfile__c where id in :recids];
        for(IP_PayProfile__c pay :payrec)
        {
            
            if(pay.IP_PayrollID__c != pay.IP_Candidate__r.Primary_Payroll_ID__c && pay.IP_PrimaryPayMethod__c )
            {  
                listtoupdte.add(new contact(Primary_Payroll_ID__c=pay.IP_PayrollID__c, id=pay.IP_Candidate__c)); 
            }
            else
            {
                if(Trigger.oldMap.get(pay.Id).IP_PrimaryPayMethod__c != pay.IP_PrimaryPayMethod__c && pay.IP_PrimaryPayMethod__c==false)
                {
                    listtoupdte.add(new contact(Primary_Payroll_ID__c='', id=pay.IP_Candidate__c));
                }
            }
        }
        if(listtoupdte.size() > 0)
        {
            update listtoupdte;
        }
        
    }
    
}