public class InvoiceDetailsfromdetailsbutton {
    @AuraEnabled
     public static String querydetails(String InvoiceiD){
        
         IP_InvoiceQuery__c inq = [Select id,IP_Actioned__c from IP_InvoiceQuery__c where id=:InvoiceiD];
         
         if(inq.IP_Actioned__c == true)
         {
             return 'actioned';
         }
         else
         {
             return 'openpopup';
         }
        
            
   }
    @AuraEnabled
     public static List<IP_InvoiceQuery__c> getinvoicerecdetails(String invoiceid){
         List<IP_InvoiceQuery__c> invlist = [Select id,IP_InvoiceNumber__c,IP_Account__c,IP_AccountNumber__c,IP_Account__r.Name,IP_QueryDescription__c from IP_InvoiceQuery__c where id =: invoiceid];
        system.debug('check invoice list'+invlist); 
         return invlist;
     }
    @AuraEnabled
    public static void Updateinvoicerecordandemail(String ponumber,String comments,String invoiceid)
    {
     IP_InvoiceQuery__c invlist = [Select id,IP_Actioned__c,IP_InvoiceNumber__c,IP_QueryValue__c,IP_Account__c,IP_AccountNumber__c,IP_Account__r.Name,IP_QueryDescription__c,IP_Comment__c,IP_PONumber__c from IP_InvoiceQuery__c where id =: invoiceid]; 
        invlist.IP_Actioned__c = true;
         invlist.IP_ActionedBy__c = UserInfo.getName();
        invlist.IP_ActionedDate__c = System.today();
        update invlist;
     Task tasklist = [Select id,Status,Whatid from Task where Whatid =:invlist.id and Status != 'Completed' and IP_TaskType__c = 'Invoice Query'];
        tasklist.Status = 'Completed';
        tasklist.IP_ActionedBy__c = UserInfo.getName();
        tasklist.IP_ActionedDate__c = System.today();
        update tasklist;  
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] {Label.BranchRequestEmail});
         String currentUserEmail = UserInfo.getUserEmail();
         String[] ccAddresses = new String[] {currentUserEmail};
             email.setccAddresses(ccAddresses);
            email.setsubject('Invoice Query Update for '+invlist.IP_Account__r.Name+' - Acc No. : '+invlist.IP_AccountNumber__c+' - INV : '+invlist.IP_InvoiceNumber__c);
            String body = 'Hi, <br/>';
            body += 'Please find below invoice query details: <br/><br/>';
            body += '<b><u>Original Query</u></b>'+'<br/>';
            body += 'Invoice Number : '+ invlist.IP_InvoiceNumber__c +'<br/>';
            body += 'Account Number : '+invlist.IP_AccountNumber__c + '<br/>';
            body += 'Account Name : '+invlist.IP_Account__r.Name+ '<br/>';
            body += 'Query Description : '+invlist.IP_QueryDescription__c+ '<br/><br/><br/>';
            body += '<b><u>Branch reply</u></b>'+'<br/>';
            body += 'PO Number : '+ponumber+ '<br/>';
            body += 'Comments : '+comments+ '<br/><br/>';
            body += 'Thank you,'+ '<br/><br/>';
            body += UserInfo.getFirstName()+' '+UserInfo.getLastName();
            email.setHtmlBody(body);
            System.debug('check email'+body);
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }
     @AuraEnabled
    public static void Updateinvoicewithfile(String ponumber,String comments,String invoiceid,String filename, String base64Data, String contentType)
    {
     IP_InvoiceQuery__c invlist = [Select id,IP_Actioned__c,IP_InvoiceNumber__c,IP_QueryValue__c,IP_Account__c,IP_AccountNumber__c,IP_Account__r.Name,IP_QueryDescription__c,IP_Comment__c,IP_PONumber__c from IP_InvoiceQuery__c where id =: invoiceid]; 
        invlist.IP_Actioned__c = true;
         invlist.IP_ActionedBy__c = UserInfo.getName();
        invlist.IP_ActionedDate__c = System.today();
        update invlist;
     Task tasklist = [Select id,Status,Whatid from Task where Whatid =:invlist.id and Status != 'Completed' and IP_TaskType__c = 'Invoice Query'];
        tasklist.Status = 'Completed';
        tasklist.IP_ActionedBy__c = UserInfo.getName();
        tasklist.IP_ActionedDate__c = System.today();
        update tasklist;  
          base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
         Attachment a = new Attachment();
        a.parentId = invlist.id;
         a.Body = EncodingUtil.base64Decode(base64Data);
        a.Name = fileName;
        a.ContentType = contentType;
        
       // insert a;
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();  
        
         Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
          efa.setFileName(fileName);
          efa.setContentType(contentType);      
        efa.setBody(EncodingUtil.base64Decode(base64Data));
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
       email.setToAddresses(new String[] {Label.BranchRequestEmail});
      //   email.setToAddresses(new String[] {'martin.jones@impellam.com'});  
         String currentUserEmail = UserInfo.getUserEmail();
         String[] ccAddresses = new String[] {currentUserEmail};
             email.setccAddresses(ccAddresses);
            email.setsubject('Invoice Query Update for '+invlist.IP_Account__r.Name+' - Acc No. : '+invlist.IP_AccountNumber__c+' - INV : '+invlist.IP_InvoiceNumber__c);
            String body = 'Hi, <br/>';
            body += 'Please find below invoice query details: <br/><br/>';
            body += '<b><u>Original Query</u></b>'+'<br/>';
            body += 'Invoice Number : '+ invlist.IP_InvoiceNumber__c +'<br/>';
            body += 'Account Number : '+invlist.IP_AccountNumber__c + '<br/>';
            body += 'Account Name : '+invlist.IP_Account__r.Name+ '<br/>';
            body += 'Query Description : '+invlist.IP_QueryDescription__c+ '<br/><br/><br/>';
            body += '<b><u>Branch reply</u></b>'+'<br/>';
            body += 'PO Number : '+ponumber+ '<br/>';
            body += 'Comments : '+comments+ '<br/><br/>';
            body += 'Thank you,'+ '<br/><br/>';
            body += UserInfo.getFirstName()+' '+UserInfo.getLastName();
            email.setHtmlBody(body);
            System.debug('check email'+body);
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }
}