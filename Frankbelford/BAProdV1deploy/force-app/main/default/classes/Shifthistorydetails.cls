public  without sharing class Shifthistorydetails {
    @AuraEnabled
    public static List<sirenum__Shift__c> getShiftshistory(String site, String jobrole, String timeframe) {

        DateTime dtnow = System.now();
        Map<String,id> comparelist1 = new Map<String,id>();

        System.debug('Timeframe check'+timeframe);
        String accID = [select id, contact.AccountId from User where id =: UserInfo.getUserId() limit 1][0].contact.AccountId;
        String conID = [select id, contactId from User where id =: UserInfo.getUserId() limit 1][0].contactId;
        Integer counter = 0;

        for(sirenum__Shift__c s: PassTempsApexController.getAllPastShifts(site, jobrole, null, timeframe)) {
            counter++;
            if(String.isBlank(timeframe) && counter > 100){
                break;
            }
            if(!comparelist1.containsKey(String.valueof(s.sirenum__Scheduled_Start_Time__c)+String.valueOf(s.sirenum__Scheduled_End_Time__c)+s.sirenum__Site__c+s.sirenum__Team__c)) {
                comparelist1.put(String.valueof(s.sirenum__Scheduled_Start_Time__c)+String.valueOf(s.sirenum__Scheduled_End_Time__c)+s.sirenum__Site__c+s.sirenum__Team__c,s.id);
            }
        }

        List<sirenum__Shift__c> returnshift = [SELECT Id,sirenum__Published__c,Scheduled_Start_Date_Text__c,Scheduled_End_Date_Text__c,TexsT__c,TexeT__c, sirenum__Contact__c,name,ClientBlueArrowRakingStored__c,RankingStored__c, sirenum__Actual_Start_Time__c,sirenum__Actual_End_Time__c,sirenum__Break_Length__c,sirenum__Scheduled_Start_Time__c,EndTime__c,Createddate, Starttime__c ,sirenum__Scheduled_End_Time__c, sirenum__Team__r.name, sirenum__Site__r.name,sirenum__Cancelled__c
                                                FROM sirenum__Shift__c
                                                where id in:comparelist1.values()
                                                AND sirenum__Site__r.sirenum__Operating_Company__c =: accID
                                                ORDER BY sirenum__Scheduled_Start_Time__c DESC limit 50000];
        system.debug('Returned shifts'+returnshift);
        List<sirenum__Shift__c> allShiftList = [SELECT Id,sirenum__Published__c,Scheduled_Start_Date_Text__c,Scheduled_End_Date_Text__c,TexsT__c,TexeT__c, ClientBlueArrowRakingStored__c,RankingStored__c,sirenum__Contact__c,sirenum__Broadcasts__c,sirenum__Team__c,sirenum__Site__c,sirenum__Scheduled_Start_Time__c, sirenum__Scheduled_End_Time__c,sirenum__Cancelled__c
                                                FROM sirenum__Shift__c
                                                WHERE sirenum__Scheduled_Start_Time__c <: dtnow
                                                AND (sirenum__Site__r.IP_MainContact__c =: conID OR sirenum__Site__r.Emergency_Contact__c=:conID OR sirenum__Site__r.IP_InvoiceContact__c =:conID)
                                                AND sirenum__Site__r.sirenum__Operating_Company__c =: accID limit 50000];
        for(sirenum__Shift__c sh : returnshift){
            Integer x = 0;
            Integer y = 0;
            Integer z = 0;
            for(sirenum__Shift__c ash : allShiftList){
                If(ash.sirenum__Contact__c!=null && sh.sirenum__Scheduled_Start_Time__c == ash.sirenum__Scheduled_Start_Time__c
                        && sh.sirenum__Scheduled_End_Time__c == ash.sirenum__Scheduled_End_Time__c
                        && sh.sirenum__Site__c == ash.sirenum__Site__c
                        && sh.sirenum__Team__c == ash.sirenum__Team__c
                        && ash.sirenum__Published__c == True
                        && !ash.sirenum__Cancelled__c
                        ){
                    x=x+1;
                }
                If((ash.sirenum__Contact__c==null || (ash.sirenum__Contact__c!=null && ash.sirenum__Published__c == false)) && sh.sirenum__Scheduled_Start_Time__c == ash.sirenum__Scheduled_Start_Time__c
                        && sh.sirenum__Scheduled_End_Time__c == ash.sirenum__Scheduled_End_Time__c
                        && sh.sirenum__Site__c == ash.sirenum__Site__c
                        && sh.sirenum__Team__c == ash.sirenum__Team__c
                        && ash.sirenum__Broadcasts__c == null
                        && !ash.sirenum__Cancelled__c
                        ){
                    y=y+1;
                }
                If(ash.sirenum__Contact__c==null &&
                        sh.sirenum__Scheduled_Start_Time__c == ash.sirenum__Scheduled_Start_Time__c
                        && sh.sirenum__Scheduled_End_Time__c == ash.sirenum__Scheduled_End_Time__c
                        && sh.sirenum__Site__c == ash.sirenum__Site__c
                        && sh.sirenum__Team__c == ash.sirenum__Team__c
                        && ash.sirenum__Broadcasts__c > 0
                        && !ash.sirenum__Cancelled__c
                        ){
                    z=z+(integer)ash.sirenum__Broadcasts__c;
                }
            }
            sh.X__c = x;
            sh.Y__c = y;
            sh.Z__c = z;
        }
        return returnshift;
    }

    @AuraEnabled
    public static List<sirenum__Site__c> getSites() {
        List<sirenum__Site__c> sitesList = ActiveVacancyControlller.getSites();
        System.debug('sitesList--->>>'+sitesList);
        return sitesList;
    }
    
    @AuraEnabled
    public static List<sirenum__Team__c> getJobRoles() {
        String accID = [select id, contact.AccountId from User where id =: UserInfo.getUserId() limit 1][0].contact.AccountId;
        system.debug('check accID'+accID);
        String conID = [select id, contactId from User where id =: UserInfo.getUserId() limit 1][0].contactId;
        List<sirenum__Team__c> JobRoles = [SELECT id,Name FROM sirenum__Team__c where sirenum__Account__r.sirenum__Client__c =:accID ORDER BY Name ASC];
        System.debug('check job role list'+JobRoles);
        return JobRoles;
        //  return jobrole;
    }

    @AuraEnabled
    public static List<sirenum__Shift__c> submitRatings(Id shiftID, String selectedRating, String siteId, String jobRoleId, String candidateId, String timePeriod) {
        sirenum__Shift__c shift = [SELECT Id,RankingStored__c,ClientRankingStored__c,ClientBlueArrowRakingStored__c, sirenum__Site__c,sirenum__Team__c,sirenum__Contact__c,
                sirenum__Site__r.sirenum__Operating_Company__c
        FROM sirenum__Shift__c
        WHERE id =: shiftID limit 1 ];
        String Rating;
        system.debug('===enter in rating method=='+shift);
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


            RecordType rateRec = [Select Id From RecordType Where sObjectType = 'sirenum__Ranking__c' And DeveloperName = 'ClientBlueArrow_Ratings'];


            insert new sirenum__Ranking__c(sirenum__Rank__c=Rating,
                    sirenum__Account__c=shift.sirenum__Site__r.sirenum__Operating_Company__c,
                    sirenum__Site__c = shift.sirenum__Site__c,
                    sirenum__Job_Role__c =shift.sirenum__Team__c,
                    //sirenum__Rota__c = shift.sirenum__Team__r.sirenum__Rota__c,
                    sirenum__Contact__c = shift.sirenum__Contact__c,
                    Shift__c = shift.Id);
            if(shift.ClientBlueArrowRakingStored__c==null){
                shift.ClientBlueArrowRakingStored__c=selectedRating;
            }
            update shift;
            system.debug('===enter in rating method1111=='+shift);
        }
        List<sirenum__Shift__c> lstSite = getShiftshistory(siteId,jobRoleId,timePeriod);
        system.debug('===enter in rating method260=='+lstSite.size());
        return lstSite;
    }
    @AuraEnabled
    public static User fetchUser() {
        return getUserInformation();
    }
    @testVisible
    private static User getUserInformation() {
        User user = [SELECT id, email, Name,username, usertype, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city, country, postalcode, User_Image__c,state, localesidkey, mobilephone, extension, fax, contact.email
        FROM User WHERE id = :UserInfo.getUserId()];
        system.debug('++++++++++++++'+user);
        return User;
    }
}