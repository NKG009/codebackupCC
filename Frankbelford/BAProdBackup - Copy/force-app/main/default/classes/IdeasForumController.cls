/**********************************************************************************************
* @Author:         Charu Rani- Espire
* @Date:           12/04/2019
* @Description:    This class is used to display all the Idea to User based on Logged in User. 
* @Requirement Id:
* @Test Class:     
* @Revision(s):    [Date] - [Change Reference] - [Changed By] - [Description]
/----
    @Author:         Jyothi Hale
    @Description      updated the code as per PT1-945
**********************************************************************************************/
public with sharing class IdeasForumController { 
    
    public String ideadIdValue{get;set;}
    private static final String COMMENT = 'Comment';
    private static final String VOTE = 'Vote';    
    @TestVisible private String UPVOTE_VALUE = 'Upvote';    
    @TestVisible private String DOWNVOTE_VALUE = 'Downvote';
    private static final String POPULAR = 'Popular';
    private static final String RECENT = 'Recent';
    private static final String TRENDING = 'Trending'; 
    List<Idea_Comments__c> lstIdeaComments  = new List<Idea_Comments__c>();    
    public Map<Id,Integer> mapIdeaIdNumberOfComments{get;set;}
    public Map<Id,Integer> mapIdeaIdCommentExist{get;set;}
    public Map<Id,Integer> mapIdeaIdNumberOfStatus{get;set;}
    public Map<Id,String> mapIdeaIdIdeaStatus{get;set;}
    public String selectedSorting{get;set;}
    private static final String UPVOTED = 'Upvoted';
    private static final String DOWNVOTED = 'Downvoted';
    private static final String ALL_VALUE = 'All';
    public String upvotedownvote{get;set;}
    public List<Idea__c> listIdeaIdeaCommentRecords{get;set;}//SD
    private Integer OffsetSize = 0;
    private Integer QueryLimit = 10;
    //default page size
    private static final Integer PAGE_SIZE = 10;
    //pagination information
    public Integer page{get;set;}
    public Integer startIdx{get;set;}
    public Integer endIdx{get;set;}
    public Integer totalRecords{get;set;}
    public Integer totalPages{get;set;}
    public string selectedStatus {get; set;}
    public List<SelectOption> statusValues {get; set;}
    public Idea__c ideaRecord{get;set;}
    public string searchText{get;set;}//jyothi
    
    public IdeasForumController(){
        selectedSorting = POPULAR;
        selectedStatus = ALL_VALUE;
        mapIdeaIdNumberOfComments = new Map<Id,Integer>();
        mapIdeaIdCommentExist = new Map<Id,Integer>();
        mapIdeaIdNumberOfStatus = new Map<Id,Integer>();
        mapIdeaIdIdeaStatus = new Map<Id,String>();
        page = 1;
        listIdeaIdeaCommentRecords = new List<Idea__c>();
        listIdeaIdeaCommentRecords = getListIdeaRecords();      
    }
    
    public List<SelectOption> getSortingOptions() {
        List<SelectOption> countryOptions = new List<SelectOption>();
        countryOptions.add(new SelectOption(POPULAR,POPULAR));
        countryOptions.add(new SelectOption(RECENT,RECENT));
        countryOptions.add(new SelectOption(TRENDING,TRENDING));
        return countryOptions;
    }
    
    
    public void getStatusOptions(){
        Schema.DescribeFieldResult statusDescription = Idea__c.Status__c.getDescribe();
        statusValues = new List<SelectOption>();
        statusValues.add(new SelectOption(ALL_VALUE,ALL_VALUE));            
        for (Schema.Picklistentry pl : statusDescription.getPicklistValues()){          
            statusValues.add(new SelectOption(pl.getValue(),pl.getLabel()));
        }
    }
    
    public void ideasBasedOnStatus(){
        //this.startIdx = 0;
        //this.endIdx = 0;
        page = 1;
        listIdeaIdeaCommentRecords = getListIdeaRecords();
    }
    
    public void displayIdeasBySelection(){
        //listIdeaIdeaCommentRecords = new List<Idea__c>();
        page = 1;
        listIdeaIdeaCommentRecords = getListIdeaRecords();
        
    }
    
    //Jyothi.start
    public pagereference clearInputText(){
        this.searchText = null;  
        this.displayIdeasBySelection();
        return null;    
    }
    //Jyothi.stop
    
    private List<Idea__c> getListIdeaRecords(){
        Integer lmt = Limits.getLimitQueryRows() - Limits.getQueryRows();
        //calculate the range of records for capture
        this.startIdx = (this.page-1)*PAGE_SIZE;
        this.endIdx = this.page*PAGE_SIZE;
        this.totalRecords = 0;
        listIdeaIdeaCommentRecords = new List<Idea__c>();
        //Jyothi.start
        String query = 'Select id,Name,IP_Category__c,CreatedDate,IP_Description__c,IP_Headline__c,CreatedBy.Name '
                  +',IP_Points__c,IP_Responce__c,Status__c,IP_TotalPoints__c,(Select id,Comment__c,User__c,IP_Idea__c,Status__c ,RecordTypeId  '
                  +'from Idea_Comments__r limit: lmt) from Idea__c WHERE Name != null ';        
        /*
        if(ALL_VALUE.equals(selectedStatus)){
             if(selectedSorting.equals(POPULAR)){
                For(Idea__c  ideaObj: [Select id,Name,IP_Category__c,CreatedDate,IP_Description__c,IP_Headline__c,CreatedBy.Name
                                    ,IP_Points__c,IP_Responce__c,Status__c,IP_TotalPoints__c,(Select id,Comment__c,User__c,IP_Idea__c,Status__c ,RecordTypeId  
                                    from Idea_Comments__r limit: lmt) from Idea__c ORDER BY IP_Points__c desc limit: 2000]) {
                    if(this.totalRecords>=this.startIdx && this.totalRecords<this.endIdx){
                        listIdeaIdeaCommentRecords.add(ideaObj);
                    }
                    this.totalRecords++;
                    system.debug('++++++Popular listIdeaIdeaCommentRecords++++'+listIdeaIdeaCommentRecords);                
                }
            }
            if(selectedSorting.equals(RECENT)){
                For(Idea__c  ideaObj: [Select id,Name,IP_Category__c,CreatedDate,IP_Description__c,IP_Headline__c,CreatedBy.Name
                                    ,IP_Points__c,IP_Responce__c,Status__c,IP_TotalPoints__c,(Select id,Comment__c,User__c,IP_Idea__c,Status__c ,RecordTypeId  
                                    from Idea_Comments__r limit: lmt) from Idea__c ORDER BY CREATEDDATE desc limit: 2000]) {
                    if(this.totalRecords>=this.startIdx && this.totalRecords<this.endIdx){
                        listIdeaIdeaCommentRecords.add(ideaObj);
                    }
                    this.totalRecords++;
                    system.debug('++++++Popular listIdeaIdeaCommentRecords++++'+listIdeaIdeaCommentRecords);
                }
            }
            if(selectedSorting.equals(TRENDING)){
                For(Idea__c  ideaObj: [Select id,Name,IP_Category__c,CreatedDate,IP_Description__c,IP_Headline__c,CreatedBy.Name
                                    ,IP_Points__c,IP_Responce__c,Status__c,IP_TotalPoints__c,(Select id,Comment__c,User__c,IP_Idea__c,Status__c ,RecordTypeId  
                                    from Idea_Comments__r limit: lmt) from Idea__c  ORDER BY IP_TotalPoints__c desc limit: 2000]) {
                    if(this.totalRecords>=this.startIdx && this.totalRecords<this.endIdx){
                        listIdeaIdeaCommentRecords.add(ideaObj);
                    }
                    this.totalRecords++;
                    system.debug('++++++Popular listIdeaIdeaCommentRecords++++'+listIdeaIdeaCommentRecords);
                }
            }
        }
        else{
            if(selectedSorting.equals(POPULAR)){
                For(Idea__c  ideaObj: [Select id,Name,IP_Category__c,CreatedDate,IP_Description__c,IP_Headline__c,CreatedBy.Name
                                    ,IP_Points__c,IP_Responce__c,Status__c,IP_TotalPoints__c,(Select id,Comment__c,User__c,IP_Idea__c,Status__c ,RecordTypeId  
                                    from Idea_Comments__r limit: lmt) from Idea__c where Status__c=:selectedStatus 
                                    ORDER BY IP_Points__c desc limit: 2000]) {
                    if(this.totalRecords>=this.startIdx && this.totalRecords<this.endIdx){
                        listIdeaIdeaCommentRecords.add(ideaObj);
                    }
                    this.totalRecords++;
                    system.debug('++++++Popular listIdeaIdeaCommentRecords++++'+listIdeaIdeaCommentRecords);                
                }
            }
            if(selectedSorting.equals(RECENT)){
                For(Idea__c  ideaObj: [Select id,Name,IP_Category__c,CreatedDate,IP_Description__c,IP_Headline__c,CreatedBy.Name
                                    ,IP_Points__c,IP_Responce__c,Status__c,IP_TotalPoints__c,(Select id,Comment__c,User__c,IP_Idea__c,Status__c,RecordTypeId   
                                    from Idea_Comments__r limit: lmt) from Idea__c where Status__c=:selectedStatus 
                                    ORDER BY CREATEDDATE desc limit: 2000]) {
                    if(this.totalRecords>=this.startIdx && this.totalRecords<this.endIdx){
                        listIdeaIdeaCommentRecords.add(ideaObj);
                    }
                    this.totalRecords++;
                    system.debug('++++++Popular listIdeaIdeaCommentRecords++++'+listIdeaIdeaCommentRecords);
                }
            }
            if(selectedSorting.equals(TRENDING)){
                For(Idea__c  ideaObj: [Select id,Name,IP_Category__c,CreatedDate,IP_Description__c,IP_Headline__c,CreatedBy.Name
                                    ,IP_Points__c,IP_Responce__c,Status__c,IP_TotalPoints__c,(Select id,Comment__c,User__c,IP_Idea__c,Status__c,RecordTypeId  
                                    from Idea_Comments__r limit: lmt) from Idea__c where Status__c=:selectedStatus 
                                    ORDER BY IP_TotalPoints__c desc limit: 2000]) {
                    if(this.totalRecords>=this.startIdx && this.totalRecords<this.endIdx){
                        listIdeaIdeaCommentRecords.add(ideaObj);
                    }
                    this.totalRecords++;
                    system.debug('++++++Popular listIdeaIdeaCommentRecords++++'+listIdeaIdeaCommentRecords);
                }
            }
        }
        */
        if(!ALL_VALUE.equals(selectedStatus)){
            query += ' AND Status__c=:selectedStatus ';
        }
        
        if(searchText != null && searchText.trim() != ''){
            query += ' AND IP_Headline__c like \'%'+searchText+'%\'';
        }
        
        if(selectedSorting.equals(POPULAR)){
            query += ' ORDER BY IP_Points__c desc limit 2000 ';
        }
        if(selectedSorting.equals(RECENT)){
            query += ' ORDER BY CREATEDDATE desc limit 2000 ';              
        }
        if(selectedSorting.equals(TRENDING)){
            query += ' ORDER BY IP_TotalPoints__c desc limit 2000 ';    
        }
        
        for(Idea__c  ideaObj: database.query(query)){
            if(this.totalRecords>=this.startIdx && this.totalRecords<this.endIdx){
                listIdeaIdeaCommentRecords.add(ideaObj);
            }
            this.totalRecords++;
        }
        
        //Jyothi.end        
        
        for(Idea__c idea : listIdeaIdeaCommentRecords){
            lstIdeaComments.addall(idea.Idea_Comments__r);
        }
        
        getIdeaRecords(lstIdeaComments,listIdeaIdeaCommentRecords);
        
        Decimal pages = Decimal.valueOf(this.totalRecords);
        pages = pages.divide(Decimal.valueOf(PAGE_SIZE), 2);

        this.totalPages = (Integer)pages.round(System.RoundingMode.CEILING);

        //adjust start index e.g. 1, 11, 21, 31
        this.startIdx++;

        //adjust end index
        if(this.endIdx>this.totalRecords){
            this.endIdx = this.totalRecords;
        }
        return listIdeaIdeaCommentRecords;
    }
    
    public void updateIdeaRecord() {
        Idea__c idea = [select id,IP_TotalPoints__c,IP_Points__c from Idea__c where id =:ideadIdValue Limit 1];
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
        getListIdeaRecords();
    }
    
    private void getIdeaRecords(List<Idea_Comments__c> lstIdeaComments,List<Idea__c> listIdeaIdeaCommentRecords){
        Map<Id,Set<Idea_Comments__c>> mapPutIdeaSetIdeaComments = new Map<Id,Set<Idea_Comments__c>>();
        
        for(Idea_Comments__c ideaComments : lstIdeaComments){
            if(ideaComments.RecordTypeId.equals(Schema.SObjectType.Idea_Comments__c.getRecordTypeInfosByName().get(VOTE).getRecordTypeId())){
                if(ideaComments.User__c == UserInfo.getUserId()){
                    mapIdeaIdIdeaStatus.put(ideaComments.IP_Idea__c,ideaComments.Status__c);
                }
            }
            else if(ideaComments.RecordTypeId.equals(Schema.SObjectType.Idea_Comments__c.getRecordTypeInfosByName().get(COMMENT).getRecordTypeId())){
                if(!mapPutIdeaSetIdeaComments.containskey(ideaComments.IP_Idea__c)){
                    Set<Idea_Comments__c> setOfIdeaComments = new Set<Idea_Comments__c>();
                    setOfIdeaComments.add(ideaComments);
                    mapPutIdeaSetIdeaComments.put(ideaComments.IP_Idea__c,setOfIdeaComments);
                }
                else{ 
                    Set<Idea_Comments__c> setOfIdeaComments = mapPutIdeaSetIdeaComments.get(ideaComments.IP_Idea__c);
                    setOfIdeaComments.add(ideaComments);
                    mapPutIdeaSetIdeaComments.put(ideaComments.IP_Idea__c,setOfIdeaComments);                   
                }
            }
        }
        
        for(Id ideaId : mapPutIdeaSetIdeaComments.keyset()){            
            mapIdeaIdNumberOfComments.put(ideaId,mapPutIdeaSetIdeaComments.get(ideaId).size());
        }
        
        
        for(Idea__c ideaValue : listIdeaIdeaCommentRecords){
            if(mapIdeaIdIdeaStatus.containsKey(ideaValue.id)){
                mapIdeaIdNumberOfStatus.put(ideaValue.id,1);
            }
            else{
                mapIdeaIdNumberOfStatus.put(ideaValue.id,0);
            }
            if(mapIdeaIdNumberOfComments.containsKey(ideaValue.id)){
                mapIdeaIdCommentExist.put(ideaValue.id,1);
            }
            else{
                mapIdeaIdCommentExist.put(ideaValue.id,0);
            }
        }
    }
    
    public void previous()
    {
        //OffsetSize -= QueryLimit;
        //system.debug('++++++ previous OffsetSize++++'+OffsetSize);
        if(getDisablePrevious()){
            this.page--;
            listIdeaIdeaCommentRecords = getListIdeaRecords();
        }
    }
    public void next()
    {
        //OffsetSize += QueryLimit;
        //system.debug('++++++ next OffsetSize++++'+OffsetSize);
        if(getDisableNext()){
            this.page++;
            listIdeaIdeaCommentRecords = getListIdeaRecords();
        }
    }
    
    //returns whether the previous page exists
    public Boolean getDisablePrevious(){
        if(this.page>1){
            return true;
        }
        else return false;
    }
    
    //returns whether the next page exists
    public Boolean getDisableNext() {
        if(this.page<this.totalPages){
            return true;
        }
        else return false;
    }
   
    
    public static PageReference createIdea(){
        PageReference ideaListPage = Page.NewIdeaCreationPage;
        ideaListPage.setRedirect(true);
        return ideaListPage;
    }
}