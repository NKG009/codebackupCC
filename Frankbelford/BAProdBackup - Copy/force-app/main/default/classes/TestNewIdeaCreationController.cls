/*
* Class Name: TestNewIdeaCreationController
* Description: Test Class for NewIdeaCreationController Class
* Date : 11th June 2019
*/
@istest
private class TestNewIdeaCreationController{
    
    private static final String COMMENT = 'Comment';
    private static final String VOTE = 'Vote';
    
    /*
    * Method Name: dataSetup
    * Description: Data Created for Idea Object
    * Parameters : none
    * Return Type: nothing
    */
    @testSetup static void dataSetup() {
        List<Idea__c> listIdeas = new List<Idea__c>();
        List<Idea_Comments__c> listIdeasComments = new List<Idea_Comments__c>();
        List<Idea_Comments__c> listIdeasvotes = new List<Idea_Comments__c>();
        
        
        for(integer i=0 ;i<=100;i++){
            Idea__c idea1 = new Idea__c();
            idea1.IP_Points__c = 100;
            idea1.IP_Points__c = 100;
            idea1.IP_Headline__c = 'New Idea' +i;
            idea1.IP_Description__c = 'use the bullets button on the toolbar.';
            idea1.IP_Category__c    = 'Business Improvement';
            idea1.Status__c = 'Idea Submitted';
            listIdeas.add(idea1);
        }        
        insert listIdeas;
        
    }
    
    /*
    * Method Name: positivetestMethodIdeas
    * Description: Test Method for NewIdeaCreationController Class
    * Parameters : none
    * Return Type: nothing
    */
    static testMethod void positivetestMethodIdeas(){
        List<Idea__c> ideas = [Select id,Name,CreatedDate,IP_Points__c,IP_TotalPoints__c from Idea__c];
        Test.startTest();
        NewIdeaCreationController newIdea = new NewIdeaCreationController();
        newIdea.Save();
        newIdea.CancelIdea();
        Test.StopTest();
    }
}