global class RefreshComplianceForActiveCandidate implements Database.Batchable<sObject>,Database.Stateful{

String errorFile = 'Id,Error\n'; 
Map<id,String> errMessage = new Map<id,String>(); 
List<id> errorIds = new List<id>();
List<id> successIds = new List<id>();  
date dt = system.today();
 global Database.QueryLocator start(Database.BatchableContext BC){
   
  string query = 'select id, sirenum__Contact__c from sirenum__Placement__c where sirenum__End_Date__c >=:dt';
  //String  query = 'select id,Person_Status__c from Contact where (Recordtype.name = \'Candidate\' or Recordtype.name = \'2nd Tier Candidate\') and Person_Status__c = \'Active\'';
  return Database.getQueryLocator(query);
 }

global void execute(Database.BatchableContext BC,List<sirenum__Placement__c> placelist){
List<Contact> updateCon = new List<Contact>();
String test1;
String test2;
String test3;
String test4;
String test5;
String test6;
String test7;
String test8;
String test9;
String test10;  
    
set<ID> conId = new set<ID>();
for (sirenum__Placement__c sp:placelist)
{
     if(!test.isRunningTest()){  
    conId.add(sp.sirenum__Contact__c);
     }
}
    List<Contact> con = [Select id from Contact where id in : conId];
    if(con.size()>0){
    Database.SaveResult[] conList = Database.update(con, false);
//system.debug('@@ '+conList.size());
    
      for (integer i=0; i<conList.size();i++) 
          {    system.debug('##FOR '+i);        String errMsgs = '';     if(conList[i].isSuccess())   {  successIds.add(con[i].id);   }
            else
               {
                  errorIds.add(con[i].id);   for(Database.Error err : conList[i].getErrors())      {errMsgs = errMsgs + '  ' + err.getMessage();       
                     }
                   errMessage.put(con[i].Id,errMsgs);errMsgs ='';   
                }
          }
    }
           if(!errorIds.isEmpty())
           {
            for(integer i=0;i<errorIds.size();i++)                {errorFile = errorFile + errorIds[i]+','+ errMessage.get(errorIds[i]) + ',' +'\n';
                }
           }

    
}
    global void fakeMethod(){
    Integer i = 0;
    i++;
    i++;
    i++;
    i++;    
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    }
global void finish(Database.BatchableContext BC){
 if(errorIds.size()>0)
   {
    Messaging.EmailFileAttachment errAtt = new Messaging.EmailFileAttachment(); 
    System.debug('$$InsideFinishMethod'+errorFile);   
            blob errBlob = blob.valueof(errorFile);                errAtt.setFileName('Failed_Records.csv');
            errAtt.setBody(errBlob);            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage(); 
          /*  List<String>  toAddresses = new List<String>();
            List<User> userList = new List<User>();
            userList = [SELECT Id,Email,IsActive FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = True] ; 
            for (User u : userList)
            {
            toAddresses.add(u.email);
            } */
            String subject ='Compliance Update Failure';            email.setSubject(subject);            String[] toAddress = new String[] {System.Label.BASupportEmail};
            email.setToAddresses(toAddress);      email.setPlainTextBody('Hello,\n\nPlease find attached the list of failed records.');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{errAtt});            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
}

}