//https://targetrecruit.atlassian.net/browse/UPP-46
public without sharing class ManualPayPackageEmailTemplateButtonClass {
    
    Public Id JAId {get;set;}
    public Boolean thankYouMessage {get; Set;}
    Public AVTRRT__Job_Applicant__c j {get;set;}
    
    public ManualPayPackageEmailTemplateButtonClass(ApexPages.StandardController controller) {
        JAId = ApexPages.currentPage().getParameters().get('Id');
        thankYouMessage = false;
    }
    
    
    Public void UpdateYes()
    {
        thankYouMessage = true;
        
        j= [Select Id, Pay_Package_Response__c from AVTRRT__Job_Applicant__c where Id=: JAId];
        j.Pay_Package_Response__c ='Accepted Pay Package';
        update j;
        Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.Info, system.label.ManualPayPackageUpdateYes));
        
    }
    Public void UpdateReqAddInfo()
    {
        thankYouMessage = true;
        AVTRRT__Job_Applicant__c  j= new AVTRRT__Job_Applicant__c();
        j= [Select Id, Pay_Package_Response__c from AVTRRT__Job_Applicant__c where Id=: JAId];
        j.Pay_Package_Response__c ='Additional Info Requested ';
        update j;
        Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.Info, system.label.ManualPayPackageInfoRequested));
        
    }
    Public void UpdateNo()
    {
        thankYouMessage = true;
        AVTRRT__Job_Applicant__c  j= new AVTRRT__Job_Applicant__c();
        j= [Select Id, Pay_Package_Response__c from AVTRRT__Job_Applicant__c where Id=: JAId];
        j.Pay_Package_Response__c ='Rejected Pay Package ';
        update j;
        Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.Info, system.label.ManualPayPackageUpdateNo));
        
    }


}