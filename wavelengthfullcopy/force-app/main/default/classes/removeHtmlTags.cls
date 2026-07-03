public class removeHtmlTags {
   @invocablemethod(label='Remove HTML Tags')
    public static List<String> removeTags(List<String> richTextList) {
        String richText = richTextList[0];
        List<String> plainTextList = new List<String>();
        
        richText = richText.stripHtmlTags();
        plainTextList.add(richText);
        return plainTextList;
    }
}