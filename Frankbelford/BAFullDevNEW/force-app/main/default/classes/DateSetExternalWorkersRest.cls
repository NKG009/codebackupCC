// /services/apexrest/DateSetExternalWorkers/branchCode/1069
@RestResource(urlMapping='/DateSetExternalWorkers/branchCode/*')
global class DateSetExternalWorkersRest 
{ 
    @HttpGet
    global static ResponseClass doGet()
    {
        String[] uriKeys = RestContext.request.requestURI.split('/'); 
        String dates = uriKeys.get(uriKeys.size()-1); 
        String branchCode = uriKeys.get(uriKeys.size()-3);            
        List<Contact> conUpdate = New List<Contact>();
        
        /* date function */  
        Pattern dToTime = Pattern.compile('[d]');  
        dates = dToTime.matcher(dates).replaceAll(':'); 
        Pattern TToSpace = Pattern.compile('[T]');  
        dates = TToSpace.matcher(dates).replaceAll(' '); 
        Datetime datetimes = Datetime.valueOf(dates); 
        /* date function */  
        
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');     
        
        try{  
            //Date dt = Date.valueOf(dates);
            List<Contact> ppData = [select Account.IP_SupplierReference__c,
                                    Birthdate,
                                    IP_ConsultantsTempestID__c,
                                    Email,
                                    FirstName,
                                    LastName,
                                    IP_MailingAddressLine1__c,
                                    IP_MailingAddressLine2__c,
                                    IP_MailingAddressLine3__c,
                                    IP_TempestDepartment__c,
                                    IP_TempestDivision__c,
                                    IP_CandidateIDlegacy__c,
                                    IP_WorkerStartDate__c,
                                    WTR_Completed__c,  
                                    MailingCity, 
                                    MailingCountry,
                                    MailingState,
                                    MailingPostalCode,
                                    Phone,
                                    Salutation,
                                    Sirenum__National_Insurance__c,
                                    IP_PayFrequency__c,
                                    IP_Department__c // added in v7 : 17-8-2017
                                    from Contact where IP_TempestDepartment__c=:branchCode and 
                                    (IP_Pass2ndTierToTempest__c=true or IP_LastPassedToTempest2ndTier__c >=: datetimes)
                                    and RecordType.DeveloperName ='IP_2ndTierCandidate'];
            //(IP_Pass2ndTierToTempest__c=true or DAY_ONLY(convertTimezone(IP_LastPassedToTempest2ndTier__c)) >=: dt)];
            for(Contact cnt: ppData)
            {                      
                cnt.IP_Pass2ndTierToTempest__c=false;
                cnt.IP_LastPassedToTempest2ndTier__c=system.now();
                conUpdate.add(cnt);                                             
            }      
            Database.SaveResult[] srList = Database.update(conUpdate, false);
            //update conUpdate;                        
            return new ResponseClass('true', 'Query executed successfully.', ppData);           
        } catch (Exception e) {
            return new ResponseClass('false', e.getMessage(), null);
        }  
    }
    
    global class ResponseClass 
    {
        
        global String success;
        global String message;
        global List<Contact> records;
        
        global ResponseClass(String success, String message, List<Contact> records) 
        {
            this.success = success;
            this.message = message;
            this.records = records;
        }
    }
}