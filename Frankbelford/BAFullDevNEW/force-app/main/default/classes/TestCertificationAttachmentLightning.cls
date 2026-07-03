@isTest
private class TestCertificationAttachmentLightning {
    
    static testMethod void certificationAttachment(){ 
        
        RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType = 'Certification__c' AND Name = 'Right to Work'];
        
        Account account = TestDataFactory.createCandidateAccount(1)[0]; 
        insert account; 
        
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        
        Contact cont = TestDataFactory.createCandidate(account.id, 1)[0];
        insert cont;
        
        Certification__c certificate = new Certification__c();
        certificate.Contact__c=cont.id;
        certificate.RecordTypeId=rt.Id;
        insert certificate; 
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(certificate);
        CertificationConfirmAttachmentLightning certification = new CertificationConfirmAttachmentLightning(sc);
        CertificationConfirmAttachmentLightning.getCertificationAttachment(certificate.id);
        CertificationConfirmAttachmentLightning.updateCertificationRecord(certificate.id,true);
        test.stopTest();
        
    }
    
    static testMethod void certificationAttachment1(){ 
        
        RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType = 'Certification__c' AND Name = 'Right to Work'];
        
        Account account = TestDataFactory.createCandidateAccount(1)[0]; 
        insert account; 
        
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        
        Contact cont = TestDataFactory.createCandidate(account.id, 1)[0];
        insert cont;
        
        Certification__c certificate = new Certification__c();
        certificate.Contact__c=cont.id;
        certificate.RecordTypeId=rt.Id;
        insert certificate; 
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(certificate);
        CertificationConfirmAttachmentLightning certification = new CertificationConfirmAttachmentLightning(sc);
        CertificationConfirmAttachmentLightning.getCertificationAttachment(certificate.id);
        CertificationConfirmAttachmentLightning.updateCertificationRecord(certificate.id,false);
        test.stopTest();        
    }
    
    static testMethod void certificationAttachment3(){ 
        
        RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType = 'Certification__c' AND Name = 'Right to Work'];
        
        Account account = TestDataFactory.createCandidateAccount(1)[0]; 
        insert account; 
        
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        
        Contact cont = TestDataFactory.createCandidate(account.id, 1)[0];
        insert cont;
        
        CertificationVerifyAttachment__c setting = new CertificationVerifyAttachment__c();
        setting.Name = 'Right to Work';
        insert setting;
        
        Certification__c certificate = new Certification__c();
        certificate.Contact__c=cont.id;
        certificate.RecordTypeId=rt.Id;
        insert certificate;
        
        Blob b = Blob.valueOf('Test Data');     
        Attachment attachment = new Attachment();
        attachment.ParentId = certificate.id;
        attachment.Name = 'Test Attachment for Parent';
        attachment.Body = b;        
        insert(attachment);
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(certificate);
        CertificationConfirmAttachmentLightning certification = new CertificationConfirmAttachmentLightning(sc);
        CertificationConfirmAttachmentLightning.getCertificationAttachment(certificate.id);
        CertificationConfirmAttachmentLightning.updateCertificationRecord(certificate.id,true);
        test.stopTest();
        
    }
    
    static testMethod void certificationAttachment4(){ 
        
        RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType = 'Certification__c' AND Name = 'Medical'];
        
        Account account = TestDataFactory.createCandidateAccount(1)[0]; 
        insert account; 
        
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        
        Contact cont = TestDataFactory.createCandidate(account.id, 1)[0];
        insert cont;
        
        CertificationVerifyAttachment__c setting = new CertificationVerifyAttachment__c();
        setting.Name = 'Right to Work';
        insert setting;
        
        Certification__c certificate = new Certification__c();
        certificate.Contact__c=cont.id;
        certificate.RecordTypeId=rt.Id;
        insert certificate;
        
        Blob b = Blob.valueOf('Test Data');     
        Attachment attachment = new Attachment();
        attachment.ParentId = certificate.id;
        attachment.Name = 'Test Attachment for Parent';
        attachment.Body = b;        
        insert(attachment);
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(certificate);
        CertificationConfirmAttachmentLightning certification = new CertificationConfirmAttachmentLightning(sc);
        CertificationConfirmAttachmentLightning.getCertificationAttachment(certificate.id);
        CertificationConfirmAttachmentLightning.updateCertificationRecord(certificate.id,true);
        test.stopTest();
        
    }
}