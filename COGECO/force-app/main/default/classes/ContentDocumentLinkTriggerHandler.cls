public without sharing class ContentDocumentLinkTriggerHandler {
    static Set<String> objectTypesForAllUsers = new Set<String>{ 'Customer_Approval__c' };
        
    public static void processContentDocumentLinkSharing(List<ContentDocumentLink> contentDocumentLinkRecords) {
        if (Auth.CommunitiesUtil.isGuestUser()) {
            return;
        }
        
        if (contentDocumentLinkRecords == null || contentDocumentLinkRecords.isEmpty()) {
            return;
        }
        
        for (ContentDocumentLink documentLink : contentDocumentLinkRecords) {
            if (ApexConstants.CONTENT_DISTRIBUTION_AVAILABLE_TYPES_FOR_AUTO_CONTENT_DISTRIBUTIONS.contains(documentLink.LinkedEntityId.getSObjectType().getDescribe().getName())) {
                documentLink.Visibility = ApexConstants.CONTENT_DOCUMENT_LINK_VISIBILITY_ALL_USERS;
            }
        }
    }
    
    public static void processContentDistributions(List<ContentDocumentLink> contentDocumentLinkRecords) {
        if (Auth.CommunitiesUtil.isGuestUser()) {
            return;
        }
        
        if (contentDocumentLinkRecords == null || contentDocumentLinkRecords.isEmpty()) {
            return;
        }
        
        List<ContentDistribution> distributions = new List<ContentDistribution>();
        Map<Id, ContentDocumentLink> documentLinkIds = new Map<Id, ContentDocumentLink>();
        
        for (ContentDocumentLink documentLink : contentDocumentLinkRecords) {
            if (ApexConstants.CONTENT_DISTRIBUTION_AVAILABLE_TYPES_FOR_AUTO_CONTENT_DISTRIBUTIONS.contains(documentLink.LinkedEntityId.getSObjectType().getDescribe().getName())) {
                documentLinkIds.put(documentLink.ContentDocumentId, documentLink);
            }
        }
        
        documentLinkIds.remove(null);
        
        if (!documentLinkIds.isEmpty()) {
            for (ContentVersion contentVersion : FileSelector.getContentVersionsByContentDocumentIds(documentLinkIds.keySet())) {
                distributions.add(new ContentDistribution(
                    ContentVersionId = contentVersion.Id,
                    Name = contentVersion.Title,
                    PreferencesNotifyOnVisit = false,
                    PreferencesAllowViewInBrowser = true,
                    PreferencesAllowOriginalDownload = true,
                    RelatedRecordId = documentLinkIds.get(contentVersion.ContentDocumentId).LinkedEntityId
                ));
            }
        }
        
        if (!distributions.isEmpty()) {
            Set<Id> distributionIds = new Set<Id>();
            List<Customer_Approval__c> customerApprovals = new List<Customer_Approval__c>();
            List<Database.SaveResult> saveResults = Database.insert(distributions);
            
            for (Database.SaveResult result : saveResults) {
                if (result.isSuccess()) {
                	distributionIds.add(result.getId());
                }
            }
            
            distributionIds.remove(null);
            
            for (ContentDistribution distribution : FileSelector.getContentDistributionByIds(distributionIds)) {
                CustomerSignatureDto signatureDto = new CustomerSignatureDto();
                signatureDto.downloadUrl = distribution.ContentDownloadUrl;
                signatureDto.fileName = distribution.ContentVersion.Title;
                signatureDto.fileType = distribution.ContentVersion.FileType;
                
                customerApprovals.add(new Customer_Approval__c(
                	Id = distribution.RelatedRecordId,
                    Customer_Contract_Details__c = JSON.serialize(signatureDto)
                ));
            }
            if (!customerApprovals.isEmpty()) {
                update customerApprovals;
            }
        }
    }
    
    public static void launchEmailCustomerFlow(List<ContentDocumentLink> contentDocumentLinkRecords) {
        if (Auth.CommunitiesUtil.isGuestUser()) {
            return;
        }
        
        if (contentDocumentLinkRecords == null || contentDocumentLinkRecords.isEmpty()) {
            return;
        }
        
        Set<Id> quoteIds = new Set<Id>();
        
        for (ContentDocumentLink documentLink : contentDocumentLinkRecords) {
            if (ApexConstants.QUOTE_OBJECT_API_NAME != documentLink.LinkedEntityId.getSObjectType().getDescribe().getName()) {
                continue;
            }
            
            quoteIds.add(documentLink.LinkedEntityId);
        }
        
        quoteIds.remove(null);
        
        if (quoteIds.isEmpty()) {
            return;
        }
        
        for (Quote quoteRecord : QuoteSelector.getQuotesToSendEmailToCustomer(quoteIds)) {            
            new AutolaunchFlow(
                new Map<String, Object>{ ApexConstants.FLOW_RECORD_ID_KEY => quoteRecord.Id },
                ApexConstants.FLOW_EMAIL_DOCUMENT_TO_CUSTOMER
            ).start();
        }
    }
}