@isTest

public class Test_ltdcompanyB2FUpdate{
 @testSetup static void dataSetUp(){   
    Account client1 = TestDataFactory.createClients(1)[0];
    insert client1;
    
    Account candacc = TestDataFactory.createCandidateAccount(1)[0];
    insert candacc;
    
    Account acccon = TestDataFactory.createAccounts(1)[0];
    insert acccon;
    
    insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

    Contact candidateid = TestDataFactory.createCandidate(candacc.id,1)[0];
    insert candidateid;
    
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
    RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
    Contact con = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acccon.id);
   insert con;
    id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('LTD').getRecordTypeId();

        IP_PayProfile__c payprofile = new IP_PayProfile__c();
        payprofile.RecordTypeId = payRTId;
        payprofile.IP_Candidate__c = candidateid.id;
        payprofile.IP_CompanyName__c='sfdc';
        payprofile.IP_Status__c = 'Active'; 
        payprofile.IP_CompanyRegNo__c  = 'ad123456';
        payprofile.IP_VATNumber__c     = '123456789';
        payprofile.IP_PayrollID__c  = 'testpay1';
        payprofile.IP_VATRegistered__c=true;
        payprofile.IP_OkToSupply__c=1;
        payprofile.IP_BuildingSocietyNumber__c='23123';
        payprofile.IP_BusinessAddressLine1__c='test address 1';
        payprofile.IP_BusinessAddressLine2__c='test address 2';
        payprofile.IP_BusinessAddressTown__c='town city';
        payprofile.IP_BusinessAddressPostcode__c='12345678';
        payprofile.IP_PayFrequency__c='Weekly';
        payprofile.IP_PaymentType__c='BACS';
        payprofile.IP_BankAccountName__c = 'testname';
        payprofile.IP_AccountNumber__c = '98958987';
        payprofile.IP_SortCode__c = '887788';
        //payprofile.IP_PassToTempest__c=true;
        insert payprofile;
        
        Batch_header__c batchheader = new Batch_header__c();
    batchheader.IP_Status__c = 'Approved';
    batchheader.IP_State__c ='Closed';
    batchheader.IP_BatchType__c ='Ltd Co Pay Profile';
    insert batchheader;


        IP_BatchLine__c batchline2 = new IP_BatchLine__c();
        batchline2.IP_BatchHeader__c = batchheader.id;
        batchline2.IP_Status__c = 'open';
        batchline2.IP_State__c  = 'open';
        batchline2.IP_TextField2__c= 'Company name 1';
        batchline2.IP_TextField3__c= '12345678';
        batchline2.IP_Number12d4Field1__c = 1;
        insert batchline2; // legacycon
  } 
   
   @istest static void BatchHeaderclassmethod1(){
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_Status__c,IP_TextField1__c,IP_TextField2__c,IP_TextField3__c,IP_Number12d4Field1__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        Test.startTest();
        Database.executeBatch(new LTDpayprofileB2FUpdate(),1);
        Test.stopTest();    
    }
    
    @istest static void BatchHeaderclassmethod2(){
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_Status__c,IP_TextField3__c,IP_TextField4__c,IP_TextField1__c,IP_DateField1__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField1__c= 'testpay1';
        listBatchLine[0].IP_TextField10__c = 'Name1';
        listBatchLine[0].IP_TextField11__c =  '12345678';
        listBatchLine[0].IP_TextField12__c = '111222';
        listBatchLine[0].IP_TextField13__c = 'ba1';
        update listBatchLine;
        Test.startTest();
        Database.executeBatch(new LTDpayprofileB2FUpdate(),1);
        Test.stopTest();    
    }
    @istest static void BatchHeaderclassmethod3(){
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_Status__c,IP_TextField3__c,IP_TextField4__c,IP_TextField1__c,IP_DateField1__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField1__c= 'test4263527';
        update listBatchLine;
        Test.startTest();
        Database.executeBatch(new LTDpayprofileB2FUpdate(),1);
        Test.stopTest();    
    }
     @istest static void testltdschedule(){
        
                List<IP_BatchLine__c> listBatchLine = [Select id,IP_Status__c,IP_TextField2__c,IP_TextField3__c,IP_TextField6__c,IP_TextField1__c,IP_TextField7__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        Test.StartTest();
        ScheduleLTDB2Fbatch sh1 = new ScheduleLTDB2Fbatch();
        String sch = '0 30 * * * ?';
        system.schedule('Test ltd', sch, sh1);
        Test.stopTest();
    }
    
    }