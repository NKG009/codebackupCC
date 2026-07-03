public class ContentDocumentLinkTriggerHelper {

    public static void beforeInsert(List<ContentDocumentLink> newList) {
        String workOrderObjPrefix = getObjectKeyPrefix('WorkOrder');
        for(ContentDocumentLink cdLink : newList) {
            if(((String)cdLink.LinkedEntityId).startsWith(workOrderObjPrefix)) {
                cdLink.Visibility = 'AllUsers';
            }
        }
    }
    
    private static String getObjectKeyPrefix(String objectName) {
        Schema.sObjectType objectType = Schema.getGlobalDescribe().get(objectName);
        return objectType.getDescribe().getKeyPrefix();
    }
}