@istest
private class Test_AssignmentBatch{

    @isTest
static void testexecute1() 
    {   
      String query = 'Select id from sirenum__Placement__c limit 10';
         String GUID = 'ABCD';
        String Field1 = 'IP_PassToTempest__c';
        String Field2 = 'IP_LastPassedToTempest__c';  
        String Field3 = 'IP_EmergencyPull__c';
 
    Account client = TestDataFactory.createClients(1)[0]; 
        Insert client;
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        //Inserting Payroll records
        insert new Payroll_Swtich__c(Name='Stoppayroll',Batch_check__c=false);
        Contact cont = TestDataFactory.createContact(client.id, 1)[0];
        Insert cont;
        
        Profile p = [SELECT Id FROM Profile where name='System Administrator'];
        User usr = TestDataFactory.createUsers(p.Id,1)[0];
        usr.username = 'TestAssignBatchUser@yahoo.com';
        insert usr; 
        
        Account clientacc = TestDataFactory.createCandidateAccount(1)[0]; 
        Insert clientacc;
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        Contact candidate = TestDataFactory.createCandidate(clientacc.id, 1)[0];
        Insert candidate;
        
        sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(client.Id, candidate.Id, 1)[0];
        Insert pac;
        
        sirenum__Rota__c sector = TestDataFactory.createSector(1)[0]; 
        Insert sector;
        
        sirenum__Job_Type__c jobType =TestDataFactory.createJobType(sector.id, 1)[0];
        Insert jobType;
        
        sirenum__Team__c jrole = TestDataFactory.createJobRole(pac.Id, jobType.Id, 1)[0]; 
        Insert jrole;
        
        IP_TopazGlobalClientInformation__c topaz = TestDataFactory.createTopaz(1)[0];
        insert topaz;
        
        sirenum__Site__c site = TestDataFactory.createSites(client.Id,topaz.id,1)[0];
        insert site;

        sirenum__Placement__c splace = TestDataFactory.createSPlacement1(candidate.Id, pac.Id, jrole.Id,usr.Id, 1)[0];
        splace.sirenum__Site__c = site.id;
        splace.IP_PassToTempest__c = TRUE;
        Insert splace;
       
        test.startTest(); 
         AssignmentBatch b = new AssignmentBatch(query,Field1,Field2,GUID);     
        Database.executeBatch(b,1);
        AssignmentEmergencyBatch b1 = new AssignmentEmergencyBatch(query,Field1,Field2,Field3,GUID);
        Database.executeBatch(b1,1);
        test.stopTest();    
            
       }  
}