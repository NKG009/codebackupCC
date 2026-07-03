public class PortalV2HoursSubmission {
    
    @AuraEnabled
    public static String applyAmendedShiftHoursToAllShifts(
        List<sirenum__Shift__c> toBeUpdatedShifts
    ) {
        String theResult = 'success';
        try {
            Map<Id, Map<String, String>> minutesToBeAdded = new Map<Id, Map<String, String>>();
            Map<Id, String> reasonToBeAdded = new Map<Id, String>();
            
            for (sirenum__Shift__c theShift : toBeUpdatedShifts) {
                minutesToBeAdded.put(
                    theShift.Id,
                    new Map<String, String>{
                        'startTime' => theShift.Starttime__c,
                            'endTime' => theShift.EndTime__c
                            }
                );
                reasonToBeAdded.put(theShift.Id, theShift.Reason_for_non_submission_of_hours__c);
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
                sirenum__Scheduled_End_Time__c,
                Reason_for_non_submission_of_hours__c
                FROM sirenum__Shift__c
                WHERE Id IN :minutesToBeAdded.keySet()
            ]) {
                String reason = reasonToBeAdded.get(theShift.Id);
                
                if (reason == 'Holiday' || reason == 'Sickness') {
                    theShift.sirenum__Actual_Start_Time__c = null;
                    theShift.sirenum__Actual_End_Time__c = null;
                } else {
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
                }
                
                theShift.Reason_for_non_submission_of_hours__c = reason;
                theShift.Hours_submitted_by_Supplier__c = true;
                
                toBeUpdated.add(theShift);
            }
            
            update toBeUpdated;
        } catch (Exception theException) {
            theResult = theException.getMessage();
        }
        return theResult;
    }
    
    
    @AuraEnabled
  public static List<sirenum__Shift__c> getAllShiftRecordsVMSClient(
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
      'SELECT Id, IP_ClientRejected__c, IP_ClientApproved__c, sirenum__Team__r.sirenum__Job_Type__c,Reason_for_non_submission_of_hours__c, sirenum__Placement__r.sirenum__Start_Date__c, sirenum__Placement__r.sirenum__End_Date__c, sirenum__Timesheet_summaries__r.sirenum__Week_Ending__c, sirenum__Timesheet_summaries__r.IP_Client_Invoice_PO__c ' +
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
    public static List<sirenum__Shift__c> getAllShiftRecords(List<String> siteIds) {
        List<String> theTimesheetFields = fetchTimesheetFields();
        String toBeAddedToQuery = theTimesheetFields.size() > 0
            ? ', ' + String.join(theTimesheetFields, ', ') + ' '
            : '';
        DateTime now = DateTime.now();
        Id currentUserId = UserInfo.getUserId();
        User currentUser = [SELECT Id, ContactId FROM User WHERE Id =: currentUserId];
        Contact userContact = [SELECT Id, AccountId FROM Contact WHERE Id =: currentUser.ContactId];
        Id userContactIdsss = currentUser.ContactId;
        Id accountId = userContact.AccountId;
        system.debug('======================userContactIdsss'+userContactIdsss);
        system.debug('======================currentUser'+currentUser);
        system.debug('======================currentUser'+currentUser);
        System.debug(userContact);
        Id shiftRecordTypeId = Schema.SObjectType.sirenum__Shift__c.getRecordTypeInfosByDeveloperName()
            .get('Shift')
            .getRecordTypeId();
        

        set<Id> setConId = new set<Id>();
        List<Contact> oContacts = [SELECT Id, Looked_After_By__c FROM Contact Where Looked_After_By__c =: userContactIdsss];
        
        system.debug('======================oContacts'+oContacts);
        Set<Id> shiftIds = new Set<Id>();
        
        if(oContacts!=null){
            for (Contact con : oContacts) {
                    setConId.add(con.Id);
                }
                

                
                List<sirenum__Shift__c> timesh = [SELECT Id, Name ,sirenum__Contact__c FROM sirenum__Shift__c Where  sirenum__Contact__c =:setConId];
                if(timesh != null){
                    for (sirenum__Shift__c TS : timesh) {
                        if (TS.sirenum__Contact__c != null) {
                            shiftIds.add(TS.Id);
                        }
                    }  
                }
            system.debug('======================timesh'+timesh);
            }
         
        
        String theQuery =
            'SELECT Id, IP_ClientRejected__c, IP_ClientApproved__c, sirenum__Team__r.sirenum__Job_Type__c, sirenum__Placement__r.sirenum__Start_Date__c, sirenum__Placement__r.sirenum__End_Date__c, sirenum__Timesheet_summaries__r.sirenum__Week_Ending__c,Reason_for_non_submission_of_hours__c, sirenum__Timesheet_summaries__r.IP_Client_Invoice_PO__c ' +
            toBeAddedToQuery +
            'FROM sirenum__Shift__c WHERE Id =: shiftIds AND sirenum__Published__c = true AND sirenum__Cancelled__c = false and IP_ClientRejected__c = false AND sirenum__Scheduled_Start_Time__c <= :now AND Unfilled_Shift__c = false AND RecordTypeId =:shiftRecordTypeId';
        
        
        theQuery += ' ORDER BY sirenum__Scheduled_Start_Time__c DESC LIMIT 10000';
        
        system.debug('======================theQuery'+theQuery);
        
        List<sirenum__Shift__c> allShiftRecords = (List<sirenum__Shift__c>) Database.query(theQuery);
        
        system.debug('======================allShiftRecords'+allShiftRecords);
        List<sirenum__Shift__c> toBeApprovedShiftRecords = new List<sirenum__Shift__c>();
        
        return allShiftRecords;
    }
    
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
    public static List<Portal_V2_Hours_Submission_Columns__mdt> fetchAdjustableColumns() {
        List<Portal_V2_Hours_Submission_Columns__mdt> theCustomMetadata = [
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
            FROM Portal_V2_Hours_Submission_Columns__mdt
            ORDER BY Display_Order__c ASC
        ];
        return theCustomMetadata;
    }
    
    
}