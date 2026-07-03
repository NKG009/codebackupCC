@isTest
private class Test_UpdateCertificateStatus_Lapsed {
    
    
     public static testmethod void updatestatus()
    {          
        Account account1 = TestDataFactory.createCandidateAccount(1)[0]; 
        insert account1; 
        
                insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);
        Contact cand = TestDataFactory.createCandidate(account1.id, 1)[0];
        insert cand;
        
          id certId = Schema.SObjectType.Certification__c.getRecordTypeInfosByName().get('WTRT- Driving').getRecordTypeId();
        Certification__c cert = new Certification__c();
        cert.PORTW_Checked__c = false;
        cert.Student_Checked__c = false;
        cert.Contact__c = cand.id;
        cert.RecordTypeId = certId;
        cert.IP_Status__c = 'Current';
        cert.Signature_Date__c = System.today().addDays(-365);
        cert.Verfied__c = TRUE;
        insert cert;
        System.debug('signature date'+cert.Signature_Date__c);
        Test.Starttest();
            UpdateCertificateStatus_Lapsed b = new UpdateCertificateStatus_Lapsed();
            Database.executebatch(b,1);
         Schedule_UpdateCertiifcateStatus sh1 = new Schedule_UpdateCertiifcateStatus();
        String sch = '0 30 * * * ?';
        system.schedule('Test manualbatch', sch, sh1);
         Test.stoptest();
        
        }
        
     }