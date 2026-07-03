/**
* @description The class containing the invocable method to strip HTML Markup from Rich Text fields
*/
public with sharing class StripHtml {

/**
* @description The class containing the invocable method to strip HTML Markup from Rich Text fields
* @param richText The List of HTML strings
* @return plainText The stripped richText strings 
*/ 
    @InvocableMethod(label='Strip HTML Tags')
    public static List<string> stripHtml(List<string> richText){
        
        List<String> plainText = new List<String>();
        for(string s : richText){
            plainText.add(s.stripHtmlTags());
        }
        
        return plainText;
       
    }
}