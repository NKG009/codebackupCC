/**
*  @Name: RateInfoController>   
*  @Description: <Class to get Rate Information>
*/
public without sharing class RateInfoController{
    
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
   @Auraenabled
    public static List<sirenum__Rate_Card_Page__c> getRateCardList(String jobrolId){
		sirenum__Team__c jobrole = [SELECT sirenum__Rate_Card__c FROM sirenum__Team__c WHERE Id =: jobrolId limit 1];
    	List<sirenum__Rate_Card_Page__c> ratecardpage = [Select id,name,sirenum__Rate_Card__c from sirenum__Rate_Card_Page__c where sirenum__Rate_Card__c =:  jobrole.sirenum__Rate_Card__c];
       
        return ratecardpage;
    }
    @Auraenabled
     public static List<sirenum__Rate_Line__c> getRateLneList2(String ratecardId){
       
		List<sirenum__Rate_Line__c> ratline = [SELECT Id,IP_TextChargeRate__c,IP_TextOTchrg__c,sirenum__Day_Type__c,sirenum__Start_Hour__c,sirenum__End_Hour__c,sirenum__Charge_Rate__c,sirenum__Overtime_Charge_Rate__c,sirenum__Code__c,sirenum__Standard_Rate_Name__c FROM sirenum__Rate_Line__c where sirenum__Rate_Card_Page__c =: ratecardId ];
      
         return ratline;
    }
   @Auraenabled
    public static List<RateiInfoWrapper> getRateLneList(String ratecardId){
         List<RateiInfoWrapper> RateInfoList = new List<RateiInfoWrapper>();
           
       //  RateiInfoWrapper RateInfo2 = new RateiInfoWrapper();
         Map < String, RateiInfoWrapper > ReturnRateMap = new Map < String, RateiInfoWrapper > ();
        set<Id> rateLineId = new set<Id>();
		List<sirenum__Rate_Line__c> ratline = [SELECT Id,IP_TextChargeRate__c,IP_TextOTchrg__c,sirenum__Day_Type__c,sirenum__Start_Hour__c,sirenum__End_Hour__c,sirenum__Charge_Rate__c,sirenum__Overtime_Charge_Rate__c,sirenum__Code__c,sirenum__Standard_Rate_Name__c FROM sirenum__Rate_Line__c where sirenum__Rate_Card_Page__c =: ratecardId ];
        for(sirenum__Rate_Line__c rtline : ratline){
             RateiInfoWrapper RateInfo = new RateiInfoWrapper();
            rateLineId.add(rtline.id);
            RateInfo.StandardRateName = rtline.sirenum__Standard_Rate_Name__c;
            RateInfo.Day = rtline.sirenum__Day_Type__c;
            if(rtline.sirenum__Start_Hour__c == null){
                 RateInfo.StartHour = '00:00';
            }
            else{RateInfo.StartHour = rtline.sirenum__Start_Hour__c;}
            if(rtline.sirenum__End_Hour__c == null){
                RateInfo.EndHour= '00:00';
            }else{RateInfo.EndHour = rtline.sirenum__End_Hour__c;}
            
            RateInfo.Code = rtline.sirenum__Code__c;
          	RateInfo.RateName = 'Pre AWR';
             RateInfo.ChargeRate = rtline.IP_TextChargeRate__c;
             RateInfo.OvertimchargeRate = rtline.IP_TextOTchrg__c;
             system.debug('@@ RateInfo1 '+RateInfo);
        RateInfoList.add(RateInfo);
  for(sirenum__Rate_Modifier__c ratemod : [Select sirenum__Rate_Line__r.id,sirenum__Rate_Modifier_Type__r.name,sirenum__Charge_Rate__c,sirenum__Overtime_Charge_Rate__c from sirenum__Rate_Modifier__c where sirenum__Rate_Line__r.id =: rtline.id and sirenum__Rate_Modifier_Type__r.name !='Holiday']){
             RateiInfoWrapper RateInfo2 = new RateiInfoWrapper();
            RateInfo2.RateName = ratemod.sirenum__Rate_Modifier_Type__r.name;
             RateInfo2.StandardRateName = '';
             RateInfo2.Code = '';
             RateInfo2.Day = '';
             RateInfo2.StartHour = '';
            RateInfo2.EndHour = '';
             RateInfo2.ChargeRate = String.ValueOf(ratemod.sirenum__Charge_Rate__c);
             RateInfo2.OvertimchargeRate = String.ValueOf(ratemod.sirenum__Overtime_Charge_Rate__c);
            system.debug('@@ RateInfo2rt '+RateInfo2.RateName);
             system.debug('@@ RateInfo2ch '+RateInfo2.ChargeRate);
             system.debug('@@ RateInfo2 ot '+RateInfo2.OvertimchargeRate);
       		 RateInfoList.add(RateInfo2);
          //  slist.add(RateInfo2);
           // RateInfo2.rateModifierInfo = slist;
        
        }
           
        }
         List < sirenum__Rate_Modifier__c > slist = new List < sirenum__Rate_Modifier__c > ();
                system.debug('@@1## '+rateLineId);      
         system.debug('@@1 '+RateInfoList);       
      /*  for(sirenum__Rate_Modifier__c ratemod : [Select sirenum__Rate_Line__r.id,sirenum__Rate_Modifier_Type__r.name,sirenum__Charge_Rate__c,sirenum__Overtime_Charge_Rate__c from sirenum__Rate_Modifier__c where sirenum__Rate_Line__r.id =: rateLineId and sirenum__Rate_Modifier_Type__r.name !='Holiday']){
             RateiInfoWrapper RateInfo2 = new RateiInfoWrapper();
            RateInfo2.RateName = ratemod.sirenum__Rate_Modifier_Type__r.name;
             RateInfo2.StandardRateName = '';
             RateInfo2.Code = '';
             RateInfo2.Day = '';
             RateInfo2.StartHour = '';
            RateInfo2.EndHour = '';
             RateInfo2.ChargeRate = String.ValueOf(ratemod.sirenum__Charge_Rate__c);
             RateInfo2.OvertimchargeRate = String.ValueOf(ratemod.sirenum__Overtime_Charge_Rate__c);
            system.debug('@@ RateInfo2rt '+RateInfo2.RateName);
             system.debug('@@ RateInfo2ch '+RateInfo2.ChargeRate);
             system.debug('@@ RateInfo2 ot '+RateInfo2.OvertimchargeRate);
       		 RateInfoList.add(RateInfo2);
          //  slist.add(RateInfo2);
           // RateInfo2.rateModifierInfo = slist;
        
        }*/
		system.debug('@@2 '+RateInfoList);
         return RateInfoList;
    }
        public class RateiInfoWrapper {
        @AuraEnabled public String Day;
        @AuraEnabled public String StartHour;
        @AuraEnabled public String EndHour;
        @AuraEnabled public String ChargeRate;
        @AuraEnabled public String OvertimchargeRate;
        @AuraEnabled public String Code;
        @AuraEnabled public String RateName;
        @AuraEnabled public String StandardRateName;
        @AuraEnabled public List <sirenum__Rate_Modifier__c> rateModifierInfo;
    }
    @Auraenabled
    public static List<sirenum__Team__c> getJobRoleList(){
      //  User u = [select id, contactId,contact.AccountId FROM User WHERE id =: UserInfo.getUserId() limit 1];
     /*   List<sirenum__Shift__c> lstShift = [SELECT Id,sirenum__Team__r.Id,sirenum__Team__c FROM sirenum__Shift__c 
                                            WHERE sirenum__Site__r.Id=:siteId AND sirenum__Scheduled_Start_Time__c >= Today AND 
                                            sirenum__Cancelled__c = False

                                            ORDER BY sirenum__Scheduled_Start_Time__c 
                                            LIMIT 100];
        List<sirenum__Team__c> jobRoleList =  new List<sirenum__Team__c>();
       
        List<sirenum__Site__c> sh = [Select id,sirenum__Operating_Company__c from sirenum__Site__c where id =: siteId limit 1];
        if(sh.size()>0){ 
         jobRoleList = [SELECT id,Name FROM sirenum__Team__c WHERE sirenum__Account__r.sirenum__Client__c =:sh[0].sirenum__Operating_Company__c  ];
        
        }
        return jobRoleList;*/
          String accID = [select id, contact.AccountId from User where id =: UserInfo.getUserId() limit 1][0].contact.AccountId;
        //   String conID = [select id, contactId from User where id =: UserInfo.getUserId() limit 1][0].contactId;
        List < sirenum__Team__c > jobRoleList = [SELECT id, Name FROM sirenum__Team__c where sirenum__Account__r.sirenum__Client__c =: accID];
        System.debug('&&&&&&&&&&&&&&&&&&&' + jobRoleList);
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
   
    /**
*  Description : Method to get the List of competenicies of Candidtae
*  @name : getContactCompetencies
*  @param : String contactId
*  @return : String 
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