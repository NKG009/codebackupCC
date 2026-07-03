global class SitedetailsBatch implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts {
    public List<String> sitename = new List<String>();
    public Map<Id,String> error = new Map<Id,String>();
    public Map<Id,String> emailerror = new Map<Id,String>();
    public Map<Id,String> emailsuccess = new Map<Id,String>();
    Date todayDate1 = System.today();
    Time todayTime = Time.newInstance(17, 0, 0, 0);
    DateTime shiftstartdate = DateTime.newInstance(todayDate1, todayTime);
    Set<id> SiteID = new Set<id>();
    Date tomorrowDate1 = System.today().addDays(1);
    Time tomorrowTime = Time.newInstance(17, 0, 0, 0);
    DateTime shiftenddate = DateTime.newInstance(tomorrowDate1, tomorrowTime);

    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('Start date@@'+shiftstartdate);
        System.debug('End date@@'+shiftenddate);
        string query ='Select id,sirenum__Placement__r.IP_Consultant1LookupSplitShare__r.Brand__c,sirenum__Scheduled_Start_Time__c,sirenum__Scheduled_End_Time__c,sirenum__Placement__r.sirenum__Contact__r.Name,sirenum__Placement__r.sirenum__Job_Role__r.sirenum__Job_Type__r.Name,sirenum__Placement__r.sirenum__Site__r.OwnerID,sirenum__Placement__r.sirenum__Site__r.Name,sirenum__Placement__r.sirenum__Site__r.Owner.Name,sirenum__Placement__r.sirenum__Site__r.Owner.Email,sirenum__Placement__r.sirenum__Site__r.IP_MainContact__c,sirenum__Placement__r.sirenum__Site__r.IP_MainContact__r.Email,sirenum__Placement__r.sirenum__Site__c,sirenum__Placement__r.sirenum__Site__r.IP_TempestDepartment__c from sirenum__Shift__c where sirenum__Contact__c!=null and (sirenum__Scheduled_Start_Time__c>=:shiftstartdate and sirenum__Scheduled_Start_Time__c<:shiftenddate) and sirenum__Placement__r.sirenum__Site__r.Email_Shifts_to_Client__c = TRUE and sirenum__Placement__r.sirenum__Site__r.IP_MainContact__r.Email!=\'\'';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sirenum__Shift__c> scope) {
        System.debug('***Scope List***'+scope);
        String brand;
        if(!SiteID.contains(scope[0].sirenum__Placement__r.sirenum__Site__c)) {
            System.debug('**Set Site**'+SiteID);
            System.debug('**Set Site**'+scope[0].sirenum__Placement__r.sirenum__Site__c);
            PageReference pdfPage;

            brand = String.isBlank(scope[0].sirenum__Placement__r.IP_Consultant1LookupSplitShare__r.Brand__c)?'Blue Arrow':scope[0].sirenum__Placement__r.IP_Consultant1LookupSplitShare__r.Brand__c;
            pdfPage = new PageReference('/apex/Site_Candidate_Template?Id='+scope[0].sirenum__Placement__r.sirenum__Site__c);
            pdfPage.getParameters().put('id',scope[0].sirenum__Placement__r.sirenum__Site__c);

            Blob pdf;
            if(!test.isrunningtest()){
                pdf = pdfPage.getContentAsPdf();
            } else {
                pdf=Blob.valueOf('Test');
            }

            Attachment a = New Attachment();
            a.body = pdf;
            a.parentID = scope[0].id;
            a.ContentType  = 'application/pdf';
            a.Name = brand+' shift confirmation.pdf';
            try {
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName(brand+' shift confirmation.pdf');
                efa.setContentType('application/pdf');
                efa.setBody(pdf);
                System.debug('Test brand >> '+ brand);
                Id templateId;
                templateId = Util.getEmailTemplateMapping(brand, 'Client Confirmation Template').TemplateId__c;

                String department = String.valueOf(scope[0].sirenum__Placement__r.sirenum__Site__r.IP_TempestDepartment__c);
                System.debug('department >>> '+department );

                IP_Shift_Template__c shiftemp = IP_Shift_Template__c.getValues(department);

                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setTargetObjectId(scope[0].sirenum__Placement__r.sirenum__Site__r.IP_MainContact__c);
                email.setTemplateId(templateId);
                email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                email.setWhatId(scope[0].sirenum__Placement__r.sirenum__Site__c);
                email.setReplyTo(scope[0].sirenum__Placement__r.sirenum__Site__r.Owner.email);

                String BranchtUserEmail = shiftemp.Email__c;
                String[] ccAddresses = new String[] {BranchtUserEmail};
                email.setccAddresses(ccAddresses);
                OrgWideEmailAddress owd = [select id, DisplayName,Address from OrgWideEmailAddress where Address =:shiftemp.Email__c];
                email.setOrgWideEmailAddressId(owd.Id);
                Messaging.SendEmailResult [] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                if (results[0].success) {
                    System.debug('The email was sent successfully.');
                    emailsuccess.put(scope[0].sirenum__Placement__r.sirenum__Site__c, 'Success');
                } else {
                    System.debug('The email failed to send: ' + results[0].errors[0].message);
                    emailerror.put(scope[0].sirenum__Placement__r.sirenum__Site__c, results[0].errors[0].message);
                }
            } catch(Exception e) {
                System.debug('Attachment=Exception-->'+e);
                sitename.add(scope[0].id);   error.put(scope[0].id, e.getMessage());
            }
        }
        SiteID.add(scope[0].sirenum__Placement__r.sirenum__Site__c);
    }

    global void finish(Database.BatchableContext BC) {
        If(error.size()>0 || emailerror.size()>0) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

            email.setToAddresses(new String[] { Userinfo.getUserEmail()});
            email.setsubject('Exception occurred');
            email.setSenderDisplayName(Userinfo.getName());
            String body = 'Dear Admin, \n';body += 'There are some issues while sending the email with these placements \n ';

            body += 'This is the Error : \n';                  body += error + '\n \n \n' ;
            body += 'Error '+emailerror + '\n \n \n' ; body += 'Success '+emailsuccess + '\n \n \n' ;
            body += 'Regards \n User';

            email.setPlainTextBody(body);

            // Sends the email
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
    }
}