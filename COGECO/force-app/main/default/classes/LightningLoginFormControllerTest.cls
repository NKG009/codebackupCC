@IsTest(SeeAllData = true)
public with sharing class LightningLoginFormControllerTest {
    
@IsTest
 static void testLogin() {
  String login = LightningLoginFormController.login('testUser', 'testuser123', 'http://my.company.salesforce.com');
  System.assertEquals(null, login);
 }

 @IsTest
 static void LightningLoginFormControllerInstantiation() {
  LightningLoginFormController controller = new LightningLoginFormController();
  System.assertNotEquals(controller, null);
 }

 @IsTest
 static void testIsUsernamePasswordEnabled() {
  System.assertEquals(true, LightningLoginFormController.getIsUsernamePasswordEnabled());
 }

 @IsTest
 static void testIsSelfRegistrationEnabled() {
  System.assertEquals(false, LightningLoginFormController.getIsSelfRegistrationEnabled());
 }
    
    
 @IsTest
 static void testGetForgotPasswordUrl() {
  Auth.AuthConfiguration authConfig = LightningLoginFormController.getAuthConfig();
  System.assertEquals(authConfig.getForgotPasswordUrl(), LightningLoginFormController.getForgotPasswordUrl(), 'Verify forget password url');
}

 @IsTest
 static void testGetSelfRegistrationURL() {
  Auth.AuthConfiguration authConfig = LightningLoginFormController.getAuthConfig();
  System.assertEquals(authConfig.getSelfRegistrationUrl(), LightningLoginFormController.getSelfRegistrationUrl(), 'Verify self registration URL');
 }

 @IsTest
 static void testAuthConfig() {
  Auth.AuthConfiguration authConfig = LightningLoginFormController.getAuthConfig();
  System.assertNotEquals(null, authConfig);
 }
    
    @IsTest
    static void testLightningsetExperienceId(){
      Site site = [SELECT Id FROM Site LIMIT 1];  
      String experienceId = LightningLoginFormController.setExperienceId(site.Id);
      System.assertNotEquals(experienceId, null);
      System.assertEquals(null, LightningLoginFormController.setExperienceId(null), 'ExperienceId is null');
    }
}