public without sharing class BookedTempController{
     @AuraEnabled
     public static List<sirenum__Shift__c> getTempshifts(String site) {
       
        String conID = [select id, contactId from User where id =: UserInfo.getUserId() limit 1][0].contactId;
        //Field sirenum__Actual_Start_Time__c  added by shweta on 19th March 2019
        string queryData = 'SELECT Id, Scheduled_Start_Time_Text__c,sirenum__Actual_Start_Time__c, ClientRankingStored__c, RankingStored__c,sirenum__Contact__r.Salutation,sirenum__Contact__r.Name, sirenum__Team__r.Name,sirenum__Site__r.name,sirenum__Scheduled_Start_Time__c, sirenum__Scheduled_End_Time__c FROM sirenum__Shift__c WHERE ';
        if(site!=null && site !=''){
            queryData = queryData + ' sirenum__Site__c =: site AND ';
        }
 
        
        queryData = queryData +' sirenum__Scheduled_Start_Time__c = Today AND sirenum__Published__c = True ORDER BY sirenum__Scheduled_Start_Time__c LIMIT 50000';
        System.debug('queryData-->'+queryData);
        return(Database.query(queryData));
        
    }
    @AuraEnabled
    public static List<sirenum__Shift__c> getAllShifts(String site, String contact, String jobrole,String filter) {
         DateTime dtnow = system.now();
        String conID = [select id, contactId from User where id =: UserInfo.getUserId() limit 1][0].contactId;
        //Field sirenum__Actual_Start_Time__c  added by shweta on 19th March 2019
        string queryData = 'SELECT Id, Scheduled_Start_Time_Text__c,sirenum__Actual_Start_Time__c, ClientRankingStored__c, RankingStored__c,sirenum__Contact__r.Salutation,sirenum__Contact__r.Name, sirenum__Team__r.Name,sirenum__Site__r.name,sirenum__Scheduled_Start_Time__c, sirenum__Scheduled_End_Time__c FROM sirenum__Shift__c WHERE ';
        if(site!=null && site !=''){
            queryData = queryData + ' sirenum__Site__c =: site AND ';
        }
        if(contact!=null && contact !=''){
            queryData = queryData + ' sirenum__Contact__c =: contact AND ';
        }
        if(jobrole!=null && jobrole !=''){
            queryData = queryData + ' sirenum__Team__c =: jobrole AND ';
        }
        if(filter=='today'){
            queryData = queryData + ' sirenum__Scheduled_Start_Time__c = TODAY AND ';
        }
        if(filter=='tomorrow'){
            queryData = queryData + ' sirenum__Scheduled_Start_Time__c = TOMORROW AND ';
        }
        if(filter=='next7days'){
            queryData = queryData + ' sirenum__Scheduled_Start_Time__c <= NEXT_N_DAYS:7 AND ';
        }
        if(filter=='next14days'){
            queryData = queryData + ' sirenum__Scheduled_Start_Time__c <= NEXT_N_DAYS:14 AND ';
        }
        if(filter=='future'){
            queryData = queryData + ' sirenum__Scheduled_Start_Time__c > NEXT_N_DAYS:14 AND ';
        }
        queryData = queryData +' sirenum__Scheduled_Start_Time__c >= TODAY AND sirenum__Published__c = True ORDER BY sirenum__Scheduled_Start_Time__c LIMIT 50000';
        System.debug('queryData-->'+queryData);
        return(Database.query(queryData));
        
    }
    @AuraEnabled
    public static List<sirenum__Site__c> getSites() {
        String accID = [select id, contact.AccountId from User where id =: UserInfo.getUserId() limit 1][0].contact.AccountId;
        String conID = [select id, contactId from User where id =: UserInfo.getUserId() limit 1][0].contactId;
       
        List<Id> siteIds = new List<Id>();
        
   /*     List<sirenum__Shift__c> shiftList = [SELECT Id, ClientRankingStored__c,RankingStored__c,sirenum__Site__c,sirenum__Site__r.sirenum__Operating_Company__c
                                             FROM sirenum__Shift__c 
                                             WHERE (sirenum__Site__r.IP_MainContact__c =: conID OR sirenum__Site__r.Emergency_Contact__c=:conID OR sirenum__Site__r.IP_InvoiceContact__c =:conID) AND sirenum__Site__r.sirenum__Operating_Company__c =: accID limit 50000 ];
        for(sirenum__Shift__c sh: shiftList){
            siteIds.add(sh.sirenum__Site__c);
        } */
       List<sirenum__Site__c> sitesList= [select id, name,sirenum__Operating_Company__c from sirenum__Site__c where (IP_MainContact__c =: conID OR Emergency_Contact__c=:conID OR IP_InvoiceContact__c =:conID) AND sirenum__Operating_Company__c =:accID];
      System.debug('sitesList--->>>'+sitesList);
        return sitesList;
      }
    
    @AuraEnabled
    public static Map<id,List<Contact>> getsiteContactMap() {
        List<Id> siteIds = new List<Id>();
        List<Id> conIds = new List<Id>();
        Map<id,List<Contact>> siteContactMap = new Map<id,List<Contact>>();
        
        String accID = [select id, contact.AccountId from User where id =: UserInfo.getUserId() limit 1][0].contact.AccountId;
        String conID = [select id, contactId from User where id =: UserInfo.getUserId() limit 1][0].contactId;
  
        List<sirenum__Shift__c> shiftList = [SELECT Id,ClientRankingStored__c,RankingStored__c, sirenum__Contact__c,sirenum__Contact__r.FirstName,sirenum__Contact__r.LastName,sirenum__Contact__r.AccountId,
                                             sirenum__Site__c,sirenum__Site__r.name,sirenum__Site__r.sirenum__Operating_Company__c
                                             FROM sirenum__Shift__c 
                                             WHERE sirenum__Scheduled_Start_Time__c > TODAY AND (sirenum__Site__r.IP_MainContact__c =: conID OR sirenum__Site__r.Emergency_Contact__c=:conID OR sirenum__Site__r.IP_InvoiceContact__c =:conID) AND sirenum__Site__r.sirenum__Operating_Company__c =: accID limit 50000];
        for(sirenum__Shift__c sh: shiftList){
            siteIds.add(sh.sirenum__Site__c);
            conIds.add(sh.sirenum__Contact__c);
        }
        
        List<sirenum__Site__c> sites= [select id, name,sirenum__Operating_Company__c from sirenum__Site__c where id in:siteIds limit 50000];
        
        List<Contact> contacts= [select id, name,AccountId from Contact where id in : conIds];
        for(sirenum__Shift__c sh: shiftList){
            for(Contact con : contacts){
                for(sirenum__Site__c site: sites){
                    if(sh.sirenum__Contact__c == con.id && sh.sirenum__Site__c==site.Id){
                        if(siteContactMap.containsKey(site.id)){
                            List<Contact> conList= siteContactMap.get(site.id);
                            if(conList.isEmpty()){
                                conList.add(con);
                                siteContactMap.put(site.id, conList);
                            }
                            else if(!conList.contains(con)){
                                conList.add(con);
                                siteContactMap.put(site.id, conList);
                            }
                        }
                        else{
                            List<Contact> conList= new List<Contact>();
                            conList.add(con);
                            siteContactMap.put(site.id, conList);
                        }
                    }
                }
            }
        }
        return siteContactMap;
    }    
    
    
    @AuraEnabled
    public static List<sirenum__Team__c> getJobRoles() {
        String accID = [select id, contact.AccountId from User where id =: UserInfo.getUserId() limit 1][0].contact.AccountId;
          String conID = [select id, contactId from User where id =: UserInfo.getUserId() limit 1][0].contactId;
   
        List<Id> jobRoleIds = new List<Id>();
        
        List<sirenum__Shift__c> shiftList = [SELECT Id,ClientRankingStored__c, RankingStored__c,sirenum__Site__c,sirenum__Team__c,sirenum__Site__r.sirenum__Operating_Company__c
                                             FROM sirenum__Shift__c 
                                             WHERE (sirenum__Site__r.IP_MainContact__c =: conID OR sirenum__Site__r.Emergency_Contact__c=:conID OR sirenum__Site__r.IP_InvoiceContact__c =:conID) AND sirenum__Site__r.sirenum__Operating_Company__c =: accID limit 50000 ];
        for(sirenum__Shift__c sh: shiftList){
            jobRoleIds.add(sh.sirenum__Team__c);
        }
        List<sirenum__Team__c> jobrole= [select id, name from sirenum__Team__c where id in:jobRoleIds];
        return jobrole;
    }
    @AuraEnabled
    public static String getPhoneDetails(string shiftId) {
        System.debug('shiftId'+shiftId);
        sirenum__Shift__c shift = [select id,RankingStored__c,ClientRankingStored__c,sirenum__Placement__r.IP_TempestDepartment__c from sirenum__Shift__c where id=:shiftId limit 1];
        IP_Shift_Template__c cs = IP_Shift_Template__c.getInstance(shift.sirenum__Placement__r.IP_TempestDepartment__c);
        System.debug('cs'+cs);
        String phone;
        if(cs!=null && cs.Phone__c!=null && cs.Phone__c!=''){
            phone = cs.Phone__c;
        }
        else{
            phone = '01635 34949';    
        }
        
        return phone;
    }
  
}