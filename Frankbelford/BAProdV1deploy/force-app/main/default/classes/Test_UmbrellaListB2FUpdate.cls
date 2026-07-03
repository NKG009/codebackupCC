@isTest
public class Test_UmbrellaListB2FUpdate{
 @testSetup static void dataSetUp(){   
    IP_Umbrellalist__c umb = new IP_Umbrellalist__c();
    umb.IP_SupplierReference__c = '101';
    umb.IP_CompanyRegNo__c = '12345678';
    umb.IP_OkToSupply__c = 1;
    umb.IP_PaymentType__c = 'A';
    umb.IP_AddressLine1__c = 'test 124';
    insert umb;
    
    Batch_header__c batchheader = new Batch_header__c();
    batchheader.IP_Status__c = 'Approved';
    batchheader.IP_State__c ='Closed';
    batchheader.IP_BatchType__c ='Umbrella Company';
    insert batchheader;

    IP_BatchLine__c batchline2 = new IP_BatchLine__c();
    batchline2.IP_BatchHeader__c = batchheader.id;
    batchline2.IP_Status__c = 'open';
    batchline2.IP_State__c  = 'open';
    batchline2.IP_TextField2__c = 'ABC Company';
    batchline2.IP_TextField6__c = 'Address1';
    batchline2.IP_TextField7__c = 'Address12';
    insert batchline2; // legacycon
 }
 @istest static void BatchHeaderclassmethod1(){
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_Status__c,IP_TextField2__c,IP_TextField6__c,IP_TextField1__c,IP_TextField7__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        Test.startTest();
        Database.executeBatch(new UmbrellaListB2FUpdate(),1);
        Test.stopTest();    
    }
    @istest static void BatchHeaderclassmethod2(){
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_Status__c,IP_TextField2__c,IP_TextField6__c,IP_TextField1__c,IP_TextField7__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        List<IP_Umbrellalist__c> umblist = [Select id,IP_SupplierReference__c from IP_Umbrellalist__c limit 1];
        listBatchLine[0].IP_TextField1__c = umblist[0].IP_SupplierReference__c;
        update listBatchLine;
        Test.startTest();
        Database.executeBatch(new UmbrellaListB2FUpdate(),1);
        Test.stopTest();    
    }
    @istest static void BatchHeaderclassmethod3(){
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_Status__c,IP_TextField2__c,IP_TextField6__c,IP_TextField1__c,IP_TextField7__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField1__c = '111';
        update listBatchLine;
        Test.startTest();
        Database.executeBatch(new UmbrellaListB2FUpdate(),1);
        Test.stopTest();    
    }
    @istest static void testumbrellachedule(){
        
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_Status__c,IP_TextField2__c,IP_TextField3__c,IP_TextField6__c,IP_TextField1__c,IP_TextField7__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        Test.StartTest();
        ScheduleUmbrellaB2Fbatch sh1 = new ScheduleUmbrellaB2Fbatch();
        String sch = '0 30 * * * ?';
        system.schedule('Test umb', sch, sh1);
        Test.stopTest();
    }
 }