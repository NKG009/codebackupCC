global class DeletionAction extends batchjobsch.BatchJobBase implements Schedulable,Database.AllowsCallouts,Database.Batchable<sObject>{
 
    global DeletionAction()
    {
              Payroll_Swtich__c Payroll = Payroll_Swtich__c.getValues('Stoppayroll'); 
              Payroll.Batch_check__c=true;
              update Payroll;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
     String Query = 'Select id ,IP_GDPRDeleConsentPortalStatus__c,IP_MarkedForDeletion__c from contact where IP_MarkedForDeletion__c = true and IP_GDPRDeleConsentPortalStatus__c = False';
       
       System.debug('Query--->> '+ Query);
       return Database.getQueryLocator(Query);
   }
     global void execute(Database.BatchableContext BC , List<Contact> scope) 
     {
         //system.debug('Contacts fetched' +scope);
       
         String callresult;
         String accesstoken;
         String tokenfromsetting;
         System.debug('@@ '+scope);
        LoginToken__c lgtoken = LoginToken__c.getValues('Token1');
         
        if(lgtoken.Token__c==null)
         {
           accesstoken = LoginCallToGDPRDataStore.logincall();
           callresult = LoginCallToGDPRDataStore.postcall(accesstoken, scope[0].id);
             lgtoken.Token__c = accesstoken;
           update lgtoken;
         }
         else
         {
             tokenfromsetting = lgtoken.Token__c;
           //  System.debug('@@ '+tokenfromsetting);
            callresult = LoginCallToGDPRDataStore.postcallwithsetting(tokenfromsetting, scope[0].id);
             if(callresult.contains('401'))
             {
              accesstoken = LoginCallToGDPRDataStore.logincall();
             callresult = LoginCallToGDPRDataStore.postcall(accesstoken, scope[0].id);   
             lgtoken.Token__c = accesstoken;
             update lgtoken;
             }
         }
          
         
            System.debug('@@callresult '+callresult);
      
    if(!callresult.contains('400') || !callresult.contains('406') || !callresult.contains('500') )
      {
            System.debug('@@in DELETE');
      try
          {
              system.debug('Batch is in try');
          //Delete scope;
            scope[0].IP_GDPRDeleConsentPortalStatus__c = True; 
             update scope;
          }
          Catch(Exception e)
          {       // scope[0].Error_Reason__c = String.valueOf(e);              update scope;
          }
      }
     /* else
      {
         scope[0].Error_Reason__c = callresult;              update scope;  
        }*/
     }
     global void finish(Database.BatchableContext BC)
    {
          Payroll_Swtich__c Payroll = Payroll_Swtich__c.getValues('Stoppayroll'); 
        Payroll.Batch_check__c=false;
        update Payroll;
        super.finishBatch(BC);
    }
     global void execute(SchedulableContext sc)
    {
        Database.executeBatch(new DeletionAction(),1); 
     }
}