@isTest
public class Test_DVLAnextdueLapse {
 public static testmethod void updatedvlastatus()
    {          
        Account account1 = TestDataFactory.createCandidateAccount(1)[0]; 
        insert account1; 
        
        Contact cand = TestDataFactory.createCandidate(account1.id, 1)[0];
        insert cand;
        
          id certId = Schema.SObjectType.Certification__c.getRecordTypeInfosByName().get('DVLA Licence Check').getRecordTypeId();
        Certification__c cert = new Certification__c();
        cert.Contact__c = cand.id;
        cert.RecordTypeId = certId;
        cert.IP_Status__c = 'Current';
        cert.Next_Check_Due__c = System.today();
        cert.Verfied__c = TRUE;
        insert cert;
        
        Test.Starttest();
          
         Schedule_DVLAnextdueLapse sh1 = new Schedule_DVLAnextdueLapse();
        String sch = '0 30 * * * ?';
        system.schedule('Test manualbatch', sch, sh1);
         Test.stoptest();
        
        }
}