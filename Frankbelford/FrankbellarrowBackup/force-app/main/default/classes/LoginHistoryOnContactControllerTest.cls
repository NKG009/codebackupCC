@IsTest
public class LoginHistoryOnContactControllerTest {
  @IsTest
  public static void testMethod1() {
    Account portalAccount1 = new Account(Name = 'TestAccount');
    Database.insert(portalAccount1);

    insert new Payroll_Swtich__c(Name = 'Stoppayroll', Batch_check__c = false);
    insert new User_Profile_Id__c(
      Name = 'User Portal',
      Profile_Id__c = [SELECT Id FROM Profile WHERE Name = 'User Portal']
      .Id
    );
    contact contact1 = new Contact(
      FirstName = 'Test1',
      Lastname = 'McTesty',
      AccountId = portalAccount1.Id,
      Email = System.now().millisecond() + 'test@test.com'
    );
    Database.insert(contact1);

    Profile portalProfile = [
      SELECT Id
      FROM Profile
      WHERE Name LIKE '%Customer Community User%'
      LIMIT 1
    ];
    User user1 = new User(
      Username = System.now().millisecond() + 'test12345@test.com',
      ContactId = contact1.Id,
      ProfileId = portalProfile.Id,
      Alias = 'test123',
      Email = 'amit.kohli@espire.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'McTesty',
      CommunityNickname = 'test12345',
      TimeZoneSidKey = 'America/Los_Angeles',
      LocaleSidKey = 'en_US',
      LanguageLocaleKey = 'en_US'
    );
    Database.insert(user1);

    Id idVariable = contact1.Id;

    /*Test.setCurrentPageReference(new PageReference('Page.LoginHistoryOnContact'));
     System.currentPageReference().getParameters().put('id', idVariable);*/
    PageReference pageRef = Page.LoginHistoryOnContact;
    test.setCurrentPageReference(pageRef);
    pageRef.getParameters().put('id', idVariable);
    LoginHistoryOnContactController lhc = new LoginHistoryOnContactController(
      new ApexPages.StandardController(contact1)
    );
    lhc.Nextbtn();
    lhc.previousbtn();
  }
}