@istest
public class Test_stampdate {

    public static testmethod void  test1()
    {       
        
        IP_TopazGlobalClientInformation__c topaz = new IP_TopazGlobalClientInformation__c();
        topaz.Name='Test topaz';
        topaz.IP_StatusID__c = 1;
        insert topaz;
        
        Test.StartTest();
        
        topaz.IP_StatusID__c = 3;
        update topaz;     
         Test.StopTest(); 
    }
     public static testmethod void  test2()
    {       
        
        IP_TopazGlobalClientInformation__c topaz1 = new IP_TopazGlobalClientInformation__c();
        topaz1.Name='Test topaz';
        topaz1.IP_StatusID__c = 1;
        insert topaz1;
        
        Test.StartTest();
        
        topaz1.IP_StatusID__c = 0;
        update topaz1;
         Test.StopTest(); 
    }
   
    
}