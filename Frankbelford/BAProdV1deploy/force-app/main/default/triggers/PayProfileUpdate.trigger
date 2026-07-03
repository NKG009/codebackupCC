trigger PayProfileUpdate on IP_PayProfile__c (after insert,after update,before update) {
    
    //process builder name : update contact by payprofile
     Set<id> Payprofileid  = new Set<id>();
     if(checkRecursive.runOnce())
    {
    Payroll_Swtich__c Payroll = Payroll_Swtich__c.getValues('Stoppayroll'); 
    if((trigger.isInsert || trigger.isUpdate ) && !Payroll.Batch_check__c)
    { 
        set<id> setid = new set<id>();
        set<Boolean> test= new set<Boolean>();
        Id devRecordTypeIdcheck = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('PAYE').getRecordTypeId();
        if(trigger.isUpdate && Trigger.isBefore)
        {
            for(integer i=0;i<trigger.new.size();i++){           
                for(IP_PayProfile__c pp : trigger.new)
                {
                    if( trigger.new[i].P45_Requested__c == true && (trigger.new[i].Reason_for_Leaving1__c !=trigger.old[i].Reason_for_Leaving1__c && trigger.new[i].Reason_for_Leaving1__c !='Automatic') && Trigger.new[i].RecordTypeId  ==devRecordTypeIdcheck )
                    {
                          //Payprofileid.add(pp.id); 
                          if(trigger.new[i].IP_Status__c == 'Active' && trigger.new[i].IP_LastPassedToTempest__c!=null)
                          {
                              trigger.new[i].IP_PassToTempest__c = true;
                          } 
                    }
                }
            }
           /*  if(!Payprofileid.isEmpty())
            {                        
                payProfileProcessBuilder.UpdatepayProfileprocess(Payprofileid);
            }*/
        }
        for(IP_PayProfile__c pp : trigger.new)
        {
        test.add(pp.For_P45_batch__c);
            if(pp.IP_PassToTempest__c==true)
            {
                setid.add(pp.IP_Candidate__c);
            }                        
        }
        for(Boolean b : test)
        {
        if(b==false)
        {
        if(setid.size()>0)
        {
           // payProfileProcessBuilder.updatesyncpayprofile(setid);            
        }
        
        
        //Process Builder name : update field for Shift Creation
        set<id> setid1= new set<id>();
        Id devRecordTypeId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('LTD').getRecordTypeId();
        Id devRecordTypeId1 = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('PAYE').getRecordTypeId();
        Id devRecordTypeId2 = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('Umbrella').getRecordTypeId();
        
        for(IP_PayProfile__c pp1:trigger.new)
        {           
            if(pp1.RecordTypeId == devRecordTypeId && pp1.IP_Status__c == 'Active' && pp1.IP_OkToSupply__c == 1 )
            { 
                setid1.add(pp1.IP_Candidate__c);
            }
        }
        if(setid1.size()>0)
        {
            payProfileProcessBuilder.updateOkToSupply(setid1);
        }
        
        for(IP_PayProfile__c pp2:trigger.new)
        {
            if ((pp2.RecordTypeId == devRecordTypeId1|| pp2.RecordTypeId == devRecordTypeId2) &&  pp2.IP_Status__c== 'Active')
            {
                setid1.add(pp2.IP_Candidate__c);
            }
        }
        if(setid1.size()>0)
        {
            payProfileProcessBuilder.updateOkToSupply(setid1);
        }
        
        else
        {
            payProfileProcessBuilder.updateOkToSupplyToNo(setid1);
        }
        }
        }
    } 
    }
    
}