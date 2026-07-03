/**
*  @Name: NewBookedTempsComponent>   
*  @Description: <Class to get PastTemp Information>
*/
public without sharing class NewBookedTempsComponentController{
    
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
        System.debug('sitesList--->>>'+mapIdSiteList);
        return mapIdSiteList.values();
    }
    
    /**
*  Description : Method to get Logged-In User NAme
*  @name : fetchUser
*  @param : None
*  @return : String
*  @throws exception-none
*/
    @AuraEnabled
    public static User fetchUser() {
        return getUserInformation();
    }
    
    /**
*  Description : Method to get Candidates Name
*  @name : getCandidateListLoggedInUser
*  @param : String siteId
*  @return : Map<id,List<Contact>>
*  @throws exception-none
*/
    @AuraEnabled
    public static List<Contact> getCandidateListLoggedInUser(String siteId) {
        DateTime dtnow = system.now();
        system.debug('=siteId='+siteId);
        Integer lmt = Limits.getLimitQueryRows() - Limits.getQueryRows();        
        Map<Id,List<Contact>> mapSiteIdContactList = new Map<Id,List<Contact>>();
        set<Id> conIds = new set<Id>();
        String accID = [select id, contact.AccountId from User where id =: UserInfo.getUserId() limit 1][0].contact.AccountId;
        
         List<sirenum__Shift__c> shiftList = new List<sirenum__Shift__c>();
        if(siteId!=null && siteId !=''){
            shiftList = [SELECT Id, sirenum__Contact__c, sirenum__Site__c,sirenum__Contact__r.Name
                         FROM sirenum__Shift__c WHERE sirenum__Scheduled_End_Time__c >: dtnow AND sirenum__Site__c =:siteId AND sirenum__Published__c = True limit: lmt];
        }
        
        
        System.debug(shiftList.size()+'=shiftList='+shiftList);
        if(!shiftList.isEmpty() && shiftList!=null){
            for(sirenum__Shift__c shift : shiftList){
                conIds.add(shift.sirenum__Contact__c);
            }
        }
        system.debug('++++++conIds+++++++++++'+conIds);
        List<Contact> contactList = [Select id, name,AccountId from Contact where id in : conIds limit: lmt];
        System.debug('==contactList='+contactList.size());
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
      //  User u = [select id, contactId,contact.AccountId FROM User WHERE id =: UserInfo.getUserId() limit 1];
        List<sirenum__Shift__c> lstShift = [SELECT Id,sirenum__Team__r.Id,sirenum__Team__c FROM sirenum__Shift__c 
                                            WHERE sirenum__Site__r.Id=:siteId AND sirenum__Scheduled_Start_Time__c >= Today AND 
                                            sirenum__Cancelled__c = False

                                            ORDER BY sirenum__Scheduled_Start_Time__c 
                                            LIMIT 100];
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
    public static List<sirenum__Shift__c> getAllFutureShifts(String candidateId, String site, String jobrole, String timeframe){
        String accID = [select id, contact.AccountId from User where id =: UserInfo.getUserId() limit 1][0].contact.AccountId;
        String conID = [SELECT Id, contactId FROM User WHERE id =: UserInfo.getUserId() limit 1].contactId;
        system.debug('candidateId '+candidateId);
   
        DateTime dtnow = system.now();
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
        string queryData = 'SELECT Id,Starttime__c,EndTime__c,Scheduled_Start_Date_Text__c,Scheduled_End_Date_Text__c,Scheduled_Start_Time_Text__c,Scheduled_End_Time_Text__c,ClientRankingStored__c,sirenum__Contact__c, sirenum__Contact__r.Name, RankingStored__c,sirenum__Team__r.Name,sirenum__Site__r.name,sirenum__Scheduled_Start_Time__c, sirenum__Scheduled_End_Time__c FROM sirenum__Shift__c WHERE sirenum__Published__c = True AND';
        
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
                    queryData = queryData + ' sirenum__Scheduled_Start_Time__c = TODAY AND sirenum__Scheduled_End_Time__c >: dtnow AND ';
                }
                else
                {
                    queryData = queryData + ' sirenum__Scheduled_Start_Time__c >=:startdate AND sirenum__Scheduled_Start_Time__c <=: enddate AND ';
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
                
                queryData = queryData + ' sirenum__Scheduled_Start_Time__c = NEXT_N_DAYS:'+numberDaysDue+' AND ';
            }
        }
        
        if(site!=null && site !=''){
            queryData = queryData + ' (sirenum__Site__c =: site OR sirenum__site__r.Name =: site) AND ';
        }
        if((candidateId!=null) && (jobrole==null ))
        {
            queryData = queryData + ' (sirenum__Contact__c =: candidateId or sirenum__Contact__r.Name =: candidateId) AND';
        }
        else if((candidateId==null ) && (jobrole!=null )){
            System.debug('Inside Job role loops');
            queryData = queryData + ' (sirenum__Team__c =: jobrole OR sirenum__Team__r.Name =: jobrole) AND';
            
        }   
        else if((candidateId!=null ) && (jobrole!=null ))
        {
            queryData = queryData + ' (sirenum__Contact__c =: candidateId or sirenum__Contact__r.Name =: candidateId) AND (sirenum__Team__c =: jobrole OR sirenum__Team__r.Name =: jobrole) AND ';
        }           
        
        queryData = queryData +' sirenum__Scheduled_End_Time__c >: dtnow and sirenum__Contact__c !=null AND sirenum__Cancelled__c != True AND sirenum__Site__r.sirenum__Operating_Company__c =: accID ORDER BY sirenum__Scheduled_Start_Time__c LIMIT 100';
        
        System.debug('queryData-->'+queryData);
        List<sirenum__Shift__c> shiftList = Database.query(queryData);
        return shiftList;
        
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
        System.debug('sitesList--->>>'+mapIdSiteList);
        return mapIdSiteList;
    }
   
    /**
*  Description : Method to get the List of competenicies of Candidtae
*  @name : getContactCompetencies
*  @param : String contactId
*  @return : String 
*  @throws exception-none
*/
    
    @Auraenabled
    public static List<sirenum__Ticket__c> getContactCompetencies(String shiftId){
        System.debug('==shiftId==='+shiftId);
        list<sirenum__Shift__c> lstShift = [SELECT Id,sirenum__Team__r.id, sirenum__Team__c, sirenum__Contact__c, sirenum__Contact__r.id
                                            FROM sirenum__Shift__c 
                                            WHERE id=:shiftId];
        
        System.debug(lstShift.size()+'===lstShift=='+lstShift);
        Set<id> setJobRoleId = new Set<id>();
        Set<id> setCandidateId = new Set<id>();
        if(!lstShift.isEmpty()){
            for (sirenum__Shift__c Shift: lstShift) {
                if(Shift.sirenum__Team__c != null){
                    setJobRoleId.add(Shift.sirenum__Team__r.id);
                }
                if(Shift.sirenum__Contact__c != null){
                    setCandidateId.add(Shift.sirenum__Contact__r.id);
                }
            }
        }
        List<sirenum__Sirenum_Condition_Membership__c> lstCompetencyCondition = [SELECT id,sirenum__TicketType__c,sirenum__TicketType__r.Name
                                                                                 FROM sirenum__Sirenum_Condition_Membership__c WHERE sirenum__Team__c IN: setJobRoleId];
        if(lstCompetencyCondition.isEmpty()){
          return null;  
        }
        Set<id> setCompetencyTypeId = new Set<id>();
        for(sirenum__Sirenum_Condition_Membership__c scm : lstCompetencyCondition){
            setCompetencyTypeId.add(scm.sirenum__TicketType__r.id);
        }
        
        list<sirenum__Ticket__c> lstTicket = [SELECT Id, sirenum__TicketType__r.Name, sirenum__Valid_from__c, sirenum__Valid_until__c FROM sirenum__Ticket__c
                                              WHERE sirenum__TicketType__c IN: setCompetencyTypeId ];
        Set<id> setTicketsId = new set<id>();
        for(sirenum__Ticket__c tk : lstTicket){
            setTicketsId.add(tk.id);
        }                                    
        System.debug(setTicketsId.size()+'==setTicketsId=='+setTicketsId);
        System.debug('==setCandidateId=='+setCandidateId);
        List<sirenum__Ticket__c> lstCompetencies = new List<sirenum__Ticket__c>();
        if(!setTicketsId.isEmpty()){
            if(!setCandidateId.isEmpty()){
                lstCompetencies = [SELECT id,sirenum__Owner__r.Name,sirenum__TicketType__r.Name,sirenum__Valid_from__c,sirenum__Valid_until__c
                                   FROM sirenum__Ticket__c WHERE id IN: setTicketsId AND sirenum__Owner__r.id IN: setCandidateId LIMIT 10];
            }
        }else{
          /* if(!setCandidateId.isEmpty()){
             lstCompetencies = [SELECT id,sirenum__Owner__r.Name,sirenum__TicketType__r.Name,sirenum__Valid_from__c,sirenum__Valid_until__c
                                FROM sirenum__Ticket__c WHERE sirenum__Owner__r.id IN: setCandidateId LIMIT 10];
           } */
           return null;
        }
       
        return lstCompetencies;
    }
    
    /**
*  Description : Method to get the Phone number from custom setting
*  @name : rejectToGetPhone
*  @param : String contactId
*  @return : String 
*  @throws exception-none
*/
    
    @Auraenabled
    public static IP_Shift_Template__c rejectToGetPhoneEmail(String shiftId){
        Id loggedInUserId = UserInfo.getUserId();
        User u = [SELECT id,ContactId FROM User WHERE id = :loggedInUserId Limit 1];
        Contact cont = [SELECT id,Name,AccountId,Account.Name FROM Contact WHERE id =:u.contactId];
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        List< sirenum__Shift__c > lstShift = [SELECT id, Owner.Name, sirenum__Site__r.Name, IP_BranchOfOwner__c, sirenum__Contact__r.Name, sirenum__Team__r.Name, sirenum__Location__r.Name, sirenum__Scheduled_Start_Time__c, sirenum__Scheduled_End_Time__c
                                              FROM sirenum__Shift__c WHERE id=:shiftId];
        
        List<String> lstToreturn = new List<String>();
        //List<Contact> lstCon = [SELECT id,Name, IP_TempestDepartment__c FROM Contact WHERE Id=:contactId];
        if(lstShift.size()>0){
            IP_Shift_Template__c shiftTemplateCS = IP_Shift_Template__c.getValues(lstShift[0].IP_BranchOfOwner__c );
            System.debug('==shiftTemplateCS==='+shiftTemplateCS);
            if(shiftTemplateCS.Email__c != null){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> sendTo = new List<String>();
                //sendTo.add('pradeep.kumar@espire.com');
                //sendTo.add('deeps.badhan@impellam.com');
               // sendTo.add('deepik.badhan@impellam.com');
                sendTo.add(shiftTemplateCS.Email__c);
                mail.setToAddresses(sendTo);
                String subject = 'Placement cancelled by '+ cont.Account.Name+' at '+lstShift[0].sirenum__Site__r.Name;
                mail.setSubject(subject);
                String body = 'Hi, <br><br>';
                body += cont.Name+' has cancelled the following shift: '+ lstShift[0].sirenum__Contact__r.Name + ' as a '+ lstShift[0].sirenum__Team__r.Name+', for '+cont.Account.Name+' at '+lstShift[0].sirenum__Site__r.Name+', '+lstShift[0].sirenum__Scheduled_Start_Time__c+' and '+lstShift[0].sirenum__Scheduled_End_Time__c+'.<br><br>';
                body += 'Please contact the client and then the candidate to confirm this cancellation to this placement, and update the scheduler accordingly. <br><br>';
                body += 'Thanks,<br> Jobscience.';
                mail.setHtmlBody(body);
                mails.add(mail);
            }
            
            Messaging.sendEmail(mails);
            return shiftTemplateCS;
        }else{
            return null;
        }
    }
    
    /**
*  Description : Method to get Logged-In User Information
*  @name : getUserInformation
*  @param : None
*  @return : User
*  @throws exception-none
*/
    private static User getUserInformation() {
        User user = [SELECT id, email, Name,username, firstname, lastname, phone, title,
                     street, city, country, postalcode, User_Image__c,state, contact.email
                     FROM User WHERE id = :UserInfo.getUserId()];
        system.debug('++++++++++++++'+user);
        return User;
    }
}