@IsTest
public class CaseTriggerHandlerTest {

    @TestSetup
    static void setupData() {
       
        Opportunity opp1 = new Opportunity(Name = 'Test Opportunity 1', StageName = 'Prospecting', CloseDate = Date.today());
        Opportunity opp2 = new Opportunity(Name = 'Test Opportunity 2', StageName = 'Prospecting', CloseDate = Date.today());
        insert new List<Opportunity>{ opp1, opp2 };

        
        Case case1 = new Case(OpportunityName__c = opp1.Id); 
        Case case2 = new Case(OpportunityName__c = opp1.Id); 
        Case case3 = new Case(OpportunityName__c = opp2.Id);
        insert new List<Case>{ case1, case2, case3 };
    }

    @IsTest
    static void testUpdateTrackedTimeForOpportunities() {
       
        List<Case> cases = [SELECT Id, OpportunityName__c, OrcaCaseTimer__Total_Time_Spent_No__c FROM Case];
        Test.startTest();
        CaseTriggerHandler.updateTrackedTimeForOpportunities(cases);
        Test.stopTest();
      
    }
}