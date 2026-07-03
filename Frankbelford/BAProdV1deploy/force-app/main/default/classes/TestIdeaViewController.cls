/*
* Class Name: TestIdeaViewController
* Description: Test Class for IdeaViewController Class
* Date : 11th June 2019
*/
@istest
private class TestIdeaViewController{
    
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
        
        for(integer i=0 ;i<=100;i++){
            Idea_Comments__c ideaComments = new Idea_Comments__c();
            ideaComments.RecordTypeId = Schema.SObjectType.Idea_Comments__c.getRecordTypeInfosByName().get(COMMENT).getRecordTypeId();
            ideaComments.Comment__c = 'Test';
            ideaComments.IP_Idea__c = listIdeas[i].id;
            ideaComments.User__c = UserInfo.getUserId();
            listIdeasComments.add(ideaComments);
        }
        insert listIdeasComments;
        
        for(integer i=0 ;i<=100;i++){
            Idea_Comments__c ideaComments = new Idea_Comments__c();
            ideaComments.RecordTypeId = Schema.SObjectType.Idea_Comments__c.getRecordTypeInfosByName().get(VOTE).getRecordTypeId();
            ideaComments.Comment__c = 'Test';
            ideaComments.IP_Idea__c = listIdeas[i].id;
            ideaComments.User__c = UserInfo.getUserId();
            listIdeasvotes.add(ideaComments);
        }
        insert listIdeasvotes;
        
    }
    
    /*
    * Method Name: positivetestMethodIdeas
    * Description: Test Method for IdeaViewController Class
    * Parameters : none
    * Return Type: nothing
    */
    static testMethod void positivetestMethodIdeas(){
        List<Idea__c> ideas = [Select id,Name,CreatedDate,IP_Points__c,IP_TotalPoints__c from Idea__c];
        Test.startTest();
        IdeaViewController ideasview = new IdeaViewController();
        ideasview.getSortingOptions();
        ideasview.displayComments();
        Test.StopTest();
    }
    
    /*
    * Method Name: positivetestMethodIdeasOldestFirst
    * Description: Test Method for IdeaViewController Class
    * Parameters : none
    * Return Type: nothing
    */
    static testMethod void positivetestMethodIdeasOldestFirst(){
        List<Idea__c> ideas = [Select id,Name,CreatedDate,IP_Points__c,IP_TotalPoints__c from Idea__c];
        Test.startTest();
        PageReference pageRef = Page.IdeaView; // Add your VF page Name here
        pageRef.getParameters().put('id', String.valueOf(ideas[0].Id));
        Test.setCurrentPage(pageRef);
        IdeaViewController ideasview = new IdeaViewController();
        ideasview.ideadIdValue = ideas[0].Id;
        ideasview.body ='Test';
        ideasview.upvotedownvote = 'Downvote';
        ideasview.DOWNVOTE_VALUE = 'Downvote';
        ideasview.selectedSorting = 'Oldest First';
        ideasview.getSortingOptions();
        ideasview.displayComments();
        ideasview.updateIdeaRecord();
        ideasview.inserIdeaComment();
        Test.StopTest();
    }
    
    /*
    * Method Name: positivetestMethodIdeasUpVote
    * Description: Test Method for IdeaViewController Class
    * Parameters : none
    * Return Type: nothing
    */
    static testMethod void positivetestMethodIdeasUpVote(){
        List<Idea__c> ideas = [Select id,Name,CreatedDate,IP_Points__c,IP_TotalPoints__c from Idea__c];
        Test.startTest();
        PageReference pageRef = Page.IdeaView; // Add your VF page Name here
        pageRef.getParameters().put('id', String.valueOf(ideas[0].Id));
        Test.setCurrentPage(pageRef);
        IdeaViewController ideasview = new IdeaViewController();
        ideasview.ideadIdValue = ideas[0].Id;
        ideasview.body ='Test';
        ideasview.upvotedownvote = 'Upvote';
        ideasview.UPVOTE_VALUE = 'Upvote';
        ideasview.selectedSorting = 'Oldest First';
        ideasview.getSortingOptions();
        ideasview.displayComments();
        ideasview.updateIdeaRecord();
        ideasview.inserIdeaComment();
        Test.StopTest();
    }
    
    /*
    * Method Name: testMethodIdeasError
    * Description: Test Method for IdeaViewController Class
    * Parameters : none
    * Return Type: nothing
    */
    static testMethod void testMethodIdeasError(){
        List<Idea__c> ideas = [Select id,Name,CreatedDate,IP_Points__c,IP_TotalPoints__c from Idea__c];
        Test.startTest();
        IdeaViewController ideasview = new IdeaViewController();
       // ideasview.body = 'Test Body';
        ideasview.selectedSorting = 'Oldest First';
        ideasview.getSortingOptions();
        ideasview.displayComments();
        ideasview.inserIdeaComment();
        
        Test.StopTest();
    }
}