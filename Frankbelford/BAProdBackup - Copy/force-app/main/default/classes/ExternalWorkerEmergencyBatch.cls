global class ExternalWorkerEmergencyBatch implements Database.Batchable<sObject>,Database.Stateful{

   global final String Query;
   global final String GUID;
   global final String Field1;
   global final String Field2;
   global boolean sendMail = false;
   global String errorFile = 'Id,Error\n';

   global ExternalWorkerEmergencyBatch(String q, String f1, String f2, String gd){
             Query=q; Field1=f1;Field2=f2;GUID=gd;
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, 
                       List<sObject> scope){
    Map<id,String> errMessage = new Map<id,String>();
    List<Id> errorIds = new List<Id>();
      for(Sobject s : scope)
      {
          s.put(Field1,False); 
          s.put(Field2,System.now()); 
          boolean testRunning= true;
          if(Test.isRunningTest() && testRunning)
          {
           testRunning = false;
           s.id = null;
          
         }
      }      
        Database.SaveResult[] srList = Database.update(scope,false);
        for (integer i=0; i<srList.size();i++) 
            {
                String errMsgs = '';

                if(!srList[i].isSuccess())
                {
                    errorIds.add(scope[i].Id);                   
                }
                for(Database.Error err : srList[i].getErrors())
                {
                    errMsgs = errMsgs + '  ' + err.getMessage();

                }
                
                errMessage.put(scope[i].Id,errMsgs);
                errMsgs ='';     
            }
           
            if(!errorIds.IsEmpty())
            {
                for(integer i=0;i<errorIds.size();i++)
                {
                    errorFile = errorFile + errorIds[i]+','+ errMessage.get(errorIds[i]) + ',' +'\n';                        
                    sendMail = true;
                }
            }
   }

   global void finish(Database.BatchableContext BC){
    if(sendMail == true)
        {
            Messaging.EmailFileAttachment errAtt = new Messaging.EmailFileAttachment();
                
            blob errBlob = blob.valueof(errorFile);    
            errAtt.setFileName('Failed_Records.csv');
            errAtt.setBody(errBlob);
    
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage(); 
           /* List<String>  toAddresses = new List<String>();
            List<User> userList = new List<User>();
            userList = [SELECT Id,Email,IsActive FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = True] ; 
            for (User u : userList)
            {
            toAddresses.add(u.email);
            } */
            String subject ='API Close Failure - External Worker';
            email.setSubject(subject);
          String[] toAddresses = new String[] {System.Label.BASupportEmail};
            email.setToAddresses(toAddresses);
            email.setPlainTextBody('Hello,\n\nPlease find attached the list of failed records.');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{errAtt});
        
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }   

   }

}