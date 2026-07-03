@isTest
public class Test_AssignmentEmergencyLightning {
    
    @testsetup
    static void splacementDetails(){
        Account client = TestDataFactory.createClients(1)[0]; 
        Insert client;

        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c(name = 'Stoppayroll', Batch_check__c = false);
        Contact cont = TestDataFactory.createContact(client.id, 1)[0];
        Insert cont;

        Account clientacc = TestDataFactory.createCandidateAccount(1)[0]; 
        Insert clientacc;

        Contact candidate = TestDataFactory.createCandidate(clientacc.id, 1)[0];
        Insert candidate;

        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        id payRTId = Schema.SObjectType.IP_PayProfile__c.getRecordTypeInfosByName().get('LTD').getRecordTypeId();
        IP_PayProfile__c payprofile = new IP_PayProfile__c();
        payprofile.RecordTypeId = payRTId;

        payprofile.IP_Candidate__c = candidate.id;
        payprofile.IP_CompanyName__c='sfdc';
        payprofile.IP_Status__c = 'Active'; 
        payprofile.IP_CompanyRegNo__c  = 'ad123456';
        payprofile.IP_VATNumber__c     = '123456789';
        payprofile.IP_PayrollID__c  = 'testpaynew';
        payprofile.IP_VATRegistered__c=true;
        payprofile.IP_OkToSupply__c=1;
        payprofile.IP_BusinessAddressLine1__c='test address 1';
        payprofile.IP_BusinessAddressLine2__c='test address 2';
        payprofile.IP_BusinessAddressTown__c='town city';
        payprofile.IP_BusinessAddressPostcode__c='12345678';
        payprofile.IP_PayFrequency__c='Weekly';
        payprofile.IP_PaymentType__c='BACS';
        payprofile.IP_PassToTempest__c=true;
        payprofile.IP_BankAccountName__c = 'Test name1';
        payprofile.IP_AccountNumber__c = '98567497';
        payprofile.IP_SortCode__c = '645362';

        insert payprofile; 

        sirenum__ProActiveContract__c pac = TestDataFactory.sirenumProActiveContract(client.Id, candidate.Id, 1)[0];
        Insert pac;

        sirenum__Rota__c sector = TestDataFactory.createSector(1)[0]; 
        Insert sector;

        sirenum__Job_Type__c jobType =TestDataFactory.createJobType(sector.id, 1)[0];
        Insert jobType;

        sirenum__Team__c jrole = TestDataFactory.createJobRole(pac.Id, jobType.Id, 1)[0]; 
        Insert jrole;

        Profile p = [SELECT Id FROM Profile where name='System Administrator'];
        User usr = TestDataFactory.createUsers(p.Id,1)[0];
		usr.IP_TempestDepartment__c='1062';
        usr.username = 'nbsnkh.loi@bvc.com';
        insert usr; 

        IP_TopazGlobalClientInformation__c tpz = TestDataFactory.createTopaz(1)[0]; 
        insert tpz;    

        sirenum__Site__c ssite = TestDataFactory.createSites(client.id,tpz.id,1)[0];
        insert ssite;

        sirenum__Placement__c splace = TestDataFactory.createSPlacement1(candidate.Id, pac.Id, jrole.Id,usr.Id, 1)[0];
       // splace.IP_PayMethod__c = payprofile.id;
        splace.sirenum__Site__c  = ssite.id;
        Insert splace;
    }

    public static testmethod void sPlacementDetailsUpdate(){
        List<sirenum__Placement__c> listSplacement = [Select id from sirenum__Placement__c limit 1];
        Test.startTest();
        AssignmentEmergencyControllerLightning.sPlacementDetailsUpdate(listSplacement[0].id);
        Test.stopTest();     
    }
    
    public static testmethod void sPlacementHybridUser(){
        Profile p1 = [SELECT Id,name FROM Profile where name='JS Recruiter - Hybrid'];
        system.debug('PROFILE NAME ----------------------'+p1.Name);
        User usr1 = new User(LastName = 'himanshu',FirstName='JASON',Alias = 'jliv1',Email = 'mm1.sf@outlook.com',
                                Username = 'dummyEmail991'+'@email.com', ProfileId = p1.Id, TimeZoneSidKey = 'GMT',
                                LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8', LocaleSidKey = 'en_US',IP_TempestDepartment__c='1062',
                                IP_TempestDivision__c='NTS'); 
        List<sirenum__Placement__c> listSplacement = [Select id from sirenum__Placement__c limit 1];
        Test.startTest();
        System.runAs(usr1){
            AssignmentEmergencyControllerLightning.sPlacementDetailsUpdate(listSplacement[0].id);
        }
        Test.stopTest();     
    }
}