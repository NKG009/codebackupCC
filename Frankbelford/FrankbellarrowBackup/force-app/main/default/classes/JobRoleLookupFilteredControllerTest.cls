@IsTest
public with sharing class JobRoleLookupFilteredControllerTest {
  @IsTest
  public static void Search() {
    Id recordTypeId = [
      SELECT Id
      FROM RecordType
      WHERE SobjectType = 'Account' AND Name = 'Client'
      LIMIT 1
    ]
    .Id;
    Account account = new Account(Name = 'Test1', RecordTypeId = recordTypeId);
    insert account;

    List<Id> fixedSearchResults = new List<Id>{ account.Id };
    Test.setFixedSearchResults(fixedSearchResults);

    List<SObject> output = portalV2JobRoleLookupFilteredController.search(
      'Account',
      new List<String>{ 'Name' },
      'Test1',
      'RecordTypeId=\'' +
      recordTypeId +
      '\''
    );

    System.assertNotEquals(0, output.size());
  }
}