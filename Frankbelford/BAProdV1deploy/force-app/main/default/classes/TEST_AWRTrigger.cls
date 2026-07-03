/*
* Class Name: TEST_AWRTrigger.
* Description: Test Class to test AWRTrigger
* Author : Amit Kohli - Espire.
* Date : 27th Sep 2017
*/

@isTest
private class TEST_AWRTrigger {
    
    /*
* Method Name: testAWRUpdateSPlacementScheduled.
* Description: to execute the scheduled class and Batch class.
* Parameters : None.
* Return Type: Void
* Author : Amit Kohli - Espire.
* Date : 27th Sep 2017
*/   
    static testMethod void testAWRValidUntilField(){   
        Account account = TestDataFactory.createCandidateAccount(1)[0];
        Insert account;
        
        Contact candidate = TestDataFactory.createCandidate(account.id, 1)[0];
        Insert candidate;
        
        sirenum__Rota__c sector = TestDataFactory.createSector(1)[0];
        insert sector;
        
        sirenum__Job_Type__c jobType = TestDataFactory.createJobType(sector.Id, 1)[0];
        insert jobType;
        
        sirenum__Payroll_Cycle__c payCycle = new sirenum__Payroll_Cycle__c(Name = 'Saturday to Friday',
                                                                           sirenum__CyclePeriodUnits__c = 'Weeks',
                                                                           sirenum__periodLength__c = 2,
                                                                           sirenum__StartingDate__c = (System.today()-200)
                                                                          );
        insert payCycle;
        sirenum__ProActiveContract__c contract = TestDataFactory.sirenumProActiveContract(account.Id, candidate.Id, 1)[0]; 
        contract.sirenum__PayrollCycle__c = payCycle.id;
        insert contract;  
        
        sirenum__AWR__c awr = new sirenum__AWR__c(
            sirenum__Contact__c =candidate.Id,
            sirenum__Client__c = account.Id,
            sirenum__Valid_From__c = system.today(),
            sirenum__AWR_Group__c = 'abc'                
        );    
        
        insert awr;
        
        Test.StartTest();
        update awr;
        Test.stopTest();
    }
    
    static testmethod void testAWRValidUntilField1(){
        
        Account acc1 = TestDataFactory.createAccounts(1)[0];
        Insert acc1;
        
        Contact con = TestDataFactory.createContact(acc1.id, 1)[0]; 
        insert con;
        
        sirenum__Rota__c sector = TestDataFactory.createSector(1)[0];
        insert sector;
        
        sirenum__Job_Type__c jobType = TestDataFactory.createJobType(sector.Id, 1)[0];
        insert jobType;
        
        sirenum__Payroll_Cycle__c payCycle1 = new sirenum__Payroll_Cycle__c(Name = 'Sunday to Saturday',
                                                                            sirenum__CyclePeriodUnits__c = 'Weeks',
                                                                            sirenum__periodLength__c = 2,
                                                                            sirenum__StartingDate__c = (System.today()-200)
                                                                           );
        insert payCycle1;
        
        sirenum__ProActiveContract__c contract1 = TestDataFactory.sirenumProActiveContract(acc1.Id, con.Id, 1)[0]; 
        contract1.sirenum__PayrollCycle__c = payCycle1.id;
        insert contract1; 
        
        sirenum__AWR__c awr2 = new sirenum__AWR__c(
            sirenum__Contact__c =con.Id,
            sirenum__Client__c = acc1.Id,
            sirenum__Valid_From__c = system.today()-1,
            sirenum__AWR_Group__c = 'abc1'                
        );    
        
        insert awr2;
        
        Test.StartTest();
        update awr2;
        Test.stopTest();
    }
    
    static testmethod void testAWRValidUntilField2(){
        
        Account acc = TestDataFactory.createAccounts(1)[0];
        Insert acc;
        
        Contact c = TestDataFactory.createContact(acc.id, 1)[0]; 
        insert c;
        
        sirenum__Rota__c sector = TestDataFactory.createSector(1)[0];
        insert sector;
        
        sirenum__Job_Type__c jobType = TestDataFactory.createJobType(sector.Id, 1)[0];
        insert jobType;
        
        sirenum__Payroll_Cycle__c payCycle2 = new sirenum__Payroll_Cycle__c(Name = 'Monday to Sunday',
                                                                            sirenum__CyclePeriodUnits__c = 'Weeks',
                                                                            sirenum__periodLength__c = 2,
                                                                            sirenum__StartingDate__c = (System.today()-200)
                                                                           );
        insert payCycle2;
        
        
        sirenum__ProActiveContract__c contract2 = TestDataFactory.sirenumProActiveContract(acc.Id, c.Id, 1)[0]; 
        contract2.sirenum__PayrollCycle__c = payCycle2.id;
        insert contract2; 
        
        sirenum__AWR__c awr3 = new sirenum__AWR__c(
            sirenum__Contact__c =c.Id,
            sirenum__Client__c = acc.Id,
            sirenum__Valid_From__c = system.today()-1,
            sirenum__AWR_Group__c = 'abc1'                
        );    
        
        insert awr3;
        
        Test.StartTest();
        update awr3;
        Test.stopTest();
    }
}