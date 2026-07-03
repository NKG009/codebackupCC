global class OutboundDataPassedEmergency implements Database.Batchable<sObject>{
 global Set<String> branchset = new Set<String>();
global OutboundDataPassedEmergency()
{
 List<IP_BranchStatus__c> branchlist = [Select id,IP_BranchID__c from IP_BranchStatus__c where IP_Status__c = 'Active'];
    for(IP_BranchStatus__c b:branchlist)
    {
        branchset.add(b.IP_BranchID__c);
    }     
}
     global Database.QueryLocator start(Database.BatchableContext BC){
         string query = 'Select id,IP_Passed__c,IP_Tempest_Department__c from IP_OutboundDataTransfer__c where IP_EmergencyPull__c = TRUE and IP_Tempest_Department__c =:branchset and IP_Passed__c = null ';
         return Database.getQueryLocator(query);
     }
     global void execute(Database.BatchableContext BC,List<IP_OutboundDataTransfer__c> scope){
     
         IP_ImpellamGlobalSetting__c imp = IP_ImpellamGlobalSetting__c.getOrgDefaults();
         imp.IP_LastTransmissionDate__c = System.now();
         update imp;
         for(IP_OutboundDataTransfer__c ob:scope){
             ob.IP_Passed__c='PASSING';            
         }
         update scope;
     }
     global void finish(Database.BatchableContext BC){
        Database.executeBatch(new OutboundCloseCall(),1);
        }
}