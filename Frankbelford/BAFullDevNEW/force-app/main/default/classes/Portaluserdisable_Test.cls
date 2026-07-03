@isTest
public class Portaluserdisable_Test {
  @testSetup
  static void sSetup() {
    Profile portalUserProfile = [
      SELECT Id
      FROM Profile
      WHERE Name = 'User Portal'
    ];
    User_Profile_Id__c UserPortalSetting = new User_Profile_Id__c(
      Name = 'User Portal',
      Profile_Id__c = portalUserProfile.Id
    );
    insert UserPortalSetting;
  }
  @istest
  static void shouldDelete() {
    UserRole portalRole = [
      SELECT Id
      FROM UserRole
      WHERE PortalType = 'None'
      LIMIT 1
    ];
    Profile pProfile = [
      SELECT Id
      FROM Profile
      WHERE name = 'System Administrator'
    ];
    Id profileId = [SELECT Id FROM Profile WHERE Name = 'User Portal'].Id;

    User userP = new User(
      Username = System.now().millisecond() + 'portalUser123@test.com',
      ProfileId = pProfile.Id,
      UserRoleId = portalRole.Id,
      Alias = 'pt123',
      Email = 'abc.xyz@espire.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'l4848',
      CommunityNickname = 'chec',
      Brand__c = 'Blue Arrow',
      IP_TempestDivision__c = 'BA',
      IP_PassToTempest__c = true,
      TimeZoneSidKey = 'GMT',
      LocaleSidKey = 'en_US',
      LanguageLocaleKey = 'en_US'
    );
    insert userP;
    contact con;
    Contact c1;
    sirenum__Timesheet__c sts;
    System.runAs(userP) {
      Account acc1 = new Account(Name = 'TestAccount', OwnerId = userP.Id);
      insert acc1;
      insert new Payroll_Swtich__c(
        Name = 'Stoppayroll',
        Batch_check__c = false
      );

      c1 = new Contact(
        FirstName = 'tt',
        Lastname = 'mm',
        AccountId = acc1.Id,
        Email = System.now().millisecond() + 'as@test.com',
        IP_MarkedForDeletion__c = true,
        IP_GDPRDeleConsentPortalStatus__c = true
      );
      Database.insert(c1);
    }

    Profile dProfile = [
      SELECT Id
      FROM Profile
      WHERE Name LIKE 'User Portal'
      LIMIT 1
    ];
    User userd = new User(
      Username = System.now().millisecond() + 'portalUser123@test.com',
      ProfileId = dProfile.Id,
      Alias = 'klkl',
      Email = 'user1@espire.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'lnamemm',
      ContactId = c1.id,
      CommunityNickname = 'checked',
      TimeZoneSidKey = 'America/Los_Angeles',
      LocaleSidKey = 'en_US',
      LanguageLocaleKey = 'en_US'
    );
    Database.insert(userd);

    Test.StartTest();
    Portaluserdisable portalUserDisable = new Portaluserdisable();
    Database.executeBatch(portalUserDisable, 600);
    // String sch = '0 30 * * * ?';
    // system.schedule('Test portal', sch, sh1);
    Test.stopTest();

    User output = [
      SELECT Id, isPortalEnabled, isActive
      FROM User
      WHERE isPortalEnabled = FALSE
      LIMIT 1
    ];
    System.debug(output);
    System.assertEquals(false, output.isPortalEnabled);
    System.assertEquals(false, output.isActive);
  }
  @istest
  static void testschedule1() {
    List<User> listBatchLine = [SELECT id FROM User LIMIT 1];
    Test.StartTest();
    Schedule_PortalUserDisable sh1 = new Schedule_PortalUserDisable();
    String sch = '0 30 * * * ?';
    system.schedule('Test portal', sch, sh1);
    Test.stopTest();
  }
}