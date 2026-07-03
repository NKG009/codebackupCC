global class CandidateBreachletter{

webservice static String sendcandidateemail(String conID){
String flag;

Contact c =[Select id,name,Email,IP_TempestDepartment__c from Contact where id =:conID];
  
      String department = String.valueOf(c.IP_TempestDepartment__c);
      System.debug('## '+department );      
      IP_Shift_Template__c shiftemp = IP_Shift_Template__c.getValues(department); 
        PageReference pdfPage = new PageReference('/apex/DrivingBreachLetter?Id='+conID);
        pdfPage.getParameters().put('id',conID);
        Blob pdf;
        if(!test.isrunningtest()){        
          pdf = pdfPage.getContentAsPdf();
       }
        else
            pdf=Blob.valueOf('Test');
        
        Attachment a = New Attachment();
        a.body = pdf;
        a.parentID = conID;
        a.ContentType  = 'application/pdf';
        a.Name = 'Working Hours Breaching Letter';
        
        try{
       
            insert a;
                       
       Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('Working Hours Breaching Letter.pdf');
        efa.setContentType('application/pdf');
        efa.setBody(pdf);
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();    
        string[] toaddress = New String[] {c.email};
        email.setToAddresses(toaddress);  
         String messageBody = '<html><body>Dear '+c.Name+' ,<br></br>As discussed, please find attached a Working Hours Breaching Letter. This is to further notify you that our records indicate you have exceeded the weekly maximum of 60 allowed working hours.<br></br>Yours sincerely<br></br>'+shiftemp.IP_Site_Name__c+'</body></html>';
        system.debug('Email Body: ' + messageBody );
      
        email.setHtmlBody(messageBody);
        email.setSubject('Working Hours Breaching Letter'); 
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        flag = 'true';
        }catch(Exception e){
          /*  System.debug('Attachment=Exception-->'+e);
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();        
            email.setToAddresses(new String[] {'ritu.hetawal@espire.com'});   
            email.setsubject('Exception occurred in sending Breach letter');
            String body = 'Dear Admin, \n';
            body += 'Below mentioned error occrured while sending the Breach letter email for the Candidate  "'+ c.name + '\n';
            body += e;
            email.setPlainTextBody(body);
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});*/
            flag = 'false';
        }
         return flag;
      
    }
}