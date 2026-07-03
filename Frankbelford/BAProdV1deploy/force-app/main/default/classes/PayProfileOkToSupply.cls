public class PayProfileOkToSupply {

    public static void method1(IP_PayProfile__c payprofile)
    {
     if(checkRecursive.runOnce())
    {       
    Payroll_Swtich__c Payroll = Payroll_Swtich__c.getValues('Stoppayroll'); 
    if( !Payroll.Batch_check__c)
    { 
     
        set<Boolean> test= new set<Boolean>();
       
        test.add(payprofile.For_P45_batch__c);
           
        for(Boolean b : test)
        {
        if(b==false)
        {
               
        //Process Builder name : update field for Shift Creation
        set<id> setid1= new set<id>();
        set<id> setid2= new set<id>();
         set<id> setid3= new set<id>();
        Id devRecordTypeId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('LTD').getRecordTypeId();
        Id devRecordTypeId1 = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('PAYE').getRecordTypeId();
        Id devRecordTypeId2 = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('Umbrella').getRecordTypeId();
        
           if(payprofile.RecordTypeId == devRecordTypeId && payprofile.IP_Status__c == 'Active' && payprofile.IP_OkToSupply__c == 1 )
            { 
                setid1.add(payprofile.IP_Candidate__c);
            }
            else if ((payprofile.RecordTypeId == devRecordTypeId1|| payprofile.RecordTypeId == devRecordTypeId2) &&  payprofile.IP_Status__c== 'Active')
            {
                setid2.add(payprofile.IP_Candidate__c);
            }
            else
            {
               setid3.add(payprofile.IP_Candidate__c);
            }
      
        if(setid1.size()>0)
        {
            payProfileProcessBuilder.updateOkToSupply(setid1);
        }
         if(setid2.size()>0)
        {
            payProfileProcessBuilder.updateOkToSupply(setid2);
        }
       if(setid3.size()>0)
       {
 		payProfileProcessBuilder.updateOkToSupplyToNo(setid3);           
       }
                
     
        }
        }
     
    }
    }
    }
}