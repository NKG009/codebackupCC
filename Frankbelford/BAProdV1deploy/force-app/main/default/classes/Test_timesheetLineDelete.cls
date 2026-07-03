@isTest
public class Test_timesheetLineDelete {
    static testMethod void Testdelete(){
        Account client = TestDataFactory.createCandidateAccount(1)[0]; 
        insert client;
        
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);
        
        Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
        candidate.IP_IsInvoicecontact__c = TRUE;
        insert candidate;
        
        sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(client.Id, candidate.Id, 1)[0];
        Insert pac;
        
        sirenum__Rota__c sector = TestDataFactory.createSector(1)[0]; 
        Insert sector;
        
        sirenum__Job_Type__c jobType =TestDataFactory.createJobType(sector.id, 1)[0];
        Insert jobType;
        
        sirenum__Team__c jrole = TestDataFactory.createJobRole(pac.Id, jobType.Id, 1)[0]; 
        Insert jrole;
        
        Profile p = [SELECT Id,name FROM Profile where name='System Administrator'];
        User usr = TestDataFactory.createUsers(p.Id,1)[0];
        usr.username = 'gftsd@polo.com';
        usr.IP_TempestDepartment__c = '1062';
        usr.IP_TempestDivision__c = 'SYS';
        usr.IP_TempestId__c='1287awfdqg';
        
        insert usr;
        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0];
        insert tpz;
        
/*        sirenum__Site__c site = TestDataFactory.createSites(client.id,tpz.id,1)[0];
        site.ownerId = usr.id;
        site.sirenum__Operating_Company__c = client.id;
        site.sirenum__Postal_Code__c = '10234';
        site.sirenum__Street_Address__c = '1231';
        site.IP_MainContact__c = candidate.id;
        site.IP_InvoiceContact__c = candidate.id;
        insert site;*/
        
        sirenum__Site__c site = new sirenum__Site__c();
        
        site.Name = 'NewSite';
        site.sirenum__Operating_Company__c= client.id;
        site.IP_ClientIDLegacy__c ='QAWWSED34';
        site.IP_PublicSector__c='No';
        site.GlobalClientName__c= tpz.Id;
        site.IP_PassClientToTempest__c=false;
        site.IP_ClientLastPassedToTempest__c=null;
        site.IP_PassClientAddressToTempest__c=false;
       // site.IP_PreAWRWTRValue__c=4;
        //site.IP_PostAWRWTRValue__c=5;
        site.OwnerId=usr.id;
        insert site;
        system.debug('Value in site'+ site);
        
        
        sirenum__Placement__c splace = TestDataFactory.createSPlacement1(candidate.Id, pac.Id, jrole.Id,usr.Id, 1)[0]; 
        splace.sirenum__Site__c = site.id;
        splace.IP_Consultant1LookupSplitShare__c = usr.id;
        splace.IP_Costcode__c='1062';
        
        Insert splace;     
        
        sirenum__Shift__c shft = TestDataFactory.createShift(splace.Id,site.id, 1)[0]; 
        insert shft;    
        sirenum__Timesheet__c sts = TestDataFactory.createTimeSheet(client.id, candidate.Id,1)[0]; 
        Insert sts;   
        
        sirenum__Timesheet_Line__c sheetline = TestDataFactory.createTimeSheetLine (sts.id,shft.id,1)[0];
        insert sheetline;
        
        sirenum__Timesheet_Line__c sheetline1 = TestDataFactory.createTimeSheetLine (sts.id,shft.id,1)[0];
        insert sheetline1;
        sheetline1.IP_LastPassedToTempest__c=system.today();
        update   sheetline1;  
        
        Test.startTest();
        try {  
            delete sheetline1;  
            System.Assert(true, 'Record Deleted');  
        }catch(DMLException e){  
            System.assert(true, 'Deletion failed appropriately');
        }
        Test.stopTest();
    }
    static testMethod void Testdelete1(){
        Profile p = [SELECT Id,name FROM Profile where name='JS Recruiter - Hybrid'];
        User usr1 = TestDataFactory.createUsers(p.Id,1)[0];
        usr1.username = 'tyrde34@yup.com';
        usr1.IP_TempestDepartment__c = '1062';
        usr1.IP_TempestDivision__c = 'SYS';
        usr1.IP_TempestId__c='1287awfdqg';
        insert usr1;
        system.runas(usr1)
        {
        Account client = TestDataFactory.createCandidateAccount(1)[0]; 
        insert client;
        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);
        
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
        candidate.IP_IsInvoicecontact__c = TRUE;
        insert candidate;
        
        sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(client.Id, candidate.Id, 1)[0];
        Insert pac;
        
        sirenum__Rota__c sector = TestDataFactory.createSector(1)[0]; 
        Insert sector;
        
        sirenum__Job_Type__c jobType =TestDataFactory.createJobType(sector.id, 1)[0];
        Insert jobType;
        
        sirenum__Team__c jrole = TestDataFactory.createJobRole(pac.Id, jobType.Id, 1)[0]; 
        Insert jrole;
        
        
        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0];
        insert tpz;
        /*
        sirenum__Site__c site = TestDataFactory.createSites(client.id,tpz.id,1)[0];
        site.ownerId = usr1.id;
        site.sirenum__Operating_Company__c = client.id;
        site.sirenum__Postal_Code__c = '10234';
        site.sirenum__Street_Address__c = '1231';
        site.IP_MainContact__c = candidate.id;
        site.IP_InvoiceContact__c = candidate.id;
        insert site;
        */    
         sirenum__Site__c site = new sirenum__Site__c();
        
        site.Name = 'NewSite';
        site.sirenum__Operating_Company__c= client.id;
        site.IP_ClientIDLegacy__c ='QAWWSED34';
        site.IP_PublicSector__c='No';
        site.GlobalClientName__c= tpz.Id;
        site.IP_PassClientToTempest__c=false;
        site.IP_ClientLastPassedToTempest__c=null;
        site.IP_PassClientAddressToTempest__c=false;
        //site.IP_PreAWRWTRValue__c=4;
        //site.IP_PostAWRWTRValue__c=5;
        site.OwnerId=usr1.id;
        insert site;
        system.debug('Value in site'+ site);
           
        
        sirenum__Placement__c splace = TestDataFactory.createSPlacement1(candidate.Id, pac.Id, jrole.Id,usr1.Id, 1)[0]; 
        splace.sirenum__Site__c = site.id;
        splace.IP_Consultant1LookupSplitShare__c = usr1.id;
        splace.IP_Costcode__c='1062';
        Insert splace;
        
        sirenum__Shift__c shft = TestDataFactory.createShift(splace.Id,site.id, 1)[0]; 
        insert shft;    
        sirenum__Timesheet__c sts = TestDataFactory.createTimeSheet(client.id, candidate.Id,1)[0]; 
        Insert sts;   
        
        sirenum__Timesheet_Line__c sheetline = TestDataFactory.createTimeSheetLine (sts.id,shft.id,1)[0];
        insert sheetline;
        
        sirenum__Timesheet_Line__c sheetline1 = TestDataFactory.createTimeSheetLine (sts.id,shft.id,1)[0];
        insert sheetline1;
        
         sirenum__Timesheet_Line__c sheetline2 = TestDataFactory.createTimeSheetLine (sts.id,shft.id,1)[0];
            insert sheetline2;
        
        
            Test.startTest();
            try {  
                delete sheetline;  
                System.Assert(true, 'Record Deleted');  
            }catch(DMLException e){  
                System.assert(true, 'Deletion failed appropriately');
            }
            Test.stopTest();
        }
    }
}