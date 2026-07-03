global class BatchHeaderP45sync implements Database.Batchable<sObject>,Database.Stateful{
    set<String>payrollID = new Set<String>();
    List<id> errorIds = new List<id>();
List<id> successIds = new List<id>();
String errorFile = 'Id,Error\n'; 
Map<id,String> errMessage = new Map<id,String>();
String errMsgs = '';   

 global Database.QueryLocator start(Database.BatchableContext BC){
  String  query = 'select id,IP_TextField1__c,IP_DateField1__c,IP_ErrorReason__c,IP_BatchLine__c.IP_BatchHeader__c  ,IP_Status__c from IP_BatchLine__c where IP_Status__c = \'open\' and IP_BatchHeader__r.IP_BatchType__c = \'P45 Sync\' and IP_BatchHeader__r.IP_State__c = \'Closed\' and IP_BatchHeader__r.IP_Status__c = \'Approved\'';
  return Database.getQueryLocator(query);
 }

  global void execute(Database.BatchableContext BC,List<IP_BatchLine__c> batchlinelist){
    Set<ID> headerId = new Set<ID>();
    String bheadername;
    for(IP_BatchLine__c bline : batchlinelist){                    
    headerId.add(bline.IP_BatchHeader__c);                  
  }
  List<IP_BatchLine__c> batchlinelistToUpdate = new List<IP_BatchLine__c>();
  List<String> legacyCandidateId = new List<String>();
  Map<ID,IP_BatchLine__c> ContactIDBatchLine = new Map<ID,IP_BatchLine__c>();
  Map<String,Date> CandidateIdEndDateMap = new Map<String,Date>();
 // list<IP_BatchLine__c> batchlinelist = [select id,IP_TextField1__c,IP_DateField1__c,IP_ErrorReason__c,IP_Status__c from IP_BatchLine__c where IP_Status__c =: 'open' and IP_BatchHeader__c In :P45Sync ];
 // system.debug('inside execute method batchline'+batchlinelist );
 
   for(IP_BatchLine__c batchline : batchlinelist ){
            if(batchline.IP_TextField1__c!=null && batchline.IP_DateField1__c!=null)
                legacyCandidateId.add(batchline.IP_TextField1__c);
            CandidateIdEndDateMap.put(batchline.IP_TextField1__c, batchline.IP_DateField1__c);
        }
   List<IP_PayProfile__c> payprofile =[Select id, IP_PayrollID__c, IP_Candidate__c,P45_Date_by_Head_Office__c from IP_PayProfile__c where IP_PayrollID__c In: legacyCandidateId and (RecordType.developername='PAYE' OR RecordType.developername='LTD')]; 
        List<Id> conId = new List<Id>();
        for(IP_PayProfile__c p : payprofile )
        {
            conId.add(p.IP_Candidate__c);
            
        }
         list<Contact> contactList = [select id,name,IP_CandidateIDlegacy__c,Reason_for_P45__c,P45_Date_by_Head_Office__c from Contact where Id In :conId ];
    
        system.debug('payprofile-->'+payprofile );
        system.debug('contactList-->'+contactList );
        for(IP_BatchLine__c batchline : batchlinelist ){
            Boolean candidateFound = false;
           // Boolean result;
            for(Integer i=0;i<payprofile.size();i++){
                for(Integer j =0;j<contactList.size();j++){
                if(batchline.IP_TextField1__c == payprofile[i].IP_PayrollID__c){
                  system.debug('IF1 '+payprofile[i].P45_Date_by_Head_Office__c);  
                      system.debug('IF2 '+batchline.IP_DateField1__c); 
                      system.debug('IF3 '+contactList[j].P45_Date_by_Head_Office__c); 
                    if(payprofile[i].P45_Date_by_Head_Office__c == batchline.IP_DateField1__c && payprofile[i].IP_Candidate__c ==  contactList[j].id && contactList[j].P45_Date_by_Head_Office__c != NULL ){
                        system.debug('LWD-->' );
                        batchline.IP_Status__c = 'Errored';
                        batchline.IP_ErrorReason__c = 'Candidate with Payroll ID as '+batchline.IP_TextField1__c + ' already has \'Date P45 Processed by Head Office\'';
                        batchlinelistToUpdate.add(batchline);
                        break;
                    }
                    else If(payprofile[i].IP_Candidate__c ==  contactList[j].id && (!payrollId.contains(batchline.IP_TextField1__c))){
                    payrollId.add(batchline.IP_TextField1__c);
                        contactList[j].P45_Date_by_Head_Office__c = CandidateIdEndDateMap.get(payprofile[i].IP_PayrollID__c);
                        payprofile[i].P45_Date_by_Head_Office__c = CandidateIdEndDateMap.get(payprofile[i].IP_PayrollID__c);
                    //  System.debug('@@ contactList[j].Reason_for_P45__c '+contactList[j].Reason_for_P45__c);                        
                        If(contactList[j].Reason_for_P45__c ==null)
                        {
                       payprofile[i].Reason_for_P45_Internal__c= 'Automatic';
                       contactList[j].Reason_for_P45__c = 'Automatic';
                        }
                        ContactIDBatchLine.put(contactList[j].id, batchline);
                        candidateFound = true;
                        break;
                    }
                }
            }
            }
            if(!candidateFound){
                if(batchline.IP_Status__c == 'Open'){
                    batchline.IP_Status__c = 'Errored';
                    batchline.IP_ErrorReason__c = 'Candidate with Payroll ID as '+batchline.IP_TextField1__c + ' not found';
                    batchlinelistToUpdate.add(batchline);
                }
            }
        }
        Database.SaveResult[] payList = Database.update(payprofile, false);

                for (integer i=0; i<payList.size();i++) 
                {
                     
                    if(payList[i].isSuccess())
                    {
                        successIds.add(payprofile[i].id);
                    }
                    else
                    {
                        errorIds.add(payprofile[i].id);       for(Database.Error err : payList[i].getErrors())
                        {
                            errMsgs = errMsgs + '  ' + err.getMessage();       
                        }
                         errMessage.put(payprofile[i].Id,errMsgs);                         errMsgs ='';   
                    }
                }        
        Database.SaveResult[] srList = Database.update(contactList, false);
      for (integer i=0; i<srList.size();i++) 
                {
                    // String errMsgs = '';
                    if(srList[i].isSuccess())
                    {
                        successIds.add(contactList[i].id);
                    }
                    else
                    {
                        errorIds.add(contactList[i].id);        for(Database.Error err : srList[i].getErrors())
                        {                            errMsgs = errMsgs + '  ' + err.getMessage();       
                        }
                         errMessage.put(contactList[i].Id,errMsgs);                         errMsgs ='';   
                    }
                }      
                System.debug('$$Error Message Map'+errMessage);
                System.debug('$$Error ID List'+errorIds);
                System.debug('$$SucessID List'+successIds);
                  for(integer i=0;i<errorIds.size();i++)                {                    errorFile = errorFile + errorIds[i]+','+ errMessage.get(errorIds[i]) + ',' +'\n';                 }
        for (Integer i = 0; i < srList.size(); i++) {
            Database.SaveResult sr = srList[i];
            if (sr.isSuccess()) {
                System.debug('sr.getID  ' + sr.getID());
                System.debug('ContactIDBatchLine  ' + ContactIDBatchLine);
                IP_BatchLine__c bl = ContactIDBatchLine.get(sr.getID());
                if(bl!=null && bl.IP_Status__c == 'Open'){
                    bl.IP_Status__c = 'Closed';
                    batchlinelistToUpdate.add(bl);
                }
            }
            else {
                String errorMessage = '';
                System.debug('sr.getID  ' + sr.getID());
                System.debug('ContactIDBatchLine  ' + ContactIDBatchLine);
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Contact fields that affected this error: ' + err.getFields());
                    errorMessage += err.getMessage();
                }
                IP_BatchLine__c bl = ContactIDBatchLine.get(contactList[i].id);
                System.debug('bl error: ' + bl);
                if(bl!=null){
                    bl.IP_Status__c = 'Errored';                    bl.IP_ErrorReason__c = errorMessage;                    batchlinelistToUpdate.add(bl);
                }
            }
        }
        system.debug('batchlinelistToUpdate-->'+batchlinelistToUpdate );
        update batchlinelistToUpdate;
        system.debug('batchlinelistToUpdate-->'+batchlinelistToUpdate );
        List<Batch_header__c> batchheaderlistUpdateStatus = [select id,name,(select id, IP_Status__c from Batch_Lines__r),IP_Status__c from Batch_header__c where id in:headerId]; 
        for(Batch_header__c bh: batchheaderlistUpdateStatus){
            IP_BatchLine__c[] bl = bh.Batch_Lines__r;
            Boolean success = false;
            Boolean failed = false;
            for(IP_BatchLine__c bline: bl){
                if(bline.IP_Status__c == 'Errored'){
                    failed = true;
                }
                else if(bline.IP_Status__c == 'Closed'){
                    success = true;
                }
            }
            if(success && failed){
                bh.IP_Status__c = 'Partial Error';
            }
            else if(success && !failed){                bh.IP_Status__c = 'Completed';
            }
            else if(!success && failed){
                bh.IP_Status__c = 'Rejected';
            }
        }
        update batchheaderlistUpdateStatus;
        system.debug('batchheaderlistUpdateStatus-->'+batchheaderlistUpdateStatus );

}

   global void finish(Database.BatchableContext BC){
   if(errorIds.size()>0)
   {
    Messaging.EmailFileAttachment errAtt = new Messaging.EmailFileAttachment(); 
    System.debug('$$InsideFinishMethod'+errorFile);   
            blob errBlob = blob.valueof(errorFile);                errAtt.setFileName('Failed_Records.csv');            errAtt.setBody(errBlob);
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage(); 
          /*  List<String>  toAddresses = new List<String>();
            List<User> userList = new List<User>();
            userList = [SELECT Id,Email,IsActive FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = True] ; 
            for (User u : userList)
            {
            toAddresses.add(u.email);
            } */
            String subject ='P45 Batch Failure';            email.setSubject(subject);            String[] toAddress = new String[] {System.Label.BASupportEmail};
            email.setToAddresses(toAddress);
            email.setPlainTextBody('Hello,\n\nPlease find attached the list of failed records.');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{errAtt});
        
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
    }
    
}