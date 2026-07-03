/* Author : priyanka
 * Case link : https://targetrecruit.atlassian.net/browse/WAVE-276
 * TestClass :CandidateGoogleSearchControlerTest
 */
public class CandidateGoogleSearchControler {
    
    public ApexPages.StandardController stdController;
    public Contact candidate { get; private set; }
    //Date threeMonthsAgo = Date.today().addMonths(-3);
    public CandidateGoogleSearchControler(ApexPages.StandardController stdController) {
        this.stdController = stdController;
        this.candidate = (Contact)stdController.getRecord();
        
    }
    
    public PageReference candidateSearch(){
        
        List<contact> conUpdate = new  List<contact>();
        Contact con = [SELECT Id,Google_Background_Check__c, FirstName,LastName,AVTRRT__Candidate_Status__c, Last_Background_Search_Date__c
                       FROM Contact WHERE Id = :candidate.Id];
        con.Last_Background_Search_Date__c = System.today();
        con.Google_Background_Check__c = 'https://www.google.com/search?q=Dr ' + 
            con.FirstName +' '+ con.LastName +
            ' AND%20revoked%20OR%20license%20suspended%20OR%20disciplinary%20OR%20investigation%20OR%20misconduct%20OR%20offences%20OR%20guilty%20OR%20allegations';
        
        update con;
        
        PageReference googleSearchPage  = new PageReference(con.Google_Background_Check__c);
        googleSearchPage.setRedirect(true);
        
       // makeCalloutAndInsertAttachment(con.Id, googleSearchPage);
        
        
         return googleSearchPage;
        
    }
    
   /* public PageReference makeCalloutAndInsertAttachment(Id contactId, PageReference googleSearchPage) {
        Blob pdfContent =googleSearchPage.getContent();
        // Store the PDF content in an Attachment
        Attachment attachment = new Attachment();
        attachment.Name = 'Google_Search_Result.pdf';
        attachment.Body = pdfContent;
        attachment.ParentId = contactId;
        insert attachment;
        return null;
    }*/
}