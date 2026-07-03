global class UpdaterecontacteddateCanddate extends batchjobsch.BatchJobBase implements Database.Batchable<sObject>{

date dt = system.today();
 global Database.QueryLocator start(Database.BatchableContext BC){
 
   string query = 'select id, IP_DateAvailableforRecontact__c,IP_AvailableforRecontact__c from Contact where IP_DateAvailableforRecontact__c !=null and IP_DateAvailableforRecontact__c=:dt';
     return Database.getQueryLocator(query);
 }
 
 global void execute(Database.BatchableContext BC,List<Contact> scope){
 
 for(Contact c: scope)
 {     
         c.IP_AvailableforRecontact__c = true;    
 }
Database.update(scope,false);

}
 global void finish(Database.BatchableContext BC){
 super.finishBatch(BC);
}
}