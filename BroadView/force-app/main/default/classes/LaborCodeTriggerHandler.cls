public class LaborCodeTriggerHandler {
    
    public static void checkForContractLineItems(List<Labor_Codes__c> newLaborCode){
        Set<Id> SAIds = new Set<Id>();
        for(Labor_Codes__c lc : newLaborCode){
            SAIds.add(lc.Service_Appointment__c);
        }
        System.debug(SAIds);
        
        Map<Id, ServiceAppointment> SAMap = new Map<Id, ServiceAppointment>([Select id, ParentRecordId, AccountId, 
                                                       Total_Cost__c from ServiceAppointment where id in: SAIds]);
        Set<Id> parentId = new Set<Id>();
        for(ServiceAppointment sa : SAMap.values()){
            parentId.add(sa.ParentRecordId);
        }
        System.debug(parentId);
        List<WorkOrder> woList = [Select id, ServiceContractId from WorkOrder where id in: parentId];
        System.debug(woList);
        Set<Id> scId = new Set<Id>();
        for(WorkOrder wo : woList){
            scId.add(wo.ServiceContractId);
        }
        
        List<ContractLineItem> cli = [Select id, UnitPrice, Product2Id, ServiceContractId from ContractLineItem
                                     where ServiceContractId in: scId];
        System.debug(cli);
        
        Map<Id, ContractLineItem> cliProductNames = new Map<Id, ContractLineItem>();
        for(ContractLineItem c : cli){
            cliProductNames.put(c.Product2Id, c);
        }
        Map<Id, ServiceAppointment> toBeUpdateMap = new Map<Id, ServiceAppointment>();
        System.debug(cliProductNames.values());
        for(Labor_Codes__c lc : newLaborCode){
            System.debug(lc.Product__c);
            if(!cliProductNames.containsKey(lc.Product__c)){
                lc.addError('This service not mentioned in service contract');
            }else{
                lc.Price__c = lc.Quantity__c * cliProductNames.get(lc.Product__c).UnitPrice;
                if(SAMap.get(lc.Service_Appointment__c).Total_Cost__c != null){
                    SAMap.get(lc.Service_Appointment__c).Total_Cost__c = SAMap.get(lc.Service_Appointment__c).Total_Cost__c + lc.Price__c; 
                }else{
                    SAMap.get(lc.Service_Appointment__c).Total_Cost__c = lc.Price__c;
                }
            }
        }
        if(!SAMap.isEmpty()){
            update SAMap.values();
        }
        
    }

}