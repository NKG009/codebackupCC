/* /services/apexrest/StandardAssignment/branchCode/1069 */
@RestResource(urlMapping='/standard/v1/collect/assignment/*/*')
global class AssignmentRest {
    
    @HttpGet
    global static ResponseClass doGet()
    {
        String[] uriKeys = RestContext.request.requestURI.split('/'); 
        String branchCode = uriKeys.get(uriKeys.size()-2);    
        String GUID = uriKeys.get(uriKeys.size()-1);
        List<sirenum__Placement__c > assignmentUpdate = New List<sirenum__Placement__c >();
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');      
       // Date dt = System.today()-8;
            String errorFile = 'Id,Error\n'; 
               Map<id,String> errMessage = new Map<id,String>();   
          Set<id> sfid = new Set<id>();
        Set<id> ppid = new Set<id>(); 
         Impellam_Settings__c set1 = Impellam_Settings__c.getValues('AssignmentRest'); 
        Integer limit1 = Integer.Valueof(set1.Limit__c);
        system.debug('Limit Value@@@'+set1);       
        List<sirenum__Timesheet_Line__c> ids = [select id, name, sirenum__shift__c, IP_PassToTempest__c from sirenum__Timesheet_Line__c where IP_TempestDepartment__c =:branchCode and IP_PassToTempest__c = true and sirenum__shift__c!='' and sirenum__Timesheet__r.sirenum__Week_Ending__c < Today];
        System.debug('timesheet line----'+ ids);
        for(sirenum__Timesheet_Line__c tl:ids){
            sfid.add(tl.sirenum__shift__c);
        }
        List<sirenum__shift__c> sf =[select id,name, sirenum__Placement__c from sirenum__shift__c where id in : sfid] ;
        System.debug('shift----'+ sf);
        for(sirenum__shift__c sc: sf){
            ppid.add(sc.sirenum__Placement__c) ;
            system.debug('check placementrecord'+ppid);
        }   
            
      try{  
            
            List<sirenum__Placement__c > assgData = [select IP_AssignmentRefForTempest__c,
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
                                                    Adhoc_Formula__c,//added 28-9-2017 after martin's email
                                                    IP_WorkerPayrollRef__c,
                                                    IP_PurchaseOrderNumber__c,
                                                    sirenum__End_Date__c,
                                                   // Sirenum__Job_Role__r.Name,
                                                   Sirenum__Job_Role__r.sirenum__Job_Type__r.Name,//After Defect 7489
                                                    Sirenum__Site__r.Name,
                                                    Sirenum__Site__r.IP_InvoiceContact__r.Name,
                                                    Sirenum__Site__r.IP_MainContact__r.Name,
                                                    sirenum__Site__r.sirenum__Postal_Code__c,
                                                    sirenum__Start_Date__c,
                                                     OPWIPS__c,
                                                    IP_Department__c
                                                   from sirenum__Placement__c where IP_PassToTempest__c=true
                                                   and IP_Department__c=:branchCode and (GUID_placement__c=null OR  GUID_placement__c!=:GUID) and id in: ppid LIMIT :limit1];
           for(sirenum__Placement__c  cnt: assgData)
                {  
                    cnt.GUID_placement__c = GUID;                   
                   // cnt.IP_PassToTempest__c=false;
                    //cnt.IP_LastPassedToTempest__c=system.now();
                    assignmentUpdate.add(cnt);                                               
                }       
          Database.SaveResult[] srList = Database.update(assignmentUpdate, false);
          List<id> errorIds = new List<id>();
                 List<id> successIds = new List<id>();
                for (integer i=0; i<srList.size();i++) 
                {
                     String errMsgs = '';
                    if(srList[i].isSuccess())
                    {
                        successIds.add(assignmentUpdate[i].id);
                    }
                    else
                    {
                        errorIds.add(assignmentUpdate[i].id);
                        for(Database.Error err : srList[i].getErrors())
                        {
                            errMsgs = errMsgs + '  ' + err.getMessage();       
                        }
                         errMessage.put(assignmentUpdate[i].Id,errMsgs);
                         errMsgs ='';   
                    }
                }
            if(errorIds.isEmpty())
           return new ResponseClass('true', 'Query executed successfully.',assgData);     
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
            String subject ='API Collect Failure - SPlacement';
            email.setSubject(subject);
            String[] toAddress = new String[] {System.Label.BASupportEmail};
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
        global List<sirenum__Placement__c> records;

        global ResponseClass(String success, String message, List<sirenum__Placement__c> records) 
        {
            this.success = success;
            this.message = message;
            this.records = records;
        }
    }
}