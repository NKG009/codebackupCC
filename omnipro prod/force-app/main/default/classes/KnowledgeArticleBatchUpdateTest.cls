@isTest
public class KnowledgeArticleBatchUpdateTest {

    @testSetup
    static void setup() {
        List<Knowledge__kav> articles = new List<Knowledge__kav>();
        for (Integer i = 1; i <= 10; i++) {
            Knowledge__kav ka = new Knowledge__kav(
                Title = 'Test Article ' + i,
                UrlName = 'test-article-' + i,
                IsVisibleInCsp = false,
                 ValidationStatus = 'Not Validated',
                Language = 'en_US'
            );
            articles.add(ka);
        }
        insert articles;
        
        
        List<Knowledge__kav> articles1 = [
            SELECT Id, KnowledgeArticleId, Title, UrlName, IsVisibleInCsp
            FROM Knowledge__kav
            WHERE IsVisibleInCsp = false
        ];
        
        
        for (Knowledge__kav article : articles1) {
            try {
                publishArticle(article.KnowledgeArticleId);
                System.debug('Published article: ' + article.Title);
            } catch (Exception e) {
                System.debug('Error publishing article: ' + article.Title + ' - ' + e.getMessage());
            }
        }

    }
     private static void publishArticle(String recordId) {
        KbManagement.PublishingService.publishArticle(recordId, true);
    }
    
     @isTest
    static void testBatchExecution() {
        
      
       
        Test.startTest();
        KnowledgeArticleBatchUpdate batch = new KnowledgeArticleBatchUpdate();
        Database.executeBatch(batch, 10);
        Test.stopTest();

    }
}