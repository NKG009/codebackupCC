public with sharing class GenericDataService {
    public static SObject getGenericDataFromRecordId(String objectApiName, Set<String> fieldApiNames, String filterRecordId) {
        String query = 'SELECT Id, ' + 
            String.join(new List<String>(fieldApiNames), ApexConstants.COMMA) + ' FROM ' + String.escapeSingleQuotes(objectApiName) + 
            ' WHERE Id = :filterRecordId';
        
        return Database.query(query);
    }
}