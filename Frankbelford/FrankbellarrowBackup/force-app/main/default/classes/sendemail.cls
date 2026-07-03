public class sendemail{
    @future(callout=true)
    public static void sendemailtimseheet(id psid){
        Boolean IsLightning;
        IsLightning = [SELECT id,UserPreferencesLightningExperiencePreferred FROM User where id = : UserInfo.getUserId()].UserPreferencesLightningExperiencePreferred;
        sirenum__Placement__c p =[Select id,name,createdby.email,IP_Consultant1LookupSplitShare__r.email,IP_Consultant1LookupSplitShare__r.IP_TempestDepartment__c,sirenum__Contact__c,sirenum__Contact__r.email,IP_Consultant1LookupSplitShare__r.Name,Manual_Timesheet_no__c,IP_Consultant1LookupSplitShare__r.FirstName,IP_Consultant1LookupSplitShare__r.LastName, sirenum__Job_Role__r.sirenum__Rota__r.Name from sirenum__Placement__c where id =:psid];
        string category=p.sirenum__Job_Role__r.sirenum__Rota__r.Name;
        String department = p.IP_Consultant1LookupSplitShare__r.IP_TempestDepartment__c;
        system.debug('department===>>>'+department);
        IP_Shift_Template__c shiftemp = IP_Shift_Template__c.getValues(department);
        
        OrgWideEmailAddress owd = [select id, DisplayName,Address from OrgWideEmailAddress where Address =:shiftemp.Email__c];
        if(category == 'driving')
        {      
            PageReference pdfPage = new PageReference('/apex/Manual_TimeSheet_Design?Id='+psid);
            pdfPage.getParameters().put('id',psid);
            Blob pdf;
            if(!test.isrunningtest()){        
                pdf = pdfPage.getContentAsPdf();
            }
            else
                pdf=Blob.valueOf('Test');
            
            Attachment a = New Attachment();
            a.body = pdf;
            a.parentID = psid;
            a.ContentType  = 'application/pdf';
            a.Name = 'SER-INV.pdf';
            
            try{
                if(IsLightning)
                {
                    ContentVersion conVer = new ContentVersion();
                    conVer.ContentLocation = 'S';
                    conVer.PathOnClient = 'application/pdf'; 
                    conVer.Title = 'SER-INV.pdf';  
                    conVer.VersionData = pdf; 
                    insert conVer;
                    Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
                    ContentDocumentLink cDe = new ContentDocumentLink();
                    cDe.ContentDocumentId = conDoc;
                    cDe.LinkedEntityId = psid;
                    cDe.ShareType = 'I';
                    cDe.Visibility = 'AllUsers';
                    insert cDe;
                    
                }
                else
                {
                    insert a; 
                }
                
                
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                
                efa.setFileName('Timesheet Template.pdf');
                efa.setContentType('application/pdf');
                efa.setBody(pdf);
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();    
                Id templateId;  
                templateId = [select id, name from EmailTemplate where developername = 'Timesheet_Template'].id;
                string[] toaddress = New String[] {p.sirenum__Contact__r.email};
                    email.setToAddresses(toaddress);   
                email.setOrgWideEmailAddressId(owd.Id);     
                email.setTargetObjectId(p.sirenum__Contact__c);
                email.setWhatid(p.id);
                email.setTemplateId(templateId); 
                email.setReplyTo(p.IP_Consultant1LookupSplitShare__r.email);
                // email.setsenderdisplayname(p.IP_Consultant1LookupSplitShare__r.Name); 
                email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            }catch(Exception e){
                System.debug('Attachment=Exception-->'+e);
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();        
                email.setToAddresses(new String[] { System.Label.BASupportEmail,p.createdby.email});
                //email.setToAddresses(new String[] {'ritu.hetawal@espire.com'});   
                email.setsubject('Exception occurred in generating Manual Timesheet');
                email.setSenderDisplayName(p.IP_Consultant1LookupSplitShare__r.name);    
                String body = 'Dear Admin, \n';
                body += 'Below mentioned error occrured while sending the timesheet email for the placement  "'+ p.name + '\n';
                body += e;
                email.setPlainTextBody(body);
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            }  
        }
        
        else
        {
            PageReference pdfPage = new PageReference('/apex/Manual_TimeSheet_Design_2?Id='+psid);
            pdfPage.getParameters().put('id',psid);
            Blob pdf;
            if(!test.isrunningtest()){
                
                pdf = pdfPage.getContentAsPdf();
            }
            else
                pdf=Blob.valueOf('Test');
            
            Attachment a = New Attachment();
            a.body = pdf;
            a.parentID = psid;
            a.ContentType  = 'application/pdf';
            a.Name = 'SER-INV.pdf';
            try{
                if(IsLightning)
                {
                    ContentVersion conVer = new ContentVersion();
                    conVer.ContentLocation = 'S';
                    conVer.PathOnClient = 'application/pdf'; 
                    conVer.Title = 'SER-INV.pdf';  
                    conVer.VersionData = pdf; 
                    insert conVer;
                    Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
                    ContentDocumentLink cDe = new ContentDocumentLink();
                    cDe.ContentDocumentId = conDoc;
                    cDe.LinkedEntityId = psid;
                    cDe.ShareType = 'I';
                    cDe.Visibility = 'AllUsers';
                    insert cDe;
                    
                }
                else
                {
                    insert a;
                }
                
                
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                
                efa.setFileName('Timesheet Template.pdf');
                efa.setContentType('application/pdf');
                efa.setBody(pdf);
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();    
                Id templateId;  
                templateId = [select id, name from EmailTemplate where developername = 'Timesheet_Template'].id;
                string[] toaddress = New String[] {p.sirenum__Contact__r.email};
                    email.setToAddresses(toaddress);   
                email.setOrgWideEmailAddressId(owd.Id);    
                email.setTargetObjectId(p.sirenum__Contact__c);
                email.setReplyTo(p.IP_Consultant1LookupSplitShare__r.email);
                email.setWhatid(p.id);
                email.setTemplateId(templateId); 
                //   email.setsenderdisplayname(p.IP_Consultant1LookupSplitShare__r.Name); 
                email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            }catch(Exception e){
                System.debug('Attachment=Exception-->'+e);
                System.debug('Attachment=Exception-->'+e);
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();        
                email.setToAddresses(new String[] { System.Label.BASupportEmail,p.createdby.email});   
                email.setsubject('Exception occurred in generating Manual Timesheet');
                email.setSenderDisplayName(p.IP_Consultant1LookupSplitShare__r.name);    
                String body = 'Dear Admin, \n';
                body += 'Below mentioned error occrured while sending the timesheet email for the placement  "'+ p.name + '\n';
                body += e;
                email.setPlainTextBody(body);
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            }
            
        }
    }
    
}