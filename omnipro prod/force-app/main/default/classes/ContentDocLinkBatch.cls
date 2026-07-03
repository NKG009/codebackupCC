global class ContentDocLinkBatch implements Database.Batchable<SObject>, Database.Stateful {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        List<Knowledge__kav> ka = [SELECT Id, Question__c FROM Knowledge__kav];
		system.debug('Knowledge__kav size ' + ka.size());
        
        List<Id> kaIds = new List<Id>();
        for (Knowledge__kav art : ka) {
            kaIds.add(art.Id);
        }
        system.debug('kaIds >>' + kaIds);
        
        system.debug('query result ' + [SELECT Id, Visibility
                                        FROM ContentDocumentLink
                                        WHERE LinkedEntityId IN :kaIds
                                        AND Visibility = 'InternalUsers']);
        
        list<ContentDocumentLink> cdl = [SELECT Id, Visibility
                                        FROM ContentDocumentLink
                                        WHERE LinkedEntityId IN :kaIds
                                        AND Visibility = 'InternalUsers'];
        
        system.debug('ContentDocumentLink List>>' +cdl);
        
        return Database.getQueryLocator([
                            SELECT Id, Visibility
                            FROM ContentDocumentLink
                            WHERE LinkedEntityId IN :kaIds
                            AND Visibility = 'InternalUsers'
        ]);
    }

    global void execute(Database.BatchableContext bc, List<ContentDocumentLink> scope) {
        List<ContentDocumentLink> cdList = new List<ContentDocumentLink>();
        
        for(ContentDocumentLink cd : scope){
            cd.Visibility = 'AllUsers';
            cdList.add(cd);
        }
        update cdList;
        
    }
    
    global void finish(Database.BatchableContext bc) {
        System.debug('Batch job finished processing Knowledge Articles.');
    }
    
 
    
    
    
}