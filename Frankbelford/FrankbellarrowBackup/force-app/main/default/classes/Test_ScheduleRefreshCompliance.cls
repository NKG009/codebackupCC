@istest
public class Test_ScheduleRefreshCompliance {

    static testMethod void updateContact() {
       
        Account acc1 = TestDataFactory.create2ndTierSupplierAccount(1)[0];
        insert acc1;
        
        Account acc2 = TestDataFactory.createCandidateAccount(1)[0];
        insert acc2;
        
         insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        //Inserting Payroll records
        insert new Payroll_Swtich__c(Name='Stoppayroll',Batch_check__c=false);
        Contact con1 = TestDataFactory.createCandidate(acc2.id,1)[0];
        con1.smagicinteract__SMSOptOut__c = true;
        con1.Phone = '+447890789065';
        insert con1;
        
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
		Contact con2 = TestDataFactory.createCandidate2ndTier(acc1.id,1)[0];
        con2.smagicinteract__SMSOptOut__c = true;
        con2.Phone = '+447890789065';
        insert con2;
        
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         
        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
        Contact con3 = new Contact();
        con3.FirstName = 'TestManish';
        con3.Lastname = 'TestName';
        con3.email = 'abc@nhg.com';
        con3.AccountID = acc2.id;
        con3.Recordtypeid = condRec.id;
        con3.IP_CategoryOfWork__c = 'Catering'; 
        con3.smagicinteract__SMSOptOut__c = true;
        con3.Phone = '+447890789065';
        insert con3;
        
        Test.startTest();
        ScheduleRefreshCompliance sh2 = new ScheduleRefreshCompliance();
        String sch = '0 0 23 * * ?';
        system.schedule('Test PCompliance Sync', sch, sh2);
        Test.stopTest();
    }
        static testMethod void updateContact1() {
       
        Account acc1 = TestDataFactory.create2ndTierSupplierAccount(1)[0];
        insert acc1;
        
        Account acc2 = TestDataFactory.createCandidateAccount(1)[0];
        insert acc2;
        
         insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
            //Inserting Payroll records
        insert new Payroll_Swtich__c(Name='Stoppayroll',Batch_check__c=false);
        Contact con1 = TestDataFactory.createCandidate(acc2.id,1)[0];
        con1.smagicinteract__SMSOptOut__c = true;
        con1.Phone = '+447890789065';
        insert con1;
        
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
		Contact con2 = TestDataFactory.createCandidate2ndTier(acc1.id,1)[0];
        con2.smagicinteract__SMSOptOut__c = true;
        con2.Phone = '+447890789065';
        insert con2;
        
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
         
        RecordType condRec = [Select Id  From RecordType Where sObjectType = 'Contact' And DeveloperName= 'Candidate'];
        Contact con3 = new Contact();
        con3.FirstName = 'TestManish';
        con3.Lastname = 'TestName';
        con3.email = 'abc@nhg.com';
        con3.AccountID = acc2.id;
        con3.Recordtypeid = condRec.id;
        con3.IP_CategoryOfWork__c = 'Catering';
        con3.IP_IsInvoicecontact__c=true;
        con3.smagicinteract__SMSOptOut__c = true;
        con3.Phone = '+447890789065';
        insert con3;
            
             sirenum__Site__c site = new sirenum__Site__c();
         
         site.Name = 'testsite';
         site.sirenum__Operating_Company__c= acc2.id;
         site.IP_ClientIDLegacy__c='123';
       // site.GlobalClientName__c=globalclient.id;
        site.IP_ClientInvoiceName__c='Testclient';
        site.IP_InvoiceAddressStreet__c='101';
        site.IP_InvoiceAddressCity__c = 'Delhi';
        site.IP_InvoiceAddressPostcode__c = '110035';
        
        site.IP_InvoiceContact__c = con3.id;
        site.IP_MainContact__c = con3.id;
        site.IP_PublicSector__c = 'No';
         insert site;
               
         sirenum__ProActiveContract__c contract = new sirenum__ProActiveContract__c();
         
         contract.Name                 = 'test contract';
         contract.sirenum__Client__c   = acc2.id;
         contract.sirenum__Employee__c = con1.id;
         
         insert contract;
            
             sirenum__Rota__c sector = new sirenum__Rota__c();
         
         sector.Name = 'new sector';
         insert sector;
         
         sirenum__Job_Type__c jobtype = new sirenum__Job_Type__c();
         jobtype.name = 'testjobtype';
         jobtype.Impellam_Sector__c = sector.id;
         jobtype.Impellam_Core_Category__c = 'Administration -ADM';
         jobtype.Impellam_Job_Category__c ='Administrator -OA001';
         
         insert jobtype;
            
             sirenum__Team__c jobroll = new sirenum__Team__c();
         
         jobroll.name = 'testjobroll';
         jobroll.sirenum__Account__c = contract.id; 
         jobroll.sirenum__Job_Type__c = jobtype.id;
         jobroll.IP_OPWIPSRole__c = 'No';
         insert jobroll;
        
          sirenum__Placement__c spleacement = new sirenum__Placement__c();
         
                 spleacement.Name = 'testing placment';
                 spleacement.sirenum__Contact__c = con3.id;
                spleacement.sirenum__Start_Date__c =  System.today();
                 spleacement.sirenum__End_Date__c= System.today()+60;//Date.newInstance(2025,03,30);
                 spleacement.sirenum__Contract__c = contract.id;
                 spleacement.sirenum__Job_Role__c = jobroll.id;
                 spleacement.sirenum__Site__c = site.Id;
                 spleacement.sirenum__Status__c   = 'Active';
             //    spleacement.IP_PayMethod__c = payprofile.id;
                 spleacement.IP_Consultant1PercentageSplit__c=100;
                 spleacement.IP_PassToTempest__c=true;
                 insert spleacement;
               
            
        Test.startTest();
        RefreshComplianceForActiveCandidate sh1 = new RefreshComplianceForActiveCandidate  ();
        database.executebatch(sh1,5);
        sh1.fakeMethod();
        Test.stopTest();
        

        
    }

}