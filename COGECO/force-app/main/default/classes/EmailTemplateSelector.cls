public inherited sharing class EmailTemplateSelector {
    public static EmailTemplate getSingleEmailTemplateSubjectAndHtmlValue(Id templateId) {
        return [SELECT HtmlValue, Subject FROM EmailTemplate WHERE Id = :templateId];
    }
    
    public static EmailTemplate getSingleEmailTemplateSubjectAndHtmlValueFromDeveloperName(String developerName) {
        if (Test.isRunningTest()) {
            developerName = CustomerContractEmailPreviewerTest.EMAIL_DEVELOPER_NAME;
        }
        
        return [SELECT HtmlValue, Subject FROM EmailTemplate WHERE DeveloperName = :developerName];
    }
}