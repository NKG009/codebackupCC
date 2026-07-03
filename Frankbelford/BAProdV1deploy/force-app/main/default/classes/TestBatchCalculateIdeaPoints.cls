/*
* Class Name: TestBatchCalculateIdeaPoints
* Description: Test Class for BatchCalculateIdeaPointsAfterSevendays Class and ScheduleBatchCalculateIdeaPoints Class
* Date : 5th June 2019
*/
@istest
private class TestBatchCalculateIdeaPoints{
    
    /*
    * Method Name: dataSetup
    * Description: Data Created for Idea Object
    * Parameters : none
    * Return Type: nothing
    */
    @testSetup static void dataSetup() {
        List<Idea__c> listIdeas = new List<Idea__c>();
        
        Idea__c idea1 = new Idea__c();
        idea1.IP_Points__c = 100;
        idea1.IP_Points__c = 100;
        idea1.IP_Headline__c = 'New Idea';
        idea1.IP_Description__c = 'use the bullets button on the toolbar.';
        idea1.IP_Category__c    = 'Business Improvement';
        idea1.Status__c = 'Idea Submitted';
        listIdeas.add(idea1);
        
        Idea__c idea2 = new Idea__c();
        idea2.IP_Points__c = 100;
        idea2.IP_Points__c = 100;
        idea2.IP_Headline__c = 'New Idea1';
        idea2.IP_Description__c = 'use the bullets button on the toolbar.';
        idea2.IP_Category__c    = 'Business Improvement';
        idea2.Status__c = 'Idea Submitted';
        listIdeas.add(idea2);
        
        insert listIdeas;
    }
    
    /*
    * Method Name: positiveBatchClassTestMethod
    * Description: Test Method for BatchCalculateIdeaPointsAfterSevendays Class
    * Parameters : none
    * Return Type: nothing
    */
    static testMethod void positiveBatchClassTestMethod(){
        List<Idea__c> ideas = [Select id,Name,CreatedDate,IP_Points__c,IP_TotalPoints__c from Idea__c];
        Test.startTest();
        BatchCalculateIdeaPointsAfterSevendays obj = new BatchCalculateIdeaPointsAfterSevendays();
        DataBase.executeBatch(obj);
        Test.StopTest();
    }
    
    /*
    * Method Name: positiveSchedularClassTestMethod
    * Description: Test Method for ScheduleBatchCalculateIdeaPoints Class
    * Parameters : none
    * Return Type: nothing
    */
    static testMethod void positiveSchedularClassTestMethod(){
        List<Idea__c> ideas = [Select id,Name,CreatedDate,IP_Points__c,IP_TotalPoints__c from Idea__c];
        Test.startTest();
        ScheduleBatchCalculateIdeaPoints sh1 = new ScheduleBatchCalculateIdeaPoints();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Calculate Points After 7 Days'+system.now(), sch, sh1);    
        Test.StopTest();
    }

}