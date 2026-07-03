//FR05,6,7,8 on hold parameteres - /services/apexrest/StandardInternalWorker/branchCode/1069
@RestResource(urlMapping='/StandardInternalWorker/branchCode/*')
global class StandardInternalWorkerRest 
{
    @HttpGet
    global static ResponseClass doGet()
    {
        Set<String> ids = new Set<String>();   
        String[] uriKeys = RestContext.request.requestURI.split('/');          
        String branchCode = uriKeys.get(uriKeys.size()-1);    
        List<IP_PayProfile__c> ppUpdate = New List<IP_PayProfile__c>();
        List<IP_PayProfile__c> ppsend = New List<IP_PayProfile__c>();
        String qCondition1;
        String qCondition2;
        
        try{  
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
                                             IP_Candidate__r.Suppression_Code__c, //p45
                                             IP_Candidate__c,
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
                                             IP_StudentLoan__c,
                                             IP_LastPassedToTempest__c
                                             from IP_PayProfile__c 
                                             where IP_Candidate__r.IP_TempestDepartment__c=:branchCode and 
                                             IP_Candidate__r.RecordType.DeveloperName ='Candidate' and 
                                             IP_PassToTempest__c=true LIMIT 10];
            for(IP_PayProfile__c cnt: ppData){                  
                ids.add(cnt.IP_Candidate__c);                
            }             
            List<sirenum__Timesheet_Line__c> tsLine = [select ContactID__c from sirenum__Timesheet_Line__c where ContactID__c in:ids and IP_PassToTempest__c=true and sirenum__Timesheet__r.sirenum__Week_Ending__c < Today];
            Map<string, sirenum__Timesheet_Line__c> accMap = new Map<string, sirenum__Timesheet_Line__c>();
            for(sirenum__Timesheet_Line__c acc :tsLine){
                accMap.put(acc.ContactID__c,acc);
            }
            
            for(IP_PayProfile__c cnt: ppData){
                if(cnt.IP_LastPassedToTempest__c==null)
                {                    
                    if(accMap.get(cnt.IP_Candidate__c)!=null)
                    {                                        
                        if(cnt.IP_Candidate__c == accMap.get(cnt.IP_Candidate__c).ContactID__c)
                        {
                            ppsend.add(cnt);    
                            System.debug('last pass to tempest null-->'+ppsend);
                        }
                    }
                }else{
                    ppsend.add(cnt); 
                    System.debug('last pass to tempest not null-->'+ppsend); 
                }
                
            }
            system.debug('latest record set ---->'+ppsend);
            
            
            
            
            
            for(IP_PayProfile__c cnt: ppsend)
            {   
                if(cnt.RecordType.Name == 'PAYE' && cnt.IP_Status__c == 'Active' && cnt.IP_Candidate__r.P45_Requested__c  && cnt.IP_Candidate__r.PayrollLeaver__c ==null)
                {
                    cnt.IP_Candidate__r.PayrollLeaver__c = 'PL';
                }
                cnt.IP_PassToTempest__c=false;
                cnt.IP_LastPassedToTempest__c=system.now();
                ppUpdate.add(cnt);                                             
            }       
            Database.SaveResult[] srList = Database.update(ppUpdate, false);                      
            return new ResponseClass('true', 'Query executed successfully.', ppsend);           
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