@isTest
public class UserSelector_Test {
    @isTest
    static void UserSelector() {
        Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User userRecord = new User(
            Title = 'Mr.',
            Username = 'tiwary91134111@gmail.com',
            LastName = 'System',
            Email = 'abc@gmail.com',
            Alias = 'autocase',
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_CA',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = testProfile.Id
        );
        
        Test.startTest();
        insert userRecord;
        
        User userRec = UserSelector.getSingleUserThatIsNotMe(userRecord.Id);
         System.assertEquals('en_US', userRec.LanguageLocaleKey);
        Test.stopTest();
    }
    
}