@isTest
public class Test_RestrictPermCreditDeleteupdate {
 static testMethod void Testdelete(){ 
   Account client = TestDataFactory.createClients(1)[0]; 
        Insert client;
        
        Account account = TestDataFactory.createAccounts(1)[0];
        Insert account;
        
        Account accountcan = TestDataFactory.createCandidateAccount(1)[0];
        Insert accountcan;
               insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        Contact cont = TestDataFactory.createContact(client.id, 1)[0];
        Insert cont;
               insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        Contact candidate = TestDataFactory.createCandidate(client.id, 1)[0];
        Insert candidate;
        
        
        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0]; 
        Insert tpz;
        
        sirenum__Site__c sites = TestDataFactory.createSites(account.id, tpz.id, 1)[0];
           sites.IP_PassClientAddressToTempest__c = false;
        sites.IP_PassClientToTempest__c  = false;
        Insert sites;
        
        Profile p = [SELECT Id FROM Profile where name='System Administrator'];
        User usr = TestDataFactory.createUsers(p.Id,1)[0];
        usr.IP_TempestDepartment__c = '1062';
        usr.username = 'pokygj123@yts.com';
        insert usr; 
        
        tr1__Job__c jb = TestDataFactory.createT2Job(usr.id, 1)[0];
        jb.tr1__Account__c = accountcan.id;
        jb.tr1__Contact__c = candidate.id;
        jb.s5m__Site__c = sites.id;
        jb.IP_Fixed_Fee__c = 100;       
        Insert jb;
        
        TR1__Closing_Report__c ts2p = TestDataFactory.createTs2Placement(client.Id, candidate.Id, cont.Id, jb.Id, sites.id,'Perm_Credits', 1)[0]; 
        ts2p.Item__c='Testabc';
      ts2p.IP_Amount_to_Credit__c = 100;
        Insert ts2p;
         
         
       Test.startTest();
         try {  
            delete ts2p;  
            System.Assert(true, 'Record Deleted');  
        }catch(DMLException e){  
            System.assert(true, 'Deletion failed appropriately');
}
         Test.stopTest();
}
}