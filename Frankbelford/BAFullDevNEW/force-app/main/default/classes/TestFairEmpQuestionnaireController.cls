/*
* Class Name: TestFairEmpQuestionnaireController
* Description: Test Class for FairEmploymentQuestionnaireController
* Date : 3/Dec/2019
*/
@isTest

public class TestFairEmpQuestionnaireController {
    
    /*
    * Method Name: setup
    * Description: Test Data
    * Parameters : none
    * Return Type: nothing
    */
    @testSetup static void setup() {
        
        insert new IP_Shift_Template__c(name = '1062', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='1234',Branch_Address__c='street1',Email__c='singh.taji26@gmail.com',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');

        Account client = TestDataFactory.createClients(1)[0]; 
        Insert client;

        Account account = TestDataFactory.createAccounts(1)[0];
        Insert account;

        Account accountcan = TestDataFactory.createCandidateAccount(1)[0];
        Insert accountcan;
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        Contact cont = TestDataFactory.createContact(client.id, 1)[0];

        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=true);

        Insert cont;

        Recordtype rt1= [Select id from Recordtype where sobjecttype='contact' and Name='Contact'];
        contact con1 = new contact();
        // con.IP_GDPRContactedCandidate__c=FALSE;
        //con.CreatedDate=dt1;
        //con.IP_MarkedForDeletion__c=NULL;
        //  con.IP_Consent_from_Data_Store__c=NULL;
        con1.RecordTypeId=rt1.id;
        con1.AccountId=account.id;
        con1.FirstName='Vandita Test';
        con1.LastName='Kakkar Test';
        insert con1;

        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=true);

        //candidate.t2placement_PassToTempest__c=null;
        Insert candidate;
    }
    
    /*
    * Method Name: contactPositive
    * Description: Test Method for FairEmploymentQuestionnaireController Class
    * Parameters : none
    * Return Type: nothing
    */
    private static testmethod void contactPositive(){
        List<Contact> con = [Select id from Contact limit 1];
        test.startTest();
        FairEmploymentQuestionnaireController obj = new FairEmploymentQuestionnaireController();
        obj.record_Id = con[0].id;
        obj.getconid();
        test.stopTest();
    }

}