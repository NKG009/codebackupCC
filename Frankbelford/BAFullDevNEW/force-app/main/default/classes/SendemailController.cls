global class SendemailController {


 webservice static void sendEmailFunction(id pid){
 
       
        
        try {
        
        
                IP_PayProfile__c p = [select id ,IP_PayrollID__c,IP_CompanyName__c ,IP_Candidate__c from IP_PayProfile__c where id =: pid];
                
               contact con = [select id,account.name,name,Owner.name from contact where id = : p.IP_Candidate__c ];
                
               // Note note1  = [SELECT Body,Id,ParentId FROM Note where ParentId = : p.id];
                 
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {System.Label.BAPayrollEmail};//{'bluearrowpayroll@impellam.com'};
                mail.setToAddresses(toAddresses);
                mail.setSenderDisplayName('Name');
                mail.setSubject('New Ltd Company');
                  String body = '<p>Dear Payroll, </p>';
                  body += 'Please find attached documentation for the Ltd Company "'+ p.IP_CompanyName__c + '"';
                  body += ', payroll ID "'+ p.IP_PayrollID__c+ '"';
                 // body += '<p> NOTE: '+ note1.Body;  
                  body += '<BR></BR>Kind regards<BR>';
                  body += con.Owner.name;
                  
                  
                  
                  mail.setHtmlBody(body);
               
              // mail.setPlainTextBody('<table><tr><td>Dear Payroll,</td></tr><tr><td> Please find attached documentation for the Ltd Company {!con.account.name}, payroll ID {!p.id}</td></tr></table>');
                //mail.setHtmlBody('<b> This is HTML body </b>' );
                
                List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                for (Attachment a : [select Name, Body, BodyLength from Attachment where ParentId = :pid]){
                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                efa.setFileName(a.Name);
                efa.setBody(a.Body);
                fileAttachments.add(efa);
                //mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        }
        
            mail.setFileAttachments(fileAttachments);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
            } catch(Exception e) {}
            }
        
        
}