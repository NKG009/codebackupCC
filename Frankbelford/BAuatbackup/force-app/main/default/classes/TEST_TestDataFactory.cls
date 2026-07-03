@isTest
private class TEST_TestDataFactory {
    
    @isTest 
    static void testdatafactory() 
    {
        Account Clnt = TestDataFactory.createClients(1)[0];
        insert Clnt;    
        
        Account account = TestDataFactory.createAccounts(1)[0]; 
        insert account; 
        
        Account acct2tier = TestDataFactory.create2ndTierSupplierAccount(2)[1];
        insert acct2tier;
        
        Account acctCand = TestDataFactory.createCandidateAccount(1)[0]; 
        insert acctCand;
        
        Account acct = TestDataFactory.createAccounts(3)[2]; 
        insert acct;
        
        Contact cont = TestDataFactory.createContact(acct.id,1)[0]; 
        insert cont;
        
        
        Contact cond = TestDataFactory.createCandidate(acct.id, 1)[0];    
        Insert cond;    
        
        Contact candt2ier = TestDataFactory.createCandidate2ndTier(acct2tier.id,1)[0]; 
        Insert candt2ier;    
        
        IP_TopazGlobalClientInformation__c tgci = TestDataFactory.createTopaz(1)[0];    
        Insert tgci;    
        
        sirenum__Site__c sites =  TestDataFactory.createSites(acct.id, tgci.id, 1)[0];     
        Insert sites;
        
        Profile p = [SELECT Id FROM Profile where name='System Administrator'];
        User usr =  TestDataFactory.createUsers(p.id, 1)[0]; 
        Insert usr;
        
        //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        //IP_PayProfile__c pp = TestDataFactory.createPayProfilePaye(cond.id, 1)[0]; 
        //Insert pp;
        //Test.stopTest();
        
        
        
        sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(acctCand.id, cont.id,1)[0];
        insert pac;    
        
        sirenum__Rota__c rota = TestDataFactory.createSector(1)[0];
        Insert rota;
        
        sirenum__Job_Type__c job = TestDataFactory.createJobType(rota.id, 1)[0]; 
        Insert job;
        
        sirenum__Team__c tm = TestDataFactory.createJobRole(pac.id, job.id,1)[0];
        Insert tm;
        
        //sirenum__Placement__c splacement = TestDataFactory.createSPlacement(cond.id, pac.id, tm.id, usr.id,1)[0];
       // Insert splacement;
        
        sirenum__Placement__c splacement = TestDataFactory.createSPlacement1(cond.id, pac.id, tm.id, usr.id,1)[0];
        Insert splacement;
        
        sirenum__Shift__c shft = TestDataFactory.createShift(splacement.id, sites.id,1)[0]; 
        insert shft; 
        
        
        sirenum__Timesheet__c sts = TestDataFactory.createTimeSheet(Clnt.id, cond.Id,1)[0]; 
        Insert sts;
        
        sirenum__Timesheet_Line__c stsl = TestDataFactory.createTimeSheetLine(sts.Id,shft.id,1)[0]; 
        Insert stsl;
        
        ts2__Job__c ts2job = TestDataFactory.createT2Job(usr.id,1)[0]; 
        insert ts2job;     
        
        ts2__Placement__c ts2p = TestDataFactory.createTs2Placement(Clnt.Id, cond.Id, cont.Id, ts2job.Id, sites.id,'Perm', 1)[0]; 
        Insert ts2p;
        
        sirenum__AWR__c awr = TestDataFactory.createAWR(cond.id,account.id,1)[0]; 
        insert awr;
        
    }
    
}