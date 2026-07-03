@isTest
global class InvoicequerymockGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        //res.setBody('{"FrostId":"FrostId12"}');
        res.setBody('{"data":[{"Entity":"Blue Arrow","Branch Code":"1062  ","Branch Name":"BAL Newbury","Acc No":"1006169   ","Client":"Tradeteam Limited","Invoice Date":"2018-04-08T00:00:00","Due Date":"2018-05-30T00:00:00","Invoice Number":"23448686     ","Query Value":3069.67,"Date Raised":"2018-04-20T00:00:00","Age of Query":-795,"Contact":"BranchRequest@impellam.com","Status":"PO query - Special Billing    ","Query Description":"23448686 PO query - Special Billing-M1o- Multi 06/04/2018 Multi - PO 44010580824 VALUE IS £1,806.54. INVOICE VALUE TRADETEAM KINTORE W/E 06/04/18 IS £2,558.06","Comment":""}]}');

        res.setStatusCode(200);
        return res;
    }
}