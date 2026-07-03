/*
* Class Name: TEST_AWRUpdateSPlacement.
* Description: Test Class for AWRUpdateSPlacementScheduled and AWRUpdateSPlacement
* Author : Amit Kohli - Espire.
* Date : 26th Sep 2017
*/

@isTest
private class TEST_AWRUpdateSPlacement {
    
    /*
* Method Name: dataSetup.
* Description: Data Setup to test AWRUpdateSPlacement.
* Parameters : None.
* Return Type: Void
* Author : Amit Kohli - Espire.
* Date : 26th Sep 2017
*/
    @testsetup
    static void dataSetup()
    {   
        Account account = TestDataFactory.createCandidateAccount(1)[0];
        account.IP_PublicSectorSupplierOrClient__c = true;
        Insert account;
        
        Contact candidate = TestDataFactory.createCandidate(account.id, 1)[0];
        Insert candidate;
        
        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0]; 
        Insert tpz;
        
        sirenum__Site__c sites = TestDataFactory.createSites(account.id, tpz.id, 1)[0];
        sites.sirenum__Operating_Company__c = account.id;
        Insert sites;
        
        Profile p = [SELECT Id FROM Profile where name='System Administrator'];
        User usr = TestDataFactory.createUsers(p.Id,1)[0];
        insert usr; 
        
        sirenum__Rota__c sector = TestDataFactory.createSector(1)[0];
        insert sector;
        
        sirenum__Job_Type__c jobType = TestDataFactory.createJobType(sector.Id, 1)[0];
        insert jobType;
        
        sirenum__ProActiveContract__c contract = TestDataFactory.sirenumProActiveContract(account.Id, candidate.Id, 1)[0]; 
        insert contract;      
        String awrGroup = 'Group 1';
        sirenum__Team__c jobRole = TestDataFactory.createJobRole(contract.Id, jobType.Id, 1)[0]; 
        jobRole.sirenum__AWR_Group__c = awrGroup;
        insert jobRole;
        
        sirenum__Placement__c plc = TestDataFactory.createSPlacement(candidate.Id, contract.ID, jobRole.Id, usr.Id, 1)[0]; 
        plc.sirenum__Contact__c =candidate.id;
        plc.sirenum__Site__c= sites.id;
        plc.IP_Consultant1LookupSplitShare__c = null;
        plc.IP_PassToTempest__c=true;
        plc.IP_PurchaseOrderNumber__c=null;
        plc.sirenum__End_Date__c=null;
        plc.OPWIPS__c='Y';
        plc.IP_LastPassedToTempest__c=null;
        insert plc;
        
        //sirenum__AWR__c awr = TestDataFactory.createAWR(candidate.Id,account.Id,1)[0]; 
        sirenum__AWR__c awr = new sirenum__AWR__c(
            sirenum__Contact__c =candidate.Id,
            sirenum__Client__c = account.Id,
            sirenum__Valid_From__c = system.today()+2,
            sirenum__Valid_Until__c = system.today()+2,
            sirenum__AWR_Group__c = awrGroup                
        );    
        insert awr;
    }
    
    
    /*
* Method Name: testAWRUpdateSPlacementScheduled.
* Description: to execute the scheduled class and Batch class.
* Parameters : None.
* Return Type: Void
* Author : Amit Kohli - Espire.
* Date : 26th Sep 2017
*/    
    static testMethod void testAWRUpdateSPlacementScheduled(){
        Test.StartTest();
        AWRUpdateSPlacementScheduled sh1 = new AWRUpdateSPlacementScheduled();
        String sch = '0 0 23 * * ?';
        system.schedule('Test Territory Check', sch, sh1);
        Test.stopTest();
    }
}