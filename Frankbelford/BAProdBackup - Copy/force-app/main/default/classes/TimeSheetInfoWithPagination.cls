public without sharing class TimeSheetInfoWithPagination {
  @AuraEnabled
  public static String approveRejectTimesheetsWithRejectReason(
    List<Id> shiftIds,
    String theState,
    String rejectReason
  ) {
    String theResult = 'success';
    try {
      System.debug(shiftIds);
      sirenum__Shift__c theShift = null;
      List<sirenum__Shift__c> toBeProcessed = new List<sirenum__Shift__c>();
      for (sirenum__Shift__c theRecord : [
        SELECT sirenum__Scheduled_Start_Time__c, sirenum__Scheduled_End_Time__c
        FROM sirenum__Shift__c
        WHERE Id IN :shiftIds
      ]) {
        System.debug(theRecord);
        theShift = new sirenum__Shift__c(Id = theRecord.Id);
        if (theState == 'approve') {
          theShift.sirenum__Billable_Start_Time__c = theRecord.sirenum__Scheduled_Start_Time__c;
          theShift.sirenum__Billable_End_Time__c = theRecord.sirenum__Scheduled_End_Time__c;
          theShift.IP_ClientApproved__c = true;
          theShift.Approved_By__c = UserInfo.getUserId();
          theShift.Approved_Date_Time__c = System.now();
        } else {
          theShift.IP_ClientRejected__c = true;
          theShift.sirenum__Client_Comments__c = rejectReason;
        }

        toBeProcessed.add(theShift);
      }

      if (toBeProcessed.size() > 0) {
        update toBeProcessed;
      } else {
        theResult = 'none';
      }
    } catch (Exception theException) {
      theResult = 'error';
    }
    return theResult;
  }

  @AuraEnabled
  public static String UpdateInvoicePO(String timeId, String InvoicePO) {
    List<sirenum__Timesheet__c> timesheet = [
      SELECT
        id,
        sirenum__Team__r.name,
        sirenum__Worker__r.Name,
        sirenum__Week_Ending__c,
        sirenum__Client_Bill__c,
        IP_StandardWeeklyNumberID__c,
        sirenum__Site__r.Name,
        IP_Client_Invoice_PO__c
      FROM sirenum__Timesheet__c
      WHERE id = :timeId
    ];
    for (sirenum__Timesheet__c st : timesheet) {
      st.IP_Client_Invoice_PO__c = InvoicePO;
    }
    try {
      User finacesuer = [
        SELECT id, email
        FROM User
        WHERE name = 'Finance Team'
        LIMIT 1
      ];
      List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
      update timesheet;
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      List<String> sendTo = new List<String>();
      //sendTo.add('deeps.badhan@impellam.com');
      sendTo.add(System.Label.BASupportEmail);
      // mail.setToAddresses(sendTo);
      mail.settargetObjectId(finacesuer.id);
      String subject =
        'New Invoice PO ' +
        InvoicePO +
        ' for Timesheet ' +
        timesheet[0].IP_StandardWeeklyNumberID__c;
      mail.setSubject(subject);
      mail.saveAsActivity = false;
      String body = 'Hi, <br><br>';
      body +=
        UserInfo.getFirstName() +
        ' at ' +
        timesheet[0].sirenum__Site__r.Name +
        ' has submitted the following PO via the client portal. <br><br>';
      body += 'PO Number - ' + InvoicePO + '<br>';
      body +=
        'Timesheet – ' +
        timesheet[0].IP_StandardWeeklyNumberID__c +
        '<br>';
      body +=
        'Week ending date - ' +
        timesheet[0].sirenum__Week_Ending__c +
        '<br>';
      body +=
        'Total Charge of timesheet – ' +
        timesheet[0].sirenum__Client_Bill__c +
        '<br><br>';
      body +=
        'Candidate Name - ' +
        timesheet[0].sirenum__Worker__r.Name +
        '<br>';
      body += 'Job Role – ' + timesheet[0].sirenum__Team__r.name + '<br><br>';

      body += 'Thanks,<br> Jobscience.';
      mail.setHtmlBody(body);
      mails.add(mail);
      System.debug('===mails==' + mails);
      if (mails != null) {
        Messaging.sendEmail(mails);
      }

      return 'SUCCESS';
    } catch (Exception e) {
      return 'Error';
    }
  }

  @AuraEnabled
  public static User getUserInformation() {
    User user = [
      SELECT
        id,
        email,
        Name,
        username,
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
        contact.email
      FROM User
      WHERE id = :UserInfo.getUserId()
    ];
    return User;
  }

  @AuraEnabled
  public static String UpdateBulkPO(String Ponumber, List<id> Timesheetlist) {
    List<sirenum__Timesheet__c> timelist = [
      SELECT
        id,
        IP_Client_Invoice_PO__c,
        IP_StandardWeeklyNumberID__c,
        sirenum__Site__r.Name,
        sirenum__Week_Ending__c,
        sirenum__Client_Bill__c,
        sirenum__Worker__r.Name,
        sirenum__Team__r.name
      FROM sirenum__Timesheet__c
      WHERE id IN :Timesheetlist
    ];
    for (sirenum__Timesheet__c t : timelist) {
      t.IP_Client_Invoice_PO__c = Ponumber;
    }
    try {
      update timelist;
      User finacesuer = [
        SELECT id, email
        FROM User
        WHERE name = 'Finance Team'
        LIMIT 1
      ];
      List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      mail.settargetObjectId(finacesuer.id);
      String subject =
        'New Invoice PO ' +
        Ponumber +
        ' for Site ' +
        timelist[0].sirenum__Site__r.Name;
      mail.setSubject(subject);
      mail.saveAsActivity = false;
      /* String checkbody = 'rituhetawal@gmail.com';
             String[] ccAddresses = new String[] {checkbody};
             mail.setccAddresses(ccAddresses);*/

      String body = 'Hi, <br><br>';
      body +=
        UserInfo.getFirstName() +
        ' has submitted the following PO via the client portal. <br><br>';
      body += '<table border="1" style="border-collapse: collapse" width:"100%" cellspacing="5" cellpadding="5"><tr><th>PO Number</th><th>Timesheet Number</th><th>Week Ending Date</th><th>Total Charge of timesheet</th><th>Candidate Name</th><th>Job Role</th></tr>';
      for (sirenum__Timesheet__c l : timelist) {
        String tnnumber = l.IP_StandardWeeklyNumberID__c;
        String ponumberupdated = l.IP_Client_Invoice_PO__c;
        Date d = l.sirenum__Week_Ending__c;
        String weekending = String.valueOf(
          Datetime.newInstance(d.year(), d.month(), d.day())
            .format('dd-MM-yyyy')
        );
        String charge = String.valueOf(l.sirenum__Client_Bill__c);
        String candname = l.sirenum__Worker__r.Name;
        String jobname = l.sirenum__Team__r.name;
        body +=
          '<tr><td>' +
          ponumberupdated +
          '</td><td>' +
          tnnumber +
          '</td><td>' +
          weekending +
          '</td><td>' +
          charge +
          '</td><td>' +
          candname +
          '</td><td>' +
          jobname +
          '</td></tr>';
      }
      body += '</table>';

      body += '<br><br>Thanks,<br> Jobscience.';
      mail.setHtmlBody(body);
      mails.add(mail);
      System.debug('===mails==' + mails);
      if (mails != null) {
        Messaging.sendEmail(mails);
      }
      return 'SUCCESS';
    } catch (Exception e) {
      return 'ERROR';
    }
  }

  @AuraEnabled
  public static List<sirenum__Timesheet__c> fetchTimeSheets() {
    String accID = [
      SELECT id, contact.AccountId
      FROM User
      WHERE id = :UserInfo.getUserId()
      LIMIT 1
    ][0]
    .contact.AccountId;
    String conID = [
      SELECT id, contactId
      FROM User
      WHERE id = :UserInfo.getUserId()
      LIMIT 1
    ][0]
    .contactId;
    System.debug('accID: ' + accID);
    System.debug('conID: ' + conID);
    set<Id> siteId = new Set<ID>();
    for (Contact_Site_link__c lstContactList : [
      SELECT
        Id,
        Account__c,
        IP_Site__c,
        IP_Site__r.id,
        IP_Contact__c,
        IP_PortalType__c
      FROM Contact_Site_link__c
      WHERE
        IP_Contact__r.Id = :conID
        AND Account__r.Id = :accID
        AND IP_PortalType__c != NULL
    ]) {
      siteId.add(lstContactList.IP_Site__c);
    }

    List<sirenum__Site__c> sitesList = [
      SELECT id, name, sirenum__Operating_Company__c
      FROM sirenum__Site__c
      WHERE id = :siteId
    ];
    System.debug('sitesList--->>>' + sitesList);
    List<sirenum__Timesheet__c> timeSheetLists;
    if (sitesList != null && sitesList.size() > 0) {
      timeSheetLists = [
        SELECT
          Id,
          WeekendingPortal__c,
          IP_Client_Invoice_PO__c,
          sirenum__Total_Charge__c,
          Name,
          sirenum__Worker__r.Name,
          IP_StandardWeeklyNumberID__c,
          sirenum__Site__r.Name,
          sirenum__Week_Ending__c,
          sirenum__Total_Hours__c,
          sirenum__Team__c,
          sirenum__Team__r.Name
        FROM sirenum__Timesheet__c
        WHERE
          sirenum__Site__c IN :sitesList
          AND sirenum__Week_Ending__c >= LAST_N_WEEKS:3
          AND sirenum__Week_Ending__c <= TODAY
          AND Id IN (
            SELECT sirenum__Timesheet__c
            FROM sirenum__Timesheet_Line__c
            WHERE IP_Locktimesheet__c = TRUE
          )
        ORDER BY sirenum__Week_Ending__c DESC
      ];
    }
    System.debug('timeSheetLists===33' + timeSheetLists);
    return timeSheetLists;
  }

  @AuraEnabled
  public static List<sirenum__Timesheet_Line__c> fetchTimeSheetLines(
    String timeSheetId
  ) {
    List<sirenum__Timesheet_Line__c> timeSheetLinesList = [
      SELECT
        sirenum__Charge__c,
        sirenum__Date__c,
        sirenum__Timesheet__r.IP_StandardWeeklyNumberID__c,
        sirenum__Hours__c,
        sirenum__Timesheet__r.Name,
        sirenum__Timesheet__r.sirenum__Site__r.Name,
        sirenum__Timesheet__r.sirenum__Team__r.Name,
        sirenum__Shift__c,
        sirenum__Shift__r.Approved_By__r.Name,
        sirenum__Shift__r.Approved_Date_Time__c
      FROM sirenum__Timesheet_Line__c
      WHERE sirenum__Timesheet__c = :timeSheetId
    ];
    System.debug('timeSheetLinesList --->>>' + timeSheetLinesList);
    return timeSheetLinesList;
  }

  @AuraEnabled
  public static List<sirenum__Site__c> getSites() {
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

  @AuraEnabled
  public static List<sirenum__Timesheet__c> fetchTimeSheetsByFilter(
    String timesheet
  ) {
    String accID = [
      SELECT id, contact.AccountId
      FROM User
      WHERE id = :UserInfo.getUserId()
      LIMIT 1
    ][0]
    .contact.AccountId;
    String conID = [
      SELECT id, contactId
      FROM User
      WHERE id = :UserInfo.getUserId()
      LIMIT 1
    ][0]
    .contactId;
    set<Id> siteId = new Set<ID>();
    for (Contact_Site_link__c lstContactList : [
      SELECT
        Id,
        Account__c,
        IP_Site__c,
        IP_Site__r.id,
        IP_Contact__c,
        IP_PortalType__c
      FROM Contact_Site_link__c
      WHERE
        IP_Contact__r.Id = :conID
        AND Account__r.Id = :accID
        AND IP_PortalType__c != NULL
    ]) {
      siteId.add(lstContactList.IP_Site__c);
    }

    List<sirenum__Site__c> sitesList = [
      SELECT id, name, sirenum__Operating_Company__c
      FROM sirenum__Site__c
      WHERE id = :siteId AND sirenum__Operating_Company__c = :accID
    ];

    System.debug('sitesList--->>>' + sitesList);
    List<sirenum__Timesheet__c> timeSheetLists;
    if (sitesList != null && sitesList.size() > 0) {
      System.debug(timesheet);
      if (timesheet != '') {
        System.debug('if');
        timeSheetLists = [
          SELECT
            Id,
            IP_Client_Invoice_PO__c,
            WeekendingPortal__c,
            Name,
            sirenum__Total_Charge__c,
            sirenum__Worker__r.Name,
            IP_StandardWeeklyNumberID__c,
            sirenum__Site__r.Name,
            sirenum__Week_Ending__c,
            sirenum__Total_Hours__c,
            sirenum__Team__c,
            sirenum__Team__r.Name
          FROM sirenum__Timesheet__c
          WHERE
            sirenum__Site__c IN :sitesList
            AND IP_StandardWeeklyNumberID__c = :timesheet
            AND sirenum__Week_Ending__c >= LAST_N_WEEKS:3
            AND sirenum__Week_Ending__c <= TODAY
            AND Id IN (
              SELECT sirenum__Timesheet__c
              FROM sirenum__Timesheet_Line__c
              WHERE IP_Locktimesheet__c = TRUE
            )
          ORDER BY sirenum__Week_Ending__c ASC
        ];
      } else {
        System.debug('else');
        timeSheetLists = [
          SELECT
            Id,
            WeekendingPortal__c,
            Name,
            sirenum__Total_Charge__c,
            sirenum__Worker__r.Name,
            IP_StandardWeeklyNumberID__c,
            sirenum__Site__r.Name,
            sirenum__Week_Ending__c,
            sirenum__Total_Hours__c,
            sirenum__Team__c,
            sirenum__Team__r.Name
          FROM sirenum__Timesheet__c
          WHERE
            sirenum__Site__c IN :sitesList
            AND sirenum__Week_Ending__c >= LAST_N_WEEKS:3
            AND sirenum__Week_Ending__c <= TODAY
            AND Id IN (
              SELECT sirenum__Timesheet__c
              FROM sirenum__Timesheet_Line__c
              WHERE IP_Locktimesheet__c = TRUE
            )
          ORDER BY sirenum__Week_Ending__c ASC
        ];
      }

      System.debug('timeSheetLists: ' + timeSheetLists);
    }

    return timeSheetLists;
  }

  @Auraenabled
  public static List<Contact> getContactList() {
    System.debug('****Method 2***');
    Id loggedInUserId = UserInfo.getUserId();
    User u = [
      SELECT id, ContactId, contact.AccountId
      FROM User
      WHERE id = :loggedInUserId
      LIMIT 1
    ];
    set<Id> siteId = new Set<ID>();

    for (Contact_Site_link__c lstContactList : [
      SELECT
        Id,
        Account__c,
        IP_Site__c,
        IP_Site__r.id,
        IP_Contact__c,
        IP_PortalType__c
      FROM Contact_Site_link__c
      WHERE
        IP_Contact__r.Id = :u.contactId
        AND Account__r.Id = :u.contact.AccountId
        AND IP_PortalType__c != NULL
    ]) {
      siteId.add(lstContactList.IP_Site__c);
    }
    if (u.contactId != null) {
      //  Contact cont = [SELECT id,AccountId FROM Contact WHERE id = :u.contactId];//WHERE id = :u.contactId];// '0030E00000HEQJY'];
      //    System.debug('cont--->>>'+cont);
      List<sirenum__Site__c> sitesList = [
        SELECT id, sirenum__Operating_Company__c
        FROM sirenum__Site__c
        WHERE Id = :siteId
      ];
      Map<Id, sirenum__Site__c> accountIdTositeMap = new Map<Id, sirenum__Site__c>();
      for (sirenum__Site__c s : sitesList) {
        accountIdTositeMap.put(s.sirenum__Operating_Company__c, s);
      }
      List<Contact> contList = [
        SELECT id, Name, AccountId
        FROM Contact
        WHERE AccountId IN :accountIdTositeMap.keySet()
      ];
      return contList;
    }
    return null;
  }

  @AuraEnabled
  public static String fetchUser() {
    return userinfo.getName();
  }

  @AuraEnabled
  public static List<Portal_V2_SM_Adjust_Columns__mdt> fetchAdjustableColumns() {
    List<Portal_V2_SM_Adjust_Columns__mdt> theCustomMetadata = [
      SELECT
        DeveloperName,
        MasterLabel,
        Display_Order__c,
        Field_API_Name__c,
        Selected_By_Default__c,
        Display_in_mobile__c,
        Field_Display_Type__c,
        Filterable__c,
        Filter_Type__c
      FROM Portal_V2_SM_Adjust_Columns__mdt
      ORDER BY Display_Order__c ASC
    ];
    return theCustomMetadata;
  }

  @AuraEnabled
  public static List<sirenum__Timesheet__c> getsearchResult(
    List<String> siteIds,
    String candidateId,
    String timeSheetId,
    String weekEndDate
  ) {
    /*
        String query = 'SELECT Id,IP_Status__c,IP_Client_Invoice_PO__c,WeekendingPortal__c,Formula_total_charge__c,sirenum__Total_Charge__c,Name,IP_StandardWeeklyNumberID__c,sirenum__Worker__c,sirenum__Worker__r.Name, sirenum__Site__c,sirenum__Site__r.Name,'+ 
                        'sirenum__Week_Ending__c,sirenum__Total_Hours__c,sirenum__Team__c,sirenum__Team__r.Name,Created_Date_Time__c '+  
                        'FROM sirenum__Timesheet__c WHERE Id in (Select sirenum__Timesheet__c from sirenum__Timesheet_Line__c where IP_Locktimesheet__c = True) LIMIT 50';
		return (List<sirenum__Timesheet__c>)Database.query(query);
		*/

    List<sirenum__Timesheet__c> sobjList = TimeSheetFilters.getsearchResult(
      siteIds,
      candidateId,
      timeSheetId,
      weekEndDate
    );
    System.debug('sobjList--->>>' + sobjList);
    return sobjList;
  }

  @AuraEnabled
  public static List<sirenum__Timesheet__c> getsearchResult(
    String siteId,
    String candidateId,
    String timeSheetId,
    String weekEndDate
  ) {
    List<sirenum__Timesheet__c> sobjList = TimeSheetFilters.getsearchResult(
      siteId,
      candidateId,
      timeSheetId,
      weekEndDate
    );

    System.debug('sobjList--->>>' + sobjList);
    return sobjList;
  }

  @AuraEnabled
  public static List<sirenum__Timesheet__c> getsearchResultFromSiteList(
    List<String> siteId,
    String candidateId,
    String timeSheetId,
    String weekEndDate
  ) {
    /*
        String query = 'SELECT Id,IP_Status__c,IP_Client_Invoice_PO__c,WeekendingPortal__c,Formula_total_charge__c,sirenum__Total_Charge__c,Name,IP_StandardWeeklyNumberID__c,sirenum__Worker__c,sirenum__Worker__r.Name, sirenum__Site__c,sirenum__Site__r.Name,'+ 
                        'sirenum__Week_Ending__c,sirenum__Total_Hours__c,sirenum__Team__c,sirenum__Team__r.Name,Created_Date_Time__c '+  
                        'FROM sirenum__Timesheet__c WHERE Id in (Select sirenum__Timesheet__c from sirenum__Timesheet_Line__c where IP_Locktimesheet__c = True) LIMIT 50';
		return (List<sirenum__Timesheet__c>)Database.query(query);
		*/

    List<sirenum__Timesheet__c> sobjList = TimeSheetFilters.getsearchResultFromSiteList(
      siteId,
      candidateId,
      timeSheetId,
      weekEndDate
    );
    System.debug('sobjList--->>>' + sobjList);
    return sobjList;
  }

  @AuraEnabled
  public static List<sirenum__Timesheet__c> getTimesheetsToDownload(
    String siteId
  ) {
    System.debug('**** Getting all Timesheets by site to download ***');
    if (String.isBlank(siteId)) {
      System.debug('Site Id is mandatory but it is >>> ' + siteId);
      throw new AuraHandledException(
        'Site Id is mandatory but it is >>> ' + siteId
      );
    } else {
      return [
        SELECT
          Id,
          IP_Client_Invoice_PO__c,
          WeekendingPortal__c,
          Formula_total_charge__c,
          sirenum__Total_Charge__c,
          Name,
          IP_StandardWeeklyNumberID__c,
          sirenum__Worker__c,
          sirenum__Worker__r.Name,
          sirenum__Site__c,
          sirenum__Site__r.Name,
          sirenum__Week_Ending__c,
          sirenum__Total_Hours__c,
          sirenum__Team__c,
          sirenum__Team__r.Name
        FROM sirenum__Timesheet__c
        WHERE
          Id IN (
            SELECT sirenum__Timesheet__c
            FROM sirenum__Timesheet_Line__c
            WHERE
              IP_Locktimesheet__c = TRUE
              AND sirenum__Timesheet__r.sirenum__Site__c = :siteId
          )
      ];
    }
  }
}