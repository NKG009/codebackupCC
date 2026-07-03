public without sharing class TimesheetPageApexController {
    
    @AuraEnabled
    public static List<Portal_V2_My_Timesheet_Adjust_Column__mdt> fetchAdjustableColumns() {
        List<Portal_V2_My_Timesheet_Adjust_Column__mdt> customMetadata = [
            SELECT
            DeveloperName,
            MasterLabel,
            Display_Order__c,
            Field_API_Name__c,
            Selected_By_Default__c,
            Table_Type__c,
            View__c,
            Filterable__c,
            Filter_Type__c,
            Type__c,
            Date_Filter_Type__c,
            Rollup_from_children__c,
            Child_Column_Name__c,
            Aggregate_Type__c,
            Include_in_temp_feedback_modal__c
            FROM Portal_V2_My_Timesheet_Adjust_Column__mdt
            ORDER BY Display_Order__c ASC
        ];
        return customMetadata;
    }
    
    @AuraEnabled
    public static List<Portal_V2_Timesheet_VMS_Client_Column__mdt> fetchAdjustableColumnsVMS() {
        List<Portal_V2_Timesheet_VMS_Client_Column__mdt> customMetadata = [
            SELECT
            DeveloperName,
            MasterLabel,
            Display_Order__c,
            Field_API_Name__c,
            Selected_By_Default__c,
            Table_Type__c,
            View__c,
            Filterable__c,
            Filter_Type__c,
            Type__c,
            Date_Filter_Type__c,
            Rollup_from_children__c,
            Child_Column_Name__c,
            Aggregate_Type__c,
            Include_in_temp_feedback_modal__c
            FROM Portal_V2_Timesheet_VMS_Client_Column__mdt
            ORDER BY Display_Order__c ASC
        ];
        return customMetadata;
    }
    
    //*********************************VMS Supplier*****************************************//
    @AuraEnabled
    public static List<sirenum__Timesheet__c> getShiftsByUserAccountSupplier(Id contactId, List<Id> siteId) {
        try {
            
            User activeUser = [SELECT ContactId FROM User WHERE ID = :UserInfo.getUserId()];
            String userContactId = activeUser.ContactId;
            
            Id idToUse = userContactId;
            Contact userContact = [ SELECT Id, AccountId FROM Contact WHERE Id = :idToUse];
            
            
            Date lookbackDate = Date.Today().addDays(-7);
            
            
            System.debug('=====================================userContactId===='+userContactId);
            set<Id> setConId = new set<Id>();
            List<Contact> oContacts = [SELECT Id, Looked_After_By__c FROM Contact Where Looked_After_By__c = :userContactId];
            
            System.debug('=====================================oContacts===='+oContacts);
            // Step 2: Extract Timesheet IDs
            Set<Id> timesheetIds = new Set<Id>();
            
            if(oContacts!=null){
                for (Contact con : oContacts) {
                    setConId.add(con.Id);
                }
                
                System.debug('=====================================setConId===='+setConId);
                
                List<sirenum__Timesheet__c> timesh = [SELECT Id, Name ,sirenum__Worker__c FROM sirenum__Timesheet__c Where  sirenum__Worker__c =:setConId];
                if(timesh != null){
                    for (sirenum__Timesheet__c TS : timesh) {
                        if (TS.sirenum__Worker__c != null) {
                            timesheetIds.add(TS.Id);
                        }
                    }  
                }
            }
            
            System.debug('=====================================timesheetIds===='+timesheetIds);
            
            List<sirenum__Timesheet__c> timesheets = new List<sirenum__Timesheet__c>();
            
            if (!timesheetIds.isEmpty()) {
                timesheets = [ 
                    SELECT Id, Name, sirenum__Worker__c, sirenum__Worker__r.Name, sirenum__Total_Charge__c, 
                    sirenum__Client_Bill__c, sirenum__Site__c,sirenum__Site__r.Name, sirenum__Team__c, sirenum__Team__r.Name,
                    sirenum__Total_Hours__c, sirenum__Week_Ending__c,sirenum__Worker_Bill__c,
                    (SELECT Id, Name,IP_RateCodes__c, sirenum__RateType__c,sirenum__Shift__c, IP_PayrollPresentedRateCode__c, sirenum__Hours__c,sirenum__Charge__c,
                     sirenum__Rate__c ,sirenum__Total_Pay__c,Portal_Rate_Code__c,sirenum__Date__c
                     FROM sirenum__Timesheet_Lines__r)
                    FROM sirenum__Timesheet__c
                    WHERE Id IN :timesheetIds
                    AND sirenum__Week_Ending__c > :lookbackDate
                    ORDER BY sirenum__Week_Ending__c DESC
                ];
            }
            
            System.debug('=====================================timesheets'+timesheets);
            
            return timesheets;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    
    //*********************************VMS Supplier*****************************************//
    @AuraEnabled
    public static List<sirenum__Timesheet__c> getPastShiftsByUserAccountSupplier(Id contactId,List<Id> siteId,String timescale) {
        try {
            Integer parsedTimescale;
            if (timescale != '1 Week') {
                parsedTimescale = Integer.valueOf(timescale);
            }
            Date lookbackDate = timescale == '1 Week' ? Date.Today().addDays(-7) : Date.Today().addMonths(-parsedTimescale);
            
            
            User activeUser = [SELECT ContactId FROM User WHERE ID = :UserInfo.getUserId()];
            String userContactId = activeUser.ContactId;
            
            Id idToUse = userContactId;
            Contact userContact = [ SELECT Id, AccountId FROM Contact WHERE Id = :idToUse];
            
            System.debug('=====================================userContactId===='+userContactId);
            set<Id> setConId = new set<Id>();
            List<Contact> oContacts = [SELECT Id, Looked_After_By__c FROM Contact Where Looked_After_By__c = :userContactId];
            
            System.debug('=====================================oContacts===='+oContacts);
            // Step 2: Extract Timesheet IDs
            Set<Id> timesheetIds = new Set<Id>();
            
            if(oContacts!=null){
                for (Contact con : oContacts) {
                    setConId.add(con.Id);
                }
                
                System.debug('=====================================setConId===='+setConId);
                
                List<sirenum__Timesheet__c> timesh = [SELECT Id, Name ,sirenum__Worker__c FROM sirenum__Timesheet__c Where  sirenum__Worker__c =:setConId];
                if(timesh != null){
                    for (sirenum__Timesheet__c TS : timesh) {
                        if (TS.sirenum__Worker__c != null) {
                            timesheetIds.add(TS.Id);
                        }
                    }  
                }
            }
            
            System.debug('=====================================timesheetIds===='+timesheetIds);
            
            List<sirenum__Timesheet__c> timesheets = new List<sirenum__Timesheet__c>();
            
            if (!timesheetIds.isEmpty()) {
                timesheets = [ 
                    SELECT Id, Name, sirenum__Worker__c, sirenum__Worker__r.Name, sirenum__Total_Charge__c, 
                    sirenum__Client_Bill__c, sirenum__Site__c,sirenum__Site__r.Name, sirenum__Team__c, sirenum__Team__r.Name,
                    sirenum__Total_Hours__c, sirenum__Week_Ending__c,sirenum__Worker_Bill__c,
                    (SELECT Id, Name,IP_RateCodes__c, sirenum__RateType__c,sirenum__Shift__c, IP_PayrollPresentedRateCode__c, sirenum__Hours__c,sirenum__Charge__c,
                     sirenum__Rate__c ,sirenum__Total_Pay__c,Portal_Rate_Code__c,sirenum__Date__c
                     FROM sirenum__Timesheet_Lines__r)
                    FROM sirenum__Timesheet__c
                    WHERE Id IN :timesheetIds
                    AND sirenum__Week_Ending__c > :lookbackDate
                    ORDER BY sirenum__Week_Ending__c DESC
                ];
            }
            
            System.debug('=====================================timesheets'+timesheets);
            
            return timesheets;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    //*********************************VMS Client*****************************************//
    @AuraEnabled
    public static List<sirenum__Timesheet__c> getShiftsByUserAccountVmsClient(Id contactId, List<Id> siteId) {
        try {
            System.debug(UserInfo.getUserId());
            System.debug(siteId);
            User activeUser = [SELECT ContactId FROM User WHERE ID = :UserInfo.getUserId()];
            String userContactId = activeUser.ContactId;
            
            Id idToUse = contactId != null ? contactId : userContactId;
            Contact userContact = [ SELECT Id, AccountId FROM Contact WHERE Id = :idToUse];
            
            Date lookbackDate = Date.Today().addDays(-7);
            
            Set<Id> timesheetIds = new Set<Id>();
            List<sirenum__Timesheet__c> timesh = [SELECT Id, Name ,sirenum__Client__c,sirenum__Site__c FROM sirenum__Timesheet__c 
                                                  Where  sirenum__Client__c =:userContact.AccountId
                                                  AND sirenum__Site__c IN :siteId];
            if(timesh != null){
                for (sirenum__Timesheet__c TS : timesh) {
                    if (TS.sirenum__Client__c != null ) {
                        timesheetIds.add(TS.Id);
                    }
                }  
            }
            
            System.debug('=====================================timesheetIds===='+timesheetIds);
            
            List<sirenum__Timesheet__c> timesheets = new List<sirenum__Timesheet__c>();
            
            if (!timesheetIds.isEmpty()) {
                timesheets = [ 
                    SELECT Id, Name, sirenum__Worker__c, sirenum__Worker__r.Name, sirenum__Total_Charge__c, 
                    sirenum__Client_Bill__c, sirenum__Site__c,sirenum__Site__r.Name, sirenum__Team__c, sirenum__Team__r.Name,
                    sirenum__Total_Hours__c, sirenum__Week_Ending__c,sirenum__Worker_Bill__c,
                    (SELECT Id, Name,IP_RateCodes__c, sirenum__RateType__c,sirenum__Shift__c, IP_PayrollPresentedRateCode__c, sirenum__Hours__c,sirenum__Charge__c,
                     sirenum__Rate__c ,Portal_Rate_Code__c ,sirenum__Total_Charge__c,sirenum__Date__c
                     FROM sirenum__Timesheet_Lines__r)
                    FROM sirenum__Timesheet__c
                    WHERE sirenum__Client__c = :userContact.AccountId 
                    AND sirenum__Site__c IN :siteId
                    AND sirenum__Week_Ending__c > :lookbackDate
                    ORDER BY sirenum__Week_Ending__c DESC
                ];
            }
            
            System.debug('=====================================timesheets'+timesheets);
            
            return timesheets;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    //*********************************VMS Client Past*****************************************//
    @AuraEnabled
    public static List<sirenum__Timesheet__c> getPastShiftsByUserAccountVmsClient(Id contactId, List<Id> siteId, String timescale) {
        try {
            Integer parsedTimescale;
            if (timescale != '1 Week') {
                parsedTimescale = Integer.valueOf(timescale);
            }
            Date lookbackDate = timescale == '1 Week' ? Date.Today().addDays(-7) : Date.Today().addMonths(-parsedTimescale);
            
            User activeUser = [SELECT ContactId FROM User WHERE ID = :UserInfo.getUserId()];
            String userContactId = activeUser.ContactId;
            
            Id idToUse = contactId != null ? contactId : userContactId;
            Contact userContact = [SELECT Id, AccountId FROM Contact WHERE Id = :idToUse];
            
            
             Set<Id> timesheetIds = new Set<Id>();
            List<sirenum__Timesheet__c> timesh = [SELECT Id, Name ,sirenum__Client__c,sirenum__Site__c FROM sirenum__Timesheet__c 
                                                  Where  sirenum__Client__c =:userContact.AccountId
                                                  AND sirenum__Site__c IN :siteId];
            if(timesh != null){
                for (sirenum__Timesheet__c TS : timesh) {
                    if (TS.sirenum__Client__c != null ) {
                        timesheetIds.add(TS.Id);
                    }
                }  
            }
            System.debug('=====================================timesheetIds Past===='+timesheetIds);
            
            List<sirenum__Timesheet__c> timesheets = new List<sirenum__Timesheet__c>();
            
             if (!timesheetIds.isEmpty()) {
                timesheets = [ 
                    SELECT Id, Name, sirenum__Worker__c, sirenum__Worker__r.Name, sirenum__Total_Charge__c, 
                    sirenum__Client_Bill__c, sirenum__Site__c,sirenum__Site__r.Name, sirenum__Team__c, sirenum__Team__r.Name,
                    sirenum__Total_Hours__c, sirenum__Week_Ending__c,sirenum__Worker_Bill__c,
                    (SELECT Id, Name,IP_RateCodes__c, sirenum__RateType__c,sirenum__Shift__c, IP_PayrollPresentedRateCode__c, sirenum__Hours__c,sirenum__Charge__c,
                     sirenum__Rate__c ,Portal_Rate_Code__c ,sirenum__Total_Charge__c,sirenum__Date__c
                     FROM sirenum__Timesheet_Lines__r)
                    FROM sirenum__Timesheet__c
                    WHERE sirenum__Client__c = :userContact.AccountId 
                    AND sirenum__Site__c IN :siteId
                    AND sirenum__Week_Ending__c > :lookbackDate
                    ORDER BY sirenum__Week_Ending__c DESC
                ];
            }
            
            
            return timesheets;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static List<sirenum__Timesheet__c> getTimesheetByUserAccount() {
        User activeUser = [SELECT ContactId, AccountId FROM User WHERE ID = :UserInfo.getUserId()];
        
        return [SELECT Id, Name, sirenum__Worker__c, sirenum__Worker__r.Name, sirenum__Total_Charge__c, 
                sirenum__Client_Bill__c, sirenum__Site__c,sirenum__Site__r.Name, sirenum__Team__c, sirenum__Team__r.Name,
                sirenum__Total_Hours__c, sirenum__Week_Ending__c,sirenum__Worker_Bill__c,
                (SELECT Id, Name,IP_RateCodes__c, sirenum__RateType__c,sirenum__Shift__c, IP_PayrollPresentedRateCode__c, sirenum__Hours__c,sirenum__Charge__c,
                 sirenum__Rate__c ,Portal_Rate_Code__c, sirenum__Date__c, sirenum__Day_Number__c
                 FROM sirenum__Timesheet_Lines__r)
                FROM sirenum__Timesheet__c
                WHERE sirenum__Client__c = :activeUser.AccountId
                ORDER BY sirenum__Worker__r.Name, sirenum__Week_Ending__c DESC]; 
    }
    
    
    
}