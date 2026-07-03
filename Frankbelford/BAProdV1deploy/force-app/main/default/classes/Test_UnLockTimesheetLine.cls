@isTest
public class Test_UnLockTimesheetLine {
    static testmethod void testunlock(){   
        
          insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
           insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
  
           RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
     RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
 Account acc1 = new Account(Name='Candidates',RecordTypeId=accountRec.id);
         
        insert acc1;
         Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc;
        
         RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
          Contact con = new Contact(AccountID = acc.Id, 
                                          RecordTypeId=condRec.id,
                                          FirstName ='Manish',
                                          Salutation ='Mr',
                                          MailingCity='ggn',
                                          MailingCountry='india',
                                          MailingPostalCode='110092',
                                          MailingState='Haryana',
                                          LastName ='candidate',  
                                          sirenum__National_Insurance__c='AA323232A', 
                                          IP_CandidateIDlegacy__c='dsdsdsdd', 
                                          MailingStreet='abc',
                                          P45_Requested__c=true,
                                          PayrollLeaver__c=null,
                                          Title = 'TestLastName',
                                          Initials__c = 'TestLastName',
                                          Birthdate = Date.valueOf('1990-02-20'),
                                          Phone = '9879879877',
                                   IP_WorkerStartDate__c=Date.valueOf('2017-02-20'),
                                         ts2__EEO_Gender__c = 'M',
                                          IP_CategoryOfWork__c='Catering;Industrial',
                                        IP_ThirdPartyID__c='testpay12', IP_IsInvoicecontact__c=true         );
        
        insert con;
        RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact']; 
         Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc.id, IP_ContactType__c = 'Invoice Contact');      
        insert maincon;
        
             IP_TopazGlobalClientInformation__c globalclient = new IP_TopazGlobalClientInformation__c();
        globalclient.Name='Test global topaz';
        globalclient.IP_StatusID__c=2;
       globalclient.IP_SalesLedgerNumber__c='123';
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
        site.IP_InvoiceContact__c = maincon.id;
        site.IP_MainContact__c = maincon.id;
        site.IP_PublicSector__c = 'No';
         insert site;
        
          sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
         
         contract.Name                 = 'test contract';
         contract.sirenum__Client__c   = acc.id;
         contract.sirenum__Employee__c = con.id;
         
         insert contract;
        
          sirenum__Rota__c sector = new sirenum__Rota__c();
         
         sector.Name = 'new sector';
         insert sector;
         
         sirenum__Job_Type__c jobtype = new sirenum__Job_Type__c();
         jobtype.name = 'testjobtype';
         jobtype.Impellam_Sector__c = sector.id;
         jobtype.Impellam_Core_Category__c = 'Administration -ADM';
         jobtype.Impellam_Job_Category__c ='Administrator -OA001';
         
         insert jobtype;
         
         sirenum__Team__c jobroll = new sirenum__Team__c();
         
         jobroll.name = 'testjobroll';
         jobroll.sirenum__Account__c = contract.id; 
         jobroll.sirenum__Job_Type__c = jobtype.id;
         
         insert jobroll;
         sirenum__Placement__c splace = TestDataFactory.createSPlacement1(con.Id, contract.Id, jobroll.Id,UserInfo.getUserId(), 1)[0]; 
        splace.sirenum__site__C = site.id;
        splace.IP_PasstoTempest__c = TRUE;
        
        Insert splace;
        
        sirenum__Shift__c shft = TestDataFactory.createShift(splace.id, site.id,1)[0];
        shft.sirenum__Contact__c = con.id;
        insert shft;   
    
        sirenum__Timesheet__c newTimeSheet1 = new sirenum__Timesheet__c();
     newTimeSheet1.sirenum__Worker__c = con.id;
     newTimesheet1.sirenum__Client__c=acc.id;
     newTimesheet1.sirenum__Team__c=jobroll.id;
     newTimesheet1.sirenum__Site__c=site.Id;
     newTimesheet1.sirenum__Week_Ending__c =Date.newInstance(2017,11,24);
        insert newTimeSheet1;
        
           sirenum__Timesheet_Line__c stsl = new sirenum__Timesheet_Line__c(); 
        stsl.sirenum__Timesheet__c=newTimeSheet1.id;
                stsl.sirenum__Rate__c=22.0;
                stsl.sirenum__Hours__c=1;
                stsl.sirenum__Charge__c = 10;
 
                stsl.IP_RateCodes__c='Taxable Expenses /TX';
                stsl.sirenum__Shift__c=shft.id;
        insert stsl;
        
          IP_OutboundDataTransfer__c ob2 = new IP_OutboundDataTransfer__c();
   		  ob2.IP_Tempest_Department__c = '1062';
        ob2.IP_TransferType__c = 'Timesheet';     
        ob2.IP_OriginRecordID__c = stsl.id;
        insert ob2;
        
          Database.executeBatch(new UnLockTimesheetLines(), 10);
    }
    
}