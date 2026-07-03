//FR15 /StandardConsultant/branchCode/*
@RestResource(UrlMapping='/emergency/v1/collect/consultant/*/*')
global class ConsultantEmergencyRest 
{
   
    @HttpGet
    global static ResponseClass doGet()
    {
        String[] uriKeys = RestContext.request.requestURI.split('/'); 
        String branchCode = uriKeys.get(uriKeys.size()-2);    
        String GUID = uriKeys.get(uriKeys.size()-1);
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');      
        List<User> userUpdate = new List<User>();
        String errorFile = 'Id,Error\n'; 
        Map<id,String> errMessage = new Map<id,String>(); 
        Impellam_Settings__c set1 = Impellam_Settings__c.getValues('ConsultantEmergencyRest'); 
        Integer limit1 = Integer.Valueof(set1.Limit__c);   
      try{  
            
            List<User> userData = [select User.Name,
                                          User.Email,
                                          User.IP_TempestID__c,
                                          User.IP_TempestDivision__c,
                                          User.IP_TempestDepartment__c,
                                          User.Department  from User where user.IP_PassToTempest__c=true
                                                and user.IP_TempestDepartment__c=:branchCode and (GUID_user__c = null OR GUID_user__c!=:GUID) LIMIT :limit1];
           for(User  cnt: userData)
                {                      
                    cnt.GUID_user__c = GUID;
                    userUpdate.add(cnt);                                             
                } 
            //    if(!Test.isRunningTest())
         //  { 
                Database.SaveResult[] srList = Database.update(userUpdate, false);
        //   }                       
           List<id> errorIds = new List<id>();
                 List<id> successIds = new List<id>();
                for (integer i=0; i<srList.size();i++) 
                {
                     String errMsgs = '';
                    if(srList[i].isSuccess())
                    {
                        successIds.add(userUpdate[i].id);
                    }
                    else
                    {
                        errorIds.add(userUpdate[i].id);
                        for(Database.Error err : srList[i].getErrors())
                        {
                            errMsgs = errMsgs + '  ' + err.getMessage();       
                        }
                         errMessage.put(userUpdate[i].Id,errMsgs);
                         errMsgs ='';   
                    }
                }
            if(errorIds.isEmpty())
           return new ResponseClass('true', 'Query executed successfully.',userData);     
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
            String subject ='API Collect Failure - Consultant';
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
        global List<User> records;

        global ResponseClass(String success, String message, List<User> records) 
        {
            this.success = success;
            this.message = message;
            this.records = records;
        }
    }
}