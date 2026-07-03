global class KnowledgeArticleBatch implements Database.Batchable<SObject>, Database.Stateful {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, KnowledgeArticleId, Title, UrlName, IsVisibleInCsp 
            FROM Knowledge__kav 
            WHERE PublishStatus = 'Online' AND (IsVisibleInCsp = false OR IsVisibleInCsp = null)
        ]);
    }

    global void execute(Database.BatchableContext bc, List<Knowledge__kav> scope) {
        for (Knowledge__kav article : scope) {
            try {
                String draftKnowledgeArticleId = unPublishArticle(article.KnowledgeArticleId);
                Knowledge__kav draftArticle = [
                    SELECT Id, KnowledgeArticleId, Title, UrlName, IsVisibleInCsp 
                    FROM Knowledge__kav 
                    WHERE KnowledgeArticleId = :draftKnowledgeArticleId
                    LIMIT 1
                ];
                draftArticle.IsVisibleInCsp = true;
                update draftArticle;
                publishArticle(draftKnowledgeArticleId);
            } catch (Exception e) {
                System.debug('Error processing article: ' + article.Title + ' - ' + e.getMessage());
            }
        }
    }

    global void finish(Database.BatchableContext bc) {
        System.debug('Batch job finished processing Knowledge Articles.');
    }

    public static void publishArticle(String recordId) {
        KbManagement.PublishingService.publishArticle(recordId, true);
    }

    public static String unPublishArticle(String recordId) {
        String newArticleId = KbManagement.PublishingService.editOnlineArticle(recordId, true);
        return [SELECT KnowledgeArticleId FROM Knowledge__kav WHERE Id = :newArticleId].KnowledgeArticleId;
    }
}