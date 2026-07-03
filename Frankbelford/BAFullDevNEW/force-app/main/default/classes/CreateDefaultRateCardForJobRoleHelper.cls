/**
* @author Dean Morris
* @description Helper class for trigger on Job Role to create Rate Card from a default template
*/
public class CreateDefaultRateCardForJobRoleHelper {
    
   /**
    * @description Class constructor to deep clone rate cards from global template for job roles
    * @param jobRoleMap Map of job roles in parallel with defaultRateCardIdMap
    * @param defaultRateCardIdMap Map of default rate card ids in parallel with jobRoles
    * @return None
    */  

    public CreateDefaultRateCardForJobRoleHelper(Map<Integer, sirenum__Team__c> jobRoleMap, 
                                                 Map<Integer, Id>               defaultRateCardIdMap,
                                                 Map<Integer, Id>               jobRoleAccountId){
        
        // Retrieve default rate cards and child objects
        Map<ID, sirenum__Rate_Card__c> defaultRateCards = new Map<ID, sirenum__Rate_Card__c>(
            [SELECT Id,
                    sirenum__Account__c,sirenum__Job_Type__c,sirenum__Sirenum_Contract__c,sirenum__Site__c
             FROM   sirenum__Rate_Card__c
             WHERE  Id IN :defaultRateCardIdMap.values()]);

        List<sirenum__Rate_Card_Page__c> defaultRateCardPages = 
            [SELECT Id, Name, 
                    sirenum__Condition_Field__c, sirenum__Condition_Operator__c, sirenum__Condition_Suggestions__c,
                    sirenum__Condition_value__c, sirenum__Daily_2x_Overtime_Treshold__c, sirenum__Daily_Overtime_Treshold__c,
                    sirenum__Rate_Card__c, sirenum__Rate_Type__c, sirenum__Shift_2x_Overtime_Treshold__c, 
                    sirenum__Shift_Overtime_Treshold__c, sirenum__SortOrder__c, sirenum__Valid_From_Date__c, 
                    sirenum__Valid_Until_Date__c, sirenum__Weekly_2x_Overtime_Treshold__c, sirenum__Weekly_Overtime_Treshold__c
             FROM   sirenum__Rate_Card_Page__c
             WHERE  sirenum__Rate_Card__c IN :defaultRateCards.values()];

        List<sirenum__Rate_Line__c> defaultRateLines = 
            [SELECT Id,
                    sirenum__Allow_Overlap__c, sirenum__ApplyShiftOvertime__c, sirenum__Apply_Daily_Overtime__c, 
                    sirenum__Apply_Weekly_Overtime__c, sirenum__Charge_Rate__c, sirenum__Code__c, sirenum__Day_Type__c,
                    sirenum__End_Hour__c, sirenum__Overtime_2x_Charge_Rate__c, sirenum__Overtime_2x_Pay_Rate__c,
                    sirenum__Overtime_Charge_Rate__c, sirenum__Overtime_Pay_Rate__c, sirenum__Pay_Rate__c, sirenum__Rate_Card_Page__c,
                    sirenum__Rate_Card__c, sirenum__SortOrder__c, sirenum__Standard_Rate_Name__c, sirenum__Standard_Rate_Type__c,
                    sirenum__Start_Hour__c,sirenum__Unit__c
             FROM   sirenum__Rate_Line__c
             WHERE  sirenum__Rate_Card_Page__c IN :defaultRateCardPages];

         List<sirenum__Rate_Modifier__c> defaultRateModifiers =
             [SELECT Id,
                     sirenum__Charge_Rate__c, sirenum__Overtime_2x_Charge_Rate__c, sirenum__Overtime_2x_Pay_Rate__c,
                     sirenum__Overtime_Charge_Rate__c, sirenum__Overtime_Pay_Rate__c, sirenum__Pay_Rate__c,
                     sirenum__Rate_Card_Page__c, sirenum__Rate_Card__c, sirenum__Rate_Line__c, sirenum__Rate_Modifier_Type__c
              FROM   sirenum__Rate_Modifier__c
              WHERE  sirenum__Rate_Line__c IN :defaultRateLines];
        system.debug('Retrieved Modifier Count:' + defaultRateModifiers.size());

        // Map of rate cards used for updating Job Role Rate Card
        Map<Integer, sirenum__Rate_Card__c> rateCardMap = new Map<Integer, sirenum__Rate_Card__c>();
                                                     
        // Cross reference between default rate card id and rate cards
        // Used as an iterator for the inner loop when cloning rate card pages       
        Map<ID, List<sirenum__Rate_Card__c>> defaultIdRateCardMap = new Map<ID, List<sirenum__Rate_Card__c>>(); 

        // Clone Rate Cards
        List<sirenum__Rate_Card__c> rateCards = new List<sirenum__Rate_Card__c>();
        for (Integer i = 0; i < jobRoleMap.size(); i++) {
            Id rateCardMapId = defaultRateCardIdMap.get(i);
            sirenum__Rate_Card__c rateCard = defaultRateCards.get(rateCardMapId).clone(false,true,false,false);
            rateCard.Name = jobRoleMap.get(i).Name;
            rateCard.IP_AcountLinkCustom__c = jobRoleAccountId.get(i);
            rateCards.add(rateCard);
            rateCardMap.put(i, rateCard);
            if (!defaultIdRateCardMap.containsKey(rateCardMapId)) {
                defaultIdRateCardMap.put(rateCardMapId, new List<sirenum__Rate_Card__c>());
            }
            defaultIdRateCardMap.get(rateCardMapId).add(rateCard);
        }
        insert rateCards;

        // Reference rate card from job roles
        for (Integer i = 0; i < jobRoleMap.size(); i++)
        {
            jobRoleMap.get(i).sirenum__Rate_Card__c = rateCardMap.get(i).Id;
        }

        // Cross reference between default rate card page id and rate card pages
        // Used as an iterator for the inner loop when cloning rate lines       
        Map<ID, List<sirenum__Rate_Card_Page__c>> defaultRateCardPagesMap = new Map<ID, List<sirenum__Rate_Card_Page__c>>(); 

        // Clone Rate Card Pages
        List<sirenum__Rate_Card_Page__c> rateCardPages = new List<sirenum__Rate_Card_Page__c>();
        for (sirenum__Rate_Card_Page__c defaultRateCardPage : defaultRateCardPages) {
            List<sirenum__Rate_Card_Page__c> rateCardPageList = new List<sirenum__Rate_Card_Page__c>();
            for (sirenum__Rate_Card__c rateCard : defaultIdRateCardMap.get(defaultRateCardPage.sirenum__Rate_Card__c)) {
                sirenum__Rate_Card_Page__c rateCardPage = defaultRateCardPage.clone(false,true,false,false);
                rateCardPage.sirenum__Rate_Card__c = rateCard.Id;
                rateCardPages.add(rateCardPage);
                rateCardPageList.add(rateCardPage);
            }
            defaultRateCardPagesMap.put(defaultRateCardPage.Id, rateCardPageList);
        }
        insert rateCardPages;
        
        // Cross reference between default rate line id and rate lines
        // Used as an iterator for the inner loop when cloning rate modifiers              
        Map<ID, List<sirenum__Rate_Line__c>> defaultRateLinesMap = new Map<ID, List<sirenum__Rate_Line__c>>(); 

        // Clone Rate Lines
        List<sirenum__Rate_Line__c> rateLines = new List<sirenum__Rate_Line__c>();
        for (sirenum__Rate_Line__c defaultRateLine : defaultRateLines) {            
            List<sirenum__Rate_Line__c> rateLineList = new List<sirenum__Rate_Line__c>();
            for (sirenum__Rate_Card_Page__c rateCardPage : defaultRateCardPagesMap.get(defaultRateLine.sirenum__Rate_Card_Page__c)) {
                sirenum__Rate_Line__c rateLine = defaultRateLine.clone(false,true,false,false);
                rateLine.sirenum__Rate_Card_Page__c = rateCardPage.Id;
                rateLines.add(rateLine);
                rateLineList.add(rateLine);
            }
            defaultRateLinesMap.put(defaultRateLine.Id, rateLineList);
        }
        insert rateLines;

        // Clone Rate Modifiers
        List<sirenum__Rate_Modifier__c> rateModifiers = new List<sirenum__Rate_Modifier__c>();
        for (sirenum__Rate_Modifier__c defaultRatemodifier : defaultRateModifiers) {            
            for (sirenum__Rate_Line__c rateLine : defaultRateLinesMap.get(defaultRateModifier.sirenum__Rate_Line__c)) {
                sirenum__Rate_Modifier__c rateModifier = defaultRateModifier.clone(false,true,false,false);
                rateModifier.sirenum__Rate_Line__c = rateLine.Id;
                rateModifiers.add(rateModifier);
            }
        }
        insert rateModifiers;
    }
}