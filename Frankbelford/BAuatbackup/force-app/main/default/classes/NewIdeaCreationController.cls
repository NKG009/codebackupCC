public class NewIdeaCreationController {
    
    public Idea__c idea{get; set;}
    
    public NewIdeaCreationController() {
        idea = new Idea__c();
        String description = '<b>•&nbsp;&nbsp;What is this great idea?</b><br/>Describe the enhancement you would like to see<br/><br/><b>•&nbsp;&nbsp;Why is this idea amazing?</b><br/>Provide some details as to why this enhancement is important to you<br/><br/><b>•&nbsp;&nbsp;Who’s going to love this idea?</b><br/>List the people or groups that will benefit from this idea e.g. FE’s, Consultants';
        idea.IP_Description__c = description;
    }
    
    public PageReference Save(){
        insert idea;
        PageReference ideaListPage = Page.IdeaForum;
        ideaListPage.setRedirect(true);
        return ideaListPage;
        /*if(string.isBlank(idea.IP_Headline__c)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Headline'));
            return null;
        }
        if(string.isBlank(idea.IP_Category__c)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Category'));
            return null;
        }
        if(string.isBlank(idea.Status__c)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Status'));
            return null;
        }
        else {
            insert idea;
            PageReference ideaListPage = Page.IdeaForum;
            ideaListPage.setRedirect(true);
            return ideaListPage;
        }*/
    }
    
    public PageReference CancelIdea(){
        PageReference ideaListPage = Page.IdeaForum;
        ideaListPage.setRedirect(true);
        return ideaListPage;
    }
}