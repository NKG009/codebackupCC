//FR02 parameteres - /services/apexrest/DateSetClient/branchCode/1069/date/2017-04-26T00d00d00
//test class name - Test_ClientRestApi
@RestResource(urlMapping='/DateSetClient/branchCode/*/date/*')
global class DateSetClientRest {
    @HttpGet
    global static ResponseClass doGet()
    {
        String[] uriKeys = RestContext.request.requestURI.split('/'); 
        String dates = uriKeys.get(uriKeys.size()-1);
        String branchCode = uriKeys.get(uriKeys.size()-3); 
        String dserialized;
        
        Pattern dToTime = Pattern.compile('[d]');  //SS added
        dates = dToTime.matcher(dates).replaceAll(':'); //SS added
        
        Pattern TToSpace = Pattern.compile('[T]');  //SS added
        dates = TToSpace.matcher(dates).replaceAll(' '); //SS added
        
        Datetime datetimes = Datetime.valueOf(dates); //SS added
        
        List<sirenum__Site__c> siteUpdate = New List<sirenum__Site__c>();
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        
        //try{  
            //Date dt = Date.valueOf(dates);  
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
                                               IP_PaymentTerms__c
                                               from sirenum__Site__c where 
                                               (not IP_ClientIDLegacy__c = null) and
                                               IP_TempestDepartment__c=:branchCode and 
                                               (IP_PassClientToTempest__c=true OR IP_ClientLastPassedToTempest__c >=: datetimes)]; //SS added
            //(IP_PassClientToTempest__c=true OR DAY_ONLY(convertTimezone(IP_ClientLastPassedToTempest__c)) >=: dt)];
            for(sirenum__Site__c cnt: siteData)
            {                      
                cnt.IP_PassClientToTempest__c=false;
                cnt.IP_ClientLastPassedToTempest__c=system.now();
                siteUpdate.add(cnt);                                             
            }
            
            //if(!Test.isRunningTest())
            //{
                //update siteUpdate;
                Database.SaveResult[] srList = Database.update(siteUpdate, false);
            //}
            
            return new ResponseClass('true', 'Query executed successfully.', siteData);                 
            
        //} catch (Exception e) {
        //    return new ResponseClass('false', e.getMessage(), null);
        //}  
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