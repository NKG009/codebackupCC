public inherited sharing class OpportunityLineItemSelector {
    public static List<OpportunityLineItem> getOpportunityLineItemsForSyncByQueryString(Set<String> fieldApiNames, Set<Id> filterIds) {
        String query = 'SELECT Id, ' + 
            String.join(new List<String>(fieldApiNames), ApexConstants.COMMA) + ' FROM OpportunityLineItem' + 
            ' WHERE Id IN :filterIds';
        
        return Database.query(query);
    }
}