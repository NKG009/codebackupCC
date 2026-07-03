@isTest
public class Test_CommBackgroundVerify{
   @testSetup static void dataSetUp(){ 

        Account acc = TestDataFactory.createClients(1)[0]; 
        insert acc; 
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        Contact c = new Contact();
        c.FirstName='Con';
        c.lastName='Test Contact';
        c.IP_CategoryOfWork__c='Industrial';
        c.sirenum__National_Insurance__c='AA123456A';
        c.P45_Date_by_Head_Office__c=system.today();
        c.AccountID=acc.id;
        insert c;
        
        insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType = 'IP_PayProfile__c' AND DeveloperName = 'PAYE'];
       
        IP_PayProfile__c pay= new IP_PayProfile__c();
        pay.RecordTypeId=rt.id;
        pay.IP_PayrollID__c='Testpayrol';
        pay.IP_Status__c='Inactive';
        pay.IP_Candidate__c=c.Id;
        pay.IP_CompanyRegNo__c='12345678';
        pay.IP_VATRegistered__c=true;
        pay.IP_VATNumber__c='123456789';
        pay.P45_Initiated__c=true;
        pay.IP_LastPassedTotempest__c = Date.newInstance(2017, 01, 01);
        pay.IP_Payroll_Leaver__c = 'PL';
        insert pay;
        
        id certId = Schema.SObjectType.Certification__c.getRecordTypeInfosByName().get('Community Background Check (NI Only)').getRecordTypeId();
        Certification__c cert = new Certification__c();
        cert.Contact__c = c.id;
        cert.RecordTypeId = certId;     
        insert cert;
        
        Certification__c cert1 = new Certification__c();
        cert1.Contact__c = c.id;
        cert1.RecordTypeId = certId;    
        cert1.Community_Background__c = 'Not Either';           
        insert cert1;
       
       Certification__c cert2 = new Certification__c();
        cert2.Contact__c = c.id;
        cert2.RecordTypeId = certId;    
        cert2.Community_Background__c = 'Not Either';
       cert2.Method_of_Determination__c = 'Direct';
        insert cert2;
       
        Certification__c cert3 = new Certification__c();
        cert3.Contact__c = c.id;
        cert3.RecordTypeId = certId;    
        cert3.Community_Background__c = 'Not Either';
        cert3.Method_of_Determination__c = 'Direct';
        cert3.SOC__c = 'SOC 1 – Managers and senior officials';
        insert cert3;
        
        
        id certIdEqualOpps = Schema.SObjectType.Certification__c.getRecordTypeInfosByName().get('Equal Opportunities Question').getRecordTypeId();
        Certification__c cert4 = new Certification__c();
        cert4.Contact__c = c.id;
        cert4.RecordTypeId = certIdEqualOpps;    
        cert4.Gender__c = 'Female';
        cert4.Date_Of_Birth__c = System.today().addmonths(-3);
        insert cert4;

        
        }
        
        @istest static void BatchHeaderclassmethod1(){      
        Certification__c listcert = [Select id from Certification__c where RecordType.Name = 'Community Background Check (NI Only)' limit 1];
        listcert.IP_Status__c = 'Current';
        update listcert;
        Test.startTest();
        CommBackgroundVerifyLapseCertification.getCertificationVerified(listcert.id);
        
        Test.stopTest();
    }
    @istest static void BatchHeaderclassmethod2(){      
        Certification__c listcert = [Select id from Certification__c where RecordType.Name = 'Community Background Check (NI Only)' and Community_Background__c = 'Not Either' limit 1];
        listcert.IP_Status__c = 'Current';
        update listcert;
        Test.startTest();
        CommBackgroundVerifyLapseCertification.getCertificationVerified(listcert.id);
        CommBackgroundVerifyLapseCertification.getCertificationLapsed(listcert.id);
        Test.stopTest();
    }
    @istest static void BatchHeaderclassmethod3(){      
        Certification__c listcert = [Select id from Certification__c where RecordType.Name = 'Community Background Check (NI Only)' and Community_Background__c = 'Not Either' limit 1];
        listcert.IP_Status__c = 'Lapsed';
        update listcert;
        Test.startTest();
        CommBackgroundVerifyLapseCertification.getCertificationVerified(listcert.id);
        CommBackgroundVerifyLapseCertification.getCertificationLapsed(listcert.id);
        Test.stopTest();
    }
    @istest static void BatchHeaderclassmethod4(){      
        Certification__c listcert = [Select id from Certification__c where RecordType.Name = 'Community Background Check (NI Only)' and Method_of_Determination__c != '' limit 1];
        listcert.Verfied__c = TRUE;
        listcert.IP_Status__c = 'Current';
        update listcert;
        Test.startTest();
        CommBackgroundVerifyLapseCertification.getCertificationVerified(listcert.id);
        Test.stopTest();
    }
     
    @istest static void BatchHeaderclassmethod5(){      
        Certification__c listcert = [Select id from Certification__c where RecordType.Name = 'Community Background Check (NI Only)' and SOC__c != '' limit 1];
        listcert.Verfied__c = TRUE;
       // listcert.IP_Status__c = 'Current';
        update listcert;
        Test.startTest();
        CommBackgroundVerifyLapseCertification.getCertificationVerified(listcert.id);
        Test.stopTest();
    }
    
    @istest static void BatchHeaderclassmethod6(){      
        Certification__c listcert = [Select id from Certification__c where RecordType.Name = 'Equal Opportunities Question' limit 1];
        listcert.Verfied__c = TRUE;
       // listcert.IP_Status__c = 'Current';
       try{
            update listcert;
       }
       catch(Exception e){
           
       }
        Test.startTest();
        CommBackgroundVerifyLapseCertification.getCertificationVerified(listcert.id);
        Test.stopTest();
    }
}