public class AttachmentController {
    public Id recordId { get; set; }
    public List<AttachmentWrapper> attachments { get; set; }

    public AttachmentController(ApexPages.StandardController controller) {
        this.recordId = controller.getId();
        loadAttachments();
    }

    public void loadAttachments() {
        attachments = new List<AttachmentWrapper>();

        // Query ContentDocumentLink (for newer files stored in Salesforce Files)
        List<ContentDocumentLink> documentLinks = [
            SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.Description
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :recordId
        ];

        System.debug('Document Links: ' + documentLinks);

        String baseUrl = URL.getOrgDomainUrl().toExternalForm();

        for (ContentDocumentLink docLink : documentLinks) {
            ContentVersion contentVersion = [
                SELECT Id, Title, VersionData, FileType
                FROM ContentVersion
                WHERE ContentDocumentId = :docLink.ContentDocumentId
                ORDER BY CreatedDate DESC
                LIMIT 1
            ];

            System.debug('Content Version: ' + contentVersion);

            // Generate the preview URL
            String previewUrl;
            if (contentVersion.FileType == 'PDF') {
                previewUrl = baseUrl + '/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=' + contentVersion.Id + '&operationContext=CHATTER&contentType=application/pdf';
            } else if (contentVersion.FileType == 'application/msword' || 
                       contentVersion.FileType == 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' || 
                       contentVersion.FileType == 'application/vnd.ms-word.document.macroEnabled.12' || 
                       contentVersion.FileType == 'doc' || 
                       contentVersion.FileType == 'docx' || 
                       contentVersion.FileType == 'word_x') {
                previewUrl = baseUrl + '/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=' + contentVersion.Id + '&operationContext=CHATTER&contentType=application/vnd.openxmlformats-officedocument.wordprocessingml.document';
            } else {
                previewUrl = baseUrl + '/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=' + contentVersion.Id + '&operationContext=CHATTER&contentType=' + contentVersion.FileType;
            }

            // Generate URL to ContentDocument record
            String contentDocUrl = baseUrl + '/lightning/r/ContentDocument/' + docLink.ContentDocumentId + '/view';

            attachments.add(new AttachmentWrapper(contentVersion.Id, contentVersion.Title, contentVersion.FileType, previewUrl, contentDocUrl));
        }

        System.debug('Attachments: ' + attachments);
    }

    public class AttachmentWrapper {
        public String id { get; set; }
        public String title { get; set; }
        public String fileType { get; set; }
        public String previewUrl { get; set; }
        public String contentDocUrl { get; set; }

        public AttachmentWrapper(String id, String title, String fileType, String previewUrl, String contentDocUrl) {
            this.id = id;
            this.title = title;
            this.fileType = fileType;
            this.previewUrl = previewUrl;
            this.contentDocUrl = contentDocUrl;
        }
    }
}