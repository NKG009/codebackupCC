public class AttachmentReferencetrggerHandler{
    
    public static string lightningTheme ='Theme4d';
    public static String getLightning = getContextUserUiThemeDisplayed();
    
    public static void handleAfterInsertUpdate(List<TR1__Reference__c> listReference){
        Set<Id> setContentDocumentId = new Set<Id>();    
        List<ContentDocument> listContentDocument = new List<ContentDocument>();
        List<Attachment> listAttachment = new List<Attachment>();
        for(TR1__Reference__c ref : listReference) {
            if(ref.Status__c=='Complete' && ref.Reference_Received_Back_Manual_Upload__c) { 
                try{
                    listAttachment = [Select id,ParentId FROM Attachment WHERE ParentId = :ref.Id];
                    system.debug('++++++++listAttachment+++'+listAttachment);
                    if(lightningTheme.equals(getLightning)){
                        for(ContentDocumentLink contentDocumentLink : [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :ref.Id]){
                            setContentDocumentId.add(contentDocumentLink.ContentDocumentId);
                        }
                        system.debug('++++++++setContentDocumentId+++'+setContentDocumentId);
                        listContentDocument = [Select Id ,Title from ContentDocument Where ID In :setContentDocumentId];
                        system.debug('++++++++listContentDocument+++'+listContentDocument);
                    }
                }
                catch(Exception e){
                    listAttachment=null;
                }
                if(lightningTheme.equals(getLightning)){
                    if(listContentDocument.isEmpty()){
                        if(listAttachment.isEmpty()){
                            ref.addError('You must provide an attachment for manually uploaded reference.');
                        }
                    }
                }
                else{
                    if (listAttachment.isEmpty()){
                        ref.addError('You must provide an attachment for manually uploaded reference.');
                    }
                }
            }
        }
    }
    
    public static String getContextUserUiThemeDisplayed() {
        return UserInfo.getUiThemeDisplayed();
    }
}