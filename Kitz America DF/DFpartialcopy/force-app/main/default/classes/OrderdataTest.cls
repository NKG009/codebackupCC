@IsTest
public class OrderdataTest {
    
    static testMethod void testParse() {
        String json = '{\"OrderID\":\"a3tDv000000oZZZIAM\",\"error\":{\"message\":\"Message not queued for processing by SAP - 204\",\"name\":\"Error\",\"statusCode\":204}}';
        Orderdata obj = orderdata.parse(json);
        System.assert(obj != null);
    }
}