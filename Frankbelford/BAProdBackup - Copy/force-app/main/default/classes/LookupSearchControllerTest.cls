@IsTest
public with sharing class LookupSearchControllerTest {
   
    @IsTest
    public static void TestSearch()
    {

        Account acct = new Account(Name='Test', Site='Test LTD');
        insert acct;
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = acct.Id;
        Test.setFixedSearchResults(fixedSearchResults);

        Test.startTest();
        System.debug([SELECT Id, Name, Site FROM Account]);
        List<SObject> output = LookupSearchController.search('Account', new List<String>{'Name', 'Site' }, 'Tes');
        Test.stopTest();

        System.assertNotEquals(0, output.size(), output);

    }
}