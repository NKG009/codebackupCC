@isTest
public class Test_permplacementB2FUpdate{
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
    
     Insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
    RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
    Contact con = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acccon.id);
   insert con;
    
    IP_TopazGlobalClientInformation__c topaz = TestDataFactory.createTopaz(1)[0];
    topaz.IP_SalesLedgerNumber__c = '645628';
    insert topaz;
    
    sirenum__Site__c site1 = TestDataFactory.createSites(acccon.id,topaz.id,1)[0];
       site1.IP_ClientIDLegacy__c = '1234'; 
        site1.IP_ClientInvoiceName__c = 'Testname';
        site1.IP_InvoiceAddressStreet__c = 'street1';
        site1.IP_InvoiceAddressCity__c = 'city1';
        site1.IP_InvoiceAddressPostcode__c = '7554';
        site1.IP_PublicSector__c = 'No';
  //  site1.IP_LEA__c = 'Barnet (EL002)';
        site1.IP_MainContact__c = con.id;
      //  site1.IP_InvoiceContact__c = con.id;
         site1.IP_PassClientToTempest__c = false;
        site1.IP_PassClientAddressToTempest__c = false;
         site1.sirenum__Street_Address__c = 'abc';
        site1.sirenum__City__c = 'xyz';
    insert site1;
    System.debug('inserted site check1'+site1.Missing_Site_Details__c);
    
    TR1__Job__c job1 = new TR1__Job__c();
     RecordType perms = [Select Id From RecordType Where DeveloperName='Perm' and sObjectType='TR1__Job__c'];
    job1.Name = 'Test Job1';
    job1.IP_Fixed_Fee__c = 120;
    job1.TR1__Account__c = candacc.id;
    job1.TR1__Contact__c = candidateid.id;
    job1.s5m__Site__c = site1.id;
    job1.Recordtypeid = perms.id;
    insert job1;
    
    TR1__Closing_Report__c permplacement = TestDataFactory.createTs2Placement(acccon.id,candidateid.id,con.id,job1.id,site1.id,'Perm',1)[0];
    insert permplacement;
    
    TR1__Closing_Report__c ts2p = TestDataFactory.createTs2Placement(acccon.Id, candidateid.Id, con.Id, job1.Id, site1.id,'Perm_Credits', 1)[0]; 
    insert ts2p;
    
    Batch_header__c batchheader = new Batch_header__c();
    batchheader.IP_Status__c = 'Approved';
    batchheader.IP_State__c ='Closed';
    batchheader.IP_BatchType__c ='Perm Placement';
    insert batchheader;


        IP_BatchLine__c batchline2 = new IP_BatchLine__c();
        batchline2.IP_BatchHeader__c = batchheader.id;
        batchline2.IP_Status__c = 'open';
        batchline2.IP_State__c  = 'open';
        batchline2.IP_TextField3__c = 'Debit';
        batchline2.IP_TextField4__c = permplacement.Placement_ID__c;
        batchline2.IP_TextField1__c = '12345678';
        batchline2.IP_DateField1__c = Date.newInstance(2017,11,20);
        insert batchline2; // legacycon
        
 }
 @istest static void BatchHeaderclassmethod1(){
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_Status__c,IP_TextField3__c,IP_TextField4__c,IP_TextField1__c,IP_DateField1__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        Test.startTest();
        Database.executeBatch(new permplacementB2FUpdate(),1);
        Test.stopTest();    
    }
@istest static void BatchHeaderclassmethod2(){
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_Status__c,IP_TextField3__c,IP_TextField4__c,IP_TextField1__c,IP_DateField1__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField3__c = '';
        update listBatchLine;
        Test.startTest();
        Database.executeBatch(new permplacementB2FUpdate(),1);
        Test.stopTest();    
    }
    @istest static void BatchHeaderclassmethod3(){
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_Status__c,IP_TextField3__c,IP_TextField4__c,IP_TextField1__c,IP_DateField1__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        list<TR1__Closing_Report__c> permlist = [Select id,Placement_ID__c from TR1__Closing_Report__c where RecordType.Name = 'Perm' limit 1];     
        listBatchLine[0].IP_TextField4__c = permlist[0].Placement_ID__c;
        update listBatchLine;
        Test.startTest();
        Database.executeBatch(new permplacementB2FUpdate(),1);
        Test.stopTest();    
    }
    @istest static void BatchHeaderclassmethod4(){
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_Status__c,IP_TextField3__c,IP_TextField4__c,IP_TextField1__c,IP_DateField1__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField4__c = '42725281';
        update listBatchLine;
        Test.startTest();
        Database.executeBatch(new permplacementB2FUpdate(),1);
        Test.stopTest();    
    }
     @istest static void BatchHeaderclassmethod5(){
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_Status__c,IP_TextField3__c,IP_TextField4__c,IP_TextField1__c,IP_DateField1__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField3__c = 'Credit';
        update listBatchLine;
        Test.startTest();
        Database.executeBatch(new permplacementB2FUpdate(),1);
        Test.stopTest();    
    }
@istest static void BatchHeaderclassmethod6(){
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_Status__c,IP_TextField3__c,IP_TextField4__c,IP_TextField1__c,IP_DateField1__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField3__c = '';
        update listBatchLine;
        Test.startTest();
        Database.executeBatch(new permplacementB2FUpdate(),1);
        Test.stopTest();    
    }
    @istest static void BatchHeaderclassmethod7(){
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_Status__c,IP_TextField3__c,IP_TextField4__c,IP_TextField1__c,IP_DateField1__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        list<TR1__Closing_Report__c> permlist = [Select id,IP_Credit_Reference__c from TR1__Closing_Report__c where RecordType.Name = 'Perm Credits' limit 1];  
        listBatchLine[0].IP_TextField3__c = 'Credit';
        listBatchLine[0].IP_TextField4__c = permlist[0].IP_Credit_Reference__c;
        update listBatchLine;
        Test.startTest();
        Database.executeBatch(new permplacementB2FUpdate(),1);
        Test.stopTest();    
    }
    @istest static void BatchHeaderclassmethod8(){
        List<IP_BatchLine__c> listBatchLine = [Select id,IP_Status__c,IP_TextField3__c,IP_TextField4__c,IP_TextField1__c,IP_DateField1__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        listBatchLine[0].IP_TextField3__c = 'Credit';
        listBatchLine[0].IP_TextField4__c = '42925281';
        update listBatchLine;
        Test.startTest();
        Database.executeBatch(new permplacementB2FUpdate(),1);
        Test.stopTest();    
    }
     @istest static void testpermschedule(){
        
                List<IP_BatchLine__c> listBatchLine = [Select id,IP_Status__c,IP_TextField2__c,IP_TextField3__c,IP_TextField6__c,IP_TextField1__c,IP_TextField7__c from IP_BatchLine__c where IP_Status__c = 'open' limit 1];
        Test.StartTest();
        SchedulePermB2Fbatch sh1 = new SchedulePermB2Fbatch();
        String sch = '0 30 * * * ?';
        system.schedule('Test perm', sch, sh1);
        Test.stopTest();
    }
}