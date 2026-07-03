//FR05,6,7,8 on hold parameteres - /services/apexrest/StandardClient/branchCode/1069
@RestResource(urlMapping='/DateSetInternalWorkers/branchCode/*/date/*')
global class DateSetInternalWorkersRest 
{
    @HttpGet
    global static ResponseClass doGet()
    {
        String[] uriKeys = RestContext.request.requestURI.split('/'); 
        String dates = uriKeys.get(uriKeys.size()-1); 
        String branchCode = uriKeys.get(uriKeys.size()-3);   
        
        /* date function */  
        Pattern dToTime = Pattern.compile('[d]');  
        dates = dToTime.matcher(dates).replaceAll(':'); 
        Pattern TToSpace = Pattern.compile('[T]');  
        dates = TToSpace.matcher(dates).replaceAll(' '); 
        Datetime datetimes = Datetime.valueOf(dates); 
        /* date function */  
        
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');      
        List<IP_PayProfile__c> ppUpdate = New List<IP_PayProfile__c>();
        
        try{  
            Date dt = Date.valueOf(dates);  
            List<IP_PayProfile__c> ppData = [select IP_BankAccountName__c,
                                             IP_AccountNumber__c,
                                             IP_BuildingSocietyNumber__c,
                                             IP_BusinessAddressCounty__c,
                                             IP_BusinessAddressLine1__c,
                                             IP_BusinessAddressLine2__c,
                                             IP_BusinessAddressPostcode__c,
                                             IP_BusinessAddressTown__c,
                                             IP_Candidate__r.Birthdate,
                                             IP_Candidate__r.IP_ConsultantsTempestID__c,
                                             IP_Candidate__r.Email,
                                             IP_Candidate__r.Firstname,
                                             IP_Candidate__r.IP_MailingAddressLine1__c,
                                             IP_Candidate__r.IP_MailingAddressLine2__c,
                                             IP_Candidate__r.IP_MailingAddressLine3__c,
                                             //IP_Candidate__r.IP_NewStartTaxStatus__c, modified at 22-8-17, Incidant-5764
                                             IP_NewStarterTaxStatus__c,
                                             IP_Candidate__r.IP_TempestDepartment__c,
                                             IP_Candidate__r.IP_TempestDivision__c,
                                             IP_Candidate__r.IP_WorkerStartDate__c,
                                             IP_Candidate__r.IP_WorkerLeavingDate__c,
                                             IP_Candidate__r.Lastname,
                                             IP_Candidate__r.MailingCity,
                                             IP_Candidate__r.MailingCountry,
                                             IP_Candidate__r.MailingState,
                                             IP_Candidate__r.MailingPostalCode,
                                             IP_Candidate__r.Phone,
                                             IP_Candidate__r.IP_PresentedP45ReasonCode__c, // added doc v9 29-8-2017
                                             IP_Candidate__r.Reason_for_P45__c,
                                             IP_Candidate__r.Salutation,
                                             IP_Candidate__r.ts2__EEO_Gender__c,
                                             IP_Candidate__r.Sirenum__National_Insurance__c,
                                             IP_Candidate__r.Student__c,
                                             IP_Candidate__r.TS2__Preferred_Name__c,
                                             IP_Candidate__r.WTR_Completed__c,   
                                             IP_CompanyName__c,
                                             IP_CompanyRegNo__c,
                                             IP_EmailPayslip__c,
                                             IP_PaymentType__c,
                                             IP_PayrollID__c,
                                             IP_SortCode__c,
                                             IP_VATNumber__c,
                                             RecordType.Name, 
                                             IP_PayFrequency__c,
                                             IP_Candidate__r.IP_Department__c, //added at 17-8-2017 doc v7
                                             IP_Status__c,  //p45
                                             IP_Candidate__r.PayrollLeaver__c,  //p45
                                             IP_Candidate__r.P45_Requested__c,  //p45
                                             IP_SupplierReference__c,
                                             IP_StudentLoan__c
                                             from IP_PayProfile__c where IP_Candidate__r.IP_TempestDepartment__c=:branchCode
                                             and (IP_PassToTempest__c=true or IP_LastPassedToTempest__c >=: datetimes)
                                             and IP_Candidate__r.RecordType.DeveloperName ='Candidate'];
            //(IP_PassToTempest__c=true or DAY_ONLY(convertTimezone(IP_LastPassedToTempest__c)) >=: dt)];
            for(IP_PayProfile__c cnt: ppData)
            {                 
                if(cnt.RecordType.Name == 'PAYE' && cnt.IP_Status__c == 'Active' && cnt.IP_Candidate__r.P45_Requested__c && cnt.IP_Candidate__r.PayrollLeaver__c ==null)
                    cnt.IP_Candidate__r.PayrollLeaver__c = 'PL';
                cnt.IP_PassToTempest__c=false;
                cnt.IP_LastPassedToTempest__c=system.now();
                ppUpdate.add(cnt);                                             
            }       
            Database.SaveResult[] srList = Database.update(ppUpdate, false);                   
            return new ResponseClass('true', 'Query executed successfully.', ppData);           
        } catch (Exception e) {
            return new ResponseClass('false', e.getMessage(), null);
        }  
    }
    
    global class ResponseClass 
    {
        
        global String success;
        global String message;
        global List<IP_PayProfile__c> records;
        
        global ResponseClass(String success, String message, List<IP_PayProfile__c> records) 
        {
            this.success = success;
            this.message = message;
            this.records = records;
        }
    }
}