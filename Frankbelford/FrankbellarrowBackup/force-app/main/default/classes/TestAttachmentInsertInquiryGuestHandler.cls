/*
* Class Name: TestAttachmentInsertInquiryGuestHandler
* Description: JPC-2485 - Trigger on attachment to work for Inquiry SiteUser
                Test Class Of Class of AttachmentInsertInquirySiteGuestUser Trigger and AttachmentInsertInquiryGuestUserHandler Class
* Date : 18th Feb 2020
*/
@isTest
private class TestAttachmentInsertInquiryGuestHandler{
    static testMethod void attachmentInsertMethod(){
        insert new User_Profile_Id__c(
            Name = 'User Portal',
            Profile_Id__c = [SELECT Id FROM Profile WHERE Name = 'User Portal'].Id
        );

        List<User> inquirySiteUser = [Select id from User where Profile.Name='Inquiry Profile'];
        
        RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType = 'ts2__Certification__c' AND Name = 'Right to Work'];
        
        Account account = TestDataFactory.createCandidateAccount(1)[0]; 
        insert account; 
        
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        
        Contact cont = TestDataFactory.createCandidate(account.id, 1)[0];
        insert cont;

        ts2__Certification__c certificate = new ts2__Certification__c();
        certificate.ts2__Contact__c=cont.id;
        certificate.RecordTypeId=rt.Id;
        insert certificate;

        Test.startTest();

        // System.runas(inquirySiteUser[0]) {
            Blob b = Blob.valueOf('Test Data');     
            Attachment attachment = new Attachment();
            attachment.ParentId = certificate.id;
            attachment.Name = 'Test Attachment for Parent';
            attachment.Body = b;        
            insert(attachment);
        // }        

		Test.stopTest();
    }
    
    static testMethod void attachmentCVParserInsertMethod(){
        insert new User_Profile_Id__c(
            Name = 'User Portal',
            Profile_Id__c = [SELECT Id FROM Profile WHERE Name = 'User Portal'].Id
        );

        Account account = TestDataFactory.createCandidateAccount(1)[0]; 
        insert account; 
        
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        
        Contact cont = TestDataFactory.createCandidate(account.id, 1)[0];
        insert cont;
        
        Test.startTest();

        Blob b = Blob.valueOf('Test Data');     
        Attachment attachment = new Attachment();
        attachment.ParentId = cont.id;
        attachment.Name = 'Resume Test Attachment for Parent';
        attachment.Body = b;        
        insert(attachment);        

		Test.stopTest();
    }
}