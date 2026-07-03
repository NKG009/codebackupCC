@isTest
public class DeletionActionTestClass {
    @testSetup 
    static void appSetup() {
        // Profile Prof=[SELECT Id FROM Profile WHERE Name='JS Recruiter - Hybrid' limit 1];
        insert new IP_ImpellamGDPRSettings__c (Name='Impellam GDPR settings',IP_ActivityTypesThatQualifyAsContact__c='Visit,Registration,General Call ,Send Email ,Send Contract',IP_UnworkedCandidateDataRetentionPeriod__c=-10);
        Account acc1 = new Account();
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Client'];
        acc1.name='TestAccount1';
        acc1.Phone='012034563433';
        acc1.BillingStreet='Street1';
        acc1.IP_Business_Type__c='catering';
        acc1.BillingCity ='City1';
        acc1.BillingPostalCode = '101911';
        acc1.BillingState='State1';
        acc1.BillingCountry='Country1';
        acc1.RecordTypeId=accountRec.id;
        insert acc1;
        system.debug('Account Inserted');
        Account acc = new Account();
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate'];
        acc.Name='Candidates';
        acc.RecordTypeId=accountRec1.id;
        acc.Phone='012034563436';
        acc.BillingStreet='Street2';
        acc.BillingCity ='City2';
        acc.BillingPostalCode = '101912';
        acc.BillingState='State2';
        acc.BillingCountry='Country2';
        insert acc;
        system.debug('Account Inserted');
        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);
        
        Recordtype recType = [Select id from Recordtype where sobjecttype='contact' and Name='Contact'];
        contact con2 = new contact();
        con2.RecordTypeId=recType.id;
        con2.AccountId=acc1.id;
        con2.FirstName='Test';
        con2.LastName='Data';
        con2.IP_ContactType__c='Invoice Contact';
        insert con2;
        
        RecordType contRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
        List<Contact> testContacts = new List<Contact>();
        // for ( Integer i = 0 ; i < 6 ; i++ )
        //{
        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);
        
        Contact contact = new Contact( Firstname='Test',                                  
                                      Lastname='Candidate',                                          
                                      accountId=acc.Id,                                          
                                      Person_Status__c='Active',                                          
                                      IP_CategoryOfWork__c='Catering',                                          
                                      IP_GDPRWorkedCandidate__c=False,                                          
                                      IP_LastContactedGDPR__c=Null, 
                                      IP_MarkedForDeletion__c=True,
                                      RecordTypeId=contRec.Id);           
        
        testContacts.add(contact);
        //}
        insert testContacts;
        system.debug('test data factory  Candidate--'+testContacts);
        
        
    }
    public static testmethod void tempmethod1()
    {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorGDPR());  
        insert new LoginToken__c(name = 'Token1', Token__c = '');
        Database.executeBatch(new DeletionAction(),1);
        
    }
    public static testmethod void tempmethod2()
    {
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorGDPR());  
        insert new LoginToken__c(name = 'Token1', Token__c = '3Hgv5+x/u9h1aFcofh+aImPY1E9/4yI92oUgod/srIJxyO1+JVcJe/M8Ng60UUMFQEl1zlJpui31BrmdITq0LgM8e3SRLJXFb1outdGHYJ/hlKgEJvQyX1ZdUG229o5wkpu5TKfkawA8rG3q3XagXys6BmDo5ldAD6FvZZFEwqOLKe49elVrKkMxqLftivgAypj1/ViI6iBjm+uPv9y63w==N2I=');
        Database.executeBatch(new DeletionAction(),1);
        
    }
    public static testmethod void tempmethod2Fail()
    {
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorGDPR1());  
        insert new LoginToken__c(name = 'Token1', Token__c = 'GasdfasdaLK9oxhwEZHQ3pkFjPtUCyv2nHwTdtBvALDhjMv9NNukgwh1VwLWDZr7g4S880AXGICxOSIfFzhxAXogb3T9VpuA8ShaX5WT274KWv7mbq9qGf0tIxx+QqHNxSB85wPXQIpRBZdY2W/rVpAWfoMzeJwPqKBQEMDZbg3cyiU/B840wRrsV+Im0BMDM=');
        Database.executeBatch(new DeletionAction(),1);
        
    }
    public static testmethod void TempScheduleMethod1()
    {
        insert new LoginToken__c(name = 'Token1', Token__c = '3Hgv5+x/u9h1aFcofh+aImPY1E9/4yI92oUgod/srIJxyO1+JVcJe/M8Ng60UUMFQEl1zlJpui31BrmdITq0LgM8e3SRLJXFb1outdGHYJ/hlKgEJvQyX1ZdUG229o5wkpu5TKfkawA8rG3q3XagXys6BmDo5ldAD6FvZZFEwqOLKe49elVrKkMxqLftivgAypj1/ViI6iBjm+uPv9y63w==N2I=');
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());  
        
        DeletionAction deleteCandidate = new DeletionAction();
        String sch = '0 0 23 * * ?'; 
        system.schedule('TempGreaterthen6months', sch, deleteCandidate); 
        
        
    }
}