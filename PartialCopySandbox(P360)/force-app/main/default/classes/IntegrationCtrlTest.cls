@isTest
private class IntegrationCtrlTest {

    @isTest
    static void testSendEmail() {
        IntegrationCtrl.sendEmail('Test');
    }
}