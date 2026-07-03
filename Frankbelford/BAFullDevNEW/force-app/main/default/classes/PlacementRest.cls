// v8 //services/apexrest/StandardPlacement/branchCode/1069
@RestResource(UrlMapping='/standard/v1/collect/placement/*/*')
global class PlacementRest {
   
    @HttpGet
    global static ResponseClass doGet()
    {
        String[] uriKeys = RestContext.request.requestURI.split('/'); 
        String branchCode = uriKeys.get(uriKeys.size()-2);    
        String GUID= uriKeys.get(uriKeys.size()-1);  
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');      
        List<TR1__Closing_Report__c> tsUpdate = new List<TR1__Closing_Report__c>();
        String errorFile = 'Id,Error\n'; 
        Map<id,String> errMessage = new Map<id,String>();
          Impellam_Settings__c set1 = Impellam_Settings__c.getValues('PlacementRest'); 
        Integer limit1 = Integer.Valueof(set1.Limit__c);
        system.debug('Limit Value@@@'+set1);      
      try{  
            
     List<TR1__Closing_Report__c > tsData = [select 
                                                //Placement_ID__c,
                                                IP_TempestDivision__c,
                                                IP_TempestDepartment__c,
                                                //IP_PayrollID__c,
                                                IP_ClientIDLegacy__c,
                                                Candidate_First_Name__c,
                                                Candidate_Last_Name__c, 
                                                TR1__Start_Date__c,
                                                Sirenum_Job_Role__c,
                                                TR1__Salary__c,
                                                IP_Fixed_Fee__c,
                                                Fee_Pct__c,
                                                Contact_Name__c,
                                                Status_PO_Number__c, //IP_PurchaseOrderNumber__c commented after howard email 23-8-2017,
                                                Filled_By__r.IP_TempestID__c,
                                                Filled_Pct__c,
                                                Filled_By_2__r.IP_TempestID__c,
                                                Filled_Pct_2__c,
                                                IP_Department__c,
                                                IP_PermID__c,
                                                IP_Amount_to_Credit__c,
                                                IP_Credit_Indicator__c,
                                                IP_Reason_for_Credit_Code__c,
                                                IP_Reference_to_Tempest__c 
                                            from TR1__Closing_Report__c where IP_PassToTempest__c=true
                                             and IP_TempestDepartment__c=:branchCode and (RecordType.DeveloperName ='Perm'OR RecordType.Name = 'Perm Credits') and (GUID_Placement_js__c=null OR GUID_Placement_js__c!=:GUID) and (Site__r.IP_ClientAddressLastPassedToTempest__c!=null OR Site__r.IP_PassClientAddressToTempest__c = TRUE) and (Site__r.IP_ClientLastPassedToTempest__c!=null OR Site__r.IP_PassClientToTempest__c = TRUE) and (Filled_By__r.IP_LastPassedToTempest__c!=null OR Filled_By__r.IP_PassToTempest__c = TRUE) LIMIT :limit1];
                                            //and IP_TempestDepartment__c=:branchCode and RecordType.DeveloperName ='Perm' and (GUID_Placement_js__c=null OR GUID_Placement_js__c!=:GUID) LIMIT :limit1];
          for(TR1__Closing_Report__c  cnt: tsData)
                {                      
                    cnt.GUID_Placement_js__c = GUID;
                    tsUpdate.add(cnt);                                               
                }
              Database.SaveResult[] srList = Database.update(tsUpdate, false);
                 List<id> errorIds = new List<id>();
                 List<id> successIds = new List<id>();
                for (integer i=0; i<srList.size();i++) 
                {
                     String errMsgs = '';
                    if(srList[i].isSuccess())
                    {
                        successIds.add(tsUpdate[i].id);
                    }
                    else
                    {
                        errorIds.add(tsUpdate[i].id);
                        for(Database.Error err : srList[i].getErrors())
                        {
                            errMsgs = errMsgs + '  ' + err.getMessage();       
                        }
                         errMessage.put(tsUpdate[i].Id,errMsgs);
                         errMsgs ='';   
                    }
                }
            if(errorIds.isEmpty())
           return new ResponseClass('true', 'Query executed successfully.',tsData);     
            else
            {
            for(integer i=0;i<errorIds.size();i++)
                {
                    errorFile = errorFile + errorIds[i]+','+ errMessage.get(errorIds[i]) + ',' +'\n';
                 }
            Messaging.EmailFileAttachment errAtt = new Messaging.EmailFileAttachment();    
            blob errBlob = blob.valueof(errorFile);    
            errAtt.setFileName('Failed_Records.csv');
            errAtt.setBody(errBlob);
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage(); 
          /*  List<String>  toAddresses = new List<String>();
            List<User> userList = new List<User>();
            userList = [SELECT Id,Email,IsActive FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = True] ; 
            for (User u : userList)
            {
            toAddresses.add(u.email);
            } */
            String subject ='API Collect Failure - Placement';
            email.setSubject(subject);
            String[] toAddress = new String[] {'ritu.hetawal@espire.com'};
            email.setToAddresses(toAddress);
            email.setPlainTextBody('Hello,\n\nPlease find attached the list of failed records.');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{errAtt});
        
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
           return new ResponseClass('false', 'Error in querying records',null);     
            }
        
        } catch (Exception e) {
            return new ResponseClass('false', e.getMessage(), null);
        }  
    }
    
    global class ResponseClass 
    {

        global String success;
        global String message;
        global List<TR1__Closing_Report__c> records;

        global ResponseClass(String success, String message,List<TR1__Closing_Report__c> records) 
        {
            this.success = success;
            this.message = message;
            this.records = records;

        }
    }
}