@isTest
public with sharing class icTestMockUtilities {
	public class functionCalls{
		private Map<String, Integer> mapStackCalls = new Map<String, Integer>();
		private Map<String, Map<String, object>> parameterCalls = new Map<String, Map<String, object>>();
		private Map<String, object> mapReturnValues = new Map<String, Object>();

		public Map<String, object> RegisterCall(String FunctionName){
			Integer value = 0;
			Map<String, object> parameters;
			if(mapStackCalls.containsKey(FunctionName)){
				value = mapStackCalls.get(FunctionName);
				parameters = parameterCalls.get(FunctionName);
			}else{
				parameters = new Map<String, object>();
				parameterCalls.put(FunctionName, parameters);
			}

			value += 1;
			mapStackCalls.put(FunctionName,value);
			return parameters;
		}

		public Integer TimesIsBeenCalled(String FunctionName){
			if(mapStackCalls.containsKey(FunctionName)){
				return mapStackCalls.get(FunctionName);
			}
			return 0;
		}

		public Object GetParameterValue(String FunctionName, String ParameterName){
			return parameterCalls.get(FunctionName).get(ParameterName);
		}

		public void SetReturnValue(String FunctionName, Object Value){
			mapReturnValues.put(FunctionName, Value);
		}

		public Object GetReturnValue(String FunctionName){
			if(mapReturnValues.containsKey(FunctionName)){
				return mapReturnValues.get(FunctionName);
			}
			return null;
		}
	}

	private static Map<string, object> MockObjects = new Map<string, object>();
	private static Map<string, functionCalls> stackCalls = new Map<String, functionCalls>();
	public static TestMocker Mocker = new TestMocker();
	public static CallStackLog Tracer = new CallStackLog();

	public class TestMocker implements icObjectFactory.IMockCreator{
		public object CreateMockInstance(String ClassName){
			return MockObjects.get(className);
		}

		public void SetMockInstance(String className, Object mockInstance){
			MockObjects.Put(className, mockInstance);
		}

		public void SetMockSingletonInstance(String className, Object mockInstance){
			icObjectFactory.MockSingletonInstance(className, mockInstance);
			MockObjects.Put(className, mockInstance);
		}
	}

	public class CallStackLog {
		public Map<String, object> RegisterCall(object instance, String methodName){
			String className = String.valueOf(instance).split(':')[0];
			if(!stackCalls.containsKey(className)){
				stackCalls.put(className, new functionCalls());
			}

			functionCalls fc = stackCalls.get(className);
			return fc.RegisterCall(methodName);
		}

		public boolean HasBeenCalled(String className, String methodName){
			if(!stackCalls.containsKey(className)) return false;

			if(((functionCalls) stackCalls.get(className)).TimesIsBeenCalled(methodName) > 0 ){ 
				return true;
			}

			return false;
		}

		public boolean HasBeenCalledWithParameter(String ClassName, String methodName, String ParameterName, Object value){
			System.Debug(stackCalls);
			if(!stackCalls.containsKey(className)) return false;

			functionCalls fc = (functionCalls) stackCalls.get(className);
			System.Debug(fc);
			if(fc.TimesIsBeenCalled(methodName) > 0 ){ 
				if( fc.GetParameterValue(methodName, ParameterName) == value ){
					return true;
				}
			}
			return false;
		}

		public void SetReturnValue(string ClassName, string FunctionName, object Value){
			if(!stackCalls.containsKey(className)){
				stackCalls.put(className, new functionCalls());
			}

			functionCalls fc = stackCalls.get(ClassName);
			fc.SetReturnValue(FunctionName, Value);
		}

		public object GetReturnValue(object instance, String methodName){
			String className = String.valueOf(instance).split(':')[0];
			System.Debug('Finding Return for:' + className + ' method :' + methodName);
			if(!stackCalls.containsKey(className)){
				return null;
			}

			functionCalls fc = stackCalls.get(className);
			return fc.GetReturnValue(methodName);
		}
	}
}