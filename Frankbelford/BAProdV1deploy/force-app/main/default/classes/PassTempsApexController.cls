/**
*  @Name: PassTempsComponentController>   
*  @Date Created: <01/04/2019>
*  @Description: <Class to get PastTemp Information>
*/
public without sharing class PassTempsApexController{

    @AuraEnabled
    public static String echo(String message) {
        return message;
    }

    /**
    *  Description : Method to get Sites Name
    *  @name : getSitesOfLoggedInUser
    *  @param : None
    *  @return : List<sirenum__Site__c>
    *  @throws exception-none
    */
    @AuraEnabled
    public static List<sirenum__Site__c> getSitesOfLoggedInUser() {
        Map<Id,Sirenum__Site__c> mapIdSiteList = getSiteList();
        return mapIdSiteList.values();
    }

    /**
    *  Description : Method to get Logged-In User Information
    *  @name : fetchUserInformation
    *  @param : None
    *  @return : User
    *  @throws exception-none
    */
    @AuraEnabled
    public static User fetchUserInformation() {
        return getUserInformation();
    }

    @AuraEnabled
    public static List<Contact> getCandidateListLoggedInUser(String siteId) {
        Integer lmt = Limits.getLimitQueryRows() - Limits.getQueryRows();
        List<Id> conIds = new List<Id>();
        Id loggedInUserId = UserInfo.getUserId();
        User u = [SELECT id,ContactId FROM User WHERE id = :loggedInUserId Limit 1];
        Contact cont = [SELECT id,AccountId FROM Contact WHERE id = :u.contactId];

        List<sirenum__Site__c> lstSites = [SELECT Id,Name FROM sirenum__Site__c WHERE
        sirenum__Operating_Company__c = :cont.AccountId
        AND (IP_MainContact__c =: cont.ID OR Emergency_Contact__c=:cont.ID OR IP_InvoiceContact__c =:cont.Id) ORDER BY Name ASC limit: lmt];


        List<sirenum__Shift__c> shiftList = new List<sirenum__Shift__c>();
        if(siteId!=null && siteId !=''){
            shiftList = [SELECT Id, sirenum__Contact__c, sirenum__Site__c,sirenum__Contact__r.Name
            FROM sirenum__Shift__c WHERE sirenum__Published__c = True AND sirenum__Scheduled_Start_Time__c = LAST_N_DAYS:30 AND sirenum__Site__c =:siteId limit: lmt];
        }else{
            shiftList = [SELECT Id, sirenum__Contact__c, sirenum__Site__c,sirenum__Contact__r.Name
            FROM sirenum__Shift__c WHERE sirenum__Published__c = True AND sirenum__Scheduled_Start_Time__c = LAST_N_DAYS:30 AND sirenum__Site__c =:lstSites[0].id limit: lmt];
        }
        if(!shiftList.isEmpty() && shiftList!=null){
            for(sirenum__Shift__c shift : shiftList){
                conIds.add(shift.sirenum__Contact__c);
            }
        }
        List<Contact> contactList = [Select id, name,AccountId from Contact where id in : conIds order by Name limit: lmt];
        return contactList;
    }

    /**
*  Description : Method to get JobRoles Name
*  @name : getJobRoles
*  @param : None
*  @return : List<sirenum__Team__c>
*  @throws exception-none
*/
    @Auraenabled
    public static List<sirenum__Team__c> getJobRoleList(String siteId){
        List<sirenum__Shift__c> lstShift = [SELECT Id,sirenum__Team__r.Id,sirenum__Team__c FROM sirenum__Shift__c
        WHERE sirenum__Site__r.Id=:siteId AND sirenum__Scheduled_Start_Time__c = LAST_N_DAYS:30 AND sirenum__Scheduled_End_Time__c < TODAY AND
        sirenum__Contact__c!=null AND sirenum__Published__c = True ORDER BY sirenum__Scheduled_Start_Time__c DESC
        LIMIT 100];
        System.debug('==lstShift=='+lstShift.size());
        set<id> jobRoleIds = new set<id>();
        for(sirenum__Shift__c sh: lstShift ){
            jobRoleIds.add(sh.sirenum__Team__r.Id);
        }
        List<sirenum__Team__c> jobRoleList = [SELECT id,Name FROM sirenum__Team__c WHERE Id IN:jobRoleIds];
        return jobRoleList;
    }

    /**
    *  Description : Method to get Past Shifts
    *  @name : getAllPastShifts
    *  @param : String siteId,string jobRoleId,String candidateId,string timePeriod
    *  @return : List<sirenum__Team__c>
    *  @throws exception-none
    */
    @Auraenabled
    public static List<sirenum__Shift__c> getAllPastShifts(String siteId,string jobRoleId,String candidateId,string timePeriod){
        String accID = [select id, contact.AccountId from User where id =: UserInfo.getUserId() limit 1][0].contact.AccountId;
        String conID = [SELECT Id, contactId FROM User WHERE id =: UserInfo.getUserId() limit 1].contactId;

        Datetime dtnow = System.now();
        Datetime shiftStartDate;
        Datetime shiftEndDate;
        String[] frompage;

        String datetoCheck = String.valueof(Date.valueof(System.today()));

        List<sirenum__Shift__c> shiftsList = new List<sirenum__Shift__c>();
        string queryData = 'SELECT Id,Starttime__c,EndTime__c,Scheduled_Start_Date_Display__c,Scheduled_End_Date_Display__c,Scheduled_Start_Date_Text__c,Scheduled_End_Date_Text__c,Scheduled_Start_Time_Text__c,Scheduled_End_Time_Text__c,ClientRankingStored__c,ClientBlueArrowRakingStored__c, sirenum__Contact__r.Name, RankingStored__c,sirenum__Team__r.Name,sirenum__Site__r.name,sirenum__Scheduled_Start_Time__c, sirenum__Scheduled_End_Time__c FROM sirenum__Shift__c WHERE ';

        if(timePeriod != null && timePeriod != '') {
            if(timePeriod.equals('lastmonth')) {
                queryData = queryData + ' sirenum__Scheduled_Start_Time__c = LAST_N_DAYS:30 AND sirenum__Scheduled_End_Time__c <:dtnow AND ';
            } else if(!timePeriod.contains('-')) {

                String datetoday = String.valueOf(getFormatedDatetime(timePeriod).date()); //String.valueOf(Date.newInstance(year1, month1, date1));
                DateTime startdate = getFormatedDatetime(timePeriod); //DateTime.newInstance(year1, month1, date1,00,00,00);
                DateTime enddate = getFormatedDatetime(timePeriod).addDays(1).addSeconds(-1); //DateTime.newInstance(year1, month1, date1, 23, 59, 59);

                if(datetoday == datetoCheck) {
                    queryData = queryData + ' sirenum__Scheduled_End_Time__c = Today AND sirenum__Scheduled_End_Time__c <:dtnow AND ';
                } else {
                    queryData = queryData + ' sirenum__Scheduled_Start_Time__c >:startdate AND sirenum__Scheduled_Start_Time__c <: enddate AND sirenum__Scheduled_End_Time__c <:dtnow AND ';
                }
            } else {
                frompage = timePeriod.split('-');
                shiftStartDate = getFormatedDatetime(frompage[0]);
                shiftEndDate = getFormatedDatetime(frompage[1]).addHours(23);
                queryData = queryData + ' sirenum__Scheduled_Start_Time__c >= '+shiftStartDate.format('yyyy-MM-dd\'t\'HH:mm:ss\'z\'')+' AND sirenum__Scheduled_End_Time__c <= ' + shiftEndDate.format('yyyy-MM-dd\'t\'HH:mm:ss\'z\'') + ' AND ';
            }
        } else {
            queryData = queryData + ' sirenum__Scheduled_End_Time__c <:dtnow AND ';
        }

        if(siteId == null) {
            List<sirenum__Site__c> sitesList= [select id,Name from sirenum__Site__c where (IP_MainContact__c =: conID OR Emergency_Contact__c=:conID OR IP_InvoiceContact__c =:conID) AND sirenum__Operating_Company__c =:accID];
            siteId = String.valueOf(sitesList[0].id);
        }

        if(siteId!=null && siteId !='') {
            queryData = queryData + ' sirenum__Site__c =: siteId AND ';
        } else {
            queryData = queryData + ' (sirenum__Site__r.IP_MainContact__c =: conID OR sirenum__Site__r.Emergency_Contact__c=:conID OR sirenum__Site__r.IP_InvoiceContact__c =:conID) AND ';
        }

        if(candidateId!=null && candidateId!=''){
            queryData = queryData + ' sirenum__Contact__c =: candidateId AND ';
        }

        if(jobRoleId!=null && jobRoleId!=''){
            queryData = queryData + ' sirenum__Team__c =: jobRoleId AND ';
        }

        queryData = queryData +' sirenum__Contact__c!=null AND sirenum__Cancelled__c != True AND sirenum__Published__c = True ORDER BY sirenum__Scheduled_Start_Time__c DESC LIMIT 50000';
        shiftsList = Database.query(queryData);
        return shiftsList;
    }

    /**
    *  Description : Method to get Site Information
    *  @name : getSiteList
    *  @param : None
    *  @return : Map<Id,Sirenum__Site__c>
    *  @throws exception-none
    */
    private static Map<Id,Sirenum__Site__c> getSiteList() {
        Integer lmt = Limits.getLimitQueryRows() - Limits.getQueryRows();
        Id loggedInUserId = UserInfo.getUserId();
        User u = [SELECT id,ContactId FROM User WHERE id = :loggedInUserId Limit 1];
        Contact cont = [SELECT id,AccountId FROM Contact WHERE id =:u.contactId];

        List < Id > siteIds = new List < Id > ();
        List<Contact_Site_link__c> lstContactList = [SELECT Id,Account__c, IP_Site__c,IP_Site__r.id, IP_Contact__c FROM Contact_Site_link__c
        WHERE IP_Contact__r.Id=:cont.id AND Account__r.Id=:cont.AccountId AND IP_PortalType__c!=null];
        System.debug(lstContactList.size()+'==lstContactList=='+lstContactList);
        for(Contact_Site_link__c conSiteLink : lstContactList){
            siteIds.add(conSiteLink.IP_Site__r.id);
        }
        Map<Id,Sirenum__Site__c> mapIdSiteList = new Map<Id,Sirenum__Site__c>([SELECT Id,Name, sirenum__Operating_Company__c FROM sirenum__Site__c WHERE
                id IN: siteIds ORDER BY name ASC limit: lmt]);
        return mapIdSiteList;
    }

    /**
     * @param dateStr 'Mon, 1 Mar 21 - Tue, 9 Mar 21'
     *
     * @return Datetime
     */
    private static Datetime getFormatedDatetime(String dateStr){
        Datetime formatedDt;
        Map<String,String> monthnumbermap = new Map<String,String>();
        monthnumbermap.put('Jan','01');
        monthnumbermap.put('Feb','02');
        monthnumbermap.put('Mar','03');
        monthnumbermap.put('Apr','04');
        monthnumbermap.put('May','05');
        monthnumbermap.put('Jun','06');
        monthnumbermap.put('Jul','07');
        monthnumbermap.put('Aug','08');
        monthnumbermap.put('Sep','09');
        monthnumbermap.put('Oct','10');
        monthnumbermap.put('Nov','11');
        monthnumbermap.put('Dec','12');

        String[] frompage1 = dateStr.split(',');
        String[] reqdate = frompage1[1].split(' ');
        Integer date21 =  Integer.valueof(reqdate[1]);
        String monthtxt = reqdate[2];
        Integer month2;
        String yearmid1 = (reqdate[3]);
        Integer year2 = Integer.ValueOf('20' + yearmid1);
        month2 = Integer.valueof(monthnumbermap.get(monthtxt));
        formatedDt = Datetime.newInstance(year2, month2, date21);

        return formatedDt;
    }


    /**
    *  Description : Method to format String value to Date
    *  @name : submitRatings
    *  @param : Id shiftID, String selectedRating
    *  @return : nothing
    *  @throws exception-none List<sirenum__Shift__c>
    */
    @AuraEnabled
    public static List<sirenum__Shift__c> submitRatings(Id shiftID, String selectedRating, String siteId, String jobRoleId, String candidateId, String timePeriod) {
        sirenum__Shift__c shift = [SELECT Id,RankingStored__c,ClientRankingStored__c, sirenum__Site__c,sirenum__Team__c,sirenum__Contact__c,
                sirenum__Site__r.sirenum__Operating_Company__c
        FROM sirenum__Shift__c
        WHERE id =: shiftID limit 1 ];
        System.debug('=shift='+shift);
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
                    //sirenum__Rota__c = shift.sirenum__Team__r.sirenum__Rota__c,
                    sirenum__Contact__c = shift.sirenum__Contact__c,
                    Shift__c = shift.Id);
            if(shift.ClientRankingStored__c==null){
                shift.ClientRankingStored__c=selectedRating;
            }
            update shift;
        }
        List<sirenum__Shift__c> lstSite = getAllPastShifts(siteId,jobRoleId,candidateId,timePeriod);
        return lstSite;
    }


    /**
    *  Description : Method to get Logged-In User Information
    *  @name : getUserInformation
    *  @param : None
    *  @return : User
    *  @throws exception-none
    */
    private static User getUserInformation() {
        User user = [SELECT id, Name, User_Image__c FROM User WHERE id = :UserInfo.getUserId()];
        return User;
    }
}