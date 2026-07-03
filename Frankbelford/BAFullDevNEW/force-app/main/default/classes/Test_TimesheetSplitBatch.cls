@isTest
public class Test_TimesheetSplitBatch {

    public static testmethod void method1()
    {
        Account client = TestDataFactory.createCandidateAccount(1)[0]; 
        Insert client;
        
        Account act = TestDataFactory.createAccounts(1)[0];
        act.IP_InvoicingMethod__c = 'Standard';
        insert act;
         //Contact cont = TestDataFactory.createCandidate(client.id, 1)[0];
        //Insert cont;
        
         RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
     Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=act.id, IP_ContactType__c = 'Invoice Contact');
      
        insert maincon;
       
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
            insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
              insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

         Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
        candidate.IP_BorrowedTemp__c = 'Yes';
    Insert candidate;
    
        
        
        sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(client.Id, candidate.Id, 1)[0];
        Insert pac;
        
        sirenum__Rota__c sector = TestDataFactory.createSector(1)[0]; 
        Insert sector;
        
        sirenum__Job_Type__c jobType =TestDataFactory.createJobType(sector.id, 1)[0];
        Insert jobType;
        
        sirenum__Team__c jrole = TestDataFactory.createJobRole(pac.Id, jobType.Id, 1)[0]; 
        Insert jrole;
        
        Profile p = [SELECT Id FROM Profile where name='System Administrator'];
      User usr = TestDataFactory.createUsers(p.Id,1)[0];
        usr.username = 'nbjudui453@mko.com';
        usr.IP_TempestDepartment__c = '1062';
        usr.IP_TempestID__c = '65742';
        usr.IP_PassToTempest__c = TRUE;
        insert usr; 
        system.debug('$$UserID$$'+usr);
          IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0]; 
        tpz.IP_SalesLedgerNumber__c = '315621';
        insert tpz;    
        
        sirenum__Site__c ssite = TestDataFactory.createSites(act.id, tpz.id,1)[0];
        ssite.IP_PassClientAddressToTempest__c = false;
        ssite.sirenum__Postal_Code__c = '1234';
        ssite.sirenum__City__c= 'ABC';
        ssite.IP_PublicSector__c = 'No';
        ssite.sirenum__Street_Address__c = 'test add';
        ssite.IP_MainContact__c = maincon.id;
        ssite.IP_InvoiceContact__c = maincon.id;
        ssite.IP_PassClientToTempest__c  = false;  
        ssite.IP_ClientAddressLastPassedToTempest__c = System.today();  
        ssite.IP_ClientLastPassedToTempest__c = System.today();  
        ssite.ownerid = usr.id;
        insert ssite;
        
        System.debug('check site'+ssite);
        
        sirenum__Placement__c splace = TestDataFactory.createSPlacement1(candidate.Id, pac.Id, jrole.Id,usr.Id, 1)[0]; 
        splace.sirenum__site__C = ssite.id;
       // splace.IP_PayMethod__c =payprofile.id;
        splace.IP_PasstoTempest__c = TRUE;
        
        Insert splace;
        
              System.debug('check placement'+splace);
        
        sirenum__Shift__c shft = TestDataFactory.createShift(splace.id, ssite.id,1)[0];
        shft.sirenum__Contact__c = candidate.id;
        insert shft;  
        
        
         sirenum__Timesheet__c sts = TestDataFactory.createTimeSheet(client.id, candidate.Id,1)[0]; 
        sts.IP_DuplicateCheckPassOK__c = TRUE;
     //  sts.IP_EmergencyPull__c=true;
        sts.IP_FlaggingCheck__c = true;
        sts.sirenum__Week_Ending__c = Date.newInstance(2018, 02, 01);
        sts.sirenum__Site__c = ssite.id;
        Insert sts;
      //
      List<sirenum__Timesheet_Line__c> timelist = new List<sirenum__Timesheet_Line__c>();
        sirenum__Timesheet_Line__c stsl = new sirenum__Timesheet_Line__c(); 
        stsl.sirenum__Timesheet__c=sts.id;
                stsl.sirenum__Rate__c=22.0;
                stsl.sirenum__Hours__c=1;
                stsl.sirenum__Charge__c = 10;
              //  stsl.IP_PassToTempest__c=true;    
                stsl.IP_RateCodes__c='Taxable Expenses /TX';
                stsl.sirenum__Shift__c=shft.id;
        
         sirenum__Timesheet_Line__c stsl11 = new sirenum__Timesheet_Line__c(); 
        stsl11.sirenum__Timesheet__c=sts.id;
                stsl11.sirenum__Rate__c=22.0;
                stsl11.sirenum__Hours__c=1;
                stsl11.sirenum__Charge__c = 10;
              //  stsl.IP_PassToTempest__c=true;    
                stsl11.IP_RateCodes__c='Taxable Expenses /TX';
                stsl11.sirenum__Shift__c=shft.id;
         sirenum__Timesheet_Line__c stsl12 = new sirenum__Timesheet_Line__c(); 
        stsl12.sirenum__Timesheet__c=sts.id;
                stsl12.sirenum__Rate__c=22.0;
                stsl12.sirenum__Hours__c=1;
                stsl12.sirenum__Charge__c = 10;
              //  stsl.IP_PassToTempest__c=true;    
                stsl12.IP_RateCodes__c='Taxable Expenses /TX';
                stsl12.sirenum__Shift__c=shft.id;
 
       sirenum__Timesheet_Line__c stsl2 = new sirenum__Timesheet_Line__c(); 
        stsl2.sirenum__Timesheet__c=sts.id;
                stsl2.sirenum__Rate__c=22.0;
                stsl2.sirenum__Hours__c=1;
                stsl2.sirenum__Charge__c = 11;
            //    stsl2.IP_PassToTempest__c=true;    
                stsl2.IP_RateCodes__c='Taxable Expenses /TX';
                stsl2.sirenum__Shift__c=shft.id;
        sirenum__Timesheet_Line__c stsl22 = new sirenum__Timesheet_Line__c(); 
        stsl22.sirenum__Timesheet__c=sts.id;
                stsl22.sirenum__Rate__c=22.0;
                stsl22.sirenum__Hours__c=1;
                stsl22.sirenum__Charge__c = 11;
            //    stsl2.IP_PassToTempest__c=true;    
                stsl22.IP_RateCodes__c='Taxable Expenses /TX';
                stsl22.sirenum__Shift__c=shft.id;
         sirenum__Timesheet_Line__c stsl23 = new sirenum__Timesheet_Line__c(); 
        stsl23.sirenum__Timesheet__c=sts.id;
                stsl23.sirenum__Rate__c=22.0;
                stsl23.sirenum__Hours__c=1;
                stsl23.sirenum__Charge__c = 11;
            //    stsl2.IP_PassToTempest__c=true;    
                stsl23.IP_RateCodes__c='Taxable Expenses /TX';
                stsl23.sirenum__Shift__c=shft.id;
        
                 sirenum__Timesheet_Line__c stsl3 = new sirenum__Timesheet_Line__c(); 
                 stsl3.sirenum__Timesheet__c=sts.id;
                stsl3.sirenum__Rate__c=22.0;
                stsl3.sirenum__Hours__c=1;
                stsl3.sirenum__Charge__c = 15;  
                stsl3.IP_RateCodes__c='Taxable Expenses /TX';
                stsl3.sirenum__Shift__c=shft.id;
         sirenum__Timesheet_Line__c stsl31 = new sirenum__Timesheet_Line__c(); 
                 stsl31.sirenum__Timesheet__c=sts.id;
                stsl31.sirenum__Rate__c=22.0;
                stsl31.sirenum__Hours__c=1;
                stsl31.sirenum__Charge__c = 15;  
                stsl31.IP_RateCodes__c='Taxable Expenses /TX';
                stsl31.sirenum__Shift__c=shft.id;
         sirenum__Timesheet_Line__c stsl32 = new sirenum__Timesheet_Line__c(); 
                 stsl32.sirenum__Timesheet__c=sts.id;
                stsl32.sirenum__Rate__c=22.0;
                stsl32.sirenum__Hours__c=1;
                stsl32.sirenum__Charge__c = 15;  
                stsl32.IP_RateCodes__c='Taxable Expenses /TX';
                stsl32.sirenum__Shift__c=shft.id;
        
             sirenum__Timesheet_Line__c stsl4 = new sirenum__Timesheet_Line__c(); 
                 stsl4.sirenum__Timesheet__c=sts.id;
                stsl4.sirenum__Rate__c=22.0;
                stsl4.sirenum__Hours__c=1;
                stsl4.sirenum__Charge__c = 17;  
                stsl4.IP_RateCodes__c='Taxable Expenses /TX';
                stsl4.sirenum__Shift__c=shft.id;
        sirenum__Timesheet_Line__c stsl41 = new sirenum__Timesheet_Line__c(); 
                 stsl41.sirenum__Timesheet__c=sts.id;
                stsl41.sirenum__Rate__c=22.0;
                stsl41.sirenum__Hours__c=1;
                stsl41.sirenum__Charge__c = 17;  
                stsl41.IP_RateCodes__c='Taxable Expenses /TX';
                stsl41.sirenum__Shift__c=shft.id;
        sirenum__Timesheet_Line__c stsl42 = new sirenum__Timesheet_Line__c(); 
                 stsl42.sirenum__Timesheet__c=sts.id;
                stsl42.sirenum__Rate__c=22.0;
                stsl42.sirenum__Hours__c=1;
                stsl42.sirenum__Charge__c = 17;  
                stsl42.IP_RateCodes__c='Taxable Expenses /TX';
                stsl42.sirenum__Shift__c=shft.id;
        
             sirenum__Timesheet_Line__c stsl5 = new sirenum__Timesheet_Line__c(); 
                 stsl5.sirenum__Timesheet__c=sts.id;
                stsl5.sirenum__Rate__c=22.0;
                stsl5.sirenum__Hours__c=1;
                stsl5.sirenum__Charge__c = 19;  
                stsl5.IP_RateCodes__c='Taxable Expenses /TX';
                stsl5.sirenum__Shift__c=shft.id;
        sirenum__Timesheet_Line__c stsl51 = new sirenum__Timesheet_Line__c(); 
                 stsl51.sirenum__Timesheet__c=sts.id;
                stsl51.sirenum__Rate__c=22.0;
                stsl51.sirenum__Hours__c=1;
                stsl51.sirenum__Charge__c = 19;  
                stsl51.IP_RateCodes__c='Taxable Expenses /TX';
                stsl51.sirenum__Shift__c=shft.id;
        sirenum__Timesheet_Line__c stsl52 = new sirenum__Timesheet_Line__c(); 
                 stsl52.sirenum__Timesheet__c=sts.id;
                stsl52.sirenum__Rate__c=22.0;
                stsl52.sirenum__Hours__c=1;
                stsl52.sirenum__Charge__c = 19;  
                stsl52.IP_RateCodes__c='Taxable Expenses /TX';
                stsl52.sirenum__Shift__c=shft.id;
        
         sirenum__Timesheet_Line__c stsl6 = new sirenum__Timesheet_Line__c(); 
                 stsl6.sirenum__Timesheet__c=sts.id;
                stsl6.sirenum__Rate__c=22.0;
                stsl6.sirenum__Hours__c=1;
                stsl6.sirenum__Charge__c = 20;  
                stsl6.IP_RateCodes__c='Taxable Expenses /TX';
                stsl6.sirenum__Shift__c=shft.id;
         sirenum__Timesheet_Line__c stsl61 = new sirenum__Timesheet_Line__c(); 
                stsl61.sirenum__Timesheet__c=sts.id;
                stsl61.sirenum__Rate__c=22.0;
                stsl61.sirenum__Hours__c=1;
                stsl61.sirenum__Charge__c = 20;  
                stsl61.IP_RateCodes__c='Taxable Expenses /TX';
                stsl61.sirenum__Shift__c=shft.id;
         sirenum__Timesheet_Line__c stsl62 = new sirenum__Timesheet_Line__c(); 
                 stsl62.sirenum__Timesheet__c=sts.id;
                stsl62.sirenum__Rate__c=22.0;
                stsl62.sirenum__Hours__c=1;
                stsl62.sirenum__Charge__c = 20;  
                stsl62.IP_RateCodes__c='Taxable Expenses /TX';
                stsl62.sirenum__Shift__c=shft.id;
          sirenum__Timesheet_Line__c stsl7 = new sirenum__Timesheet_Line__c(); 
                 stsl7.sirenum__Timesheet__c=sts.id;
                stsl7.sirenum__Rate__c=22.0;
                stsl7.sirenum__Hours__c=1;
                stsl7.sirenum__Charge__c = 23;  
                stsl7.IP_RateCodes__c='Taxable Expenses /TX';
                stsl7.sirenum__Shift__c=shft.id;
          sirenum__Timesheet_Line__c stsl8 = new sirenum__Timesheet_Line__c(); 
                 stsl8.sirenum__Timesheet__c=sts.id;
                stsl8.sirenum__Rate__c=22.0;
                stsl8.sirenum__Hours__c=1;
                stsl8.sirenum__Charge__c = 25;  
                stsl8.IP_RateCodes__c='Taxable Expenses /TX';
                stsl8.sirenum__Shift__c=shft.id;
 
        timelist.add(stsl);
        timelist.add(stsl11);
        timelist.add(stsl12);
        timelist.add(stsl2);
        timelist.add(stsl22);
        timelist.add(stsl23);
        timelist.add(stsl3);
        timelist.add(stsl31);
        timelist.add(stsl32);
        timelist.add(stsl4);
        timelist.add(stsl41);
        timelist.add(stsl42);
        timelist.add(stsl5);
        timelist.add(stsl51);
        timelist.add(stsl52);
        timelist.add(stsl6);
        timelist.add(stsl61);
        timelist.add(stsl62);
        timelist.add(stsl7);
        timelist.add(stsl8);
        Insert timelist;
        
         Test.startTest();
         insert new CreatedDateSPliting__c(name = 'SplittingData', SplittingCreatedDate__c = Date.newInstance(2019, 01, 01));
        Database.executeBatch(new TimesheetSplittingBatch(),1);
            
        Test.stopTest();
               
    }
     public static testmethod void method2()
    {
        Account client = TestDataFactory.createCandidateAccount(1)[0]; 
        Insert client;
        
        Account act = TestDataFactory.createAccounts(1)[0];
        act.IP_InvoicingMethod__c = 'Standard';
        insert act;
         //Contact cont = TestDataFactory.createCandidate(client.id, 1)[0];
        //Insert cont;
         RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
     Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=act.id, IP_ContactType__c = 'Invoice Contact');
      
        insert maincon;
        
        
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
            insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
              insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

         Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
        candidate.IP_BorrowedTemp__c = 'Yes';
    Insert candidate;
    
        
        
        sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(client.Id, candidate.Id, 1)[0];
        Insert pac;
        
        sirenum__Rota__c sector = TestDataFactory.createSector(1)[0]; 
        Insert sector;
        
        sirenum__Job_Type__c jobType =TestDataFactory.createJobType(sector.id, 1)[0];
        Insert jobType;
        
        sirenum__Team__c jrole = TestDataFactory.createJobRole(pac.Id, jobType.Id, 1)[0]; 
        Insert jrole;
        
        Profile p = [SELECT Id FROM Profile where name='System Administrator'];
      User usr = TestDataFactory.createUsers(p.Id,1)[0];
        usr.username = 'nbjudui453@mko.com';
        usr.IP_TempestDepartment__c = '1062';
        usr.IP_TempestID__c = '65742';
        usr.IP_PassToTempest__c = TRUE;
        insert usr; 
        system.debug('$$UserID$$'+usr);
          IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0]; 
        tpz.IP_SalesLedgerNumber__c = '315621';
        insert tpz;    
        
        sirenum__Site__c ssite = TestDataFactory.createSites(act.id, tpz.id,1)[0];
        ssite.IP_PassClientAddressToTempest__c = false;
        ssite.sirenum__Postal_Code__c = '1234';
        ssite.sirenum__City__c= 'ABC';
        ssite.IP_PublicSector__c = 'No';
        ssite.sirenum__Street_Address__c = 'test add';
        ssite.IP_MainContact__c = maincon.id;
        ssite.IP_InvoiceContact__c = maincon.id;
        ssite.IP_PassClientToTempest__c  = false;  
        ssite.IP_ClientAddressLastPassedToTempest__c = System.today();  
        ssite.IP_ClientLastPassedToTempest__c = System.today();  
        ssite.ownerid = usr.id;
        insert ssite;
        
        System.debug('check site'+ssite);
        
        sirenum__Placement__c splace = TestDataFactory.createSPlacement1(candidate.Id, pac.Id, jrole.Id,usr.Id, 1)[0]; 
        splace.sirenum__site__C = ssite.id;
       // splace.IP_PayMethod__c =payprofile.id;
        splace.IP_PasstoTempest__c = TRUE;
        
        Insert splace;
        
              System.debug('check placement'+splace);
        
        sirenum__Shift__c shft = TestDataFactory.createShift(splace.id, ssite.id,1)[0];
        shft.sirenum__Contact__c = candidate.id;
        insert shft;  
        
        
         sirenum__Timesheet__c sts = TestDataFactory.createTimeSheet(client.id, candidate.Id,1)[0]; 
        sts.IP_DuplicateCheckPassOK__c = TRUE;
      // sts.IP_EmergencyPull__c=true;
        sts.IP_FlaggingCheck__c = true;
        sts.sirenum__Week_Ending__c = Date.newInstance(2018, 02, 01);
        sts.sirenum__Site__c = ssite.id;
        Insert sts;
      //
      List<sirenum__Timesheet_Line__c> timelist = new List<sirenum__Timesheet_Line__c>();
        sirenum__Timesheet_Line__c stsl = new sirenum__Timesheet_Line__c(); 
        stsl.sirenum__Timesheet__c=sts.id;
                stsl.sirenum__Rate__c=22.0;
                stsl.sirenum__Hours__c=1;
                stsl.sirenum__Charge__c = 10;
              //  stsl.IP_PassToTempest__c=true;    
                stsl.IP_RateCodes__c='Taxable Expenses /TX';
                stsl.sirenum__Shift__c=shft.id;
        
         sirenum__Timesheet_Line__c stsl11 = new sirenum__Timesheet_Line__c(); 
        stsl11.sirenum__Timesheet__c=sts.id;
                stsl11.sirenum__Rate__c=22.0;
                stsl11.sirenum__Hours__c=1;
                stsl11.sirenum__Charge__c = 10;
              //  stsl.IP_PassToTempest__c=true;    
                stsl11.IP_RateCodes__c='Taxable Expenses /TX';
                stsl11.sirenum__Shift__c=shft.id;
 
       sirenum__Timesheet_Line__c stsl2 = new sirenum__Timesheet_Line__c(); 
        stsl2.sirenum__Timesheet__c=sts.id;
                stsl2.sirenum__Rate__c=22.0;
                stsl2.sirenum__Hours__c=1;
                stsl2.sirenum__Charge__c = 11;
            //    stsl2.IP_PassToTempest__c=true;    
                stsl2.IP_RateCodes__c='Taxable Expenses /TX';
                stsl2.sirenum__Shift__c=shft.id;
        sirenum__Timesheet_Line__c stsl22 = new sirenum__Timesheet_Line__c(); 
        stsl22.sirenum__Timesheet__c=sts.id;
                stsl22.sirenum__Rate__c=22.0;
                stsl22.sirenum__Hours__c=1;
                stsl22.sirenum__Charge__c = 11;
            //    stsl2.IP_PassToTempest__c=true;    
                stsl22.IP_RateCodes__c='Taxable Expenses /TX';
                stsl22.sirenum__Shift__c=shft.id;
    
        
        
          sirenum__Timesheet_Line__c stsl7 = new sirenum__Timesheet_Line__c(); 
                 stsl7.sirenum__Timesheet__c=sts.id;
                stsl7.sirenum__Rate__c=22.0;
                stsl7.sirenum__Hours__c=1;
                stsl7.sirenum__Charge__c = 23;  
                stsl7.IP_RateCodes__c='Taxable Expenses /TX';
                stsl7.sirenum__Shift__c=shft.id;
          sirenum__Timesheet_Line__c stsl8 = new sirenum__Timesheet_Line__c(); 
                 stsl8.sirenum__Timesheet__c=sts.id;
                stsl8.sirenum__Rate__c=22.0;
                stsl8.sirenum__Hours__c=1;
                stsl8.sirenum__Charge__c = 25;  
                stsl8.IP_RateCodes__c='Taxable Expenses /TX';
                stsl8.sirenum__Shift__c=shft.id;
          sirenum__Timesheet_Line__c stsl9 = new sirenum__Timesheet_Line__c(); 
                 stsl9.sirenum__Timesheet__c=sts.id;
                stsl9.sirenum__Rate__c=22.0;
                stsl9.sirenum__Hours__c=1;
                stsl9.sirenum__Charge__c = 55;  
                stsl9.IP_RateCodes__c='Taxable Expenses /TX';
                stsl9.sirenum__Shift__c=shft.id;
          sirenum__Timesheet_Line__c stsl10  = new sirenum__Timesheet_Line__c(); 
                 stsl10.sirenum__Timesheet__c=sts.id;
                stsl10.sirenum__Rate__c=22.0;
                stsl10.sirenum__Hours__c=1;
                stsl10.sirenum__Charge__c = 45;  
                stsl10.IP_RateCodes__c='Taxable Expenses /TX';
                stsl10.sirenum__Shift__c=shft.id;
          sirenum__Timesheet_Line__c stsl01  = new sirenum__Timesheet_Line__c(); 
                 stsl01.sirenum__Timesheet__c=sts.id;
                stsl01.sirenum__Rate__c=22.0;
                stsl01.sirenum__Hours__c=1;
                stsl01.sirenum__Charge__c = 45;  
                stsl01.IP_RateCodes__c='Taxable Expenses /TX';
                stsl01.sirenum__Shift__c=shft.id;
          sirenum__Timesheet_Line__c stsl12  = new sirenum__Timesheet_Line__c(); 
                 stsl12.sirenum__Timesheet__c=sts.id;
                stsl12.sirenum__Rate__c=22.0;
                stsl12.sirenum__Hours__c=1;
                stsl12.sirenum__Charge__c = 45;  
                stsl12.IP_RateCodes__c='Taxable Expenses /TX';
                stsl12.sirenum__Shift__c=shft.id;
          sirenum__Timesheet_Line__c stsl13  = new sirenum__Timesheet_Line__c(); 
                 stsl13.sirenum__Timesheet__c=sts.id;
                stsl13.sirenum__Rate__c=22.0;
                stsl13.sirenum__Hours__c=1;
                stsl13.sirenum__Charge__c = 45;  
                stsl13.IP_RateCodes__c='Taxable Expenses /TX';
                stsl13.sirenum__Shift__c=shft.id;
          sirenum__Timesheet_Line__c stsl14  = new sirenum__Timesheet_Line__c(); 
                 stsl14.sirenum__Timesheet__c=sts.id;
                stsl14.sirenum__Rate__c=22.0;
                stsl14.sirenum__Hours__c=1;
                stsl14.sirenum__Charge__c = 45;  
                stsl14.IP_RateCodes__c='Taxable Expenses /TX';
                stsl14.sirenum__Shift__c=shft.id;
          sirenum__Timesheet_Line__c stsl15  = new sirenum__Timesheet_Line__c(); 
                 stsl15.sirenum__Timesheet__c=sts.id;
                stsl15.sirenum__Rate__c=22.0;
                stsl15.sirenum__Hours__c=1;
                stsl15.sirenum__Charge__c = 45;  
                stsl15.IP_RateCodes__c='Taxable Expenses /TX';
                stsl15.sirenum__Shift__c=shft.id;
 
        timelist.add(stsl);
        timelist.add(stsl11);
   
        timelist.add(stsl2);
        //timelist.add(stsl22);
  
        timelist.add(stsl7);
        timelist.add(stsl8);
        timelist.add(stsl9);
        timelist.add(stsl10);
        timelist.add(stsl01);
        timelist.add(stsl12);
        timelist.add(stsl13);
        timelist.add(stsl14);
        timelist.add(stsl15);
        Insert timelist;
        
         Test.startTest();
     insert new CreatedDateSPliting__c(name = 'SplittingData', SplittingCreatedDate__c = Date.newInstance(2019, 01, 01));
    
        Database.executeBatch(new TimesheetSplittingBatch(),1);
            
        Test.stopTest();
               
    }
       public static testmethod void method3()
    {
        Account client = TestDataFactory.createCandidateAccount(1)[0]; 
        Insert client;
        
        Account act = TestDataFactory.createAccounts(1)[0];
        act.IP_InvoicingMethod__c = 'Standard';
        insert act;
         //Contact cont = TestDataFactory.createCandidate(client.id, 1)[0];
        //Insert cont;
        RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
     Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=act.id, IP_ContactType__c = 'Invoice Contact');
      
        insert maincon;
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
            insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
              insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

            Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
        candidate.IP_BorrowedTemp__c = 'Yes';
    Insert candidate;
    
        
        
        sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(client.Id, candidate.Id, 1)[0];
        Insert pac;
        
        sirenum__Rota__c sector = TestDataFactory.createSector(1)[0]; 
        Insert sector;
        
        sirenum__Job_Type__c jobType =TestDataFactory.createJobType(sector.id, 1)[0];
        Insert jobType;
        
        sirenum__Team__c jrole = TestDataFactory.createJobRole(pac.Id, jobType.Id, 1)[0]; 
        Insert jrole;
        
        Profile p = [SELECT Id FROM Profile where name='System Administrator'];
      User usr = TestDataFactory.createUsers(p.Id,1)[0];
        usr.username = 'nbjudui453@mko.com';
        usr.IP_TempestDepartment__c = '1062';
        usr.IP_TempestID__c = '65742';
        usr.IP_PassToTempest__c = TRUE;
        insert usr; 
        system.debug('$$UserID$$'+usr);
          IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0]; 
        tpz.IP_SalesLedgerNumber__c = '315621';
        insert tpz;    
        
        sirenum__Site__c ssite = TestDataFactory.createSites(act.id, tpz.id,1)[0];
        ssite.IP_PassClientAddressToTempest__c = false;
        ssite.sirenum__Postal_Code__c = '1234';
        ssite.sirenum__City__c= 'ABC';
        ssite.IP_PublicSector__c = 'No';
        ssite.sirenum__Street_Address__c = 'test add';
        ssite.IP_MainContact__c = maincon.id;
        ssite.IP_InvoiceContact__c = maincon.id;
        ssite.IP_PassClientToTempest__c  = false;  
        ssite.IP_ClientAddressLastPassedToTempest__c = System.today();  
        ssite.IP_ClientLastPassedToTempest__c = System.today();  
        ssite.ownerid = usr.id;
        insert ssite;
        
        System.debug('check site'+ssite);
        
        sirenum__Placement__c splace = TestDataFactory.createSPlacement1(candidate.Id, pac.Id, jrole.Id,usr.Id, 1)[0]; 
        splace.sirenum__site__C = ssite.id;
       // splace.IP_PayMethod__c =payprofile.id;
        splace.IP_PasstoTempest__c = TRUE;
        
        Insert splace;
        
              System.debug('check placement'+splace);
        
        sirenum__Shift__c shft = TestDataFactory.createShift(splace.id, ssite.id,1)[0];
        shft.sirenum__Contact__c = candidate.id;
        insert shft;  
        
        
         sirenum__Timesheet__c sts = TestDataFactory.createTimeSheet(client.id, candidate.Id,1)[0]; 
        sts.IP_DuplicateCheckPassOK__c = TRUE;
     //  sts.IP_EmergencyPull__c=true;
        sts.IP_FlaggingCheck__c = true;
        sts.sirenum__Week_Ending__c = Date.newInstance(2018, 02, 01);
        sts.sirenum__Site__c = ssite.id;
        Insert sts;
      //
      List<sirenum__Timesheet_Line__c> timelist = new List<sirenum__Timesheet_Line__c>();
        sirenum__Timesheet_Line__c stsl = new sirenum__Timesheet_Line__c(); 
        stsl.sirenum__Timesheet__c=sts.id;
                stsl.sirenum__Rate__c=22.0;
                stsl.sirenum__Hours__c=1;
                stsl.sirenum__Charge__c = 10;
              //  stsl.IP_PassToTempest__c=true;    
                stsl.IP_RateCodes__c='Taxable Expenses /TX';
                stsl.sirenum__Shift__c=shft.id;
        
         sirenum__Timesheet_Line__c stsl11 = new sirenum__Timesheet_Line__c(); 
        stsl11.sirenum__Timesheet__c=sts.id;
                stsl11.sirenum__Rate__c=22.0;
                stsl11.sirenum__Hours__c=1;
                stsl11.sirenum__Charge__c = 10;
              //  stsl.IP_PassToTempest__c=true;    
                stsl11.IP_RateCodes__c='Taxable Expenses /TX';
                stsl11.sirenum__Shift__c=shft.id;
 
       sirenum__Timesheet_Line__c stsl2 = new sirenum__Timesheet_Line__c(); 
        stsl2.sirenum__Timesheet__c=sts.id;
                stsl2.sirenum__Rate__c=22.0;
                stsl2.sirenum__Hours__c=1;
                stsl2.sirenum__Charge__c = 11;
            //    stsl2.IP_PassToTempest__c=true;    
                stsl2.IP_RateCodes__c='Taxable Expenses /TX';
                stsl2.sirenum__Shift__c=shft.id;
        sirenum__Timesheet_Line__c stsl22 = new sirenum__Timesheet_Line__c(); 
        stsl22.sirenum__Timesheet__c=sts.id;
                stsl22.sirenum__Rate__c=22.0;
                stsl22.sirenum__Hours__c=1;
                stsl22.sirenum__Charge__c = 11;
            //    stsl2.IP_PassToTempest__c=true;    
                stsl22.IP_RateCodes__c='Taxable Expenses /TX';
                stsl22.sirenum__Shift__c=shft.id;
    
        
        
          sirenum__Timesheet_Line__c stsl7 = new sirenum__Timesheet_Line__c(); 
                 stsl7.sirenum__Timesheet__c=sts.id;
                stsl7.sirenum__Rate__c=22.0;
                stsl7.sirenum__Hours__c=1;
                stsl7.sirenum__Charge__c = 23;  
                stsl7.IP_RateCodes__c='Taxable Expenses /TX';
                stsl7.sirenum__Shift__c=shft.id;
          sirenum__Timesheet_Line__c stsl8 = new sirenum__Timesheet_Line__c(); 
                 stsl8.sirenum__Timesheet__c=sts.id;
                stsl8.sirenum__Rate__c=22.0;
                stsl8.sirenum__Hours__c=1;
                stsl8.sirenum__Charge__c = 25;  
                stsl8.IP_RateCodes__c='Taxable Expenses /TX';
                stsl8.sirenum__Shift__c=shft.id;
          sirenum__Timesheet_Line__c stsl9 = new sirenum__Timesheet_Line__c(); 
                 stsl9.sirenum__Timesheet__c=sts.id;
                stsl9.sirenum__Rate__c=22.0;
                stsl9.sirenum__Hours__c=1;
                stsl9.sirenum__Charge__c = 55;  
                stsl9.IP_RateCodes__c='Taxable Expenses /TX';
                stsl9.sirenum__Shift__c=shft.id;
          sirenum__Timesheet_Line__c stsl10  = new sirenum__Timesheet_Line__c(); 
                 stsl10.sirenum__Timesheet__c=sts.id;
                stsl10.sirenum__Rate__c=22.0;
                stsl10.sirenum__Hours__c=1;
                stsl10.sirenum__Charge__c = 45;  
                stsl10.IP_RateCodes__c='Taxable Expenses /TX';
                stsl10.sirenum__Shift__c=shft.id;
 
        timelist.add(stsl);
      
   
        timelist.add(stsl2);
        //timelist.add(stsl22);
  
        timelist.add(stsl7);
        timelist.add(stsl8);
        timelist.add(stsl9);
        timelist.add(stsl10);
        Insert timelist;
        
         Test.startTest();
     insert new CreatedDateSPliting__c(name = 'SplittingData', SplittingCreatedDate__c = Date.newInstance(2019, 01, 01));
    
        Database.executeBatch(new TimesheetSplittingBatch(),1);
            
        Test.stopTest();
               
    }
    
          public static testmethod void method4()
    {
        Account client = TestDataFactory.createCandidateAccount(1)[0]; 
        Insert client;
        
        Account act = TestDataFactory.createAccounts(1)[0];
        act.IP_InvoicingMethod__c = 'Standard';
        insert act;
         //Contact cont = TestDataFactory.createCandidate(client.id, 1)[0];
        //Insert cont;
         RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
     Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=act.id, IP_ContactType__c = 'Invoice Contact');
      
        insert maincon;
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
            insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
                            insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

         Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
        candidate.IP_BorrowedTemp__c = 'Yes';
    Insert candidate;
    
        
        
        sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(client.Id, candidate.Id, 1)[0];
        Insert pac;
        
        sirenum__Rota__c sector = TestDataFactory.createSector(1)[0]; 
        Insert sector;
        
        sirenum__Job_Type__c jobType =TestDataFactory.createJobType(sector.id, 1)[0];
        Insert jobType;
        
        sirenum__Team__c jrole = TestDataFactory.createJobRole(pac.Id, jobType.Id, 1)[0]; 
        Insert jrole;
        
        Profile p = [SELECT Id FROM Profile where name='System Administrator'];
      User usr = TestDataFactory.createUsers(p.Id,1)[0];
        usr.username = 'nbjudui453@mko.com';
        usr.IP_TempestDepartment__c = '1062';
        usr.IP_TempestID__c = '65742';
        usr.IP_PassToTempest__c = TRUE;
        insert usr; 
        system.debug('$$UserID$$'+usr);
          IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0]; 
        tpz.IP_SalesLedgerNumber__c = '315621';
        insert tpz;    
        
        sirenum__Site__c ssite = TestDataFactory.createSites(act.id, tpz.id,1)[0];
        ssite.IP_PassClientAddressToTempest__c = false;
        ssite.sirenum__Postal_Code__c = '1234';
        ssite.sirenum__City__c= 'ABC';
        ssite.IP_PublicSector__c = 'No';
        ssite.sirenum__Street_Address__c = 'test add';
        ssite.IP_MainContact__c = maincon.id;
        ssite.IP_InvoiceContact__c = maincon.id;
        ssite.IP_PassClientToTempest__c  = false;  
        ssite.IP_ClientAddressLastPassedToTempest__c = System.today();  
        ssite.IP_ClientLastPassedToTempest__c = System.today();  
        ssite.ownerid = usr.id;
        insert ssite;
        
        System.debug('check site'+ssite);
        
        sirenum__Placement__c splace = TestDataFactory.createSPlacement1(candidate.Id, pac.Id, jrole.Id,usr.Id, 1)[0]; 
        splace.sirenum__site__C = ssite.id;
       // splace.IP_PayMethod__c =payprofile.id;
        splace.IP_PasstoTempest__c = TRUE;
        
        Insert splace;
        
              System.debug('check placement'+splace);
        
        sirenum__Shift__c shft = TestDataFactory.createShift(splace.id, ssite.id,1)[0];
        shft.sirenum__Contact__c = candidate.id;
        insert shft;  
        
        
         sirenum__Timesheet__c sts = TestDataFactory.createTimeSheet(client.id, candidate.Id,1)[0]; 
        sts.IP_DuplicateCheckPassOK__c = TRUE;
     //  sts.IP_EmergencyPull__c=true;
        sts.IP_FlaggingCheck__c = true;
        sts.sirenum__Week_Ending__c = Date.newInstance(2018, 02, 01);
        sts.sirenum__Site__c = ssite.id;
        Insert sts;
      //
      List<sirenum__Timesheet_Line__c> timelist = new List<sirenum__Timesheet_Line__c>();
        sirenum__Timesheet_Line__c stsl = new sirenum__Timesheet_Line__c(); 
        stsl.sirenum__Timesheet__c=sts.id;
                stsl.sirenum__Rate__c=22.0;
                stsl.sirenum__Hours__c=1;
                stsl.sirenum__Charge__c = 10;
              //  stsl.IP_PassToTempest__c=true;    
                stsl.IP_RateCodes__c='Taxable Expenses /TX';
                stsl.sirenum__Shift__c=shft.id;
        
         sirenum__Timesheet_Line__c stsl11 = new sirenum__Timesheet_Line__c(); 
        stsl11.sirenum__Timesheet__c=sts.id;
                stsl11.sirenum__Rate__c=22.0;
                stsl11.sirenum__Hours__c=1;
                stsl11.sirenum__Charge__c = 10;
              //  stsl.IP_PassToTempest__c=true;    
                stsl11.IP_RateCodes__c='Taxable Expenses /TX';
                stsl11.sirenum__Shift__c=shft.id;
 
       sirenum__Timesheet_Line__c stsl2 = new sirenum__Timesheet_Line__c(); 
        stsl2.sirenum__Timesheet__c=sts.id;
                stsl2.sirenum__Rate__c=22.0;
                stsl2.sirenum__Hours__c=1;
                stsl2.sirenum__Charge__c = 11;
            //    stsl2.IP_PassToTempest__c=true;    
                stsl2.IP_RateCodes__c='Taxable Expenses /TX';
                stsl2.sirenum__Shift__c=shft.id;
        sirenum__Timesheet_Line__c stsl22 = new sirenum__Timesheet_Line__c(); 
        stsl22.sirenum__Timesheet__c=sts.id;
                stsl22.sirenum__Rate__c=22.0;
                stsl22.sirenum__Hours__c=1;
                stsl22.sirenum__Charge__c = 11;
            //    stsl2.IP_PassToTempest__c=true;    
                stsl22.IP_RateCodes__c='Taxable Expenses /TX';
                stsl22.sirenum__Shift__c=shft.id;
    
        
        
          sirenum__Timesheet_Line__c stsl7 = new sirenum__Timesheet_Line__c(); 
                 stsl7.sirenum__Timesheet__c=sts.id;
                stsl7.sirenum__Rate__c=22.0;
                stsl7.sirenum__Hours__c=1;
                stsl7.sirenum__Charge__c = 23;  
                stsl7.IP_RateCodes__c='Taxable Expenses /TX';
                stsl7.sirenum__Shift__c=shft.id;
          sirenum__Timesheet_Line__c stsl8 = new sirenum__Timesheet_Line__c(); 
                 stsl8.sirenum__Timesheet__c=sts.id;
                stsl8.sirenum__Rate__c=22.0;
                stsl8.sirenum__Hours__c=1;
                stsl8.sirenum__Charge__c = 25;  
                stsl8.IP_RateCodes__c='Taxable Expenses /TX';
                stsl8.sirenum__Shift__c=shft.id;
          sirenum__Timesheet_Line__c stsl9 = new sirenum__Timesheet_Line__c(); 
                 stsl9.sirenum__Timesheet__c=sts.id;
                stsl9.sirenum__Rate__c=22.0;
                stsl9.sirenum__Hours__c=1;
                stsl9.sirenum__Charge__c = 55;  
                stsl9.IP_RateCodes__c='Taxable Expenses /TX';
                stsl9.sirenum__Shift__c=shft.id;
          sirenum__Timesheet_Line__c stsl10  = new sirenum__Timesheet_Line__c(); 
                 stsl10.sirenum__Timesheet__c=sts.id;
                stsl10.sirenum__Rate__c=22.0;
                stsl10.sirenum__Hours__c=1;
                stsl10.sirenum__Charge__c = 45;  
                stsl10.IP_RateCodes__c='Taxable Expenses /TX';
                stsl10.sirenum__Shift__c=shft.id;
        
         sirenum__Timesheet_Line__c stsl101  = new sirenum__Timesheet_Line__c(); 
                 stsl101.sirenum__Timesheet__c=sts.id;
                stsl101.sirenum__Rate__c=22.0;
                stsl101.sirenum__Hours__c=1;
                stsl101.sirenum__Charge__c = 46;  
                stsl101.IP_RateCodes__c='Taxable Expenses /TX';
                stsl101.sirenum__Shift__c=shft.id;
         sirenum__Timesheet_Line__c stsl12   = new sirenum__Timesheet_Line__c(); 
                 stsl12.sirenum__Timesheet__c=sts.id;
                stsl12.sirenum__Rate__c=22.0;
                stsl12.sirenum__Hours__c=1;
                stsl12.sirenum__Charge__c = 47;  
                stsl12.IP_RateCodes__c='Taxable Expenses /TX';
                stsl12.sirenum__Shift__c=shft.id;
         sirenum__Timesheet_Line__c stsl13   = new sirenum__Timesheet_Line__c(); 
                 stsl13.sirenum__Timesheet__c=sts.id;
                stsl13.sirenum__Rate__c=22.0;
                stsl13.sirenum__Hours__c=1;
                stsl13.sirenum__Charge__c = 48;  
                stsl13.IP_RateCodes__c='Taxable Expenses /TX';
                stsl13.sirenum__Shift__c=shft.id;
         sirenum__Timesheet_Line__c stsl14   = new sirenum__Timesheet_Line__c(); 
                 stsl14.sirenum__Timesheet__c=sts.id;
                stsl14.sirenum__Rate__c=22.0;
                stsl14.sirenum__Hours__c=1;
                stsl14.sirenum__Charge__c = 49;  
                stsl14.IP_RateCodes__c='Taxable Expenses /TX';
                stsl14.sirenum__Shift__c=shft.id;
         sirenum__Timesheet_Line__c stsl15   = new sirenum__Timesheet_Line__c(); 
                 stsl15.sirenum__Timesheet__c=sts.id;
                stsl15.sirenum__Rate__c=22.0;
                stsl15.sirenum__Hours__c=1;
                stsl15.sirenum__Charge__c = 50;  
                stsl15.IP_RateCodes__c='Taxable Expenses /TX';
                stsl15.sirenum__Shift__c=shft.id;
 
        timelist.add(stsl);
      
   
        timelist.add(stsl2);
        //timelist.add(stsl22);
  
        timelist.add(stsl7);
        timelist.add(stsl8);
        timelist.add(stsl9);
        timelist.add(stsl10);
         timelist.add(stsl101);
         timelist.add(stsl12);
         timelist.add(stsl13);
         timelist.add(stsl14);
         timelist.add(stsl15);
        Insert timelist;
        
         Test.startTest();
     insert new CreatedDateSPliting__c(name = 'SplittingData', SplittingCreatedDate__c = Date.newInstance(2019, 01, 01));
    
        Database.executeBatch(new TimesheetSplittingBatch(),1);
            
        Test.stopTest();
               
    }
     @istest static void testScheduleplitting(){
        
        Test.StartTest();
     insert new CreatedDateSPliting__c(name = 'SplittingData', SplittingCreatedDate__c = Date.newInstance(2019, 01, 01));
        
        Schedule_TimesheetSplitting sh1 = new Schedule_TimesheetSplitting();
        String sch = '0 30 * * * ?';
        system.schedule('Test Schedule_TimesheetSplitting', sch, sh1);
        Test.stopTest();
    }
}