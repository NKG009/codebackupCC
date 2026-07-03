public with sharing class icHTTPCallout implements icIClass {
	public Object GetInstance()
	{
		return new Impl();
	}

	public Interface IClass{
		HTTPResponse invokeHTTPCallout(HttpRequest request);
	}

	public class Impl implements IClass
	{
		public HTTPResponse invokeHTTPCallout(HttpRequest request){
			Http http = new Http();
			HTTPResponse response;
			System.debug('request ' + request);
			System.debug('request body ' + request.getBody());
			try{
				response = http.send(request);
			}catch(System.Exception ex){
				System.debug('invokeHTTPCallout Exception - ' + ex.getMessage());
				icServiceErrorHandler.LogError('icHTTPCallout', 'invokeHTTPCallout', ex.getStackTraceString(), ex.getMessage(), '');
			}
			return response;
		}
	}
}