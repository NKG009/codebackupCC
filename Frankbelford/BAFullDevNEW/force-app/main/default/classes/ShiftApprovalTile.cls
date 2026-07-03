public class ShiftApprovalTile {

    @AuraEnabled public Integer shiftRequireApproval{get;set;}
   
    @AuraEnabled
    public static Map<string, integer> getAllShifts(String site, String contact, DateTime startDate, DateTime endDate){

        System.debug('site--: '+site);
        List<sirenum__Shift__c> shiftList = getAllShiftsData(site, null, null, null);
        List<sirenum__Shift__c> approvedList = [Select id from sirenum__Shift__c where IP_ClientApproved__c = True 
                                                and sirenum__Site__c =:site and sirenum__Timesheet_summaries__c = null and sirenum__Scheduled_End_Time__c = LAST_N_DAYS:14];

        Map<string, integer> mp = new Map<string, integer>();   
        mp.put('Shifts Requiring Approval',  shiftList.size());
        mp.put('Shifts Approved', approvedList.size());
        mp.put('Total Shifts', shiftList.size()+approvedList.size());
        
        List<sirenum__Site__c> siteList = ShiftApprovalController.getSites();
        return mp;
    }


    @AuraEnabled
    public static Map<string, integer> getAllShiftsFromSiteList(List<String> site, String contact, DateTime startDate, DateTime endDate){

        System.debug('site--: '+site);
        List<sirenum__Shift__c> shiftList = getAllShiftsData(site, null, null, null);
        List<sirenum__Shift__c> approvedList = [Select id from sirenum__Shift__c where IP_ClientApproved__c = True 
                                                and sirenum__Site__c IN:site and sirenum__Timesheet_summaries__c = null and sirenum__Scheduled_End_Time__c = LAST_N_DAYS:14];

        Map<string, integer> mp = new Map<string, integer>();   
        mp.put('Shifts Requiring Approval',  shiftList.size());
        mp.put('Shifts Approved', approvedList.size());
        mp.put('Total Shifts', shiftList.size()+approvedList.size());
        
        List<sirenum__Site__c> siteList = ShiftApprovalController.getSites();
        return mp;
    }
    private static List<sirenum__Shift__c> getAllShiftsData(List<Id> site, String contact, DateTime startDate, DateTime endDate) {
        
        System.debug('site: '+site);
        //    String accID = [select id, contact.AccountId from User where id =: '0051w000000vDDcAAM' limit 1][0].contact.AccountId;
        //    String conID = [select id, contactId from User where id =: '0051w000000vDDcAAM' limit 1][0].contactId;
        
        String accID = [select id, contact.AccountId from User where id =: UserInfo.getUserId() limit 1][0].contact.AccountId;
        String conID = [select id, contactId from User where id =: UserInfo.getUserId() limit 1][0].contactId;
        System.debug('accID: '+accID+' conID:'+conID);
        
        List<String> status = new List<String>(); 
        status.add('Awaiting approval');
        status.add('Not Yet Submitted');
        DateTime val = DateTime.now();
        DateTime dtend;
        if(endDate!=null){
            dtend = endDate.addDays(1); }
        system.debug('##dtend '+dtend);
        String datetoCheck = String.valueof(Date.valueof(System.today()));
        string queryData = 'SELECT Id,Total_Shift_BreakLength__c,Name,sirenum__Placement__c,Break_from_Brekdef__c,Shift_Length_from_Break__c, sirenum__Billable_Start_Time__c, sirenum__Billable_End_Time__c, sirenum__Contact__r.Name,sirenum__Team__r.Name,sirenum__Site__r.name,sirenum__Scheduled_Start_Time__c, sirenum__Scheduled_End_Time__c,sirenum__Actual_Start_Time__c,sirenum__Actual_End_Time__c,Starttime__c,EndTime__c,Break_Length__c,sirenum__Break_Length__c FROM sirenum__Shift__c WHERE ';
        if(contact!=null && contact!=''){
            queryData = queryData + 'sirenum__Contact__c =: contact AND ';
        }
        if(site!=null && !site.isEmpty()){
            queryData = queryData +' sirenum__Site__c IN: site AND ';
        }
        if(startDate!=null){
            queryData = queryData + ' sirenum__Scheduled_Start_Time__c >: startDate AND ';
        }
        if(endDate!=null){
            queryData = queryData + ' sirenum__Scheduled_Start_Time__c <=: dtend AND ';
        }
        system.debug('@@val'+val);
        system.debug('@@startDate '+startDate);
        system.debug('@@endDate '+endDate);
        queryData = queryData +' sirenum__Timesheet_summaries__c = null AND  sirenum__Scheduled_End_Time__c <=:val AND sirenum__Scheduled_End_Time__c = LAST_N_DAYS:14 AND sirenum__Published__c=True AND sirenum__Site__r.sirenum__Operating_Company__c =: accID AND IP_Status__c in : status AND sirenum__site__r.IP_Timesheet_Method__c = \'eTimesheet\' AND sirenum__Contact__c!=null AND sirenum__Cancelled__c = false AND IP_ClientRejected__c !=true ORDER BY sirenum__Scheduled_Start_Time__c';
        system.debug('@@queryData '+queryData);
        List<sirenum__Shift__c> shiftList = Database.query(queryData);
        return shiftList;
    }

    private static List<sirenum__Shift__c> getAllShiftsData(String site, String contact, DateTime startDate, DateTime endDate) {
        
        System.debug('site: '+site);
        //    String accID = [select id, contact.AccountId from User where id =: '0051w000000vDDcAAM' limit 1][0].contact.AccountId;
        //    String conID = [select id, contactId from User where id =: '0051w000000vDDcAAM' limit 1][0].contactId;
        
        String accID = [select id, contact.AccountId from User where id =: UserInfo.getUserId() limit 1][0].contact.AccountId;
        String conID = [select id, contactId from User where id =: UserInfo.getUserId() limit 1][0].contactId;
        System.debug('accID: '+accID+' conID:'+conID);
        
        List<String> status = new List<String>(); 
        status.add('Awaiting approval');
        status.add('Not Yet Submitted');
        DateTime val = DateTime.now();
        DateTime dtend;
        if(endDate!=null){
            dtend = endDate.addDays(1); }
        system.debug('##dtend '+dtend);
        String datetoCheck = String.valueof(Date.valueof(System.today()));
        string queryData = 'SELECT Id,Total_Shift_BreakLength__c,Name,sirenum__Placement__c,Break_from_Brekdef__c,Shift_Length_from_Break__c, sirenum__Billable_Start_Time__c, sirenum__Billable_End_Time__c, sirenum__Contact__r.Name,sirenum__Team__r.Name,sirenum__Site__r.name,sirenum__Scheduled_Start_Time__c, sirenum__Scheduled_End_Time__c,sirenum__Actual_Start_Time__c,sirenum__Actual_End_Time__c,Starttime__c,EndTime__c,Break_Length__c,sirenum__Break_Length__c FROM sirenum__Shift__c WHERE ';
        if(contact!=null && contact!=''){
            queryData = queryData + 'sirenum__Contact__c =: contact AND ';
        }
        if(site!=null && site!=''){
            queryData = queryData +' sirenum__Site__c =: site AND ';
        }
        if(startDate!=null){
            queryData = queryData + ' sirenum__Scheduled_Start_Time__c >: startDate AND ';
        }
        if(endDate!=null){
            queryData = queryData + ' sirenum__Scheduled_Start_Time__c <=: dtend AND ';
        }
        system.debug('@@val'+val);
        system.debug('@@startDate '+startDate);
        system.debug('@@endDate '+endDate);
        queryData = queryData +' sirenum__Timesheet_summaries__c = null AND  sirenum__Scheduled_End_Time__c <=:val AND sirenum__Scheduled_End_Time__c = LAST_N_DAYS:14 AND sirenum__Published__c=True AND sirenum__Site__r.sirenum__Operating_Company__c =: accID AND IP_Status__c in : status AND sirenum__site__r.IP_Timesheet_Method__c = \'eTimesheet\' AND sirenum__Contact__c!=null AND sirenum__Cancelled__c = false AND IP_ClientRejected__c !=true ORDER BY sirenum__Scheduled_Start_Time__c';
        system.debug('@@queryData '+queryData);
        List<sirenum__Shift__c> shiftList = Database.query(queryData);
        return shiftList;
    }
    
    @auraEnabled
    public static Map<string, integer> getChartMap(Integer shiftsRequiringApproval){
        Map<string, integer> mp = new Map<string, integer>();    
        
        List<sirenum__Timesheet__c> approvedList = fetchTimeSheets();
        mp.put('Shifts Requiring Approval',  shiftsRequiringApproval);
        mp.put('Shifts Approved', approvedList.size());
        mp.put('Total Shifts', shiftsRequiringApproval+approvedList.size());
        
        List<sirenum__Site__c> siteList = ShiftApprovalController.getSites();
        System.debug('siteList: '+siteList);
        return mp;
    }
    
    @AuraEnabled
    public static List<sirenum__Timesheet__c> fetchTimeSheets() {
        return TimeSheetInfoWithPagination.fetchTimeSheets();
    }
    
}