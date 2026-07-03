public class icServiceErrorHandler {
	private static icLogicErrorLog.IClass logic = (icLogicErrorLog.IClass) icObjectFactory.GetSingletonInstance('icLogicErrorLog');

	public static String LogError(String className, String methodName, String stackTrace, String errorMessage, String jsonObject) {
		return logic.createErrorLog(className, methodName, stackTrace, errorMessage, jsonObject);
	}
}