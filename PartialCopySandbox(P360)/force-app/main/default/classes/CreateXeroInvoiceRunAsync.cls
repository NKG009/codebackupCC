// Start Apex Class
public with sharing class CreateXeroInvoiceRunAsync {
    
    public static InvoiceListWrapper fakeInvoiceWrapper;
    public CreateXeroInvoiceRunAsync() {

    }

    @InvocableMethod(label='Create Xero Invoice' description='Create Xero Invoice')
    public static void createXeroInvoice(List<Requests> requestList){
        List<Object> xeroInvoiceList = new List<Object>();
        String xeroOrgIdValue = '';
        String OrderIdValue = '';

        for(Requests req : requestList){
            If(req.xeroOrgId != NULL && String.isNotBlank(req.xeroOrgId))
                xeroOrgIdValue = req.xeroOrgId;
            If(req.OrderId!= NULL && String.isNotBlank(req.OrderId))
                OrderIdValue = req.OrderId;

            xeroInvoiceList.add(generateXeroInvoiceMap(req));
        }

        // Sending request to Xero via exposed Global API
        Map<String, Object> reqJSONMap = new Map<String, Object>(); 
        reqJSONMap.put('invoices' , xeroInvoiceList);
        String reqJSON = JSON.serialize(reqJSONMap); 

        Map<String, Object> finalReqMap = new Map<String, Object>(); 
        finalReqMap.put('version' , '1.0'); 
        finalReqMap.put('action' , 'createInvoice');
        finalReqMap.put('RequestJSON' , reqJSON); 
        If(xeroOrgIdValue != NULL && String.isNotBlank(xeroOrgIdValue))
            finalReqMap.put('xeroOrgId' , xeroOrgIdValue);
        System.debug('Request ::: ' + finalReqMap);
        System.debug('RequestJSON ::: ' + JSON.serialize(finalReqMap));

        // Make a request to Xero
        Map<String, Object> respMap = Bread_Winner.BreadwinnerXeroAPI.call(finalReqMap);
        System.debug(JSON.serialize(respMap));
        String respJSONString = String.valueOf(respMap.get('responseJSON'));
        System.debug(respJSONString);
        InvoiceListWrapper invWrapper;
        if (Test.isRunningTest()) {
            invWrapper = fakeInvoiceWrapper;
        } else {
            invWrapper = (InvoiceListWrapper)JSON.deserialize(respJSONString,InvoiceListWrapper.class);
        }

        // Collect ids from response.
        List<String> ids = new List<String>();
        for (InvoiceWrapper invoice :  invWrapper.invoices){
            String invoiceId = invoice.SalesforceRecordId;

            ids.add(invoiceId);
        }

        // Get invoices by ids.
        Map<String, String> names = new Map<String, String>();
        List<Bread_Winner__Invoice__c> invoices = [SELECT Id,Name, Order_Lookup__r.Invoice_Number2__c  FROM Bread_Winner__Invoice__c where Id IN : ids];
        for(Bread_Winner__Invoice__c invoice : invoices){
            names.put(invoice.Name, invoice.Id);
        }

        // Get orders by names.
        Order[] orders = [SELECT Id, Invoice_Number2__c  FROM Order where Invoice_Number2__c IN :names.keySet()];
        for(Bread_Winner__Invoice__c invoice : invoices){
            for(Order order : orders){
                if(order.Invoice_Number2__c != invoice.Name) continue;

                invoice.Order_Lookup__c = order.Id;
            }
        }

        update invoices;
    }

	public class InvoiceWrapper{
		public String SalesforceRecordId;
	}
	public class InvoiceListWrapper{
		public List<InvoiceWrapper> invoices;
	}

    public class Response{
        @InvocableVariable(label='status Code' description='Status of the request')
        public String statusCode;

        @InvocableVariable(label='Error' description='Error')
        public String error;
    }

    public class Requests{
        @InvocableVariable(label='Xero Org Id' description='Xero Org Id')
        public String xeroOrgId;
        
        @InvocableVariable(label='OrderId' description='OrderId')
        public String OrderId;

        @InvocableVariable(label='Xero Contact ID' description='Xero Contact ID')
        public String ContactID;

        @InvocableVariable(label='Date' description='Date')
        public Date DateString;

        @InvocableVariable(label='Due Date' description='Due Date')
        public Date DueDateString;

        @InvocableVariable(label='Status' description='Status')
        public String Status;

        @InvocableVariable(label='InvoiceNumber' description='InvoiceNumber')
        public String InvoiceNumber;

        @InvocableVariable(label='Reference' description='Reference')
        public String Reference;

        @InvocableVariable(label='Line Amount Types' description='Line Amount Types')
        public String LineAmountTypes;

        @InvocableVariable(label='Salesforce Account Id' description='Salesforce Account Id')
        public String Salesforce_Account_Id;

        @InvocableVariable(label='Salesforce Opportunity Id' description='Salesforce Opportunity Id')
        public String Salesforce_Opportunity_Id;

        @InvocableVariable(label='Line Item Code' description='Line Item Code')
        public STRING ItemCode;

        @InvocableVariable(label='Line Description' description='Line Description')
        public STRING Description;

        @InvocableVariable(label='Line Tax Type' description='Line Tax Type')
        public STRING TaxType;

        @InvocableVariable(label='Line Account Code' description='Line Account Code')
        public STRING AccountCode;

        @InvocableVariable(label='Line Line Item ID' description='Line Line Item ID')
        public STRING LineItemID;

        @InvocableVariable(label='Line Unit Amount' description='Line Unit Amount')
        public STRING UnitAmount;

        @InvocableVariable(label='Line Tax Amount' description='Line Tax Amount')
        public STRING TaxAmount;

        @InvocableVariable(label='Line Line Amount' description='Line Line Amount')
        public STRING LineAmount;

        @InvocableVariable(label='Line Quantity' description='Line Quantity')
        public STRING Quantity;

        @InvocableVariable(label='Line Discount Rate' description='Line Discount Rate')
        public STRING DiscountRate;

        @InvocableVariable(label='Line Tracking Category ID 1' description='Line Tracking Category ID 1')
        public STRING TrackingCategoryID1;

        @InvocableVariable(label='Line Tracking Category Name 1' description='Line Tracking Category Name 1')
        public STRING TrackingCategoryName1;

        @InvocableVariable(label='Line Tracking Category Option 1' description='Line Tracking Category Option 1')
        public STRING TrackingCategoryOption1;

        @InvocableVariable(label='Line Tracking Category ID 2' description='Line Tracking Category ID 2')
        public STRING TrackingCategoryID2;

        @InvocableVariable(label='Line Tracking Category Name 2' description='Line Tracking Category Name 2')
        public STRING TrackingCategoryName2;

        @InvocableVariable(label='Line Tracking Category Option 2' description='Line Tracking Category Option 2')
        public STRING TrackingCategoryOption2;

        @InvocableVariable(label='Invoice Line Items' description='Invoice Line Items') 
        public List<SObject> invoiceLines; 


    }

    public static Map<String, Object> generateXeroInvoiceMap(Requests req){
        Map<String, Object> xeroInvoiceMap = new Map<String, Object>(); 
        // Assign values from the Request to Xero Invoice
        Map<String,Object> xeroInvoiceContactRefMap = new Map<String,Object>();
        xeroInvoiceMap.put('Type','ACCREC');
        
        If(req.OrderId != NULL && String.isNotBlank(req.OrderId))
            xeroInvoiceMap.put('OrderId', req.OrderId);        

        If(req.ContactID != NULL && String.isNotBlank(req.ContactID))
            xeroInvoiceContactRefMap.put('ContactID', req.ContactID);

        If(req.DateString != NULL)
            xeroInvoiceMap.put('DateString', DateTime.newInstance(req.DateString.year(), req.DateString.month(), req.DateString.day()).format('yyyy-MM-dd\'T\'HH:mm:ss'));

        If(req.DueDateString != NULL)
            xeroInvoiceMap.put('DueDateString', DateTime.newInstance(req.DueDateString.year(), req.DueDateString.month(), req.DueDateString.day()).format('yyyy-MM-dd\'T\'HH:mm:ss'));

        If(req.Status != NULL && String.isNotBlank(req.Status))
            xeroInvoiceMap.put('Status', req.Status);

        If(req.Reference != NULL && String.isNotBlank(req.Reference))
            xeroInvoiceMap.put('Reference', req.Reference);

        If(req.InvoiceNumber != NULL && String.isNotBlank(req.InvoiceNumber))
            xeroInvoiceMap.put('InvoiceNumber', req.InvoiceNumber);

        If(req.LineAmountTypes != NULL && String.isNotBlank(req.LineAmountTypes))
            xeroInvoiceMap.put('LineAmountTypes', req.LineAmountTypes);

        If(req.Salesforce_Account_Id != NULL && String.isNotBlank(req.Salesforce_Account_Id))
            xeroInvoiceMap.put('Salesforce_Account_Id', req.Salesforce_Account_Id);

        If(req.Salesforce_Opportunity_Id != NULL && String.isNotBlank(req.Salesforce_Opportunity_Id))
            xeroInvoiceMap.put('Salesforce_Opportunity_Id', req.Salesforce_Opportunity_Id);

        xeroInvoiceMap.put('Contact', xeroInvoiceContactRefMap);

        // Assign values of Request to Xero Invoice Lines
        List<Object> lineItemList = new List<Object>();
        if(req.invoiceLines != null){
            for(SObject sobj : req.invoiceLines){
                Map<String, Object> xeroInvoiceLineMap = new Map<String, Object>(); 
                List<Object> xeroInvoiceLineTrackingMapList = new List<Object>(); 
                Map<String, Object> xeroInvoiceLineTrackingMap1 = new Map<String, Object>(); 
                Map<String, Object> xeroInvoiceLineTrackingMap2 = new Map<String, Object>(); 
                If(req.ItemCode != NULL && String.isNotBlank(req.ItemCode))
                    xeroInvoiceLineMap.put('ItemCode', sobj.get(req.ItemCode));

                If(req.Description != NULL && String.isNotBlank(req.Description))
                    xeroInvoiceLineMap.put('Description', sobj.get(req.Description));

                If(req.TaxType != NULL && String.isNotBlank(req.TaxType))
                    xeroInvoiceLineMap.put('TaxType', 'OUTPUT');

                If(req.AccountCode != NULL && String.isNotBlank(req.AccountCode))
                    xeroInvoiceLineMap.put('AccountCode', sobj.get(req.AccountCode));

                If(req.LineItemID != NULL && String.isNotBlank(req.LineItemID))
                    xeroInvoiceLineMap.put('LineItemID', sobj.get(req.LineItemID));

                If(req.UnitAmount != NULL)
                    xeroInvoiceLineMap.put('UnitAmount', sobj.get(req.UnitAmount));

                If(req.TaxAmount != NULL)
                    xeroInvoiceLineMap.put('TaxAmount', sobj.get(req.TaxAmount));

                If(req.LineAmount != NULL)
                    xeroInvoiceLineMap.put('LineAmount', sobj.get(req.LineAmount));

                If(req.Quantity != NULL)
                    xeroInvoiceLineMap.put('Quantity', sobj.get(req.Quantity));

                If(req.DiscountRate != NULL)
                    xeroInvoiceLineMap.put('DiscountRate', sobj.get(req.DiscountRate));

                If(req.TrackingCategoryID1 != NULL)
                    xeroInvoiceLineTrackingMap1.put('TrackingCategoryID', sobj.get(req.TrackingCategoryID1));

                If(req.TrackingCategoryName1 != NULL)
                    xeroInvoiceLineTrackingMap1.put('Name', sobj.get(req.TrackingCategoryName1));

                If(req.TrackingCategoryOption1 != NULL)
                    xeroInvoiceLineTrackingMap1.put('Option', sobj.get(req.TrackingCategoryOption1));

                If(req.TrackingCategoryID2 != NULL)
                    xeroInvoiceLineTrackingMap2.put('TrackingCategoryID', sobj.get(req.TrackingCategoryID2));

                If(req.TrackingCategoryName2 != NULL)
                    xeroInvoiceLineTrackingMap2.put('Name', sobj.get(req.TrackingCategoryName2));

                If(req.TrackingCategoryOption2 != NULL)
                    xeroInvoiceLineTrackingMap2.put('Option', sobj.get(req.TrackingCategoryOption2));

                xeroInvoiceLineTrackingMapList.add(xeroInvoiceLineTrackingMap1);
                xeroInvoiceLineTrackingMapList.add(xeroInvoiceLineTrackingMap2);
                xeroInvoiceLineMap.put('Tracking', xeroInvoiceLineTrackingMapList);
                lineItemList.add(xeroInvoiceLineMap);
            }
        }
        xeroInvoiceMap.put('LineItems',lineItemList);

        return xeroInvoiceMap;
    }
}