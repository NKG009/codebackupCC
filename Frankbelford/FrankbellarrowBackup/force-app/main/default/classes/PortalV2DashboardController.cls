public with sharing class PortalV2DashboardController {
  @AuraEnabled
  public static List<sirenum__Timesheet__c> getTotalCostPerWeek(List<Id> siteId) {
    List<sirenum__Timesheet__c> timesheetLst = new List<sirenum__Timesheet__c>();
    //Date thisMonday = System.today().toStartOfWeek();
    timesheetLst = [
      SELECT
        Id,
        sirenum__Client_Bill__c,
        sirenum__Total_Hours__c,
        //sirenum__Forecast_Charge__c,
        //Scheduled_hours_minus_break__c,
        sirenum__Week_Ending__c
      FROM sirenum__Timesheet__c
      WHERE
        sirenum__Site__c IN :siteId
        AND sirenum__Week_Ending__c >= LAST_N_WEEKS:4 order by sirenum__Week_Ending__c asc
        //AND sirenum__Date__c < :thisMonday order by sirenum__Date__c asc
    ];

    return timesheetLst;
    /*List<sirenum__Shift__c> shiftList = new List<sirenum__Shift__c>();
    Date thisMonday = System.today().toStartOfWeek();
    shiftList = [
      SELECT
        Id,
        sirenum__Timesheet_summaries__r.sirenum__Client_Bill__c,
        sirenum__Timesheet_summaries__r.sirenum__Total_Hours__c,
        //sirenum__Forecast_Charge__c,
        //Scheduled_hours_minus_break__c,
        sirenum__Date__c
      FROM sirenum__Shift__c
      WHERE
        sirenum__Site__c IN :siteId
        AND sirenum__Date__c >= LAST_N_WEEKS:4
        AND sirenum__Date__c < :thisMonday order by sirenum__Date__c asc
    ];

    return shiftList;*/
  }

  @AuraEnabled
  public static List<sirenum__Shift_Break__c> getShiftBreaks(Id shiftId) {
    try {
      if (String.isBlank(shiftId))
        return null;
      List<sirenum__Shift_Break__c> output = new List<sirenum__Shift_Break__c>();
      output = [
        SELECT
          Id,
          sirenum__Duration__c,
          sirenum__Start_Time__c,
          sirenum__End_Time__c
        FROM sirenum__Shift_Break__c
        WHERE sirenum__Shift__c = :shiftId
      ];
      return output;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled
  public static DateTime getShiftBreakStartTime(Id shiftId) {
    try {
      if (String.isBlank(shiftId))
        return System.now();
      sirenum__Shift__c output;
      output = [
        SELECT Break_Calculation_Start_Time__c
        FROM sirenum__Shift__c
        WHERE Id = :shiftId
        LIMIT 1
      ];
      return output.Break_Calculation_Start_Time__c;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled
  public static void updateShiftBreak(Id breakId, DateTime newEndTime) {
    try {
      update new sirenum__Shift_Break__c(
        Id = breakId,
        sirenum__End_Time__c = newEndTime
      );
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  //jyothi.start
  @AuraEnabled
  public static Boolean getEnableWorkerEndorsement() {
    USER cUser = [SELECT Id,AccountId,Account.Enable_Worker_Endorsement__c from User Where Id=: UserInfo.getUserId()];
    return cUser.Account.Enable_Worker_Endorsement__c;
  }
  //jyothi.stop
}