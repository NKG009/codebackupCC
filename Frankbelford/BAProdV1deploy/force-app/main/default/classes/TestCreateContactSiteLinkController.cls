@isTest
public class TestCreateContactSiteLinkController {

    public static testmethod void sitedetails1(){
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 

        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc1;
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
        RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
        Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
        insert maincon;

        IP_TopazGlobalClientInformation__c topaz = TestDataFactory.createTopaz(1)[0];
        topaz.IP_PaymentTerms__c = 123456789123456.0;
        insert topaz;

        sirenum__Site__c site = new sirenum__Site__c();         
        site.Name = 'testsite';
        site.sirenum__Operating_Company__c= acc1.id;
        site.IP_ClientIDLegacy__c='123';
        site.IP_ClientInvoiceName__c = 'test abc';
        site.IP_PublicSector__c = 'No';
        site.IP_InvoiceContactText__c = 'Contact 1';
        site.IP_MainContact__c = maincon.id;
        site.sirenum__Street_Address__c = 'Street1';
        site.sirenum__City__c = 'City 1';
        site.IP_InvoiceAddressCountry__c = 'UK';
        site.sirenum__Postal_Code__c = 'ABC1234';
        site.IP_InvoiceContactEmail__c = 'test@abc.com';
        site.IP_InvoiceAddressStreet__c = 'Street2';
        site.IP_InvoiceAddressCity__c= 'City2';
        site.IP_InvoiceAddressPostcode__c= 'XYZ';
        insert site;
        
        PageReference pageRef = Page.CreateContactSiteLink;
        pageRef.getparameters().put('Id', maincon.id);
        Test.setCurrentPage(pageRef);
        
        Contact_Site_link__c sitecontactLink = new Contact_Site_link__c();

        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(site);
        CreateContactSiteLinkController sitelink = new CreateContactSiteLinkController(sc);
        CreateContactSiteLinkController.getSiteContactLink(maincon.id);
        CreateContactSiteLinkController.saveNewRecord(sitecontactLink,site.Id);
        sitelink.cancelRecord();
        Test.stopTest();

    }
    
    public static testmethod void sitedetails2(){
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Account']; 

        Account acc1 = new Account(Name='Capita',RecordTypeId=accountRec1.id);
        insert acc1;
        Account acc2 = new Account(Name='Rate Card Account1111',RecordTypeId=accountRec1.id);
        insert acc2;
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
        RecordType maincondRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Contact'];
        Contact maincon = new Contact(RecordTypeId=maincondRec.id,FirstName='Test',LastName= 'Main COntact', AccountID=acc1.id);
        insert maincon;

        IP_TopazGlobalClientInformation__c topaz = TestDataFactory.createTopaz(1)[0];
        topaz.IP_PaymentTerms__c = 123456789123456.0;
        insert topaz;

        sirenum__Site__c site = new sirenum__Site__c();         
        site.Name = 'testsite';
        site.sirenum__Operating_Company__c= acc1.id;
        site.IP_ClientIDLegacy__c='123';
        site.IP_ClientInvoiceName__c = 'test abc';
        site.IP_PublicSector__c = 'No';
        site.IP_InvoiceContactText__c = 'Contact 1';
        site.IP_MainContact__c = maincon.id;
        site.sirenum__Street_Address__c = 'Street1';
        site.sirenum__City__c = 'City 1';
        site.IP_InvoiceAddressCountry__c = 'UK';
        site.sirenum__Postal_Code__c = 'ABC1234';
        site.IP_InvoiceContactEmail__c = 'test@abc.com';
        site.IP_InvoiceAddressStreet__c = 'Street2';
        site.IP_InvoiceAddressCity__c= 'City2';
        site.IP_InvoiceAddressPostcode__c= 'XYZ';
        insert site;
        
        PageReference pageRef = Page.CreateContactSiteLink;
        pageRef.getparameters().put('Id', maincon.id);
        Test.setCurrentPage(pageRef);
        
        Contact_Site_link__c sitecontactLink = new Contact_Site_link__c();
        sitecontactLink.Account__c = acc2.id;

        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(site);
        CreateContactSiteLinkController sitelink = new CreateContactSiteLinkController(sc);
        CreateContactSiteLinkController.getSiteContactLink(maincon.id);
        CreateContactSiteLinkController.saveNewRecord(sitecontactLink,site.Id);
        sitelink.cancelRecord();
        Test.stopTest();

    }
}