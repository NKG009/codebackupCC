public class icObjectFactory {
	
	public Interface IMockCreator{ 
		object CreateMockInstance(String ClassName);
	}

	@testVisible
	private static Map<string, object> globalObjects = new Map<string, object>();
	private static IMockCreator mockInstantiator = null;

	public static object GetSingletonInstance(String className){
	if(!globalObjects.containsKey(className)){
		Type t = Type.forName(className);
		Object newObj = ((icIClass) t.newInstance()).GetInstance();
		System.Debug('Type Found : ' + t + ' for class : ' + className);
		globalObjects.put(className, newObj);
	}

	return globalObjects.get(className);
	}

	public static void MockSingletonInstance(String className, Object mock){
		globalObjects.put(className, mock);
	}

	public static void SetMockInstantiator(IMockCreator creator){
		mockInstantiator = creator;
	}

	public static void ResetFactory(){
		globalObjects.clear();
	}

	public static object GetInstance(String className){
	if(mockInstantiator == null){
		Type t = Type.forName(className);
		return ((icIClass) t.newInstance()).GetInstance();
	}

	return mockInstantiator.CreateMockInstance(ClassName);
	}
}