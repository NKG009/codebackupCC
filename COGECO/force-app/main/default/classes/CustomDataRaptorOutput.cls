global with sharing class CustomDataRaptorOutput implements Callable {

    public Object call(String action, Map<String, Object> args){
        Map<String, Object> input = (Map<String, Object>)args.get('input');
        Map<String, Object> output = (Map<String, Object>)args.get('output');
        Map<String, Object> options = (Map<String, Object>)args.get('options');

        return invokeMethod(action, input, output, options);
    }

	global Boolean invokeMethod(String methodName, Map<String, Object> inputs, Map<String, Object> output, Map<String, Object> options) {
        if (methodName == 'CustomDocGenOutput') {
            List<Object> argumentsList = (List<Object>)inputs.get('arguments');
            String strId = (String)argumentsList[0];
            Id id = (Id)strId;
            
            String data = this.createResult(Id);
            Map<String, Object> dataMap = String.isBlank(data) ? new Map<String, Object>() : (Map<String,Object>)JSON.deserializeUntyped(data);
            output.put('result', dataMap);
        }
        
        return true;
    }
    
    private String createResult(Id quoteId) {
        return ContractService.process(quoteId);
    }
}