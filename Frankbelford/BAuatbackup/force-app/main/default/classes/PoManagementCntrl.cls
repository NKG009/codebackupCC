public class PoManagementCntrl {
     @AuraEnabled
    public static List<sirenum__Site__c> getSitesOfLoggedInUser() {
     String abc1;
        String abc2;
        String abc3;
        String abc4;
        String abc5;
        String abc6;
        String abc7;
        String abc8;
        String abc9;
        String abc10;
        Map<Id,Sirenum__Site__c> mapIdSiteList = getSiteList();
        System.debug('sitesList--->>>'+mapIdSiteList);
        return mapIdSiteList.values();
    }
    
       @AuraEnabled
    public static String UpdateBulkPO(String Ponumber, List<id> placelist){
     String abc1;
        String abc2;
        String abc3;
        String abc4;
        String abc5;
        String abc6;
        String abc7;
        String abc8;
        String abc9;
        String abc10;
        system.debug('@@placelist '+placelist);
        List<sirenum__Placement__c> timelist = [Select id,IP_PurchaseOrderNumber__c from sirenum__Placement__c where id in:placelist];
        for(sirenum__Placement__c t:timelist)
        {
            t.IP_PurchaseOrderNumber__c = Ponumber;
        }
        try
        {
            update timelist;                      return 'SUCCESS';
        }
        catch(Exception e)
        {
            return 'ERROR';
        }
        
    }
    @AuraEnabled
    public static User getUserInformation() {
        
        User user = [SELECT id, email, Name,username, firstname, lastname, phone, title, street, city, country, postalcode, User_Image__c,state, contact.email
                     FROM User WHERE id = :UserInfo.getUserId()];
        return User;
        
    }
     @AuraEnabled
    public static User fetchUser() {
        return getUserInformation();
    }
   
   @Auraenabled
    public static List < sirenum__Team__c > getJobRoleList() {
      /*  String accID = [select id, contact.AccountId from User where id =: UserInfo.getUserId() limit 1][0].contact.AccountId;
        //   String conID = [select id, contactId from User where id =: UserInfo.getUserId() limit 1][0].contactId;
*/

       System.debug('****Method 2***');
          List < sirenum__Team__c > jobRoleList;
        Id loggedInUserId = UserInfo.getUserId();
        User u = [SELECT id,ContactId,contact.AccountId  FROM User WHERE id = :loggedInUserId Limit 1];
          set<Id> siteId = new set<ID>();
          set<Id> jobId = new set<ID>();
       
    for(Contact_Site_link__c lstContactList: [SELECT Id,Account__c, IP_Site__c,IP_Site__r.id, IP_Contact__c,IP_PortalType__c FROM Contact_Site_link__c
                                                     WHERE IP_Contact__r.Id=:u.contactId AND Account__r.Id=:u.contact.AccountId AND IP_PortalType__c!=null])
      {
          siteId.add(lstContactList.IP_Site__c);
      }
        if(u.contactId != null){
            
           Date stdatelist = getStartDate();
            Date Endatelist = getEndDate();
          
            System.debug('Date @@ '+stdatelist +' '+Endatelist);
             
            for(sirenum__Placement__c place: [select id,TotalForecastValue__c,sirenum__Start_Date__c,sirenum__Contract__r.sirenum__PayrollCycle__r.Name,sirenum__End_Date__c,sirenum__Contact__r.Name, sirenum__Job_Role__r.id,IP_PurchaseOrderNumber__c from sirenum__Placement__c where id in (Select sirenum__Placement__c from sirenum__Shift__c where sirenum__Published__c = true and sirenum__Cancelled__c = false and IP_ClientRejected__c = false and sirenum__Scheduled_Start_Time__c >=: stdatelist and  sirenum__Scheduled_Start_Time__c <=:Endatelist) AND sirenum__End_Date__c >=:stdatelist  AND sirenum__Site__c =: siteId])
            {jobId.add(place.sirenum__Job_Role__r.id);}
        }
        if(jobId.size()>0){
            jobRoleList = [SELECT id, Name FROM sirenum__Team__c where id =: jobId];
        }
        return jobRoleList;
    }


      
     
    
    
    
   @Auraenabled
    public  static Map<Id,Sirenum__Site__c> getSiteList() {
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
    
        @Auraenabled
    public static List<Contact> getContactList(){
        Integer lmt = Limits.getLimitQueryRows() - Limits.getQueryRows();
        System.debug('****Method 2***');
         List<Contact> contList;
        Id loggedInUserId = UserInfo.getUserId();
        User u = [SELECT id,ContactId,contact.AccountId  FROM User WHERE id = :loggedInUserId Limit 1];
              set<Id> siteId = new set<ID>();
          set<Id> conId = new set<ID>();
       
    for(Contact_Site_link__c lstContactList: [SELECT Id,Account__c, IP_Site__c,IP_Site__r.id, IP_Contact__c,IP_PortalType__c FROM Contact_Site_link__c
                                                     WHERE IP_Contact__r.Id=:u.contactId AND Account__r.Id=:u.contact.AccountId AND IP_PortalType__c!=null])
      {
          siteId.add(lstContactList.IP_Site__c);
      }
        if(u.contactId != null){
            
            Date stdatelist = getStartDate();
            Date Endatelist = getEndDate();
         
            System.debug('Date @@ '+stdatelist +' '+Endatelist);
             
            for(sirenum__Placement__c place: [select id,TotalForecastValue__c,(Select sirenum__Forecast_Charge__c,sirenum__Total_Charge__c from sirenum__Shifts__r),sirenum__Start_Date__c,sirenum__Contract__r.sirenum__PayrollCycle__r.Name,sirenum__End_Date__c,sirenum__Contact__r.Name, sirenum__Job_Role__r.Name,IP_PurchaseOrderNumber__c from sirenum__Placement__c where id in (Select sirenum__Placement__c from sirenum__Shift__c where sirenum__Published__c = true and sirenum__Cancelled__c = false and IP_ClientRejected__c = false and sirenum__Scheduled_Start_Time__c >=: stdatelist and  sirenum__Scheduled_Start_Time__c <=:Endatelist) AND sirenum__End_Date__c >=:stdatelist  AND sirenum__Site__c =: siteId])
            {conId.add(place.sirenum__Contact__r.id);}
        }
        if(conId.size()>0){
            contList = [select id,Name from Contact where id =: conId ORDER BY name ASC limit: lmt];
        }
        return contList;
    }
    
      @Auraenabled
    public static List<Date> StartDateMonday(String PayrollWeek){
        List<Date> startEndList = new List<Date>();
        List<String> payroll = payrollWeek.split('to');
            String startDay = payroll[0];
            String endDay =payroll[1];
            Date StartDate;
            Date EndDate;
            if(startDay.contains('Monday')){
                Date d = System.today();
                Datetime dt = (DateTime)d;
                String dayOfWeek = dt.format('EEEE');
                if(dayOfWeek == 'Monday'){
                    StartDate = System.today();                    EndDate = System.today()+6;
                }
                else if(dayOfWeek == 'Tuesday'){
                    StartDate = System.today()-1;                    EndDate = System.today()+5;
                }
                else if(dayOfWeek == 'Wednesday'){
                    StartDate = System.today()-2;
                    EndDate = System.today()+4;
                }
                else if(dayOfWeek == 'Thursday'){                    StartDate = System.today()-3;                    EndDate = System.today()+3;
                }
                else if (dayOfWeek == 'Friday'){                    StartDate = System.today()-4;                    EndDate = System.today()+2;
                }
                else if (dayOfWeek == 'Saturday'){                    StartDate = System.today()-5;                    EndDate = System.today()+1;
                }
                else if (dayOfWeek == 'Sunday'){                    StartDate = System.today()-6;                    EndDate = System.today();
                }
                startEndList.add(StartDate);
                 startEndList.add(EndDate);
            }
            return startEndList;
        
    }
      @Auraenabled
    public static List<Date> StartDateSaturday(String PayrollWeek){
        List<Date> startEndList = new List<Date>();
        List<String> payroll = payrollWeek.split('to');
            String startDay = payroll[0];
            String endDay =payroll[1];
            Date StartDate;
            Date EndDate;
           if(startDay.contains('Saturday')){
                Date d = System.today();
                Datetime dt = (DateTime)d;
                String dayOfWeek = dt.format('EEEE');
                if(dayOfWeek == 'Monday'){
                    StartDate = System.today()-2;                    EndDate = System.today()+4;
                }
                else if(dayOfWeek == 'Tuesday'){
                    StartDate = System.today()-3;                    EndDate = System.today()+3;
                }
                else if(dayOfWeek == 'Wednesday'){
                    StartDate = System.today()-4;
                    EndDate = System.today()+2;
                }
                else if(dayOfWeek == 'Thursday'){                    StartDate = System.today()-5;                    EndDate = System.today()+1;
                }
                else if (dayOfWeek == 'Friday'){                    StartDate = System.today()-6;                    EndDate = System.today();
                }
                else if (dayOfWeek == 'Saturday'){                    StartDate = System.today();                    EndDate = System.today()+6;
                }
                else if (dayOfWeek == 'Sunday'){                    StartDate = System.today()-1;                    EndDate = System.today()+5;
                }
                 startEndList.add(StartDate);
                 startEndList.add(EndDate);
            }
            return startEndList;
        
    }
    
      @Auraenabled
    public static List<Date> StartDateSunday(String PayrollWeek){
        List<Date> startEndList = new List<Date>();
        List<String> payroll = payrollWeek.split('to');
            String startDay = payroll[0];
            String endDay =payroll[1];
            Date StartDate;
            Date EndDate;
          if(startDay.contains('Sunday')){
                Date d = System.today();
                Datetime dt = (DateTime)d;
                String dayOfWeek = dt.format('EEEE');
                if(dayOfWeek == 'Monday'){
                    StartDate = System.today()-1;                    EndDate = System.today()+5;
                }
                else if(dayOfWeek == 'Tuesday'){
                    StartDate = System.today()-2;                    EndDate = System.today()+4;
                }
                else if(dayOfWeek == 'Wednesday'){
                    StartDate = System.today()-3;
                    EndDate = System.today()+3;
                }
                else if(dayOfWeek == 'Thursday'){                    StartDate = System.today()-4;                    EndDate = System.today()+2;
                }
                else if (dayOfWeek == 'Friday'){                    StartDate = System.today()-5;                    EndDate = System.today()+1;
                }
                else if (dayOfWeek == 'Saturday'){                    StartDate = System.today()-6;                    EndDate = System.today();
                }
                else if (dayOfWeek == 'Sunday'){                    StartDate = System.today();                    EndDate = System.today()+6;
                }
                startEndList.add(StartDate);
                 startEndList.add(EndDate);
            }
            return startEndList;
        
    }
        @Auraenabled
    public static List<sirenum__Shift__c> getShifts(String placeId, String PayrollWeek){
             List<Date> startEndList = new List<Date>();
            Date stdatelist ;
            Date Endatelist ;
            if(PayrollWeek == 'Monday to Sunday'){
                startEndList = StartDateMonday(PayrollWeek);
                stdatelist= startEndList[0];
                Endatelist= startEndList[1].addDays(1);
            }
            else if(PayrollWeek == 'Saturday to Friday'){
                 startEndList = StartDateSaturday(PayrollWeek);
                stdatelist= startEndList[0];
                Endatelist= startEndList[1].addDays(1);
            }
            else if(PayrollWeek == 'Sunday to Saturday'){
                 startEndList = StartDateSunday(PayrollWeek);
                stdatelist= startEndList[0];
                Endatelist= startEndList[1].addDays(1);
            }
            
            system.debug('Dates ** '+stdatelist +Endatelist);
            
            
        List<sirenum__Shift__c> shiftlist = [Select id,sirenum__Forecast_Charge__c,sirenum__Total_Charge__c,sirenum__Scheduled_Shift_Length_Decimal__c,sirenum__Team__r.Name,sirenum__Scheduled_Start_Time__c,sirenum__Scheduled_End_Time__c from sirenum__Shift__c where sirenum__Published__c = true and sirenum__Cancelled__c = false and IP_ClientRejected__c = false AND sirenum__Scheduled_Start_Time__c >=: stdatelist and  sirenum__Scheduled_Start_Time__c <=:Endatelist and  sirenum__Placement__c =: placeId ORDER By sirenum__Scheduled_Start_Time__c];
        return shiftlist;
    }
    
       @Auraenabled
    public static Date getStartDate(){
          Id loggedInUserId = UserInfo.getUserId();
         User u = [SELECT id,ContactId,contact.AccountId  FROM User WHERE id = :loggedInUserId Limit 1];
           List<sirenum__ProActiveContract__c> sirlink = [Select id,sirenum__Client__r.id,sirenum__PayrollCycle__r.name from sirenum__ProActiveContract__c where sirenum__Client__r.id =: u.contact.AccountId];
          List<Date> stdatelist = new List<Date>();
            List<Date> Endatelist = new List<Date>();
            Date StartDate;
            Date EndDate;
              for(sirenum__ProActiveContract__c slink : sirlink){
                   String payrollWeek = slink.sirenum__PayrollCycle__r.name;
            List<String> payroll = payrollWeek.split('to');
            String startDay = payroll[0];
            String endDay =payroll[1];
            if(startDay.contains('Monday')){
                Date d = System.today();
                Datetime dt = (DateTime)d;
                String dayOfWeek = dt.format('EEEE');
                if(dayOfWeek == 'Monday'){
                    StartDate = System.today();                    EndDate = System.today()+6;
                }
                else if(dayOfWeek == 'Tuesday'){
                    StartDate = System.today()-1;                    EndDate = System.today()+5;
                }
                else if(dayOfWeek == 'Wednesday'){
                    StartDate = System.today()-2;
                    EndDate = System.today()+4;
                }
                else if(dayOfWeek == 'Thursday'){                    StartDate = System.today()-3;                    EndDate = System.today()+3;
                }
                else if (dayOfWeek == 'Friday'){                    StartDate = System.today()-4;                    EndDate = System.today()+2;
                }
                else if (dayOfWeek == 'Saturday'){                    StartDate = System.today()-5;                    EndDate = System.today()+1;
                }
                else if (dayOfWeek == 'Sunday'){                    StartDate = System.today()-6;                    EndDate = System.today();
                }
                stdatelist.add(StartDate);
                Endatelist.add(EndDate);
            }
            else if(startDay.contains('Saturday')){
                Date d = System.today();                Datetime dt = (DateTime)d;                String dayOfWeek = dt.format('EEEE');
                if(dayOfWeek == 'Monday'){                    StartDate = System.today()-2;                    EndDate = System.today()+4;
                }
                else if(dayOfWeek == 'Tuesday'){                    StartDate = System.today()-3;                    EndDate = System.today()+3;
                }
                else if(dayOfWeek == 'Wednesday'){                    StartDate = System.today()-4;                    EndDate = System.today()+2;
                }
                else if(dayOfWeek == 'Thursday'){                    StartDate = System.today()-5;                    EndDate = System.today()+1;
                }
                else if (dayOfWeek == 'Friday'){                    StartDate = System.today()-6;                    EndDate = System.today();
                }
                else if (dayOfWeek == 'Saturday'){                    StartDate = System.today();                    EndDate = System.today()+6;
                }
                else if (dayOfWeek == 'Sunday'){                    StartDate = System.today()-1;                    EndDate = System.today()+5;
                }
                stdatelist.add(StartDate);                Endatelist.add(EndDate);
            }
             else if(startDay.contains('Sunday')){
                Date d = System.today();
                Datetime dt = (DateTime)d;
                String dayOfWeek = dt.format('EEEE');
                if(dayOfWeek == 'Monday'){
                    StartDate = System.today()-1;                    EndDate = System.today()+5;
                }
                else if(dayOfWeek == 'Tuesday'){
                    StartDate = System.today()-2;                    EndDate = System.today()+4;
                }
                else if(dayOfWeek == 'Wednesday'){
                    StartDate = System.today()-3;
                    EndDate = System.today()+3;
                }
                else if(dayOfWeek == 'Thursday'){                    StartDate = System.today()-4;
                    EndDate = System.today()+2;
                }
                else if (dayOfWeek == 'Friday'){                    StartDate = System.today()-5;                    EndDate = System.today()+1;
                }
                else if (dayOfWeek == 'Saturday'){                    StartDate = System.today()-6;                    EndDate = System.today();
                }
                else if (dayOfWeek == 'Sunday'){                    StartDate = System.today();                    EndDate = System.today()+6;
                }
                 stdatelist.add(StartDate);
              //  Endatelist.add(EndDate);
            }
            }
            
          stdatelist.sort();
          
            date sDate = stdatelist.get(0);
           
            return sDate;
    }
    
        @Auraenabled
    public static Date getEndDate(){
        
          Id loggedInUserId = UserInfo.getUserId();
         User u = [SELECT id,ContactId,contact.AccountId  FROM User WHERE id = :loggedInUserId Limit 1];
         
           List<sirenum__ProActiveContract__c> sirlink = [Select id,sirenum__Client__r.id,sirenum__PayrollCycle__r.name from sirenum__ProActiveContract__c where sirenum__Client__r.id =: u.contact.AccountId];
          List<Date> stdatelist = new List<Date>();
            List<Date> Endatelist = new List<Date>();
            Date StartDate;
            Date EndDate;
              for(sirenum__ProActiveContract__c slink : sirlink){
                   String payrollWeek = slink.sirenum__PayrollCycle__r.name;
            List<String> payroll = payrollWeek.split('to');
            String startDay = payroll[0];
            String endDay =payroll[1];
            if(startDay.contains('Monday')){
                Date d = System.today();
                Datetime dt = (DateTime)d;
                String dayOfWeek = dt.format('EEEE');
                if(dayOfWeek == 'Monday'){
                    StartDate = System.today();                    EndDate = System.today()+6;
                }
                else if(dayOfWeek == 'Tuesday'){
                    StartDate = System.today()-1;                    EndDate = System.today()+5;
                }
                else if(dayOfWeek == 'Wednesday'){
                    StartDate = System.today()-2;
                    EndDate = System.today()+4;
                }
                else if(dayOfWeek == 'Thursday'){
                    StartDate = System.today()-3;
                    EndDate = System.today()+3;
                }
                else if (dayOfWeek == 'Friday'){                    StartDate = System.today()-4;                    EndDate = System.today()+2;
                }
                else if (dayOfWeek == 'Saturday'){                    StartDate = System.today()-5;                    EndDate = System.today()+1;
                }
                else if (dayOfWeek == 'Sunday'){                    StartDate = System.today()-6;                    EndDate = System.today();
                }
                stdatelist.add(StartDate);
                Endatelist.add(EndDate);
            }
            else if(startDay.contains('Saturday')){
                Date d = System.today();
                Datetime dt = (DateTime)d;
                String dayOfWeek = dt.format('EEEE');
                if(dayOfWeek == 'Monday'){
                    StartDate = System.today()-2;
                    EndDate = System.today()+4;
                }
                else if(dayOfWeek == 'Tuesday'){                    StartDate = System.today()-3;                    EndDate = System.today()+3;
                }
                else if(dayOfWeek == 'Wednesday'){    
                    StartDate = System.today()-4;      
                    EndDate = System.today()+2;
                }
                else if(dayOfWeek == 'Thursday'){                    StartDate = System.today()-5;                    EndDate = System.today()+1;
                }
                else if (dayOfWeek == 'Friday'){                    StartDate = System.today()-6;                    EndDate = System.today();
                }
                else if (dayOfWeek == 'Saturday'){                    StartDate = System.today();                    EndDate = System.today()+6;
                }
                else if (dayOfWeek == 'Sunday'){                    StartDate = System.today()-1;                    EndDate = System.today()+5;
                }
                stdatelist.add(StartDate);                Endatelist.add(EndDate);
            }
             else if(startDay.contains('Sunday')){
                Date d = System.today();
                Datetime dt = (DateTime)d;
                String dayOfWeek = dt.format('EEEE');
                if(dayOfWeek == 'Monday'){
                    StartDate = System.today()-1;                    EndDate = System.today()+5;
                }
                else if(dayOfWeek == 'Tuesday'){
                    StartDate = System.today()-2;                    EndDate = System.today()+4;
                }
                else if(dayOfWeek == 'Wednesday'){
                    StartDate = System.today()-3;
                    EndDate = System.today()+3;
                }
                else if(dayOfWeek == 'Thursday'){                    StartDate = System.today()-4;                    EndDate = System.today()+2;
                }
                else if (dayOfWeek == 'Friday'){                    StartDate = System.today()-5;                    EndDate = System.today()+1;
                }
                else if (dayOfWeek == 'Saturday'){                    StartDate = System.today()-6;                    EndDate = System.today();
                }
                else if (dayOfWeek == 'Sunday'){                    StartDate = System.today();                    EndDate = System.today()+6;
                }
              //   stdatelist.add(StartDate);
                Endatelist.add(EndDate);
            }
            }
        
         Endatelist.sort();
          
            date eDate = Endatelist.get(Endatelist.size()-1);
           
            return eDate;
         
    }
    
    
    
      @Auraenabled
    public static List<sirenum__Placement__c> getPlaceList(String CandId, String jobroleId){
        System.debug('****Method 2***'+CandId+jobroleId);
        
         List<Contact> contList;
        List<sirenum__Placement__c> place = new List<sirenum__Placement__c>();
           List<sirenum__Placement__c> updateplace = new List<sirenum__Placement__c>();
        Id loggedInUserId = UserInfo.getUserId();
        User u = [SELECT id,ContactId,contact.AccountId  FROM User WHERE id = :loggedInUserId Limit 1];
              set<Id> siteId = new set<ID>();
          set<Id> conId = new set<ID>();
   
    for(Contact_Site_link__c lstContactList: [SELECT Id,Account__c, IP_Site__c,IP_Site__r.id, IP_Contact__c,IP_PortalType__c FROM Contact_Site_link__c
                                                     WHERE IP_Contact__r.Id=:u.contactId AND Account__r.Id=:u.contact.AccountId AND IP_PortalType__c!=null])
      {
          siteId.add(lstContactList.IP_Site__c);
      }
        if(u.contactId != null){
            Date stdatelist = getStartDate();
            Date Endatelist = getEndDate().addDays(1);
         
            System.debug('Date @@ '+stdatelist +' '+Endatelist);
              string queryData = 'select id,TimesheetCheck__c,TotalForecastValue__c,(Select sirenum__Forecast_Charge__c,sirenum__Timesheet_summaries__c,sirenum__Total_Charge__c,sirenum__Scheduled_Start_Time__c from sirenum__Shifts__r  where sirenum__Published__c = true and sirenum__Cancelled__c = false and IP_ClientRejected__c = false and sirenum__Scheduled_Start_Time__c >=: stdatelist and  sirenum__Scheduled_Start_Time__c <=:Endatelist ),sirenum__Start_Date__c,sirenum__Contract__r.sirenum__PayrollCycle__r.Name,sirenum__End_Date__c,sirenum__Contact__r.Name, sirenum__Job_Role__r.Name,IP_PurchaseOrderNumber__c from sirenum__Placement__c where id in (Select sirenum__Placement__c from sirenum__Shift__c where sirenum__Published__c = true and sirenum__Cancelled__c = false and IP_ClientRejected__c = false and sirenum__Scheduled_Start_Time__c >=: stdatelist and  sirenum__Scheduled_Start_Time__c <=:Endatelist) AND sirenum__End_Date__c >=:stdatelist AND sirenum__Site__c =: siteId';
            
            
            if(CandId != null && CandId != '' ){
                queryData = queryData + ' AND sirenum__Contact__c =: CandId';
            }
            if(jobroleId != null && jobroleId != '' ){
                queryData = queryData + ' AND sirenum__Job_Role__c =: jobroleId';
            }
            place = Database.query(queryData);
           
            if(place.size()>0){
                system.debug('@@ '+place);
                for(sirenum__Placement__c pl : place){
                     Boolean TimesheetCheck = false;
               String PayrollWeek = pl.sirenum__Contract__r.sirenum__PayrollCycle__r.Name;
            List<Date> startEndList = new List<Date>();
            Date shiftstart ;
            Date shiftend ;
            if(PayrollWeek == 'Monday to Sunday'){
                startEndList = StartDateMonday(PayrollWeek);
                shiftstart= startEndList[0];
                shiftend= startEndList[1].addDays(1);
            }
            else if(PayrollWeek == 'Saturday to Friday'){
                 startEndList = StartDateSaturday(PayrollWeek);
                shiftstart= startEndList[0];
                shiftend= startEndList[1].addDays(1);
            }
            else if(PayrollWeek == 'Sunday to Saturday'){
                 startEndList = StartDateSunday(PayrollWeek);
                shiftstart= startEndList[0];
                shiftend= startEndList[1].addDays(1);
            }
                    
                    
                     Decimal forcastvalue = 0;
                List<sirenum__Shift__c> opptys = new List<sirenum__Shift__c>();
                opptys = pl.getSObjects('sirenum__Shifts__r');
                for(sirenum__Shift__c opt:opptys)
                {
                    if(opt.sirenum__Scheduled_Start_Time__c >= shiftstart && opt.sirenum__Scheduled_Start_Time__c <= shiftend){
                     if(opt.sirenum__Timesheet_summaries__c == null){
                            if(opt.sirenum__Forecast_Charge__c != null){
                            forcastvalue = forcastvalue+opt.sirenum__Forecast_Charge__c;}
                            else if(opt.sirenum__Total_Charge__c != null){
                                forcastvalue  = forcastvalue+opt.sirenum__Total_Charge__c;}
                     }
                      else{ TimesheetCheck  = true;}
                    }
                    
                }
                    if(pl.TotalForecastValue__c != String.ValueOf(forcastvalue)){
                        pl.TotalForecastValue__c = String.ValueOf(forcastvalue);
             updateplace.add(pl); 
                       
                        }
                                if(TimesheetCheck == true && pl.TimesheetCheck__c == false){
                                    
                            pl.TimesheetCheck__c = TimesheetCheck;                                      if(updateplace.size()==0){                                      updateplace.add(pl);    
                                     }
                                }
            }
                if(updateplace.size()>0){
                    try{ update updateplace;}
                    catch(Exception DMLException){
                        String abc1;
                        String abc2;
                        String abc3;
                        String abc4;
                    }
                
                }
                
                return place;
            } 
            else{
                 return place;
            }
        }else{
            return null;
        }
        
        
    }
}