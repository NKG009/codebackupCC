global class SitedetailsonButton{

webservice static String sendsiteemail(String siteid){
String flag;
 sirenum__site__c s = [Select id,name,IP_TempestDepartment__c,IP_MainContact__c,IP_MainContact__r.Email,OwnerID, Owner.email,Owner.name from sirenum__site__c where id=:siteID];  
 
    String department = String.valueOf(s.IP_TempestDepartment__c);
       System.debug('## '+department );
      
      IP_Shift_Template__c shiftemp = IP_Shift_Template__c.getValues(department);     
            
 
        PageReference pdfPage = new PageReference('/apex/Site_Candidate_Template?Id='+siteid);
        pdfPage.getParameters().put('id',siteid);
        Blob pdf;
        if(!test.isrunningtest()){        
          pdf = pdfPage.getContentAsPdf();
       }
        else
            pdf=Blob.valueOf('Test');
        
        Attachment a = New Attachment();
        a.body = pdf;
        a.parentID = siteid;
        a.ContentType  = 'application/pdf';
        a.Name = 'Blue Arrow shift confirmation.pdf';
        
        try{
       
            insert a;
                       
       Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('Blue Arrow shift confirmation.pdf');
        efa.setContentType('application/pdf');
        efa.setBody(pdf);
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();    
        Id templateId;  
        templateId = [select id, name from EmailTemplate where developername = 'Client_Confirmation_Template'].id;
        string[] toaddress = New String[] {s.IP_MainContact__r.Email};
        email.setToAddresses(toaddress);   
        email.setTargetObjectId(s.IP_MainContact__c);
        email.setWhatid(s.id);
        email.setTemplateId(templateId); 
        email.setReplyTo(s.Owner.email);
       // email.setsenderdisplayname(s.Owner.name);
        String BranchtUserEmail = shiftemp.Email__c;
              OrgWideEmailAddress owd = [select id, DisplayName,Address from OrgWideEmailAddress where Address =:shiftemp.Email__c];
        email.setOrgWideEmailAddressId(owd.Id);
        String[] ccAddresses = new String[] {BranchtUserEmail}; 
         email.setccAddresses(ccAddresses);
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        flag = 'true';
        }catch(Exception e){
            System.debug('Attachment=Exception-->'+e);
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();        
            email.setToAddresses(new String[] {'ritu.hetawal@espire.com'});   
            email.setsubject('Exception occurred in sending Shift details');
            email.setSenderDisplayName(s.Owner.name); 
            String body = 'Dear Admin, \n';
            body += 'Below mentioned error occrured while sending the timesheet email for the placement  "'+ s.name + '\n';
            body += e;
            email.setPlainTextBody(body);
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            flag = 'false';
        }
         return flag;
    }

}