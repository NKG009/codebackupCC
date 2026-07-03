@isTest
public class Test_TimesheetDelete {
   static testMethod void Testdelete(){
    Account client = TestDataFactory.createCandidateAccount(1)[0]; 
        insert client;
       
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
        
        Profile p = [SELECT Id,name FROM Profile where name='System Administrator'];
      User usr = TestDataFactory.createUsers(p.Id,1)[0];
       usr.username = 'lmnjqw21@abc.com';
        insert usr;
        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0];
         insert tpz;
         
         sirenum__Site__c site = TestDataFactory.createSites(client.id,tpz.id,1)[0];
         
         site.IP_InvoiceContact__c = candidate.id;
         insert site;
        
        sirenum__Placement__c splace = TestDataFactory.createSPlacement1(candidate.Id, pac.Id, jrole.Id,usr.Id, 1)[0]; 
        splace.sirenum__Site__c = site.id;
        Insert splace;
         
       
         
        sirenum__Shift__c shft = TestDataFactory.createShift(splace.Id,site.id, 1)[0]; 
        insert shft;    
         sirenum__Timesheet__c sts = TestDataFactory.createTimeSheet(client.id, candidate.Id,1)[0]; 
        Insert sts;   
         
         
       Test.startTest();
         try {  
            delete sts;  
            System.Assert(true, 'Record Deleted');  
        }catch(DMLException e){  
            System.assert(true, 'Deletion failed appropriately');
}
         Test.stopTest();
}
    static testMethod void Testdelete1(){
    Account client = TestDataFactory.createCandidateAccount(1)[0]; 
        insert client;
       
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
        
        Profile p = [SELECT Id,name FROM Profile where name='JS Recruiter - Hybrid'];
      User usr1 = TestDataFactory.createUsers(p.Id,1)[0];
               usr1.username = 'vdswea564@xyz.com';
        insert usr1;
         IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0];
         insert tpz;
         
         sirenum__Site__c site = TestDataFactory.createSites(client.id,tpz.id,1)[0];
            site.IP_InvoiceContact__c = candidate.id;
         insert site;
        
        sirenum__Placement__c splace = TestDataFactory.createSPlacement1(candidate.Id, pac.Id, jrole.Id,usr1.Id, 1)[0]; 
        splace.sirenum__Site__c = site.id;
        Insert splace;
         
        sirenum__Shift__c shft = TestDataFactory.createShift(splace.Id,site.id, 1)[0]; 
        insert shft;    
         sirenum__Timesheet__c sts = TestDataFactory.createTimeSheet(client.id, candidate.Id,1)[0]; 
        Insert sts;   
         
         system.runas(usr1)
         {
       Test.startTest();
         try {  
            delete sts;  
            System.Assert(true, 'Record Deleted');  
        }catch(DMLException e){  
            System.assert(true, 'Deletion failed appropriately');
}
         Test.stopTest();
         }
}
}