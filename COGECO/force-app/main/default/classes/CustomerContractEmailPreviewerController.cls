public with sharing class CustomerContractEmailPreviewerController {
    @TestVisible private class CustomerContractEmailPreviewerException extends Exception {}

    @AuraEnabled(cacheable=true)
    public static CustomerContractEmailPreviewerDto getEmailTemplateBasedOnLanguage(String language) {
        if (String.isBlank(language)) {
            return null;
        }

        try {
            String emailTemplateDeveloperName = ApexConstants.CONTRACT_PREVIEW_EMAIL_TEMPLATE_MAPPING_FROM_LANGUAGE.get(language);
            EmailTemplate template = EmailTemplateSelector.getSingleEmailTemplateSubjectAndHtmlValueFromDeveloperName(emailTemplateDeveloperName);
    
            CustomerContractEmailPreviewerDto dto = new CustomerContractEmailPreviewerDto();
            dto.templateId = template.Id;
            dto.subject = template.Subject;
            dto.htmlValue = template.HtmlValue;
    
            return dto;
        } catch (Exception e) {
            icServiceErrorHandler.LogError('CustomerContractEmailPreviewerController', 'getEmailTemplate', e.getStackTraceString(), e.getMessage(), null);
            throw new CustomerContractEmailPreviewerException(e.getMessage());
        }
    }
}