public class PassTempController {

    
    @AuraEnabled
    public static List<sirenum__Shift__c> getAllShiftsPast(String site, String contact, String jobrole,String filter) {
               String conID = [select id, contactId from User where id =: UserInfo.getUserId() limit 1][0].contactId;
     
            
        string queryData = 'SELECT Id,ClientRankingStored__c, sirenum__Contact__r.Name, RankingStored__c,sirenum__Team__r.Name,sirenum__Site__r.name,sirenum__Scheduled_Start_Time__c, sirenum__Scheduled_End_Time__c FROM sirenum__Shift__c WHERE ';
        if(site!=null && site !=''){
            queryData = queryData + ' sirenum__Site__c =: site AND ';
        }
        if(contact!=null && contact !=''){
            queryData = queryData + ' sirenum__Contact__c =: contact AND ';
        }
        if(jobrole!=null && jobrole !=''){
            queryData = queryData + ' sirenum__Team__c =: jobrole AND ';
        }
        if(filter=='yesterday'){
            queryData = queryData + ' sirenum__Scheduled_Start_Time__c = YESTERDAY AND ';
        }
        if(filter=='last7days'){
            queryData = queryData + ' sirenum__Scheduled_Start_Time__c >= LAST_N_DAYS:7 AND ';
        }
        if(filter=='last14days'){
            queryData = queryData + ' sirenum__Scheduled_Start_Time__c >= LAST_N_DAYS:14 AND ';
        }
        if(filter=='lastmonth'){
            queryData = queryData + ' sirenum__Scheduled_Start_Time__c = LAST_N_DAYS:30 AND ';
        }
        queryData = queryData +' sirenum__Scheduled_Start_Time__c < TODAY AND (sirenum__Site__r.IP_MainContact__c =: conID OR sirenum__Site__r.Emergency_Contact__c=:conID OR sirenum__Site__r.IP_InvoiceContact__c =:conID) ORDER BY sirenum__Scheduled_Start_Time__c desc LIMIT 50000';
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
                                             WHERE sirenum__Scheduled_Start_Time__c < TODAY AND (sirenum__Site__r.IP_MainContact__c =: conID OR sirenum__Site__r.Emergency_Contact__c=:conID OR sirenum__Site__r.IP_InvoiceContact__c =:conID) AND sirenum__Site__r.sirenum__Operating_Company__c =: accID limit 50000];
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
    public static void submitRatings(Id shiftID, String selectedRating) {
        sirenum__Shift__c shift = [SELECT Id,RankingStored__c,ClientRankingStored__c, sirenum__Site__c,sirenum__Team__c,sirenum__Contact__c,sirenum__Team__r.sirenum__Rota__c,
                                   sirenum__Site__r.sirenum__Operating_Company__c
                                   FROM sirenum__Shift__c 
                                   WHERE id =: shiftID limit 1 ];
        String Rating;
        If(shift.sirenum__Contact__c!=null){
            if(selectedRating=='0' || selectedRating=='1'){
                Rating = 'Unsuitable';
            }
            else if(selectedRating=='2'){
                Rating = 'Bad';
            }
            else if(selectedRating=='3'){
                Rating = 'Average';
            }
            else if(selectedRating=='4'){
                Rating = 'Good';
            }
            else if(selectedRating=='5'){
                Rating = 'Excellent';
            }
            RecordType rateRec = [Select Id From RecordType Where sObjectType = 'sirenum__Ranking__c' And DeveloperName = 'ClientCandidate_Ratings']; 
            insert new sirenum__Ranking__c(sirenum__Rank__c=Rating,
                                           sirenum__Account__c=shift.sirenum__Site__r.sirenum__Operating_Company__c,
                                           sirenum__Site__c = shift.sirenum__Site__c,
                                           sirenum__Job_Role__c =shift.sirenum__Team__c,
                                           sirenum__Rota__c = shift.sirenum__Team__r.sirenum__Rota__c,
                                           sirenum__Contact__c = shift.sirenum__Contact__c,
                                           Shift__c = shift.Id);
               if(shift.ClientRankingStored__c==null)
            {
                shift.ClientRankingStored__c=selectedRating;
                
            }
            update shift;
        }
    
}
    
}