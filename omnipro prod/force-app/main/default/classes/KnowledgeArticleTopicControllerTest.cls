@IsTest
public class KnowledgeArticleTopicControllerTest {

    @TestSetup 
    static void testRecords() {
      
        Topic t = new Topic();
        t.Description = 'Test topic description';
        t.Name = 'OmniPro Test Topic';
        
        insert t;
        
         Topic t1 = new Topic();
        t1.Description = 'Test topic descriptionv test';
        t1.Name = 'Accountants Resource Centre';
        
        insert t1;

        User u = new User();
        u.FirstName = 'Test';
        u.LastName = 'User';
        u.Email = 'testuser@example.com';
        u.Username = 'testuser' + System.currentTimeMillis() + '@example.com';
        u.Alias = 'tuser';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id;
        u.LanguageLocaleKey = 'en_US';
        insert u;
        
         User u1 = new User();
        u1.FirstName = 'Testing';
        u1.LastName = 'User1';
        u1.Email = 'testuser1@example.com';
        u1.Username = 'testuser1' + System.currentTimeMillis() + '@example.com';
        u1.Alias = 'tuser1';
        u1.TimeZoneSidKey = 'America/Los_Angeles';
        u1.LocaleSidKey = 'en_US';
        u1.EmailEncodingKey = 'UTF-8';
        u1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;
        u1.LanguageLocaleKey = 'en_US';
        insert u1;


        Omnipro_AccessToken__c oa = new Omnipro_AccessToken__c();
        oa.OAuth_URL__c = 'https://example.com/oauth/token?';
        oa.grant_type__c = 'password';
        oa.client_id__c = 'client_id';
        oa.client_secret__c = 'client_secret';
        oa.username__c = 'username';
        oa.password__c = 'password';
        insert oa;

        Knowledge__kav ta = new Knowledge__kav();
        ta.Title = 'Test Article';
        ta.UrlName = 'test-article';
        ta.Question__c = 'Test Question?';
        ta.Answer__c = 'Test Answer.';
        insert ta;

        Knowledge__kav ka = new Knowledge__kav();
        ka.Title = 'Test Article without QnA';
        ka.UrlName = 'test-article-without-qna';
        ka.Question__c = '';
        ka.Answer__c = '';
        insert ka;

        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document Version 1';
        cv.PathOnClient = 'path/to/file.pdf';
        cv.VersionData = Blob.valueOf('This is the file content');
        insert cv;
        
         
    }

    
    @isTest
    static void testFetchTopicByName() {
        Topic existingTopic = [SELECT Id, Name FROM Topic WHERE Name = 'OmniPro Test Topic' LIMIT 1];
        String topicId = KnowledgeArticleTopicController.fetchTopic('OmniPro Test Topic', null);
    }

    @isTest
    static void testFetchTopicById() {
        Topic existingTopic = [SELECT Id, Name FROM Topic WHERE Name = 'OmniPro Test Topic' LIMIT 1];
        String topicName = KnowledgeArticleTopicController.fetchTopic(null, existingTopic.Id);
    }

    @isTest
    static void testGetFeaturedTopicsAndPermissionSets() {
        User u = [SELECT Id FROM User WHERE FirstName = 'Test' LIMIT 1];
        Test.startTest();
        List<Map<String, Object>> topics = KnowledgeArticleTopicController.getFeaturedTopicsAndPermissionSets(u.Id);
        Test.stopTest();
    }
     @isTest
    static void testGetFeaturedTopicsAndPermissionSets1() {
        User u = [SELECT Id FROM User WHERE FirstName = 'Testing' LIMIT 1];
        Test.startTest();
        List<Map<String, Object>> topics = KnowledgeArticleTopicController.getFeaturedTopicsAndPermissionSets(u.Id);
        Test.stopTest();
    }

    @isTest
    static void testGetAccessToken() {
        HttpMock mock = new HttpMock();
        mock.setEndpoint('https://example.com/oauth/token');
        mock.setMethod('POST');
        mock.setResponse('{"access_token": "mock_access_token"}', 'application/json', 200);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        KnowledgeArticleTopicController.getAccessToken();
        Test.stopTest();
    }

    @isTest
    static void testGetManagedTopics() {
      
        User u1 = [SELECT Id,Profile.Name FROM User WHERE FirstName = 'Testing' LIMIT 1];
        
            list<PermissionSetAssignment> pslist = new list<PermissionSetAssignment>();
            
            for( PermissionSet ps : [SELECT Id,Label,Name,IsOwnedByProfile FROM PermissionSet WHERE LicenseId =null AND (Label='ARC Non Audit' OR Label='ARC Premium' OR Label='CompaniesAct2014.com')]){
                                     
                 PermissionSetAssignment psa2 = new PermissionSetAssignment();
                        psa2.AssigneeId = u1.Id;
                        psa2.PermissionSetId = ps.Id;
                  pslist.add(psa2);
                }
            system.debug('pslist..' + pslist);
            insert pslist;
            
        Topic testTopic = [SELECT Id FROM Topic WHERE Name = 'Accountants Resource Centre' LIMIT 1];
       
        HttpMock mock = new HttpMock();
        mock.setEndpoint('https://omniproireland2--omniprodev.sandbox.my.salesforce.com/services/data/v61.0/support/dataCategoryGroups/OmniPro_Test_Topic/dataCategories/All?sObjectName=KnowledgeArticleVersion');
        mock.setMethod('GET');
        mock.setResponse('{"childCategories": [{"label": "Anti-Money Laundering Resources", "name": "Anti_Money_Laundering_Resources", "url": "/category1"},{"label": "Engagement Letters", "name": "Engagement_Letters", "url": "/category1"}]}', 'application/json', 200);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        List<Map<String, Object>> managedTopics = KnowledgeArticleTopicController.getManagedTopics(testTopic.Id,u1.id);
        Test.stopTest();
    }
   
     @isTest
    static void testGetManagedTopics1() {
      
        User u = [SELECT Id,Profile.Name FROM User WHERE FirstName = 'Test' LIMIT 1];
        
            list<PermissionSetAssignment> pslist = new list<PermissionSetAssignment>();
            
            for( PermissionSet ps : [SELECT Id,Label,Name,IsOwnedByProfile FROM PermissionSet WHERE LicenseId =null AND ( Label='ARC Premium' OR Label='CompaniesAct2014.com')]){
                                     
                 PermissionSetAssignment psa2 = new PermissionSetAssignment();
                        psa2.AssigneeId = u.Id;
                        psa2.PermissionSetId = ps.Id;
                  pslist.add(psa2);
                }
            system.debug('pslist..' + pslist);
            insert pslist;
            
        Topic testTopic = [SELECT Id FROM Topic WHERE Name = 'Accountants Resource Centre' LIMIT 1];
       
        HttpMock mock = new HttpMock();
        mock.setEndpoint('https://omniproireland2--omniprodev.sandbox.my.salesforce.com/services/data/v61.0/support/dataCategoryGroups/OmniPro_Test_Topic/dataCategories/All?sObjectName=KnowledgeArticleVersion');
        mock.setMethod('GET');
        mock.setResponse('{"childCategories": [{"label": "Audit Entity Resources", "name": "Audit_Entity_Resources", "url": "/category1"}]}', 'application/json', 200);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        List<Map<String, Object>> managedTopics = KnowledgeArticleTopicController.getManagedTopics(testTopic.Id,u.id);
        Test.stopTest();
    }
    
     @isTest
    static void testGetManagedTopics2() {
      
         User u = [SELECT Id,Profile.Name FROM User WHERE FirstName = 'Test' LIMIT 1];
        
            list<PermissionSetAssignment> pslist = new list<PermissionSetAssignment>();
            
            for( PermissionSet ps : [SELECT Id,Label,Name,IsOwnedByProfile FROM PermissionSet WHERE LicenseId =null AND ( Label='ARC Non Audit' OR Label='CompaniesAct2014.com')]){
                                     
                 PermissionSetAssignment psa2 = new PermissionSetAssignment();
                        psa2.AssigneeId = u.Id;
                        psa2.PermissionSetId = ps.Id;
                  pslist.add(psa2);
                }
            system.debug('pslist..' + pslist);
            insert pslist;
            
        Topic testTopic = [SELECT Id FROM Topic WHERE Name = 'Accountants Resource Centre' LIMIT 1];
       
        HttpMock mock = new HttpMock();
        mock.setEndpoint('https://omniproireland2--omniprodev.sandbox.my.salesforce.com/services/data/v61.0/support/dataCategoryGroups/OmniPro_Test_Topic/dataCategories/All?sObjectName=KnowledgeArticleVersion');
        mock.setMethod('GET');
        mock.setResponse('{"childCategories": [{"label": "Non-Audit Entity Resources", "name": "Non_Audit_Entity_Resources", "url": "/category1"}]}', 'application/json', 200);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        List<Map<String, Object>> managedTopics = KnowledgeArticleTopicController.getManagedTopics(testTopic.Id,u.id);
        Test.stopTest();
    }

     @isTest
    static void testGetManagedTopics3() {
      
        User u1 = [SELECT Id FROM User WHERE FirstName = 'Testing' LIMIT 1];
        
            list<PermissionSetAssignment> pslist = new list<PermissionSetAssignment>();
            
            for( PermissionSet ps : [SELECT Id,Label,Name,IsOwnedByProfile FROM PermissionSet WHERE LicenseId =null AND (Label='CompaniesAct2014.com')]){
                                     
                 PermissionSetAssignment psa2 = new PermissionSetAssignment();
                        psa2.AssigneeId = u1.Id;
                        psa2.PermissionSetId = ps.Id;
                  pslist.add(psa2);
                }
            system.debug('pslist..' + pslist);
            insert pslist;
            
        Topic testTopic = [SELECT Id FROM Topic WHERE Name = 'OmniPro Test Topic' LIMIT 1];
       
        HttpMock mock = new HttpMock();
        mock.setEndpoint('https://omniproireland2--omniprodev.sandbox.my.salesforce.com/services/data/v61.0/support/dataCategoryGroups/OmniPro_Test_Topic/dataCategories/All?sObjectName=KnowledgeArticleVersion');
        mock.setMethod('GET');
        mock.setResponse('{"childCategories": [{"label": "Audit Entity Resources", "name": "Audit_Entity_Resources", "url": "/category1"}]}', 'application/json', 200);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        List<Map<String, Object>> managedTopics = KnowledgeArticleTopicController.getManagedTopics(testTopic.Id,u1.id);
        Test.stopTest();
    }
    
      @isTest
    static void testGetManagedTopics4() {
      
        User u = [SELECT Id,Profile.Name FROM User WHERE FirstName = 'Test' LIMIT 1];
        
            list<PermissionSetAssignment> pslist = new list<PermissionSetAssignment>();
            
            for( PermissionSet ps : [SELECT Id,Label,Name,IsOwnedByProfile FROM PermissionSet WHERE LicenseId =null AND ( Label='ARC Premium Plus' )]){
                                     
                 PermissionSetAssignment psa2 = new PermissionSetAssignment();
                        psa2.AssigneeId = u.Id;
                        psa2.PermissionSetId = ps.Id;
                  pslist.add(psa2);
                }
            system.debug('pslist..' + pslist);
            insert pslist;
            
        Topic testTopic = [SELECT Id FROM Topic WHERE Name = 'Accountants Resource Centre' LIMIT 1];
       
        HttpMock mock = new HttpMock();
        mock.setEndpoint('https://omniproireland2--omniprodev.sandbox.my.salesforce.com/services/data/v61.0/support/dataCategoryGroups/OmniPro_Test_Topic/dataCategories/All?sObjectName=KnowledgeArticleVersion');
        mock.setMethod('GET');
        mock.setResponse('{"childCategories": [{"label": "Audit", "name": "Audit", "url": "/category1"},{"label": "Non-Audit", "name": "Non_Audit", "url": "/category1"}]}', 'application/json', 200);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        List<Map<String, Object>> managedTopics = KnowledgeArticleTopicController.getManagedTopics(testTopic.Id,u.id);
        Test.stopTest();
    }

   
    @isTest
    static void testGetArticleDetails() {
        Knowledge__kav article = [SELECT Id FROM Knowledge__kav LIMIT 1];
        Test.startTest();
        KnowledgeArticleTopicController.ArticleDetailsWrapper details = KnowledgeArticleTopicController.getArticleDetails(article.Id);
        Test.stopTest();
    }

    @isTest
    static void testGetArticleDetailsWithoutQNA() {
        Knowledge__kav article = [SELECT Id FROM Knowledge__kav WHERE Title = 'Test Article without QnA'];
        Test.startTest();
        KnowledgeArticleTopicController.ArticleDetailsWrapper details = KnowledgeArticleTopicController.getArticleDetails(article.Id);
        Test.stopTest();
    }

    @isTest
    static void testGetContentDistribution() {
        ContentVersion cv = [SELECT Id, ContentDocumentId FROM ContentVersion LIMIT 1];
        Test.startTest();
        List<ContentDistribution> distributions = KnowledgeArticleTopicController.getContentDistribution(cv.ContentDocumentId);
        Test.stopTest();
    }

    @isTest
    static void testFetchSubtopics() {
        
        User u = [SELECT Id FROM User WHERE FirstName = 'Test' LIMIT 1];
        
            list<PermissionSetAssignment> pslist = new list<PermissionSetAssignment>();
            
            for( PermissionSet ps : [SELECT Id,Label,Name,IsOwnedByProfile FROM PermissionSet WHERE LicenseId =null AND (Label='ARC Non Audit' OR Label='ARC Premium' OR Label='CompaniesAct2014.com')]){
                                     
                 PermissionSetAssignment psa2 = new PermissionSetAssignment();
                        psa2.AssigneeId = u.Id;
                        psa2.PermissionSetId = ps.Id;
                  pslist.add(psa2);
                }
            system.debug('pslist..' + pslist);
            insert pslist;
        
        Topic testTopic = [SELECT Id FROM Topic WHERE Name = 'Accountants Resource Centre' LIMIT 1];
         
        HttpMock mock = new HttpMock();
        mock.setEndpoint('https://omniproireland2--omniprodev.sandbox.my.salesforce.com/api/subtopics');
        mock.setMethod('GET');
        mock.setResponse('{"childCategories": [{"label": "Non-Audit", "name": "Non_Audit", "url": "/category1"}]}', 'application/json', 200);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        String url = 'services/data/v61.0/support/dataCategoryGroups/OmniPro_Test_Topic/dataCategories/All?sObjectName=KnowledgeArticleVersion';
        List<Map<String, Object>> result = KnowledgeArticleTopicController.fetchSubtopics(url,'OmniPro_Test_Topic',u.Id, testTopic.Id);
        Test.stopTest();
    }
    
    
    @isTest
    static void testFetchSubtopics1() {
        
        User u = [SELECT Id FROM User WHERE FirstName = 'Test' LIMIT 1];
        
            list<PermissionSetAssignment> pslist = new list<PermissionSetAssignment>();
            
            for( PermissionSet ps : [SELECT Id,Label,Name,IsOwnedByProfile FROM PermissionSet WHERE LicenseId =null AND (Label='ARC Non Audit' OR Label='ARC Premium' OR Label='CompaniesAct2014.com')]){
                                     
                 PermissionSetAssignment psa2 = new PermissionSetAssignment();
                        psa2.AssigneeId = u.Id;
                        psa2.PermissionSetId = ps.Id;
                  pslist.add(psa2);
                }
            system.debug('pslist..' + pslist);
            insert pslist;
        
        Topic testTopic = [SELECT Id FROM Topic WHERE Name = 'Accountants Resource Centre' LIMIT 1];
         
        HttpMock mock = new HttpMock();
        mock.setEndpoint('https://omniproireland2--omniprodev.sandbox.my.salesforce.com/api/subtopics');
        mock.setMethod('GET');
        mock.setResponse('{"childCategories": [{"label": "Services", "name": "Services", "url": "/category1"}]}', 'application/json', 200);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        String url = 'services/data/v61.0/support/dataCategoryGroups/OmniPro_Test_Topic/dataCategories/All?sObjectName=KnowledgeArticleVersion';
        List<Map<String, Object>> result = KnowledgeArticleTopicController.fetchSubtopics(url,'OmniPro_Test_Topic',u.Id, testTopic.Id);
        Test.stopTest();
    }
    
    @isTest
    static void testFetchSubtopics2() {
        
        User u1 = [SELECT Id,Profile.Name FROM User WHERE FirstName = 'Testing' LIMIT 1];
        
            list<PermissionSetAssignment> pslist = new list<PermissionSetAssignment>();
            
            for( PermissionSet ps : [SELECT Id,Label,Name,IsOwnedByProfile FROM PermissionSet WHERE LicenseId =null AND (Label='ARC Non Audit' OR Label='ARC Premium' OR Label='CompaniesAct2014.com')]){
                                     
                 PermissionSetAssignment psa2 = new PermissionSetAssignment();
                        psa2.AssigneeId = u1.Id;
                        psa2.PermissionSetId = ps.Id;
                  pslist.add(psa2);
                }
            system.debug('pslist..' + pslist);
            insert pslist;
        
        Topic testTopic = [SELECT Id FROM Topic WHERE Name = 'Accountants Resource Centre' LIMIT 1];
         
        HttpMock mock = new HttpMock();
        mock.setEndpoint('https://omniproireland2--omniprodev.sandbox.my.salesforce.com/api/subtopics');
        mock.setMethod('GET');
        mock.setResponse('{"childCategories": [{"label": "Services", "name": "Services", "url": "/category1"}]}', 'application/json', 200);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        String url = 'services/data/v61.0/support/dataCategoryGroups/OmniPro_Test_Topic/dataCategories/All?sObjectName=KnowledgeArticleVersion';
        List<Map<String, Object>> result = KnowledgeArticleTopicController.fetchSubtopics(url,'OmniPro_Test_Topic',u1.Id, testTopic.Id);
        Test.stopTest();
    }
/*
    @isTest
    static void testGetSubTopics() {
        HttpMock mock = new HttpMock();
        mock.setEndpoint('https://omniproireland2--omniprodev.sandbox.my.salesforce.com/api/subtopics');
        mock.setMethod('GET');
        mock.setResponse('{"childCategories": [{"id": "subtopic1", "label": "Subtopic A", "name": "Subtopic-A", "url": "/subtopic-a"}]}', 'application/json', 200);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        List<Map<String, Object>> result = KnowledgeArticleTopicController.getSubTopics('/api/subtopics', 'ParentCategory');
        Test.stopTest();
    }
*/
    @isTest
    static void testGetKnowledgeArticles() {
        Test.startTest();
        List<Map<String, Object>> result = KnowledgeArticleTopicController.getKnowledgeArticles('CompaniesAct2014_com_Premium_Toolkit__c', 'OmniPro_Quick_Guides__c');
        Test.stopTest();
    }

    public class HttpMock implements HttpCalloutMock {
        private String endpoint;
        private String method;
        private String response;
        private String responseType;
        private Integer statusCode;

        public void setEndpoint(String endpoint) {
            this.endpoint = endpoint;
        }

        public void setMethod(String method) {
            this.method = method;
        }

        public void setResponse(String response, String responseType, Integer statusCode) {
            this.response = response;
            this.responseType = responseType;
            this.statusCode = statusCode;
        }

        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', responseType);
            res.setBody(response);
            res.setStatusCode(statusCode);
            return res;
        }
    }
}