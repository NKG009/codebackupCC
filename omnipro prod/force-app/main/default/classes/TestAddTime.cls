@isTest
public class TestAddTime {
    @isTest static void TestAddTimeVoid(){
        Case c = new Case(Origin = 'Web', Subject = 'Test');
        insert c;
        Case ca = [SELECT Id,CaseNumber From Case WHERE Subject = 'Test' LIMIT 1];
        LWCCaseTimer__Session_Time__c lwc = new LWCCaseTimer__Session_Time__c(LWCCaseTimer__Duration__c = 60,
                                                                             Name='Vanguard time test', LWCCaseTimer__Case__c =ca.Id);
        Test.startTest();
        insert lwc;
        Test.stopTest();
    }
	
    
}