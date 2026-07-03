global class TOE_Update_Batch implements Database.Batchable<sObject>{
   public String errorFile = 'Id\n';
    public Boolean sendMail = false;
    global Database.QueryLocator start(Database.BatchableContext BC){
        
   IP_ImpellamGlobalSetting__c imp = IP_ImpellamGlobalSetting__c.getOrgDefaults();
       Date datelimit = imp.ToeBatchDateFilter__c;
       String dayslimit = imp.ToeDaysFilter__c;
system.debug(datelimit +dayslimit );
         String query = 'Select id from Contact where TOE_Completed__c =  True and Id not in (Select ContactId from User)'+
           ' and (TOE_Updated__c >= '+dayslimit+' OR  TOE_Updated__c =: datelimit )' ;
       
        System.debug('query '+query);
        return database.getQueryLocator(query);
        
    }
     global void execute(Database.BatchableContext BC,List<Contact> scope){
    
          Profile p = [Select id from Profile where name='User Portal' Limit 1];
        UserRole role = [select id from UserRole where name = 'Candidates Customer User' Limit 1];
        List<User> listuser = new List<User>();
       for(Contact con: [Select id,IP_Alias__c,sirenum__National_Insurance__c,Email,FirstName,LastName,MailingCity,MailingCountry,MobilePhone,Phone,MailingPostalCode,MailingState,MailingStreet from Contact where id in: scope])
        {
            User u = new User();
            u.FirstName = con.FirstName;
            u.LastName = con.LastName;
            u.Email = con.Email;
            u.Username = con.Email;
            u.Alias = con.IP_Alias__c;
            u.CommunityNickname = con.IP_Alias__c;
            u.LanguageLocaleKey = 'en_US';
            u.ProfileId = p.Id;
             if(!test.isRunningTest()){
                u.UserRoleId = role.id;}
            u.State = con.MailingState;
            u.Street = con.MailingStreet;
            u.City = con.MailingCity;
            u.Country = con.MailingCountry;
            u.PostalCode = con.MailingPostalCode;
            u.Phone = con.Phone;
            u.MobilePhone = con.MobilePhone;
            u.ContactId = con.Id;
            u.TimeZoneSidKey = 'Europe/London';
            u.LocaleSidKey = 'en_GB';
            u.EmailEncodingKey = 'ISO-8859-1';
            u.NI_Number__c = con.sirenum__National_Insurance__c;
           listuser.add(u);
           
        }
     if(listuser.size()>0){
         //insert listuser;
         Database.SaveResult[] srList = Database.insert(listuser,false);
 
  
         
     }
         
     }
       global void finish(Database.BatchableContext BC){
       
       IP_ImpellamGlobalSetting__c imp = IP_ImpellamGlobalSetting__c.getOrgDefaults();
       Date datelimit = imp.ToeBatchDateFilter__c;
       String dayslimit = imp.ToeDaysFilter__c;
      String querycontact = 'Select id from Contact where TOE_Completed__c =  True and Id not in (Select ContactId from User)'+
           ' and (TOE_Updated__c >= '+dayslimit+' OR  TOE_Updated__c =: datelimit )';
           
         List<Contact> con =  Database.query(querycontact); 
         for(Contact c: con){           errorFile = errorFile + c.id+ '\n';       
         }
         If(con.size()>0){
           Messaging.EmailFileAttachment errAtt = new Messaging.EmailFileAttachment();                
            blob errBlob = blob.valueof(errorFile);    
            errAtt.setFileName('Failed_UserRecords.csv');            errAtt.setBody(errBlob);    
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage(); 
            String subject ='Portal User failed';            email.setSubject(subject);
            //  String[] toAddresses = new String[] {emailid};
           // email.setToAddresses(toAddresses);
          email.saveAsActivity= false;             email.settargetObjectId(UserInfo.getUserId()); 
            email.setPlainTextBody('Hello,\n\nPlease find attached the list of failed records.');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{errAtt});
        
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            }
       }
}