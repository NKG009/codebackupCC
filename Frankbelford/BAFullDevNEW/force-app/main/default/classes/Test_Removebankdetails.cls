@isTest 
public class Test_Removebankdetails {

@istest 
    static void test1() {
      
     Account acc = TestDataFactory.createCandidateAccount(1)[0];
        insert acc;
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

                        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
                        
                            
        id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('PAYE').getRecordTypeId();

         IP_PayProfile__c payprofile1 = new IP_PayProfile__c();
         payprofile1.RecordTypeId = payRTId;         
       payprofile1.IP_Candidate__c = con.id;
         payprofile1.IP_CompanyName__c='sfdc';
         payprofile1.IP_Status__c = 'Inactive'; 
         payprofile1.IP_CompanyRegNo__c  = 'ad123456';
         payprofile1.IP_VATNumber__c     = '123456789';
         payprofile1.IP_PayrollID__c  = 't12786c3';
         payprofile1.IP_VATRegistered__c=true;
         payprofile1.IP_OkToSupply__c=1;
         payprofile1.IP_BusinessAddressLine1__c='test address 1';
         payprofile1.IP_BusinessAddressLine2__c='test address 2';
         payprofile1.IP_BusinessAddressTown__c='town city';
         payprofile1.IP_BusinessAddressPostcode__c='12345678';
         payprofile1.IP_PayFrequency__c='Weekly';
         payprofile1.IP_BankAccountName__c = 'tes123';
         payprofile1.IP_AccountNumber__c = '12344321';
         payprofile1.IP_SortCode__c = '123321';
         payprofile1.IP_PaymentType__c='BACS';
         payprofile1.P45_Date_by_Head_Office__c =  System.today().addMonths(-4);
      //  payprofile1
         insert payprofile1;
         
         
          id certId = Schema.SObjectType.Certification__c.getRecordTypeInfosByName().get('Bank Details Form (PAYE)').getRecordTypeId();
        Certification__c cert = new Certification__c();
        cert.Contact__c = con.id;
        cert.RecordTypeId = certId;
        cert.Account_Name__c = 'test123';
        cert.Account_Number__c = '12344321';
        cert.Sort_Code__c = '123321';
        insert cert;
         
         Test.startTest();
         
         Removebankdetails rs = new Removebankdetails();
         database.executebatch(rs,1);
         
         Test.stopTest();
         
         
         
  }
  


}