//FR10 /services/apexrest/DateSetAssignment/branchCode/1069/date/2017-05-21T00d00d00 */
@RestResource(UrlMapping='/DateSetAssignment/branchCode/*/date/*')
global class DateSetAssignmentRest {
    
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
        
        List<sirenum__Placement__c > assignmentUpdate = New List<sirenum__Placement__c >();
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');      

            
      try{  
            //Date dt = Date.valueOf(dates);  
            List<sirenum__Placement__c > assData = [select IP_AssignmentRefForTempest__c,
                                                    IP_AWRCoreCat__c,
                                                    IP_AWRJobCat__c,
                                                    IP_ClientIDLegacy__c,
                                                    IP_Consultant1IDnumberSplitShare__c,
                                                    IP_Consultant1PercentageSplit__c,
                                                    IP_Consultant2IDnumberSplitShare__c,
                                                    IP_Consultant2PercentageSplit__c,
                                                    IP_TempestDepartment__c, //17-8-2017 v7 added 
                                                    IP_TempestDivision__c, //  17-8-2017 v7 commented 
                                                    IP_LookUpOfHolidayEntitlement__c,
                                                    IP_WorkerPayrollRef__c,
                                                    IP_PurchaseOrderNumber__c,
                                                    sirenum__End_Date__c,
                                                    Sirenum__Job_Role__r.Name,
                                                    Sirenum__Site__r.Name,
                                                    Sirenum__Site__r.IP_InvoiceContact__r.Name,
                                                    Sirenum__Site__r.IP_MainContact__r.Name,
                                                    sirenum__Site__r.sirenum__Postal_Code__c,
                                                    sirenum__Start_Date__c,
                                                    OPWIPS__c,
                                                    IP_Department__c
                                                     from sirenum__Placement__c where IP_Department__c=:branchCode and                                                     
                                                    (IP_PassToTempest__c=true or IP_LastPassedToTempest__c >=: datetimes)];
                                                    //(IP_PassToTempest__c=true or DAY_ONLY(convertTimezone(IP_LastPassedToTempest__c)) >=: dt)];
           for(sirenum__Placement__c  cnt: assData)
                {                      
                    cnt.IP_PassToTempest__c=false;
                     cnt.IP_LastPassedToTempest__c=system.now();
                    assignmentUpdate.add(cnt);                                               
                }   
          Database.SaveResult[] srList = Database.update(assignmentUpdate, false);
           //update assignmentUpdate;                        
           return new ResponseClass('true', 'Query executed successfully.', assData);     
        } catch (Exception e) {
            return new ResponseClass('false', e.getMessage(), null);
        }  
    }
    
    global class ResponseClass 
    {

        global String success;
        global String message;
        global List<sirenum__Placement__c> records;

        global ResponseClass(String success, String message, List<sirenum__Placement__c> records) 
        {
            
            this.success = success;
            this.message = message;
            this.records = records;
        }
    }
}