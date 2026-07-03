// Start Apex Test Class
@isTest
private class CreateXeroInvoiceRunAsyncTest{
    @isTest
    static void BWCreateXeroInvoice(){
        Bread_Winner__Invoice__c invoice = new Bread_Winner__Invoice__c();
        insert invoice;
        CreateXeroInvoiceRunAsync.InvoiceWrapper invWrapperItem = new CreateXeroInvoiceRunAsync.InvoiceWrapper();
        invWrapperItem.SalesforceRecordId = invoice.Id;

        CreateXeroInvoiceRunAsync.InvoiceListWrapper invWrapper = new CreateXeroInvoiceRunAsync.InvoiceListWrapper();
        invWrapper.invoices = new List<CreateXeroInvoiceRunAsync.InvoiceWrapper>();
        invWrapper.invoices.add(invWrapperItem);
        CreateXeroInvoiceRunAsync.fakeInvoiceWrapper = invWrapper;

        List<CreateXeroInvoiceRunAsync.Requests> requestList = new List<CreateXeroInvoiceRunAsync.Requests>(); 
        CreateXeroInvoiceRunAsync.Requests req = new CreateXeroInvoiceRunAsync.Requests(); 
        req.xeroOrgId = '!KsqPL';
        req.ContactID = '950f2525-14a8-4871-8348-980d6b9c5757';
        req.DateString = Date.today();
        req.DueDateString = Date.today();
        req.Status = 'Test Status';
        req.Reference = 'Test Reference';
        req.LineAmountTypes = 'Test LineAmountTypes';
        req.Salesforce_Account_Id = 'Test Salesforce_Account_Id';
        req.Salesforce_Opportunity_Id = 'Test Salesforce_Opportunity_Id';
        req.ItemCode = 'Type';
        SObject fakeObject = new Order();
        fakeObject.put(req.ItemCode, 'val');
        req.invoiceLines = new List<SObject>();
        req.invoiceLines.add(fakeObject);
        requestList.add(req); 
        CreateXeroInvoiceRunAsync.CreateXeroInvoice(requestList);
    }
}