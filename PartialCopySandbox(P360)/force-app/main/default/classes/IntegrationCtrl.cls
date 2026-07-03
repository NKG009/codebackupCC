public without sharing class IntegrationCtrl {

    @AuraEnabled
    public static void sendEmail(String buttonLabel) {
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new List<String>{'a.t.186807785.u-2806745.9f59433c-51c5-47ce-8ec5-97f5973e6254@tasks.clickup.com'});
        mail.setSubject(UserInfo.getName() + ' <tag ' + buttonLabel + '> <assign Tim Smalldon>');
        mail.PlainTextBody = buttonLabel;
        mailList.add(mail);
        if(!Test.isRunningTest()) Messaging.sendEmail(mailList);
    }	
}