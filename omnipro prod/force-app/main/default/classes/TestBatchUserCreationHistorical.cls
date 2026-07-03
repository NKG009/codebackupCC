@isTest(seealldata=true)
public class TestBatchUserCreationHistorical {

   
    @isTest
    static void testBatchUserCreation() {
        Test.startTest();
        
        BatchUserCreationHistorical batchInstance = new BatchUserCreationHistorical();
        
        ID batchJobId = Database.executeBatch(batchInstance);

        Test.stopTest();

        
    }
}