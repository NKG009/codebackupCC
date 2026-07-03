global class ShiftDetailsonButton{

    webservice static String sendemail(String placeid){
        String flag;
        String brand;
        String fileName;
        sirenum__Placement__c p =[Select id,IP_TempestDepartment__c,IP_Department__c,IP_Shift_Details_sent__c,name,createdby.email
                ,Manual_Timesheet_no__c
                ,sirenum__Contact__c,sirenum__Contact__r.email
                ,IP_Consultant1LookupSplitShare__r.email
                ,IP_Consultant1LookupSplitShare__r.Brand__c
                ,IP_Consultant1LookupSplitShare__r.Name
                ,IP_Consultant1LookupSplitShare__r.FirstName
                ,IP_Consultant1LookupSplitShare__r.LastName, sirenum__Job_Role__r.sirenum__Rota__r.Name
        from sirenum__Placement__c where id =:placeid];
        PageReference pdfPage = new PageReference('/apex/CandidateTemplate?Id='+placeid);
        pdfPage.getParameters().put('id',placeid);
        Blob pdf;
        if(!test.isrunningtest()){
            pdf = pdfPage.getContentAsPdf();
        } else {
            pdf=Blob.valueOf('Test');
        }
        brand = String.isNotBlank(p.IP_Consultant1LookupSplitShare__r.Brand__c)?p.IP_Consultant1LookupSplitShare__r.Brand__c:'';
        fileName = String.isNotBlank(brand)?brand+ ' Shift Confirmation.pdf':'Shift Confirmation.pdf';

        Attachment a = New Attachment();
        a.body = pdf;
        a.parentID = placeid;
        a.ContentType  = 'application/pdf';
        a.Name =fileName;

        //etDevName = [SELECT Label, DeveloperName, TemplateId FROM Email_Template_Mapping__mdt WHERE Brand__c =: brand].DeveloperName;
        //try{
        String department = String.valueOf(p.IP_TempestDepartment__c);
        System.debug('## '+department );

        IP_Shift_Template__c shiftemp = IP_Shift_Template__c.getValues(department);
        insert a;

        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        //efa.setFileName('Blue Arrow shift confirmation.pdf');
        efa.setFileName(fileName);
        efa.setContentType('application/pdf');
        efa.setBody(pdf);
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        Id templateId;

        templateId = Id.valueOf([SELECT Label, DeveloperName, TemplateId__c
                                    FROM Email_Template_Mapping__mdt
                                    WHERE Brand__r.Label =: brand
                                    AND Label = 'Assignment Confirmation Email'].TemplateId__c);
        List<User> ucand = [Select id from User where ContactId =: p.sirenum__Contact__c limit 1];
        string[] toaddress = New String[] {p.sirenum__Contact__r.email};

        if(ucand.size()>0){
            email.setTargetObjectId(ucand[0].Id);
            email.setSaveAsActivity(false);
        } else {
            email.setToAddresses(toaddress);
            email.setTargetObjectId(p.sirenum__Contact__c);
            email.setSaveAsActivity(true);
        }
        email.setWhatid(p.id);
        email.setTemplateId(templateId);
        email.setReplyTo(p.IP_Consultant1LookupSplitShare__r.email);
        OrgWideEmailAddress owd = [select id, DisplayName,Address from OrgWideEmailAddress where Address =:shiftemp.Email__c];
        email.setOrgWideEmailAddressId(owd.Id);
        //  email.setsenderdisplayname(p.IP_Consultant1LookupSplitShare__r.Name);
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});

        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        flag = 'true';
        /*} catch(Exception e){
            System.debug('Attachment=Exception-->'+e);
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[] {'ritu.hetawal@espire.com'});
            email.setsubject('Exception occurred in sending Shift details');            email.setSenderDisplayName(p.IP_Consultant1LookupSplitShare__r.name);
            String body = 'Dear Admin, \n';
            body += 'Below mentioned error occrured while sending the timesheet email for the placement  "'+ p.name + '\n';
            body += e;            email.setPlainTextBody(body);
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});            flag = 'false';
        }*/
        return flag;
    }

}