public without sharing class MyShiftController {
  @AuraEnabled
  public static List<sirenum__Shift__c> getShifts(String startdate) {
    //System.debug('startdate'+startdate);
    User activeUser = [
      SELECT ContactId
      FROM User
      WHERE ID = :UserInfo.getUserId()
    ];
    String userEmail = activeUser.ContactId;

    Datetime dt = system.now();
    List<sirenum__Shift__c> returnshift = new List<sirenum__Shift__c>();
    if (startdate != null) {
      if (startdate == 'Today') {
        returnshift = [
          SELECT
            Id,
            sirenum__Directions_to_Site__c,
            RankingStored__c,
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
          WHERE
            sirenum__Published__c = TRUE
            AND sirenum__Cancelled__c = FALSE
            AND IP_Status__c != 'Processed'
            AND sirenum__Contact__c = :userEmail
            AND sirenum__Scheduled_Start_Time__c = Today
          ORDER BY sirenum__Scheduled_Start_Time__c ASC
        ];
      } else if (startdate == 'Tomorrow') {
        returnshift = [
          SELECT
            Id,
            sirenum__Directions_to_Site__c,
            RankingStored__c,
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
          WHERE
            sirenum__Published__c = TRUE
            AND sirenum__Cancelled__c = FALSE
            AND IP_Status__c != 'Processed'
            AND sirenum__Contact__c = :userEmail
            AND sirenum__Scheduled_Start_Time__c > Today
            AND sirenum__Scheduled_Start_Time__c <= NEXT_N_DAYS:1
          ORDER BY sirenum__Scheduled_Start_Time__c ASC
        ];
      } else if (startdate == 'Next_7_days') {
        returnshift = [
          SELECT
            Id,
            sirenum__Directions_to_Site__c,
            RankingStored__c,
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
          WHERE
            sirenum__Published__c = TRUE
            AND sirenum__Cancelled__c = FALSE
            AND IP_Status__c != 'Processed'
            AND sirenum__Contact__c = :userEmail
            AND sirenum__Scheduled_Start_Time__c > Today
            AND sirenum__Scheduled_Start_Time__c <= NEXT_N_DAYS:7
          ORDER BY sirenum__Scheduled_Start_Time__c ASC
        ];
      } else if (startdate == 'Next_30_days') {
        returnshift = [
          SELECT
            Id,
            sirenum__Directions_to_Site__c,
            RankingStored__c,
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
          WHERE
            sirenum__Published__c = TRUE
            AND sirenum__Cancelled__c = FALSE
            AND IP_Status__c != 'Processed'
            AND sirenum__Contact__c = :userEmail
            AND sirenum__Scheduled_Start_Time__c > Today
            AND sirenum__Scheduled_Start_Time__c <= NEXT_N_DAYS:30
          ORDER BY sirenum__Scheduled_Start_Time__c ASC
        ];
      }
    } else {
      returnshift = [
        SELECT
          Id,
          sirenum__Directions_to_Site__c,
          RankingStored__c,
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
        WHERE
          sirenum__Published__c = TRUE
          AND sirenum__Cancelled__c = FALSE
          AND IP_Status__c != 'Processed'
          AND sirenum__Contact__c = :userEmail
          AND sirenum__Scheduled_Start_Time__c >= :dt
          AND sirenum__Scheduled_Start_Time__c <= NEXT_N_DAYS:21
        ORDER BY sirenum__Scheduled_Start_Time__c ASC
      ];
    }
    return returnshift;
  }
  @AuraEnabled
  public static List<sirenum__Shift__c> getCancleShifts(String recordID) {
    system.debug('Found recordID----->' + recordID);
    List<sirenum__Shift__c> returnshift = [
      SELECT
        Id,
        Phonedepartment__c,
        sirenum__Placement__c,
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
      WHERE id = :recordID
    ];
    system.debug('Found returnshift----->' + returnshift);
    sirenum__Placement__c place = [
      SELECT id, sirenum__Site__c, IP_TempestDepartment__c
      FROM sirenum__Placement__c
      WHERE id = :returnshift[0].sirenum__Placement__c
    ];

    String department = String.valueOf(place.IP_TempestDepartment__c);
    if (department != '0000') {
      IP_Shift_Template__c shiftemp = IP_Shift_Template__c.getValues(
        department
      );

      returnshift[0].Phonedepartment__c = shiftemp.Phone__c;
      update returnshift;
    }
    return returnshift;
  }

  @AuraEnabled
  public static List<sirenum__Shift__c> getShiftshistory(String startdate) {
    Datetime dt = system.now();
    User activeUser = [
      SELECT ContactId
      FROM User
      WHERE ID = :UserInfo.getUserId()
    ];
    String userEmail = activeUser.ContactId;
    List<sirenum__Shift__c> returnshift = new List<sirenum__Shift__c>();
    if (startdate != null) {
      if (startdate == 'Today') {
        returnshift = [
          SELECT
            Id,
            RankingStored__c,
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
          WHERE
            sirenum__Published__c = TRUE
            AND sirenum__Cancelled__c = FALSE
            AND IP_Status__c != 'Processed'
            AND sirenum__Contact__c = :userEmail
            AND sirenum__Scheduled_Start_Time__c = Today
            AND sirenum__Scheduled_Start_Time__c < :dt
          ORDER BY sirenum__Scheduled_Start_Time__c DESC
        ];
      } else if (startdate == 'Yesterday') {
        returnshift = [
          SELECT
            Id,
            RankingStored__c,
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
          WHERE
            sirenum__Published__c = TRUE
            AND sirenum__Cancelled__c = FALSE
            AND IP_Status__c != 'Processed'
            AND sirenum__Contact__c = :userEmail
            AND sirenum__Scheduled_Start_Time__c < Today
            AND sirenum__Scheduled_Start_Time__c = Last_N_DAYS:1
          ORDER BY sirenum__Scheduled_Start_Time__c DESC
        ];
      } else if (startdate == 'Last_7_days') {
        returnshift = [
          SELECT
            Id,
            RankingStored__c,
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
          WHERE
            sirenum__Published__c = TRUE
            AND sirenum__Cancelled__c = FALSE
            AND IP_Status__c != 'Processed'
            AND sirenum__Contact__c = :userEmail
            AND sirenum__Scheduled_Start_Time__c < Today
            AND sirenum__Scheduled_Start_Time__c = LAST_N_DAYS:7
          ORDER BY sirenum__Scheduled_Start_Time__c DESC
        ];
      } else if (startdate == 'Last_30_days') {
        returnshift = [
          SELECT
            Id,
            RankingStored__c,
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
          WHERE
            sirenum__Published__c = TRUE
            AND sirenum__Cancelled__c = FALSE
            AND IP_Status__c != 'Processed'
            AND sirenum__Contact__c = :userEmail
            AND sirenum__Scheduled_Start_Time__c < Today
            AND sirenum__Scheduled_Start_Time__c = LAST_N_DAYS:30
          ORDER BY sirenum__Scheduled_Start_Time__c DESC
        ];
      }
    } else {
      returnshift = [
        SELECT
          Id,
          RankingStored__c,
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
        WHERE
          sirenum__Published__c = TRUE
          AND sirenum__Cancelled__c = FALSE
          AND IP_Status__c != 'Processed'
          AND sirenum__Contact__c = :userEmail
          AND sirenum__Scheduled_Start_Time__c < :dt
          AND sirenum__Scheduled_Start_Time__c = LAST_N_DAYS:21
        ORDER BY sirenum__Scheduled_Start_Time__c DESC
      ];
    }
    return returnshift;
  }
  @AuraEnabled
  public static String getuserId() {
    String userId = UserInfo.getUserId();

    return userId;
  }
  @AuraEnabled
  public static void submitRatings(Id shiftID, String selectedRating) {
    sirenum__Shift__c shift = [
      SELECT
        Id,
        sirenum__Site__c,
        RankingStored__c,
        sirenum__Team__c,
        sirenum__Contact__c,
        sirenum__Team__r.sirenum__Rota__c,
        sirenum__Site__r.sirenum__Operating_Company__c
      FROM sirenum__Shift__c
      WHERE id = :shiftID
      LIMIT 1
    ];
    String Rating;
    if (shift.sirenum__Contact__c != null) {
      if (selectedRating == '0' || selectedRating == '1') {
        Rating = 'Unsuitable';
      } else if (selectedRating == '2') {
        Rating = 'Bad';
      } else if (selectedRating == '3') {
        Rating = 'Average';
      } else if (selectedRating == '4') {
        Rating = 'Good';
      } else if (selectedRating == '5') {
        Rating = 'Excellent';
      }

      RecordType rateRec = [
        SELECT Id
        FROM RecordType
        WHERE
          sObjectType = 'sirenum__Ranking__c'
          AND DeveloperName = 'Candidate_Ratings'
      ];
      insert new sirenum__Ranking__c(
        sirenum__Rank__c = Rating,
        recordtypeid = rateRec.id,
        sirenum__Account__c = shift.sirenum__Site__r.sirenum__Operating_Company__c,
        sirenum__Site__c = shift.sirenum__Site__c,
        sirenum__Job_Role__c = shift.sirenum__Team__c,
        sirenum__Rota__c = shift.sirenum__Team__r.sirenum__Rota__c,
        sirenum__Contact__c = shift.sirenum__Contact__c,
        Shift__c = shift.Id
      );
      if (shift.RankingStored__c == null) {
        shift.RankingStored__c = selectedRating;
      }
      update shift;
    }
  }

  @AuraEnabled
  public static void getcancleshift(String recordID,Map<String,Object> params) {
      String cancelRsn = '', supCancelRsn = '';
      if(params != null){
          cancelRsn = params.containsKey('cancelRsn') ? (String)params.get('cancelRsn') : '';
          supCancelRsn = params.containsKey('supCancelRsn') ? (String)params.get('supCancelRsn') : '';
      }
    Id templateIdCancel = [
      SELECT id, name
      FROM EmailTemplate
      WHERE developername = 'Candidate_Portal_Cancel_Placement'
    ]
    .id;

    List<sirenum__Shift__c> returnshift = [
      SELECT
        Id,
        sirenum__Contact__c,
        sirenum__site__r.GlobalClientName__r.Name,
        sirenum__Placement__r.IP_Consultant1LookupSplitShare__c,
        sirenum__Placement__r.IP_Consultant1LookupSplitShare__r.Email,
        sirenum__Placement__r.sirenum__Contact__r.Name,
        sirenum__Placement__r.sirenum__Contact__c,
        sirenum__Contact__r.IP_TempestDepartment__c,
        sirenum__Cancelled__c,
        Cancellation_Reason__c,
        sirenum__Scheduling_Comments__c,
        sirenum__Placement__c,
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
      WHERE id = :recordID
    ];
    Date startdate = System.today();
    Time startTime1 = Time.newInstance(8, 0, 0, 0);
    DateTime businessstartdate = DateTime.newInstance(startdate, startTime1);
    Date enddate = System.today();
    String dayOfWeek = System.now().format('EEEE');
    Time endTime1 = Time.newInstance(17, 30, 0, 0);
    DateTime businessenddate = DateTime.newInstance(enddate, endTime1);
    Datetime dt;
    String department1 = returnshift[0]
      .sirenum__Contact__r.IP_TempestDepartment__c;
    IP_Shift_Template__c shiftemp1 = IP_Shift_Template__c.getValues(
      department1
    );

    OrgWideEmailAddress owd1 = [
      SELECT id, DisplayName, Address
      FROM OrgWideEmailAddress
      WHERE Address = 'no.reply@bluearrow.co.uk'
    ];

    Task tsk = new Task();
    System.debug(
      'Placement Consultant' +
      returnshift[0].sirenum__Placement__r.IP_Consultant1LookupSplitShare__c
    );

    tsk.OwnerID = returnshift[0]
      .sirenum__Placement__r.IP_Consultant1LookupSplitShare__c;
    tsk.WhatId = returnshift[0].id;
    tsk.Subject = 'Candidate cancelled shift';
    tsk.Whoid = returnshift[0].sirenum__Contact__c;
    tsk.Description = 'Shift cancelled by candidate on portal';
    insert tsk;

    for (sirenum__Shift__c sh : returnshift) {
      sh.sirenum__Cancelled__c = true;
      sh.Cancellation_Reason__c = 'Cancelled by Worker';
      sh.sirenum__CancellationReason__c = cancelRsn;
      sh.Supplementary_Cancellation_Reason__c = supCancelRsn;
      sh.sirenum__Scheduling_Comments__c =
        sh.sirenum__Scheduling_Comments__c != null ?  sh.sirenum__Scheduling_Comments__c + 'Cancelled by worker' : 'Cancelled by worker';
    }
    update returnshift;

    dt = System.now();
    String starttime = String.valueof(
      returnshift[0].sirenum__Scheduled_Start_Time__c
    );
    String endtime = String.valueof(
      returnshift[0].sirenum__Scheduled_End_Time__c
    );
    if (!Test.isRunningTest()) {
      Messaging.SingleEmailMessage semail = messaging.renderStoredEmailTemplate(
        templateIdCancel,
        returnshift[0].sirenum__Contact__c,
        returnshift[0].id
      );
      semail.setTreatTargetObjectAsRecipient(false);
      if (dayOfWeek != 'Saturday' && dayOfWeek != 'Sunday' && (dt > businessstartdate && dt < businessenddate)) {
        String department = returnshift[0]
          .sirenum__Contact__r.IP_TempestDepartment__c;
        IP_Shift_Template__c shiftemp = IP_Shift_Template__c.getValues(
          department
        );
        String BranchUserEmail = shiftemp.Email__c;
        String[] toAddresses = new List<String>{
          BranchUserEmail,
          returnshift[0]
            .sirenum__Placement__r.IP_Consultant1LookupSplitShare__r.Email
        };
        semail.setToAddresses(toAddresses);
        System.debug('inside if');
      } else {
        String[] toAddresses1 = new List<String>{
         Label.OutOfHoursBlueArrowEmail
        };
        String[] ccAddress = new String[]{returnshift[0].sirenum__Placement__r.IP_Consultant1LookupSplitShare__r.Email != null ? returnshift[0].sirenum__Placement__r.IP_Consultant1LookupSplitShare__r.Email :''};
        semail.setCcAddresses(ccAddress);
        semail.setToAddresses(toAddresses1);
        system.debug('inside else');
      }
      semail.setOrgWideEmailAddressId(owd1.Id);
      semail.setSubject(
        'Placement cancelled by ' +
        returnshift[0].sirenum__Placement__r.sirenum__Contact__r.Name +
        ' at ' +
        returnshift[0].sirenum__site__r.GlobalClientName__r.Name
      );
      semail.saveAsActivity = false;
      Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ semail });
    }
  }
}