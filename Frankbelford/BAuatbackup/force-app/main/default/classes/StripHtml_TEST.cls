@isTest
public class StripHtml_TEST {  
    // Test method for stripHtml
    @isTest
    static void teststripHtmlTags() {
    
        List<string> withHTML = New List<String>{'<html><body>This is a Test</body></html>'};     
        List<string> withoutHTML = New List<String>{'This is a Test'};

        Assert.areEqual(withoutHTML,StripHtml.stripHtml(withHTML),'HTML removed');       


    }
}