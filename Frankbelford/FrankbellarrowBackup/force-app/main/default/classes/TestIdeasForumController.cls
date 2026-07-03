/*
* Class Name: TestIdeasForumController
* Description: Test Class for IdeasForumController Class
* Date : 11th June 2019
*/
@istest
private class TestIdeasForumController{
    
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
    * Method Name: positivetestMethodIdeasPopular
    * Description: Test Method for IdeasForumController Class
    * Parameters : none
    * Return Type: nothing
    */
    static testMethod void positivetestMethodIdeasPopular(){
        List<Idea__c> ideas = [Select id,Name,CreatedDate,IP_Points__c,IP_TotalPoints__c from Idea__c];
        Test.startTest();
        IdeasForumController ideasForum = new IdeasForumController();
        ideasForum.ideadIdValue = ideas[0].id;
        ideasForum.upvotedownvote = 'Upvoted';
        ideasForum.getSortingOptions();
        ideasForum.getStatusOptions();
        ideasForum.ideasBasedOnStatus();
        ideasForum.displayIdeasBySelection();
        ideasForum.updateIdeaRecord();
        Test.StopTest();
    }
    
    /*
    * Method Name: positivetestMethodIdeasRecent
    * Description: Test Method for IdeasForumController Class
    * Parameters : none
    * Return Type: nothing
    */
    static testMethod void positivetestMethodIdeasRecent(){
        List<Idea__c> ideas = [Select id,Name,CreatedDate,IP_Points__c,IP_TotalPoints__c from Idea__c];
        Test.startTest();
        IdeasForumController ideasForum = new IdeasForumController();
        ideasForum.selectedSorting = 'Recent';
        ideasForum.ideadIdValue = ideas[0].id;
        ideasForum.upvotedownvote = 'Upvoted';
        ideasForum.getSortingOptions();
        ideasForum.getStatusOptions();
        ideasForum.ideasBasedOnStatus();
        ideasForum.displayIdeasBySelection();
        Test.StopTest();
    }
    
    /*
    * Method Name: positivetestMethodIdeastrending
    * Description: Test Method for IdeasForumController Class
    * Parameters : none
    * Return Type: nothing
    */
    static testMethod void positivetestMethodIdeastrending(){
        List<Idea__c> ideas = [Select id,Name,CreatedDate,IP_Points__c,IP_TotalPoints__c from Idea__c];
        Test.startTest();
        IdeasForumController ideasForum = new IdeasForumController();
        ideasForum.selectedSorting = 'Trending';
        ideasForum.ideadIdValue = ideas[0].id;
        ideasForum.upvotedownvote = 'Upvoted';
        ideasForum.getSortingOptions();
        ideasForum.getStatusOptions();
        ideasForum.ideasBasedOnStatus();
        ideasForum.displayIdeasBySelection();
        Test.StopTest();
    }
    
    
    /*
    * Method Name: positivetestMethodIdeasPopularStatus
    * Description: Test Method for IdeasForumController Class
    * Parameters : none
    * Return Type: nothing
    */
    static testMethod void positivetestMethodIdeasPopularStatus(){
        List<Idea__c> ideas = [Select id,Name,CreatedDate,IP_Points__c,IP_TotalPoints__c from Idea__c];
        Test.startTest();
        IdeasForumController ideasForum = new IdeasForumController();
        ideasForum.ideadIdValue = ideas[0].id;
        ideasForum.selectedStatus = 'Idea Submitted';
        ideasForum.upvotedownvote = 'Upvoted';
        ideasForum.getSortingOptions();
        ideasForum.getStatusOptions();
        ideasForum.ideasBasedOnStatus();
        ideasForum.displayIdeasBySelection();
        ideasForum.updateIdeaRecord();
        Test.StopTest();
    }
    
    /*
    * Method Name: positivetestMethodIdeasRecentStatus
    * Description: Test Method for IdeasForumController Class
    * Parameters : none
    * Return Type: nothing
    */
    static testMethod void positivetestMethodIdeasRecentStatus(){
        List<Idea__c> ideas = [Select id,Name,CreatedDate,IP_Points__c,IP_TotalPoints__c from Idea__c];
        Test.startTest();
        IdeasForumController ideasForum = new IdeasForumController();
        ideasForum.selectedStatus = 'Idea Submitted';
        ideasForum.selectedSorting = 'Recent';
        ideasForum.ideadIdValue = ideas[0].id;
        ideasForum.upvotedownvote = 'Upvoted';
        ideasForum.getSortingOptions();
        ideasForum.getStatusOptions();
        ideasForum.ideasBasedOnStatus();
        ideasForum.displayIdeasBySelection();
        Test.StopTest();
    }
    
    /*
    * Method Name: positivetestMethodIdeastrendingStatus
    * Description: Test Method for IdeasForumController Class
    * Parameters : none
    * Return Type: nothing
    */
    static testMethod void positivetestMethodIdeastrendingStatus(){
        List<Idea__c> ideas = [Select id,Name,CreatedDate,IP_Points__c,IP_TotalPoints__c from Idea__c];
        Test.startTest();
        IdeasForumController ideasForum = new IdeasForumController();
        ideasForum.selectedStatus = 'Idea Submitted';
        ideasForum.selectedSorting = 'Trending';
        ideasForum.ideadIdValue = ideas[0].id;
        ideasForum.upvotedownvote = 'Upvoted';
        ideasForum.getSortingOptions();
        ideasForum.getStatusOptions();
        ideasForum.ideasBasedOnStatus();
        ideasForum.displayIdeasBySelection();
        Test.StopTest();
    }
    
    /*
    * Method Name: positivetestMethodIdeasUpVote
    * Description: Test Method for IdeasForumController Class
    * Parameters : none
    * Return Type: nothing
    */
    static testMethod void positivetestMethodIdeasDownVote(){
        List<Idea__c> ideas = [Select id,Name,CreatedDate,IP_Points__c,IP_TotalPoints__c from Idea__c];
        Test.startTest();
        IdeasForumController ideasForum = new IdeasForumController();
        ideasForum.selectedStatus = 'Idea Submitted';
        ideasForum.selectedSorting = 'Popular';
        ideasForum.ideadIdValue = ideas[0].id;
        ideasForum.upvotedownvote = 'Downvote';
        ideasForum.DOWNVOTE_VALUE = 'Downvote';
        ideasForum.getSortingOptions();
        ideasForum.getStatusOptions();
        ideasForum.ideasBasedOnStatus();
        ideasForum.displayIdeasBySelection();
        Test.StopTest();
    }
    
    /*
    * Method Name: positivetestMethodIdeasUpVote
    * Description: Test Method for IdeasForumController Class
    * Parameters : none
    * Return Type: nothing
    */
    static testMethod void positivetestMethodIdeasUpVote(){
        List<Idea__c> ideas = [Select id,Name,CreatedDate,IP_Points__c,IP_TotalPoints__c from Idea__c];
        List<Idea_Comments__c> ideaComments = [Select id,Name from Idea_Comments__c];
        Test.startTest();
        IdeasForumController ideasForum = new IdeasForumController();
        ideasForum.selectedStatus = 'Idea Submitted';
        ideasForum.selectedSorting = 'Popular';
        ideasForum.upvotedownvote = 'Upvote';
        ideasForum.UPVOTE_VALUE = 'Upvote';
        ideasForum.ideadIdValue = ideas[0].id;
        ideasForum.getSortingOptions();
        ideasForum.getStatusOptions();
        ideasForum.ideasBasedOnStatus();
        ideasForum.displayIdeasBySelection();
        IdeasForumController.createIdea();
        ideasForum.previous();
        ideasForum.next();
        Test.StopTest();
    }
    
    /*
    * Method Name: positivetestMethodDisabledPrevious
    * Description: Test Method for IdeasForumController Class
    * Parameters : none
    * Return Type: nothing
    */
    static testMethod void positivetestMethodDisabledPrevious(){
        List<Idea__c> ideas = [Select id,Name,CreatedDate,IP_Points__c,IP_TotalPoints__c from Idea__c limit 2];
        Test.startTest();
        IdeasForumController ideasForum = new IdeasForumController();
        ideasForum.selectedStatus = 'Idea Submitted';
        ideasForum.selectedSorting = 'Popular';
        ideasForum.upvotedownvote = 'Upvote';
        ideasForum.UPVOTE_VALUE = 'Upvote';
        ideasForum.getSortingOptions();
        ideasForum.getStatusOptions();
        ideasForum.ideasBasedOnStatus();
        ideasForum.displayIdeasBySelection();
        IdeasForumController.createIdea();
        ideasForum.previous();
        ideasForum.next();
        Test.StopTest();
    }

}