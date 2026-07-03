public without sharing class PortalV2TimesheetsController {
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
    return setToList;
  }

  @AuraEnabled
  public static List<Portal_V2_SM_Adjust_Columns__mdt> fetchAdjustableColumns() {
    List<Portal_V2_SM_Adjust_Columns__mdt> theCustomMetadata = [
      SELECT
        Display_Order__c,
        MasterLabel,
        DeveloperName,
        Field_API_Name__c,
        Selected_By_Default__c,
        Filterable__c,
        Filter_Type__c,
        Display_In_Mobile__c,
        Field_Display_Type__c,
        Display_In_Approved_Shifts_View__c,
        Mobile_Column_Order__c
      FROM Portal_V2_SM_Adjust_Columns__mdt
      ORDER BY Display_Order__c ASC
    ];
    return theCustomMetadata;
  }

  @AuraEnabled
  public static List<sirenum__Shift__c> getAllShiftRecords(
    List<String> siteIds
  ) {
    List<String> theTimesheetFields = fetchTimesheetFields();
    String toBeAddedToQuery = theTimesheetFields.size() > 0
      ? ', ' + String.join(theTimesheetFields, ', ') + ' '
      : '';
    DateTime now = DateTime.now();
     //get current user account
     Id currentUserId = UserInfo.getUserId();
     User currentUser = [SELECT Id, ContactId FROM User WHERE Id =: currentUserId];
     Contact userContact = [SELECT Id, AccountId FROM Contact WHERE Id =: currentUser.ContactId];
     Id accountId = userContact.AccountId;
    System.debug(userContact);
    Id shiftRecordTypeId = Schema.SObjectType.sirenum__Shift__c.getRecordTypeInfosByDeveloperName()
      .get('Shift')
      .getRecordTypeId();

    String theQuery =
      'SELECT Id, IP_ClientRejected__c, IP_ClientApproved__c, sirenum__Team__r.sirenum__Job_Type__c, sirenum__Placement__r.sirenum__Start_Date__c, sirenum__Placement__r.sirenum__End_Date__c, sirenum__Timesheet_summaries__r.sirenum__Week_Ending__c, sirenum__Timesheet_summaries__r.IP_Client_Invoice_PO__c ' +
      toBeAddedToQuery +
      'FROM sirenum__Shift__c WHERE IP_Account__c = :accountId AND sirenum__Site__c IN :siteIds AND sirenum__Published__c = true AND sirenum__Cancelled__c = false and IP_ClientRejected__c = false AND sirenum__Scheduled_Start_Time__c <= :now AND Unfilled_Shift__c = false AND RecordTypeId =:shiftRecordTypeId';
    

    theQuery += ' ORDER BY sirenum__Scheduled_Start_Time__c DESC LIMIT 10000';

    List<sirenum__Shift__c> allShiftRecords = (List<sirenum__Shift__c>) Database.query(
      theQuery
    );

    List<sirenum__Shift__c> toBeApprovedShiftRecords = new List<sirenum__Shift__c>();
    return allShiftRecords;
  }

  @AuraEnabled
  public static String approveRejectShifts(
    List<Id> theShiftIds,
    String theState,
    String rejectionReason
  ) {
    String theResult = 'success';
    try {
      sirenum__Shift__c theShift = null;
      List<sirenum__Shift__c> toBeProcessed = new List<sirenum__Shift__c>();
      //jyothi
      for (sirenum__Shift__c theRecord : [
        SELECT
          Id,
          sirenum__Actual_Start_Time__c,
          sirenum__Actual_End_Time__c,
          sirenum__Scheduled_Start_Time__c,
          sirenum__Scheduled_End_Time__c
        FROM sirenum__Shift__c
        WHERE Id IN :theShiftIds
      ]) {
        theShift = new sirenum__Shift__c(Id = theRecord.Id);
        if (theState == 'approve') {
          theShift.sirenum__Billable_Start_Time__c = theRecord.sirenum__Actual_Start_Time__c !=
            null
            ? theRecord.sirenum__Actual_Start_Time__c
            : theRecord.sirenum__Scheduled_Start_Time__c;
          theShift.sirenum__Billable_End_Time__c = theRecord.sirenum__Actual_End_Time__c !=
            null
            ? theRecord.sirenum__Actual_End_Time__c
            : theRecord.sirenum__Scheduled_End_Time__c;
          theShift.IP_ClientApproved__c = true;
          theShift.IP_ClientRejected__c = false;
          theShift.Approved_By__c = UserInfo.getUserId();
          theShift.Approved_Date_Time__c = System.now();
          theShift.sirenum__Allow_pay__c = true;
          theShift.sirenum__Allow_charge__c = true;
          theShift.sirenum__Actual_Start_Time__c = theRecord.sirenum__Actual_Start_Time__c !=
            null
            ? theRecord.sirenum__Actual_Start_Time__c
            : theRecord.sirenum__Scheduled_Start_Time__c;
          theShift.sirenum__Actual_End_Time__c = theRecord.sirenum__Actual_End_Time__c !=
            null
            ? theRecord.sirenum__Actual_End_Time__c
            : theRecord.sirenum__Scheduled_End_Time__c;
        } else {
          theShift.IP_ClientRejected__c = true;
          theShift.sirenum__Client_Comments__c = rejectionReason;
        }

        toBeProcessed.add(theShift);
      }

      update toBeProcessed;
    } catch (Exception theException) {
      theResult = theException.getMessage();
    }
    return theResult;
  }

  private static Map<Id, Id> getShiftIdAndItsPlacementId(Set<Id> theShiftIds) {
    Map<Id, Id> theShiftIdAndItsPlacementId = new Map<Id, Id>();
    for (sirenum__Shift__c theShift : [
      SELECT sirenum__Placement__c
      FROM sirenum__Shift__c
      WHERE Id IN :theShiftIds AND sirenum__Placement__c != NULL
    ]) {
      theShiftIdAndItsPlacementId.put(
        theShift.Id,
        theShift.sirenum__Placement__c
      );
    }
    return theShiftIdAndItsPlacementId;
  }

  @AuraEnabled
  public static String updateIndividualPO(
    List<sirenum__Shift__c> updatedPONumbers
  ) {
    String theResult = 'success';
    try {
      Map<Id, String> shiftAndItsPONumber = new Map<Id, String>();
      for (sirenum__Shift__c theShift : updatedPONumbers) {
        shiftAndItsPONumber.put(theShift.Id, theShift.Invoice_PO_Optional__c);
      }

      Map<Id, Id> theShiftIdAndItsPlacementId = getShiftIdAndItsPlacementId(
        shiftAndItsPONumber.keySet()
      );
      if (theShiftIdAndItsPlacementId.size() > 0) {
        Map<Id, sirenum__Placement__c> toBeUpdated = new Map<Id, sirenum__Placement__c>();
        for (Id shiftId : theShiftIdAndItsPlacementId.keySet()) {
          toBeUpdated.put(
            theShiftIdAndItsPlacementId.get(shiftId),
            new sirenum__Placement__c(
              Id = theShiftIdAndItsPlacementId.get(shiftId),
              IP_PurchaseOrderNumber__c = shiftAndItsPONumber.get(shiftId)
            )
          );
        }
        update toBeUpdated.values();
      } else {
        theResult = 'No placements records are associated with selected shifts.';
      }
    } catch (Exception theException) {
      theResult = theException.getMessage();
    }
    return theResult;
  }

  @AuraEnabled
  public static String updateBulkPO(List<Id> theShiftIds, String poNumber) {
    String theResult = 'success';
    try {
      Map<Id, Id> theShiftIdAndItsPlacementId = getShiftIdAndItsPlacementId(
        new Set<Id>(theShiftIds)
      );
      if (theShiftIdAndItsPlacementId.size() > 0) {
        Map<Id, sirenum__Placement__c> toBeUpdated = new Map<Id, sirenum__Placement__c>();
        for (Id placementId : theShiftIdAndItsPlacementId.values()) {
          toBeUpdated.put(
            placementId,
            new sirenum__Placement__c(
              Id = placementId,
              IP_PurchaseOrderNumber__c = poNumber
            )
          );
        }
        update toBeUpdated.values();
      } else {
        theResult = 'No placements records are associated with selected shifts.';
      }
    } catch (Exception theException) {
      theResult = theException.getMessage();
    }
    return theResult;
  }

  private static Integer getMinutesToBeAdded(String amendedBreaks) {
    Integer hoursPart = Integer.valueOf(amendedBreaks.substringBefore(':'));
    Integer minutesPart = Integer.valueOf(
      amendedBreaks.substringAfter(':').substringBefore(':00.000')
    );
    return (hoursPart * 60) + minutesPart;
  }

  @AuraEnabled
  public static String amendOneBreakToAllShifts(
    List<Id> theShiftIds,
    String amendedBreaks
  ) {
    String theResult = 'success';
    try {
      Integer minutesToBeAdded = getMinutesToBeAdded(amendedBreaks);

      List<sirenum__Shift_Break__c> toBeCreated = new List<sirenum__Shift_Break__c>();
      List<sirenum__Shift_Break__c> toDelete = new List<sirenum__Shift_Break__c>();
      List<sirenum__Shift__c> shiftsToUpdate = new List<sirenum__Shift__c>();
      List<sirenum__Shift_Break__c> shiftBreaks = null;
      for (sirenum__Shift__c shift : [
        SELECT
          Id,
          Break_Calculation_Start_Time__c,
          (
            SELECT Id, sirenum__Start_Time__c, sirenum__End_Time__c
            FROM sirenum__Shift_Breaks__r
          )
        FROM sirenum__Shift__c
        WHERE Id IN :theShiftIds
      ]) {
        shiftBreaks = shift.sirenum__Shift_Breaks__r;

        // Creating the new shift break.
        toBeCreated.add(
          new sirenum__Shift_Break__c(
            sirenum__Start_Time__c = shift.Break_Calculation_Start_Time__c,
            sirenum__End_Time__c = shift.Break_Calculation_Start_Time__c.addMinutes(
              minutesToBeAdded
            ),
            sirenum__Shift__c = shift.Id,
            sirenum__Paid_Break__c = false
          )
        );
        shiftsToUpdate.add(
          new sirenum__Shift__c(
            Id = shift.Id,
            sirenum__Break_Override__c = true
          )
        );

        // Deleting all existing shift breaks to make way for the up to date one.
        if (!shiftBreaks.isEmpty()) {
          for (sirenum__Shift_Break__c shiftBreak : shiftBreaks) {
            toDelete.add(shiftBreak);
          }
        }
      }

      insert toBeCreated;
      update shiftsToUpdate;
      delete toDelete;
    } catch (Exception theException) {
      theResult = theException.getMessage();
    }
    return theResult;
  }

  @AuraEnabled
  public static String applyAmendedBreakToAllShifts(
    List<sirenum__Shift__c> toBeUpdatedShifts
  ) {
    String theResult = 'success';
    try {
      Map<Id, Integer> minutesToBeAdded = new Map<Id, Integer>();
      for (sirenum__Shift__c theShift : toBeUpdatedShifts) {
        minutesToBeAdded.put(
          theShift.Id,
          getMinutesToBeAdded(theShift.Invoice_PO_Optional__c)
        );
      }

      List<sirenum__Shift_Break__c> toBeCreated = new List<sirenum__Shift_Break__c>();
      List<sirenum__Shift_Break__c> toDelete = new List<sirenum__Shift_Break__c>();
      List<sirenum__Shift__c> shiftsToUpdate = new List<sirenum__Shift__c>();
      List<sirenum__Shift_Break__c> shiftBreaks = null;
      for (sirenum__Shift__c shift : [
        SELECT
          Id,
          Break_Calculation_Start_Time__c,
          (
            SELECT Id, sirenum__Start_Time__c, sirenum__End_Time__c
            FROM sirenum__Shift_Breaks__r
          )
        FROM sirenum__Shift__c
        WHERE Id IN :minutesToBeAdded.keySet()
      ]) {
        shiftBreaks = shift.sirenum__Shift_Breaks__r;

        // Creating the new shift break.
        toBeCreated.add(
          new sirenum__Shift_Break__c(
            sirenum__Start_Time__c = shift.Break_Calculation_Start_Time__c,
            sirenum__End_Time__c = shift.Break_Calculation_Start_Time__c.addMinutes(
              minutesToBeAdded.get(shift.Id)
            ),
            sirenum__Shift__c = shift.Id,
            sirenum__Paid_Break__c = false
          )
        );
        shiftsToUpdate.add(
          new sirenum__Shift__c(
            Id = shift.Id,
            sirenum__Break_Override__c = true
          )
        );

        // Deleting all existing shift breaks to make way for the up to date one.
        if (!shiftBreaks.isEmpty()) {
          for (sirenum__Shift_Break__c shiftBreak : shiftBreaks) {
            toDelete.add(shiftBreak);
          }
        }
      }

      insert toBeCreated;
      update shiftsToUpdate;
      delete toDelete;
    } catch (Exception theException) {
      theResult = theException.getMessage();
    }
    return theResult;
  }

  @AuraEnabled
  public static String applyAmendedShiftHoursToAllShifts(
    List<sirenum__Shift__c> toBeUpdatedShifts
  ) {
    String theResult = 'success';
    String sss;
    try {
      Map<Id, Map<String, String>> minutesToBeAdded = new Map<Id, Map<String, String>>();
      for (sirenum__Shift__c theShift : toBeUpdatedShifts) {
        minutesToBeAdded.put(
          theShift.Id,
          new Map<String, String>{
            'startTime' => theShift.Starttime__c,
            'endTime' => theShift.EndTime__c
          }
        );
      }

      Integer startHoursPart = null;
      Integer startMinutesPart = null;
      Integer endHoursPart = null;
      Integer endMinutesPart = null;
      Time newStartTime = null;
      Time newEndTime = null;
      Date newEndDate = null;

      List<sirenum__Shift__c> toBeUpdated = new List<sirenum__Shift__c>();
      for (sirenum__Shift__c theShift : [
        SELECT
          sirenum__Actual_Start_Time__c,
          sirenum__Actual_End_Time__c,
          sirenum__Scheduled_Start_Time__c,
          sirenum__Scheduled_End_Time__c
        FROM sirenum__Shift__c
        WHERE Id IN :minutesToBeAdded.keySet()
      ]) {
        startHoursPart = Integer.valueOf(
          minutesToBeAdded.get(theShift.Id)
            .get('startTime')
            .substringBefore(':')
        );

        String[] startMinutesSplit = minutesToBeAdded.get(theShift.Id)
          .get('startTime')
          .split(':');
        startMinutesPart = Integer.valueOf(startMinutesSplit[1]);
        newStartTime = Time.newInstance(startHoursPart, startMinutesPart, 0, 0);

        endHoursPart = Integer.valueOf(
          minutesToBeAdded.get(theShift.Id).get('endTime').substringBefore(':')
        );
        String[] endMinutesSplit = minutesToBeAdded.get(theShift.Id)
          .get('endTime')
          .split(':');
        endMinutesPart = Integer.valueOf(endMinutesSplit[1]);
        newEndTime = Time.newInstance(endHoursPart, endMinutesPart, 0, 0);
        newEndDate = newEndTime < newStartTime
          ? theShift.sirenum__Scheduled_End_Time__c.addDays(1).Date()
          : theShift.sirenum__Scheduled_End_Time__c.Date();

        if (
          theShift.sirenum__Scheduled_Start_Time__c.Date()
            .daysBetween(newEndDate) > 1
        ) {
          newEndDate = newEndDate.addDays(-1);
        }
        theShift.sirenum__Actual_Start_Time__c = DateTime.newInstance(
          theShift.sirenum__Scheduled_Start_Time__c.Date(),
          newStartTime
        );
        theShift.sirenum__Actual_End_Time__c = DateTime.newInstance(
          newEndDate,
          newEndTime
        );

        toBeUpdated.add(theShift);
      }

      update toBeUpdated;
    } catch (Exception theException) {
      theResult = theException.getMessage();
    }
    return theResult;
  }
  @AuraEnabled
  public static List<Endorsement__c> getEndorsements(
    List<String> compositeIds
  ) {
    List<Endorsement__c> endorsements = [
      SELECT Id, Composite_Id__c, Candidate__c, Job_Category__c, Site__c
      FROM Endorsement__c
      WHERE Composite_Id__c IN :compositeIds
    ];
    return endorsements;
  }

  @AuraEnabled
  public static Void SendRejectionToOwner(
    String shiftID,
    String comments,
    String combinedComment
  ) {
    if (comments != null && shiftID != null) {
      List<sirenum__Shift__c> returnshift = [
        SELECT
          Id,
          Name,
          sirenum__Site__r.IP_MainContact__r.IP_JobTitle__c,
          sirenum__Contact__c,
          IP_BranchOfOwner__c,
          sirenum__site__r.GlobalClientName__r.name,
          sirenum__Contact__r.FirstName,
          IP_ClientRejected__c,
          sirenum__Placement__r.IP_Consultant1LookupSplitShare__c,
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
          sirenum__Site__c,
          sirenum__Team__r.sirenum__Job_Type__r.Name,
          sirenum__Site__r.Owner.Name,
          sirenum__Site__r.OwnerID,
          sirenum__Site__r.name
        FROM sirenum__Shift__c
        WHERE id = :shiftID
      ];

      System.debug('check shift ID' + returnshift);

      IP_Shift_Template__c branchemail = IP_Shift_Template__c.getValues(
        returnshift[0].IP_BranchOfOwner__c
      );
      List<OrgWideEmailAddress> owd;
      if (branchemail != null) {
        owd = [
          SELECT id, DisplayName, Address
          FROM OrgWideEmailAddress
          WHERE Address = :branchemail.Email__c
        ];
        system.debug('OWD ID--->' + owd);
      }

      Id templateIdReject = [
        SELECT id, name
        FROM EmailTemplate
        WHERE developername = 'Client_Reject_Shift_on_Portal'
      ]
      .id;
      OrgWideEmailAddress owd1 = [
        SELECT id, DisplayName, Address
        FROM OrgWideEmailAddress
        WHERE Address = 'no.reply@bluearrow.co.uk'
      ];

      // System.debug('check Org ID' + owd[0]);

      // for(sirenum__Shift__c sh : returnshift){
      //     sh.IP_ClientRejected__c=true;

      // }
      // update returnshift;
      String startDateString = returnshift[0]
        .sirenum__Scheduled_Start_Time__c.format('dd-MM-YYYY');
      String startTimeString = returnshift[0]
        .sirenum__Scheduled_Start_Time__c.format('kk:mm:ss');
      String endDateString = returnshift[0]
        .sirenum__Scheduled_End_Time__c.format('dd-MM-YYYY');
      String endTimeString = returnshift[0]
        .sirenum__Scheduled_End_Time__c.format('kk:mm:ss');

      System.debug(templateIdReject);
      System.debug(returnshift[0].sirenum__Contact__c);
      System.debug(returnshift[0].id);
      if (!Test.isRunningTest()) {
        Messaging.SingleEmailMessage semail = messaging.renderStoredEmailTemplate(
          templateIdReject,
          returnshift[0].sirenum__Contact__c,
          returnshift[0].id
        );
        if (owd.size() > 0) {
          semail.setOrgWideEmailAddressId(owd[0].Id);
        } else {
          semail.setOrgWideEmailAddressId(owd1.Id);
        }

        semail.setSubject(
          returnshift[0].sirenum__site__r.GlobalClientName__r.name +
          ' has made changes to your recent placement'
        );
        semail.saveAsActivity = false;
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ semail });
      }

      Task tsk = new Task();
      tsk.Ownerid = returnshift[0].sirenum__Site__r.OwnerID;
      tsk.WhatID = returnshift[0].id;
      tsk.Subject = 'Rejected Shift Hours by Client';
      String comments1 =
        'Hi ' +
        returnshift[0].sirenum__site__r.Owner.Name +
        ',' +
        '\n' +
        '\n';
      comments1 +=
        'Shift: ' +
        returnshift[0].Name +
        '\n' +
        'Comments: \n' +
        returnshift[0].sirenum__site__r.GlobalClientName__r.name +
        ' does not agree with the hours submitted for payment for ' +
        returnshift[0].sirenum__Contact__r.FirstName +
        ' at ' +
        returnshift[0].sirenum__site__r.name +
        ', which started at ' +
        startTimeString +
        ' on the ' +
        startDateString +
        ' and ended at ' +
        endTimeString +
        ' on the ' +
        endDateString +
        '.\n' +
        'Reason: \n' +
        comments +
        '.\n\n' +
        'If required please investigate.\n\n';

      comments1 += 'Best regards,' + '\n';
      comments1 += 'Customer Support' + '\n';
      tsk.Description = comments1;
      tsk.WhoID = returnshift[0].sirenum__Contact__c;
      insert tsk;
      System.debug('Task created' + tsk);
    }
  }
}