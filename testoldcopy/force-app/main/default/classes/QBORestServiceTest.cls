@isTest
private class QBORestServiceTest {
    public static String CustomerId = '1';
    public static String ItemId = '1';
    public static String EstimateId = '41';
    public static String InvoiceId = '239';
    public static String PaymentId = '152';
  /*  
   @testSetup
   static void testSetup() {
        QBO_Quickbooks_App_Info__c config = QBO_Quickbooks_App_Info__c.getOrgDefaults();
        config.QBO_Enable_Quickbooks__c = true;
        config.QBO_Client_ID__c = '823042834345';
        config.QBO_Client_Secret__c = '823042834345';
        upsert config;
       
		QBO_QuickBook_Auth_Info__c qboAuthInfoRec = new QBO_QuickBook_Auth_Info__c();
       	qboAuthInfoRec.QBO_Refresh_Token__c = qboAuthInfoRec.QBO_Access_Token__c = '273649827304720';
       	insert qboAuthInfoRec;
       
       	Pricebook2 standardPricebook = new Pricebook2(
        	Id = Test.getStandardPricebookId(),
           	IsActive = true
       	);
       	update standardPricebook;
       
    }
    
    static testmethod void notificationTest(){
       
        Test.setMock(HttpCalloutMock.class, new QBOGetRequestMockGenerator());
        Test.startTest();
        QBOWebhookWrapper.EventNotification eventNot1 = new QBOWebhookWrapper.EventNotification();
        eventNot1.realmId = '123';
        eventNot1.dataChangeEvent = new QBOWebhookWrapper.Event();
        
        QBOWebhookWrapper.Entity itemEntity = new QBOWebhookWrapper.Entity();
        itemEntity.id =ItemId;
        itemEntity.name = 'item';
        itemEntity.operation = 'update';
        
        QBOWebhookWrapper.Entity customerEntity = new QBOWebhookWrapper.Entity();
        customerEntity.id = CustomerId;
        customerEntity.name = 'customer';
        customerEntity.operation = 'create';
        
        QBOWebhookWrapper.Entity estimateEntity = new QBOWebhookWrapper.Entity();
        estimateEntity.id = EstimateId;
        estimateEntity.name = 'estimate';
        estimateEntity.operation = 'create';
        
        QBOWebhookWrapper.Entity invoiceEntity = new QBOWebhookWrapper.Entity();
        invoiceEntity.id = InvoiceId;
        invoiceEntity.name = 'invoice';
        invoiceEntity.operation = 'create';
        
        QBOWebhookWrapper.Entity paymentEntity = new QBOWebhookWrapper.Entity();
        invoiceEntity.id = PaymentId;
        invoiceEntity.name = 'payment';
        invoiceEntity.operation = 'create';
        
        eventNot1.dataChangeEvent.entities = new List<QBOWebhookWrapper.Entity>{itemEntity, customerEntity, estimateEntity, invoiceEntity, paymentEntity};
        QBOWebhookWrapper webhookObj = new QBOWebhookWrapper();
        webhookObj.eventNotifications = new List<QBOWebhookWrapper.EventNotification>{eventNot1};
            
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/qbowebservice';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JSON.serialize(webhookObj));
        RestContext.request = req;
        RestContext.response= res;
                Test.setMock(HttpCalloutMock.class, new QBOGetRequestMockGenerator());
        QuickbooksPaymentWebService.GetPaymentWebhooksResponse();
        Test.stopTest();
    }
    
    static testmethod void deleteNotificationTest(){
       
        Test.setMock(HttpCalloutMock.class, new QBODeleteRequestMockGenerator());
        Test.startTest();
        QBOWebhookWrapper.EventNotification eventNot1 = new QBOWebhookWrapper.EventNotification();
        eventNot1.realmId = '123';
        eventNot1.dataChangeEvent = new QBOWebhookWrapper.Event();
        
        QBOWebhookWrapper.Entity itemEntity = new QBOWebhookWrapper.Entity();
        itemEntity.id = ItemId;
        itemEntity.name = 'item';
        itemEntity.operation = 'update';
        
        QBOWebhookWrapper.Entity customerEntity = new QBOWebhookWrapper.Entity();
        customerEntity.id = CustomerId;
        customerEntity.name = 'customer';
        customerEntity.operation = 'update';
        
        QBOWebhookWrapper.Entity estimateEntity = new QBOWebhookWrapper.Entity();
        estimateEntity.id = EstimateId;
        estimateEntity.name = 'estimate';
        estimateEntity.operation = 'update';
        
        QBOWebhookWrapper.Entity invoiceEntity = new QBOWebhookWrapper.Entity();
        invoiceEntity.id =InvoiceId;
        invoiceEntity.name = 'invoice';
        invoiceEntity.operation = 'update';
        
        QBOWebhookWrapper.Entity paymentEntity = new QBOWebhookWrapper.Entity();
        invoiceEntity.id =PaymentId;
        invoiceEntity.name = 'payment';
        invoiceEntity.operation = 'create';
        
        eventNot1.dataChangeEvent.entities = new List<QBOWebhookWrapper.Entity>{itemEntity, customerEntity, estimateEntity, invoiceEntity};
        QBOWebhookWrapper webhookObj = new QBOWebhookWrapper();
        webhookObj.eventNotifications = new List<QBOWebhookWrapper.EventNotification>{eventNot1};
            
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/qbowebservice';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JSON.serialize(webhookObj));
        RestContext.request = req;
        RestContext.response= res;
       QuickbooksPaymentWebService.GetPaymentWebhooksResponse();
       
        Test.stopTest();
    }
    
    public class QBODeleteRequestMockGenerator implements HttpCalloutMock{
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest request) {
            // Create a fake response
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            if(request.getEndpoint().containsIgnoreCase('tokens'))
                response.setBody('{"x_refresh_token_expires_in":8726400,"refresh_token":"AB11602094975KiN2qJNm5axzgWeddwdldTeqcdSbXd4lk1XR9","token_type":"bearer","access_token":"abcdxyz","expires_in":-100}');
            else if(request.getEndpoint().containsIgnoreCase('item'))
                response.setBody('{"QueryResponse":{"startPosition":1,"Item":[],"maxResults":2},"time":"2015-04-22T11:04:34.194-07:00"}');
            else if(request.getEndpoint().containsIgnoreCase('customer'))
                response.setBody('{"QueryResponse": {"Customer": [], "startPosition": 1, "maxResults": 6  },   "time": "2015-07-23T11:02:25.149-07:00"}');
            else if(request.getEndpoint().containsIgnoreCase('invoice'))
                response.setBody('{"QueryResponse":{"startPosition":1,"totalCount":1,"maxResults":1,"Invoice":[]},"time":"2015-07-24T10:38:50.01-07:00"}');
            else if(request.getEndpoint().containsIgnoreCase('estimate'))
                response.setBody('{"QueryResponse":{"startPosition":1,"Estimate":[],"maxResults":1},"time":"2015-07-24T14:00:04.902-07:00"}');
            else if(request.getEndpoint().containsIgnoreCase('payment'))
                response.setBody('{"QueryResponse":{},"time":"2022-08-01T11:16:02.467-07:00"}');
            response.setStatusCode(200);
            return response; 
        }
    }
    
    public class QBOGetRequestMockGenerator implements HttpCalloutMock{
    
    // Implement this interface method
    public HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        if(request.getEndpoint().containsIgnoreCase('tokens'))
            response.setBody('{"x_refresh_token_expires_in":8726400,"refresh_token":"AB11602094975KiN2qJNm5axzgWeddwdldTeqcdSbXd4lk1XR9","token_type":"bearer","access_token":"abcdxyz","expires_in":-100}');
        else if(request.getEndpoint().containsIgnoreCase('item'))
            response.setBody('{"QueryResponse":{"startPosition":1,"Item":[{"FullyQualifiedName":"Concrete","domain":"QBO","Name":"Concrete","TrackQtyOnHand":false,"Type":"Service","PurchaseCost":0,"IncomeAccountRef":{"name":"LandscapingServices:JobMaterials:FountainsandGardenLighting","value":"48"},"Taxable":true,"MetaData":{"CreateTime":"2014-09-16T10:36:03-07:00","LastUpdatedTime":"2014-09-19T12:47:47-07:00"},"sparse":false,"Active":true,"SyncToken":"1","UnitPrice":0,"Id":"'+ItemId+'","Description":"Concreteforfountaininstallation"}],"maxResults":2},"time":"2015-04-22T11:04:34.194-07:00"}');
        else if(request.getEndpoint().containsIgnoreCase('customer'))
            response.setBody('{"QueryResponse": {"Customer": [{"domain": "QBO","FamilyName": "Lauterbach","DisplayName": "Amy\'s Bird Sanctuary","DefaultTaxCodeRef": { "value": "2"},"PrimaryEmailAddr": { "Address": "Birds@Intuit.com"},"PreferredDeliveryMethod": "Print","GivenName": "Amy","FullyQualifiedName": "Amy\'s Bird Sanctuary","BillWithParent": false,"Job": false,"BalanceWithJobs": 274.0,"PrimaryPhone": { "FreeFormNumber": "(650) 555-3311"},"Active": true,"MetaData": { "CreateTime": "2014-09-11T16:48:43-07:00",  "LastUpdatedTime": "2015-07-01T10:14:15-07:00"},"BillAddr": { "City": "Bayshore",  "Line1": "4581 Finch St.",  "PostalCode": "94326",  "Lat": "INVALID",  "Long": "INVALID",  "CountrySubDivisionCode": "CA",  "Id": "2"},"MiddleName": "Michelle","Notes": "Note added via Update operation.","Taxable": true,"Balance": 274.0,"SyncToken": "5","ShipAddr": { "City": "Bayshore",  "Line1": "4581 Finch St.",  "PostalCode": "94326",  "Lat": "INVALID",  "Long": "INVALID",  "CountrySubDivisionCode": "CA",  "Id": "109"},"PrintOnCheckName": "Amy\'s Bird Sanctuary","sparse": false,"Id": "'+CustomerId+'"}], "startPosition": 1, "maxResults": 6  },   "time": "2015-07-23T11:02:25.149-07:00"}');
        else if(request.getEndpoint().containsIgnoreCase('invoice'))
            response.setBody('{"QueryResponse":{"startPosition":1,"totalCount":1,"maxResults":1,"Invoice":[{"DocNumber":"1070","SyncToken":"0","domain":"QBO","Balance":150.0,"BillAddr":{"City":"Bayshore","Line1":"4581FinchSt.","PostalCode":"94326","Lat":"INVALID","Long":"INVALID","CountrySubDivisionCode":"CA","Id":"2"},"TxnDate":"2015-07-24","TotalAmt":150.0,"CustomerRef":{"name":"Amy\'sBirdSanctuary","value":"1"},"ShipAddr":{"City":"Bayshore","Line1":"4581FinchSt.","PostalCode":"94326","Lat":"INVALID","Long":"INVALID","CountrySubDivisionCode":"CA","Id":"109"},"LinkedTxn":[],"DueDate":"2015-08-23","PrintStatus":"NeedToPrint","Deposit":0,"sparse":false,"EmailStatus":"NotSet","Line":[{"LineNum":1,"Amount":150.0,"SalesItemLineDetail":{"TaxCodeRef":{"value":"NON"},"ItemRef":{"name":"Services","value":"1"}},"Id":"1","DetailType":"SalesItemLineDetail"},{"DetailType":"SubTotalLineDetail","Amount":150.0,"SubTotalLineDetail":{}}],"ApplyTaxAfterDiscount":false,"CustomField":[{"DefinitionId":"1","Type":"StringType","Name":"Crew#"}],"Id":"'+InvoiceId+'","TxnTaxDetail":{"TotalTax":0},"MetaData":{"CreateTime":"2015-07-24T10:35:08-07:00","LastUpdatedTime":"2015-07-24T10:35:08-07:00"}}]},"time":"2015-07-24T10:38:50.01-07:00"}');
        else if(request.getEndpoint().containsIgnoreCase('estimate'))
            response.setBody('{"QueryResponse":{"startPosition":1,"Estimate":[{"DocNumber":"1001","SyncToken":"0","domain":"QBO","TxnStatus":"Closed","BillEmail":{"Address":"Geeta@Kalapatapu.com"},"TxnDate":"2014-09-07","TotalAmt":582.5,"CustomerRef":{"name":"GeetaKalapatapu","value":"10"},"CustomerMemo":{"value":"Thankyouforyourbusinessandhaveagreatday!"},"ShipAddr":{"City":"Middlefield","Line1":"1987MainSt.","PostalCode":"94303","Lat":"37.445013","Long":"-122.1391443","CountrySubDivisionCode":"CA","Id":"10"},"LinkedTxn":[{"TxnId":"103","TxnType":"Invoice"}],"PrintStatus":"NeedToPrint","BillAddr":{"Line3":"Middlefield,CA94303","Line2":"1987MainSt.","Long":"-122.1178261","Line1":"GeetaKalapatapu","Lat":"37.4530553","Id":"59"},"sparse":false,"EmailStatus":"NotSet","Line":[{"Description":"RockFountain","DetailType":"SalesItemLineDetail","SalesItemLineDetail":{"TaxCodeRef":{"value":"NON"},"Qty":1,"UnitPrice":275,"ItemRef":{"name":"RockFountain","value":"'+ItemId+'"}},"LineNum":1,"Amount":275.0,"Id":"1"},{"DetailType":"SubTotalLineDetail","Amount":582.5,"SubTotalLineDetail":{}}],"ApplyTaxAfterDiscount":false,"CustomField":[{"DefinitionId":"1","Type":"StringType","Name":"Crew#"}],"Id":"'+estimateId+'","TxnTaxDetail":{"TotalTax":0},"MetaData":{"CreateTime":"2014-09-17T11:20:06-07:00","LastUpdatedTime":"2014-09-18T13:41:59-07:00"}}],"maxResults":1},"time":"2015-07-24T14:00:04.902-07:00"}');
        else if(request.getEndpoint().containsIgnoreCase('query'))
            response.setBody('{"QueryResponse":{"Payment":[{"CustomerRef":{"value":"62","name":"Vivek Singh - CUST-00000036"},"DepositToAccountRef":{"value":"4"},"PaymentRefNum":"Payment003","TotalAmt":40,"UnappliedAmt":0,"ProcessPayment":false,"domain":"QBO","sparse":false,"Id":"162","SyncToken":"6","MetaData":{"CreateTime":"2022-08-01T09:35:37-07:00","LastUpdatedTime":"2022-08-01T11:00:15-07:00"},"TxnDate":"2022-08-01","CurrencyRef":{"value":"USD","name":"United States Dollar"},"Line":[{"Amount":40,"LinkedTxn":[{"TxnId":"'+InvoiceId+'","TxnType":"Invoice"}],"LineEx":{"any":[{"name":"{http://schema.intuit.com/finance/v3}NameValue","declaredType":"com.intuit.schema.finance.v3.NameValue","scope":"javax.xml.bind.JAXBElement$GlobalScope","value":{"Name":"txnId","Value":"152"},"nil":false,"globalScope":true,"typeSubstituted":false},{"name":"{http://schema.intuit.com/finance/v3}NameValue","declaredType":"com.intuit.schema.finance.v3.NameValue","scope":"javax.xml.bind.JAXBElement$GlobalScope","value":{"Name":"txnOpenBalance","Value":"40.00"},"nil":false,"globalScope":true,"typeSubstituted":false},{"name":"{http://schema.intuit.com/finance/v3}NameValue","declaredType":"com.intuit.schema.finance.v3.NameValue","scope":"javax.xml.bind.JAXBElement$GlobalScope","value":{"Name":"txnReferenceNumber","Value":"1039"},"nil":false,"globalScope":true,"typeSubstituted":false}]}}]}],"startPosition":1,"maxResults":1}}');
        response.setStatusCode(200);
        return response; 
    }
}
    static testmethod void test3(){
         set<string> nls = new set<string>();
        nls.add('169');
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new QBOGetRequestMockGenerator());
       QuickbooksPaymentWebService.fetchPaymentByIds(nls);
        test.stopTest();
    }
    */
}