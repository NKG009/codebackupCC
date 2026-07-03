@istest
private class Test_ClientAddressBatch{
    
    @isTest
    static void testexecute1() 
    {   
        String query = 'Select id from sirenum__Site__c limit 10';
        String GUID = 'ABCD';
        String Field1 = 'IP_PassClientAddressToTempest__c';
        String Field2 = 'IP_ClientAddressLastPassedToTempest__c';  
         String Field3 = 'IP_EmergencyPullClientAddress__c';
        Account account = TestDataFactory.createCandidateAccount(1)[0]; 
        insert account; 
        system.debug('all account data in api class----'+account.id);
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        //Inserting Payroll records
        insert new Payroll_Swtich__c(Name='Stoppayroll',Batch_check__c=false);
        Contact cont = TestDataFactory.createCandidate(account.id, 1)[0];
        insert cont;
        system.debug('all contact data in api class----'+cont.id);
        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0]; 
        insert tpz;
        system.debug('all tpz data in api class----'+tpz);
        sirenum__Site__c sites =  TestDataFactory.createSites(account.Id, tpz.id,1)[0];
        insert sites;    
        
        sirenum__Site__c sites1 =  TestDataFactory.createSites(account.Id, tpz.id,2)[1];
        insert sites1;  
       
        system.debug('VALUE OF THE FIELD__________________'+Sites1.Name);
        system.debug('VALUE OF THE FIELD__________________'+sites1.IP_ClientAddressLastPassedToTempest__c);
        
        test.startTest(); 
        ClientAddressBatch b = new ClientAddressBatch(query,Field1,Field2,GUID);
        Database.executeBatch(b); 
        ClientAddressEmergencyBatch b1 = new ClientAddressEmergencyBatch(query,Field1,Field2,Field3,GUID);
        Database.executeBatch(b1);               
        test.stopTest();
        
    }
   
    
    
}