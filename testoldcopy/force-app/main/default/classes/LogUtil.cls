public class LogUtil {
    /*
    public static Final String ERROR = 'Error';
    public static Final Integer maxCharLimit = 131072;
    public static List<QBO_Log__c> errorLogs = new List<QBO_Log__c>();
        
    public static QBO_Log__c createLog(String apexCls, String method, String logType, Integer errCode, String errMsg) {
        return createLog(apexCls, method, logType, null, errCode, errMsg, null);
    }
    
    public static QBO_Log__c createLog(String apexCls, String method, String logType, String methdParams, Integer errCode,  String errMsg) {
        return createLog(apexCls, method, logType, methdParams, errCode, null, errMsg);
    }
    public static QBO_Log__c createLog(String apexCls, String method, String logType, String methdParams, Integer errCode, String responseBody, String errMsg) {
        QBO_Log__c logRec = new QBO_Log__c();
        logRec.QBO_Apex_Class__c = apexCls;
        logRec.QBO_Method__c = method;
        logRec.QBO_Type__c = logType;
        if(String.isNotBlank(methdParams)) {
            logRec.QBO_Method_Parameters__c = methdParams.length() > maxCharLimit ? methdParams.substring(0, maxCharLimit) : methdParams;
        }
        if(String.isNotBlank(responseBody)) {
            logRec.QBO_Response_Body__c = responseBody.length() > maxCharLimit ? responseBody.substring(0, maxCharLimit) : responseBody;
        }
        logRec.QBO_Status_Code__c = errCode;
        if(String.isNotBlank(errMsg)) {
            logRec.QBO_Error_Message__c = errMsg.length() > maxCharLimit ? errMsg.substring(0, maxCharLimit) : errMsg;
        }
        return logRec;
    }
    
    public static void insertLogs() {
        if(errorLogs != null && !errorLogs.isEmpty()) insert errorLogs;
        errorLogs = new List<QBO_Log__c>();
    }*/
}