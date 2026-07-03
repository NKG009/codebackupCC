/**
 * Created by mrahman on 2021-04-26.
 */

public with sharing class ClientComApprovedShiftController {
    @AuraEnabled
    public static List<sirenum__Shift__c> getAllApprovedShifts(String siteId, String candidateId){
        List<sirenum__Shift__c> shiftDetails = new List<sirenum__Shift__c>();
        for (sirenum__Shift__c shift : [SELECT Id, sirenum__Contact__c, sirenum__Contact__r.Name, sirenum__Team__c ,sirenum__Team__r.Name
                                                ,sirenum__Placement__r.IP_PurchaseOrderNumber__c
                                                ,TSchShL__c
                                                ,Starttime__c
                                                ,EndTime__c
                                                ,TActShL__c
                                                ,IP_ClientApproved__c
                                                ,IP_ClientRejected__c
                                        		,FORMAT(sirenum__Forecast_Charge__c) ForecastCharge
                                                //,FORMAT(sirenum__Billable_Calculated_Shift_Length__c) TotalHours
                                                ,FORMAT(Billable_hours_minus_breaks__c) TotalHours
                                                ,FORMAT(Scheduled_Start_Date_Display__c) StartDate
                                                ,FORMAT(sirenum__Total_Charge__c) Charge
                                                ,sirenum__Scheduled_Start_Time__c
                                                ,Break_from_Brekdef__c
                                            FROM sirenum__Shift__c
                                            WHERE sirenum__Site__c =: siteId
                                            // AND sirenum__Scheduled_Start_Time__c = LAST_N_WEEKS:12
                                        	AND sirenum__Scheduled_Start_Time__c = LAST_N_DAYS:84
                                            AND sirenum__Timesheet_summaries__c = null
                                            AND sirenum__Allow_charge__c = true
                                            AND sirenum__Allow_pay__c = true
                                        	AND sirenum__Cancelled__c = false
                                            ORDER BY sirenum__Scheduled_Start_Time__c DESC
                                        LIMIT 20]){
            if(String.isBlank(candidateId)){
                shiftDetails.add(shift);
            } else if(candidateId == shift.sirenum__Contact__c) {
                shiftDetails.add(shift);
            }
        }
        return shiftDetails;
    }
}