@IsTest
public class orderdataerror400_Test {
    
    static testMethod void testParse() {
        String json = '{'+
            '    \"error\": {'+
            '        \"statusCode\": 400,'+
            '        \"message\": \"API creation is failed with not_found\",'+
            '        \"name\": \"Error\"'+
            '    }'+
            '}';
        Orderdataerror400 r = orderdataerror400.parse(json);
        System.assert(r != null);
        
    }
}