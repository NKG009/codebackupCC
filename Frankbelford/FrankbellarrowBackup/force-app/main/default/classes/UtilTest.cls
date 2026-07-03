/**
 * Created by mrahman on 2021-03-15.
 */

@IsTest
private class UtilTest {
    @IsTest
    static void testGetWeekDayStrOrNum() {
        Datetime dt = Datetime.now();
        String strOrNum = '0';
        System.assert(Util.getWeekDayStrOrNum(dt, strOrNum) != null);
    }

    @IsTest
    static void testIsLastWeekendDate(){
        Date d = Datetime.now().date();
        System.assert(Util.isLastWeekendDate(d) != null);
    }

    @IsTest
    static void testNotifyAdminByEmail() {
        String subject = 'Test';
        String body = 'Test body';
        Util.notifyAdminByEmail(subject, body);
    }

    @IsTest
    static void testGetEmailTemplateMapping(){
        String brand='Blue Arrow';
        Email_Template_Mapping__mdt etm = [SELECT Id, Label, DeveloperName, TemplateId__c, Brand__c, Brand__r.Label, Brand_Logo__c
                                            FROM Email_Template_Mapping__mdt
                                            WHERE Brand__r.Label =: brand LIMIT 1];
        String templateName=etm.Label;

        System.assert(Util.getEmailTemplateMapping(brand, templateName) != null);
    }
}