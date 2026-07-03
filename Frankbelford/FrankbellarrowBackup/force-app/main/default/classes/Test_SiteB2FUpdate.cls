@isTest
public class Test_SiteB2FUpdate{
 @testSetup static void dataSetUp(){ 

        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
        RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];

        Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc;
        
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

        Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc.id);
        insert maincon;
        
        IP_TopazGlobalClientInformation__c globalclient = new IP_TopazGlobalClientInformation__c();
        globalclient.Name='Test global topaz';
        globalclient.IP_StatusID__c=2;
        globalclient.IP_SalesLedgerNumber__c='123';
        globalclient.IP_TopazUniquenumber__c = 156;
        insert globalclient;
        
        sirenum__Site__c site = new sirenum__Site__c();
        site.Name = 'testsite';
        site.sirenum__Operating_Company__c= acc.id;
        site.IP_ClientIDLegacy__c='123';
        site.GlobalClientName__c=globalclient.id;
        site.IP_ClientInvoiceName__c='Testclient';
        site.IP_InvoiceAddressStreet__c='101';
        site.IP_InvoiceAddressCity__c = 'Delhi';
        site.IP_InvoiceAddressPostcode__c = '110035';
        site.sirenum__Street_Address__c = 'ABC';
        site.sirenum__City__c = 'ABC';
        site.IP_MainContact__c = maincon.id;
        site.IP_PublicSector__c = 'No';
   // site.IP_LEA__c = 'Barking and Dagenham (EL001)';
        insert site;
        
        Batch_header__c batchheader = new Batch_header__c();
        batchheader.IP_Status__c = 'Approved';
        batchheader.IP_State__c ='Closed';
        batchheader.IP_BatchType__c ='Site Update';
        insert batchheader;

        IP_BatchLine__c batchline2 = new IP_BatchLine__c();
        batchline2.IP_BatchHeader__c = batchheader.id;
        batchline2.IP_Status__c = 'open';
        batchline2.IP_State__c  = 'open';
        batchline2.IP_TextField2__c = '123';
        batchline2.IP_TextField3__c = 'Name1';
        batchline2.IP_TextField6__c = 'Address1';
        batchline2.IP_TextField7__c = 'Address2';
        insert batchline2; 

 }
 @istest static void testsiteschedule(){
        
                List<IP_BatchLine__c> listBatchLine = [Select id,IP_Status__c,IP_TextField2__c,IP_TextField3__c,IP_TextField6__c,IP_TextField1__c,IP_TextField7__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        Test.StartTest();
        ScheduleSiteB2Fbatch sh1 = new ScheduleSiteB2Fbatch();
        String sch = '0 30 * * * ?';
        system.schedule('Test site', sch, sh1);
        Test.stopTest();
    }
 
 @istest static void BatchHeaderclassmethod1(){
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_Status__c,IP_TextField2__c,IP_TextField3__c,IP_TextField6__c,IP_TextField1__c,IP_TextField7__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        Test.startTest();
        Database.executeBatch(new SiteB2FUpdate(),1);
        Test.stopTest();    
    }
    @istest static void BatchHeaderclassmethod2(){
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_Status__c,IP_TextField2__c,IP_TextField3__c,IP_TextField6__c,IP_TextField1__c,IP_TextField7__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        List<sirenum__Site__c> sitelist = [Select id,IP_ClientIDLegacy__c from sirenum__Site__c limit 1];
        listBatchLine[0].IP_TextField1__c  = sitelist[0].IP_ClientIDLegacy__c;
        update listBatchLine;
        Test.startTest();
        Database.executeBatch(new SiteB2FUpdate(),1);
        Test.stopTest();    
    }
    @istest static void BatchHeaderclassmethod3(){
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_Status__c,IP_TextField2__c,IP_TextField3__c,IP_TextField6__c,IP_TextField1__c,IP_TextField7__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField1__c = '111';
        update listBatchLine;
        Test.startTest();
        Database.executeBatch(new SiteB2FUpdate(),1);
        Test.stopTest();    
    }
}