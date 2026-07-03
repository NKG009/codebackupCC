@istest
private class Test_PlacementBatch{

    @isTest
static void testexecute1() 
    {   
      String query = 'Select id from ts2__Placement__c  limit 10';
         String GUID = 'ABCD';
        String Field1 = 'IP_PassToTempest__c';
        String Field2 = 'IP_LastPassedToTempest__c';  
       
        Account client = TestDataFactory.createClients(1)[0]; 
        Insert client;
        
        Account account = TestDataFactory.createAccounts(1)[0];
        Insert account;
        
        //Inserting Payroll records
        insert new Payroll_Swtich__c(Name='Stoppayroll',Batch_check__c=false);
        
        Account accountcan = TestDataFactory.createCandidateAccount(1)[0];
        Insert accountcan;
       insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true); 
        Contact cont = TestDataFactory.createContact(client.id, 1)[0];
        cont.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Insert cont;
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
        candidate.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Insert candidate;
        
        
        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0]; 
        Insert tpz;
        
        sirenum__Site__c sites = TestDataFactory.createSites(account.id, tpz.id, 1)[0];
        Insert sites;
        
        Profile p = [SELECT Id FROM Profile where name='System Administrator'];
        User usr = TestDataFactory.createUsers(p.Id,1)[0];
        usr.username = 'bhf5@kou.com';
        insert usr; 
        
        ts2__Job__c jb = TestDataFactory.createT2Job(usr.id, 1)[0];
        Insert jb;
        
        ts2__Placement__c ts2p = TestDataFactory.createTs2Placement(client.Id, candidate.Id, cont.Id, jb.Id, sites.id,'Perm', 1)[0]; 
        Insert ts2p;    

       
        test.startTest(); 
         PlacementBatch b = new PlacementBatch(query,Field1,Field2,GUID);
     
        Database.executeBatch(b,1);
        PlacementEmergencyBatch b1 = new PlacementEmergencyBatch(query,Field1,Field2,GUID);
     
        Database.executeBatch(b1,1);
       
        test.stopTest();
        
       }
    
    
}