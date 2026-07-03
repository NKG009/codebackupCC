public class Invoicequeryupdatecontrller {
@AuraEnabled
     public static String getInvoicedetails(String InvoiceIDS){
         if(InvoiceIDS == null || InvoiceIDS == '')
         {
            return 'blankvalue';
         }
         else
         {
            List<String> invoicelist = InvoiceIDS.split(',');
            System.debug('check list--->'+invoicelist);
             if(invoicelist.size()>1)
             {
                 return 'morethan1';
             }
             else
             {
                 List<IP_InvoiceQuery__c> inlist = [Select id,IP_Actioned__c from IP_InvoiceQuery__c where id=:InvoiceIDS ];
                 if(inlist[0].IP_Actioned__c == true)
                 {
                     return 'actioned';
                 }
                 else
                 {
                     return 'openpopup';
                 }
                  
             }
            
         }
}
@AuraEnabled
     public static List<IP_InvoiceQuery__c> getInvoicerecorddetails(String InvoiceIDS){
        system.debug('check parameter--->'+InvoiceIDS);
         List<IP_InvoiceQuery__c> invlist = [Select id,IP_InvoiceNumber__c,IP_Account__c,IP_AccountNumber__c,IP_Account__r.Name,IP_QueryDescription__c,IP_Comment__c,IP_PONumber__c from IP_InvoiceQuery__c where id =: InvoiceIDS];
        system.debug('check invoice list'+invlist); 
         return invlist;
     }
@AuraEnabled
    public static void Updaterecordandsendemail(String ponumber,String comments,String InvoiceIDS)
    {
      List<IP_InvoiceQuery__c> invlist = [Select id,IP_Actioned__c,IP_InvoiceNumber__c,IP_QueryValue__c,IP_Account__c,IP_AccountNumber__c,IP_Account__r.Name,IP_QueryDescription__c,IP_Comment__c,IP_PONumber__c from IP_InvoiceQuery__c where id =: InvoiceIDS]; 
        invlist[0].IP_Actioned__c = true;
        invlist[0].IP_ActionedBy__c = UserInfo.getName();
        invlist[0].IP_ActionedDate__c = System.today();
        update invlist;
        List<Task> tasklist = [Select id,Status from Task where IP_TaskType__c = 'Invoice Query' and Status != 'Completed'and Whatid =:InvoiceIDS];
     if(tasklist.size()>0)
     {
         for(Task t:Tasklist)
         {
             t.Status = 'Completed';
             t.IP_ActionedBy__c = UserInfo.getName();
             t.IP_ActionedDate__c = System.today();
         }
         update Tasklist;
     }
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();        
      email.setToAddresses(new String[] {'branchrequest@impellam.com'});
      //   email.setToAddresses(new String[] {'rituhetawal@gmail.com'});  
         String currentUserEmail = UserInfo.getUserEmail();
         String[] ccAddresses = new String[] {currentUserEmail};
             email.setccAddresses(ccAddresses);
            email.setsubject('Invoice Query Update for '+invlist[0].IP_Account__r.Name+' - Acc No. :'+invlist[0].IP_AccountNumber__c+' - INV : '+invlist[0].IP_InvoiceNumber__c);
            String body = 'Hi, <br/>';
            body += 'Please find below invoice query details: <br/><br/>';
            body += '<b><u>Original Query</u></b>'+'<br/>';
            body += 'Invoice Number : '+ invlist[0].IP_InvoiceNumber__c +'<br/>';
            body += 'Account Number : '+invlist[0].IP_AccountNumber__c + '<br/>';
            body += 'Account Name : '+invlist[0].IP_Account__r.Name+ '<br/>';
            body += 'Query Description : '+invlist[0].IP_QueryDescription__c+ '<br/><br/><br/><br/>';
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