@istest
public class Test_UpdaterecontacteddateCanddate  {

    static testMethod void updateContactdate() {
       
      
        Account acc2 = TestDataFactory.createCandidateAccount(1)[0];
        insert acc2;
                insert new Payroll_Swtich__c (name = 'Stoppayroll', Batch_check__c = false);

         insert new IP_JSToFrostSwtich__c(name = 'JSToFrost', IP_RunJSToFrost__c = true);
        Contact con1 = TestDataFactory.createCandidate(acc2.id,1)[0];
        con1.IP_DateAvailableforRecontact__c = System.today();
        insert con1;    

        Test.startTest();
        ScheduleUpdaterecontacteddateCanddate sh2 = new ScheduleUpdaterecontacteddateCanddate();
        String sch = '0 0 23 * * ?';
        system.schedule('Testcontactdtae Sync', sch, sh2);
        Test.stopTest();
    }
    }