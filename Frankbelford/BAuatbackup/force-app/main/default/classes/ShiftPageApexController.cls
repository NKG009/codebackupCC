public with sharing class ShiftPageApexController {
  @AuraEnabled
  public static String getbreaks(Id shiftid) {
    List<sirenum__Shift__c> shiftlist = [
      SELECT sirenum__Team__c, sirenum__Site__c
      FROM sirenum__Shift__c
      WHERE id = :shiftid
    ];
    List<sirenum__Break_definition__c> brkdef = [
      SELECT sirenum__Minimum_shift_length__c
      FROM sirenum__Break_definition__c
      WHERE
        sirenum__Site__c = :shiftlist[0].sirenum__Site__c
        AND sirenum__Team__c = :shiftlist[0].sirenum__Team__c
    ];
    String shiftlenght;
    if (brkdef.size() > 0) {
      shiftlenght = String.valueOf(brkdef[0].sirenum__Minimum_shift_length__c);
    } else {
      shiftlenght = '0';
    }
    system.debug('@shiftlenght ' + shiftlenght);
    return shiftlenght;
  }

  @AuraEnabled
  public static String sendEmail(String recordId, String QueryData) {
    List<sirenum__Shift__c> shiftlist = [
      SELECT
        Id,
        sirenum__site__r.GlobalClientName__r.Name,
        sirenum__Placement__r.IP_Consultant1LookupSplitShare__c,
        sirenum__Contact__c,
        IP_CandidateApproved__c,
        sirenum__Contact__r.FirstName,
        Break_Length__c,
        sirenum__Contact__r.name,
        sirenum__Contact__r.Email,
        sirenum__Placement__r.IP_Consultant1LookupSplitShare__r.name,
        sirenum__Placement__r.IP_Consultant1LookupSplitShare__r.email,
        sirenum__Actual_Start_Time__c,
        sirenum__Actual_End_Time__c,
        sirenum__Break_Length__c,
        sirenum__Scheduled_Start_Time__c,
        EndTime__c,
        Createddate,
        Starttime__c,
        sirenum__Scheduled_End_Time__c,
        sirenum__Team__r.name,
        sirenum__Site__r.name
      FROM sirenum__Shift__c
      WHERE id = :recordId
    ];
    Id templateId = [
      SELECT id, name
      FROM EmailTemplate
      WHERE developername = 'Candidate_Portal_Confirm_My_Hours'
    ]
    .id;

    System.debug('Data ' + QueryData);
    String status;
    String starttime = String.valueof(
      shiftlist[0].sirenum__Scheduled_Start_Time__c
    );
    string endtime = String.valueof(
      shiftlist[0].sirenum__Scheduled_End_Time__c
    );
    if (shiftlist.size() > 0) {
      /*
Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
email.setSubject('Confirm my hours query');
email.setTargetObjectId(shiftlist[0].sirenum__Contact__c);
email.setPlainTextBody('Hi '+shiftlist[0].sirenum__Contact__r.firstname +','+'\n'+'\n'+
'Thank you for your recent query regarding working hours for the placement ' + shiftlist[0].sirenum__Team__r.name + ' ,for '+ shiftlist[0].sirenum__site__r.GlobalClientName__r.Name + ' at '+ shiftlist[0].sirenum__site__r.Name+ ', '+ starttime + 'and ' + endtime +'\n\n'+
'This query has now been passed to Consultant, ' + shiftlist[0].sirenum__Placement__r.IP_Consultant1LookupSplitShare__r.name + ', who will be in touch very soon to help resolve your query.' +'\n\n'+
'Best Rgards,'+'\n'+
'Customer Support.'
);  
System.debug('email '+email); 
System.debug('recepent '+shiftlist[0].sirenum__Placement__r.IP_Consultant1LookupSplitShare__c);
//email.setSenderDisplayName(UserInfo.getFirstName());
email.saveAsActivity = false;
// Sends the email
*/

      Contact con = [
        SELECT
          id,
          Owner.FirstName,
          Owner.Name,
          FirstName,
          LastName,
          Name,
          IP_TempestDepartment__c,
          Email
        FROM Contact
        WHERE id = :shiftlist[0].sirenum__Contact__c
      ];
      String department = con.IP_TempestDepartment__c;
      IP_Shift_Template__c shiftemp = IP_Shift_Template__c.getValues(
        department
      );
      String BranchUserEmail = shiftemp.Email__c;
      system.debug('Depttt' + department);
      OrgWideEmailAddress owd = [
        SELECT id, DisplayName, Address
        FROM OrgWideEmailAddress
        WHERE Address = 'no.reply@bluearrow.co.uk'
      ];
      List<OrgWideEmailAddress> owd1;
      if (shiftemp != null) {
        owd1 = [
          SELECT id, DisplayName, Address
          FROM OrgWideEmailAddress
          WHERE Address = :shiftemp.Email__c
        ];
        system.debug('OWD ID--->' + owd1);
      }
      User usr = new User();
      if (
        shiftlist[0].sirenum__Contact__r.Email != null && !test.isRunningTest()
      ) {
        usr = [
          SELECT id
          FROM User
          WHERE email = :shiftlist[0].sirenum__Contact__r.Email
          LIMIT 1
        ];
      }
      String targetObjid = '';
      if (usr.Id != null) {
        targetObjid = usr.Id;
      } else {
        targetObjid = shiftlist[0].sirenum__Contact__c;
      }
      System.debug('Debug log for usr.Id: ' + usr.Id);
      Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
      email.setTargetObjectId(targetObjid);
      email.setTemplateId(templateId);
      email.setWhatid(shiftlist[0].id);
      email.saveAsActivity = false;
      if (owd1.size() > 0) {
        email.setOrgWideEmailAddressId(owd1[0].Id);
      } else {
        email.setOrgWideEmailAddressId(owd.Id);
      }

      if (!Test.isRunningTest()) {
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
      }
      Task tsk = new Task();
      tsk.OwnerID = shiftlist[0]
        .sirenum__Placement__r.IP_Consultant1LookupSplitShare__c;
      tsk.whatid = shiftlist[0].id;
      tsk.Subject = 'Confirm my hours query';
      tsk.whoid = shiftlist[0].sirenum__contact__c;
      tsk.Description = QueryData;
      insert tsk;
    }
    return status;
  }

  @AuraEnabled
  public static List<sirenum__Shift__c> getdetailShifts(String shiftId) {
    List<sirenum__Shift__c> shiftlist = [
      SELECT
        Id,
        Total_Shift_BreakLength__c,
        Break_from_Brekdef__c,
        Shift_Length_from_Break__c,
        TestField__c,
        IP_CandidateApproved__c,
        IP_Status__c,
        sirenum__Actual_Start_Time__c,
        Break_Length__c,
        sirenum__Actual_End_Time__c,
        sirenum__Break_Length__c,
        sirenum__Scheduled_Start_Time__c,
        EndTime__c,
        Createddate,
        Starttime__c,
        sirenum__Scheduled_End_Time__c,
        sirenum__Team__r.name,
        sirenum__Site__r.name
      FROM sirenum__Shift__c
      WHERE id = :shiftId
    ];
    system.debug('shiftlist ' + shiftlist);

    return shiftlist;
  }

  @AuraEnabled
  public static List<sirenum__Shift__c> getShiftsByUserAccount(
    Id contactId,
    List<Id> siteId
  ) {
    try {
      System.debug(UserInfo.getUserId());
      System.debug(siteId);
      User activeUser = [
        SELECT ContactId
        FROM User
        WHERE ID = :UserInfo.getUserId()
      ];
      String userContactId = activeUser.ContactId;

      Id idToUse = contactId != null ? contactId : userContactId;
      Contact userContact = [
        SELECT Id, AccountId
        FROM Contact
        WHERE Id = :idToUse
      ];

      system.debug('contactid ' + userContact);
      DateTime currentTime = DateTime.now();

      List<sirenum__Shift__c> shifts = new List<sirenum__Shift__c>();
      shifts = [
        SELECT
          Id,
          sirenum__Scheduled_Start_Time__c,
          sirenum__Scheduled_End_Time__c,
          sirenum__Team__r.sirenum__Job_Type__r.Name,
          sirenum__Team__r.Name,
          sirenum__Site__r.Name,
          sirenum__Contact__r.Name,
          sirenum__IsShiftDemand__c,
          sirenum__Broadcasts__c,
          sirenum__AssignedShifts__c,
          Remaining_Shifts__c,
          (
            SELECT
              Id,
              sirenum__Scheduled_Start_Time__c,
              sirenum__Scheduled_End_Time__c,
              sirenum__Contact__c,
              sirenum__Team__r.sirenum__Job_Type__r.Name,
              sirenum__Team__r.Name,
              sirenum__Site__r.Name,
              sirenum__Contact__r.Name
            FROM sirenum__Shifts__r
            WHERE
              sirenum__Scheduled_Start_Time__c >= :currentTime
              AND sirenum__Team__r.sirenum__Account__r.sirenum__Client__c = :userContact.AccountId
              AND IP_Status__c != 'Processed'
              AND sirenum__Cancelled__c = FALSE
              AND sirenum__Site__c IN :siteId
          ),
          (SELECT Id, sirenum__Rank__c FROM Rankings__r)
        FROM sirenum__Shift__c
        WHERE
          sirenum__Scheduled_Start_Time__c >= :currentTime
          AND sirenum__Team__r.sirenum__Account__r.sirenum__Client__c = :userContact.AccountId
          AND IP_Status__c != 'Processed'
          AND sirenum__Cancelled__c = FALSE
          AND sirenum__Site__c IN :siteId
          AND sirenum__ShiftDemand__c = NULL
        ORDER BY sirenum__Scheduled_Start_Time__c ASC
      ];

      return shifts;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled
  public static List<sirenum__Shift__c> getPastShiftsByUserAccount(
    Id contactId,
    List<Id> siteId,
    String timescale
  ) {
    try {
      Integer parsedTimescale;
      //Parse the date to look back to
      if (timescale != '1 Week') {
        parsedTimescale = Integer.valueOf(timescale);
      }
      Date lookbackDate = timescale == '1 Week'
        ? Date.Today().addDays(-7)
        : Date.Today().addMonths(-parsedTimescale);
      System.debug(UserInfo.getUserId());
      System.debug(siteId);
      User activeUser = [
        SELECT ContactId
        FROM User
        WHERE ID = :UserInfo.getUserId()
      ];
      String userContactId = activeUser.ContactId;

      Id idToUse = contactId != null ? contactId : userContactId;
      Contact userContact = [
        SELECT Id, AccountId
        FROM Contact
        WHERE Id = :idToUse
      ];

      system.debug('contactid ' + userContact);
      DateTime currentTime = DateTime.now();

      List<sirenum__Shift__c> shifts = new List<sirenum__Shift__c>();
      shifts = [
        SELECT
          Id,
          sirenum__Scheduled_Start_Time__c,
          sirenum__Scheduled_End_Time__c,
          sirenum__Team__r.sirenum__Job_Type__r.Name,
          sirenum__Team__r.Name,
          sirenum__Site__r.Name,
          sirenum__Contact__r.Name,
          sirenum__IsShiftDemand__c,
          sirenum__Broadcasts__c,
          Remaining_Shifts__c,
          sirenum__AssignedShifts__c,
          (
            SELECT
              Id,
              sirenum__Scheduled_Start_Time__c,
              sirenum__Scheduled_End_Time__c,
              sirenum__Team__r.sirenum__Job_Type__r.Name,
              sirenum__Team__r.Name,
              sirenum__Site__r.Name,
              sirenum__Contact__r.Name
            FROM sirenum__Shifts__r
            WHERE
              sirenum__Team__r.sirenum__Account__r.sirenum__Client__c = :userContact.AccountId
              AND IP_Status__c != 'Processed'
              AND sirenum__Cancelled__c = FALSE
              AND sirenum__Site__c IN :siteId
          ),
          (SELECT Id, sirenum__Rank__c FROM Rankings__r)
        FROM sirenum__Shift__c
        WHERE
          sirenum__Scheduled_Start_Time__c < :currentTime
          AND sirenum__Scheduled_Start_Time__c > :lookbackDate
          AND sirenum__Team__r.sirenum__Account__r.sirenum__Client__c = :userContact.AccountId
          // IP_Status__c !='Processed' AND
          AND sirenum__Cancelled__c = FALSE
          AND sirenum__Site__c IN :siteId
          AND sirenum__ShiftDemand__c = NULL
        ORDER BY sirenum__Scheduled_Start_Time__c ASC
      ];

      return shifts;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled(cacheable=false)
  public static Map<Id, List<sirenum__Ranking__c>> getRatings(
    List<Id> contactIds
  ) {
    try {
      Map<Id, List<sirenum__Ranking__c>> outputMap = new Map<Id, List<sirenum__Ranking__c>>();
      List<sirenum__Ranking__c> selectedRatings = [
        SELECT Id, sirenum__Contact__c, sirenum__Score__c
        FROM sirenum__Ranking__c
        WHERE sirenum__Contact__c IN :contactIds
      ];

      for (Sirenum__Ranking__c rating : selectedRatings) {
        if (!outputMap.keySet().contains(rating.sirenum__Contact__c)) {
          outputMap.put(
            rating.sirenum__Contact__c,
            new List<sirenum__Ranking__c>()
          );
        }
        outputMap.get(rating.sirenum__Contact__c).add(rating);
      }
      return outputMap;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled
  public static List<Portal_V2_My_Shifts_Adjust_Columns__mdt> fetchAdjustableColumns() {
    List<Portal_V2_My_Shifts_Adjust_Columns__mdt> customMetadata = [
      SELECT
        DeveloperName,
        MasterLabel,
        Display_Order__c,
        Field_API_Name__c,
        Selected_By_Default__c,
        Table_Type__c,
        View__c,
        Filterable__c,
        Filter_Type__c,
        Type__c,
        Date_Filter_Type__c,
        Rollup_from_children__c,
        Child_Column_Name__c,
        Aggregate_Type__c,
        Include_in_temp_feedback_modal__c
      FROM Portal_V2_My_Shifts_Adjust_Columns__mdt
      ORDER BY Display_Order__c ASC
    ];
    return customMetadata;
  }

  @AuraEnabled
  public static List<sirenum__Shift__c> getShifts() {
    //   String userName = UserInfo.getUserID();
    User activeUser = [
      SELECT ContactId
      FROM User
      WHERE ID = :UserInfo.getUserId()
    ];
    String userEmail = activeUser.ContactId;
    system.debug('contactid ' + userEmail);
    DateTime val = DateTime.now();

    List<sirenum__Shift__c> shiftlist = [
      SELECT
        Id,
        Break_from_Brekdef__c,
        Shift_Length_from_Break__c,
        TestField__c,
        IP_CandidateApproved__c,
        IP_Status__c,
        sirenum__Actual_Start_Time__c,
        Break_Length__c,
        sirenum__Actual_End_Time__c,
        sirenum__Break_Length__c,
        sirenum__Scheduled_Start_Time__c,
        EndTime__c,
        Createddate,
        Starttime__c,
        sirenum__Scheduled_End_Time__c,
        sirenum__Team__r.name,
        sirenum__Site__r.name
      FROM sirenum__Shift__c
      WHERE
        IP_Status__c != 'Processed'
        AND sirenum__Published__c = TRUE
        AND sirenum__Cancelled__c = FALSE
        AND sirenum__Scheduled_Start_Time__c <= :val
        AND sirenum__Contact__c = :userEmail
        AND sirenum__site__r.IP_Timesheet_Method__c = 'eTimesheet'
      ORDER BY sirenum__Scheduled_Start_Time__c ASC
    ];
    system.debug('shiftlist ' + shiftlist);

    return shiftlist;
  }

  @AuraEnabled
  public static sirenum__Shift__c updateshifts(
    sirenum__Shift__c ushift,
    String stime,
    String etime,
    String chargehours
  ) {
    system.debug('%%TIME ' + stime);
    system.debug('%%TIME ' + etime);
    system.debug('%% ' + ushift);
    List<String> stringParts = stime.split(':');
    List<String> stringParts2 = etime.split(':');
    //
    Datetime dt;
    Datetime enddt;
    DateTime updatestart;
    DateTime updateEnd;
    Long dt1Long;
    Long dt2Long;
    if (
      ushift.sirenum__Actual_Start_Time__c != null &&
      ushift.sirenum__Actual_End_Time__c != null
    ) {
      dt = ushift.sirenum__Actual_Start_Time__c;
      enddt = ushift.sirenum__Actual_End_Time__c;
    } else {
      dt = ushift.sirenum__Scheduled_Start_Time__c;
      enddt = ushift.sirenum__Scheduled_End_Time__c;
    }
    updatestart = DateTime.newInstance(
      dt.year(),
      dt.month(),
      dt.day(),
      Integer.valueOf(stringParts[0]),
      Integer.valueOf(stringParts[1]),
      0
    );
    updateEnd = DateTime.newInstance(
      enddt.year(),
      enddt.month(),
      enddt.day(),
      Integer.valueOf(stringParts2[0]),
      Integer.valueOf(stringParts2[1]),
      0
    );

    System.debug('DATETIMEstart ' + updatestart);
    //  System.debug('DATETIMEend '+updateEnd);
    if (updateEnd < updatestart) {
      updateEnd = DateTime.newInstance(
        enddt.year(),
        enddt.month(),
        enddt.day() + 1,
        Integer.valueOf(stringParts2[0]),
        Integer.valueOf(stringParts2[1]),
        0
      );
    } else {
      updateEnd = DateTime.newInstance(
        enddt.year(),
        enddt.month(),
        enddt.day(),
        Integer.valueOf(stringParts2[0]),
        Integer.valueOf(stringParts2[1]),
        0
      );
    }
    System.debug('DATETIMEend2nd ' + updateEnd);
    ushift.sirenum__Actual_Start_Time__c = updatestart;
    ushift.sirenum__Actual_End_Time__c = updateEnd;

    /*    else 
{
dt = ushift.sirenum__Scheduled_Start_Time__c;
enddt = ushift.sirenum__Scheduled_End_Time__c;
updatestart = DateTime.newInstance(dt.year(),dt.month(),dt.day(),Integer.valueOf(stringParts[0]),Integer.valueOf(stringParts[1]),00);
updateEnd = DateTime.newInstance(enddt.year(),enddt.month(),enddt.day(),Integer.valueOf(stringParts2[0]),Integer.valueOf(stringParts2[1]),00);

System.debug('DATETIME '+updatestart);
ushift.sirenum__Scheduled_Start_Time__c=updatestart;
ushift.sirenum__Scheduled_End_Time__c=updateEnd;
}*/

    ushift.TestField__c = chargehours;
    ushift.IP_CandidateApproved__c = true;
    update ushift;

    return ushift;
  }
}