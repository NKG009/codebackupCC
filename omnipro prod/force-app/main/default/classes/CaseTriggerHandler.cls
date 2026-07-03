public class CaseTriggerHandler {

     public static void updateTrackedTimeForOpportunities(List<Case> caseList) {

        Map<Id, Decimal> oppTotalTimeMap = new Map<Id, Decimal>();

       
        for (Case c : caseList) {
            if (c.OpportunityName__c != null) {
                oppTotalTimeMap.put(c.OpportunityName__c, 0);
            }
        }

       
        List<AggregateResult> caseTimeResults = [
            SELECT OpportunityName__c, SUM(OrcaCaseTimer__Total_Time_Spent_No__c) totalTime 
            FROM Case
            WHERE OpportunityName__c IN :oppTotalTimeMap.keySet()
            GROUP BY OpportunityName__c
        ];

        
        for (AggregateResult result : caseTimeResults) {
            Id opportunityId = (Id) result.get('OpportunityName__c');
            Decimal totalTime = (Decimal) result.get('totalTime');
            oppTotalTimeMap.put(opportunityId, totalTime);
        }

        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();

       
        for (Id oppId : oppTotalTimeMap.keySet()) {
            Opportunity opp = new Opportunity();
            opp.Id = oppId;

            
            opp.Tracked_Time__c = oppTotalTimeMap.get(oppId) * 1440;

            opportunitiesToUpdate.add(opp);
        }

        
        if (!opportunitiesToUpdate.isEmpty()) {
            update opportunitiesToUpdate;
        }
    }

}