global class UpdaterecontacteddatePlacement extends batchjobsch.BatchJobBase implements Database.Batchable<sObject>{

date dt = system.today();
 global Database.QueryLocator start(Database.BatchableContext BC){
 
   string query = 'select id, IP_DateAvailableforRecontact__c,IP_StatuschangedtoHired__c,ts2extams__Substatus__c from ts2__Placement__c where ts2extams__Substatus__c=\'Hired\'';
     return Database.getQueryLocator(query);
 }
 
 global void execute(Database.BatchableContext BC,List<ts2__Placement__c> scope){
 
 for(ts2__Placement__c c: scope)
 {
     if(c.IP_StatuschangedtoHired__c!=null && c.IP_StatuschangedtoHired__c.DaysBetween(dt) == 90)
     {
         c.IP_DateAvailableforRecontact__c = system.today();
     }
 }
Database.update(scope,false);

}
 global void finish(Database.BatchableContext BC){
 super.finishBatch(BC);
}
}