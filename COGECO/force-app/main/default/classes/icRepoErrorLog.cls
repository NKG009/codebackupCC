public class icRepoErrorLog implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		void createErrorLog(Custom_Error_Log__c newErrorLog);
	}

	public class Impl implements IClass {

		public void createErrorLog(Custom_Error_Log__c newErrorLog) {
			insert newErrorLog;
		}
	}
}