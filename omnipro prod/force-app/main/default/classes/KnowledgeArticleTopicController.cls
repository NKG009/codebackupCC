public class KnowledgeArticleTopicController {
    
    public static String topicLabel;
    
    List<Map<String, String>> result = new List<Map<String, String>>();

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getFeaturedTopicsAndPermissionSets(String userId) {
        List<Map<String, Object>> result = new List<Map<String, Object>>();
        
        String userProfileName = [SELECT Profile.Name FROM User WHERE Id = :userId].Profile.Name;
        
        if (userProfileName == 'System Administrator') {
            
            List<Topic> topicList = [SELECT Id, Name, Description, NetworkId FROM Topic 
                                     WHERE ManagedTopicType LIKE '%Featured%' ORDER BY Name ASC];
            system.debug('topicList >>' + topicList);
            
            for (Topic topic : topicList) {
                Map<String, Object> topicMap = new Map<String, Object>();
                topicMap.put('Id', topic.Id);
                topicMap.put('Name', topic.Name);
                
                result.add(topicMap);
            }
            
            system.debug('Result for System Admin :'+ result);
            /*
if (result.isEmpty()) {
throw new AuraHandledException('No topics available. Please contact the System Administrator.');
}
*/
            return result;
            
        } else {
            
            
            List<Topic> topicList = [SELECT Id, Name, Description, NetworkId FROM Topic WHERE ManagedTopicType LIKE '%Featured%' ORDER BY Name ASC];
            
            System.debug('topicList>>' + topicList);
            
            Map<String, Topic> topicMap = new Map<String, Topic>();
            for (Topic topic : topicList) {
                topicMap.put(topic.Name, topic);
            }
            
            System.debug('topicMap>>' + topicMap);
            
            
            User user = [SELECT Id, (SELECT PermissionSetId FROM PermissionSetAssignments WHERE PermissionSet.IsOwnedByProfile = false) 
                         FROM User WHERE Id = :userId LIMIT 1];
            System.debug('user Details>>' + user);
            
            
            Set<Id> permissionSetIds = new Set<Id>();
            for (PermissionSetAssignment psa : user.PermissionSetAssignments) {
                permissionSetIds.add(psa.PermissionSetId);
            }
            
            
            List<PermissionSetAssignment> psaList = [SELECT PermissionSetId, PermissionSet.Name 
                                                 	FROM PermissionSetAssignment 
                                                 	WHERE PermissionSetId IN :permissionSetIds AND AssigneeId = :userId ];
            System.debug('psaList>>' + psaList);
            
            
            Set<String> permissionSetNames = new Set<String>();
            for (PermissionSetAssignment psa : psaList) {
                permissionSetNames.add(psa.PermissionSet.Name); 
            }
            System.debug('Permission Set Names>>' + permissionSetNames);
            
             if (permissionSetNames.contains('ARC_Non_Audit') || 
                permissionSetNames.contains('ARC_Premium') ||
                permissionSetNames.contains('ARC_Premium_Plus')) {
                    
                    if (topicMap.containsKey('Accountants Resource Centre')) {
                        Topic topic = topicMap.get('Accountants Resource Centre');
                        
                        result.add(new Map<String, Object>{ 'Id' => topic.Id, 'Name' => topic.Name });
                    }
                }
            
            
            if (permissionSetNames.contains('CompaniesAct2014_com')) {
                
                if (topicMap.containsKey('CompaniesAct2014.com Premium Toolkit')) {
                    Topic topic = topicMap.get('CompaniesAct2014.com Premium Toolkit');
                    
                    result.add(new Map<String, Object>{ 'Id' => topic.Id, 'Name' => topic.Name });
                }
            }
            
            if (permissionSetNames.contains('FRS102_com')) {
                
                if (topicMap.containsKey('FRS102.com Premium Toolkit')) {
                    Topic topic = topicMap.get('FRS102.com Premium Toolkit');
                    
                    result.add(new Map<String, Object>{ 'Id' => topic.Id, 'Name' => topic.Name });
                }
            }
            
            if (permissionSetNames.contains('KnowledgeHUB')) {
                
                if (topicMap.containsKey('KnowledgeHUB')) {
                    Topic topic = topicMap.get('KnowledgeHUB');
                    
                    result.add(new Map<String, Object>{ 'Id' => topic.Id, 'Name' => topic.Name });
                }
            }
            
           
            /*
if (result.isEmpty()) {
throw new AuraHandledException('No topics available. Please contact the System Administrator regarding permission set assignment.');
}
*/
            System.debug('Result>>' + result);
            return result;
        }
    }
    
    
    
    
    
    //Get Acccess Token
    @AuraEnabled(cacheable=false)
    public static void getAccessToken() {
        try {
            Omnipro_AccessToken__c OAT = [SELECT ID, grant_type__c, client_id__c, client_secret__c, username__c, password__c, OAuth_URL__c, Access_Token__c
                                          FROM Omnipro_AccessToken__c
                                          LIMIT 1]; 
            
            String baseURL = OAT.OAuth_URL__c;
            String grantType = OAT.grant_type__c;
            String clientId = OAT.client_id__c;
            String clientSecret = OAT.client_secret__c;
            String username = OAT.username__c;
            String password = OAT.password__c;
            
            String url = baseURL + 
                'grant_type=' + grantType + 
                '&client_id=' + clientId + 
                '&client_secret=' + clientSecret + 
                '&username=' + username + 
                '&password=' + password;
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            HttpResponse res = http.send(req);
            
            system.debug('Access token Responce Is :' + res.getBody());
            
            if (res.getStatusCode() == 200) {
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                String accessToken = (String) responseMap.get('access_token');
                
                
                OAT.Access_Token__c = accessToken;
                update OAT;
                
                System.debug('Access Token Updated Successfully: ' + accessToken);
            } else {
                System.debug('Error in response: ' + res.getStatus() + ' ' + res.getStatusCode());
            }
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static String fetchTopic(String topicName, String topicRecordId) {
        if (topicName != null) {
            
            Topic topicRecord = [SELECT Id FROM Topic WHERE Name = :topicName LIMIT 1];
            return (topicRecord != null) ? topicRecord.Id : null;
        } else if (topicRecordId != null ) {
            
            Topic topicRecord = [SELECT Name FROM Topic WHERE Id = :topicRecordId LIMIT 1];
            return (topicRecord != null) ? topicRecord.Name : null;
        } else {
            return null;  
        }
    }
    
    
    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getManagedTopics(Id featuredtopicid, String userId) {
        
        User user = [SELECT Id,Profile.Name, (SELECT PermissionSetId FROM PermissionSetAssignments WHERE PermissionSet.IsOwnedByProfile = false) 
                     FROM User WHERE Id = :userId LIMIT 1];
        System.debug('User Details>> ' + user);
        
        Set<Id> permissionSetIds = new Set<Id>();
        for (PermissionSetAssignment psa : user.PermissionSetAssignments) {
            permissionSetIds.add(psa.PermissionSetId);
        }
        
        List<PermissionSetAssignment> psaList = [SELECT PermissionSetId, PermissionSet.Name 
                                                 FROM PermissionSetAssignment 
                                                 WHERE PermissionSetId IN :permissionSetIds AND AssigneeId = :userId];
        System.debug('psaList>> ' + psaList);
        
        Set<String> permissionSetNames = new Set<String>();
        for (PermissionSetAssignment psa : psaList) {
            permissionSetNames.add(psa.PermissionSet.Name);
        }
        System.debug('Permission Set Names>> ' + permissionSetNames);
        
        List<String> labelForARCNonAudit = new List<String>{
            'Anti-Money Laundering Resources', 
                'Engagement Letters', 
                'Financial Statements', 
                'Non-Audit Entity Resources'
                };
                    
                    List<String> labelForARCPremium = new List<String>{
                        'Anti-Money Laundering Resources', 
                            'Engagement Letters', 
                            'Financial Statements', 
                            'Non-Audit Entity Resources',
                            'Audit Entity Resources',
                            'ISQM1 and IES8 Resources'
                            };
                                
                                List<Map<String, Object>> result = new List<Map<String, Object>>();
        
        try {
            Topic t1 = [SELECT Id, Name, ManagedTopicType, Description, NetworkId 
                        FROM Topic 
                        WHERE Id = :featuredtopicid 
                        LIMIT 1];
            
            Omnipro_AccessToken__c OAt = [SELECT ID, Access_Token__c FROM Omnipro_AccessToken__c LIMIT 1];
            String AccessToken = OAt.Access_Token__c;
            system.debug('Access Token Is :'+ AccessToken);
            
            String topicName = t1.Name.replaceAll('[ .]', '_');
            system.debug('The Topic Name is : ' + topicName);
            
            String domainUrl = Label.omniProDomainUrl;
			System.debug('Base URL: ' + domainUrl);
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint( domainUrl +'/services/data/v61.0/support/dataCategoryGroups/' 
                            + topicName + '/dataCategories/All?sObjectName=KnowledgeArticleVersion');
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Accept-Language', 'en-US');
            req.setHeader('Authorization', 'Bearer ' + AccessToken);
            
            Http http = new Http();
            HttpResponse res = http.send(req);
            system.debug('res.getBody()>>' + res.getBody());
            
            if (res.getStatusCode() == 200) {
                subcategoriesResponseWrapper responseMap = (subcategoriesResponseWrapper)System.JSON.deserialize(res.getBody(), subcategoriesResponseWrapper.class);
                system.debug('responseMap from wrapper :>' + responseMap);
                
                if(responseMap.childCategories.size() > 0) {
                    if(t1.Name == 'Accountants Resource Centre' && user.Profile.Name != 'System Administrator'){
                        
                        system.debug('out of for loop');
                        for (subcategoriesResponseWrapper.childCategories category : responseMap.childCategories) {
                            system.debug('inside for loop');
                            if (permissionSetNames.contains('ARC_Non_Audit')) {
                                system.debug('category.label for ARC_Non_Audit >>' + category.label);
                                if (labelForARCNonAudit.contains(category.label)) {
                                    Map<String, Object> entry = new Map<String, Object>();
                                    entry.put('label', category.label);
                                    entry.put('name', category.name);
                                    entry.put('url', category.url);
                                    result.add(entry);
                                }
                            }else if(permissionSetNames.contains('ARC_Premium')){
                                system.debug('category.label ARC_Premium>>' + category.label);
                                if (labelForARCPremium.contains(category.label)) {
                                    Map<String, Object> entry = new Map<String, Object>();
                                    entry.put('label', category.label);
                                    entry.put('name', category.name);
                                    entry.put('url', category.url);
                                    result.add(entry);
                                }
                            }else if(permissionSetNames.contains('ARC_Premium_Plus')){
                                system.debug('category.label ARC_Premium_Plus>>' + category.label);
                                
                                Map<String, Object> entry = new Map<String, Object>();
                                entry.put('label', category.label);
                                entry.put('name', category.name);
                                entry.put('url', category.url);
                                result.add(entry);
                                
                            }
                        }
                        
                    }else{
                        for (subcategoriesResponseWrapper.childCategories category : responseMap.childCategories) {
                            system.debug('Other data categories');
                            Map<String, Object> entry = new Map<String, Object>();
                            entry.put('label', category.label);
                            entry.put('name', category.name);
                            entry.put('url', category.url);
                            result.add(entry);
                        }
                    }
                    
                    
                }
                
                
            }
            system.debug('Result is : ' + result);
            return result;
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
            return new List<Map<String, Object>>(); 
        }
    }
    
    
    
    
    //Fetch subtopics at second level
    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> fetchSubtopics(String SubTopicUrl, String parentName, String userId, String ParentTopicId) {
        String url = SubTopicUrl;
        String currentTopicName = parentName;
        system.debug('currentTopicName  ' + currentTopicName);
        
        system.debug('ParentTopicId  ' + ParentTopicId);
        
        Topic t1 = [SELECT Id, Name, ManagedTopicType, Description, NetworkId 
                    FROM Topic 
                    WHERE Id = :ParentTopicId 
                    LIMIT 1];
        
        
        
        
        //get permission set names
        User user = [SELECT Id,Profile.Name, (SELECT PermissionSetId FROM PermissionSetAssignments WHERE PermissionSet.IsOwnedByProfile = false) 
                     FROM User WHERE Id = :userId LIMIT 1];
        System.debug('User Details>> ' + user);
        
        Set<Id> permissionSetIds = new Set<Id>();
        for (PermissionSetAssignment psa : user.PermissionSetAssignments) {
            permissionSetIds.add(psa.PermissionSetId);
        }
        
        List<PermissionSetAssignment> psaList = [SELECT PermissionSetId, PermissionSet.Name 
                                                 FROM PermissionSetAssignment 
                                                 WHERE PermissionSetId IN :permissionSetIds  AND AssigneeId = :userId ];
        System.debug('psaList>> ' + psaList);
        
        Set<String> permissionSetNames = new Set<String>();
        for (PermissionSetAssignment psa : psaList) {
            permissionSetNames.add(psa.PermissionSet.Name);
        }
        System.debug('Permission Set Names>> ' + permissionSetNames);
        
        
        
        
        List<String> labelForARCNonAudit = new List<String>{
            'AML Resources for Accountants',
                'Non-Audit',
                'Services'
                
                };
                    
                    List<String> labelForARCPremium = new List<String>{
                        'AGM & Letters to Claim Audit Exemption', 
                            'Audit Ltd Company FRS102', 
                            'Audit Opinion Guide and Examples', 
                            'Audit Resignations & Removals',
                            'FRS102 (1A) Audit',
                            'FRS105 Audit',
                            'Qualifying Limited Partnership Resources',
                            'Regulated Entity Audit Ltd Co FRS102',
                            'Stock Take Attendance Resources',
                            'Audit',
                            'Non-Audit',
                            'Services'
                            };
                                
                                List<Map<String, Object>> subResult = new List<Map<String, Object>>();
        
        String domainUrl = Label.omniProDomainUrl;
			System.debug('Base URL: ' + domainUrl);
        
        try {
            Omnipro_AccessToken__c OAt = [SELECT ID, Access_Token__c FROM Omnipro_AccessToken__c LIMIT 1];
            String accessToken = OAt.Access_Token__c;
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint(domainUrl + url);
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Accept-Language', 'en-US');
            req.setHeader('Authorization', 'Bearer ' + accessToken);
            
            Http http = new Http();
            HttpResponse res = http.send(req);
            
            if (res.getStatusCode() == 200) {
                subcategoriesResponseWrapper responseMapSubSTopics = (subcategoriesResponseWrapper)System.JSON.deserialize(res.getBody(), subcategoriesResponseWrapper.class);
                system.debug('responseMapSubSTopics from wrapper :>' + responseMapSubSTopics);
                
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                Object childCategoriesObj = responseMap.get('childCategories');
                
                if (childCategoriesObj instanceof List<Object>) {
                    List<Object> subCategoriesList = (List<Object>) childCategoriesObj;
                    
                    system.debug('subCategoriesList: ' + subCategoriesList);
                    
                    if (subCategoriesList.isEmpty()) {
                        return subResult;
                    }
                    
                    
                    
                    if(t1.Name == 'Accountants Resource Centre' && user.Profile.Name != 'System Administrator'){
                        
                        for (PermissionSetAssignment psa : psaList){
                            
                            
                            
                            system.debug('inside for loop' );
                            
                            if(psa.PermissionSet.Name == 'ARC_Non_Audit'  ) {
                                for (subcategoriesResponseWrapper.childCategories category : responseMapSubSTopics.childCategories){
                                    system.debug('parentName>>>' +currentTopicName);
                                    system.debug('inside ARC_Non_Audit' );
                                    if(currentTopicName == 'Non-Audit Entity Resources'){
                                        system.debug('category.label Non-Audit Entity Resources>>' + category.label);
                                        
                                        
                                        Map<String, Object> subEntry = new Map<String, Object>();
                                        
                                        subEntry.put('label', category.label);
                                        subEntry.put('name', category.name);
                                        subEntry.put('url', category.url);
                                        //adding immediate subtopics
                                        subEntry.put('children', new List<Map<String, Object>>());  
                                        
                                        subResult.add(subEntry);
                                        system.debug('parentName>>>' +currentTopicName);
                                    }else if (labelForARCNonAudit.contains(category.label) ){
                                        system.debug('category.label ARC_Non_Audit>>' + category.label);
                                        
                                        Map<String, Object> subEntry = new Map<String, Object>();
                                        
                                        subEntry.put('label', category.label);
                                        subEntry.put('name', category.name);
                                        subEntry.put('url', category.url);
                                        //adding immediate subtopics
                                        subEntry.put('children', new List<Map<String, Object>>());  
                                        
                                        subResult.add(subEntry);
                                        
                                    }
                                }
                                
                                
                                
                            } if(psa.PermissionSet.Name == 'ARC_Premium'){
                                system.debug('inside ARC_Premium' );
                                
                                for (subcategoriesResponseWrapper.childCategories category : responseMapSubSTopics.childCategories){
                                    
                                    if(currentTopicName == 'Non-Audit Entity Resources' || currentTopicName == 'Anti-Money Laundering Resources' || currentTopicName == 'ISQM1 and IES8 Resources' ){
                                        
                                        system.debug('category.label ARC_Premium>>' + category.label);
                                        
                                        Map<String, Object> subEntry = new Map<String, Object>();
                                        
                                        subEntry.put('label', category.label);
                                        subEntry.put('name', category.name);
                                        subEntry.put('url', category.url);
                                        //adding immediate subtopics
                                        subEntry.put('children', new List<Map<String, Object>>());  
                                        
                                        subResult.add(subEntry);
                                        
                                    }else if(labelForARCPremium.contains(category.label)){
                                        
                                        
                                        system.debug('category.label Non-Audit Entity Resources>>' + category.label);
                                        
                                        
                                        Map<String, Object> subEntry = new Map<String, Object>();
                                        
                                        subEntry.put('label', category.label);
                                        subEntry.put('name', category.name);
                                        subEntry.put('url', category.url);
                                        
                                        subEntry.put('children', new List<Map<String, Object>>());  
                                        
                                        subResult.add(subEntry);
                                        
                                    }
                                }

                                
                            }
                            if(psa.PermissionSet.Name == 'ARC_Premium_Plus'){
                                for (subcategoriesResponseWrapper.childCategories category : responseMapSubSTopics.childCategories){
                            system.debug('category.label All Categoriess' );
                            
                            
                            Map<String, Object> subEntry = new Map<String, Object>();
                            
                            subEntry.put('label', category.label);
                            subEntry.put('name', category.name);
                            subEntry.put('url', category.url);
                            //adding immediate subtopics
                            subEntry.put('children', new List<Map<String, Object>>());  
                            
                            subResult.add(subEntry);
                        }
                            }
                        }
                        
                        
                    }else {
                        for (subcategoriesResponseWrapper.childCategories category : responseMapSubSTopics.childCategories){
                            system.debug('category.label All Categoriess' );
                            
                            
                            Map<String, Object> subEntry = new Map<String, Object>();
                            
                            subEntry.put('label', category.label);
                            subEntry.put('name', category.name);
                            subEntry.put('url', category.url);
                            //adding immediate subtopics
                            subEntry.put('children', new List<Map<String, Object>>());  
                            
                            subResult.add(subEntry);
                        }
                        
                        
                    }
                    //end
                }
            }else {
                throw new AuraHandledException('Error fetching subtopics: ' + res.getStatus() + ' ' + res.getStatusCode());
            }
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        system.debug('subresult is :>' +subResult);
        return subResult;
    }

    
    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getKnowledgeArticles(String parentName, String subChildId) {
        
        System.debug('Parent Name is: ' + parentName);
        System.debug('SubChild ID is: ' + subChildId);
        
        String formattedParentName = parentName.replaceAll('[\\s-.]+', '_');
        String formattedChildName = subChildId.replaceAll('[\\s-.]+', '_');
        
        
        System.debug('Formatted Parent Name: ' + formattedParentName);
        System.debug('Formatted Child Name: ' + formattedChildName);
        
        Map<String, Object> acctBinds = new Map<String, Object>{
            'formattedParentName' => formattedParentName,
                'formattedChildName' => formattedChildName
                };
                    
                    
                    String query = 'SELECT Title, ArticleNumber, Id, UrlName ' +
                    'FROM Knowledge__kav ' +
                    'WHERE PublishStatus = \'online\' ' +
                    'WITH DATA CATEGORY ' + formattedParentName + ' Above ' + formattedChildName + ' ' +
                     'ORDER BY Title ASC'  ; 
        
        System.debug('Query: ' + query);
        
        List<Knowledge__kav> articles = Database.query(query);
        System.debug('articles: ' + articles);
        
        List<Map<String, Object>> articleList = new List<Map<String, Object>>();
        
        for (Knowledge__kav article : articles) {
            Map<String, Object> articleMap = new Map<String, Object>();
            articleMap.put('label', article.Title);
            articleMap.put('labelid', article.Id);
            articleMap.put('url', article.UrlName);
            articleList.add(articleMap);
        }
        
        System.debug('Article List is :' + articleList);
        return articleList;
    }
    
    
    
    @AuraEnabled(cacheable=true)
    public static ArticleDetailsWrapper getArticleDetails(Id articleId) {
        
        Knowledge__kav article = [SELECT Id, Title,UrlName, Question__c, Answer__c 
                                  FROM Knowledge__kav 
                                  WHERE Id = :articleId LIMIT 1];
        
        
        List<ContentDocument> attachedDocuments = new List<ContentDocument>();
        
        
        if (article.Question__c == null || article.Answer__c == null) {
            
            List<ContentDocumentLink> contentDocumentLinks = [SELECT ContentDocumentId 
                                                              FROM ContentDocumentLink 
                                                              WHERE LinkedEntityId = :articleId];
            
            
            Set<Id> contentDocumentIds = new Set<Id>();
            for (ContentDocumentLink link : contentDocumentLinks) {
                contentDocumentIds.add(link.ContentDocumentId);
            }
            
            system.debug('contentDocumentIds are ' + contentDocumentIds);
            
            
            attachedDocuments = [SELECT Id, Title 
                                 FROM ContentDocument 
                                 WHERE Id IN :contentDocumentIds];
        }
        
        
        return new ArticleDetailsWrapper(article, attachedDocuments);
    }
    
    
    public class ArticleDetailsWrapper {
        @AuraEnabled public Knowledge__kav article;
        @AuraEnabled public List<ContentDocument> attachedDocuments;
        
        public ArticleDetailsWrapper(Knowledge__kav article, List<ContentDocument> attachedDocuments) {
            this.article = article;
            this.attachedDocuments = attachedDocuments;
        }
    }
    
    // @AuraEnabled(cacheable=true)
    // public static List<ContentVersion> getVersionFiles(String documentId){
    //     system.debug('documentId is ' + documentId);
    //     try {
    //         return [SELECT
    // 	        Id,
    //             Title,
    //             ContentDocumentId,
    //             FileType, 
    //             ContentSize,
    //             FileExtension,
    //             VersionNumber,
    //             CreatedDate,
    //             VersionData,
    //                     FirstPublishLocationId
    //             FROM ContentVersion
    //          WHERE ContentDocumentId =:documentId
    //                 ORDER BY CreatedDate DESC
    // 	];
    
    //     } catch (Exception e) {
    //         throw new AuraHandledException(e.getMessage());
    //     }
    // }
    
    
    
    //this method gives the document articles link to preview articles
    @AuraEnabled(cacheable=true)
    public static List<ContentDistribution>  getContentDistribution(String documentId){
        
        system.debug('Content Document Id Is :' + documentId);
        
        List<ContentDistribution> contentDistributionList = [SELECT Id,ContentDownloadUrl,ContentDocumentId,DistributionPublicUrl 
                                                             FROM ContentDistribution 
                                                             WHERE ContentDocumentId =: documentId];
        
        system.debug('Content Distribution List is :' + contentDistributionList);
        
        return [SELECT Id,ContentDownloadUrl,ContentDocumentId,DistributionPublicUrl 
                FROM ContentDistribution 
                WHERE ContentDocumentId =: documentId];
        
    }
    
    
    
}