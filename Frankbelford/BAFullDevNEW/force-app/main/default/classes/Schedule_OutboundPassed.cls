global class Schedule_OutboundPassed implements Schedulable{
IP_ImpellamGlobalSetting__c imp = IP_ImpellamGlobalSetting__c.getOrgDefaults();
             Integer limit1 = Integer.valueOf(imp.IP_OutboundWriteBatchsize__c);
     global void execute(SchedulableContext sc) {
        OutboundDataPassed batchInstance = new OutboundDataPassed(); 
        database.executebatch(batchInstance,limit1);
    }
}