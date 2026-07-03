global class ShiftdetailsendingBatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
  public List<String> placename = new List<String>();
  public List<sirenum__shift__c> shiftlist = new List<sirenum__shift__c>();
  public Map<Id, String> error = new Map<Id, String>();

  public Map<Id, String> emailsuccess = new Map<Id, String>();
  public String errorFile = 'Id,Error,Message\n';
  public Boolean sendMail = false;
  public Boolean throwError = false;
  public Date dt = System.today();

  global Database.QueryLocator start(Database.BatchableContext BC) {
    string query = 'Select id,createdby.email,IP_TempestDepartment__c,sirenum__Contact__c,IP_Consultant1LookupSplitShare__r.email,IP_Consultant1LookupSplitShare__r.IP_TempestDepartment__c,IP_Consultant1LookupSplitShare__c, IP_Consultant1LookupSplitShare__r.Brand__c, IP_Consultant1LookupSplitShare__r.name,name,createddate,IP_Shift_Details_sent__c from sirenum__Placement__c where (CreatedDate = Today OR CreatedDate = YESTERDAY ) and sirenum__Status__c=\'Active\' and IP_Shift_Details_sent__c=False and sirenum__Contact__r.Email != null and Id in (Select sirenum__Placement__c from sirenum__Shift__c)';
    return Database.getQueryLocator(query);
  }

  global void execute(
    Database.BatchableContext BC,
    List<sirenum__Placement__c> scope
  ) {
      
    
    shiftlist = [
      SELECT id
      FROM sirenum__shift__c
      WHERE sirenum__Placement__c = :scope[0].id
    ];
      system.debug('Shiftlist Size--> ' + shiftlist.size());
    String brand = String.isBlank(
        scope[0].IP_Consultant1LookupSplitShare__r.Brand__c
      )
      ? 'Blue Arrow'
      : scope[0].IP_Consultant1LookupSplitShare__r.Brand__c;

    if (shiftlist.size() > 0) {
     try {
      if (Test.isRunningTest() && throwError) {
          throw new SPlacementException('Test Thrown Error');
        }
      
        PageReference pdfPage;
        pdfPage = new PageReference(
          '/apex/CandidateTemplate?Id=' + scope[0].id
        );
        pdfPage.getParameters().put('id', scope[0].id);

        Blob pdf;
        if (!test.isrunningtest()) {
          pdf = pdfPage.getContentAsPdf();
        } else {
          pdf = Blob.valueOf('Test');
        }

        Attachment a = new Attachment();
        a.body = pdf;
        a.parentID = scope[0].id;
        a.ContentType = 'application/pdf';
        a.Name = 'shift confirmation.pdf';

        // insert a;

        scope[0].IP_Shift_Details_sent__c = true;
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName(brand + ' shift confirmation.pdf'); //Pleace ad pdf name from contact name project and oppty concatinate
        efa.setContentType('application/pdf');
        efa.setBody(pdf);

        Id templateId;
        templateId = Util.getEmailTemplateMapping(
            brand,
            'Assignment Confirmation Email'
          )
          .TemplateId__c;

        String department = String.valueOf(scope[0].IP_TempestDepartment__c);
        System.debug('## ' + department);

        IP_Shift_Template__c shiftemp = IP_Shift_Template__c.getValues(
          department
        );
        if (shiftemp != null) {
          List<User> ucand = [
            SELECT id
            FROM User
            WHERE ContactId = :scope[0].sirenum__Contact__c
            LIMIT 1
          ];
          Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

          if (ucand.size() > 0) {
            email.setTargetObjectId(ucand[0].Id);
          } else {
            email.setTargetObjectId(scope[0].sirenum__Contact__c);
          }
          email.saveAsActivity = false;
          email.setTemplateId(templateId);
          email.setFileAttachments(
            new List<Messaging.EmailFileAttachment>{ efa }
          );
          email.setWhatId(scope[0].id);

          email.setReplyTo(scope[0].IP_Consultant1LookupSplitShare__r.email);
          String orgWideEmailAddress = System.Label.BASupportEmail;
          List<OrgWideEmailAddress> owd = [
            SELECT id, DisplayName, Address
            FROM OrgWideEmailAddress
            WHERE Address = :shiftemp.Email__c
          ];
          List<OrgWideEmailAddress> defaultowd = [
            SELECT id, DisplayName, Address
            FROM OrgWideEmailAddress
            WHERE Address = :orgWideEmailAddress
          ];

          if (owd.size() > 0) {
            email.setOrgWideEmailAddressId(owd[0].Id);
          } else {
            email.setOrgWideEmailAddressId(defaultowd[0].Id);
          }

          Messaging.SendEmailResult[] results = Messaging.sendEmail(
            new List<Messaging.SingleEmailMessage>{ email }
          );
          if (results[0].success) {
            System.debug('The email was sent successfully.');
            emailsuccess.put(scope[0].id, 'Success');
            database.update(scope, false);
          } else {
            System.debug(
              'The email failed to send: ' + results[0].errors[0].message
            );
            errorFile =
              errorFile +
              scope[0].id +
              ',' +
              results[0].errors[0].message +
              ',' +
              ' Error in Sending Mail' +
              ',' +
              '\n';
            sendMail = true;
          }
        
        }
      } catch (Exception e) {
        System.debug('Attachment=Exception-->' + e);
        placename.add(scope[0].id);
        errorFile =
          errorFile +
          scope[0].id +
          ',' +
          e.getMessage() +
          ',' +
          'Error in Attachment OR email' +
          ',' +
          '\n';
        sendMail = true;

        //Set error field on record
        update new sirenum__Placement__c(
          Id = scope[0].id,
          Error_Message__c = e.getMessage()
        );
      }
    }
  }

  global void finish(Database.BatchableContext BC) {
    if (sendMail == true) {
      Messaging.EmailFileAttachment errAtt = new Messaging.EmailFileAttachment();
      blob errBlob = blob.valueof(errorFile);
      errAtt.setFileName('Failed_Records.csv');
      errAtt.setBody(errBlob);
      Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
      String subject = 'Shift Details Processing - Error';
      email.setSubject(subject);
      email.saveAsActivity = false;
      email.settargetObjectId(UserInfo.getUserId());
      email.setPlainTextBody(
        'Hello,\n\nPlease find attached the list of failed records.'
      );
      email.setFileAttachments(
        new List<Messaging.EmailFileAttachment>{ errAtt }
      );

      Messaging.SendEmailResult[] r = Messaging.sendEmail(
        new List<Messaging.SingleEmailMessage>{ email }
      );
    }
  }
  class SPlacementException extends Exception {
  }
}