// /services/apexrest/StandardExternalWorker/branchCode/1069
@RestResource(urlMapping='/standard/v1/collect/externalworker/*/*')
global class ExternalWorkerRest 
{
    @HttpGet
    global static ResponseClass doGet()
    {
        String[] uriKeys = RestContext.request.requestURI.split('/');          
        String branchCode = uriKeys.get(uriKeys.size()-2);
        String GUID= uriKeys.get(uriKeys.size()-1);     
        List<Contact> conUpdate = New List<Contact>();
        String errorFile = 'Id,Error\n'; 
        Map<id,String> errMessage = new Map<id,String>();
           Impellam_Settings__c set1 = Impellam_Settings__c.getValues('ExternalWorkerRest'); 
        Integer limit1 = Integer.Valueof(set1.Limit__c);
        system.debug('Limit Value@@@'+set1);     
        
        try{  
            List<Contact> ppData = [select Account.IP_SupplierReference__c,
                                    Birthdate,
                                    IP_ConsultantsTempestID__c,
                                    Email,
                                    FirstName,
                                    LastName,
                                    IP_MailingAddressLine1__c,
                                    IP_MailingAddressLine2__c,
                                    IP_MailingAddressLine3__c,
                                    IP_TempestDepartment__c,
                                    IP_TempestDivision__c,
                                    IP_CandidateIDlegacy__c,
                                    IP_WorkerStartDate__c,
                                    WTR_Completed__c,  
                                    MailingCity, 
                                    MailingCountry,
                                    MailingState,
                                    MailingPostalCode,
                                    Phone,
                                    Salutation,
                                    Sirenum__National_Insurance__c,
                                    IP_PayFrequency__c,
                                    IP_Department__c // added in v7 : 17-8-2017
                                    from Contact where 
                                    IP_Pass2ndTierToTempest__c=true and IP_TempestDepartment__c=:branchCode
                                    and RecordType.DeveloperName ='IP_2ndTierCandidate' and (GUID__c=null or GUID__c!=:GUID) LIMIT :limit1];
            for(Contact cnt: ppData)
            {                      
                cnt.GUID__c = GUID;
                conUpdate.add(cnt);                                             
            }      
            Database.SaveResult[] srList = Database.update(conUpdate, false);
               List<id> errorIds = new List<id>();
                 List<id> successIds = new List<id>();
                for (integer i=0; i<srList.size();i++) 
                {
                     String errMsgs = '';
                    if(srList[i].isSuccess())
                    {
                        successIds.add(conUpdate[i].id);
                    }
                    else
                    {
                        errorIds.add(conUpdate[i].id);
                        for(Database.Error err : srList[i].getErrors())
                        {
                            errMsgs = errMsgs + '  ' + err.getMessage();       
                        }
                         errMessage.put(conUpdate[i].Id,errMsgs);
                         errMsgs ='';   
                    }
                }
            if(errorIds.isEmpty())
           return new ResponseClass('true', 'Query executed successfully.',ppData);     
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
            String subject ='API Collect Failure - External Worker';
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
        global List<Contact> records;
        
        global ResponseClass(String success, String message, List<Contact> records) 
        {
            this.success = success;
            this.message = message;
            this.records = records;
        }
    }
}