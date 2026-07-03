public class icLogicErrorLog implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		String createErrorLog(String className, String methodName, String stackTrace, String errorMessage, String jsonObject);
	}

	public class Impl implements IClass {

		icRepoErrorLog.IClass repo = (icRepoErrorLog.IClass) icObjectFactory.GetSingletonInstance('icRepoErrorLog');

		public String createErrorLog(String className, String methodName, String stackTrace, String errorMessage, String jsonObject) {
			if(errorMessage.length() > 254) {
				errorMessage = errorMessage.left(254);
			}

			Custom_Error_Log__c newErrorLog = new Custom_Error_Log__c(
				Class_Name__c = className
				,Method_Name__c = methodName
				,Stack_Trace__c = stackTrace
				,Error_Message__c = errorMessage
				,JSON_Object__c = jsonObject);
			repo.createErrorLog(newErrorLog);
			
			return newErrorLog.Id;
		}
	}
}