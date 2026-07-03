@isTest

public class DeleteLogEntrysirenumTest{

@istest static void method1(){
        
       sirenum__LogEntry__c se = new sirenum__LogEntry__c();
      // se.name = 'test';
       insert se;
       Date creationdate = System.today().addDays(-100);
        Test.setCreatedDate(se.Id, creationdate); 
        Test.startTest();
        Database.executeBatch(new DeleteLogEntrysirenum(),1);
        Test.stopTest();
    }


}