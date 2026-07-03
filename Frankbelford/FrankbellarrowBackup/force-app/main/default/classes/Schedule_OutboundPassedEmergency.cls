global class Schedule_OutboundPassedEmergency implements Schedulable{
IP_ImpellamGlobalSetting__c imp = IP_ImpellamGlobalSetting__c.getOrgDefaults();
             Integer limit1 = Integer.valueOf(imp.IP_OutboundWriteBatchsize__c);
     global void execute(SchedulableContext sc) {
        OutboundDataPassedEmergency batchInstance = new OutboundDataPassedEmergency(); 
        database.executebatch(batchInstance,limit1);
    }
}