/* /services/apexrest/StandardAssignment/branchCode/1069 /date/2017-05-21T00d00d00/*/
@RestResource(urlMapping='/StandardAssignment/branchCode/*')
global class StandardAssignmentRest {
    
    @HttpGet
    global static ResponseClass doGet()
    {
        
        String[] uriKeys = RestContext.request.requestURI.split('/'); 
        String branchCode = uriKeys.get(uriKeys.size()-1);  
        Set<id> sfid = new Set<id>();
        Set<id> ppid = new Set<id>();
        
        List<sirenum__Placement__c > assignmentUpdate = New List<sirenum__Placement__c >();
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');      
       // Date dt = System.Today()-8;
        List<sirenum__Timesheet_Line__c> ids = [select id, name, sirenum__shift__c, IP_PassToTempest__c from sirenum__Timesheet_Line__c where IP_PassToTempest__c = true and sirenum__shift__c!='' and sirenum__Timesheet__r.sirenum__Week_Ending__c < Today];
        System.debug('timesheet line----'+ ids);
        for(sirenum__Timesheet_Line__c tl:ids){
            sfid.add(tl.sirenum__shift__c);
        }
        List<sirenum__shift__c> sf =[select id,name, sirenum__Placement__c from sirenum__shift__c where id in : sfid] ;
        System.debug('shift----'+ sf);
        for(sirenum__shift__c sc: sf){
            ppid.add(sc.sirenum__Placement__c) ;
        }   
        try{  
            
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
                                                 //   Adhoc_Formula__c,//added 28-9-2017 after martin's email
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
                                                    from sirenum__Placement__c where IP_PassToTempest__c=true 
                                                    and IP_Department__c=:branchCode and id in: ppid];
            System.debug('PlacementData&&&&'+assData);
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