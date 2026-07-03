public with sharing class icServiceCISL implements icIClass {

	public Object GetInstance(){
		return new Impl();
	}

	public interface IClass {
		void sendShippingRequest(icDTOShippingRequest shippingRequest);
	}

	public class Impl implements IClass {

		public void sendShippingRequest(icDTOShippingRequest shippingRequest) {
			sendShippingRequestAsync(JSON.serialize(shippingRequest), shippingRequest.orderID);
		}		
	}

	@future(callout=true)
	private static void sendShippingRequestAsync(String requestBody, String orderId){
		icHTTPCallout.IClass icHTTP = (icHTTPCallout.IClass) icObjectFactory.GetSingletonInstance('icHTTPCallout');

		CISL_Configuration__c cislConfiguration = CISL_Configuration__c.getOrgDefaults();

		String requestURI = cislConfiguration.Shipping_Request_Endpoint__c;	// port: 8440

		HttpRequest request = new HttpRequest();
		request.setEndpoint(requestURI);
		request.setMethod('POST');
		request.setTimeout(120000);
		request.setHeader('RequestID', orderID);
		request.setClientCertificateName(cislConfiguration.Shipping_Request_Certificate__c); // devuat_salesforce_cogeco_com - prod_salesforce_cogeco_com

		request.setBody(requestBody);
		
		HTTPResponse response = icHTTP.invokeHTTPCallout(request);

		System.debug('response ' + response);
		if(response != null) {
			Integer responseStatusCode = response.getStatusCode();
			String responseStatus = response.getStatus();

			System.debug('response > Status ' + responseStatus);
			System.debug('response > StatusCode ' + responseStatusCode);
			System.debug('response > HeaderKeys ' + response.getHeaderKeys());

			if(responseStatusCode != 200) {
				icServiceErrorHandler.LogError('icServiceCISL', 'sendShippingRequestAsync', 'evaluating response : ' + responseStatusCode, responseStatus, response.getBody());
			}			
		}
	}
}