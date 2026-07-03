@isTest
private class CustomLabelTranslatorTest {
    
    @isTest
    static void testTranslateMethod() {
        Test.startTest();
        String language = 'fr';
        List<String> labels = new List<String>{'SignatorysName'};
        String namespace;
        
        String result = CustomLabelTranslator.translate(language,namespace,labels);
        
       
        Test.stopTest();
          
        System.assert(result.contains('"SignatorysName":"Nom du signataire"'));
        
    }
    
    @isTest
    static void testTranslateMethodNoCustomLabel() {
        Test.startTest();
        String language = 'fr';
        List<String> labels = new List<String>{'Arriverdeci'};
        String errorMessage;
                
        try {
            String result = CustomLabelTranslator.translate(language,'vlocity_cmt', labels);
        } catch (Exception e) {
            errorMessage = e.getTypeName();
        }
        
        Test.stopTest();

        System.assertEquals('System.AuraHandledException', errorMessage);
    }
}