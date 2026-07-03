/**********************************************************************************************
* @Author:         Espire
* @Date:           02/09/2019
* @Description:    This class is used to view Rate Card Page. 
* @Requirement Id:  JPC-1982
* @Test Class:     
* @Revision(s):    [Date] - [Change Reference] - [Changed By] - [Description]
**********************************************************************************************/
public class RateCardController {
	
	/*
    * Method Name: siteDetailsUpdate
    * Description: To update site record
    * Parameters : String siteId
    * Return Type: String
    * Date : 15/08/2019
    */
	@AuraEnabled
	public Static String ViewRateCard(String JobroleId){
         String ratecardid;
		List<sirenum__Team__c> jobrole = [SELECT name,sirenum__Account__r.sirenum__Client__c,sirenum__Rate_Card__c  from sirenum__Team__c where id =: jobroleId];
        if(jobrole[0].sirenum__Rate_Card__c == NULL ){
            sirenum__Rate_Card__c sratecard = new sirenum__Rate_Card__c();
            sratecard.Name = jobrole[0].name;
            sratecard.IP_AcountLinkCustom__c = jobrole[0].sirenum__Account__r.sirenum__Client__c;
            insert sratecard;
            
            jobrole[0].sirenum__Rate_Card__c = sratecard.Id;
            update jobrole;
            
           ratecardid = sratecard.id;
            return ratecardid;
            
        }
        else{
            ratecardid = jobrole[0].sirenum__Rate_Card__c;
            return ratecardid;
            
        }
	}
}