/**
*
* Class Name: TimesheetLineTriggerHandler
* Description: JPC-2570
* Test Class: TestTimesheetLineTrigger
* Created by Espire Team (Ritu Hetawal) Date : 29th April 2020
* Updated by Musaddekur Rahman on 23/09/2020
*/
public class TimesheetLineTriggerHandler{
    
    /*
    * Method Name: handleBeforeInsert
    * Description: To Process all record
    * Parameters : List<sirenum__Timesheet_line__c> listTimesheetLine
    * Return Type: void
    * Date : 29th April 2020
    */
    
    public static void handleBeforeInsert(List<sirenum__Timesheet_line__c> listTimesheetLine) {
        Map<Id,String> mapShiftIdShiftComments = new Map<Id,String>();
        Set<Id> setShiftId = new Set<Id>();
        
        for(sirenum__Timesheet_line__c timesheetLine : listTimesheetLine){
            if(timesheetLine.sirenum__Shift__c!=null){
                setShiftId.add(timesheetLine.sirenum__Shift__c);                
            }
        }
        
        if(!setShiftId.isEmpty()){
            for(sirenum__Shift__c shift : [Select id,sirenum__Client_Comments__c from sirenum__Shift__c 
                                            where ID IN :setShiftId]){
                if(String.IsNotBlank(shift.sirenum__Client_Comments__c) && shift.sirenum__Client_Comments__c.toLowerCase().contains(Label.Client_Comments.toLowerCase())){
                    mapShiftIdShiftComments.put(shift.id,shift.sirenum__Client_Comments__c);
                }
            }
        }
        
        for(sirenum__Timesheet_line__c timesheetLine : listTimesheetLine){
            if(timesheetLine.sirenum__Shift__c!=null && !mapShiftIdShiftComments.isEmpty() 
                && mapShiftIdShiftComments.containsKey(timesheetLine.sirenum__Shift__c)){
                timesheetLine.sirenum__Hours__c = 0.00;
            }
        }
        
    }
    public static void handleupdatesplitting(List<sirenum__Timesheet_Line__c> newValues, Map<id,sirenum__Timesheet_Line__c> Oldvalues)
    {
        Set<id> timesheetset = new Set<id>();
        Set<id> tlset =new Set<id>();
        
        for(sirenum__Timesheet_Line__c tl:newValues)
        {
            if((tl.IP_TempestRateCode__c != Oldvalues.get(tl.id).IP_TempestRateCode__c || tl.sirenum__Rate__c != OldValues.get(tl.id).sirenum__Rate__c || tl.sirenum__Charge__c != OldValues.get(tl.id).sirenum__Charge__c) && tl.IP_Locktimesheet__c == false)
            {
                System.debug('Inside if check');
                tl.IP_TimesheetSplitCheck__c = false;
                tl.IP_OutboundID__c = '';
                tl.IP_SplitTSSet__c = '';
                tlset.add(tl.id);
                timesheetset.add(tl.sirenum__Timesheet__c);
            }
        }
                
        List<sirenum__Timesheet_Line__c> tllist = [Select id,IP_TimesheetSplitCheck__c from sirenum__Timesheet_Line__c where sirenum__Timesheet__c in: timesheetset and id not in:newValues];
        Set<id> originid = new Set<id>();
        
        for(sirenum__Timesheet_Line__c tl1:tllist)
        {
            tl1.IP_TimesheetSplitCheck__c = false;
            tl1.IP_OutboundID__c = '';
            tl1.IP_SplitTSSet__c = '';
            originid.add(tl1.id);
        }
        update tllist;
        
        List<IP_OutboundDataTransfer__c> outdelete = [Select id,IP_OriginRecordID__c,IP_Passed__c from IP_OutboundDataTransfer__c where IP_Passed__c = null and (IP_OriginRecordID__c in :originid OR IP_OriginRecordID__c in:tlset)];
        
        if(outdelete.size()>0)
        {
            delete outdelete;
        }
    }

    /**
     * BUSINESS LOGIC:
     * When a timesheet line is created then the system needs to check the related shift
     *
     * If the shift has a candidate who has a record type of 2nd Tier Candidate (0120Y000000Evac)
     * AND
     * If the shift has the Job Order field populated
     *
     * Then take the current pay rate and do the following calculations:
     * Pay Rate + ((pay rate * Total Supplier % ) + Total Supplier Fee £) - ((pay rate * Managment fee % ) + total managment fee £)
     *
     * @param newTSlineMap Map OF TIMESHEETLINES RECORD
     */
    public static void apply2ndTierPayRate(List<sirenum__Timesheet_Line__c> newTSLines){

        Map<Id, Decimal> shiftPayRate = new Map<Id, Decimal>();
        Id recordTypeId2TC = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('2nd Tier Candidate').getRecordTypeId();

        for(sirenum__Timesheet_Line__c tsl : newTSLines){
            shiftPayRate.put(tsl.sirenum__Shift__c, tsl.sirenum__Rate__c);
        }

        Map<Id, Decimal> calculatedPayRate = new Map<Id, Decimal>();
        for(sirenum__Shift__c shift : [SELECT Name
                                            ,sirenum__JobOrder__c
                                            ,sirenum__Contact__r.RecordTypeId
                                            ,sirenum__JobOrder__r.Management_Fee__c
                                            ,sirenum__JobOrder__r.Management_Fee_hr__c
                                            ,sirenum__JobOrder__r.Total_Supplier_Flat_Fee__c
                                            ,sirenum__JobOrder__r.Total_Supplier_Percentage_Fee__c
                                            ,sirenum__JobOrder__r.sirenum__Account__r.VMS_Client__c
                                            ,sirenum__JobOrder__r.sirenum__Account__r.Management_Fee_hr__c
                                            ,sirenum__JobOrder__r.sirenum__Account__r.Supplier_Flat_Fee__c
                                            ,sirenum__JobOrder__r.sirenum__Account__r.Supplier_Percentage_Fee__c
                                        FROM sirenum__Shift__c
                                        WHERE Id IN :shiftPayRate.keySet()]){

            //@@TODO: clarify whether VMS_Client__c checkbox is checked or not
            if(shift.sirenum__Contact__r.RecordTypeId == recordTypeId2TC
                    && shift.sirenum__JobOrder__c != null
                    && shift.sirenum__JobOrder__r.sirenum__Account__r.VMS_Client__c) {
                        
                Decimal part1 = (shiftPayRate.get(shift.Id) * (shift.sirenum__JobOrder__r.Total_Supplier_Percentage_Fee__c/100))+shift.sirenum__JobOrder__r.Total_Supplier_Flat_Fee__c;
                Decimal part2 = (shiftPayRate.get(shift.Id) * (shift.sirenum__JobOrder__r.Management_Fee__c/100)) + shift.sirenum__JobOrder__r.Management_Fee_hr__c;
                Decimal newPayRate =shiftPayRate.get(shift.Id) + part1 - part2;

                calculatedPayRate.put(shift.Id, newPayRate);
            }
        }

        for(sirenum__Timesheet_Line__c tsLine : newTSLines){
            if(calculatedPayRate.get(tsLine.sirenum__Shift__c) != null &&
                    String.isBlank(tsLine.IP_RateCodes__c)){
                tsLine.sirenum__Rate__c = calculatedPayRate.get(tsLine.sirenum__Shift__c);
            }
        }
    }

    // JIRA Ticket # PTI-576.
    public static void updateHoursOnRateTypeChange(List<sirenum__Timesheet_Line__c> newValues, Map<Id, sirenum__Timesheet_Line__c> oldMap, Boolean isInsert) {
		for(sirenum__Timesheet_Line__c theRecord : newValues) {
            if(
                (isInsert || oldMap.get(theRecord.Id).sirenum__RateType__c != theRecord.sirenum__RateType__c) &&
                (theRecord.sirenum__RateType__c == 'Daily' || theRecord.sirenum__RateType__c == 'Shift')
            ) {
                theRecord.sirenum__Hours__c = 1;
            }
        }
    }
}