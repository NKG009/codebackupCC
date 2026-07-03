@isTest

public class TaskStatusCompletedTrigger_Test {

    public static void sendMail() {

      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

      String[] toAddresses = new String[] {'shyam.verma@cogeco.com'};

      mail.setToAddresses(toAddresses);
      mail.setSubject('Salesforce CPQ Support');
      mail.setPlainTextBody('Hi Hi Hi');
      Messaging.SendEmailResult[] results = Messaging.sendEmail(
                                new Messaging.SingleEmailMessage[] { mail });

   }
}