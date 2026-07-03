@isTest
public class Drivingletter_Test {
public static testmethod void pdfgeneratedriving(){
Account acc =  TestDataFactory.createCandidateAccount(1)[0];
insert acc;
Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
insert con;
insert new IP_Shift_Template__c(name = '1069', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='1234',Branch_Address__c='street1',Email__c='test@abc.com',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');
test.startTest();

      PageReference pageRef = Page.DrivingBreachLetter;
        pageRef.getParameters().put('id', con.id);
        Test.setCurrentPage(pageRef);
    ApexPages.StandardController sc = new ApexPages.StandardController(con);               
Drivingletter test1 = new Drivingletter(sc); 
    test.stopTest();
}
}