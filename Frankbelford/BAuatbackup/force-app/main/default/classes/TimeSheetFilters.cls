public class TimeSheetFilters {
  @Auraenabled
  public static List<sirenum__Site__c> getsitesList() {
    String SetLimitCustomSetting = Impellam_Settings__c.getValues(
        'TimesheetApproval'
      )
      .Limit__c;
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
    //String queryStr = 'select id, name,sirenum__Operating_Company__c from sirenum__Site__c where (IP_MainContact__c =: conID OR Emergency_Contact__c=:conID OR IP_InvoiceContact__c =:conID) AND sirenum__Operating_Company__c =:accID LIMIT '+SetLimitCustomSetting;
    List<sirenum__Site__c> sitesList = [
      SELECT id, name, sirenum__Operating_Company__c
      FROM sirenum__Site__c
      WHERE
        (IP_MainContact__c = :conID
        OR Emergency_Contact__c = :conID
        OR IP_InvoiceContact__c = :conID)
        AND sirenum__Operating_Company__c = :accID
    ];
    //List<sirenum__Site__c> sitesList = Database.query(queryStr);
    System.debug('sitesList--->>>' + sitesList);
    return sitesList;
  }

  @Auraenabled
  public static List<Contact> getContactList() {
    //String SetLimitCustomSetting = Impellam_Settings__c.getValues('TimesheetApproval').Limit__c;
    System.debug('****Method 2***');
    Id loggedInUserId = UserInfo.getUserId();
    User u = [
      SELECT id, ContactId, Contact.AccountId
      FROM User
      WHERE id = :loggedInUserId
      LIMIT 1
    ];
    List<Contact> contList = [
      SELECT id, Name, AccountId
      FROM Contact
      WHERE AccountId = :u.Contact.AccountId
    ];
    System.debug('***contList2*** ' + contList);
    return contList;
  }
  @Auraenabled
  public static Map<id, List<Contact>> getsiteconmap(String sitesId) {
    System.debug('****Method 3***');
    Integer SetLimitCustomSetting = Integer.valueOf(
      Impellam_Settings__c.getValues('TimesheetApproval_ComMap').Limit__c
    );
    Id loggedInUserId = UserInfo.getUserId();
    User u = [
      SELECT id, ContactId
      FROM User
      WHERE id = :loggedInUserId
      LIMIT 1
    ];

    List<sirenum__Timesheet__c> timeSheetLists = [
      SELECT
        Id,
        IP_StandardWeeklyNumberID__c,
        Name,
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
          WHERE IP_Locktimesheet__c = TRUE
        )
        AND sirenum__Site__c = :sitesId
      ORDER BY sirenum__Worker__r.Name ASC
      LIMIT :SetLimitCustomSetting
    ];

    Set<Id> contIdSet = new Set<Id>();

    Map<Id, Set<Id>> siteIdToContIdsMap = new Map<Id, Set<Id>>();
    Set<Id> contIdList;
    for (sirenum__Timesheet__c ts : timeSheetLists) {
      contIdList = siteIdToContIdsMap.get(ts.sirenum__Site__c);
      if (contIdList == null) {
        contIdList = new Set<Id>();
      }
      contIdList.add(ts.sirenum__Worker__c);
      contIdSet.add(ts.sirenum__Worker__c);
      siteIdToContIdsMap.put(ts.sirenum__Site__c, contIdList);
    }
    Map<Id, Contact> contactMap = new Map<Id, Contact>(
      [SELECT Id, Name FROM Contact WHERE id IN :contIdSet]
    );
    Map<Id, List<Contact>> siteIdToContactListMap = new Map<Id, List<Contact>>();
    for (Id siteId : siteIdToContIdsMap.keySet()) {
      List<Contact> contactList = new List<Contact>();
      Set<Id> contIds = siteIdToContIdsMap.get(siteId);

      for (Id cid : contIds) {
        Contact c = contactMap.get(cid);
        contactList.add(c);
      }
      siteIdToContactListMap.put(siteId, contactList);
    }
    System.debug('siteIdToContactListMap--->>>' + siteIdToContactListMap);
    return siteIdToContactListMap;
  }

  @AuraEnabled
  public static List<Contact> getsiteContactMap(String sitesId) {
    System.debug('****Method 3***');
    Integer SetLimitCustomSetting = Integer.valueOf(
      Impellam_Settings__c.getValues('TimesheetApproval_ComMap').Limit__c
    );
    Id loggedInUserId = UserInfo.getUserId();

    //   Map<id,sirenum__Site__c> sitesMap = new Map<id,sirenum__Site__c>([SELECT id,sirenum__Operating_Company__c FROM sirenum__Site__c WHERE
    //        Id=:]);
    //   List<sirenum__Site__c> sitesList = [SELECT id,    sirenum__Operating_Company__c FROM sirenum__Site__c WHERE Id IN :sitesMap.keyset()];

    List<sirenum__Timesheet__c> timeSheetLists = [
      SELECT
        Id,
        IP_StandardWeeklyNumberID__c,
        Name,
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
          WHERE IP_Locktimesheet__c = TRUE
        )
        AND sirenum__Site__c = :sitesId
      ORDER BY sirenum__Week_Ending__c DESC
      LIMIT :SetLimitCustomSetting
    ];

    Set<Id> contIdSet = new Set<Id>();

    Map<Id, Set<Id>> siteIdToContIdsMap = new Map<Id, Set<Id>>();
    Set<Id> contIdList;
    for (sirenum__Timesheet__c ts : timeSheetLists) {
      contIdList = siteIdToContIdsMap.get(ts.sirenum__Site__c);
      if (contIdList == null) {
        contIdList = new Set<Id>();
      }
      contIdList.add(ts.sirenum__Worker__c);
      contIdSet.add(ts.sirenum__Worker__c);
      siteIdToContIdsMap.put(ts.sirenum__Site__c, contIdList);
    }
    Map<Id, Contact> contactMap = new Map<Id, Contact>(
      [SELECT Id, Name FROM Contact WHERE id IN :contIdSet]
    );
    List<Contact> siteIdToContactListMap = new List<Contact>();
    List<Id> contactList = new List<Id>();
    for (Id siteId : siteIdToContIdsMap.keySet()) {
      Set<Id> contIds = siteIdToContIdsMap.get(siteId);

      for (Id cid : contIds) {
        Contact c = contactMap.get(cid);
        contactList.add(c.id);
      }
      // siteIdToContactListMap.add(contactList);
    }
    siteIdToContactListMap = [
      SELECT id, name, AccountId
      FROM Contact
      WHERE id IN :contactList
      ORDER BY Name
    ];
    System.debug('siteIdToContactListMap--->>>' + siteIdToContactListMap);
    return siteIdToContactListMap;
  }

  private static Datetime convertMonthTextToNumber(String myDate) {
    String[] myDateOnly = myDate.split(' ');
    Integer month;
    String strDate = myDateOnly[1];

    if (myDateOnly[myDateOnly.size() - 2] == 'Jan') {
      month = 1;
    } else if (myDateOnly[myDateOnly.size() - 2] == 'Feb') {
      month = 2;
    } else if (myDateOnly[myDateOnly.size() - 2] == 'Mar') {
      month = 3;
    } else if (myDateOnly[myDateOnly.size() - 2] == 'Apr') {
      month = 4;
    } else if (myDateOnly[myDateOnly.size() - 2] == 'May') {
      month = 5;
    } else if (myDateOnly[myDateOnly.size() - 2] == 'Jun') {
      month = 6;
    } else if (myDateOnly[myDateOnly.size() - 2] == 'Jul') {
      month = 7;
    } else if (myDateOnly[myDateOnly.size() - 2] == 'Aug') {
      month = 8;
    } else if (myDateOnly[myDateOnly.size() - 2] == 'Sep') {
      month = 9;
    } else if (myDateOnly[myDateOnly.size() - 2] == 'Oct') {
      month = 10;
    } else if (myDateOnly[myDateOnly.size() - 2] == 'Nov') {
      month = 11;
    } else {
      month = 12;
    }

    Date d = Date.newInstance(
      integer.valueOf('20' + myDateOnly[myDateOnly.size() - 1]),
      month,
      integer.valueOf(myDateOnly[myDateOnly.size() - 3])
    );

    Datetime dt = (Datetime) d;
    //2018-08-10
    System.debug('d: ' + dt.format('yyyy-MM-dd'));
    return dt;
  }

  private static List<String> fetchTimesheetFields() {
    Set<String> theTimesheetFields = new Set<String>();
    for (Portal_V2_SM_Adjust_Columns__mdt theCustomMetadata : [
      SELECT Field_API_Name__c
      FROM Portal_V2_SM_Adjust_Columns__mdt
    ]) {
      theTimesheetFields.add(theCustomMetadata.Field_API_Name__c);
    }

    List<String> setToList = new List<String>();
    setToList.addAll(theTimesheetFields);
    if (Test.isRunningTest()) {
      return new List<String>{ 'Name' };
    }
    return setToList;
  }

  @AuraEnabled
  public static List<sirenum__Timesheet__c> getsearchResult(
    List<String> siteIds,
    String candidateId,
    String timeSheetId,
    String weekEndDate
  ) {
    System.debug('****Method 4***');
    String SetLimitCustomSetting = Impellam_Settings__c.getValues(
        'TimesheetApproval'
      )
      .Limit__c;
    System.debug(
      'IDs-->>>' +
      siteIds +
      ' ' +
      candidateId +
      ' ' +
      timeSheetId +
      ' ' +
      weekEndDate
    );
    Id loggedInUserId = UserInfo.getUserId();
    User u = [
      SELECT id, ContactId
      FROM User
      WHERE id = :loggedInUserId
      LIMIT 1
    ];
    /*  Contact cont = [SELECT id,AccountId FROM Contact WHERE id =:u.contactId];//WHERE id ='0030E00000HEQJY'];//:u.contactId];
        System.debug('cont--->>>'+cont);
        Map<id,sirenum__Site__c> sitesMap = new Map<id,sirenum__Site__c>([SELECT id,sirenum__Operating_Company__c FROM sirenum__Site__c WHERE 
                                             sirenum__Operating_Company__c = :cont.AccountId AND ]);
        Set<Id> siteIdSet = new Set<Id>();
        for(Id sId : sitesMap.keySet()){
            siteIdSet.add(sId);
        } */

    /*
        String query = 'SELECT Id,IP_Status__c,IP_Client_Invoice_PO__c,WeekendingPortal__c,Formula_total_charge__c,sirenum__Total_Charge__c,Name,IP_StandardWeeklyNumberID__c,sirenum__Worker__c,sirenum__Worker__r.Name, sirenum__Site__c,sirenum__Site__r.Name,'+ 
                        'sirenum__Week_Ending__c,sirenum__Total_Hours__c,sirenum__Team__c,sirenum__Team__r.Name '+  
                        'FROM sirenum__Timesheet__c WHERE Id in (Select sirenum__Timesheet__c from sirenum__Timesheet_Line__c where IP_Locktimesheet__c = True) AND ';
		*/

    List<String> theTimesheetFields = fetchTimesheetFields();
    String toBeAddedToQuery = theTimesheetFields.size() > 0
      ? ', ' + String.join(theTimesheetFields, ', ') + ' '
      : '';

    String query =
      'SELECT Id' +
      toBeAddedToQuery +
      'FROM sirenum__Timesheet__c WHERE Id in (Select sirenum__Timesheet__c from sirenum__Timesheet_Line__c where IP_Locktimesheet__c = True) AND ';

    if (siteIds.size() > 0) {
      query = query + 'sirenum__Site__c = :siteIds AND ';
    }
    if (!String.isBlank(candidateId)) {
      query = query + 'sirenum__Worker__c = :candidateId AND ';
    }
    if (!String.isBlank(timeSheetId)) {
      query = query + 'IP_StandardWeeklyNumberID__c = :timeSheetId AND ';
    }
    if (!String.isBlank(weekEndDate)) {
      List<String> DateList = new List<String>();
      DateList = weekEndDate.split('-');

      DateTime startDate;
      DateTime endDate;

      if (DateList != null && DateList.size() > 0) {
        if (DateList.size() > 1)
          endDate = convertMonthTextToNumber(DateList[1]).addDays(1);
        else
          endDate = convertMonthTextToNumber(DateList[0]).addDays(1);
        startDate = convertMonthTextToNumber(DateList[0]);
      }

      Date sDate = startDate.date();
      Date lDate = endDate.date();

      if (sDate != null)
        query = query + ' sirenum__Week_Ending__c >= :sDate AND ';

      if (lDate != null)
        query = query + ' sirenum__Week_Ending__c <=:lDate AND ';

      System.debug('qqq' + query);

      /*        
            if(result){
                String[] weekEndDatesOnly = weekEndDate.split('-');
                dt1  = convertMonthTextToNumber(weekEndDatesOnly[0].trim());
                dt2  = convertMonthTextToNumber(weekEndDatesOnly[1].trim());

                Date weekEndDt = date.valueOf(dt);
                query = query + 'sirenum__Week_Ending__c >= :dt1 AND sirenum__Week_Ending__c <= :dt2';  
                System.debug(query);

            }else{
                dt  = convertMonthTextToNumber(weekEndDate);
                Date weekEndDt = date.valueOf(dt);
                query = query + 'sirenum__Week_Ending__c = :weekEndDt';
            }*/
    }
    if (query.endsWith('AND ')) {
      query = query.removeEnd('AND ');
    }
    if (query.endsWith('WHERE ')) {
      query = query.removeEnd('WHERE ');
    }
    query =
      query +
      ' ORDER BY sirenum__Week_Ending__c DESC LIMIT ' +
      SetLimitCustomSetting;
    System.debug('query--->>>' + query);
    List<sirenum__Timesheet__c> sobjList = (List<sirenum__Timesheet__c>) Database.query(
      query
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
    System.debug('****Method 4***');
    String SetLimitCustomSetting = Impellam_Settings__c.getValues(
        'TimesheetApproval'
      )
      .Limit__c;
    System.debug(
      'IDs-->>>' +
      siteId +
      ' ' +
      candidateId +
      ' ' +
      timeSheetId +
      ' ' +
      weekEndDate
    );
    Id loggedInUserId = UserInfo.getUserId();
    User u = [
      SELECT id, ContactId
      FROM User
      WHERE id = :loggedInUserId
      LIMIT 1
    ];
    /*  Contact cont = [SELECT id,AccountId FROM Contact WHERE id =:u.contactId];//WHERE id ='0030E00000HEQJY'];//:u.contactId];
        System.debug('cont--->>>'+cont);
        Map<id,sirenum__Site__c> sitesMap = new Map<id,sirenum__Site__c>([SELECT id,sirenum__Operating_Company__c FROM sirenum__Site__c WHERE 
                                             sirenum__Operating_Company__c = :cont.AccountId AND ]);
        Set<Id> siteIdSet = new Set<Id>();
        for(Id sId : sitesMap.keySet()){
            siteIdSet.add(sId);
        } */
    String query =
      'SELECT Id,IP_Client_Invoice_PO__c,WeekendingPortal__c,Formula_total_charge__c,sirenum__Total_Charge__c,Name,IP_StandardWeeklyNumberID__c,sirenum__Worker__c,sirenum__Worker__r.Name, sirenum__Site__c,sirenum__Site__r.Name,' +
      'sirenum__Week_Ending__c,sirenum__Total_Hours__c,sirenum__Team__c,sirenum__Team__r.Name ' +
      'FROM sirenum__Timesheet__c WHERE Id in (Select sirenum__Timesheet__c from sirenum__Timesheet_Line__c where IP_Locktimesheet__c = True) AND ';
    if (!String.isBlank(siteId)) {
      query = query + 'sirenum__Site__c = :siteId AND ';
    }
    if (!String.isBlank(candidateId)) {
      query = query + 'sirenum__Worker__c = :candidateId AND ';
    }
    if (!String.isBlank(timeSheetId)) {
      query = query + 'IP_StandardWeeklyNumberID__c = :timeSheetId AND ';
    }
    if (!String.isBlank(weekEndDate)) {
      List<String> DateList = new List<String>();
      DateList = weekEndDate.split('-');

      DateTime startDate;
      DateTime endDate;

      if (DateList != null && DateList.size() > 0) {
        if (DateList.size() > 1)
          endDate = convertMonthTextToNumber(DateList[1]).addDays(1);
        else
          endDate = convertMonthTextToNumber(DateList[0]).addDays(1);
        startDate = convertMonthTextToNumber(DateList[0]);
      }

      Date sDate = startDate.date();
      Date lDate = endDate.date();

      if (sDate != null)
        query = query + ' sirenum__Week_Ending__c >= :sDate AND ';

      if (lDate != null)
        query = query + ' sirenum__Week_Ending__c <=:lDate AND ';

      System.debug('qqq' + query);

      /*        
            if(result){
                String[] weekEndDatesOnly = weekEndDate.split('-');
                dt1  = convertMonthTextToNumber(weekEndDatesOnly[0].trim());
                dt2  = convertMonthTextToNumber(weekEndDatesOnly[1].trim());

                Date weekEndDt = date.valueOf(dt);
                query = query + 'sirenum__Week_Ending__c >= :dt1 AND sirenum__Week_Ending__c <= :dt2';  
                System.debug(query);

            }else{
                dt  = convertMonthTextToNumber(weekEndDate);
                Date weekEndDt = date.valueOf(dt);
                query = query + 'sirenum__Week_Ending__c = :weekEndDt';
            }*/
    }
    if (query.endsWith('AND ')) {
      query = query.removeEnd('AND ');
    }
    if (query.endsWith('WHERE ')) {
      query = query.removeEnd('WHERE ');
    }
    query =
      query +
      ' ORDER BY sirenum__Week_Ending__c DESC LIMIT ' +
      SetLimitCustomSetting;
    System.debug('query--->>>' + query);
    List<sirenum__Timesheet__c> sobjList = (List<sirenum__Timesheet__c>) Database.query(
      query
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
    System.debug('****Method 4***');
    String SetLimitCustomSetting = Impellam_Settings__c.getValues(
        'TimesheetApproval'
      )
      .Limit__c;
    System.debug(
      'IDs-->>>' +
      siteId +
      ' ' +
      candidateId +
      ' ' +
      timeSheetId +
      ' ' +
      weekEndDate
    );
    Id loggedInUserId = UserInfo.getUserId();
    User u = [
      SELECT id, ContactId
      FROM User
      WHERE id = :loggedInUserId
      LIMIT 1
    ];
    /*  Contact cont = [SELECT id,AccountId FROM Contact WHERE id =:u.contactId];//WHERE id ='0030E00000HEQJY'];//:u.contactId];
        System.debug('cont--->>>'+cont);
        Map<id,sirenum__Site__c> sitesMap = new Map<id,sirenum__Site__c>([SELECT id,sirenum__Operating_Company__c FROM sirenum__Site__c WHERE 
                                             sirenum__Operating_Company__c = :cont.AccountId AND ]);
        Set<Id> siteIdSet = new Set<Id>();
        for(Id sId : sitesMap.keySet()){
            siteIdSet.add(sId);
        } */

    /*
        String query = 'SELECT Id,IP_Status__c,IP_Client_Invoice_PO__c,WeekendingPortal__c,Formula_total_charge__c,sirenum__Total_Charge__c,Name,IP_StandardWeeklyNumberID__c,sirenum__Worker__c,sirenum__Worker__r.Name, sirenum__Site__c,sirenum__Site__r.Name,'+ 
                        'sirenum__Week_Ending__c,sirenum__Total_Hours__c,sirenum__Team__c,sirenum__Team__r.Name '+  
                        'FROM sirenum__Timesheet__c WHERE Id in (Select sirenum__Timesheet__c from sirenum__Timesheet_Line__c where IP_Locktimesheet__c = True) AND ';
		*/

    List<String> theTimesheetFields = fetchTimesheetFields();
    String toBeAddedToQuery = theTimesheetFields.size() > 0
      ? ', ' + String.join(theTimesheetFields, ', ') + ' '
      : '';

    String query =
      'SELECT Id' +
      toBeAddedToQuery +
      'FROM sirenum__Timesheet__c WHERE Id in (Select sirenum__Timesheet__c from sirenum__Timesheet_Line__c where IP_Locktimesheet__c = True) AND ';

    if (!siteId.isEmpty()) {
      query = query + 'sirenum__Site__c IN: siteId AND ';
    }
    if (!String.isBlank(candidateId)) {
      query = query + 'sirenum__Worker__c = :candidateId AND ';
    }
    if (!String.isBlank(timeSheetId)) {
      query = query + 'IP_StandardWeeklyNumberID__c = :timeSheetId AND ';
    }
    if (!String.isBlank(weekEndDate)) {
      List<String> DateList = new List<String>();
      DateList = weekEndDate.split('-');

      DateTime startDate;
      DateTime endDate;

      if (DateList != null && DateList.size() > 0) {
        if (DateList.size() > 1)
          endDate = convertMonthTextToNumber(DateList[1]).addDays(1);
        else
          endDate = convertMonthTextToNumber(DateList[0]).addDays(1);
        startDate = convertMonthTextToNumber(DateList[0]);
      }

      Date sDate = startDate.date();
      Date lDate = endDate.date();

      if (sDate != null)
        query = query + ' sirenum__Week_Ending__c >= :sDate AND ';

      if (lDate != null)
        query = query + ' sirenum__Week_Ending__c <=:lDate AND ';

      System.debug('qqq' + query);
    }
    if (query.endsWith('AND ')) {
      query = query.removeEnd('AND ');
    }
    if (query.endsWith('WHERE ')) {
      query = query.removeEnd('WHERE ');
    }
    query =
      query +
      ' ORDER BY sirenum__Week_Ending__c DESC LIMIT ' +
      SetLimitCustomSetting;
    System.debug('query--->>>' + query);
    List<sirenum__Timesheet__c> sobjList = (List<sirenum__Timesheet__c>) Database.query(
      query
    );
    System.debug('sobjList--->>>' + sobjList);
    return sobjList;
  }

  @AuraEnabled
  public static List<sirenum__Timesheet__c> getTimeSheets(String siteId) {
    System.debug('****Method 5site** ' + siteId);
    Integer SetLimitCustomSetting = Integer.valueOf(
      Impellam_Settings__c.getValues('TimesheetApproval_ComMap').Limit__c
    );
    System.debug('****Method 5**');
    Id loggedInUserId = UserInfo.getUserId();
    // set<Id> siteId = new set<ID>();
    User u = [
      SELECT id, contactId, contact.AccountId
      FROM User
      WHERE id = :UserInfo.getUserId()
      LIMIT 1
    ];
    List<sirenum__Timesheet__c> timeSheetLists;
    if (siteId != null) {
      timeSheetLists = [
        SELECT
          Id,
          Name,
          sirenum__Worker__r.Name,
          sirenum__Site__r.Name,
          sirenum__Week_Ending__c,
          sirenum__Total_Hours__c,
          sirenum__Team__c,
          sirenum__Team__r.Name
        FROM sirenum__Timesheet__c
        WHERE sirenum__Site__c = :siteId
        ORDER BY sirenum__Week_Ending__c DESC
        LIMIT :SetLimitCustomSetting
      ];
    }
    System.debug('timeSheetLists--->>>' + timeSheetLists.size());
    return timeSheetLists;
  }

  @AuraEnabled
  public static Map<id, List<sirenum__Timesheet__c>> getContactTimeSheetMap() {
    System.debug('****Method 6***');
    Id loggedInUserId = UserInfo.getUserId();
    User u = [
      SELECT id, ContactId
      FROM User
      WHERE id = :loggedInUserId
      LIMIT 1
    ];
    Contact cont = [SELECT id, AccountId FROM Contact WHERE id = :u.contactId]; //WHERE id ='0030E00000HEQJY'];//:u.contactId];
    System.debug('cont--->>>' + cont);
    Map<id, sirenum__Site__c> sitesMap = new Map<id, sirenum__Site__c>(
      [
        SELECT id, sirenum__Operating_Company__c
        FROM sirenum__Site__c
        WHERE
          (IP_MainContact__c = :cont.id
          OR Emergency_Contact__c = :cont.id
          OR IP_InvoiceContact__c = :cont.id)
          AND sirenum__Operating_Company__c = :cont.AccountId
      ]
    );
    //List<sirenum__Site__c> sitesList = [SELECT id,    sirenum__Operating_Company__c FROM sirenum__Site__c WHERE Id IN :sitesMap.keyset()];
    List<sirenum__Timesheet__c> timeSheetLists = [
      SELECT
        Id,
        WeekendingPortal__c,
        IP_StandardWeeklyNumberID__c,
        Name,
        sirenum__Worker__c,
        sirenum__Worker__r.Name,
        sirenum__Site__c,
        sirenum__Site__r.Name,
        sirenum__Week_Ending__c,
        sirenum__Total_Hours__c,
        sirenum__Team__c,
        sirenum__Team__r.Name
      FROM sirenum__Timesheet__c
      WHERE sirenum__Site__c IN :sitesMap.keyset()
      ORDER BY sirenum__Week_Ending__c DESC
    ];
    Set<Id> contIdSet = new Set<Id>();

    Map<Id, List<sirenum__Timesheet__c>> ContIdToTimeSheetsMap = new Map<Id, List<sirenum__Timesheet__c>>();
    List<sirenum__Timesheet__c> timeSheets;
    for (sirenum__Timesheet__c ts : timeSheetLists) {
      timeSheets = ContIdToTimeSheetsMap.get(ts.sirenum__Worker__c);
      if (timeSheets == null) {
        timeSheets = new List<sirenum__Timesheet__c>();
      }
      timeSheets.add(ts);
      //contIdSet.add(ts.sirenum__Worker__c);
      ContIdToTimeSheetsMap.put(ts.sirenum__Worker__c, timeSheets);
    }
    return ContIdToTimeSheetsMap;
  }
}