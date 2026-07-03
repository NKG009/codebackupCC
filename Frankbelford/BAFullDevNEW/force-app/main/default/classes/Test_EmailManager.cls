@isTest
public class Test_EmailManager{
public static testmethod void email1(){

        Account acc = TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
        List<Contact> conlist = new List<Contact>();
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
        con.Email = 'abc@gmail.com';
        con.Salutation ='Mr';
        con.IP_CitizenshipGroup__c='Citizen of the UK';
        con.sirenum__National_Insurance__c='AA123456B';
        con.Birthdate=date.newInstance(1992, 04, 23);
        con.EEO_Gender__c ='M';
        con.PORTW_Completed__c =true;
        con.Medical_Completed__c =true;
        con.Declaration_Completed__c=true;
        con.TOE_Completed__c =true;
        con.New_Starter_Form__c=true;
        con.Equal_Opportunity_Completed__c=true;
        con.MailingCity ='ddd';
        con.MailingCountry='eee';
        con.MailingState='jjjj';
        con.MailingPostalCode='123456';
        con.MailingStreet='rrrrrr';
        insert con;
        conlist.add(con);
        
            test.startTest();
            PageReference pageRef = Page.SendEmailManager;
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardSetController sc = new ApexPages.StandardSetController(conlist);               
            EmailManager emailsend = new EmailManager(sc);
            emailsend.insertResultItemRecords();
            test.stopTest();
        
}

}