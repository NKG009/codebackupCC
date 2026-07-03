global class ConsentDateSynchBatch extends batchjobsch.BatchJobBase implements Database.Batchable<sObject>,Database.Stateful{
    
    
    List<Contact> con = new List<Contact>();
    global ConsentDateSynchBatch (List<Contact> listCon)
    {
        con = listCon;
         System.debug('CONlIst'+con);

    }

   global List<Contact> start(Database.BatchableContext BC)
    {
    System.debug('CONlIst'+con);
       // return DataBase.getQueryLocator([Select id,IP_Phone__c,IP_Consent_entered_by__c,IP_Consent_from_Data_Store__c,IP_SMS__c,IP_Email__c,IP_Post__c,IP_Criminal_Conviction__c,IP_Health_Reasonable_Adjustments__c,IP_Medical_History__c,IP_Equal_Ops__c from Contact where id IN: con]);
        return con;
    }
    global void execute(Database.BatchableContext BC,List<Contact> scope)
    {
     
       Database.SaveResult[] conList = Database.update(scope, false);
      //update scope;
      System.debug('Updated scopw'+scope);
    }
    
    global void finish(Database.BatchableContext BC)
    {
        super.finishBatch(BC);
    }

}