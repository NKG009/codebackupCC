public class My_Blue_Arrow_Contact_cnt{
    
     @AuraEnabled
     public static Map<string,Object> getUsernfo(String site)
     {
      
      sirenum__Site__c siteObj = [select Id,Owner.Name, IP_TempestDepartment__c,IP_MainContact__c from sirenum__Site__c where Id=:site];
      
       Map<string,Object> UserMap = new Map<string,Object>();
       
      if(siteObj!=null )
      {
      
      	 UserMap.put('site',siteObj);
         Contact con = [select id,Name,IP_TempestDepartment__c from Contact where Id=:siteObj.IP_MainContact__c];
      
                 UserMap.put('User',con);
                 
                 if(siteObj.IP_TempestDepartment__c!=null)
                 {
                   IP_Shift_Template__c shiftemp = IP_Shift_Template__c.getValues(siteObj.IP_TempestDepartment__c);
                   UserMap.put('ShifTemp',shiftemp);
                 }
                 else
                 {
                   UserMap.put('ShifTemp',null);
                 }
              }   
                 return UserMap;
     }
 
}