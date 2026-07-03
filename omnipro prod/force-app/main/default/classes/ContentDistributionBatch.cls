public class ContentDistributionBatch implements Database.Batchable<SObject>, Database.Stateful {
    
    public Set<Id> contentDocumentIds;
    
     public ContentDistributionBatch(Set<Id> contentDocumentIds) {
        this.contentDocumentIds = contentDocumentIds;
    }

    
        public Database.QueryLocator start(Database.BatchableContext bc) {
       
        String query = 'SELECT ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN :contentDocumentIds AND Id NOT IN (SELECT ContentVersionId FROM ContentDistribution)';
        return Database.getQueryLocator(query);
    }
    
        public void execute(Database.BatchableContext bc, List<ContentVersion> docVersion) {
       
        Set<Id> batchContentDocumentIds = new Set<Id>();
        for (ContentVersion cv : docVersion) {
            batchContentDocumentIds.add(cv.ContentDocumentId);
        }
            
            system.debug('batchContentDocumentIds Size :' + batchContentDocumentIds.size());
        
        if (!batchContentDocumentIds.isEmpty()) {
            ContentVersionTriggerHandler.getDocumentPublicLink(batchContentDocumentIds);
        }
    }
    
    
     public void finish(Database.BatchableContext bc) {
        System.debug('Batch complete');
    }
    
}