public class CustomerEmailAttachmentDto {
    public String attachmentId {get;set;}
    public String attachmentName {get;set;}
    public String attachmentDescription {get;set;}
    public String attachmentExtension {get;set;}
    
    public CustomerEmailAttachmentDto() { }
    
    public CustomerEmailAttachmentDto(String attachmentId, String attachmentName, String attachmentDescription, String attachmentExtension) {
        this.attachmentId = attachmentId;
        this.attachmentName = attachmentName;
        this.attachmentDescription = attachmentDescription;
        this.attachmentExtension = attachmentExtension;
    }
}