public class Util {
  public static boolean stopFrostRunAgain = true;
  public static boolean stopQueueableRunAgain = true;

  /**
   * Supply a date to receive either the Weekday name like Monday or Weekday number like 0
   *
   * @param dt
   * @param strOrNum
   *
   * @return
   */
  @AuraEnabled
  public static String getWeekDayStrOrNum(Datetime dt, String strOrNum){
    System.debug('Day from Now: ' + dt.Day());
    System.debug('Week Day from Now: ' + dt.format('EEEE'));
    strOrNum = StrOrNum.toUpperCase();
    if(strOrNum == 'STR' || strOrNum == 'STRING'){
      return dt.format('EEEE');
    } else if(strOrNum == 'NUM' || strOrNum == 'NUMBER' || strOrNum == 'NO'){
      return String.valueOf(dt.day());
    } else {
      return 'Error: unknown request. Expected Str or Num';
    }
  }

  public static Boolean isLastWeekendDate(Date d){
    return true;
  }

  public static Email_Template_Mapping__mdt getEmailTemplateMapping(String brand, String templateName){
    Email_Template_Mapping__mdt etm = [SELECT Id, DeveloperName, TemplateId__c, Brand__c, Brand__r.Label, Brand_Logo__c
                      FROM Email_Template_Mapping__mdt
                      WHERE Brand__r.Label =: brand AND Label =: templateName LIMIT 1];
    return etm;
  }

  public static void notifyAdminByEmail(String subject, String body){
    Messaging.SingleEmailMessage[] sEmails = new Messaging.SingleEmailMessage[0];
    String strAdminEmails = System.Label.AdminEmail;
    if(String.isBlank(strAdminEmails)){
      return ;
    }

    List<String> emailAddress = new List<String>();
    for(String e : strAdminEmails.split(',')){
      emailAddress.add(e.trim());
    }

    Messaging.SingleEmailMessage sEmail = new Messaging.SingleEmailMessage();
    sEmail.setToAddresses(emailAddress);
    sEmail.setSubject(subject);
    sEmail.setPlainTextBody(body);
    sEmails.add(sEmail);
    Messaging.sendEmail(sEmails);
  }
}