public  without sharing class ActiveVacancyControlller {
    @AuraEnabled
    public static User getUserInformation() {
        User user = [SELECT id, email, Name,username, firstname, lastname, phone, title,
                     street, city, country, postalcode, User_Image__c,state, contact.email
                     FROM User WHERE id = :UserInfo.getUserId()];
        system.debug('++++++++++++++'+user);
        return User;
    }
    @AuraEnabled
    public static List<sirenum__Site__c> getSites() {
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
        List < sirenum__Site__c > sitesList = [SELECT id, name, sirenum__Operating_Company__c FROM sirenum__Site__c 
                                               WHERE id IN: siteIds ORDER BY name ASC];
        return sitesList;
    }
    @AuraEnabled
    public static List<sirenum__Shift__c> getAllShifts(String site, String jobrole, String timeframe) {
        
        String accID = [select id, contact.AccountId from User where id =: UserInfo.getUserId() limit 1][0].contact.AccountId;
        String conID = [select id, contactId from User where id =: UserInfo.getUserId() limit 1][0].contactId;
        if(site == null){
            List<sirenum__Site__c> sitesList= [select id,name from sirenum__Site__c where (IP_MainContact__c =: conID OR Emergency_Contact__c=:conID OR IP_InvoiceContact__c =:conID) AND sirenum__Operating_Company__c =:accID ORDER BY Name ASC];
            site= String.valueOf(sitesList[0].id);
        }
        String datetoCheck = String.valueof(Date.valueof(System.today()));
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
        System.debug('Acc ID to check'+accID);
        string queryData = 'SELECT Id,Scheduled_End_Date_Text__c,Scheduled_Start_Date_Text__c,TexsT__c,TexeT__c, X__c,Y__c,Z__c,ClientBlueArrowRakingStored__c,RankingStored__c,sirenum__Team__r.Name,sirenum__Site__r.name,sirenum__Team__c,sirenum__Site__c,sirenum__Scheduled_Start_Time__c, sirenum__Scheduled_End_Time__c FROM sirenum__Shift__c WHERE';
        Date today = System.today();
        Date test = Date.valueOf(today);
        String[] frompage;
        String[] frompage1;
        String[] frompage2;
        String filter = '';
        
        if(timeframe != null && timeframe != '')
        {
            if(timeframe == 'From today...')
            {
                queryData = queryData + ' sirenum__Scheduled_Start_Time__c >= TODAY AND ';
            }
            else if(!timeframe.contains('-'))
            {
                frompage = timeframe.split(',');
                String[] reqdate = frompage[1].split(' ');
                Integer date1 =  Integer.valueof(reqdate[1]);
                String monthtxt = reqdate[2];
                Integer month1;
                String yearmid1 = (reqdate[3]);
                Integer year1 = Integer.ValueOf('20' + yearmid1);
                month1 = Integer.valueof(monthnumbermap.get(monthtxt));
                String datetoday = String.valueOf(Date.newInstance(year1, month1, date1));
                System.debug('checkfinaldate'+datetoday);
                
                DateTime startdate = DateTime.newInstance(year1, month1, date1,00,00,00);
                System.debug('checkfinaldatestartdate '+startdate);
                DateTime enddate = DateTime.newInstance(year1, month1, date1, 23, 59, 59);
                System.debug('checkfinaldateenddate '+enddate);
                if(datetoday == datetoCheck)
                {
                    queryData = queryData + ' sirenum__Scheduled_Start_Time__c = TODAY AND ';
                }
                else
                {
                    queryData = queryData + ' sirenum__Scheduled_Start_Time__c >:startdate AND sirenum__Scheduled_Start_Time__c <: enddate AND ';
                }
            }
            else
            {
                frompage = timeframe.split('-');
                String date1 = frompage[0];
                String date2 = frompage[1];
                System.debug('check date1'+ date1);
                System.debug('check date2'+ date2);
                frompage1 = date1.split(',');
                String[] reqdate = frompage1[1].split(' ');
                Integer date21 =  Integer.valueof(reqdate[1]);
                String monthtxt = reqdate[2];
                Integer month2;
                String yearmid1 = (reqdate[3]);
                Integer year2 = Integer.ValueOf('20' + yearmid1);
                month2 = Integer.valueof(monthnumbermap.get(monthtxt));
                Date datefilter1 = Date.newInstance(year2, month2, date21);
                System.debug('checkfinaldate'+datefilter1);
                frompage2 = date2.split(',');
                String[] reqdate2 = frompage2[1].split(' ');
                Integer date3 =  Integer.valueof(reqdate2[1]);
                String monthtxt1 = reqdate2[2];
                Integer month3;
                String yearmid2 = (reqdate2[3]);
                Integer year3 = Integer.ValueOf('20' + yearmid2);
                month3 = Integer.valueof(monthnumbermap.get(monthtxt1));
                Date datefilter2 = Date.newInstance(year3, month3, date3);
                System.debug('checkfinaldate'+datefilter2);
                Integer numberDaysDue = datefilter1.daysBetween(datefilter2);
                System.debug('check difference'+numberDaysDue);
                queryData = queryData + ' sirenum__Scheduled_Start_Time__c >=:datefilter1 AND sirenum__Scheduled_Start_Time__c <=:datefilter2 AND ';
                
                //   queryData = queryData + ' sirenum__Scheduled_Start_Time__c = NEXT_N_DAYS:'+numberDaysDue+' AND ';
            }
        }
        else
        {
            queryData = queryData + ' sirenum__Scheduled_Start_Time__c >= Today AND ';
        }
        if(site!=null && site !=''){
            queryData = queryData + ' (sirenum__Site__c =: site OR sirenum__site__r.Name =: site) AND ';
        }
        
        if(jobrole!=null && jobrole !=''){
            System.debug('Inside Job role loops');
            queryData = queryData + ' (sirenum__Team__c =: jobrole OR sirenum__Team__r.Name =: jobrole) ';
        }              
        else
        {
            queryData = queryData +' sirenum__Scheduled_Start_Time__c >= Today and sirenum__Site__r.sirenum__Operating_Company__c =: accID AND sirenum__Cancelled__c = False ORDER BY sirenum__Scheduled_Start_Time__c LIMIT 100';
        }
        System.debug('queryData-->'+queryData);
        List<sirenum__Shift__c> shiftList = Database.query(queryData);
        
		Map<String,id> uniqueRecords = new Map<String,id>();
        for (sirenum__Shift__c sh : shiftList){
            if(!uniqueRecords.containsKey(String.valueof(sh.sirenum__Scheduled_Start_Time__c)+String.valueOf(sh.sirenum__Scheduled_End_Time__c)+sh.sirenum__Site__c+sh.sirenum__Team__c)){
                uniqueRecords.put(String.valueOf(sh.sirenum__Scheduled_Start_Time__c)+String.valueOf(sh.sirenum__Scheduled_End_Time__c)+sh.sirenum__Site__c+sh.sirenum__Team__c, sh.id);
            }
         }
        
        List<sirenum__Shift__c> returnshift = [SELECT Id,Scheduled_End_Date_Text__c,Scheduled_Start_Date_Text__c,sirenum__Published__c,TexsT__c,TexeT__c,name,sirenum__Cancelled__c, sirenum__Actual_Start_Time__c,sirenum__Actual_End_Time__c,sirenum__Break_Length__c,sirenum__Scheduled_Start_Time__c,EndTime__c,Createddate, Starttime__c ,sirenum__Scheduled_End_Time__c, sirenum__Team__r.name, sirenum__Site__r.name
                                               FROM sirenum__Shift__c where sirenum__Site__c =: site AND sirenum__Cancelled__c = False AND id in:uniqueRecords.values()  AND sirenum__Site__r.sirenum__Operating_Company__c =: accID  ORDER BY sirenum__Scheduled_Start_Time__c limit 50000];
        
        List<sirenum__Shift__c> allShiftList = [SELECT Id,Scheduled_End_Date_Text__c,Scheduled_Start_Date_Text__c,sirenum__Published__c,TexsT__c,TexeT__c, sirenum__Contact__c,sirenum__Cancelled__c,sirenum__Broadcasts__c,sirenum__Team__c,sirenum__Site__c,sirenum__Scheduled_Start_Time__c, sirenum__Scheduled_End_Time__c 
                                                FROM sirenum__Shift__c
                                                WHERE sirenum__Site__c =: site AND  sirenum__Cancelled__c = False AND sirenum__Scheduled_Start_Time__c >= TODAY AND sirenum__Site__r.sirenum__Operating_Company__c =: accID limit 50000];
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
                If((ash.sirenum__Contact__c==null || (ash.sirenum__Contact__c!=null && ash.sirenum__Published__c == False)) && sh.sirenum__Scheduled_Start_Time__c == ash.sirenum__Scheduled_Start_Time__c
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
            sh.Z__c = z >=x ? z : x;
            
        }
        return returnshift;
    }
    @Auraenabled
    public static List<sirenum__Team__c> getJobRoleList(String siteId){
        User u = [select id, contactId,contact.AccountId FROM User WHERE id =: UserInfo.getUserId() limit 1];
        List<sirenum__Shift__c> lstShift = [SELECT Id,sirenum__Team__r.Id,sirenum__Team__c FROM sirenum__Shift__c 
                                            WHERE sirenum__Site__c=:siteId AND sirenum__Scheduled_Start_Time__c >= Today AND 
                                            sirenum__Cancelled__c = False AND
                                            
                                            sirenum__Site__r.sirenum__Operating_Company__c =: u.contact.AccountId
                                            ORDER BY sirenum__Scheduled_Start_Time__c 
                                            LIMIT 100];
        set<id> jobRoleIds = new set<id>();
        for(sirenum__Shift__c sh: lstShift ){
            jobRoleIds.add(sh.sirenum__Team__r.Id);
        }
        List<sirenum__Team__c> jobRoleList = [SELECT id,Name FROM sirenum__Team__c WHERE Id IN:jobRoleIds];
        return jobRoleList;
    }
}