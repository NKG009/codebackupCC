/**Test Class - InvokeSitePersonaActionTest*/

public class SiteTriggerHelper {
	
    public static void populateVacancies(Set<Id> siteAccIdSet){
        Map<Id,Decimal> tempVacMap = new Map<Id,Decimal>(), permVacMap = new Map<Id,Decimal>();
        List<Account> accLstToUpdate = new List<Account>();
        Map<Id,sirenum__Site__c> accSiteMap = new Map<Id,sirenum__Site__c>();
        for(sirenum__Site__c eachSite : [SELECT Id,Name,sirenum__Operating_Company__c,Estimated_Temp_Requirements__c,Estimated_Perm_Vacancies__c,
                                         sirenum__Operating_Company__r.Estimated_Temp_Requirements__c,sirenum__Operating_Company__r.Estimated_Perm_Vacancies__c
                                         FROM sirenum__Site__c WHERE sirenum__Operating_Company__c IN :siteAccIdSet AND Status__c != 'Inactive']){
                                             if(accSiteMap.isEmpty() || !accSiteMap.containsKey(eachSite.sirenum__Operating_Company__c)){
                                                 accSiteMap.put(eachSite.sirenum__Operating_Company__c,eachSite);
                                             }
            if(eachSite.Estimated_Temp_Requirements__c != null && (tempVacMap.isEmpty() || !tempVacMap.containsKey(eachSite.sirenum__Operating_Company__c))){
                tempVacMap.put(eachSite.sirenum__Operating_Company__c,eachSite.Estimated_Temp_Requirements__c);
            }else if(eachSite.Estimated_Temp_Requirements__c != null && (!tempVacMap.isEmpty() && tempVacMap.containsKey(eachSite.sirenum__Operating_Company__c))){
                //Decimal tempVacancies = tempVacMap.get(eachSite.sirenum__Operating_Company__c)+eachSite.Estimated_Temp_Requirements__c;
                tempVacMap.put(eachSite.sirenum__Operating_Company__c,tempVacMap.get(eachSite.sirenum__Operating_Company__c)+eachSite.Estimated_Temp_Requirements__c);
            }
            //Calculate Perm Vacancies
            if(eachSite.Estimated_Perm_Vacancies__c != null && (permVacMap.isEmpty() || !permVacMap.containsKey(eachSite.sirenum__Operating_Company__c))){
                permVacMap.put(eachSite.sirenum__Operating_Company__c,(Decimal)eachSite.Estimated_Perm_Vacancies__c);
            }
            else if(eachSite.Estimated_Perm_Vacancies__c != null && (!permVacMap.isEmpty() && permVacMap.containsKey(eachSite.sirenum__Operating_Company__c))){
                //Decimal tempVacancies = tempVacMap.get(eachSite.sirenum__Operating_Company__c)+eachSite.Estimated_Perm_Vacancies__c;
                permVacMap.put(eachSite.sirenum__Operating_Company__c,permVacMap.get(eachSite.sirenum__Operating_Company__c)+eachSite.Estimated_Perm_Vacancies__c);
            }
        }
         System.debug('update in site trigger helper'+JSON.serialize(permVacMap)+'??'+JSON.serialize(tempVacMap));
        for(Id eachSiteAccId : siteAccIdSet){
            System.debug('update in site trigger helper');
        if((!tempVacMap.isEmpty() && tempVacMap.containsKey(eachSiteAccId)) || (!permVacMap.isEmpty() && permVacMap.containsKey(eachSiteAccId))){
            Account acc = new Account(Id = eachSiteAccId, Estimated_Temp_Requirements__c = !tempVacMap.isEmpty() && tempVacMap.containsKey(eachSiteAccId) ? tempVacMap.get(eachSiteAccId) : accSiteMap.get(eachSiteAccId).sirenum__Operating_Company__r.Estimated_Temp_Requirements__c,
                                     Estimated_Perm_Vacancies__c = !permVacMap.isEmpty() && permVacMap.containsKey(eachSiteAccId) ? permVacMap.get(eachSiteAccId) : accSiteMap.get(eachSiteAccId).sirenum__Operating_Company__r.Estimated_Perm_Vacancies__c);
            accLstToUpdate.add(acc);
        }
    }
    
    if(!accLstToUpdate.isEmpty() && accLstToUpdate.size() > 0)
        update accLstToUpdate;
    }
    
    
    
}