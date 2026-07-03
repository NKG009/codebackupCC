//FR05,6,7,8 on hold parameteres - /services/apexrest/StandardInternalWorker/branchCode/1069

@RestResource(urlMapping='/standard/v1/ready/timesheet/*')
global class Timesheetready
{
    @HttpGet
    global static ResponseClass doGet()
    {
        String[] uriKeys = RestContext.request.requestURI.split('/');          
        String branchCode = uriKeys.get(uriKeys.size()-1);                  
        List<AsyncApexJob> job = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name in ('TimesheetLineBatch','InternalWorkerBatch') and status!='Completed' and createddate = TODAY];
        if(job.size()>0)
        {   
            return new ResponseClass('false','Not Ready');
        }
         else
         {
            return new ResponseClass('true','Ready'); 
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