@isTest
public class FilesTC {
    // private static LoggerCP logger = new LoggerCP('FilesTest');
    
    @IsTest
    private static void testCreate() {
        
        AVTRRT__Config_Settings__c configSetting = new AVTRRT__Config_Settings__c(
            Name = 'Default',
            AVTRRT__Trigger_Disabled_Trigger_JobApplicants__c = true,
            AVTRRT__Trigger_Disabled_Contact__c = true,
            AVTRRT__Trigger_Placement__c = true
        );
        
        insert configSetting;
        
        Account account = new Account(Name = 'Test Account',Business_Entity__c='Wavelength International');
        insert account;
        
        Contact contact = new Contact(LastName = 'Test',Business_Entity__c='Wavelength International', AccountId = account.Id);
        insert contact;
        
        Files.File[] filesToCreate = new Files.File[] {};
            
            Files.File file = new Files.File();
        file.name = 'Test1.pdf';
        file.body = Blob.valueOf('Ha-ha');
        file.parentId = contact.Id;
        filesToCreate.add(file);
        
        file = new Files.File();
        file.name = 'Test2.pdf';
        file.body = Blob.valueOf('Ha-ha');
        file.parentId = contact.Id;
        filesToCreate.add(file);
        
        file = new Files.File();
        file.name = 'Test3.pdf';
        file.body = Blob.valueOf('Ha-ha');
        file.parentId = contact.Id;
        filesToCreate.add(file);
        
        Test.startTest();
        
        ContentVersion[] versions = Files.create(filesToCreate);
        
        Files.getContentVersionsByParentId(contact.Id);
        Files.getContentVersionsByIds(new Id[] {versions[0].Id});
        
        Test.stopTest();
        
        System.assertEquals(3, versions.size());
    }
    
    @IsTest
    private static void testConvert() {
        
        AVTRRT__Config_Settings__c cusSet = new AVTRRT__Config_Settings__c();
        cusSet.Name = 'Default';
        cusSet.AVTRRT__Trigger_Placement__c = true;
        cusSet.AVTRRT__Trigger_Disabled_Trigger_JobApplicants__c = true;
        cusSet.AVTRRT__Trigger_Disabled_Contact__c = true;
        insert cusSet;
        
        Account account = new Account(Name = 'Test',Business_Entity__c='Wavelength International');
        insert account;
        
        List<Account> a = new List<Account>();
        a.add(account);
        
        Contact contact = new Contact(LastName = 'Test',Business_Entity__c='Wavelength International', AccountId = account.Id);
        insert contact;
        
        Attachment[] attachments = new Attachment[] {};
            for (Integer i = 0; i < 3; i++) {
                createAttachment(attachments, contact.Id, i + 1);
            }
        insert attachments;
        
        
        GroupByHelper.getFieldValuesStrings(a,'Name');
        GroupByHelper.getFieldValuesIds(a,'Id'); 
        attachments = [
            SELECT ParentId, OwnerId, Name, Description, Body, IsPrivate,
            CreatedById, CreatedDate, LastModifiedById, LastModifiedDate
            FROM Attachment
        ];
        
        Test.startTest();
        
        ContentVersion[] versions = Files.convert(attachments, true);
        
        Test.stopTest();
        
        System.assertEquals(3, versions.size());
        
        attachments = [
            SELECT ParentId, OwnerId, Name, Description, Body, IsPrivate,
            CreatedById, CreatedDate, LastModifiedById, LastModifiedDate
            FROM Attachment
            WHERE ParentId = :contact.Id
        ];
        
        System.assertEquals(0, attachments.size());
    }
    
    private static void createAttachment(Attachment[] attachments, Id parentId, Integer num) {
        
        AVTRRT__Config_Settings__c cusSet = new AVTRRT__Config_Settings__c();
        cusSet.Name = 'Default';
        cusSet.AVTRRT__Trigger_Placement__c = true;
        cusSet.AVTRRT__Trigger_Disabled_Trigger_JobApplicants__c = true;
        cusSet.AVTRRT__Trigger_Disabled_Contact__c = true;
        insert cusSet;
        
        if (attachments != null) {
            attachments.add(new Attachment(
                Name = 'Test Attachment' + num,
                Body = Blob.valueOf('Test Attachment Body' + num),
                ParentId = parentId
            ));
        }
    }
    
    
    private static testMethod void newMethod() {
        
        AVTRRT__Config_Settings__c cusSet = new AVTRRT__Config_Settings__c();
        cusSet.Name = 'Default';
        cusSet.AVTRRT__Trigger_Placement__c = true;
        cusSet.AVTRRT__Trigger_Disabled_Trigger_JobApplicants__c = true;
        cusSet.AVTRRT__Trigger_Disabled_Contact__c = true;
        insert cusSet;
        
        Account account = new Account(Name = 'Test Account',Business_Entity__c='Wavelength International');
        insert account;
        
        Contact contact = new Contact(LastName = 'Test',Business_Entity__c='Wavelength International', AccountId = account.Id);
        insert contact;
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'tr__Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        //Get Content Version
        List<ContentVersion> cvList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        
        //Get Content Documents
        List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        
        Files.linkDocumentToRecord(new List<Id>{cdList[0].Id}, new List<Id>{contact.Id});
        
        
        Files.getContentVersionsByParentId(contact.Id,false);
    }
}