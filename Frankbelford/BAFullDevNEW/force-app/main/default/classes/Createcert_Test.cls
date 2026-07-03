@isTest
public class Createcert_Test {
    
    @testSetup
    Static void consetup()
    {
        Profile Prof=[SELECT Id FROM Profile WHERE Name='System Administrator' limit 1];
        User testuser = new User(
            ProfileId = Prof.Id,
            Username = System.now().millisecond() + 'test2@test.com',
            Alias = 'batman',
            Email='bruce.wayne@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        
        insert testuser;
        Account account1 = TestDataFactory.createCandidateAccount(1)[0]; 
        insert account1; 
        system.debug('inserted acc----->' +account1);
        insert new DefaultAccounts__c (Name='Candidates',Account_Id__c=account1.Id);
        insert new Payroll_Swtich__c (Name='Stoppayroll',Batch_check__c=false);
        RecordType contRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
        Contact cand = new Contact( Firstname='Test1',                                        
                                   Lastname='Candidate1',
                                   IP_CategoryOfWork__c='Catering',
                                   RecordTypeId=contRec.Id);
        
        insert cand;
        RecordType contRec1 = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
        Contact cand1 = new Contact( Firstname='Test',                                        
                                    Lastname='Candidate',
                                    accountId=account1.Id,
                                    Person_Status__c='Active',
                                    IP_CategoryOfWork__c='Catering',
                                    RecordTypeId=contRec1.Id);
        
        insert cand1;

        
        
        sirenum__TicketType__c competency = new sirenum__TicketType__c();
        competency.Name='LGV D1 Licence';
        competency.sirenum__Expires__c=true;
        competency.sirenum__Requires_Proof__c=true;
        insert competency;
        
        sirenum__TicketType__c competency2 = new sirenum__TicketType__c();
        competency2.Name='ADR';
        competency2.sirenum__Expires__c=true;
        competency2.sirenum__Requires_Proof__c=true;
        insert competency2;
        
        sirenum__TicketType__c competency1 = new sirenum__TicketType__c();
        competency1.Name='PCV Licence';
        competency1.sirenum__Expires__c=true;
        competency1.sirenum__Requires_Proof__c=true;
        insert competency1;
        
        id certId = Schema.SObjectType.Certification__c.getRecordTypeInfosByName().get('Driving Licence').getRecordTypeId();
        Certification__c cert = new Certification__c();
        cert.Contact__c = cand.id;
        cert.RecordTypeId = certId;
        cert.Valid_From__c = System.today();
        cert.Valid_To__c = System.today().addDays(10);
        cert.Verfied__c = false;
        insert cert;
        
        
    }
    public static testmethod void updatecertificate()
    {          
        Test.startTest();
        
        Certification__c cert = [select id,Verfied__c,Class_ADR_C1_Small_Lorries_7_5_tonnes__c,Class_ADR_C_Large_Lorries__c,Class_C_HIAB__c,Class_ADR_C1_E_Small_Lorry_Trailer__c,Class_B_Car_Van__c,Class_C1_Small_Lorries_7_5_tonnes__c,Class_C_Large_Lorries__c
                                      ,Class_D_Minibus__c,PCV_Licence__c,Class_D_Bus_Coach__c,Class_C1_E_Small_Lorry_Trailer__c,Class_C_E_102_Draw_Bar_Only__c,Class_C_E_Articulated_Lorry__c ,Standard__c from Certification__c where RecordType.name='Driving Licence'];
        
        cert.Verfied__c = TRUE;
        cert.Class_ADR_C1_Small_Lorries_7_5_tonnes__c = TRUE;
        cert.Class_B_Car_Van_Expiry_Date__c = system.today();
        cert.Class_ADR_C_Large_Lorries__c = TRUE;
        cert.Class_C_HIAB__c = TRUE;
        cert.Class_ADR_C1_E_Small_Lorry_Trailer__c = TRUE;
        cert.Class_B_Car_Van__c = TRUE;
        cert.Class_C1_Small_Lorries_7_5_tonnes__c = TRUE;
        cert.Class_C_Large_Lorries__c = TRUE;
        cert.Class_D_Minibus__c = TRUE;
        cert.PCV_Licence__c=true;
        cert.Class_D_Bus_Coach__c = TRUE;
        cert.Class_C1_E_Small_Lorry_Trailer__c = TRUE;
        cert.Class_C_E_102_Draw_Bar_Only__c = TRUE;
        cert.Class_C_E_Articulated_Lorry__c = TRUE;
        cert.Standard__c = TRUE;
        cert.ADR__c = TRUE;
        cert.ADR_Expiry_Date__c = system.today();
        cert.Class_C_E_102_Restriction_Expiry_Date__c = system.today();
        cert.Class_C_E_Articulated_Lorry_Expiry_Date__c = system.today();
        cert.Class_C1_Small_Lorries_Expiry_Date__c = system.today();
        cert.Class_C_Large_Lorries_Expiry_Date__c = system.today();
        cert.Class_D1_Minibus_Expiry_Date__c = system.today();
        cert.Class_D_Bus_Coach_Expiry_Date__c = system.today();
        cert.Class_Small_Lorry_Trailer_Expiry_Date__c = system.today();
        cert.CPC__c = TRUE;
        cert.CPC_Expiry_Date__c = system.today();
        cert.Digicard__c = TRUE;
        cert.Digicard_Expiry_Date__c = system.today();
        cert.Class_B_Car_Van_Expiry_Date__c = system.today();
        cert.HIAB__c = TRUE;
        cert.HIAB_Expiry_Date__c = system.today();
        cert.Other_Licence_Expiry_Date__c = system.today();
        cert.PCV__c = TRUE;
        cert.PCV_Expiry_Date__c = system.today();
        update cert;
        
        Test.stopTest();
    }
  
}