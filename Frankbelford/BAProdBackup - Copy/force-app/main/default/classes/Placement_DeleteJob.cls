global class Placement_DeleteJob implements Database.Batchable<sObject>,Database.Stateful{
 public String errorFile = 'Id,Error,Message\n';
    public Boolean sendMail = false;
    public Integer counter=0;
    
 global Database.QueryLocator start(Database.BatchableContext BC){
     IP_ImpellamGlobalSetting__c imp = IP_ImpellamGlobalSetting__c.getOrgDefaults();
     String limitdays = imp.S_placementLimitSize__c;
       string query = 'Select id from sirenum__Placement__c where ID not in (select sirenum__Placement__c from sirenum__Shift__c)'+
       ' and IP_LastPassedToTempest__c=NULL and createdDate < '+limitdays;
         return Database.getQueryLocator(query);
     
 }
    global void execute(Database.BatchableContext BC,List<sirenum__Placement__c> scope){
    
   List<sirenum__Placement__c> placelist = scope;
   if(placelist.size()>0)
        {
            List<sirenum__Assignment__c> assignment = [Select id from sirenum__Assignment__c where sirenum__Placement__c in : placelist];
          
        Database.DeleteResult[] drList = Database.delete(assignment, false);


            for(Database.DeleteResult dr : drList) {
                if (dr.isSuccess()) {
                   

                }
                else {
                                   
                    for(Database.Error err : dr.getErrors()) {
                                       
                          errorFile = errorFile + dr.getId()+','+ err.getMessage() + ',' + err.getFields() + ',' + '\n';    
                        sendMail = True;            
                    }
                }
            }
            Database.DeleteResult[] drList2 = Database.delete(placelist, false);


            for(Database.DeleteResult dr : drList2) {
                if (dr.isSuccess()) {
                   

                }
                else {
                                   
                    for(Database.Error err : dr.getErrors()) {
                                       
                     
                        errorFile = errorFile + dr.getId()+','+ err.getMessage() + ',' + err.getFields() + ',' + '\n';    
                        sendMail = True;                    
                    }
                }
            }
            
                         
        } 
       
    }
    global void finish(Database.BatchableContext BC){
    

       If(sendMail == true)
            {
        
            Messaging.EmailFileAttachment errAtt = new Messaging.EmailFileAttachment();                
            blob errBlob = blob.valueof(errorFile);    
            errAtt.setFileName('Failed_Records.csv');
            errAtt.setBody(errBlob);    
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage(); 
            String subject ='Placement Delete Job Issue';
            email.setSubject(subject);
            //  String[] toAddresses = new String[] {emailid};
           // email.setToAddresses(toAddresses);
          email.saveAsActivity= false;
             email.settargetObjectId(UserInfo.getUserId()); 
            email.setPlainTextBody('Hello,\n\nPlease find attached the list of failed records.');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{errAtt});
        
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        
        } 
    }
}