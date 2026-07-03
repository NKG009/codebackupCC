@istest
private class TestConvertBusinessControllerLightning{
    
    @testSetup static void setup(){
        
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account'];

        Account acc1 = new Account();
        acc1.name='Test Account Inquiry';
        acc1.Phone='111111111';
        acc1.BillingStreet='Street1';
        acc1.IP_Business_Type__c='catering';
        acc1.BillingCity ='City1';
        acc1.BillingPostalCode = '101911';
        acc1.BillingState='State1';
        acc1.BillingCountry='Country1';
        acc1.RecordTypeId=accountRec.id;
        insert acc1;
        system.debug('Account Inserted');

        Account accPhone = new Account();
        accPhone.name='Test Account phone';
        accPhone.Phone='76757657';
        accPhone.BillingStreet='Street1';
        accPhone.IP_Business_Type__c='catering';
        accPhone.BillingCity ='City1';
        accPhone.BillingPostalCode = '101911';
        accPhone.BillingState='State1';
        accPhone.BillingCountry='Country1';
        accPhone.RecordTypeId=accountRec.id;
        insert accPhone;
        system.debug('Account Inserted');

        Account accComReg = new Account();
        accComReg.name='Test Account registration';
        accComReg.Phone='66666';
        accComReg.BillingStreet='Street1';
        accComReg.IP_Business_Type__c='catering';
        accComReg.BillingCity ='City1';
        accComReg.BillingPostalCode = '101911';
        accComReg.BillingState='State1';
        accComReg.BillingCountry='Country1';
        accComReg.IP_CompanyRegistrationNo__c = '12345678';
        accComReg.RecordTypeId=accountRec.id;
        insert accComReg;
        system.debug('Account Inserted');
        
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
        
        Account acc6 = new Account();
        acc6.name='Test Account Company Limited';
        acc6.Phone='6767676';
        acc6.RecordTypeId=accountRec.id;
        insert acc6;
        system.debug('Account Inserted');

        Account acc2 = new Account();
        acc2.name='Account Company';
        acc2.Phone='44444';
        acc2.BillingStreet='Street1';
        acc2.IP_Business_Type__c='catering';
        acc2.BillingCity ='City1';
        acc2.BillingPostalCode = '101911';
        acc2.BillingState='State1';
        acc2.BillingCountry='Country1';
        acc2.RecordTypeId=accountRec.id;
        insert acc2;
        system.debug('Account Inserted');

        Account acc4 = new Account();
        acc4.name='Test';
        acc4.Phone='222222';
        acc4.BillingStreet='Street1';
        acc4.IP_Business_Type__c='catering';
        acc4.BillingCity ='City1';
        acc4.BillingPostalCode = '101911';
        acc4.BillingState='State1';
        acc4.BillingCountry='Country1';
        acc4.RecordTypeId=accountRec.id;
        insert acc4;
        system.debug('Account Inserted');
        
        id conRTid = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact').getRecordTypeId(); 
        Contact conObj = new Contact(FirstName = 'cFirstName',
                              LastName = 'cLastName',
                              AccountID = acc1.id, 
                              RecordTypeId = conRTid, 
                              MailingStreet = 'Mailing Street details',
                              Salutation='Mr',
                              MailingPostalCode='hgf 23',
                              sirenum__National_Insurance__c='AA123456A',
                              EEO_Gender__c='M',
                              Birthdate =Date.newInstance(2000, 12, 9)
                             );
        insert conObj;
        
        IP_TopazGlobalClientInformation__c topazClientObj = new IP_TopazGlobalClientInformation__c(
                                                                    name = 'MyClient',
                                                                    IP_StatusID__c = 1,
                                                                IP_SalesLedgerNumber__c  ='1004105'
                                                    );
        insert topazClientObj;
        sirenum__Site__c site = new sirenum__Site__c();
        site.Name = 'testsite';
        site.sirenum__Operating_Company__c= acc1.id;
        site.IP_ClientIDLegacy__c='123';
        site.IP_ClientInvoiceName__c='Test Invoice';
        site.IP_InvoiceAddressStreet__c='Test Street';
        site.IP_PublicSector__c='No';
        site.Status__c = 'Prospect';
        site.GlobalClientName__c= topazClientObj.Id;
        site.sirenum__Postal_Code__c='124678';
        site.sirenum__City__c='New Delhi';
        site.Top_Prospect__c = false;
        site.IP_PublicSector__c='NO';
        //site.IP_MainContact__c=con2.id;
        //site.IP_InvoiceContact__c=con2.id;
        //site.OwnerId=user1.id;
        site.IP_InvoiceAddressCity__c='Delhi';
        site.IP_Timesheet_Method__c='eTimesheet';
        //site.IP_ScheduledAutoApproval__c= true; 
        insert site;

        Inquiry__c inquiry = new Inquiry__c();
        inquiry.Name = 'Test Account Inquiry';
        inquiry.Business_Type__c ='Commercial';
        inquiry.Phone_Number__c = '76757657';
        inquiry.Contact_First_Name__c = 'Test';
        inquiry.Contact_Last_Name__c  = 'Test';
        inquiry.Company_Registration_No__c = '12345678';
        insert inquiry;
        
        Task task= new task();
        task.Subject='Please provide details for your referees';
        task.status='Completed';
        task.WhatId= inquiry.id;
        insert task;
        system.debug('inquiry++++++++'+inquiry);
    }
    
    private static testmethod void NewBusinessPositive(){
        List<Inquiry__c> inquiry = [Select id from Inquiry__c limit 1];
        List<Account> acc = [Select id,Name from Account where Name='Test Account Inquiry' limit 1];
        List<Contact> con = [Select id from Contact limit 1];
        List<sirenum__Site__c> site = [Select id from sirenum__Site__c limit 1];
        String str = JSON.serialize(acc[0]);
        
        ConvertNewBusinessControllerLightning convertNewBuiness = new ConvertNewBusinessControllerLightning();
        ConvertNewBusinessControllerLightning.getNewBusinessDetails(inquiry[0].id);
        ConvertNewBusinessControllerLightning.getAccountOptionValues(inquiry[0].id);
        ConvertNewBusinessControllerLightning.getMatchingAccountList(inquiry[0].id);
        ConvertNewBusinessControllerLightning.ConvertToNewAccount(inquiry[0].id);
        ConvertNewBusinessControllerLightning.ConvertToNewSite(inquiry[0].id,acc[0].id);
        ConvertNewBusinessControllerLightning.getMatchingSitesList(acc[0].id);
        ConvertNewBusinessControllerLightning.getMatchingContactList(inquiry[0].id);
        ConvertNewBusinessControllerLightning.addAccountIdFromLookup(inquiry[0].id,str);
        ConvertNewBusinessControllerLightning.convertNewContact(inquiry[0].id,acc[0].id,'true',site[0].id);
    }
    
    private static testmethod void NewBusinessAccNameDifferent(){
        List<Inquiry__c> inquiry = [Select id from Inquiry__c limit 1];
        List<Account> acc = [Select id from Account where Name='Test Account Inquiry' limit 1];
        acc[0].Name = 'ConvertNeWbusiness';
        update acc;
        List<Contact> con = [Select id from Contact limit 1];

        ConvertNewBusinessControllerLightning convertNewBuiness = new ConvertNewBusinessControllerLightning();
        ConvertNewBusinessControllerLightning.getNewBusinessDetails(inquiry[0].id);
        ConvertNewBusinessControllerLightning.getAccountOptionValues(inquiry[0].id);
        ConvertNewBusinessControllerLightning.getMatchingAccountList(inquiry[0].id);
        ConvertNewBusinessControllerLightning.ConvertToNewAccount(inquiry[0].id);
        ConvertNewBusinessControllerLightning.ConvertToNewSite(inquiry[0].id,acc[0].id);
        ConvertNewBusinessControllerLightning.getMatchingSitesList(acc[0].id);
        ConvertNewBusinessControllerLightning.getMatchingContactList(inquiry[0].id);
    }
    
    private static testmethod void NewBusinessPositive1(){
        List<Inquiry__c> inquiry = [Select id from Inquiry__c limit 1];
        List<Account> acc = [Select id,Name from Account where Name='Test Account Inquiry' limit 1];
        List<Contact> con = [Select id from Contact limit 1];
        List<sirenum__Site__c> site = [Select id from sirenum__Site__c limit 1];
        String str = JSON.serialize(acc[0]);
        
        ConvertNewBusinessControllerLightning convertNewBuiness = new ConvertNewBusinessControllerLightning();
        ConvertNewBusinessControllerLightning.getNewBusinessDetails(inquiry[0].id);
        ConvertNewBusinessControllerLightning.getAccountOptionValues(inquiry[0].id);
        ConvertNewBusinessControllerLightning.getMatchingAccountList(inquiry[0].id);
        ConvertNewBusinessControllerLightning.ConvertToNewAccount(inquiry[0].id);
        ConvertNewBusinessControllerLightning.ConvertToNewSite(inquiry[0].id,acc[0].id);
        ConvertNewBusinessControllerLightning.getMatchingSitesList(acc[0].id);
        ConvertNewBusinessControllerLightning.getMatchingContactList(inquiry[0].id);
        ConvertNewBusinessControllerLightning.addAccountIdFromLookup(inquiry[0].id,str);
        ConvertNewBusinessControllerLightning.convertNewContact(inquiry[0].id,acc[0].id,'false',site[0].id);
    }
}