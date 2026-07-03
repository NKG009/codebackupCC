@isTest
public class Test_OutboundPassedEmergency {

    static testmethod void testoutbound1(){
          IP_BranchStatus__c b  = new IP_BranchStatus__c ();
                 b.IP_BranchID__c = '1062';
                 b.Name = 'Test';
             b.IP_Status__c = 'Active';
                 insert b;
         IP_ImpellamGlobalSetting__c setting = new IP_ImpellamGlobalSetting__c();
                 setting.IP_LastTransmissionDate__c =   Date.newInstance(2019,07,01);
                 insert setting;
        
          IP_OutboundDataTransfer__c ob2 = new IP_OutboundDataTransfer__c();
     ob2.IP_Tempest_Department__c = '1062';
        ob2.IP_TransferType__c = 'Assignment';   
        ob2.IP_EmergencyPull__c  = true;  
        insert ob2;
        
        Database.executeBatch(new OutboundDataPassedEmergency(), 10);
    }
}