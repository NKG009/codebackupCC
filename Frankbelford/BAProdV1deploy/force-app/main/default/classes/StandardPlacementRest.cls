// v8 //services/apexrest/StandardPlacement/branchCode/1069
@RestResource(UrlMapping='/StandardPlacement/branchCode/*')
global class StandardPlacementRest {
   
    @HttpGet
    global static ResponseClass doGet()
    {
        String[] uriKeys = RestContext.request.requestURI.split('/'); 
        String branchCode = uriKeys.get(uriKeys.size()-1);    
       
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');      
        List<ts2__Placement__c> tsUpdate = new List<ts2__Placement__c>();
            
      try{  
            
     List<ts2__Placement__c > tsData = [select Placement_ID__c,
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
                                                from ts2__Placement__c where IP_PassToTempest__c=true
                                                and IP_TempestDepartment__c=:branchCode and RecordType.DeveloperName ='Perm'];
            
          for(ts2__Placement__c  cnt: tsData)
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
        global List<ts2__Placement__c> records;

        global ResponseClass(String success, String message, List<ts2__Placement__c> records) 
        {
            this.success = success;
            this.message = message;
            this.records = records;
        }
    }
}