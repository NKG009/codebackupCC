//field not found Sirenum_Hours__c
//FR14 /DateSetTimesheet/branchCode/*/date/*
@RestResource(UrlMapping='/DateSetTimesheet/branchCode/*/date/*')
global class DateSetTimesheetRest {
    
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
        List<sirenum__Timesheet_Line__c> tsUpdate = new List<sirenum__Timesheet_Line__c>();     
        
        
        try{  
            //Date dt = Date.valueOf(dates);  
            List<sirenum__Timesheet_Line__c > assData = [select Adhoc_Formula__c,
                                                         //sirenum__Code__c,
                                                         IP_PayrollPresentedRateCode__c, //-commented due to sirenum__Code__c on 17-8-2017 v7
                                                         IP_PurchaseOrderNumber__c,
                                                         Sirenum__Charge__c,
                                                         Sirenum__Shift__r.Sirenum__Site__r.IP_ClientIDLegacy__c,                                                 
                                                         Sirenum__Rate__c,
                                                         Sirenum__Shift__r.Sirenum__Placement__r.IP_Consultant2PercentageSplit__c,
                                                         Sirenum__Shift__r.sirenum__Site__r.IP_MainContact__r.Name,
                                                         /*Sirenum__Shift__r.Sirenum__Placement__r.Name,  commented on 14-9-2017 new field added */
                                                         sirenum__Shift__r.Sirenum__Placement__r.IP_AssignmentRefForTempest__c,
                                                         sirenum__Shift__r.sirenum__Placement__r.IP_Consultant1IDnumberSplitShare__c,
                                                         Sirenum__Shift__r.Sirenum__Placement__r.IP_Consultant1PercentageSplit__c,
                                                         sirenum__Shift__r.sirenum__Placement__r.IP_Consultant2IDnumberSplitShare__c,
                                                         sirenum__Shift__r.sirenum__Placement__r.IP_TempestDepartment__c,
                                                         //sirenum__Shift__r.sirenum__Placement__r.IP_PayMethod__r.IP_PayrollID__c,
                                                         sirenum__Shift__r.sirenum__Placement__r.IP_WorkerPayrollRef__c,
                                                         sirenum__Shift__r.sirenum__Placement__r.sirenum__End_Date__c,
                                                         sirenum__Shift__r.sirenum__Placement__r.sirenum__Start_Date__c,
                                                         sirenum__Shift__r.sirenum__Site__r.Name,
                                                         sirenum__Shift__r.sirenum__Team__r.Name,
                                                         IP_PresentedPayrollDateDateType__c,
                                                         //sirenum__Timesheet__r.IP_PresentedPayrollDateDateType__c,
                                                         sirenum__Timesheet__r.Timesheet_tempest_number__c,
                                                         sirenum__Hours__c,
                                                         sirenum__Shift__r.sirenum__Placement__r.IP_TempestDivision__c,
                                                         sirenum__Shift__r.sirenum__Placement__r.IP_AWRJobCat__c,
                                                         sirenum__Shift__r.sirenum__Placement__r.IP_AWRCoreCat__c
                                                         from sirenum__Timesheet_Line__c where IP_TempestDepartment__c=:branchCode and 
                                                         (IP_PassToTempest__c=true or IP_LastPassedToTempest__c >=: datetimes) and IP_RateCodes__c!='WT'];
            //(IP_PassToTempest__c=true or DAY_ONLY(convertTimezone(IP_LastPassedToTempest__c)) >=: dt)];
            for(sirenum__Timesheet_Line__c  cnt: assData)
            {                      
                cnt.IP_PassToTempest__c=false;
                cnt.IP_LastPassedToTempest__c=system.now();
                tsUpdate.add(cnt);                                               
            }
            Database.SaveResult[] srList = Database.update(tsUpdate, false);
            //update tsUpdate;                        
            return new ResponseClass('true', 'Query executed successfully.', assData);     
            
            
        } catch (Exception e) {
            return new ResponseClass('false', e.getMessage(), null);
        }  
    }
    
    global class ResponseClass 
    {
        
        global String success;
        global String message;
        global List<sirenum__Timesheet_Line__c> records;
        
        global ResponseClass(String success, String message, List<sirenum__Timesheet_Line__c> records) 
        {
            this.success = success;
            this.message = message;
            this.records = records;
        }
    }
}