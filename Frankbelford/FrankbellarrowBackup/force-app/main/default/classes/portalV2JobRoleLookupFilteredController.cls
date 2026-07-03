public with sharing class portalV2JobRoleLookupFilteredController {
  @AuraEnabled
  public static List<sObject> search(
    String objectName,
    List<String> fields,
    String searchTerm,
    String filterTerm
  ) {
    String searchKeyword = searchTerm + '*';
    String returningQuery = '';
    returningQuery =
      objectName +
      ' ( Id, ' +
      String.join(fields, ',') +
      ' WHERE ' +
      filterTerm +
      ')';
    String query =
      'FIND :searchKeyword IN ALL FIELDS RETURNING ' +
      returningQuery +
      ' LIMIT 20';
    System.debug(' query ' + query);
    List<List<sObject>> searchRecords = Search.Query(Query);
    return searchRecords.get(0);
  }
}