@istest
public class UpdatePayProfile_test{

    public static testmethod void payprofile()
    {
           insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
         Account acc =  TestDataFactory.createCandidateAccount(1)[0];
          insert acc;
         Contact con = TestDataFactory.createCandidate(acc.id,1)[0];
          insert con;
         IP_Umbrellalist__c ul = new IP_Umbrellalist__c ();
         ul.Name = 'ABC';
         ul.IP_AddressLine1__c = 'Line 1';
         ul.IP_AddressLine2__c = 'Line 2';
         ul.IP_AddressLine3__c = 'Line 3';
         ul.IP_BankAccountName__c   = 'Bank 1';
         ul.IP_BankAccountNumber__c = '12345678';
         ul.IP_BankSortCode__c = '123456';
         ul.IP_BuildingSocietyNo__c ='12344';
         ul.IP_CompanyRegNo__c = '12345678';
         ul.IP_OkToSupply__c = 1;
         ul.IP_PaymentType__c = 'B';
         ul.IP_Postcode__c = 'ABCD';
         ul.IP_SupplierReference__c = 'XYZ';
         ul.VAT_Number__c='123324578';
         ul.IP_VATRegistered__c =1;
         
         insert ul;
         IP_Umbrellalist__c ul1 = new IP_Umbrellalist__c ();
         ul1.Name = 'ABC';
         ul1.IP_AddressLine1__c = 'Line 1';
         ul1.IP_AddressLine2__c = 'Line 2';
         ul1.IP_AddressLine3__c = 'Line 3';
         ul1.IP_BankAccountName__c   = 'Bank 1';
         ul1.IP_BankAccountNumber__c = '12345678';
         ul1.IP_BankSortCode__c = '123456';
         ul1.IP_BuildingSocietyNo__c ='12344';
         ul1.IP_CompanyRegNo__c = '12345678';
         ul1.IP_OkToSupply__c = 1;
         ul1.IP_PaymentType__c = 'B';
         ul1.IP_Postcode__c = 'ABCD';
         ul1.IP_SupplierReference__c = 'XYZ';
         ul1.VAT_Number__c='';
         ul1.IP_VATRegistered__c =0;         
         insert ul1;
            insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c= false);
         IP_PayProfile__c pf = new IP_PayProfile__c();
         RecordType condRec = [Select Id  From RecordType Where sObjectType = 'IP_PayProfile__c' And DeveloperName='Umbrella'];
         pf.IP_Candidate__c = con.id;
         pf.IP_UmbrellaName__c = ul.id;
         pf.RecordTypeid = condRec.id;
        IP_PayProfile__c pf1 = new IP_PayProfile__c();
         RecordType condRec1 = [Select Id  From RecordType Where sObjectType = 'IP_PayProfile__c' And DeveloperName='Umbrella'];
         pf1.IP_Candidate__c = con.id;
         pf1.IP_UmbrellaName__c = ul1.id;
         pf1.RecordTypeid = condRec1.id;
           test.startTest();
         insert pf;
       
        
         insert pf1;
        
         pf.IP_UmbrellaName__c = ul1.id;
        update pf;
          test.stopTest();
        }
    
 }