@isTest(SeeAllData=true)

public class Test_PortalDetailsController {
static testMethod void testMethod1()
        
    {

    Profile Prof=[SELECT Id FROM Profile WHERE Name='System Administrator' limit 1];
        
       // insert new IP_ImpellamGDPRSettings__c (Name='Impellam GDPR settings',IP_ActivityTypesThatQualifyAsContact__c='Visit,Registration,General Call ,Send Email ,Send Contract',IP_UnworkedCandidateDataRetentionPeriod__c=-10);
                    //insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);

        User user = new User();
        
        DateTime dt2 = DateTime.newInstance(2017, 6, 23, 4, 2, 3);
        
        Long gettime = dt2.getTime();
        
        user.LastName = 'Data1';
        
        user.FirstName='TestUser';
        
        user.Alias = 'TstUrD';
        
        user.Email = 'abc.efg@GHI.com';
        
        user.Username = 'Email'+gettime+'@js.com.uk';
        
        user.ProfileId = Prof.id;
        
        user.TimeZoneSidKey = 'GMT';
        
        user.LanguageLocaleKey = 'en_US';
        
        user.EmailEncodingKey = 'UTF-8';
        
        user.LocaleSidKey = 'en_US';
        
        user.IP_TempestDepartment__c='7062';
        
        user.IP_TempestID__c='1084675';
        
        user.IP_TempestDivision__c='NTS';
        
        user.Department='1069';
        
        user.IP_PassToTempest__c=true;
        
        //insert user;
        
        //system.runas(user)
        //{
        
        
        Account acc1 = new Account();
        
        RecordType accountRec = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Client'];
        
        acc1.name='TestAccountuudu1';
        
        acc1.Phone='012034563433';
        
        acc1.BillingStreet='Street1';
        
        acc1.IP_Business_Type__c='catering';
        
        acc1.BillingCity ='City1';
        
        acc1.BillingPostalCode = '101911';
        
        acc1.BillingState='State1';
        
        acc1.BillingCountry='Country1';
        
        acc1.RecordTypeId=accountRec.id;
        
        insert acc1;
        
        
        
        
        
        
        
        Account acc = new Account();
        
        RecordType accountRec1 = [Select Id From RecordType Where sObjectType = 'Account' And DeveloperName = 'Candidate'];
        
        acc.Name='Candidatesaccount';
        
        acc.RecordTypeId=accountRec1.id;
        
        acc.Phone='012034563436';
        
        acc.BillingStreet='Street2';
        
        acc.BillingCity ='City2';
        
        acc.BillingPostalCode = '101912';
        
        acc.BillingState='State2';
        
        acc.BillingCountry='Country2';
        
        insert acc;
        
        system.debug('Account Inserted');
        
        
        
        Recordtype recType = [Select id from Recordtype where sobjecttype='contact' and Name='Contact'];
        
        contact con2 = new contact();
        
        con2.RecordTypeId=recType.id;
        
        con2.AccountId=acc1.id;
        
        con2.FirstName='Test contact';
        
        con2.LastName='Data';
        
        con2.IP_ContactType__c='Invoice Contact';
        
        insert con2;
        
        
        RecordType contRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
        
        List<Contact> testContacts = new List<Contact>();
        for ( Integer i = 0 ; i < 6 ; i++ )
        {
            Contact contact = new Contact( Firstname='Test'+i,
                                          
                                          Lastname='Candidate'+i,
                                          
                                          accountId=acc.Id,
                                          
                                          Person_Status__c='Active',
                                          
                                          IP_CategoryOfWork__c='Catering',
                                          
                                          IP_GDPRWorkedCandidate__c=False,
                                          
                                          IP_LastContactedGDPR__c=Null,
                                          
                                          RecordTypeId=contRec.Id);
            
            
            testContacts.add(contact);
            
        }
        insert testContacts;
		//insert new IP_Shift_Template__c(name = '1062', IP_Branch_City__c = 'test1',IP_Branch_Country__c='count1',IP_Branch_County__c='count2',IP_Branch_Postal_Code__c='1234',Branch_Address__c='street1',Email__c='singh.taji26@gmail.com',Fax__c='123456',Phone__c='54735622',IP_Site_Name__c='Name1');

        
        Test.startTest();
        
        PortalDetailsController VF = new PortalDetailsController();
        VF.recipient_Id=testContacts[1].id;
        
        Contact Con = VF.getConDetails();
        
        
        Test.stopTest();
        //}
    }  
}