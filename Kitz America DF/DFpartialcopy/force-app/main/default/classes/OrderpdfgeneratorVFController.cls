public with sharing class OrderpdfgeneratorVFController {

    public Order ord { get; private set; }
    public List<OrderItem> items { get; private set; }

    public Contact billToContact { get; private set; }
    public User salesRep { get; private set; }
    
    public Id orderId { get; private set; }

   
    public OrderpdfgeneratorVFController() {

       // Id orderId = ApexPages.currentPage().getParameters().get('id');
       orderId = ApexPages.currentPage().getParameters().get('id');
        if(orderId == null) {
            orderId = ApexPages.currentPage().getParameters().get('recordId');
        }
        System.debug('Order Id from VF: ' + orderId);
     //   Id orderId     ='801VG00000o7fGWYAY';
        ord = [
            SELECT Id,
                   OrderNumber,
                   ST_SAP_SO_Number__c,
            	   PoNumber,
                   EffectiveDate,
                   BillToContactId,
                   BillToContact.Name,
                   BillToContact.Email,
                   SBQQ__Quote__r.SBQQ__SalesRep__c,
                   SBQQ__Quote__r.SBQQ__SalesRep__r.Email,
                   SBQQ__Quote__r.SBQQ__SalesRep__r.Name,
                   Ship_To_Account_Number__c,
                   SoldToAccountId__c,
                   ShipToAccountId__c,
                   ShippingAddress,
                   BillingAddress,
                   Total_Weight_lb__c,
                   Total_Net_Price__c
            FROM Order
            WHERE Id = :orderId
        ];

        items = [
            SELECT Quantity,
                   OrderItemNumber,
                   Product2.Name,
                   Product2.ProductCode,
                   Product_Description__c,
                   Notes_Est_Delivery__c,
                   UnitPrice,
                   TotalPrice
            FROM OrderItem
            WHERE OrderId = :orderId
            ORDER BY OrderItemNumber
        ];

        billToContact = ord.BillToContact;
        salesRep = ord.SBQQ__Quote__r.SBQQ__SalesRep__r;
    }
}