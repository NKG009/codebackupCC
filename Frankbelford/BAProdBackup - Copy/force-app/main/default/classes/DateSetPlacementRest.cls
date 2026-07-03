//FR /DateSetAssignment/branchCode/*/date/*
@RestResource(UrlMapping='/DateSetPlacement/branchCode/*/date/*')
global class DateSetPlacementRest {
    
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
        
        List<ts2__Placement__c > assignmentUpdate = New List<ts2__Placement__c >();
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');      

            
      try{  
            //Date dt = Date.valueOf(dates);  
            List<ts2__Placement__c > assData = [select Placement_ID__c,
                                                IP_TempestDivision__c,
                                                IP_TempestDepartment__c,
                                                //IP_PayrollID__c,
                                                IP_ClientIDLegacy__c,
                                                Candidate_First_Name__c,
                                                Candidate_Last_Name__c, 
                                                ts2__Start_Date__c,
                                                Sirenum_Job_Role__c,
                                                ts2__Salary__c,
                                                IP_Fixed_Fee__c,
                                                ts2__Fee_Pct__c,
                                                Contact_Name__c,
                                                Status_PO_Number__c, //IP_PurchaseOrderNumber__c commented after howard email 23-8-2017,
                                                ts2__Filled_By__r.IP_TempestID__c,
                                                ts2__Filled_Pct__c,
                                                ts2__Filled_By_2__r.IP_TempestID__c,
                                                ts2__Filled_Pct_2__c,
                                                IP_Department__c,
                                                IP_PermID__c
                                        from ts2__Placement__c where IP_TempestDepartment__c=:branchCode and                                                     
                                                    (IP_PassToTempest__c=true or IP_LastPassedToTempest__c >=: datetimes)];
                                                    //(IP_PassToTempest__c=true or DAY_ONLY(convertTimezone(IP_LastPassedToTempest__c)) >=: dt)];
                                                    
               for(ts2__Placement__c  cnt: assData)
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
        global List<ts2__Placement__c> records;

        global ResponseClass(String success, String message, List<ts2__Placement__c> records) 
        {
            this.success = success;
            this.message = message;
            this.records = records;
        }
    }
}