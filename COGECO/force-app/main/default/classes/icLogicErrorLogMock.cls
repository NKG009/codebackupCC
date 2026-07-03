@isTest
public with sharing class icLogicErrorLogMock implements icLogicErrorLog.IClass{
	public String createErrorLog(String className, String methodName, String stackTrace, String errorMessage, String jsonObject) {
		Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'createErrorLog');
		params.put('className', className);
		params.put('methodName', methodName);
		params.put('stackTrace', stackTrace);
		params.put('errorMessage', errorMessage);
		params.put('jsonObject', jsonObject);
		return (String) icTestMockUtilities.Tracer.GetReturnValue(this, 'createErrorLog');
	}
}