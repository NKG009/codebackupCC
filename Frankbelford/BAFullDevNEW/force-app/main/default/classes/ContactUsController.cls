/**
 *  @Name: <ContactUsController>
 *  @Date Created: <04/04/2019>
 *  @Description: used for the Component NewContactUs
 */
public without sharing class ContactUsController {
  /**
   *  Description : Method to get Sites Name
   *  @name : getSitesOfLoggedInUser
   *  @param : None
   *  @return : List<sirenum__Site__c>
   *  @throws exception-none
   */
  @AuraEnabled
  public static List<sirenum__Site__c> getSitesOfLoggedInUser() {
    Id loggedInUserId = UserInfo.getUserId();
    User u = [
      SELECT id, ContactId
      FROM User
      WHERE id = :loggedInUserId
      LIMIT 1
    ];
    Contact cont = [SELECT id, AccountId FROM Contact WHERE id = :u.contactId];

    List<Id> siteIds = new List<Id>();
    List<Contact_Site_link__c> lstContactList = [
      SELECT Id, Account__c, IP_Site__c, IP_Site__r.id, IP_Contact__c
      FROM Contact_Site_link__c
      WHERE
        IP_Contact__r.Id = :cont.id
        AND Account__r.Id = :cont.AccountId
        AND IP_PortalType__c != NULL
    ];
    System.debug(lstContactList.size() + '==lstContactList==' + lstContactList);
    for (Contact_Site_link__c conSiteLink : lstContactList) {
      siteIds.add(conSiteLink.IP_Site__r.id);
    }
    List<sirenum__Site__c> sitesList = [
      SELECT id, name, sirenum__Operating_Company__c
      FROM sirenum__Site__c
      WHERE id IN :siteIds
      ORDER BY name ASC
    ];
    return sitesList;
  }

  /**
   *  Description : Method to get Logged-In User NAme
   *  @name : fetchUser
   *  @param : None
   *  @return : String
   *  @throws exception-none
   */
  @AuraEnabled
  public static User fetchUser() {
    return getUserInformation();
  }

  /**
   *  Description : Method to get fetch the Subject picklist value
   *  @name : fetch Picklist Value
   *  @param : None
   *  @return : String
   *  @throws exception-none
   */

  @AuraEnabled
  public static List<String> getselectOptionsClient(
    sObject objObject,
    string fld
  ) {
    List<String> allOpts = new List<String>();
    // Get the object type of the SObject.
    Schema.sObjectType objType = objObject.getSObjectType();

    // Describe the SObject using its object type.
    Schema.DescribeSObjectResult objDescribe = objType.getDescribe();

    // Get a map of fields for the SObject
    map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();

    // Get the list of picklist values for this field.
    list<Schema.PicklistEntry> values = fieldMap.get(fld)
      .getDescribe()
      .getPickListValues();

    // Add these values to the selectoption list.
    for (Schema.PicklistEntry a : values) {
      allOpts.add(a.getValue());
    }

    allOpts.sort();
    return allOpts;
  }

  /**
   *  Description : This Method is used to create a case and Send Email
   *  @name : caseInsertSendEmail
   *  @param : Subject and Description
   *  @return : void
   *  @throws exception-none
   */

  @AuraEnabled
  public static string caseInsertSendEmail(
    String sub,
    String des,
    String siteId
  ) {
    System.debug('===siteId==' + siteId);
    String status;
    if (sub != null && des != null) {
      // Update contact description field.
      ID contactId = [
        SELECT contactid
        FROM User
        WHERE id = :Userinfo.getUserid()
      ]
      .contactId;
      Contact c = new Contact(
        Id = contactId,
        Contact_Us_Query__c = sub,
        Description = des
      );
      update c;

      // Fetch portal user's email address from contact record.
      List<String> sentToEmailAddress = new List<String>();
      List<Contact_Site_link__c> lstContactList = [
        SELECT
          Id,
          Account__c,
          IP_Site__c,
          IP_Site__r.id,
          IP_Contact__c,
          IP_Contact__r.Email
        FROM Contact_Site_link__c
        WHERE
          IP_Site__r.id = :siteId
          AND IP_PortalType__c INCLUDES ('Primary Hours Approver')
          AND IP_PortalType__c != NULL
      ];
      for (Contact_Site_link__c csl : lstContactList) {
        sentToEmailAddress.add(csl.IP_Contact__r.Email);
      }
      system.debug('Email Addresses - ' + sentToEmailAddress);

      system.debug('Case ' + c);

      String profilename = [
        SELECT Profile.Name
        FROM User
        WHERE id = :Userinfo.getUserid()
      ]
      .Profile.Name;
      Contact con = [
        SELECT
          id,
          Brand__c,
          Owner.FirstName,
          Owner.Name,
          FirstName,
          LastName,
          Name,
          IP_TempestDepartment__c,
          Email
        FROM Contact
        WHERE id = :contactId
      ];
      String department = con.IP_TempestDepartment__c;
      System.debug('Contact Department - ' + department);
      IP_Shift_Template__c shiftemp = IP_Shift_Template__c.getValues(
        department
      );
      System.debug('Contact Shift Template - ' + shiftemp);

      // Fetch "blueArrow" email templates.
      /*
            Id templateIdCand = [select id, name from EmailTemplate where developername = 'Candidate_Portal_Submit_Query_Candidate'].id;
            Id templateIdCandBranch = [select id, name from EmailTemplate where developername = 'Candidate_Portal_Submit_Query_Branch'].id;
            Id templateIdClientCand = [select id, name from EmailTemplate where developername = 'Client_Portal_Submit_Query_Client'].id;
            Id templateIdClientBranch = [select id, name from EmailTemplate where developername = 'Client_Portal_Submit_Query_Branch'].id;
			*/

      OrgWideEmailAddress owd = con.Brand__c == 'Tate'
        ? [
            SELECT id, DisplayName, Address
            FROM OrgWideEmailAddress
            WHERE Address = 'noreply@tate.co.uk'
          ]
        : [
            SELECT id, DisplayName, Address
            FROM OrgWideEmailAddress
            WHERE Address = 'no.reply@bluearrow.co.uk'
          ];

      // Fetch "Tate" and "blueArrow" email templates.
      Id templateIdCand = null;
      Id templateIdCandBranch = null;
      Id templateIdClientCand = null;
      Id templateIdClientBranch = null;
      Id tateClientPortalSubmitQueryBranchId = null;
      Id tateClientPortalSubmitQueryClientId = null;
      for (EmailTemplate theTemplate : [
        SELECT DeveloperName
        FROM EmailTemplate
        WHERE
          DeveloperName IN (
            'Candidate_Portal_Submit_Query_Candidate',
            'Candidate_Portal_Submit_Query_Branch',
            'Client_Portal_Submit_Query_Client',
            'Client_Portal_Submit_Query_Branch',
            'Tate_Client_Portal_Submit_Query_Client',
            'Tate_Client_Portal_Submit_Query_Branch'
          )
      ]) {
        switch on theTemplate.DeveloperName {
          when 'Candidate_Portal_Submit_Query_Candidate' {
            templateIdCand = theTemplate.Id;
          }
          when 'Candidate_Portal_Submit_Query_Branch' {
            templateIdCandBranch = theTemplate.Id;
          }
          when 'Client_Portal_Submit_Query_Client' {
            templateIdClientCand = theTemplate.Id;
          }
          when 'Client_Portal_Submit_Query_Branch' {
            templateIdClientBranch = theTemplate.Id;
          }
          when 'Tate_Client_Portal_Submit_Query_Client' {
            tateClientPortalSubmitQueryClientId = theTemplate.Id;
          }
          when 'Tate_Client_Portal_Submit_Query_Branch' {
            tateClientPortalSubmitQueryBranchId = theTemplate.Id;
          }
        }
      }

      if (profilename == 'User Portal') {
        if (Test.isRunningTest()) {
          templateIdCandBranch = [
            SELECT Id, Name
            FROM EmailTemplate
            WHERE Name = 'TestEmailTemplate'
            LIMIT 1
          ]
          .Id;
        }
        Messaging.SingleEmailMessage email = messaging.renderStoredEmailTemplate(
          templateIdCandBranch,
          con.id,
          c.id
        );
        String BranchUserEmail = shiftemp.Email__c;
        String[] toAddresses = new List<String>{ BranchUserEmail };
        email.setTreatTargetObjectAsRecipient(false);
        email.setToAddresses(toAddresses);
        email.setSubject('Query From ' + con.Name);
        email.saveAsActivity = false;
        Messaging.SendEmailResult[] results = Messaging.sendEmail(
          new List<Messaging.SingleEmailMessage>{ email }
        );
        if (results[0].success) {
          System.debug('The email was sent successfully.');
          status = 'Success';
        } else {
          System.debug(
            'The email failed to send: ' + results[0].errors[0].message
          );
          status = 'Failed';
        }

        if (Test.isRunningTest()) {
          templateIdCand = [
            SELECT Id, Name
            FROM EmailTemplate
            WHERE Name = 'TestEmailTemplate'
          ]
          .Id;
        }
        Messaging.SingleEmailMessage email1 = messaging.renderStoredEmailTemplate(
          templateIdCand,
          con.id,
          null
        );
        String branchname = shiftemp.IP_Site_Name__c;
        email1.setSubject('Your recent query to ' + branchname);
        email1.saveAsActivity = false;
        Messaging.SendEmailResult[] results1 = Messaging.sendEmail(
          new List<Messaging.SingleEmailMessage>{ email1 }
        );
        if (results1[0].success) {
          System.debug('The email was sent successfully.');
          status = 'Success';
        } else {
          System.debug(
            'The email failed to send: ' + results1[0].errors[0].message
          );
          status = 'Failed';
        }
      } else if (profilename == System.Label.Client_Portal_User_Profile) {
        System.debug('===sentToEmailAddress==' + sentToEmailAddress);
        if (Test.isRunningTest()) {
          templateIdClientBranch = [
            SELECT Id, Name
            FROM EmailTemplate
            WHERE Name = 'TestEmailTemplate'
            LIMIT 1
          ]
          .Id;
        }

        // Identify branch email template as per the logged-in user brand.
        Id branchTemplateId = (con.Brand__c == 'Tate'
          ? tateClientPortalSubmitQueryBranchId
          : templateIdClientBranch);
        System.debug('Branch Email Template Id - ' + branchTemplateId);

        Messaging.SingleEmailMessage email = messaging.renderStoredEmailTemplate(
          branchTemplateId,
          con.id,
          c.id
        );
        email.setSubject('Query From ' + con.Name);
        String BranchUserEmail = shiftemp.Email__c;
        String[] toAddresses = new List<String>{ BranchUserEmail };
        email.setTreatTargetObjectAsRecipient(false);
        System.debug('Branch Email Address - ' + toAddresses);
        email.setToAddresses(toAddresses);
        email.setOrgWideEmailAddressId(owd.Id);
        System.debug('email ' + email);
        email.saveAsActivity = false;
        Messaging.SendEmailResult[] results = Messaging.sendEmail(
          new List<Messaging.SingleEmailMessage>{ email }
        );
        if (results[0].success) {
          System.debug('The email was sent successfully.');
          status = 'Success';
        } else {
          System.debug(
            'The email failed to send: ' + results[0].errors[0].message
          );
          status = 'Failed';
        }
        if (Test.isRunningTest()) {
          templateIdClientCand = [
            SELECT Id, Name
            FROM EmailTemplate
            WHERE Name = 'TestEmailTemplate'
          ]
          .Id;
        }

        // Identify client email template as per the logged-in user brand.
        Id clientTemplateId = (con.Brand__c == 'Tate'
          ? tateClientPortalSubmitQueryClientId
          : templateIdClientCand);
        System.debug('Client Email Template Id - ' + clientTemplateId);
        System.debug('Client Email Address - ' + con.Email);

        Messaging.SingleEmailMessage email1 = messaging.renderStoredEmailTemplate(
          clientTemplateId,
          con.id,
          con.id
        );
        String branchname = shiftemp.IP_Site_Name__c;
        email1.setOrgWideEmailAddressId(owd.Id);
        email1.setSubject(
          'Your recent query to ' +
          con.Brand__c +
          ' ' +
          branchname
        );
        email1.saveAsActivity = false;
        Messaging.SendEmailResult[] results1 = Messaging.sendEmail(
          new List<Messaging.SingleEmailMessage>{ email1 }
        );
        if (results1[0].success) {
          System.debug('The email was sent successfully.');
          status = 'Success';
        } else {
          System.debug(
            'The email failed to send: ' + results1[0].errors[0].message
          );
          status = 'Failed';
        }
      }
    }
    return status;
  }

  /**
   *  Description : Method to get Logged-In User Information
   *  @name : getUserInformation
   *  @param : None
   *  @return : User
   *  @throws exception-none
   */
  @testVisible
  private static User getUserInformation() {
    User user = [
      SELECT
        id,
        email,
        Name,
        username,
        usertype,
        communitynickname,
        timezonesidkey,
        languagelocalekey,
        firstname,
        lastname,
        phone,
        title,
        street,
        city,
        country,
        postalcode,
        User_Image__c,
        state,
        localesidkey,
        mobilephone,
        extension,
        fax,
        contact.email
      FROM User
      WHERE id = :UserInfo.getUserId()
    ];
    return User;
  }
}