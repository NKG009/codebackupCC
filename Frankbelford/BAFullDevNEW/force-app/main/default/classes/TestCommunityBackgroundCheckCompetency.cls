/*
* Class Name: TestCommunityBackgroundCheckCompetency
* Description: Test Class for CreateCommunityBackgroundCheckCompetency
* Date : 3/Dec/2019
*/
@isTest
public class TestCommunityBackgroundCheckCompetency {
    
    private static final string COMMUNITY_BACKGROUND_CHECK = 'Community Background Check';
    
    /*
    * Method Name: setup
    * Description: Test Data
    * Parameters : none
    * Return Type: nothing
    */
    @testSetup static void setup() {
        
        sirenum__TicketType__c CompetenceType =new sirenum__TicketType__c();
        CompetenceType.Name = 'Community Background Check';
        insert CompetenceType;
        
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
        Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
        insert acc1;
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);

        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
        
        Contact con = new Contact(AccountID = acc1.Id, 
            RecordTypeId=condRec.id,
            FirstName ='Manish',
            Salutation ='Mr',
            MailingCity='ggn',
            MailingCountry='india',
            MailingPostalCode='110092',
            MailingState='Haryana',
            LastName ='candidate',  
            sirenum__National_Insurance__c='AA323232A', 
            IP_CandidateIDlegacy__c='dsdsdsdd', 
            MailingStreet='abc',
            P45_Requested__c=true,
            PayrollLeaver__c=null,
            Title = 'TestLastName',
            Initials__c = 'TestLastName',
            Birthdate = Date.valueOf('1990-02-20'),
            Phone = '9879879877',
            IP_WorkerStartDate__c=Date.valueOf('2017-02-20'),
            EEO_Gender__c = 'M',
            IP_CategoryOfWork__c='Catering;Industrial',
            IP_ThirdPartyID__c='testpay12',
            IP_IsInvoicecontact__c=true
        );
        
        insert con;
    }
    
    /*
    * Method Name: testMethodPositive
    * Description: Test Method for CreateCommunityBackgroundCheckCompetency Class
    * Parameters : none
    * Return Type: nothing
    */
    private static testmethod void testMethodPositive(){
        List<Contact> con = [Select id from Contact limit 1];
        List<String> listCandidateId = new List<String>();
        listCandidateId.add(con[0].id);
        test.startTest();
        CreateCommunityBackgroundCheckCompetency obj = new CreateCommunityBackgroundCheckCompetency();
        CreateCommunityBackgroundCheckCompetency.sendEmail(listCandidateId);
        test.stopTest();
    }
    
    /*
    * Method Name: testMethodPositive1
    * Description: Test Method for CreateCommunityBackgroundCheckCompetency Class
    * Parameters : none
    * Return Type: nothing
    */
    private static testmethod void testMethodPositive1(){
        List<Contact> con = [Select id from Contact limit 1];
        List<sirenum__TicketType__c> communitBackGroundCompetency = [Select id from sirenum__TicketType__c 
                                                        where Name=:COMMUNITY_BACKGROUND_CHECK limit 1];
        
        sirenum__Ticket__c competency = new sirenum__Ticket__c();
        competency.sirenum__TicketType__c = communitBackGroundCompetency[0].id;                         
        competency.sirenum__Owner__c = con[0].id;
        //competency.sirenum__Valid__c = true;
        competency.sirenum__Valid_from__c = System.today();
        insert competency;                          
        
        List<String> listCandidateId = new List<String>();
        listCandidateId.add(con[0].id);
        test.startTest();
        CreateCommunityBackgroundCheckCompetency obj = new CreateCommunityBackgroundCheckCompetency();
        CreateCommunityBackgroundCheckCompetency.sendEmail(listCandidateId);
        test.stopTest();
    }
}