@RestResource(urlMapping='/standard/v1/close/timesheet/*/*')

global class TimesheetClose

{
    @HttpPost
    
      global static ResponseClass doPost()
        {
            String[] uriKeys = RestContext.request.requestURI.split('/'); 
            String GUID = uriKeys.get(uriKeys.size()-1);
            String Query = 'Select id,sirenum__Overtime_Rate__c,sirenum__Shift__r.sirenum__Placement__r.IP_WorkerPayrollRef__c,sirenum__Shift__r.sirenum__Placement__r.IP_AssignmentRef__c,IP_PassToTempest__c,IP_RateCodes__c,sirenum__Rate_Line__r.sirenum__Standard_Rate_Name__c,sirenum__Shift__r.sirenum__Placement__r.Name,sirenum__Timesheet__r.sirenum__Site__r.IP_Timesheet_Method__c,IP_LastPassedToTempest__c,IP_PayrollPresentedTimesheetNumber__c,Name,sirenum__Timesheet__r.sirenum__Lines__c,sirenum__Timesheet__r.sirenum__Worker__r.name,sirenum__Timesheet__r.sirenum__Worker__c,sirenum__Timesheet__r.sirenum__Client__r.Name,sirenum__Timesheet__r.sirenum__Site__r.Name,sirenum__Timesheet__r.sirenum__Week_Ending__c,IP_PurchaseOrderNumber__c,sirenum__Date__c,IP_EdiRateCode__c,sirenum__Hours__c,sirenum__Shift__r.Approved_By__r.Name,sirenum__Shift__r.Approved_Date_Time__c from sirenum__Timesheet_Line__c where IP_PassToTempest__c = TRUE and GUID_Timesheetline__c=:GUID';
            String Field1 = 'IP_PassToTempest__c';
            String Field2 = 'IP_LastPassedToTempest__c';
           

            
             Impellam_Settings__c set1 = Impellam_Settings__c.getValues('TimesheetClose'); 
             Integer limit1 = Integer.Valueof(set1.Limit__c);
            try
            {
            Database.executeBatch(new TimesheetLineBatch(Query,Field1,Field2,GUID),limit1);            
            return new ResponseClass('true','Batch Process initiated');
            }
            catch(DMLException e){return new ResponseClass('false', e.getMessage());
            }
         }   
         
        
     global class ResponseClass 
    {        
        global String success;
        global String message;        
       
        global ResponseClass(String success, String message) 
        {
            this.success = success;
            this.message = message;
        }
    }
}