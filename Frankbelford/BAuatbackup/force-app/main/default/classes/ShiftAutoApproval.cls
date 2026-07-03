/*** JIRA-1485  Shift Auto Approval Process ***/
/** Date - 11-03-2019 **/
/** This batch will run only on Monday According to the requirement **/
global class ShiftAutoApproval implements Database.Batchable<sObject>
{
    DateTime dateNow=system.now();  
    Date dateToday=system.today();        
    Date DateMonSht1 =dateToday.addDays(-7);
    Date DateSunSht1 =dateToday.addDays(-1);
    Date DateSatSht2 =dateToday.addDays(-9);
    Date DateFriSht2 =dateToday.addDays(-3);
    Date DateSunSht3 =dateToday.addDays(-8);
    Date DateSatSht3 =dateToday.addDays(-2);
     String Scheduledtimestart;
    String Scheduledtimeend;
    String Actualtimeend;
    String Actualtimestart;
    dateTime startDateTime=dateTime.newInstance(DateSatSht2.year(),DateSatSht2.month(),DateSatSht2.day(),00,00,00);
    dateTime endDateTime=dateTime.newInstance(DateSunSht1.year(),DateSunSht1.month(),DateSunSht1.day(),23,59,59);
    Date convertDate;
    Date CheckStartDate;
    Id approvedByUserId = [select id from user  where name ='Ignitesvc' limit 1].Id;
    //
    /** Start Method **/
    //
    global Database.QueryLocator start (Database.BatchableContext BC){    
        String Query ='SELECT id , sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.name ,sirenum__Site__r.IP_Timesheet_Method__c ,sirenum__Site__r.IP_ScheduledAutoApproval__c,'+
            'IP_CandidateApproved__c ,Actuals_confirmed__c ,IP_ClientApproved__c,sirenum__Scheduled_Start_Time__c,sirenum__Scheduled_End_Time__c,'+
            ' sirenum__Actual_Start_Time__c,sirenum__Actual_End_Time__c,sirenum__Billable_Start_Time__c,sirenum__Billable_End_Time__c,IP_ClientRejected__c,'+
            'sirenum__Allow_pay__c,sirenum__Allow_charge__c,Approved_By__c,Approved_Date_Time__c FROM sirenum__Shift__c '+
            'WHERE sirenum__Site__r.IP_Timesheet_Method__c=\'eTimesheet\' AND '+
            'sirenum__Site__r.IP_ScheduledAutoApproval__c=true AND '+
            '(IP_CandidateApproved__c =true OR Actuals_confirmed__c =true OR IP_ClientApproved__c=true) AND IP_ClientRejected__c=false '+
            'AND sirenum__Published__c=true AND sirenum__Cancelled__c=false AND '+
            'sirenum__Scheduled_Start_Time__c != Null AND sirenum__Scheduled_End_Time__c!= Null'+
            ' AND sirenum__Allow_pay__c=False AND sirenum__Allow_charge__c=False '+
            ' AND sirenum__Scheduled_Start_Time__c>=:startDateTime AND sirenum__Scheduled_Start_Time__c<=:endDateTime';
        
        return Database.getQueryLocator(Query);          
        
    }
    //
    /** Execute Method **/
    //
    global void execute(Database.BatchableContext BC , List<sirenum__Shift__c> ShiftForApproval){
        Map<Id,sirenum__Shift__c> updateShift = new Map<Id,sirenum__Shift__c>();
        List<sirenum__Shift__c> ShiftInPrevPayroll = new List<sirenum__Shift__c>();
        List<sirenum__Shift__c> ShiftsNotInPrevPayroll = new List<sirenum__Shift__c>();
        for(sirenum__Shift__c shiftCheck :ShiftForApproval )
        {
            convertDate = date.valueOf(shiftCheck.sirenum__Scheduled_Start_Time__c);
            CheckStartDate =Date.newInstance(convertDate.year(),convertDate.month(),convertDate.day()); 
            if(shiftCheck.sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.name == 'Monday to Sunday' 
               && CheckStartDate >= DateMonSht1 && CheckStartDate <= DateSunSht1)
            {
                ShiftInPrevPayroll.add(shiftCheck);
            }
            else if(shiftCheck.sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.name == 'Sunday to Saturday' 
                    && CheckStartDate >= DateSunSht3 && CheckStartDate <= DateSatSht3)
            {
                ShiftInPrevPayroll.add(shiftCheck);
            }
            else if(shiftCheck.sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.name == 'Saturday to Friday' 
                    && CheckStartDate >= DateSatSht2 && CheckStartDate <= DateFriSht2)
            {
                ShiftInPrevPayroll.add(shiftCheck);
            }             
            else
            {
            }
        }
        
        for(sirenum__Shift__c Shift: ShiftInPrevPayroll)
        {
            Scheduledtimestart = shift.sirenum__Scheduled_Start_Time__c.format('yyyy-MM-dd HH:mm');
            Scheduledtimeend = shift.sirenum__Scheduled_End_Time__c.format('yyyy-MM-dd HH:mm');
            Actualtimestart = shift.sirenum__Actual_Start_Time__c.format('yyyy-MM-dd HH:mm');
            Actualtimeend = shift.sirenum__Actual_End_Time__c.format('yyyy-MM-dd HH:mm');
           
            if((Scheduledtimestart == Actualtimestart) && (Scheduledtimeend == Actualtimeend))                
            {
                if((shift.IP_CandidateApproved__c || shift.Actuals_confirmed__c) && !shift.IP_ClientApproved__c )
                {
                    if(shift.Approved_By__c == Null && shift.Approved_Date_Time__c == Null)
                    {
                        sirenum__Shift__c ShiftToBeApproved = new sirenum__Shift__c(Id=Shift.Id ,sirenum__Allow_pay__c=true,sirenum__Allow_charge__c=true,Approved_By__c=approvedByUserId,Approved_Date_Time__c=dateNow);
                        updateShift.put(Shift.Id,ShiftToBeApproved);
                    }
                    else
                    {
                        sirenum__Shift__c ShiftToBeApproved = new sirenum__Shift__c(Id=Shift.Id ,sirenum__Allow_pay__c=true,sirenum__Allow_charge__c=true);
                        updateShift.put(Shift.Id,ShiftToBeApproved);
                    }
                }
                if((shift.IP_CandidateApproved__c || shift.Actuals_confirmed__c) && shift.IP_ClientApproved__c && (shift.sirenum__Billable_Start_Time__c == shift.sirenum__Scheduled_Start_Time__c)&&(shift.sirenum__Billable_End_Time__c == shift.sirenum__Scheduled_End_Time__c))
                    
                {
                    if(shift.Approved_By__c == Null && shift.Approved_Date_Time__c == Null)
                    {
                        sirenum__Shift__c ShiftToBeApproved = new sirenum__Shift__c(Id=Shift.Id ,sirenum__Allow_pay__c=true,sirenum__Allow_charge__c=true,Approved_By__c=approvedByUserId,Approved_Date_Time__c=dateNow);
                        updateShift.put(Shift.Id,ShiftToBeApproved);
                    }
                    else
                    {
                        sirenum__Shift__c ShiftToBeApproved = new sirenum__Shift__c(Id=Shift.Id ,sirenum__Allow_pay__c=true,sirenum__Allow_charge__c=true);
                        updateShift.put(Shift.Id,ShiftToBeApproved);
                    }                
                }
            }
            
        }
        Database.update(updateShift.values(),false);
        
        
    }
    //
    /** Finish Method **/
    //
    global void finish(Database.BatchableContext BC)
    {
        
    }
}