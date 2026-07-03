public class ContentVersionTriggerHandler {
    
    public static void getDocumentPublicLink(Set<Id> contentDocumentIds) {
        System.debug('Getting ContentDocument IDs to create public links: ' + contentDocumentIds);
        
        List<ContentVersion> contentVersions = [
            SELECT Id, Title, ContentDocumentId 
            FROM ContentVersion 
            WHERE ContentDocumentId IN :contentDocumentIds
        ];
        
        System.debug('List of ContentVersions: ' + contentVersions);
        
        List<ContentDistribution> contentDistributions = new List<ContentDistribution>();
        
        for (ContentVersion cv : contentVersions) {
           
            String trimTitle = cv.Title;
            Integer maxTitleLength = 50; 
            
            if (cv.Title != null && cv.Title.length() > maxTitleLength) {
                trimTitle = cv.Title.substring(0, maxTitleLength);
            }
            
            ContentDistribution cd = new ContentDistribution();
            cd.Name = trimTitle;
            cd.ContentVersionId = cv.Id;
            cd.PreferencesAllowViewInBrowser = true;
            cd.PreferencesLinkLatestVersion = true;
            cd.PreferencesNotifyOnVisit = false;
            cd.PreferencesPasswordRequired = false;
            cd.PreferencesAllowOriginalDownload = true;
            cd.PreferencesExpires = false;
            
            contentDistributions.add(cd);
        }
        
        System.debug('Total ContentDistribution : ' + contentDistributions.size());
        
        if (!contentDistributions.isEmpty()) {
           insert contentDistributions;
        } else {
            System.debug('unsuccessful insert.');
        }
    }
}