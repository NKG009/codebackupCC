global class BatchUpdateAgentAcountContactRelation implements Database.AllowsCallouts, Database.Batchable<SObject>, Database.Stateful  {
    global Database.QueryLocator start(Database.BatchableContext context){
        return Database.getQueryLocator('Select Name from AccountContactId__c limit 5');
    }
global void execute(Database.BatchableContext BC,List<AccountContactId__c> scope) {
        for(AccountContactId__c acc : scope){
            CreateUpdateAccountContactRole.fetchAgentdata(acc.Name);
            delete acc;
        }
    }
    global void finish(Database.BatchableContext BC) {
        AgentAcountContactRelationSchedulable.reschedulebatch();
    }
}