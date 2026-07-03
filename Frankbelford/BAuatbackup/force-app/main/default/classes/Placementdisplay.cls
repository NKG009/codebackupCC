public class Placementdisplay{ 

@AuraEnabled 

    public static List<sirenum__placement__c> getplacement(){ 
		Date startdate = System.today()+7;
        Date enddate = System.today()-7;
        Id conId = [Select ContactId from User where id =: UserInfo.getUserId()].ContactId;
        system.debug('conId '+conId);
       List<sirenum__placement__c> placeList = [Select id, name, sirenum__Job_Role__r.Name,DateThisWeek__c,DateNextWeek__c, sirenum__Site__r.Name,sirenum__Start_Date__c,sirenum__End_Date__c From sirenum__placement__c where sirenum__Contact__c =:conId and sirenum__Start_Date__c <: startdate and sirenum__End_Date__c >: enddate]; 
		return placeList;
    } 
    @AuraEnabled
    public static String fetchit(){
         string urler2 = URL.getSalesforceBaseUrl().toExternalForm();
          system.debug('IN FETCH urler2 ' +urler2);

        return (urler2);
    }
    
   

}