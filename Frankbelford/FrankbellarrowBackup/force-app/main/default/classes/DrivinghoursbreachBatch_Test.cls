@isTest
public class DrivinghoursbreachBatch_Test {
public static testmethod void updatebreachhours()
{
                insert new IP_Shift_Template__c(name = '1062', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='1234',Branch_Address__c='street1',Email__c='singh.taji26@gmail.com',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');

    Account client = TestDataFactory.createCandidateAccount(1)[0]; 
        Insert client;
        
        Account act = TestDataFactory.createAccounts(1)[0]; 
        insert act;
         //Contact cont = TestDataFactory.createCandidate(client.id, 1)[0];
        //Insert cont;
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
       // candidate.IP_BorrowedTemp__c = 'Yes';
    Insert candidate;
        
         insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
                insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
         id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('LTD').getRecordTypeId();
Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());      

         IP_PayProfile__c payprofile = new IP_PayProfile__c();
         payprofile.RecordTypeId = payRTId;
          
       payprofile.IP_Candidate__c = candidate.id;
         payprofile.IP_CompanyName__c='sfdc';
         payprofile.IP_Status__c = 'Active'; 
         payprofile.IP_CompanyRegNo__c  = 'ad123456';
         payprofile.IP_VATNumber__c     = '123456789';
         payprofile.IP_PayrollID__c  = 'testpaynew';
         payprofile.IP_VATRegistered__c=true;
         payprofile.IP_OkToSupply__c=1;
         payprofile.IP_BusinessAddressLine1__c='test address 1';
         payprofile.IP_BusinessAddressLine2__c='test address 2';
         payprofile.IP_BusinessAddressTown__c='town city';
         payprofile.IP_BusinessAddressPostcode__c='12345678';
         payprofile.IP_PayFrequency__c='Weekly';
         payprofile.IP_PaymentType__c='BACS';
         payprofile.IP_PassToTempest__c=true;
        payprofile.IP_BankAccountName__c = 'Bank 1';
        payprofile.IP_AccountNumber__c = '89786756';
        payprofile.IP_SortCode__c = '998866';
         
         insert payprofile; 
   
        sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(client.Id, candidate.Id, 1)[0];
        Insert pac;
        
        sirenum__Rota__c sector = TestDataFactory.createSector(1)[0]; 
        Insert sector;
        
        sirenum__Job_Type__c jobType =TestDataFactory.createJobType(sector.id, 1)[0];
    jobType.Driving_Applicable__c = TRUE;
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
        insert tpz;    
        
        sirenum__Site__c ssite = TestDataFactory.createSites(act.id, tpz.id,1)[0];
        ssite.IP_PassClientAddressToTempest__c = false;
        ssite.IP_PassClientToTempest__c  = false;
        ssite.ownerid = usr.id;
        insert ssite;
        
        sirenum__Placement__c splace = TestDataFactory.createSPlacement1(candidate.Id, pac.Id, jrole.Id,usr.Id, 1)[0]; 
        splace.sirenum__site__C = ssite.id;
        splace.IP_PayMethod__c =payprofile.id;
        splace.IP_PasstoTempest__c = false;
        
        Insert splace;

        sirenum__Shift__c shft = TestDataFactory.createShift(splace.id, ssite.id,1)[0];
        shft.sirenum__Contact__c = candidate.id;
        insert shft;  

         sirenum__Timesheet__c sts = TestDataFactory.createTimeSheet(client.id, candidate.Id,1)[0]; 
        sts.IP_DuplicateCheckPassOK__c = TRUE;
       sts.IP_EmergencyPull__c=true;
    sts.sirenum__Team__c = jrole.id;
        sts.sirenum__Week_Ending__c = Date.newInstance(2018, 02, 01);
        
        Insert sts;
      //
        sirenum__Timesheet_Line__c stsl = new sirenum__Timesheet_Line__c(); 
        stsl.sirenum__Timesheet__c=sts.id;
                stsl.sirenum__Rate__c=22.0;
                stsl.sirenum__Hours__c=70;
                stsl.IP_PassToTempest__c=true;    
                stsl.IP_RateCodes__c='Standard Hours /P1';
                stsl.sirenum__Shift__c=shft.id;
        stsl.IP_POErrorLogField__c = 'TestValue';       
        Insert stsl;
    Test.startTest();
     ScheduleDrivinghoursbreachBatch sh1 = new ScheduleDrivinghoursbreachBatch();
        String sch = '0 30 * * * ?';
        system.schedule('Test manualbatch1', sch, sh1);
   
    Test.stopTest();
}    
    
}