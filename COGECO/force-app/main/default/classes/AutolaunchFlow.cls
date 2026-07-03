public without sharing class AutolaunchFlow {
	private Map<String, Object> parameters;
    private String flowName;
    
    public AutolaunchFlow(Map<String, Object> parameters, String flowName) {
        this.parameters = parameters;
        this.flowName = flowName;
    }
    
    public Flow.Interview start() {
        Flow.Interview dynamicFlow = Flow.Interview.createInterview(flowName, this.parameters);
      	dynamicFlow.start();
        
        return dynamicFlow;
    }
}