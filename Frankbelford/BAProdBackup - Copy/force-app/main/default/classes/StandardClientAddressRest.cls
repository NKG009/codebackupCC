//FR03 parameteres - /services/apexrest/StandardClientAddress/branchCode/1069
//test class name =Test_ClientAddress
@RestResource(urlMapping='/StandardClientAddress/branchCode/*')
global class StandardClientAddressRest
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
            List<sirenum__Site__c> siteData = [select 
                                               /*IP_Clientinvoicename__c,
                                               IP_InvoiceAddressStreet__c,
                                               IP_InvoiceAddressCity__c,
                                               IP_InvoiceAddressCounty__c,
                                               IP_InvoiceAddressPostcode__c,
                                               IP_InvoiceAddressCountry__c,*/  //Changed after invoice address issue 08/12/17 
                                               Name,
                                               sirenum__Street_Address__c,
                                               sirenum__City__c,
                                               sirenum__County__c,
                                               sirenum__Postal_Code__c,
                                               sirenum__Country__c,                                              
                                               IP_MainContact__r.Phone,
                                               IP_MainContact__r.Fax,
                                               IP_MainContact__r.Name,
                                               IP_ClientIDLegacy__c
                                               from sirenum__Site__c where 
                                                IP_TempestDepartment__c=:branchCode and IP_PassClientAddressToTempest__c=true LIMIT 40];
           for(sirenum__Site__c cnt: siteData)
                {                      
                    cnt.IP_PassClientAddressToTempest__c=false;
                    cnt.IP_ClientAddressLastPassedToTempest__c=system.now();
                    siteUpdate.add(cnt);                                             
                }       
          update siteUpdate;                        
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