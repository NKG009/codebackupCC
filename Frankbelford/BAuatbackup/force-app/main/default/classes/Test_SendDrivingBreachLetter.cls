@isTest
public class Test_SendDrivingBreachLetter{
    public static testmethod void lookupcont(){
        
        insert new IP_Shift_Template__c(name = '1181', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='1234',Branch_Address__c='street1',Email__c='singh.taji26@gmail.com',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');
        
        Account acc = TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
        
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        id conRTId1 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Candidate').getRecordTypeId();
        Contact con = new Contact();
        con.Recordtypeid = conRTId1;
        con.FirstName = 'method1';
        con.LastName = 'test1';
        con.Email = 'abc321@gmail.com';
        con.Salutation ='Mrs';
        con.IP_CitizenshipGroup__c='Citizen of the UK';
        con.sirenum__National_Insurance__c='AA123456D';
        con.Birthdate=date.newInstance(1992, 05, 23);
        con.ts2__EEO_Gender__c ='F';
        con.PORTW_Completed__c =true;
        con.Medical_Completed__c =true;
        con.Declaration_Completed__c=true;
        con.TOE_Completed__c =true;
        con.New_Starter_Form__c=true;
        con.Equal_Opportunity_Completed__c=true;
        con.MailingCity ='city1';
        con.MailingCountry='abc1';
        con.MailingState='kjcw';
        con.MailingPostalCode='74393';
        con.MailingStreet='juvr';
        insert con;
        
        test.starttest();
        SendDrivingBreachLetter.getContact(con.id);
        SendDrivingBreachLetter.sendcandidateemail(con.id);
        test.stoptest();
        
    }
}