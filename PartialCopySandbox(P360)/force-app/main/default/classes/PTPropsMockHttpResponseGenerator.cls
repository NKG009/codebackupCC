/*******************************************************************************************
* @Name         PTPropsMockHttpResponseGenerator
* @Author       Rajesh
* @Description  This test class generates the mock response for PropertiesDataUpsert
*******************************************************************************************/
@isTest
public class PTPropsMockHttpResponseGenerator implements HttpCalloutMock {
    
    String ptJson = ''; 
    String iSource = '';
    Boolean isValidaJson; 
    
    public PTPropsMockHttpResponseGenerator(String integrationSource, String jsonData, Boolean isSuccessJson){
        ptJson = jsonData;
        iSource = integrationSource;
        isValidaJson = isSuccessJson;
    }
    
    // Implement this interface method
    public HTTPResponse respond(HTTPRequest req) {
        
        // Create a fake response 
        HttpResponse res = new HttpResponse();
        if(iSource.equalsignoreCase('Property Tree') || iSource.equalsignoreCase('Property Me')){           
                // Optionally, only send a mock response for a specific endpoint and method.
                System.assertEquals('GET', req.getMethod());                           
                res.setHeader('Content-Type', 'application/json');
                res.setBody(ptJson);
            	if(isValidaJson){
                	res.setStatusCode(200);      
                }else{
                    res.setStatusCode(201); 
                }
        } 
        return res;
    }

}