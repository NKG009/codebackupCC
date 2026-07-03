public class TimesheetController {
    @AuraEnabled
    public static List<sirenum__Timesheet__c> getTimesheetByUserAccount() {
        try {
            String userContactId = [SELECT ContactId FROM User WHERE ID = :UserInfo.getUserId()].ContactId;
            Contact userContact = [ SELECT Id, AccountId FROM Contact WHERE Id = :userContactId];

            DateTime currentTime = DateTime.now();
            
            // Step 1: Fetch shifts
            List<sirenum__Shift__c> shifts = [
                SELECT Id, sirenum__Scheduled_Start_Time__c, sirenum__Scheduled_End_Time__c,
                sirenum__Team__r.sirenum__Job_Type__r.Name, sirenum__Team__r.Name,
                sirenum__Site__r.Name, sirenum__Contact__r.Name,
                sirenum__IsShiftDemand__c, sirenum__Broadcasts__c,
                sirenum__AssignedShifts__c, Remaining_Shifts__c,
                sirenum__Timesheet_summaries__c // This field contains Timesheet IDs
                FROM sirenum__Shift__c
                WHERE
                sirenum__Team__r.sirenum__Account__r.sirenum__Client__c = :userContact.AccountId
                AND sirenum__Cancelled__c = FALSE
                AND sirenum__ShiftDemand__c = NULL
                ORDER BY sirenum__Scheduled_Start_Time__c ASC
            ];
            System.debug('=====================================shifts===='+shifts);
            // Step 2: Extract Timesheet IDs
            Set<Id> timesheetIds = new Set<Id>();
            
            for (sirenum__Shift__c shift : shifts) {
                if (shift.sirenum__Timesheet_summaries__c != null) {
                    timesheetIds.add(shift.sirenum__Timesheet_summaries__c);
                }
            }
            System.debug('=====================================timesheetIds===='+timesheetIds);
            // Step 3: Fetch Timesheets (Only if there are IDs)
            List<sirenum__Timesheet__c> timesheets = new List<sirenum__Timesheet__c>();
            
            if (!timesheetIds.isEmpty()) {
                timesheets = [ 
                    SELECT Id, Name, sirenum__Worker__c, sirenum__Worker__r.Name, sirenum__Total_Charge__c, 
                    sirenum__Client_Bill__c, sirenum__Site__c,sirenum__Site__r.Name, sirenum__Team__c, sirenum__Team__r.Name,
                    sirenum__Total_Hours__c, sirenum__Week_Ending__c,sirenum__Worker_Bill__c,
                    (SELECT Id, Name,IP_RateCodes__c, sirenum__RateType__c,sirenum__Shift__c, IP_PayrollPresentedRateCode__c, sirenum__Hours__c,sirenum__Charge__c,
                     sirenum__Rate__c 
                     FROM sirenum__Timesheet_Lines__r)
                    
                    FROM sirenum__Timesheet__c
                    WHERE Id IN :timesheetIds
                ];
            }            
            return timesheets;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}