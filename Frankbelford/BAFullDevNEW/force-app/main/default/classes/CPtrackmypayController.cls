global without sharing class CPtrackmypayController {

    @AuraEnabled  /* this is onload method */
    global static List<sirenum__Timesheet__c> getTimesheets() {
        List<sirenum__Timesheet__c> timeSheets = [select Id,Name,CreatedDate,sirenum__Week_Ending__c,sirenum__Total_Pay__c,sirenum__Non_Taxed_Deductions__c, sirenum__Total_Hours__c,IP_Status__c
                                                    from sirenum__Timesheet__c
                                                    where CreatedDate >= THIS_YEAR
                                                    and sirenum__Worker__c =: getUserId()
                                                    order by CreatedDate desc];
        return timeSheets;
    }

    @AuraEnabled
    global static List<Object> getTimesheetLine(String TSLID) {
        List<sirenum__Timesheet_Line__c> tsl=[Select Id,Name,sirenum__Timesheet__r.Name,sirenum__Timesheet__r.IP_StandardWeeklyNumberID__c,sirenum__Date__c,sirenum__Timesheet__r.sirenum__Team__r.Name,
                                                        sirenum__Timesheet__r.sirenum__Site__r.Name,sirenum__Hours__c,sirenum__Rate__c
                                                from sirenum__Timesheet_Line__c
                                                where sirenum__Timesheet__c=:TSLID];
        return tsl;

    }

    @AuraEnabled
    global static List<sirenum__Timesheet__c> getTimesheetQuery(String TimesheetId) {
        return [select Id, Name, sirenum__Team__r.Name,sirenum__Total_Pay__c, IP_StandardWeeklyNumberID__c,sirenum__Site__r.Name from sirenum__Timesheet__c where id=:Timesheetid];
    }

    @AuraEnabled
    global static Void SendQueryOwner(String TSLID, String comments, String combinedComment) {
        Id templateIdCandBranch = [select id, name from EmailTemplate where developername = 'Candidate_Portal_Track_MyPay_Branch'].id;
        Id templateIdCand = [select id, name from EmailTemplate where developername = 'Candidate_Portal_Track_MyPay_Candidate'].id;

        if(comments!=null && TSLID!=null) {
            sirenum__Timesheet_line__c tsl = [Select id,sirenum__Shift__c from sirenum__Timesheet_line__c where sirenum__Timesheet__c=:TSLID limit 1];
            sirenum__Shift__c ts= [select Id,sirenum__site__r.GlobalClientName__r.Name,sirenum__Contact__r.Owner.Name,sirenum__Contact__r.FirstName,sirenum__Scheduled_Start_Time__c,sirenum__Scheduled_End_Time__c,sirenum__site__r.Name,sirenum__Team__r.Name, sirenum__Contact__c,sirenum__Contact__r.Name,sirenum__Contact__r.IP_TempestDepartment__c from sirenum__Shift__c where id=:tsl.sirenum__Shift__c];
            //System.debug('shift record >> '+ts);
            String department = ts.sirenum__Contact__r.IP_TempestDepartment__c;
            //System.debug('department >>> ' + department);
            IP_Shift_Template__c shiftemp = IP_Shift_Template__c.getValues(department);
            String BranchUserEmail = shiftemp.Email__c;
            String[] toAddresses = new String[] {BranchUserEmail};

            ts.Description__c=comments;
            update ts;
            OrgWideEmailAddress owd = [select id, DisplayName,Address from OrgWideEmailAddress where Address =:shiftemp.Email__c];
            OrgWideEmailAddress owd1 = [select id, DisplayName,Address from OrgWideEmailAddress where Address ='no.reply@bluearrow.co.uk'];
            List<User> ulist = [Select id from User where contactid =: ts.sirenum__Contact__r.id limit 1];
            Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
            semail.setTreatTargetObjectAsRecipient(false);
            semail.setToAddresses(toAddresses);

            if(ulist.size()>0){
                semail.setTargetObjectId(ulist[0].id);
                semail.setSaveAsActivity(false);
            }else{ semail.setTargetObjectId(ts.sirenum__Contact__r.id);  }

            semail.setWhatId(ts.id);
            semail.setOrgWideEmailAddressId(owd1.Id);
            semail.setTemplateId(templateIdCandBranch);

            Messaging.SingleEmailMessage semail1 = new Messaging.SingleEmailMessage();
            if(ulist.size()>0){
                semail1.setTargetObjectId(ulist[0].id);
                semail1.setSaveAsActivity(false);
            }else{ semail1.setTargetObjectId(ts.sirenum__Contact__r.id); }

            semail1.setOrgWideEmailAddressId(owd.Id);
            semail1.setTemplateId(templateIdCand);

            if(!Test.isRunningTest()) {
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail});
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail1});
            }
        }
    }

    public static String getUserId(){
        ID contactId = [Select contactid from User where id =: Userinfo.getUserid()].contactId;
        return contactId;
    }
}