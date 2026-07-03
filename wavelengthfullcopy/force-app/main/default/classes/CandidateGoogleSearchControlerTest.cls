@isTest
public class CandidateGoogleSearchControlerTest {

    @isTest
    public static void  CandidateGoogleSearchTest(){
               Account acc = new Account();
        acc.Name = 'PH';
        acc.Industry = 'Real Estate';
        acc.ShippingStreet = 'commercial street';
        acc.Account_Status__c = 'Active';
        acc.AVTRRT__Required__c = false;
        acc.Payroll_Tax_Exempt__c = false;
        acc.ShippingCity  = 'CA';
        acc.CRDNTLS__Credentials_Pack__c = 'STD-Standard;STE-NSW-PH';
        acc.ShippingState = 'CA';
        acc.ShippingPostalCode = '34677';
        acc.AVTRRT__Time_Zone__c = 'Alaska';
        acc.Business_Entity__c = 'Wavelength International';
        acc.AVTRRT__Update_Gross_Values__c = false;
        insert acc;

        Contact con = new Contact(FirstName = 'Approver', LastName = 'Approvingson', Email='test@test.com',
                                       RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Candidate').getRecordTypeId());
        insert con;
        
         ApexPages.StandardController stdController = new ApexPages.StandardController(con);
        
        CandidateGoogleSearchControler controller = new CandidateGoogleSearchControler(stdController);
        
        controller.candidateSearch();
    }
}