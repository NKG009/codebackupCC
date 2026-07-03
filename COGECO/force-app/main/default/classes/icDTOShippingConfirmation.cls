public class icDTOShippingConfirmation {
    public String deliveryRequestID {get; set;}
     // : "Unique identifier of the order submission request from Canada Post like tracking number (Mandatory)",
    
    public String orderID {get; set;}
     // : "Shipping Request Identifier one from input request(Mandatory)",
    
    public String shippingWaybillNumber {get; set;}
     // : "This is the Waybill Number for tracking of the shipment to the customer (outbound shipment) (Mandatory)",
    
    public String shippingWaybillStatus {get; set;}
     // : "Status from Canada post for given delivery (Mandatory)",
    
    public String shippingReturnWaybillNumber {get; set;}
     // : "This field will contain the Return Waybill Number if applicable (Swap/Exchange only) (Optional)",
    
    public String referencecustomerRef1 {get; set;}
     // : "This is refrence buid in by Cogeco CP process (Optional) ",
    
    public String referencecustomerRef2 {get; set;}
     // : "This is refrence buid in by Cogeco CP process (Optional)",
    
    public String resourceID {get; set;}
     // : "This is the Resource ID of the device from AMS (e.g 001F7D9EAC91)(Optional) ",
    
    public String resourceIDType {get; set;}
     // : "The type of resource value provided in the ResourceID field. Enumeration values are: ‘MAC’, ‘SN’, ‘UA’, 'TSN' (Optional)"

    public String shippingDate {get; set;}
     // : "2018-05-09"
}