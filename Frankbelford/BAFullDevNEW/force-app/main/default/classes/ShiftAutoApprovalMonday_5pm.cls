/**
 * Created by Espier
 * Updated by Musaddekur Rahman on 11/03/2021
 */

global class ShiftAutoApprovalMonday_5pm implements Database.Batchable<sObject>, Database.Stateful {
    Integer shiftAutoApprovalCount = 0;
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
    Id templateId = [select id, name from EmailTemplate where developername = 'Client_Portal_Auto_Shift_to_be_Approved'].id;
    Map<Id, Integer> siteShiftCount = new Map<Id, Integer>();

    /** Start Method **/
    global Database.QueryLocator start (Database.BatchableContext BC){
        String Query;
        Query ='SELECT id , sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.name ,sirenum__Site__r.IP_Timesheet_Method__c ,sirenum__Site__r.IP_ScheduledAutoApproval__c, '+
                        'IP_CandidateApproved__c ,Actuals_confirmed__c ,IP_ClientApproved__c,sirenum__Scheduled_Start_Time__c,sirenum__Scheduled_End_Time__c, '+
                        'sirenum__Actual_Start_Time__c,sirenum__Actual_End_Time__c,sirenum__Billable_Start_Time__c,sirenum__Billable_End_Time__c,IP_ClientRejected__c, '+
                        'sirenum__Allow_pay__c,sirenum__Allow_charge__c,Approved_By__c,Approved_Date_Time__c '+
                'FROM sirenum__Shift__c '+
                'WHERE sirenum__Site__r.IP_Timesheet_Method__c=\'eTimesheet\' '+
                'AND sirenum__Site__r.IP_ScheduledAutoApproval__c=true '+
                'AND (IP_CandidateApproved__c =true OR Actuals_confirmed__c =true OR IP_ClientApproved__c=true) '+
                'AND IP_ClientRejected__c=false '+
                'AND sirenum__Published__c=true '+
                'AND sirenum__Cancelled__c=false '+
                'AND sirenum__Scheduled_Start_Time__c != Null '+
                'AND sirenum__Scheduled_End_Time__c!= Null '+
                'AND sirenum__Allow_pay__c=False AND sirenum__Allow_charge__c=False '+
                'AND sirenum__Scheduled_Start_Time__c>=:startDateTime AND sirenum__Scheduled_Start_Time__c<=:endDateTime';
        return Database.getQueryLocator(Query);
    }

    /** Execute Method **/
    global void execute(Database.BatchableContext BC , List<sirenum__Shift__c > ShiftForApproval){
        Map<Id,sirenum__Shift__c> updateShift = new Map<Id,sirenum__Shift__c>();
        List<sirenum__Shift__c> ShiftInPrevPayroll = new List<sirenum__Shift__c>();
        List<sirenum__Shift__c> shiftsNotInPrevPayroll = new List<sirenum__Shift__c>();

        for(sirenum__Shift__c shiftCheck :ShiftForApproval ){
            convertDate = date.valueOf(shiftCheck.sirenum__Scheduled_Start_Time__c);
            CheckStartDate =Date.newInstance(convertDate.year(),convertDate.month(),convertDate.day());

            if(shiftCheck.sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.name == 'Monday to Sunday'
                    && CheckStartDate >= DateMonSht1 && CheckStartDate <= DateSunSht1) {
                ShiftInPrevPayroll.add(shiftCheck);
            } else if(shiftCheck.sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.name == 'Sunday to Saturday'
                    && CheckStartDate >= DateSunSht3 && CheckStartDate <= DateSatSht3) {
                ShiftInPrevPayroll.add(shiftCheck);
            } else if(shiftCheck.sirenum__Team__r.sirenum__Account__r.sirenum__PayrollCycle__r.name == 'Saturday to Friday'
                    && CheckStartDate >= DateSatSht2 && CheckStartDate <= DateFriSht2) {
                ShiftInPrevPayroll.add(shiftCheck);
            } else {
                shiftsNotInPrevPayroll.add(shiftCheck);
            }
        }

        for(sirenum__Shift__c Shift: ShiftInPrevPayroll) {
            Scheduledtimestart = shift.sirenum__Scheduled_Start_Time__c.format('yyyy-MM-dd HH:mm');
            Scheduledtimeend = shift.sirenum__Scheduled_End_Time__c.format('yyyy-MM-dd HH:mm');
            Actualtimestart = shift.sirenum__Actual_Start_Time__c.format('yyyy-MM-dd HH:mm');
            Actualtimeend = shift.sirenum__Actual_End_Time__c.format('yyyy-MM-dd HH:mm');

            if((Scheduledtimestart == Actualtimestart) && (Scheduledtimeend == Actualtimeend)) {
                if((shift.IP_CandidateApproved__c || shift.Actuals_confirmed__c) && !shift.IP_ClientApproved__c ) {
                    if(shift.Approved_By__c == Null && shift.Approved_Date_Time__c == Null) {
                        //sirenum__Shift__c ShiftToBeApproved = new sirenum__Shift__c(Id=Shift.Id ,sirenum__Allow_pay__c=true,sirenum__Allow_charge__c=true,Approved_By__c=approvedByUserId,Approved_Date_Time__c=dateNow);
                        Shift.sirenum__Allow_pay__c=true; Shift.sirenum__Allow_charge__c=true; Shift.Approved_By__c=approvedByUserId; Shift.Approved_Date_Time__c=dateNow;
                        updateShift.put(Shift.Id,Shift);
                    } else {
                        //sirenum__Shift__c ShiftToBeApproved = new sirenum__Shift__c(Id=Shift.Id ,sirenum__Allow_pay__c=true,sirenum__Allow_charge__c=true);
                        Shift.sirenum__Allow_pay__c=true; Shift.sirenum__Allow_charge__c=true;
                        updateShift.put(Shift.Id,Shift);
                    }
                }
                if((shift.IP_CandidateApproved__c || shift.Actuals_confirmed__c) &&
                        shift.IP_ClientApproved__c &&
                        (shift.sirenum__Billable_Start_Time__c == shift.sirenum__Scheduled_Start_Time__c) &&
                        (shift.sirenum__Billable_End_Time__c == shift.sirenum__Scheduled_End_Time__c)) {
                    if(shift.Approved_By__c == Null && shift.Approved_Date_Time__c == Null) {
                        //sirenum__Shift__c ShiftToBeApproved = new sirenum__Shift__c(Id=Shift.Id ,sirenum__Allow_pay__c=true,sirenum__Allow_charge__c=true,Approved_By__c=approvedByUserId,Approved_Date_Time__c=dateNow);
                        Shift.sirenum__Allow_pay__c=true;
                        Shift.sirenum__Allow_charge__c=true;
                        Shift.Approved_By__c=approvedByUserId;
                        Shift.Approved_Date_Time__c=dateNow;
                        updateShift.put(Shift.Id,Shift);
                    } else {
                        //sirenum__Shift__c ShiftToBeApproved = new sirenum__Shift__c(Id=Shift.Id ,sirenum__Allow_pay__c=true,sirenum__Allow_charge__c=true);
                        Shift.sirenum__Allow_pay__c=true; Shift.sirenum__Allow_charge__c=true;
                        updateShift.put(Shift.Id,Shift);
                    }
                }
            } else {
                System.debug('Shift is ignored > ' + ShiftInPrevPayroll);
            }
        }

        try {
            System.debug('Number of Shift to be Updated $$ '+updateShift.size());
            Database.SaveResult[] ds = Database.update(updateShift.values(),false);
            for(database.SaveResult d : ds){
                if(d.isSuccess()){
                    shiftAutoApprovalCount++;
                    //KEEP A COUNT OF SHIFT APPROVED BY SITE TO SEND EMAIL TO THE Primary Hours Approver
                    Id siteId = updateShift.get(d.getId()).sirenum__Site__c;

                    if(siteShiftCount.containsKey(siteId)){
                        siteShiftCount.put(siteId,siteShiftCount.get(siteId)+1);
                    } else {
                        siteShiftCount.put(siteId,1);
                    }
                } else {
                    System.debug('Save failed >>> ' + d);
                }
            }
        }catch(exception e){
            System.debug('update failed');
        }
    }

    /** Finish Method **/
    global void finish(Database.BatchableContext BC){
        Map<Id, Integer> primaryApproverMap = new Map<Id, Integer>(); //CONTACT RECORD ID AND NUMBER OF SHIFTS AUTO APPROVED
        Map<Id, Contact_Site_link__c> contactSiteLinkMap = new Map<Id, Contact_Site_link__c>(); //CONTACT RECORD ID AND SITE LINK RECORD
        List<User> userList = new List<User>(); //LIST OF USER RECORDS TO UPDATE NumberOfShifts__c WHICH IS USED IN THE EMAIL TEMPLATE
        Set<String> brands = new Set<String>();
        Map<String, Id> brandOWEmailIdMap = new Map<String, Id>(); //BRAND NAME AND ORG WIDE EMAIL ID
        Messaging.SingleEmailMessage[] semArray = new Messaging.SingleEmailMessage[0];

        System.debug('shiftAutoApprovalCount = ' +shiftAutoApprovalCount);
        System.debug('siteShiftCount >> ' + siteShiftCount);

        If(shiftAutoApprovalCount > 0){
            //GET Primary Hours Approver CONTACT AND Contact_Site_link__c
            for(Contact_Site_link__c csl : [SELECT IP_Contact__c, IP_Site__c, IP_Site__r.Brand__c
                                            FROM Contact_Site_link__c
                                            WHERE IP_Site__c IN: siteShiftCount.keySet()
                                            AND IP_PortalType__c = 'Primary Hours Approver'
                                            AND IP_Contact__c IN (SELECT ContactId FROM User WHERE IsActive=true)]){
                primaryApproverMap.put(csl.IP_Contact__c, siteShiftCount.get(csl.IP_Site__c));
                contactSiteLinkMap.put(csl.IP_Contact__c, csl);
                brands.add(csl.IP_Site__r.Brand__c);
            }
            //GET ORG WIDE EMAIL ID BY BRAND
            for(OrgWideEmailAddress owd : [select id, DisplayName,Address
                                            from OrgWideEmailAddress
                                            where Address LIKE 'no.reply%'
                                            AND DisplayName IN: brands]){
                brandOWEmailIdMap.put(owd.DisplayName, owd.Id);
            }
            System.debug('primaryApproverMap = ' + primaryApproverMap);
            //GET Primary Hours Approver USER RECORD
            for(User u : [SELECT Id, ContactId, NumberOfShifts__c, Brand__c
                            FROM User
                            WHERE ContactId IN: primaryApproverMap.keySet()
                            AND IsActive = true]){

                u.NumberOfShifts__c = String.valueOf(primaryApproverMap.get(u.ContactId));
                userList.add(u);

                Messaging.SingleEmailMessage semail1 = new Messaging.SingleEmailMessage();
                semail1.setOrgWideEmailAddressId(brandOWEmailIdMap.get(u.Brand__c));
                semail1.setTargetObjectID(u.Id);
                semail1.setSaveAsActivity(false);
                semail1.setTemplateId(templateId);
                semail1.setWhatId(contactSiteLinkMap.get(u.ContactId).IP_Site__r.Id);
                semArray.add(semail1);
                //System.debug('semail1 = ' + semail1); 
            }
            //UPDATE USERS BEFORE SENDING EMAIL
            update userList;
            Messaging.sendEmail(semArray);
        }
    }
}