@isTest
public class TestLeaverRequestControllerLightning {
    
    @testsetup
    static void datasetup(){

        Account acc = TestDataFactory.createClients(1)[0]; 
        insert acc; 
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        
        Contact c = new Contact();
        c.FirstName='Con';
        c.lastName='Test Contact';
        c.IP_CategoryOfWork__c='Industrial';
        c.sirenum__National_Insurance__c='AA123456A';
        c.P45_Date_by_Head_Office__c=system.today();
        c.AccountID=acc.id;
        insert c;

        RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
        Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc.id);

        insert maincon;

        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        
        RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'PAYE'];

        IP_PayProfile__c pay= new IP_PayProfile__c();
        pay.RecordTypeId=rt.id;
        pay.IP_PayrollID__c='Testpayrol';
        pay.IP_Status__c='Active';
        pay.IP_Candidate__c=c.Id;
        pay.IP_CompanyRegNo__c='12345678';
        pay.IP_VATRegistered__c=true;
        pay.IP_VATNumber__c='123456789';
        pay.P45_Initiated__c=true;
        pay.IP_LastPassedTotempest__c = Date.newInstance(2017, 01, 01);
        insert pay;

        RecordType rt1=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'LTD'];

        IP_PayProfile__c pay1= new IP_PayProfile__c();
        pay1.RecordTypeId=rt1.id;
        pay1.IP_PayrollID__c='Tes76l';
        pay1.IP_Status__c='Active';
        pay1.IP_Candidate__c=c.Id;
        pay1.IP_CompanyRegNo__c='12345678';
        pay1.IP_VATRegistered__c=true;
        pay1.IP_VATNumber__c='123456789';
        insert pay1;

        Profile p = [SELECT Id FROM Profile where name='System Administrator'];
        User usr = TestDataFactory.createUsers(p.Id,1)[0];
        usr.username = 'hgd89809@cko.com';
        usr.IP_TempestDepartment__c = '1062';
        usr.IP_TempestID__c = '2342341';
        usr.IP_PassToTempest__c = TRUE;
        insert usr; 

        Test.startTest();

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
        site.IP_MainContact__c = maincon.id;
        site.IP_InvoiceContact__c = maincon.id;
        site.Ownerid = usr.id;
        site.IP_PublicSector__c = 'No';
        insert site;

        sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
        contract.Name                 = 'test contract';
        contract.sirenum__Client__c   = acc.id;
        contract.sirenum__Employee__c = c.id;
        insert contract;

        // to create job roll need to create job type and  Imappelam Sector

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
        jobroll.IP_OPWIPSRole__c = 'No';
        jobroll.sirenum__Rota__c =  sector.id;
        insert jobroll;

        sirenum__Placement__c spleacement = new sirenum__Placement__c();
        spleacement.Name = 'testing placment';
        spleacement.sirenum__Contact__c = c.id;
        spleacement.sirenum__Start_Date__c =  Date.newInstance(2018,11,01);
        spleacement.sirenum__End_Date__c= Date.newInstance(2019,12,20);
        spleacement.sirenum__Contract__c = contract.id;
        spleacement.sirenum__Job_Role__c = jobroll.id;
        spleacement.sirenum__Site__c = site.Id;
        spleacement.sirenum__Status__c   = 'Active';
        spleacement.IP_PayMethod__c = pay.id;
        spleacement.sirenum__Rota__c = sector.id;
        spleacement.IP_Consultant1PercentageSplit__c=100;
        spleacement.IP_Consultant1LookupSplitShare__c = usr.id;
        insert spleacement;
        System.debug('**Test class check**'+spleacement);
        sirenum__placement__C p56 = [Select id,IP_Consultant1IDnumberSplitShare__c from sirenum__placement__C where id =:spleacement.id ];
        System.debug('**Test class check**'+p56.IP_Consultant1IDnumberSplitShare__c);  

        sirenum__Timesheet__c newTimeSheet1 = new sirenum__Timesheet__c();
        newTimeSheet1.sirenum__Worker__c = c.id;
        newTimesheet1.sirenum__Client__c=acc.id;
        newTimesheet1.sirenum__Team__c=jobroll.id;
        newTimesheet1.sirenum__Site__c=site.Id;
        newTimesheet1.sirenum__Week_Ending__c =Date.newInstance(2018,11,24);
        insert newTimeSheet1;

        sirenum__Shift__c shift = new sirenum__Shift__c();
        shift.sirenum__Site__c = site.id;
        shift.sirenum__Placement__c = spleacement.Id;
        shift.sirenum__Team__c = jobroll.id;
        shift.sirenum__Contact__c = c.id; 
        shift.sirenum__Published__c = true;
        shift.sirenum__cancelled__c = false;
        shift.sirenum__Rota__c = sector.id;
        // shift.sirenum__Timesheet_summaries__c = newTimesheet1.Id;
        insert shift;
        system.debug('**Test class check shift**'+shift);

        sirenum__Timesheet_Line__c stl = new sirenum__Timesheet_Line__c();
        stl.sirenum__Timesheet__c=newTimeSheet1.id;
        stl.sirenum__Rate__c=22.0;
        stl.sirenum__Hours__c=1;
        stl.IP_PassToTempest__c=true;     
        stl.IP_RateCodes__c='Taxable Expenses /TX';
        stl.sirenum__Shift__c=shift.id;
        insert stl;     
        Test.stopTest();
    }
        
    static testmethod void P45action1(){
        
        List<Contact> listContact = [Select id from Contact limit 1];
        LeaverRequestControllerLightning.getContact(listContact[0].id);
        LeaverRequestControllerLightning.getTimesheetLines(listContact[0].id);
        LeaverRequestControllerLightning.getShifts(listContact[0].id);
    }

}