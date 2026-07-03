@isTest
public class Test_TopazGlobalB2FUpdate {
  @testSetup
  static void dataSetUp() {
    IP_TopazGlobalClientInformation__c globalclient = new IP_TopazGlobalClientInformation__c();
    globalclient.Name = 'Test global topaz';
    globalclient.IP_StatusID__c = 2;
    globalclient.IP_SalesLedgerNumber__c = '134241';
    globalclient.IP_TopazUniquenumber__c = 156;
    insert globalclient;

    Batch_header__c batchheader = new Batch_header__c();
    batchheader.IP_Status__c = 'Approved';
    batchheader.IP_State__c = 'Closed';
    batchheader.IP_BatchType__c = 'Topaz Global Account';
    insert batchheader;

    IP_BatchLine__c batchline2 = new IP_BatchLine__c();
    batchline2.IP_BatchHeader__c = batchheader.id;
    batchline2.IP_Status__c = 'open';
    batchline2.IP_State__c = 'open';
    batchline2.IP_TextField2__c = '134241';
    batchline2.IP_TextField1__c = 'Name1';
    batchline2.IP_TextField6__c = 'Address1';
    batchline2.IP_TextField7__c = 'Address2';
    insert batchline2;
  }
  @istest
  static void BatchHeaderclassmethod1() {
    List<IP_BatchLine__c> listBatchLine = [
      SELECT
        id,
        IP_Status__c,
        IP_TextField2__c,
        IP_TextField6__c,
        IP_TextField1__c,
        IP_TextField7__c
      FROM IP_BatchLine__c
      WHERE IP_Status__c = 'open'
      LIMIT 1
    ];
    Test.startTest();
    Database.executeBatch(new TopazGlobalB2FUpdate(), 1);
    Test.stopTest();
  }
  @istest
  static void BatchHeaderclassmethod2() {
    List<IP_BatchLine__c> listBatchLine = [
      SELECT
        id,
        IP_Status__c,
        IP_Number12d4Field1__c,
        IP_TextField2__c,
        IP_TextField6__c,
        IP_TextField1__c,
        IP_TextField7__c
      FROM IP_BatchLine__c
      WHERE IP_Status__c = 'open'
      LIMIT 1
    ];
    List<IP_TopazGlobalClientInformation__c> topazlist = [
      SELECT id, IP_TopazUniquenumber__c, IP_SalesLedgerNumber__c
      FROM IP_TopazGlobalClientInformation__c
      LIMIT 1
    ];
    listBatchLine[0].IP_TextField2__c = topazlist[0].IP_SalesLedgerNumber__c;
    update listBatchLine;
    Test.startTest();
    Database.executeBatch(new TopazGlobalB2FUpdate(), 1);
    Test.stopTest();
  }
  @istest
  static void BatchHeaderclassmethod3() {
    List<IP_BatchLine__c> listBatchLine = [
      SELECT
        id,
        IP_Status__c,
        IP_Number12d4Field1__c,
        IP_TextField2__c,
        IP_TextField6__c,
        IP_TextField1__c,
        IP_TextField7__c
      FROM IP_BatchLine__c
      WHERE IP_Status__c = 'open'
      LIMIT 1
    ];
    listBatchLine[0].IP_TextField2__c = '111';
    update listBatchLine;
    Test.startTest();
    Database.executeBatch(new TopazGlobalB2FUpdate(), 1);
    Test.stopTest();
  }
  @istest
  static void testtopazschedule() {
    List<IP_BatchLine__c> listBatchLine = [
      SELECT
        id,
        IP_Status__c,
        IP_TextField2__c,
        IP_TextField3__c,
        IP_TextField6__c,
        IP_TextField1__c,
        IP_TextField7__c
      FROM IP_BatchLine__c
      WHERE IP_Status__c = 'open'
      LIMIT 1
    ];
    Test.StartTest();
    ScheduleTopazB2Fbatch sh1 = new ScheduleTopazB2Fbatch();
    String sch = '0 30 * * * ?';
    system.schedule('Test topaz', sch, sh1);
    Test.stopTest();
  }
}