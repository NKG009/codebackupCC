public class LeaverRequestControllerLightning {
    
    @AuraEnabled
    public static Contact getContact(String contactId){ 
        
        Contact con =[Select id,IP_Allpayprofiles__c,P45_Suppression_Reason__c from Contact where id =:contactId];
        return con;
    }
    
    @AuraEnabled
    public static List<sirenum__Timesheet_Line__c> getTimesheetLines(String contactId){
        
        List<sirenum__Timesheet_Line__c> listTimesheet =[Select id,IP_LastPassedToTempest__c,sirenum__Timesheet__r.sirenum__Worker__c,
                                                    IP_PassToTempest__c,sirenum__Timesheet__r.Name,sirenum__Timesheet__r.IP_StandardWeeklyNumberID__c 
                                                    from sirenum__Timesheet_Line__c where sirenum__Timesheet__r.sirenum__Worker__c=:contactId 
                                                    and ((IP_LastPassedToTempest__c=null and IP_PassToTempest__c = TRUE and IP_Locktimesheet__c = FALSE) OR (IP_PassToTempest__c = TRUE and IP_Locktimesheet__c = FALSE))];
        
        return listTimesheet;
    }
    
    @AuraEnabled
    public static List<sirenum__shift__c> getShifts(String contactId){
        
        Date shiftTimeFrameStart = Date.today().addDays(-Integer.valueOf(Label.ShiftTimeframestart));
        Date shiftTimeFrameEnd = Date.today().addDays(Integer.valueOf(Label.ShiftTimeframeend));
        
        List<sirenum__shift__c> listTimesheet =[Select id,sirenum__Cancelled__c,Name,sirenum__Published__c,sirenum__Timesheet_summaries__c,sirenum__Billable_Calculated_Start_Time__c from sirenum__shift__c where sirenum__Contact__c =:contactId and sirenum__Published__c= TRUE and (sirenum__Cancelled__c=false and sirenum__Timesheet_summaries__c ='') and (sirenum__Billable_Calculated_Start_Time__c = null OR sirenum__Billable_Calculated_Start_Time__c>=:shiftTimeFrameStart OR sirenum__Billable_Calculated_Start_Time__c<=:shiftTimeFrameEnd)];
        
        return listTimesheet;
    }
}