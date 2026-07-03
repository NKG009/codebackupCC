@isTest
private class Test_CertificationConfirmAttachment {
    
    static testMethod void MyTest()
    { 
        
        RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType = 'ts2__Certification__c' AND Name = 'Right to Work'];
        
        Account account = TestDataFactory.createCandidateAccount(1)[0]; 
        insert account; 
        
          insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        Contact cont = TestDataFactory.createCandidate(account.id, 1)[0];
        insert cont;
        
        ts2__Certification__c certificate = new ts2__Certification__c();
        certificate.ts2__Contact__c=cont.id;
        certificate.RecordTypeId=rt.Id;
        insert certificate;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(certificate);
        CertificationConfirmAttachment e = new CertificationConfirmAttachment(sc);
        system.assert(e != null);
        
        Test.startTest();
        certificate.Verfied__c=true;
        if(certificate.Verfied__c==true){
            certificate.IP_Original_Seen_on__c=true;
        }else{
            certificate.IP_Original_Seen_on__c=false;
        }
        e.save();
        
        PageReference pageRef = Page.CertificationConfirmAttachment;
        pageRef.getparameters().put('id', certificate.id);
        Test.setCurrentPage(pageRef);
        
        
        Apexpages.StandardController sc1 = new Apexpages.StandardController(certificate);
        CertificationConfirmAttachment ext = new CertificationConfirmAttachment(sc1);    
        ext.Cancel();   
        
        
        CertificationVerifyAttachment__c setting = new CertificationVerifyAttachment__c();
        setting.Name = 'Right to Work';
        insert setting;
        String recordTypeName = [SELECT Name from Recordtype where ID=:certificate.RecordTypeId].Name;      
        CertificationConfirmAttachment testAccPlan = new CertificationConfirmAttachment(sc);
        testAccPlan.getSettings();
        
        test.stopTest();
        
    } 
    
    static testMethod void MyTest2()
    { 
        
        RecordType rt=[SELECT Id FROM RecordType WHERE SobjectType = 'ts2__Certification__c' AND Name = 'Right to Work'];
        
        Account account = TestDataFactory.createCandidateAccount(1)[0]; 
        insert account; 
        
          insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        Contact cont = TestDataFactory.createCandidate(account.id, 1)[0];
        insert cont;
        
        ts2__Certification__c certificate = new ts2__Certification__c();
        certificate.ts2__Contact__c=cont.id;
        certificate.RecordTypeId=rt.Id;
        insert certificate;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(certificate);
        CertificationConfirmAttachment e = new CertificationConfirmAttachment(sc);
        system.assert(e != null);
        
        
        certificate.Verfied__c=false;
        if(certificate.Verfied__c==true){
            certificate.IP_Original_Seen_on__c=true;
        }else{
            certificate.IP_Original_Seen_on__c=false;
        }
        e.save();
        
        PageReference pageRef = Page.CertificationConfirmAttachment;
        pageRef.getparameters().put('id', certificate.id);
        Test.setCurrentPage(pageRef);
        
        
        Apexpages.StandardController sc1 = new Apexpages.StandardController(certificate);
        CertificationConfirmAttachment ext = new CertificationConfirmAttachment(sc1);    
        ext.Cancel();   
        
        CertificationVerifyAttachment__c setting = new CertificationVerifyAttachment__c();
        setting.Name = 'Right to Works';
        insert setting;
        String recordTypeName = [SELECT Name from Recordtype where ID=:certificate.RecordTypeId].Name;      
        CertificationConfirmAttachment testAccPlan = new CertificationConfirmAttachment(sc);
        testAccPlan.getSettings();
        
    }
    
}