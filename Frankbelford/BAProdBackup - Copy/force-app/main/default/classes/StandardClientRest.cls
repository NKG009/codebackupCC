//FR01 parameters - /services/apexrest/StandardClient/branchCode/1069
//test class name - Test_ClientRestApi
@RestResource(urlMapping='/StandardClient/branchCode/*')
global class StandardClientRest 
{
     @HttpGet
    global static ResponseClass doGet()
    {
        String[] uriKeys = RestContext.request.requestURI.split('/');          
        String branchCode = uriKeys.get(uriKeys.size()-1);    
        
        List<sirenum__Site__c> siteUpdate = New List<sirenum__Site__c>();
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');  
         
      try{  
            List<sirenum__Site__c> siteData = [select IP_ClientIDLegacy__c, 
                                                IP_Clientinvoicename__c,
                                                IP_InvoiceAddressCity__c, 
                                                IP_InvoiceAddressCountry__c,
                                                IP_InvoiceAddressCounty__c, 
                                                IP_InvoiceAddressPostcode__c,
                                                IP_InvoiceAddressStreet__c,
                                                IP_InvoiceContact__r.Name, 
                                                IP_InvoiceContact__r.Email,
                                                IP_InvoiceContact__r.Fax, 
                                                IP_InvoiceContact__r.Mobilephone,
                                                IP_InvoiceContact__r.Phone, 
                                                IP_MainContact__r.Email,
                                                IP_MainContact__r.Mobilephone,
                                                IP_MainContact__r.Name, 
                                                IP_MainContact__r.Phone,
                                                IP_SalesLedgerNo__c,
                                                Name,
                                               IP_Department__c,
                                               IP_TempestDepartment__c,
                                                IP_TempestDivision__c,
                                                IP_PublicSector__c,
                                               IP_PaymentTerms__c,
                                               NetMonthlySettlementCode__c
                                                from sirenum__Site__c where IP_PassClientToTempest__c=True  
                                             and IP_TempestDepartment__c =:branchCode LIMIT 40];
           for(sirenum__Site__c cnt: siteData)
                {                      
                    cnt.IP_PassClientToTempest__c=false; 
                    cnt.IP_ClientLastPassedToTempest__c=system.now();
                    siteUpdate.add(cnt);                                             
                } 
          
           if(!Test.isRunningTest())
           { 
                //update siteUpdate;
                Database.SaveResult[] srList = Database.update(siteUpdate, false);
           }
          
           return new ResponseClass('true', 'Query executed successfully.', siteData);     
            
        
        } catch (Exception e) {
            return new ResponseClass('false', e.getMessage(), null);
        }  
    }
    
    global class ResponseClass 
    {

        global String success;
        global String message;
        global List<sirenum__Site__c> records;

        global ResponseClass(String success, String message, List<sirenum__Site__c> records) 
        {
            this.success = success;
            this.message = message;
            this.records = records;
        }
    }
}