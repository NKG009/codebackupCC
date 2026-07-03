public class CertificationConfirmAttachmentLightning {
    private final Certification__c record {get;set;}
    //public CertificationVerifyAttachment__c custom {get;set;}
    public CertificationConfirmAttachmentLightning(ApexPages.StandardController stdController){
        this.record = (Certification__c)stdController.getRecord();
    }
    
    @AuraEnabled
    public Static String getCertificationAttachment(String certificationId){
        Certification__c certification = [select id,Verfied__c,IP_Status__c,RecordTypeId from Certification__c where Id=:certificationId]; 
        if(certification.IP_Status__c=='Lapsed'){
            return 'Lapsed certificate cannot be re-verified. Please create a new one instead.';
            
        }
        else
        {
            if(certification.IP_Status__c=='Current' && certification.Verfied__c){
                return 'This record has already been verified.';
            }
            else{
                List<Attachment> listAttachment = [Select id,ParentId FROM Attachment WHERE ParentId = :certificationId];
                //List<ContentDocumentLink> contentDocumentLink = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :certificationId];
                Set<Id> setContentDocumentId = new Set<Id>();
                for(ContentDocumentLink contentDocumentLink : [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :certificationId]){
                    setContentDocumentId.add(contentDocumentLink.ContentDocumentId);
                }
                system.debug('+++++++++++setContentDocumentId+++++++'+setContentDocumentId);
                List<ContentDocument> listContentDocument = [Select Id ,Title from ContentDocument Where ID In :setContentDocumentId];
                system.debug('+++++++++++listAttachment+++++++'+listAttachment);
                if((!listAttachment.isEmpty() && listAttachment!=null) || (!listContentDocument.isEmpty() && listContentDocument!=null)){
                    Boolean result = getSettings(certification.RecordTypeId);
                    if(result){
                        if(certification.Verfied__c){
                            return 'true';
                        }
                        else{
                            return 'verifiedFalse';
                        }
                    }
                    else{
                        return 'false';
                    }
                }
                else{
                    return 'attachmentNotExist';
                }
                
            }
        }
    }
    
    @AuraEnabled
    public Static String updateCertificationRecord(String certificationId,Boolean isChecked){
        
        Certification__c certification = new Certification__c(id=certificationId);        
        certification.IP_Original_Seen_on__c = isChecked;
        certification.Verfied__c = isChecked;
        try{
            system.debug('try block');
            update certification;
            //PageReference pageRef = new PageReference('/lightning/r/ts2__Certification__c/'+certificationId+'/view'); //
            return 'true';
        } 
        catch(DmlException ex) {
            system.debug('try block');
            String errormsg = ex.getMessage();
            String suberror1 = errormsg.substringAfter(',');
            String suberror2 = suberror1.substringBefore(':');
            System.debug('Error message '+ suberror2);
            // ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, suberror2);
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,suberror2));         
            System.debug('The following exception has occurred: ' + ex.getMessage());           
            //ApexPages.addMessage(msg);
            return suberror2;
        }
    }
    
    public static Boolean getSettings(Id recordTypeId){  
        //List<CertificationVerifyAttachment__c> mcs = CertificationVerifyAttachment__c.getall().values();
        String recordTypeName = [SELECT Name from Recordtype where ID=:recordTypeId].Name;
        for(CertificationVerifyAttachment__c mcs :CertificationVerifyAttachment__c.getall().values()){
            if(mcs.Name==recordTypeName){
                return true;
            }
        }
        return false;
    }
}