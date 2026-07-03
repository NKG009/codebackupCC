@istest
public class SiteRecordCreationSchedulable_test {
    static testmethod void testscheduler(){
        SiteRecordCreationSchedulable RS = new SiteRecordCreationSchedulable(system.now());
        String sch = '0 5 * * * ?';
        Test.startTest();
        System.schedule('batchJobName', sch, rs );
        Test.stopTest();
        SiteRecordCreationSchedulable.reschedulebatch(system.now());
    }
   
}