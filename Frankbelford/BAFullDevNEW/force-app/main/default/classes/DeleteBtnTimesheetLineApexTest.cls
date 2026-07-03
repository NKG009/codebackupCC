@isTest
public class DeleteBtnTimesheetLineApexTest {
    
    static testMethod void Method1(){
        
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
        RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
        Account client = TestDataFactory.createCandidateAccount(1)[0]; 
        insert client;
        
        Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc;
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
        Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc.id);
        
        insert maincon;
        
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);
        
        Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
        candidate.IP_IsInvoicecontact__c = TRUE;
        insert candidate;
        
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        
        id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('LTD').getRecordTypeId();
        IP_PayProfile__c payprofile = new IP_PayProfile__c();
        payprofile.RecordTypeId = payRTId;
        
        payprofile.IP_Candidate__c = candidate.id;
        payprofile.IP_CompanyName__c='sfdc';
        payprofile.IP_Status__c = 'Active'; 
        payprofile.IP_CompanyRegNo__c  = 'ad123456';
        payprofile.IP_VATNumber__c     = '123456789';
        payprofile.IP_PayrollID__c  = 'test57861';
        payprofile.IP_VATRegistered__c=true;
        payprofile.IP_OkToSupply__c=1;
        payprofile.IP_BusinessAddressLine1__c='test address 1';
        payprofile.IP_BusinessAddressLine2__c='test address 2';
        payprofile.IP_BusinessAddressTown__c='town city';
        payprofile.IP_BusinessAddressPostcode__c='12345678';
        payprofile.IP_PayFrequency__c='Weekly';
        payprofile.IP_PaymentType__c='BACS';
        payprofile.IP_PassToTempest__c=true;
        payprofile.IP_BankAccountName__c = 'Test name1';
        payprofile.IP_AccountNumber__c = '98567497';
        payprofile.IP_SortCode__c = '645362';
        payprofile.IP_LastPassedToTempest__c=datetime.newInstance(2014, 9, 15, 12, 30, 0);
        
        insert payprofile; 
        
        Profile Prof=[SELECT Id FROM Profile WHERE Name='System Administrator' limit 1];
        User user = new User();            
        user.LastName = 'Data1';        
        user.FirstName='TestUser';       
        user.Alias = 'TstUrD';        
        user.Email = 'abc.efg@GHI.com';       
        user.Username = 'Email@js.com.uk';        
        user.ProfileId = Prof.id;     
        user.TimeZoneSidKey = 'GMT';       
        user.LanguageLocaleKey = 'en_US';        
        user.EmailEncodingKey = 'UTF-8';        
        user.LocaleSidKey = 'en_US';
        user.IP_TempestDepartment__c='2043';      
        user.IP_TempestDivision__c='NTS';       
        user.Department='1062';        
        insert user;       
        
        
        sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(client.Id, candidate.Id, 1)[0];
        Insert pac;
        
        sirenum__Rota__c sector = TestDataFactory.createSector(1)[0]; 
        Insert sector;
        
        sirenum__Job_Type__c jobType =TestDataFactory.createJobType(sector.id, 1)[0];
        Insert jobType;
        
        sirenum__Team__c jrole = TestDataFactory.createJobRole(pac.Id, jobType.Id, 1)[0]; 
        jrole.sirenum__Rota__c = sector.id;
        Insert jrole;
        
        
        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0];
        insert tpz;
        
        
        
        sirenum__Site__c site = new sirenum__Site__c();
        
        site.Name = 'testsite';
        site.sirenum__Operating_Company__c= acc.id;
        site.IP_ClientIDLegacy__c='123';
        site.GlobalClientName__c=tpz.id;
        site.IP_ClientInvoiceName__c='Testclient';
        site.IP_InvoiceAddressStreet__c='101';
        site.IP_InvoiceAddressCity__c = 'Delhi';
        site.IP_InvoiceAddressPostcode__c = '110035';
        
        site.IP_InvoiceContact__c = maincon.id;
        site.IP_MainContact__c = maincon.id;
        site.IP_PublicSector__c = 'No';
        insert site;
        
        sirenum__Placement__c spleacement = new sirenum__Placement__c();
        
        spleacement.Name = 'testing placment';
        spleacement.sirenum__Contact__c = candidate.id;
        spleacement.sirenum__Start_Date__c =  Date.newInstance(2017,11,01);
        spleacement.sirenum__End_Date__c= Date.newInstance(2017,12,20);
        spleacement.sirenum__Contract__c = pac.id;
        spleacement.sirenum__Job_Role__c = jrole.id;
        spleacement.sirenum__Site__c = site.Id;
        spleacement.sirenum__Status__c   = 'Active';
        spleacement.IP_Consultant1PercentageSplit__c=100;
        spleacement.IP_PassToTempest__c=true;
        spleacement.IP_Consultant1LookupSplitShare__c=UserInfo.getUserId();
        spleacement.sirenum__Rota__c = sector.id;
        spleacement.IP_PurchaseOrderNumber__c = 'ABCD';
        insert spleacement;
        
        sirenum__Shift__c shft = TestDataFactory.createShift(spleacement.Id,site.id, 1)[0];
        shft.sirenum__Rota__c = sector.id; 
       // shft.sirenum__Contact__c = candidate.id;
        insert shft;    
        sirenum__Timesheet__c sts = TestDataFactory.createTimeSheet(client.id, candidate.Id,1)[0]; 
        Insert sts;   
        
        sirenum__Timesheet_Line__c sheetline = TestDataFactory.createTimeSheetLine (sts.id,shft.id,1)[0];
        insert sheetline;
        
        
        IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
        ob.IP_OriginRecordID__c = spleacement.id;
        ob.IP_TransferType__c = 'Assignment';
        ob.IP_Passed__c = '';
        ob.IP_TimesheetID__c = sts.id;
        insert ob;   
        
        IP_OutboundDataTransfer__c ob1 = new IP_OutboundDataTransfer__c();
        ob1.IP_OriginRecordID__c = payprofile.id;
        ob1.IP_TransferType__c = 'Internal Worker';
        ob1.IP_Passed__c = '';
        ob1.IP_TimesheetID__c = sts.id;
        insert ob1;  
        
        IP_OutboundDataTransfer__c ob2 = new IP_OutboundDataTransfer__c();
        ob2.IP_OriginRecordID__c = candidate.id;
        ob2.IP_TransferType__c = 'External Worker';
        ob2.IP_Passed__c = '';
        ob2.IP_TimesheetID__c = sts.id;
        insert ob2;
        
        PageReference pageRef = Page.RestrictDeleteActionOnTimesheetLine;
        pageRef.getParameters().put('retURL','/'+sts.id);
        pageRef.getParameters().put('ID',sheetline.Id);
        Test.setCurrentPage(pageRef);
        
        system.runas(user){
            Test.startTest();
            DeleteBtnTimesheetLineApex abc = new DeleteBtnTimesheetLineApex();
            DeleteBtnTimesheetLineApex.deletemethod(sheetline.id);
            Test.stopTest();
        }
    }
    static testMethod void Testdelete(){
        
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
        RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
        Account client = TestDataFactory.createCandidateAccount(1)[0]; 
        insert client;
        
        Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc;
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
        Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc.id);
        
        insert maincon;
        
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);
        
        Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
        candidate.IP_IsInvoicecontact__c = TRUE;
        insert candidate;
        
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        
        id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('LTD').getRecordTypeId();
        IP_PayProfile__c payprofile = new IP_PayProfile__c();
        payprofile.RecordTypeId = payRTId;
        
        payprofile.IP_Candidate__c = candidate.id;
        payprofile.IP_CompanyName__c='sfdc';
        payprofile.IP_Status__c = 'Active'; 
        payprofile.IP_CompanyRegNo__c  = 'ad123456';
        payprofile.IP_VATNumber__c     = '123456789';
        payprofile.IP_PayrollID__c  = 'test57861';
        payprofile.IP_VATRegistered__c=true;
        payprofile.IP_OkToSupply__c=1;
        payprofile.IP_BusinessAddressLine1__c='test address 1';
        payprofile.IP_BusinessAddressLine2__c='test address 2';
        payprofile.IP_BusinessAddressTown__c='town city';
        payprofile.IP_BusinessAddressPostcode__c='12345678';
        payprofile.IP_PayFrequency__c='Weekly';
        payprofile.IP_PaymentType__c='BACS';
        payprofile.IP_PassToTempest__c=true;
        payprofile.IP_BankAccountName__c = 'Test name1';
        payprofile.IP_AccountNumber__c = '98567497';
        payprofile.IP_SortCode__c = '645362';
        payprofile.IP_LastPassedToTempest__c=datetime.newInstance(2014, 9, 15, 12, 30, 0);
        
        insert payprofile; 
        
        sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(client.Id, candidate.Id, 1)[0];
        Insert pac;
        
        sirenum__Rota__c sector = TestDataFactory.createSector(1)[0]; 
        Insert sector;
        
        sirenum__Job_Type__c jobType =TestDataFactory.createJobType(sector.id, 1)[0];
        Insert jobType;
        
        sirenum__Team__c jrole = TestDataFactory.createJobRole(pac.Id, jobType.Id, 1)[0]; 
        jrole.sirenum__Rota__c = sector.id;
        Insert jrole;
        
        
        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0];
        insert tpz;
        
        
        
        sirenum__Site__c site = new sirenum__Site__c();
        
        site.Name = 'testsite';
        site.sirenum__Operating_Company__c= acc.id;
        site.IP_ClientIDLegacy__c='123';
        site.GlobalClientName__c=tpz.id;
        site.IP_ClientInvoiceName__c='Testclient';
        site.IP_InvoiceAddressStreet__c='101';
        site.IP_InvoiceAddressCity__c = 'Delhi';
        site.IP_InvoiceAddressPostcode__c = '110035';
        
        site.IP_InvoiceContact__c = maincon.id;
        site.IP_MainContact__c = maincon.id;
        site.IP_PublicSector__c = 'No';
        insert site;
        
        sirenum__Placement__c spleacement = new sirenum__Placement__c();
        
        spleacement.Name = 'testing placment';
        spleacement.sirenum__Contact__c = candidate.id;
        spleacement.sirenum__Start_Date__c =  Date.newInstance(2017,11,01);
        spleacement.sirenum__End_Date__c= Date.newInstance(2017,12,20);
        spleacement.sirenum__Contract__c = pac.id;
        spleacement.sirenum__Job_Role__c = jrole.id;
        spleacement.sirenum__Site__c = site.Id;
        spleacement.sirenum__Status__c   = 'Active';
        spleacement.IP_Consultant1PercentageSplit__c=100;
        spleacement.IP_PassToTempest__c=true;
        spleacement.IP_Consultant1LookupSplitShare__c=UserInfo.getUserId();
        spleacement.sirenum__Rota__c = sector.id;
        spleacement.IP_PurchaseOrderNumber__c = 'ABCD';
        insert spleacement;
        Test.startTest();
        sirenum__Shift__c shft = TestDataFactory.createShift(spleacement.Id,site.id, 1)[0];
        shft.sirenum__Contact__c = candidate.id;
        shft.sirenum__Rota__c = sector.id; 
        insert shft;    
        sirenum__Timesheet__c sts = TestDataFactory.createTimeSheet(client.id, candidate.Id,1)[0]; 
        Insert sts;   
        
        sirenum__Timesheet_Line__c sheetline = TestDataFactory.createTimeSheetLine (sts.id,shft.id,1)[0];
        insert sheetline;
        
        sirenum__Timesheet_Line__c sheetline1 = TestDataFactory.createTimeSheetLine (sts.id,shft.id,1)[0];
        insert sheetline1;
        sheetline1.IP_LastPassedToTempest__c=system.today();
        update   sheetline1;  
        
        IP_OutboundDataTransfer__c ob = new IP_OutboundDataTransfer__c();
        ob.IP_OriginRecordID__c = spleacement.id;
        ob.IP_TransferType__c = 'Assignment';
        ob.IP_Passed__c = '';
        ob.IP_TimesheetID__c = sts.id;
        insert ob;   
        
        IP_OutboundDataTransfer__c ob1 = new IP_OutboundDataTransfer__c();
        ob1.IP_OriginRecordID__c = payprofile.id;
        ob1.IP_TransferType__c = 'Internal Worker';
        ob1.IP_Passed__c = '';
        ob1.IP_TimesheetID__c = sts.id;
        insert ob1;  
        
        IP_OutboundDataTransfer__c ob2 = new IP_OutboundDataTransfer__c();
        ob2.IP_OriginRecordID__c = candidate.id;
        ob2.IP_TransferType__c = 'External Worker';
        ob2.IP_Passed__c = '';
        ob2.IP_TimesheetID__c = sts.id;
        insert ob2;
        DeleteBtnTimesheetLineApex.deletemethod(sheetline1.id);
        
    }
    
}