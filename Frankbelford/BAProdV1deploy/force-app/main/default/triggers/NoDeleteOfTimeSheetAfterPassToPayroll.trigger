trigger NoDeleteOfTimeSheetAfterPassToPayroll on sirenum__Timesheet__c(
  before delete,
  before update,
  after update
) {
  Payroll_Swtich__c Payroll = Payroll_Swtich__c.getValues('Stoppayroll');
  if (!Payroll.Batch_check__c) {
    Set<id> deleteids = new Set<id>();
    Set<id> timeid = new Set<id>();
    Integer count = 0;

    Boolean checkexe = false;
    Boolean checkpassed = false;
    Set<id> deleterelatedsset = new Set<id>();
    Map<id, id> timesheetout = new Map<id, id>();
    List<IP_OutboundDataTransfer__c> dellist = new List<IP_OutboundDataTransfer__c>();
    Profile adminId = [
      SELECT Id
      FROM Profile
      WHERE Name = 'System Administrator'
      LIMIT 1
    ];
    if (Trigger.IsDelete) {
      List<IP_OutboundDataTransfer__c> existrec = [
        SELECT id, IP_OriginRecordID__c, IP_Passed__c
        FROM IP_OutboundDataTransfer__c
        WHERE
          IP_TransferType__c = 'Timesheet'
          AND IP_Passed__c != NULL
          AND IP_TimesheetID__c IN :Trigger.oldMap.KeySet()
      ];
      if (existrec.size() > 0) {
        for (IP_OutboundDataTransfer__c ot : existrec) {
          timesheetout.put(ot.IP_OriginRecordID__c, ot.id);
        }
      }
      for (sirenum__Timesheet__c sheet : [
        SELECT
          Id,
          Adjustment_Date_Time__c,
          Adjusted_By__c,
          Negative_Timesheet__c,
          Positive_Timesheet__c,
          Timesheet_Adjusted__c,
          Late_Purchase_Order_Number__c,
          Late_Purchase_Order_Submitted__c,
          Late_Purchase_Order_Submitted_By__c,
          Late_Purchase_Order_Submitted_Date__c,
          (
            SELECT
              id,
              IP_OutboundID__c,
              IP_Locktimesheet__c,
              IP_LastPassedtoTempest__c
            FROM sirenum__Timesheet_lines__r
          )
        FROM sirenum__Timesheet__c
        WHERE Id IN :Trigger.oldMap.KeySet()
      ]) {
        sirenum__Timesheet__c oldTimesheet = Trigger.oldMap.get(sheet.Id);
        Boolean AdjustmentDateChanged =
          sheet.Adjustment_Date_Time__c != oldTimesheet.Adjustment_Date_Time__c;
        Boolean LatePONumChanged =
          sheet.Late_Purchase_Order_Number__c !=
          oldTimesheet.Late_Purchase_Order_Number__c;
        Boolean LatePOSubmittedChanged =
          sheet.Late_Purchase_Order_Submitted__c !=
          oldTimesheet.Late_Purchase_Order_Submitted__c;
        Boolean LatePOSubmittedByChanged =
          sheet.Late_Purchase_Order_Submitted_By__c !=
          oldTimesheet.Late_Purchase_Order_Submitted_By__c;
        Boolean LatePOSubmittedDateChanged =
          sheet.Late_Purchase_Order_Submitted_Date__c !=
          oldTimesheet.Late_Purchase_Order_Submitted_Date__c;
        Boolean AdjustedByChanged =
          sheet.Adjusted_By__c != oldTimesheet.Adjusted_By__c;
        Boolean NegativeTimesheetChanged =
          sheet.Negative_Timesheet__c != oldTimesheet.Negative_Timesheet__c;
        Boolean PositiveTimesheetChanged =
          sheet.Positive_Timesheet__c != oldTimesheet.Positive_Timesheet__c;
        Boolean TimesheetAdjustedChanged =
          sheet.Timesheet_Adjusted__c != oldTimesheet.Timesheet_Adjusted__c;

        if (
          AdjustedByChanged ||
          AdjustmentDateChanged ||
          NegativeTimesheetChanged ||
          PositiveTimesheetChanged ||
          TimesheetAdjustedChanged ||
          LatePONumChanged ||
          LatePOSubmittedChanged ||
          LatePOSubmittedByChanged ||
          LatePOSubmittedDateChanged
        ) {
          continue;
        }

        timeid.add(sheet.id);
        if (sheet.sirenum__Timesheet_lines__r.size() > 0) {
          if (UserInfo.getProfileId() != adminId.id) {
            for (
              sirenum__Timesheet_line__c tl : sheet.sirenum__Timesheet_lines__r
            ) {
              if (
                tl.IP_Locktimesheet__c == true ||
                tl.IP_LastPassedtoTempest__C != null ||
                (existrec.size() > 0 && timesheetout.containsKey(tl.id))
              ) {
                Trigger.oldMap
                  .get(sheet.Id)
                  .adderror('Timesheet is locked, data is passed to Payroll');
                count++;
              }
            }
          }

          if (count == 0) {
            for (
              sirenum__Timesheet_line__c tl : sheet.sirenum__Timesheet_lines__r
            ) {
              deleteids.add(tl.IP_OutboundID__c);
            }
          }
        }
        /* else
{
System.debug('Inside else'+sheet.sirenum__Timesheet_lines__r);
for(sirenum__Timesheet_line__c tl: sheet.sirenum__Timesheet_lines__r)
{                deleteids.add(tl.IP_OutboundID__c);
}
}*/
      }
      System.debug('check deleteids' + deleteids);
      if (!deleteids.isEmpty()) {
        dellist = [
          SELECT id
          FROM IP_OutboundDataTransfer__c
          WHERE id IN :deleteids
        ];
      }
      if (dellist.size() > 0) {
        delete dellist;
      }
      List<IP_OutboundDataTransfer__c> checklist = [
        SELECT id, IP_TransferType__c, IP_TimesheetID__c
        FROM IP_OutboundDataTransfer__c
        WHERE IP_TransferType__c = 'Timesheet' AND IP_TimesheetID__c IN :timeid
      ];
      if (checklist.size() == 0) {
        List<IP_OutboundDataTransfer__c> deleterelated = [
          SELECT id
          FROM IP_OutboundDataTransfer__c
          WHERE IP_TimesheetID__c IN :timeid
        ];
        if (deleterelated.size() > 0) {
          // delete deleterelated;
          for (IP_OutboundDataTransfer__c o : deleterelated) {
            deleterelatedsset.add(o.id);
          }
          UpdateRelateddateLink.deleteupdatedata(deleterelatedsset);
        }
      }
    }
    if (Trigger.isUpdate) {
      if (Trigger.isBefore) {
        String clientPortalUserProfile = System.Label.Client_Portal_User_Profile;
        List<PermissionSetAssignment> checkpermission = [
          SELECT Id, PermissionSet.Name, AssigneeId
          FROM PermissionSetAssignment
          WHERE
            AssigneeId = :Userinfo.getUserId()
            AND PermissionSet.Name = 'Emergency_Payroll'
        ];
        if (UserInfo.getProfileId() != adminId.id) {
          Map<id, id> timesheetout1 = new Map<id, id>();
          List<IP_OutboundDataTransfer__c> existrec1 = [
            SELECT id, IP_OriginRecordID__c, IP_Passed__c, IP_TimesheetID__c
            FROM IP_OutboundDataTransfer__c
            WHERE
              IP_TransferType__c = 'Timesheet'
              AND IP_Passed__c != NULL
              AND IP_TimesheetID__c IN :Trigger.oldMap.KeySet()
          ];
          if (existrec1.size() > 0) {
            for (IP_OutboundDataTransfer__c ot : existrec1) {
              timesheetout1.put(ot.IP_TimesheetID__c, ot.id);
            }
          }
          Id profileId = userinfo.getProfileId();
          String profileName = [
            SELECT Id, Name
            FROM Profile
            WHERE Id = :profileId
          ]
          .Name;
          for (sirenum__Timesheet__c sheet : [
            SELECT
              Id,
              IP_Client_Invoice_PO__c,
              (
                SELECT id, IP_Locktimesheet__c, IP_LastPassedtoTempest__C
                FROM sirenum__Timesheet_lines__r
              )
            FROM sirenum__Timesheet__c
            WHERE Id IN :Trigger.oldMap.KeySet()
          ]) {
            sirenum__Timesheet__c oldTimesheet = Trigger.oldMap.get(sheet.Id);
            sirenum__Timesheet__c newTimesheet = Trigger.newMap.get(sheet.Id);
            Boolean AdjustmentDateChanged =
              newTimesheet.Adjustment_Date_Time__c !=
              oldTimesheet.Adjustment_Date_Time__c;
            Boolean AdjustedByChanged =
              newTimesheet.Adjusted_By__c != oldTimesheet.Adjusted_By__c;
            Boolean NegativeTimesheetChanged =
              newTimesheet.Negative_Timesheet__c !=
              oldTimesheet.Negative_Timesheet__c;
            Boolean PositiveTimesheetChanged =
              newTimesheet.Positive_Timesheet__c !=
              oldTimesheet.Positive_Timesheet__c;
            Boolean TimesheetAdjustedChanged =
              newTimesheet.Timesheet_Adjusted__c !=
              oldTimesheet.Timesheet_Adjusted__c;
            Boolean LatePONumChanged =
              newTimesheet.Late_Purchase_Order_Number__c !=
              oldTimesheet.Late_Purchase_Order_Number__c;
            Boolean LatePOSubmittedChanged =
              newTimesheet.Late_Purchase_Order_Submitted__c !=
              oldTimesheet.Late_Purchase_Order_Submitted__c;
            Boolean LatePOSubmittedByChanged =
              newTimesheet.Late_Purchase_Order_Submitted_By__c !=
              oldTimesheet.Late_Purchase_Order_Submitted_By__c;
            Boolean LatePOSubmittedDateChanged =
              newTimesheet.Late_Purchase_Order_Submitted_Date__c !=
              oldTimesheet.Late_Purchase_Order_Submitted_Date__c;

            System.debug('LatePONumChanged ' + LatePONumChanged);
            System.debug('LatePOSubmittedChanged ' + LatePOSubmittedChanged);
            System.debug(
              'LatePOSubmittedByChanged ' + LatePOSubmittedByChanged
            );
            System.debug(
              'LatePOSubmittedDateChanged ' + LatePOSubmittedDateChanged
            );
            if (
              !AdjustedByChanged &&
              !AdjustmentDateChanged &&
              !NegativeTimesheetChanged &&
              !PositiveTimesheetChanged &&
              !TimesheetAdjustedChanged &&
              !LatePONumChanged &&
              !LatePOSubmittedChanged &&
              !LatePOSubmittedByChanged &&
              !LatePOSubmittedDateChanged
            ) {
              if (
                sheet.sirenum__Timesheet_lines__r.size() > 0 &&
                profileName != clientPortalUserProfile
              ) {
                for (
                  sirenum__Timesheet_line__c tl : sheet.sirenum__Timesheet_lines__r
                ) {
                  if (
                    tl.IP_Locktimesheet__c == true ||
                    tl.IP_LastPassedtoTempest__C != null
                  ) {
                    Trigger.NewMap
                      .get(sheet.Id)
                      .adderror(
                        'Timesheet is locked, data is passed to Payroll'
                      );
                    // checkexe = true;
                  }
                }
              }
            }
          }
          for (sirenum__Timesheet__c ts : Trigger.new) {
            sirenum__Timesheet__c oldTimesheet = Trigger.oldMap.get(ts.Id);
            Boolean AdjustmentDateChanged =
              ts.Adjustment_Date_Time__c !=
              oldTimesheet.Adjustment_Date_Time__c;
            Boolean AdjustedByChanged =
              ts.Adjusted_By__c != oldTimesheet.Adjusted_By__c;
            Boolean NegativeTimesheetChanged =
              ts.Negative_Timesheet__c != oldTimesheet.Negative_Timesheet__c;
            Boolean PositiveTimesheetChanged =
              ts.Positive_Timesheet__c != oldTimesheet.Positive_Timesheet__c;
            Boolean TimesheetAdjustedChanged =
              ts.Timesheet_Adjusted__c != oldTimesheet.Timesheet_Adjusted__c;
            Boolean LatePONumChanged =
              ts.Late_Purchase_Order_Number__c !=
              oldTimesheet.Late_Purchase_Order_Number__c;
            Boolean LatePOSubmittedChanged =
              ts.Late_Purchase_Order_Submitted__c !=
              oldTimesheet.Late_Purchase_Order_Submitted__c;
            Boolean LatePOSubmittedByChanged =
              ts.Late_Purchase_Order_Submitted_By__c !=
              oldTimesheet.Late_Purchase_Order_Submitted_By__c;
            Boolean LatePOSubmittedDateChanged =
              ts.Late_Purchase_Order_Submitted_Date__c !=
              oldTimesheet.Late_Purchase_Order_Submitted_Date__c;

            if (
              !AdjustedByChanged &&
              !AdjustmentDateChanged &&
              !NegativeTimesheetChanged &&
              !PositiveTimesheetChanged &&
              !TimesheetAdjustedChanged &&
              !LatePONumChanged &&
              !LatePOSubmittedChanged &&
              !LatePOSubmittedByChanged &&
              !LatePOSubmittedDateChanged
            ) {
              if (
                (ts.IP_EmergencyPull__c !=
                Trigger.oldMap.get(ts.Id).IP_EmergencyPull__c &&
                ts.IP_EmergencyPull__c == true &&
                (existrec1.size() > 0 && timesheetout1.containsKey(ts.id)) &&
                (ts.IP_Client_Invoice_PO__c ==
                Trigger.oldMap.get(ts.Id).IP_Client_Invoice_PO__c)) ||
                ((ts.IP_Client_Invoice_PO__c ==
                Trigger.oldMap.get(ts.Id).IP_Client_Invoice_PO__c) &&
                ts.IP_EmergencyPull__c ==
                Trigger.oldMap.get(ts.Id).IP_EmergencyPull__c &&
                ts.IP_EmergencyPull__c == false &&
                (existrec1.size() > 0 && timesheetout1.containsKey(ts.id)))
              ) {
                Trigger.NewMap
                  .get(ts.Id)
                  .adderror('Timesheet is locked, data is passed to Payroll');
                checkexe = true;
              }
            }
          }
        }
        for (sirenum__Timesheet__c ts : Trigger.new) {
          if (
            (ts.IP_EmergencyPull__c !=
            Trigger.oldMap.get(ts.Id).IP_EmergencyPull__c) &&
            ts.IP_EmergencyPull__c == true
          ) {
            if (checkpermission.size() > 0) {
              System.debug('inside loop required check***');
              ts.Emergency_Pull_User__c = 'Emergency_Payroll';
            }
          }
        }
      }
    }
    if (Trigger.isAFter) {
      if (checkexe == false) {
        Set<id> emergencytl = new Set<id>();
        for (sirenum__Timesheet__c tl : Trigger.new) {
          sirenum__Timesheet__c oldtl = Trigger.oldMap.get(tl.Id);
          if (
            oldtl.IP_EmergencyPull__c != tl.IP_EmergencyPull__c &&
            tl.IP_EmergencyPull__c == true
          ) {
            emergencytl.add(tl.id);
          }
        }
        if (!emergencytl.isEmpty()) {
          TimesheetEmergencyextract.createoutbounddata(emergencytl);
        }
      }
    }
  }
}