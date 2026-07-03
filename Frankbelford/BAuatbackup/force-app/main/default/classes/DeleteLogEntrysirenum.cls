global class DeleteLogEntrysirenum implements Database.Batchable<sObject>{

//date dt = system.today().addDays(-21);
 global Database.QueryLocator start(Database.BatchableContext BC){
   
  string query = 'SELECT Id FROM sirenum__LogEntry__c WHERE sirenum__Shift__c = NULL AND sirenum__Contact__c = NULL AND CreatedDate < LAST_N_DAYS:90';
  return Database.getQueryLocator(query);
 }

global void execute(Database.BatchableContext BC,List<sirenum__LogEntry__c > loglist){

    if(loglist.size()>0)
    {
        database.delete(loglist,false);
    }    
}
global void finish(Database.BatchableContext BC){
 
}
}