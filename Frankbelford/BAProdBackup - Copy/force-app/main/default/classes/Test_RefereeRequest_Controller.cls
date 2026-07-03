@isTest

public class Test_RefereeRequest_Controller {
    
    static testmethod void method1() {
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
        con1.IP_ContactType__c='Invoice Contact';
        insert con1;
        
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=true);
        
        //candidate.t2placement_PassToTempest__c=null;
        Insert candidate;
        
        
      /*  IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0]; 
        Insert tpz;
        Profile p = [SELECT Id FROM Profile where name='System Administrator'];
        User usr = TestDataFactory.createUsers(p.Id,1)[0];
        usr.username = 'pokygj123@yts.com';
        usr.IP_TempestDepartment__c='2043';
        usr.IP_TempestID__c='1084675';
        usr.IP_TempestDivision__c='NTS';
        insert usr; 
        
        
        ts2__Reference__c ref = new ts2__Reference__c();
        ref.ts2__Candidate__c = cont.id;
ref.ts2__Name__c = 'Name1';
ref.ts2__Email__c = 'abc@123.com';
        
        insert ref;*/
        Test.startTest();
        RefereeRequest_Controller obj = new RefereeRequest_Controller();
        obj.record_Id = candidate.id;
        obj.getconid();
        Test.stopTest();
       
    } 

}