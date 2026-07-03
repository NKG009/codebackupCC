public class ShiftDetailsOnButtonLightning{

    private static final string candidateEmailBlank = 'candidateEmailBlank';
    private static final string placementnotactive = 'placementnotactive';
    private static final string shift_details_already_sent = 'shift_details_already_sent';
    private static final string Active = 'Active';
    private static string shift_confirmation = 'shift confirmation.pdf';

    @AuraEnabled
    public static String getSPlacementDetail(String splacementId){
        sirenum__Placement__c splacement = [Select id,IP_TempestDepartment__c,IP_Department__c,IP_Shift_Details_sent__c,name,
                createdby.email,IP_Consultant1LookupSplitShare__r.email,sirenum__Contact__c,sirenum__Contact__r.email,
                IP_Consultant1LookupSplitShare__r.Name,Manual_Timesheet_no__c,sirenum__Placement__c.sirenum__Status__c,
                IP_Consultant1LookupSplitShare__r.FirstName,IP_Consultant1LookupSplitShare__r.LastName,
                sirenum__Job_Role__r.sirenum__Rota__r.Name,
                IP_Consultant1LookupSplitShare__r.Brand__c
        from sirenum__Placement__c where id =:splacementId];

        system.debug('+++++++222222222+++++'+splacement.sirenum__Contact__r.Email);
        shift_confirmation = splacement.IP_Consultant1LookupSplitShare__r.Brand__c + '_' + shift_confirmation;

        if(!splacement.IP_Shift_Details_sent__c) {
            if(splacement.sirenum__Status__c.equals(Active)) {
                if(String.IsNotBlank(splacement.sirenum__Contact__r.Email) ||
                        String.IsNotEmpty(splacement.sirenum__Contact__r.Email)){
                    String emailSent = sendSiteEmailToCandidate(splacement);
                    return emailSent;
                } else {
                    return candidateEmailBlank;
                }
            } else {
                return placementnotactive;
            }
        } else {
            return shift_details_already_sent;
        }
    }

    public static String sendSiteEmailToCandidate(sirenum__Placement__c splacement){
        String flag;
        PageReference pdfPage = new PageReference('/apex/CandidateTemplate?Id='+splacement.id);
        pdfPage.getParameters().put('id',splacement.id);
        Blob pdf;
        if(!test.isrunningtest()){
            pdf = pdfPage.getContentAsPdf();
        } else {
            pdf=Blob.valueOf('Test');
        }

        Attachment a = New Attachment();
        a.body = pdf;
        a.parentID = splacement.id;
        a.ContentType  = 'application/pdf';
        a.Name = shift_confirmation;

        String department = String.valueOf(splacement.IP_TempestDepartment__c);
        System.debug('## '+department );
        IP_Shift_Template__c shiftemp = IP_Shift_Template__c.getValues(department);
        insert a;

        if(shiftemp != null)
        {
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(shift_confirmation);
            efa.setContentType('application/pdf');
            efa.setBody(pdf);
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            Email_Template_Mapping__mdt templateMapping = Util.getEmailTemplateMapping(splacement.IP_Consultant1LookupSplitShare__r.Brand__c, 'Assignment Confirmation Email');
            Id templateId = templateMapping.TemplateId__c; 

            email.setWhatid(splacement.id);
            email.setTemplateId(templateId);
            email.setReplyTo(splacement.IP_Consultant1LookupSplitShare__r.email);
            OrgWideEmailAddress owd = [select id, DisplayName,Address from OrgWideEmailAddress where Address =:shiftemp.Email__c];
            email.setOrgWideEmailAddressId(owd.Id);
            List<User> ucand = [Select id from User where ContactId =: splacement.sirenum__Contact__c limit 1];
            if(ucand.size()>0){
                email.setTargetObjectId(ucand[0].Id);             email.setSaveasactivity(false);
            } else {
                email.setTargetObjectId(splacement.sirenum__Contact__c);
                email.setSaveasactivity(true);
            }

            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});

            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            flag = 'true';
            splacement.IP_Shift_Details_sent__c = true;
            update splacement;
        }
        return flag;
    }

}