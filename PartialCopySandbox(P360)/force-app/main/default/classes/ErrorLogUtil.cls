public class ErrorLogUtil {

    public static Error_Log__c createSampleErrorLog(String statusCode, String errMsg, String description, String cls, String method, 
                                                    String objectType, String source) {
        Error_Log__c errorLog = new Error_Log__c();
        errorLog.Error_Type__c = 'ERROR';
        errorLog.Error_Status_Code__c = statusCode;
        errorLog.Error_Message__c = (String.isNotBlank(errMsg) && errMsg.length() > 255) ? errMsg.substring(0, 255) : errMsg;
        errorLog.Error_Description__c = description;
        errorLog.Class_Name__c = cls;
        errorLog.Method_Name__c = method;
        errorLog.Object_Type__c = objectType;
        errorLog.Source__c = source;
        return errorLog;
    }
    
    public static void insertLogs(List<Error_Log__c> logs) {
        if(logs != null && !logs.isEmpty()) {
            insert logs;
        }
    }
}