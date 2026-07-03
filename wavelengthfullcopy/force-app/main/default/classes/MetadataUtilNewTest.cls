@IsTest
private class MetadataUtilNewTest {
    
    @IsTest
    private static void test() {
        
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
        
        Test.startTest();
        
        MetadataUtilNew md = MetadataUtilNew.getInstance('Account');
        md = MetadataUtilNew.getInstance(account);
        md = new MetadataUtilNew('Account');
         MetadataUtilNew md2 = new MetadataUtilNew(account);
        MetadataUtilNew md1 = new MetadataUtilNew(account.Id);
        
        md.getObjectType();
        
        System.assertEquals('Account', md.getObjectName());
        
        md.getAllFieldNames();
        md.getAllFieldsSObject();
        
        md.getAllFieldsString();

        md.getAllFieldsString(
                new SObjectField[] { Schema.Account.ParentId },
                new SObjectField[] { Schema.Contact.AccountId });
        
        md.getFieldDisplayType('Parent.Name');
        
        Account v_account = new Account(Name = 'Test Parent',Business_Entity__c='Wavelength International');
        insert v_account;
        
        account.ParentId = v_account.Id;
        update account;
        
        v_account = (Account)md.getRecords(
                new Id[] { account.Id },
                new List<Schema.SObjectField> { Schema.Account.ParentId },
                new List<Schema.SObjectField> { Schema.Contact.AccountId })[0];
        
        Account clonedAccount = (Account)md.cloneById(account.Id, null);
        clonedAccount = (Account)md.cloneById(account.Id, new String[] { 'Contacts' });
        //System.assertEquals('Test Account', clonedAccount.Name);
        //System.assertEquals(1, clonedAccount.Contacts.size());
        
        Account targetAccount = new Account();
        md.updateRecords(account, targetAccount);
        
        md.makeWhereStatement(new Account(
                Name = 'Test Account',
                NumberOfEmployees = 3,
                Type = 'Test'));
        
        md.getFieldLabel('Name');
        md.getFieldLabel(account.Name);
        
        md.getFieldValue('Name', account);
        
        System.assertEquals(false, md.isFieldExists('TestFieldName'));
        
        md.makeWhereStatement(new Account(
                Name = 'Test Account',
                NumberOfEmployees = 3,
                Type = 'Test'));
        
        md.isSortableField('Name');
        md.isEmailField('Name');
        md.isFormulaField('Name');
        md.getAllEditableFieldsSObject();
        md.getObjectAPINameByParentRelationshipName('Account');
        
        md.getFieldValueAsString('Name', 'Test');
        md.getFieldValueAsString('ParentId', account.Id);
        md.getFieldValueAsString('LastActivityDate', Date.today());
        
        md.getParentObjectDescribe('Name');
        
        md.getAllChildRelationshipsStrings();
        
        MetadataUtilNew.getWhereConstraint('Name', '=', '', new Account());
        MetadataUtilNew.getWhereConstraint('Name', '=', 'Test', new Account());
        MetadataUtilNew.getWhereConstraint('Name', 'contains', 'Test', new Account());
        MetadataUtilNew.getWhereConstraint('Name', 'startswith', 'Test', new Account());
        MetadataUtilNew.getWhereConstraint('Name', 'not contains', 'Test', new Account());
        
        MetadataUtilNew.getWhereConstraint('IsDeleted', '=', 'true', new Account());
        
        MetadataUtilNew.getWhereConstraint('NumberOfEmployees', '=', '1', new Account());
        
        MetadataUtilNew.getWhereConstraint(
                'LastActivityDate', '=', Date.today().format(), new Account());
        
        MetadataUtilNew.getWhereConstraint(
                'LastModifiedDate', '=', Date.today().format(), new Account());
        MetadataUtilNew.getWhereConstraint(
                'LastModifiedDate', '!=', Date.today().format(), new Account());
        MetadataUtilNew.getWhereConstraint(
                'LastModifiedDate', '>', Date.today().format(), new Account());
        MetadataUtilNew.getWhereConstraint(
                'LastModifiedDate', '<=', Date.today().format(), new Account());
        MetadataUtilNew.getWhereConstraint(
                'LastModifiedDate', '<>', Date.today().format(), new Account());
        
        MetadataUtilNew.getWhereConstraint(null, null, null, null);
        
        md.getValueByFieldType('Name', 'Test');
        md.getValueByFieldType('NumberOfEmployees', '1');
        md.getValueByFieldType('AnnualRevenue', '30');
        
        MetadataUtilNew mdContact = new MetadataUtilNew(Schema.Contact.SObjectType);
        mdContact.getRecordTypeByRecordId(contact.Id);
        mdContact.getRecordTypeIdByRecordTypeName('Candidate');
        mdContact.getAllRecordTypesAsSelectOptions(true);
        
        MetadataUtilNew.getAllSelectOptionsForField(
                SObjectType.Account.fields.Industry, true);
        MetadataUtilNew.getAllPicklistValueToLabel(
                SObjectType.Account.fields.Industry);
        
        MetadataUtilNew.areStringsMatched('Test', '%Test%');
        MetadataUtilNew.areStringsMatched('Test', '%Test');
        MetadataUtilNew.areStringsMatched('Test', 'Test%');
        MetadataUtilNew.areStringsMatched('Test', 'Test');

        MetadataUtilNew.checkCrudFls(Schema.Account.SObjectType,
                new List<SObjectField> { Schema.Account.Name }, MetadataUtilNew.CHECK_READ);
        
        Test.stopTest();
    }
}