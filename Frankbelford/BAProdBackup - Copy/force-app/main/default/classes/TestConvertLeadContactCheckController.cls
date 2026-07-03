/**********************************************************************************************
* @Author:         Charu Rani
* @Date:           14/07/2019
* @Description:    Test class for ConvertLeadContactCheckController.
* @Requirement Id: 
* @Test Class:     
* @Revision(s):    [Date] - [Change Reference] - [Changed By] - [Description]
**********************************************************************************************/
@istest
public class TestConvertLeadContactCheckController {
    
    @testSetup 
    static void testDataCreation() {
        //variables
        id acctRTid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Account').getRecordTypeId();
        id conRTid = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact').getRecordTypeId();    
        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false); 
        jsinq__Inquiry__c inqObj = new jsinq__Inquiry__c(Name = 'Test Inquiry',
                                           Business_Type__c ='Commercial',
                                          jsinq__Phone_Number__c = '76757657',
                                          Company_Registration_No__c = '12345678', 
                                          jsinq__Contact_Last_Name__c = 'cLastName', 
                                          jsinq__Contact_First_Name__c = 'cFirstName');
        insert inqObj;
        //insert accounts
        Account accObj = new Account(IP_Business_Type__c ='Catering',
                                          Name = 'Test Account',
                                          Top_Prospect__c = false,
                                          RecordTypeId = acctRTid, 
                                          IP_BusinessIncorporationNumber__c = '12345678');
        insert accObj;
        Contact conObj = new Contact(FirstName = 'cFirstName',
                                          LastName = 'cLastName',
                                          AccountID = accObj.id, 
                                          RecordTypeId = conRTid, 
                                          MailingStreet = 'Mailing Street details',
                                          Salutation='Mr',
                                          MailingPostalCode='hgf 23',
                                          sirenum__National_Insurance__c='AA123456A',
                                          ts2__EEO_Gender__c='M',
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
        site.sirenum__Operating_Company__c= accObj.id;
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
    }
    static testMethod void test1() {
        
        List<jsinq__Inquiry__c> inqObjList= [Select id from jsinq__Inquiry__c limit 1];
        List<Account> accList= [Select id from Account limit 1];
        List<sirenum__Site__c> siteList= [Select id from sirenum__Site__c limit 1];
        //start testing
        test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(inqObjList[0]);
            Test.setCurrentPageReference(new PageReference('Page.ConvertLeadContactCheck'));         
            System.currentPageReference().getParameters().put('id',inqObjList[0].id ); 
            System.currentPageReference().getParameters().put('accId',accList[0].id ); 
            System.currentPageReference().getParameters().put('siteId',siteList[0].id ); 
            ConvertLeadContactCheckController contrl = new ConvertLeadContactCheckController(sc);  
            
            //Test Update
            contrl.checboxSelected = true;
            contrl.ConvertNewContact();
            contrl.Cancel();
        test.stopTest();                   
    }
    
    static testMethod void testNotSelected() {
        
        List<jsinq__Inquiry__c> inqObjList= [Select id from jsinq__Inquiry__c limit 1];
        List<Account> accList= [Select id from Account limit 1];
        List<sirenum__Site__c> siteList= [Select id from sirenum__Site__c limit 1];
        //start testing
        test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(inqObjList[0]);
            Test.setCurrentPageReference(new PageReference('Page.ConvertLeadContactCheck'));         
            System.currentPageReference().getParameters().put('id',inqObjList[0].id ); 
            System.currentPageReference().getParameters().put('accId',accList[0].id ); 
            System.currentPageReference().getParameters().put('siteId',siteList[0].id ); 
            ConvertLeadContactCheckController contrl = new ConvertLeadContactCheckController(sc);  
            
            //Test Update
            contrl.checboxSelected = false;
            contrl.ConvertNewContact();
            contrl.Cancel();
        test.stopTest();                   
    }
    
}