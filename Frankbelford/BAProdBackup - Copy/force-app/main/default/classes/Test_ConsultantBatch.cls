@istest
private class Test_ConsultantBatch{

    @isTest
static void testexecute1() 
    {   
      String query = 'Select id from User limit 10';
         String GUID = 'ABCD';
        String Field1 = 'IP_PassToTempest__c';
        String Field2 = 'IP_LastPassedToTempest__c';  
           
       Profile p = [SELECT Id FROM Profile where name='System Administrator'];
        User usr = TestDataFactory.createUsers(p.Id,1)[0];
        usr.IP_PassToTempest__c = TRUE;
        usr.username = '7nbj@huy.com';
        insert usr; 
       
        test.startTest(); 
         ConsultantBatch b = new ConsultantBatch(query,Field1,Field2,GUID);    
        Database.executeBatch(b,100);       
         ConsultantEmergencyBatch b1 = new ConsultantEmergencyBatch(query,Field1,Field2,GUID);    
        Database.executeBatch(b1,100);       
        test.stopTest();
        
       }
    
    
}