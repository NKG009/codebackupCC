@istest
private class Test_ClientBatch{

    @isTest
static void testexecute1() 
    {   
      String query = 'Select id from sirenum__Site__c limit 10';
         String GUID = 'ABCD';
        String Field1 = 'IP_PassClientToTempest__c';
        String Field2 = 'IP_ClientLastPassedToTempest__c';  
        String Field3 = 'IP_EmergencyPullClient__c';
         Account account = TestDataFactory.createCandidateAccount(1)[0]; 
        insert account; 
         //Inserting Payroll records
        insert new Payroll_Swtich__c(Name='Stoppayroll',Batch_check__c=false);
        
        system.debug('all account data in api class----'+account.id);
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        Contact cont = TestDataFactory.createCandidate(account.id, 1)[0];
        insert cont;
        system.debug('all contact data in api class----'+cont.id);
        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0]; 
        insert tpz;
            system.debug('all tpz data in api class----'+tpz);
        sirenum__Site__c sites =  TestDataFactory.createSites(account.Id, tpz.id,1)[0];
        insert sites;
    
       
        test.startTest(); 
         ClientBatch b = new ClientBatch(query,Field1,Field2,GUID);
     
        Database.executeBatch(b,1);
        ClientEmergencyBatch b1 = new ClientEmergencyBatch(query,Field1,Field2,Field3,GUID);
     
        Database.executeBatch(b1,1);
       
        test.stopTest();
        
       }
    
    
}