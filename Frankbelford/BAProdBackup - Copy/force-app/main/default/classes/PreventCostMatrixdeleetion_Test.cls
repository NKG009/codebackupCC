@isTest
private class PreventCostMatrixdeleetion_Test {
    
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
        insert usr;
        
        sirenum__Placement__c splace = TestDataFactory.createSPlacement1(candidate.Id, pac.Id, jrole.Id,usr.Id, 1)[0]; 
        Insert splace;
         
        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0];
         insert tpz;
         
         sirenum__Site__c site = TestDataFactory.createSites(client.id,tpz.id,1)[0];
         
         site.IP_InvoiceContact__c = candidate.id;
         insert site;
         
        sirenum__Shift__c shft = TestDataFactory.createShift(splace.Id,site.id, 1)[0]; 
        insert shft;    
         sirenum__Timesheet__c sts = TestDataFactory.createTimeSheet(client.id, candidate.Id,1)[0]; 
        Insert sts;   
         
         sirenum__PayrollCostMatrixFrame__c pcf = new sirenum__PayrollCostMatrixFrame__c();
         pcf.Name = 'Testabc';
         insert pcf;
         
        sirenum__PayrollCostMatrix__c pcm = new sirenum__PayrollCostMatrix__c();
     //  pcm.name= 'Testabc';  
        pcm.sirenum__costMatrixFrame__c = pcf.id;
        pcm.sirenum__Income_per_Hour__c = 1;
        pcm.sirenum__Cost_per_Shift__c   = 1;
         pcm.sirenum__Day_Type__c = 'ONE_TIME';
         pcm.sirenum__Taxed_deduction__c = 10;
         pcm.sirenum__Taxed_expenses__c  = 12;
         pcm.sirenum__Non_taxed_deduction__c  = 20;
         pcm.sirenum__Non_taxed_expenses__c = 10;
         pcm.sirenum__Bonus__c = 30;
         pcm.sirenum__Cost_per_Hour__c = 10;
        insert pcm;
    
        sirenum__Timesheet_Line__c stsl = TestDataFactory.createTimeSheetLine(sts.Id,shft.id,1)[0]; 
        stsl.sirenum__Cost_Matrix__c = pcm.id;
        Insert stsl;  
         
         Test.startTest();
         try {  
            delete pcm;  
            System.Assert(true, 'Record Deleted');  
        }catch(DMLException e){  
            System.assert(true, 'Deletion failed appropriately');
}
         Test.stopTest();
}   
    static testMethod void Testdelete1(){
 		 Profile p1 = [SELECT Id,name FROM Profile where name='JS Recruiter - Hybrid'];
          User usr1 = new User(LastName = 'LIVESTON',FirstName='JASON',Alias = 'jliv',Email = 'mm.sf@outlook.com',
                                Username = 'dummyEmail@email.com', ProfileId = p1.id, TimeZoneSidKey = 'GMT',
                                LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8', LocaleSidKey = 'en_US',IP_TempestDepartment__c='1069',
                                IP_TempestDivision__c='NTS',Department='1069',IP_PassToTempest__c=true);
        insert usr1;
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
        insert usr;
        
        sirenum__Placement__c splace = TestDataFactory.createSPlacement1(candidate.Id, pac.Id, jrole.Id,usr.Id, 1)[0]; 
        Insert splace;
         
        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0];
         insert tpz;
         
         sirenum__Site__c site = TestDataFactory.createSites(client.id,tpz.id,1)[0];
         
         site.IP_InvoiceContact__c = candidate.id;
         insert site;
         
        sirenum__Shift__c shft = TestDataFactory.createShift(splace.Id,site.id, 1)[0]; 
        insert shft;    
         sirenum__Timesheet__c sts = TestDataFactory.createTimeSheet(client.id, candidate.Id,1)[0]; 
        Insert sts;   
         
         sirenum__PayrollCostMatrixFrame__c pcf = new sirenum__PayrollCostMatrixFrame__c();
         pcf.Name = 'Testabc';
         insert pcf;
         
        sirenum__PayrollCostMatrix__c pcm = new sirenum__PayrollCostMatrix__c();
     //  pcm.name= 'Testabc';  
        pcm.sirenum__costMatrixFrame__c = pcf.id;
        pcm.sirenum__Income_per_Hour__c = 1;
        pcm.sirenum__Cost_per_Shift__c   = 1;
         pcm.sirenum__Day_Type__c = 'ONE_TIME';
         pcm.sirenum__Taxed_deduction__c = 10;
         pcm.sirenum__Taxed_expenses__c  = 12;
         pcm.sirenum__Non_taxed_deduction__c  = 20;
         pcm.sirenum__Non_taxed_expenses__c = 10;
         pcm.sirenum__Bonus__c = 30;
         pcm.sirenum__Cost_per_Hour__c = 10;
        insert pcm;
    
        sirenum__Timesheet_Line__c stsl = TestDataFactory.createTimeSheetLine(sts.Id,shft.id,1)[0]; 
        stsl.sirenum__Cost_Matrix__c = pcm.id;
        Insert stsl;  
          system.runas(usr1)
          {
         Test.startTest();
         try {  
            delete pcm;  
            System.Assert(true, 'Record Deleted');  
        }catch(DMLException e){  
            System.assert(true, 'Deletion failed appropriately');
}
         Test.stopTest();
          }
}   
}