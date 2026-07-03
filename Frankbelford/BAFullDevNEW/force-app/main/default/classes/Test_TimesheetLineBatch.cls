@istest
private class Test_TimesheetLineBatch{

    @isTest
static void testexecute1() 
    {   
         String Query = 'Select id,sirenum__Shift__r.sirenum__Placement__r.IP_WorkerPayrollRef__c,sirenum__Shift__r.sirenum__Placement__r.IP_AssignmentRef__c,IP_PassToTempest__c,IP_RateCodes__c,sirenum__Rate_Line__r.sirenum__Standard_Rate_Name__c,sirenum__Shift__r.sirenum__Placement__r.Name,sirenum__Timesheet__r.sirenum__Site__r.IP_Timesheet_Method__c,IP_LastPassedToTempest__c,IP_PayrollPresentedTimesheetNumber__c,Name,sirenum__Timesheet__r.sirenum__Lines__c,sirenum__Timesheet__r.sirenum__Worker__r.name,sirenum__Timesheet__r.sirenum__Worker__c,sirenum__Timesheet__r.sirenum__Client__r.Name,sirenum__Timesheet__r.sirenum__Site__r.Name,sirenum__Timesheet__r.sirenum__Week_Ending__c,IP_PurchaseOrderNumber__c,sirenum__Date__c,IP_EdiRateCode__c,sirenum__Hours__c,sirenum__Shift__r.Approved_By__r.Name,sirenum__Shift__r.Approved_Date_Time__c from sirenum__Timesheet_Line__c where IP_PassToTempest__c = TRUE and GUID_Timesheetline__c=:GUID';
         
         
         String GUID = 'ABCD';
        String Field1 = 'IP_PassToTempest__c';
        String Field2 = 'IP_LastPassedToTempest__c';  
                     String Field3 = 'sirenum__Timesheet__r.IP_EmergencyPull__c';
  Account client = TestDataFactory.createCandidateAccount(1)[0]; 
        Insert client;
        
        
          RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate']; 
    RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 
    RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
       
        
    
     Account acc = new Account(Name='Capita',RecordTypeId=accountRec1.id);
          insert acc;
           insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
     Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc.id, IP_ContactType__c = 'Invoice Contact');
      
        insert maincon;
            
        
        Account act = TestDataFactory.createAccounts(1)[0]; 
        insert act;
         //Contact cont = TestDataFactory.createCandidate(client.id, 1)[0];
        //Insert cont;
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = true);
         Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
        candidate.IP_CandidateIDlegacy__c = 'JA22353489';
    	Insert candidate;
        
        sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(acc.Id, candidate.Id, 1)[0];
        Insert pac;
        
        sirenum__Rota__c sector = TestDataFactory.createSector(1)[0]; 
        Insert sector;
        
        sirenum__Job_Type__c jobType =TestDataFactory.createJobType(sector.id, 1)[0];
        Insert jobType;
        
        sirenum__Team__c jrole = TestDataFactory.createJobRole(pac.Id, jobType.Id, 1)[0]; 
        Insert jrole;
        
         Profile p = [SELECT Id FROM Profile where name='System Administrator'];
      User usr = TestDataFactory.createUsers(p.Id,1)[0];
        usr.username = 'nbjtestabc@mko.com';
        usr.IP_TempestDepartment__c = '0000';//'1062';
        usr.IP_TempestID__c = '65742';
        usr.IP_PassToTempest__c = TRUE;
        insert usr;  
        
        IP_TopazGlobalClientInformation__c topaz = TestDataFactory.createTopaz(1)[0];
        insert topaz;
        
        sirenum__Site__c site = TestDataFactory.createSites(acc.id,topaz.id,1)[0];
        site.IP_PassClientAddressToTempest__c = false;
        site.sirenum__Postal_Code__c = '1234';
        site.sirenum__City__c= 'ABC';
        site.IP_PublicSector__c = 'No';
        site.sirenum__Street_Address__c = 'test add';
        site.IP_MainContact__c = maincon.id;
       site.IP_InvoiceContact__c = maincon.id;
       site.IP_PassClientToTempest__c  = false;  
        site.IP_ClientAddressLastPassedToTempest__c = System.today();  
        site.IP_ClientLastPassedToTempest__c = System.today();  
        site.ownerid = usr.id;
        site.IP_Timesheet_Method__c = 'eTimesheet';
        Test.startTest();
        insert site;
        
        sirenum__Placement__c splace = TestDataFactory.createSPlacement1(candidate.Id, pac.Id, jrole.Id,usr.Id, 1)[0]; 
        splace.sirenum__site__c = site.id;
        //splace.IP_WorkerPayrollRef__c = 'JA22353489';
        Insert splace;
        
       /* IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0]; 
        insert tpz;    
        
        sirenum__Site__c ssite = TestDataFactory.createSites(act.id, tpz.id,1)[0];
        insert ssite;*/ 
        
        sirenum__Shift__c shft = TestDataFactory.createShift(splace.id, site.id,1)[0]; 
        shft.sirenum__Contact__c = candidate.Id;
    insert shft;  
        
        
         sirenum__Timesheet__c sts = TestDataFactory.createTimeSheet(client.id, candidate.Id,1)[0]; 
        sts.sirenum__Site__c = site.id;
        
        Insert sts;
      
        sirenum__Timesheet_Line__c stsl = TestDataFactory.createTimeSheetLine(sts.Id,shft.id,1)[0]; 
        stsl.GUID_Timesheetline__c = 'ABCD';
        Insert stsl;
        
        sts.IP_EmergencyPull__c = TRUE;
        update sts;
        
        
         TimesheetLineBatch b = new TimesheetLineBatch(query,Field1,Field2,GUID);
     
        Database.executeBatch(b,1);
        TimesheetEmergencyBatch b1 = new TimesheetEmergencyBatch(query,Field1,Field2,Field3,GUID);
     
        Database.executeBatch(b1,1);
       
        test.stopTest();
        
       }
    
    
}