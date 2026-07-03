/*
* Class Name: TestUploadBatchheadetfromcomp
*/
@isTest
private class TestUploadBatchheadetfromcomp {
    @TestSetup
    static void prepareTest(){
        TestDataFactory.setupUserProfileCustomSettings();
        Account candidateAccount = TestDataFactory.createCandidateAccount(1)[0];
        Account client = TestDataFactory.createClients(1)[0];
        insert new List<Account>{candidateAccount, client};
        TestDataFactory.setupCustomSettings(candidateAccount.Id);
        insert new Batch_header__c(  IP_BatchType__c = 'Generic'
                ,IP_Status__c = 'Approved'
                ,IP_State__c = 'Closed'
                ,IP_Account__c = client.Name
                ,IP_AccountID__c = client.Id
                ,Uploaded_File_Name__c = 'TestFile'+(Math.random()*1000).intValue()+'.csv');
    }

    @isTest
    static void checkDuplicateFileLoadTest(){
        Batch_header__c batchHeader = [SELECT Id, Name, Uploaded_File_Name__c
        FROM Batch_header__c
        WHERE Uploaded_File_Name__c LIKE 'TestFile%.csv'
        LIMIT 1];
        Test.startTest();
        Integer fileCountIs1 = UploadBatchheadetfromcomp.checkDuplicateFileLoad(batchHeader.Uploaded_File_Name__c);
        Integer fileCountIs0 = UploadBatchheadetfromcomp.checkDuplicateFileLoad('THIS FILE NAME DOES NOT EXISTS.CSV');
        Test.stopTest();
        System.assert(fileCountIs1 == 1, 'Matching File count is expected to be 1');
        System.assert(fileCountIs0 == 0, 'Matching File count is expected to be 0');
    }

    static testMethod void UploadBatchheadetfromcompMethod(){

        //List<User> inquirySiteUser = [Select id from User where Profile.Name='Inquiry Profile'];

        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account'];
        Account account =[SELECT Id, Name FROM Account WHERE RecordType.Name = 'Candidate']; //TestDataFactory.createCandidateAccount(1)[0];
        //insert account;

        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc1;

        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

        Contact cont = TestDataFactory.createCandidate(account.id, 1)[0];
        insert cont;

        sirenum__Site__c site = new sirenum__Site__c();
        site.Name = 'testsite';
        site.sirenum__Operating_Company__c= acc1.id;
        site.IP_ClientIDLegacy__c='123';
        site.IP_ClientInvoiceName__c = 'test abc';
        site.IP_PublicSector__c = 'No';
        site.IP_InvoiceContactText__c = 'Contact 1';
        insert site;

        Batch_header__c batchHeader = [SELECT Id, Name, Uploaded_File_Name__c
        FROM Batch_header__c
        WHERE Uploaded_File_Name__c LIKE 'TestFile%.csv'
        LIMIT 1];

        Test.startTest();
        String jsonSiteString ='{"Candidate_ID":"P999999","Candidate_Name":"Steve Test","Hours":"8","Pay_Rate":"3","Charge_Rate":"6","Rate_Code":"Flex Pay /FL","Shift_Date":"14/02/2020","Weekending":"14/02/2020","PO_Number":"12345678","Job_Role":"Dreamland jobrole","Client_Ref":"BG0029216","External_Assignment_ID":"111111"}';
        String jsonAccountString = '{"Id":"'+acc1.Id+'","Name":"'+acc1.Name+'"}';
        UploadBatchheadetfromcomp.getsitesList(jsonSiteString);
        UploadBatchheadetfromcomp.insertData(jsonSiteString,jsonAccountString,'', 'Test-new-file.csv');
        try{
            UploadBatchheadetfromcomp.insertData(jsonSiteString,jsonAccountString,'', batchHeader.Uploaded_File_Name__c);
            System.assert(false, 'Error message expected');
        } catch(Exception ex){
            System.assert(String.isNotBlank(ex.getMessage()));
        }
        try{
            UploadBatchheadetfromcomp.insertData(jsonSiteString,jsonAccountString,'', null);
            System.assert(false, 'Error message expected');
        } catch(Exception ex){
            System.assert(String.isNotBlank(ex.getMessage()));
        }
        Test.stopTest();
    }

    /*static testMethod void UploadBatchheadetfromcompMethod() {
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
        Account account = TestDataFactory.createCandidateAccount(1)[0]; 
        insert account;
        TestDataFactory.setupCustomSettings(account.Id);
        TestDataFactory.setupUserProfileCustomSettings();
        
        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc1;
        
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        
        Contact cont = TestDataFactory.createCandidate(account.id, 1)[0];
        insert cont;
        
        sirenum__Site__c site = new sirenum__Site__c();         
        site.Name = 'testsite';
        site.sirenum__Operating_Company__c= acc1.id;
        site.IP_ClientIDLegacy__c='123';
        site.IP_ClientInvoiceName__c = 'test abc';
        site.IP_PublicSector__c = 'No';
        site.IP_InvoiceContactText__c = 'Contact 1';
        insert site;
        
        Test.startTest();
            String jsonSiteString ='{"Candidate_ID":"P999999","Candidate_Name":"Steve Test","Hours":"8","Pay_Rate":"3","Charge_Rate":"6","Rate_Code":"Flex Pay /FL","Shift_Date":"14/02/2020","Weekending":"14/02/2020","PO_Number":"12345678","Job_Role":"Dreamland jobrole","Client_Ref":"BG0029216","External_Assignment_ID":"111111"}';
            String jsonAccountString = '{"Id":"'+acc1.Id+'","Name":"'+acc1.Name+'"}';
            UploadBatchheadetfromcomp.getsitesList(jsonSiteString);
            UploadBatchheadetfromcomp.insertData(jsonSiteString,jsonAccountString,'');
        Test.stopTest();  
    }*/
}