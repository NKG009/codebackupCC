@isTest
private class removeHtmlTagsTest {

    @isTest
    static void testRemoveTags() {
        // Test input data with HTML tags
        List<String> richTextList = new List<String>{'<p>This is <b>bold</b> text.</p>'};

        // Expected output without HTML tags
        List<String> expectedPlainTextList = new List<String>{'This is bold text.'};

        // Call the method
        List<String> actualPlainTextList = removeHtmlTags.removeTags(richTextList);

        // Assert the result
        System.assertEquals(expectedPlainTextList, actualPlainTextList, 'HTML tags should be removed.');
    }
   
}