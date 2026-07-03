@isTest
private class LoginControllerTest{
    
    @testSetup 
    static void shiftSetup() {
        
         
        //Create portal account owner
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username ='test2274945@test.com',
            Alias = 'batman',
            Email='bruce.wayne@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        Database.insert(portalAccountOwner1);
     }

     @istest 
    static void testMethodOne() {
        LoginController.checkPortal('test2274945@test.com','Password@123');
        LoginController.checkPortal('','Password@123');
         LoginController.checkPortal('test2274945@test.com','');
        LoginController.resetPasswordMethod('test2274945@test.com');
        LoginController.resetPasswordMethod('');
    }

}