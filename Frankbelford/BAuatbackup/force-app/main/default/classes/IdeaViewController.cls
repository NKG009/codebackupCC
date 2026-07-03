public class IdeaViewController { 

    public String body { get; set; }    
    public Map<Id,Idea__c> mapIdeaIdIdeaCommentRecords{get;set;}
    public Map<Id,Idea__c> mapIdeaIdIdeaVotedRecords{get;set;}
    @TestVisible private String UPVOTE_VALUE = 'Upvote';
    @TestVisible private String DOWNVOTE_VALUE = 'Downvote';
    private static final String OLDEST_FIRST = 'Oldest First';
    private static final String NEWEST_FIRST = 'Newest First';
    private static final String COMMENT = 'Comment';
    private static final String VOTE = 'Vote';
    private static final String UPVOTED = 'Upvoted';
    private static final String DOWNVOTED = 'Downvoted';
    public String upvotedownvote{get;set;}
    public String ideadIdValue{get;set;}
    public String selectedSorting{get;set;}
    public Map<Id,Integer> mapIdeaTotalIdeaVotedRecords{get;set;}
    
    public IdeaViewController(){
        selectedSorting = NEWEST_FIRST;
        system.debug('++++++selectedSorting++++'+selectedSorting);
        mapIdeaIdIdeaCommentRecords = new Map<Id,Idea__c>();
        mapIdeaIdIdeaVotedRecords = new Map<Id,Idea__c>();
        mapIdeaTotalIdeaVotedRecords = new Map<Id,Integer>();
        mapIdeaIdIdeaCommentRecords = getIdeaCommentRecords();
        mapIdeaIdIdeaVotedRecords = getIdeaVotedRecords();
        mapIdeaTotalIdeaVotedRecords = getIdeaTotalVotedRecords();
    }
    
    public List<SelectOption> getSortingOptions() {
        List<SelectOption> countryOptions = new List<SelectOption>();
        countryOptions.add(new SelectOption(NEWEST_FIRST,NEWEST_FIRST));
        countryOptions.add(new SelectOption(OLDEST_FIRST,OLDEST_FIRST));
        return countryOptions;
    }
    
    public void displayComments(){
        system.debug('++++++selectedSorting++++'+selectedSorting);
        mapIdeaIdIdeaCommentRecords = getIdeaCommentRecords();
    }
    
    private Map<Id,Idea__c> getIdeaCommentRecords(){
        if(selectedSorting.equals(NEWEST_FIRST)){
            mapIdeaIdIdeaCommentRecords = new Map<Id,Idea__c>([Select id,Name,IP_Category__c,CreatedDate,IP_Description__c,IP_Headline__c,CreatedBy.Name
                                ,IP_Points__c,IP_Responce__c,Status__c,IP_TotalPoints__c,(Select id,Comment__c,Status__c,User__r.Name from Idea_Comments__r
                                where RecordTypeId = :Schema.SObjectType.Idea_Comments__c.getRecordTypeInfosByName().get(COMMENT).getRecordTypeId() Order By CreatedDate desc) from Idea__c where id=:ApexPages.currentPage().getParameters().get('id') Limit 1]);
        }
        else if(selectedSorting.equals(OLDEST_FIRST)){
            mapIdeaIdIdeaCommentRecords = new Map<Id,Idea__c>([Select id,Name,IP_Category__c,CreatedDate,IP_Description__c,IP_Headline__c,CreatedBy.Name
                                ,IP_Points__c,IP_Responce__c,Status__c,IP_TotalPoints__c,(Select id,Comment__c,Status__c,User__r.Name from Idea_Comments__r
                                where RecordTypeId = :Schema.SObjectType.Idea_Comments__c.getRecordTypeInfosByName().get(COMMENT).getRecordTypeId() Order By CreatedDate) from Idea__c where id=:ApexPages.currentPage().getParameters().get('id') Limit 1]);
        }
        return mapIdeaIdIdeaCommentRecords;
    }
    
    private Map<Id,Idea__c> getIdeaVotedRecords(){
        mapIdeaIdIdeaVotedRecords = new Map<Id,Idea__c>([Select id,Name,IP_Category__c,CreatedDate,IP_Description__c,IP_Headline__c,CreatedBy.Name
                                ,IP_Points__c,IP_Responce__c,Status__c,IP_TotalPoints__c,(Select id,Comment__c,Status__c from Idea_Comments__r
                                where User__c=:UserInfo.getUserId() and RecordTypeId = :Schema.SObjectType.Idea_Comments__c.getRecordTypeInfosByName().get(VOTE).getRecordTypeId() Limit 1) from Idea__c where id=:ApexPages.currentPage().getParameters().get('id') Limit 1]);
        return mapIdeaIdIdeaVotedRecords;
    }
    
    public Map<Id,Integer> getIdeaTotalVotedRecords(){
        List<Idea__c> lstIdeas = [Select id,Name,IP_Category__c,CreatedDate,IP_Description__c,IP_Headline__c,CreatedBy.Name
                                ,IP_Points__c,IP_Responce__c,Status__c,IP_TotalPoints__c,(Select id,Comment__c,Status__c from Idea_Comments__r
                                where RecordTypeId = :Schema.SObjectType.Idea_Comments__c.getRecordTypeInfosByName().get(VOTE).getRecordTypeId()) from Idea__c where id=:ApexPages.currentPage().getParameters().get('id') Limit 1];
        for(Idea__c idea : lstIdeas){
            mapIdeaTotalIdeaVotedRecords.put(idea.id,idea.Idea_Comments__r.size());
        }
        return mapIdeaTotalIdeaVotedRecords;
    }
    
    public PageReference inserIdeaComment() {
        //system.debug('++++++++++'+body.length());
        if(String.Isblank(body)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please correct the following error(s):Please enter a value in comment section.'));
            return null;
        }
        if(String.IsNotblank(body) && body.length()>4000){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please correct the following error(s):Please enter a value that is no longer than 4000 characters in length.'));
            return null;
        }else{
            Idea_Comments__c ideaComment = new Idea_Comments__c();
            ideaComment.IP_Idea__c = ApexPages.currentPage().getParameters().get('id');
            ideaComment.User__c = UserInfo.getUserId(); 
            ideaComment.Comment__c = body;
            ideaComment.RecordTypeId = Schema.SObjectType.Idea_Comments__c.getRecordTypeInfosByName().get(COMMENT).getRecordTypeId();
            insert ideaComment;
            PageReference pageref = new PageReference('/apex/IdeaView?id='+ApexPages.currentPage().getParameters().get('id'));
            pageref.setRedirect(true);
            return pageref;
        }
    }
    
    public PageReference updateIdeaRecord() {
        system.debug('+++++++++++++++'+ideadIdValue);
        Idea__c idea = [select id,IP_TotalPoints__c,IP_Points__c from Idea__c where id=:ideadIdValue Limit 1];
        system.debug('+++++++++++++++'+idea.IP_Points__c);
        if(upvotedownvote.equals(UPVOTE_VALUE)){
            idea.IP_Points__c = idea.IP_Points__c + 20;
            idea.IP_TotalPoints__c = idea.IP_TotalPoints__c + 20;
        }
        else if(upvotedownvote.equals(DOWNVOTE_VALUE)){
            idea.IP_Points__c = idea.IP_Points__c - 10;
            idea.IP_TotalPoints__c = idea.IP_TotalPoints__c - 10;
        }
        update idea;
        Idea_Comments__c ideaComment = new Idea_Comments__c();
        ideaComment.IP_Idea__c = ideadIdValue;
        ideaComment.User__c = UserInfo.getUserId();     
        if(upvotedownvote.equals(UPVOTE_VALUE)){
            ideaComment.Status__c = UPVOTED;
        }
        else if(upvotedownvote.equals(DOWNVOTE_VALUE)){
            ideaComment.Status__c = DOWNVOTED;
        }
        ideaComment.RecordTypeId = Schema.SObjectType.Idea_Comments__c.getRecordTypeInfosByName().get(VOTE).getRecordTypeId();
        insert ideaComment;
        mapIdeaIdIdeaVotedRecords = getIdeaVotedRecords();
        PageReference pageref = new PageReference('/apex/IdeaView?id='+ApexPages.currentPage().getParameters().get('id'));
        pageref.setRedirect(true);
        return pageref;
    }
    
    public static PageReference CancelPage(){
        PageReference ideaListPage = Page.IdeaForum;
        ideaListPage.setRedirect(true);
        return ideaListPage;
    }
}