@isTest
public class icServiceCISLMock implements icServiceCISL.IClass {
	
	public void sendShippingRequest(icDTOShippingRequest shippingRequest) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'sendShippingRequest');
        params.put('shippingRequest', shippingRequest);
        //Return (CastType) icTestMockUtilities.Tracer.GetReturnValue(this, 'sendShippingRequest');
    }
}