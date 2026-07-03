public class SitedetailsOnButtonLightning {

    @AuraEnabled
    public static String getSiteDetail(String siteId){
        sirenum__site__c site = [Select id,name,Email_Shifts_to_Client__c,IP_TempestDepartment__c,IP_MainContact__c,IP_MainContact__r.Email,
                                        OwnerID, Owner.email, Owner.name, Brand__c
                                    from sirenum__site__c where id=:siteID];
        System.debug('site >> ' + site);
        if(site.Email_Shifts_to_Client__c){
            if(String.IsNotBlank(site.IP_MainContact__r.Email)){
                String emailSent = sendSiteEmailToCandidate(site);
                return emailSent;
            } else {
                return 'candidateEmailBlank';
            }
        } else {
            return 'errorMessage';
        }
    }

    public static String sendSiteEmailToCandidate(sirenum__site__c site){
        site = [Select id,name,Email_Shifts_to_Client__c,IP_TempestDepartment__c,IP_MainContact__c,IP_MainContact__r.Email,
                OwnerID, Owner.email, Owner.name, Brand__c
        from sirenum__site__c where id=:site.Id];
        System.debug('site >> ' + site);
        System.debug('site.IP_TempestDepartment__c >> ' + site.IP_TempestDepartment__c);
        String brand = String.isBlank(site.Brand__c)?'Blue Arrow':site.Brand__c;
        String flag;
        Boolean IsLightning;
        OrgWideEmailAddress owd;
        IsLightning = [SELECT id,UserPreferencesLightningExperiencePreferred FROM User where id = : UserInfo.getUserId()].UserPreferencesLightningExperiencePreferred;

        String department = String.valueOf(site.IP_TempestDepartment__c);
        System.debug('department >> ' + department);

        IP_Shift_Template__c shiftemp = IP_Shift_Template__c.getValues(department);
        String BranchtUserEmail = shiftemp.Email__c;

        PageReference pdfPage = new PageReference('/apex/Site_Candidate_Template?Id='+site.id);
        pdfPage.getParameters().put('id',site.id);
        Blob pdf;
        if(!test.isrunningtest()){
            pdf = pdfPage.getContentAsPdf();
            owd = [select id, DisplayName,Address from OrgWideEmailAddress where Address =:shiftemp.Email__c];
        } else {
            pdf=Blob.valueOf('Test');
            owd = [select id, DisplayName,Address from OrgWideEmailAddress LIMIT 1];
        }

        Attachment a = New Attachment();
        a.body = pdf;
        a.parentID = site.id;
        a.ContentType  = 'application/pdf';
        a.Name = brand+' shift confirmation.pdf';

        if(IsLightning) {
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S';
            conVer.PathOnClient = 'application/pdf';
            conVer.Title = 'Timesheet.pdf';
            conVer.VersionData = pdf;
            insert conVer;
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
            ContentDocumentLink cDe = new ContentDocumentLink();
            cDe.ContentDocumentId = conDoc;
            cDe.LinkedEntityId = site.id;
            cDe.ShareType = 'I';
            cDe.Visibility = 'AllUsers';
            insert cDe;
        } else {
            insert a;
        }

        //Email Attachment
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName(brand+' shift confirmation.pdf');
        efa.setContentType('application/pdf');
        efa.setBody(pdf);

        //Email Body
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        Id templateId = Util.getEmailTemplateMapping(site.Brand__c, 'Client Confirmation Template').TemplateId__c; //[select id, name from EmailTemplate where developername = 'Client_Confirmation_Template'].id;
        string[] toaddress = New String[] {site.IP_MainContact__r.Email};
        email.setToAddresses(toaddress);
        email.setTargetObjectId(site.IP_MainContact__c);
        email.setWhatid(site.id);
        email.setTemplateId(templateId);
        email.setReplyTo(site.Owner.email);
        email.setOrgWideEmailAddressId(owd.Id);
        String[] ccAddresses = new String[] {BranchtUserEmail};
        email.setccAddresses(ccAddresses);
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});

        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        flag = 'true';
        return flag;
    }
}