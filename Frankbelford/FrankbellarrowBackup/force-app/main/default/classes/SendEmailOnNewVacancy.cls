public without sharing class SendEmailOnNewVacancy {
  /**
   *  Description : Method to get Logged-In User Information
   *  @name : fetchUserInformation
   *  @param : None
   *  @return : User
   *  @throws exception-none
   */
  @AuraEnabled
  public static User fetchUserInformation() {
    return getUserInformation();
  }

  @Auraenabled
  public static List<sirenum__Site__c> getsitesList() {
    List<sirenum__Site__c> sitesList = new List<sirenum__Site__c>();
    try {
      Id loggedInUserId = UserInfo.getUserId();
      User u = [
        SELECT id, ContactId
        FROM User
        WHERE id = :loggedInUserId
        LIMIT 1
      ];
      Contact cont = [
        SELECT id, AccountId
        FROM Contact
        WHERE id = :u.contactId
      ];

      List<Id> siteIds = new List<Id>();
      List<Contact_Site_link__c> lstContactList = [
        SELECT Id, Account__c, IP_Site__c, IP_Site__r.id, IP_Contact__c
        FROM Contact_Site_link__c
        WHERE
          IP_Contact__r.Id = :cont.id
          AND Account__r.Id = :cont.AccountId
          AND IP_PortalType__c != NULL
      ];
      System.debug(
        lstContactList.size() +
        '==lstContactList==' +
        lstContactList
      );
      for (Contact_Site_link__c conSiteLink : lstContactList) {
        siteIds.add(conSiteLink.IP_Site__r.id);
      }
      sitesList = [
        SELECT id, name, sirenum__Operating_Company__c
        FROM sirenum__Site__c
        WHERE id IN :siteIds
        ORDER BY name ASC
      ];
    } catch (Exception e) {
      System.debug('Exception-->>' + e.getMessage());
    }
    return sitesList;
  }

  @Auraenabled
  public static List<sirenum__Team__c> getJobRoleList() {
    Id loggedInUserId = UserInfo.getUserId();
    User u = [
      SELECT id, ContactId
      FROM User
      WHERE id = :loggedInUserId
      LIMIT 1
    ];
    Contact cont = [SELECT id, AccountId FROM Contact WHERE id = :u.contactId];
    List<sirenum__Team__c> jobRoleList = [
      SELECT id, Name
      FROM sirenum__Team__c
      WHERE sirenum__Account__r.sirenum__Client__c = :cont.AccountId
    ];
    return jobRoleList;
  }

  @Auraenabled
  public static String SendEmail(
    String siteId,
    String startTime,
    String endTime,
    String startDate,
    String endDate,
    String textAreaVal
  ) {
    System.debug('siteId@@@@' + siteId);
    boolean result;
    String msg = '';
    try {
      DateTime StartDateTime;
      if (!String.isBlank(startDate)) {
        List<String> dateStrList = startDate.split('/');
        //Date startDt = Date.valueOf(startDate);
        Date startDt = Date.newInstance(
          Integer.valueOf('20' + dateStrList[2]),
          Integer.valueOf(dateStrList[1]),
          Integer.valueOf(dateStrList[0])
        );
        system.debug('+++++++++++++' + startDt);
        List<String> timeStrList = startTime.split(':');
        Time startTt = Time.newInstance(1, 0, 0, 0); //Time.newInstance(Integer.valueOf(timeStrList[0]),Integer.valueOf(timeStrList[1]),0,0 );

        StartDateTime = DateTime.newInstance(startDt, startTt);
        System.debug('StartDateTime:' + StartDateTime);
      }
      DateTime endDateTime;
      if (!String.isBlank(endDate)) {
        //Date endDt = Date.valueOf(endDate);
        List<String> dateStrList = endDate.split('/');
        Date endDt = Date.newInstance(
          Integer.valueOf('20' + dateStrList[2]),
          Integer.valueOf(dateStrList[1]),
          Integer.valueOf(dateStrList[0])
        );
        List<String> endStrList = endTime.split(':');
        Time endTt = Time.newInstance(
          Integer.valueOf(endStrList[0]),
          Integer.valueOf(endStrList[1]),
          0,
          0
        );
        System.debug('endTt-->>>' + endTt);
        endDateTime = DateTime.newInstance(endDt, endTt);
      }

      Id loggedInUserId = UserInfo.getUserId();
      User u = [
        SELECT id, ContactId, Name
        FROM User
        WHERE id = :loggedInUserId
        LIMIT 1
      ];
      //Contact cont = [SELECT AccountId FROM Contact WHERE id = :u.contactId];

      //Send Email Logic
      //Contact dummycont = [SELECT id,Name FROM Contact Limit 1];
      sirenum__Site__c site = [
        SELECT
          id,
          Owner.Email,
          Owner.Name,
          OwnerID,
          Name,
          IP_TempestDepartment__c,
          sirenum__Operating_Company__r.name
        FROM sirenum__Site__c
        WHERE id = :siteId
        LIMIT 1
      ];
      System.debug('site-->>' + site.Owner.Email + site);

      IP_Shift_Template__c branchemail = IP_Shift_Template__c.getValues(
        site.IP_TempestDepartment__c
      );

      String subject =
        'New Shift from ' + site.sirenum__Operating_Company__r.name;
      String body = 'Hi, <br><br>';
      body +=
        u.name +
        ' has submitted the following shift via the client portal.<br><br>';
      body +=
        'Start Date : ' +
        startDate +
        '<br> End Date : ' +
        endDate +
        '<br> Details of New Staff Requirement : ' +
        textAreaVal +
        '<br><br>';
      body += 'Please contact them asap to confirm their request resolve their query. <br><br>';
      body += 'Thanks,<br> Jobscience.';

      Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
      String[] toaddressess = new List<String>{ branchemail.Email__c }; //{site.Owner.Email};//{'swathi.melkundi@espire.com'};//
      email.setToAddresses(toaddressess);
      email.setHtmlBody(body);
      email.setSubject(subject);

      System.debug('email-->>' + email);
      Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ email });

      Task tsk = new Task();
      tsk.Ownerid = site.OwnerID;
      tsk.WhatID = site.id;
      tsk.Subject = 'New Vacancy';
      tsk.ActivityDate = System.today();
      String comments = 'Site = ' + site.name + '\n';
      comments += 'Start Time = ' + startDate + '\n';
      comments += 'End Time = ' + endDate + '\n';
      comments += 'Vacancy Description = ' + textAreaVal;
      tsk.Description = comments;
      // tsk.WhoID = newShift.sirenum__Contact__c;
      insert tsk;
      System.debug('Task created' + tsk);
      msg = 'Request Sent for Processing';
    } catch (Exception e) {
      System.debug(e.getLineNumber() + 'exception-->>' + e.getMessage());
      msg = e.getMessage();
    }
    return msg;
  }

  @Auraenabled
  public static String SendEmailWithPO(
    String siteId,
    String startTime,
    String endTime,
    String startDate,
    String endDate,
    String textAreaVal,
    String poNumber
  ) {
    System.debug('siteId@@@@' + siteId);
    boolean result;
    String msg = '';
    try {
      DateTime StartDateTime;
      if (!String.isBlank(startDate)) {
        List<String> dateStrList = startDate.split('/');
        //Date startDt = Date.valueOf(startDate);
        Date startDt = Date.newInstance(
          Integer.valueOf('20' + dateStrList[2]),
          Integer.valueOf(dateStrList[1]),
          Integer.valueOf(dateStrList[0])
        );
        system.debug('+++++++++++++' + startDt);
        List<String> timeStrList = startTime.split(':');
        Time startTt = Time.newInstance(1, 0, 0, 0); //Time.newInstance(Integer.valueOf(timeStrList[0]),Integer.valueOf(timeStrList[1]),0,0 );

        StartDateTime = DateTime.newInstance(startDt, startTt);
        System.debug('StartDateTime:' + StartDateTime);
      }
      DateTime endDateTime;
      if (!String.isBlank(endDate)) {
        //Date endDt = Date.valueOf(endDate);
        List<String> dateStrList = endDate.split('/');
        Date endDt = Date.newInstance(
          Integer.valueOf('20' + dateStrList[2]),
          Integer.valueOf(dateStrList[1]),
          Integer.valueOf(dateStrList[0])
        );
        List<String> endStrList = endTime.split(':');
        Time endTt = Time.newInstance(
          Integer.valueOf(endStrList[0]),
          Integer.valueOf(endStrList[1]),
          0,
          0
        );
        System.debug('endTt-->>>' + endTt);
        endDateTime = DateTime.newInstance(endDt, endTt);
      }

      Id loggedInUserId = UserInfo.getUserId();
      User u = [
        SELECT id, ContactId, Name
        FROM User
        WHERE id = :loggedInUserId
        LIMIT 1
      ];
      //Contact cont = [SELECT AccountId FROM Contact WHERE id = :u.contactId];

      //Send Email Logic
      //Contact dummycont = [SELECT id,Name FROM Contact Limit 1];
      sirenum__Site__c site = [
        SELECT
          id,
          Owner.Email,
          Owner.Name,
          OwnerID,
          Name,
          IP_TempestDepartment__c,
          sirenum__Operating_Company__r.name
        FROM sirenum__Site__c
        WHERE id = :siteId
        LIMIT 1
      ];
      System.debug('site-->>' + site.Owner.Email + site);

      IP_Shift_Template__c branchemail = IP_Shift_Template__c.getValues(
        site.IP_TempestDepartment__c
      );

      String subject =
        'New Shift from ' + site.sirenum__Operating_Company__r.name;
      String body = 'Hi, <br><br>';
      body +=
        u.name +
        ' has submitted the following shift via the client portal.<br><br>';
      body +=
        'Start Date : ' +
        startDate +
        '<br> Start Time : ' +
        startTime +
        '<br> End Date : ' +
        endDate +
        '<br> End Time : ' +
        endTime;

      if (!String.isEmpty(poNumber)) {
        body += '<br> PO Number : ' + poNumber;
      }

      body +=
        '<br> Details of New Staff Requirement : ' +
        textAreaVal +
        '<br><br>';
      body += 'Please contact them asap to confirm their request resolve their query. <br><br>';
      body += 'Thanks,<br> Jobscience.';

      Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
      //Following logic works out whether the email is being fired out of work hours or not, using the 'WorkHoursCalculator'
      String recipientEmail = WorkHoursCalculator.isInWorkHours(Datetime.now()) == true ? branchemail.Email__c : Label.OutOfHoursBlueArrowEmail;
      String[] toaddressess = new List<String>{ recipientEmail }; //{site.Owner.Email};//{'swathi.melkundi@espire.com'};//
      email.setToAddresses(toaddressess);
      if(WorkHoursCalculator.isInWorkHours(Datetime.now()) == false){
        //CC the branch email only if out of work hours
        email.setCcAddresses(new List<String>{branchemail.Email__c});
      }
      email.setHtmlBody(body);
      email.setSubject(subject);

      System.debug('email-->>' + email);
      Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ email });

      Task tsk = new Task();
      tsk.Ownerid = site.OwnerID;
      tsk.WhatID = site.id;
      tsk.Subject = 'New Vacancy';
      tsk.ActivityDate = System.today();
      String comments =
        'Site = ' +
        site.name +
        '\n' +
        'Start Date : ' +
        startDate +
        '\n' +
        'Start Time : ' +
        startTime +
        '\n' +
        'End Date : ' +
        endDate +
        '\n' +
        'End Time : ' +
        endTime +
        '\n';

      if (!String.isEmpty(poNumber)) {
        comments += 'PO Number : ' + poNumber + '\n';
      }
      comments += 'Vacancy Description = ' + textAreaVal;
      tsk.Description = comments;
      // tsk.WhoID = newShift.sirenum__Contact__c;
      insert tsk;
      System.debug('Task created' + tsk);
      msg = 'Request Sent for Processing';
    } catch (Exception e) {
      System.debug(e.getLineNumber() + 'exception-->>' + e.getMessage());
      msg = e.getMessage();
    }
    return msg;
  }

  /**
   *  Description : Method to get Logged-In User Information
   *  @name : getUserInformation
   *  @param : None
   *  @return : User
   *  @throws exception-none
   */
  private static User getUserInformation() {
    User user = [
      SELECT id, Name, User_Image__c
      FROM User
      WHERE id = :UserInfo.getUserId()
    ];
    return User;
  }
}