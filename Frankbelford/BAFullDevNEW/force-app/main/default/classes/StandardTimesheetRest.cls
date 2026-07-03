//field not found Sirenum_Hours__c
//FR13 /StandardTimesheet/branchCode/*
@RestResource(UrlMapping='/StandardTimesheet/branchCode/*')
global class StandardTimesheetRest {
    
    @HttpGet
    global static ResponseClass doGet()
    {
        String[] uriKeys = RestContext.request.requestURI.split('/'); 
        String branchCode = uriKeys.get(uriKeys.size()-1);    
        
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');      
        List<sirenum__Timesheet_Line__c> tsUpdate = new List<sirenum__Timesheet_Line__c>();
        
        try{  
            
            List<sirenum__Timesheet_Line__c > tsData = [select Adhoc_Formula__c,
                                                        //sirenum__Code__c,commented after Martin's email on 27-9-2017
                                                        //IP_PayrollPresentedRateCode__c,- Comented after the EDI Change-IP_EdiRateCode is used instead
                                                        IP_EdiRateCode__c,
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
                                                        //  IP_TempestDepartment__c,
                                                        sirenum__Shift__r.sirenum__Placement__r.IP_TempestDepartment__c, 
                                                        //sirenum__Shift__r.sirenum__Placement__r.IP_PayMethod__r.IP_PayrollID__c,
                                                        sirenum__Shift__r.sirenum__Placement__r.IP_WorkerPayrollRef__c,
                                                        sirenum__Shift__r.sirenum__Placement__r.sirenum__End_Date__c,
                                                        sirenum__Shift__r.sirenum__Placement__r.sirenum__Start_Date__c,
                                                        sirenum__Shift__r.sirenum__Site__r.Name,
                                                        sirenum__Shift__r.sirenum__Team__r.Name,
                                                        IP_PresentedPayrollDateDateType__c,
                                                        //sirenum__Timesheet__r.IP_PresentedPayrollDateDateType__c,
                                                        // sirenum__Timesheet__r.Timesheet_tempest_number__c, (Chnage after Martin's approval for automate timesheet 27/11/2017)
                                                        // sirenum__Timesheet__r.IP_PayrollPresentedTimesheetNumber__c,
                                                        IP_PayrollPresentedTimesheetNumber__c,
                                                        sirenum__Hours__c,
                                                        //  IP_TempestDivision__c,
                                                        sirenum__Shift__r.sirenum__Placement__r.IP_TempestDivision__c, 
                                                        sirenum__Shift__r.sirenum__Placement__r.IP_AWRJobCat__c,
                                                        sirenum__Shift__r.sirenum__Placement__r.IP_AWRCoreCat__c
                                                        from sirenum__Timesheet_Line__c where IP_PassToTempest__c=true
                                                        and IP_TempestDepartment__c=:branchCode and IP_RateCodes__c!='WT' and 
                                                        sirenum__Timesheet__r.IP_DuplicateCheckPassOK__c=True and sirenum__Timesheet__r.sirenum__Week_Ending__c < Today and (IP_PayrollPresentedRateCode__c!='' OR IP_PayrollPresentedRateCode__c!=null) LIMIT 500];
            for(sirenum__Timesheet_Line__c  cnt: tsData)
            {                      
                cnt.IP_PassToTempest__c=false;
                cnt.IP_LastPassedToTempest__c=system.now();
                tsUpdate.add(cnt);                                               
            }       
            Database.SaveResult[] srList = Database.update(tsUpdate, false);
            //update tsUpdate;                        
            return new ResponseClass('true', 'Query executed successfully.', tsData);     
            
            
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