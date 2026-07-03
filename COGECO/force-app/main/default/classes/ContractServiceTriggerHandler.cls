public class ContractServiceTriggerHandler {
    private static ContractServiceTriggerHandler instance;

    public static ContractServiceTriggerHandler getInstance() {
        if (instance == null) {
            instance = new ContractServiceTriggerHandler();
        }
        return instance;
    }

    public void onBeforeInsert(final List<ContractService__c> newObject) {
        this.calculateBulkRate(newObject);
    }

    public void onBeforeUpdate(final List<ContractService__c> newObject) {
        this.calculateBulkRate(newObject);
    }

    public void onAfterInsert(final List<ContractService__c> newObject, final Map<Id, ContractService__c> oldObjectMap) {
        this.updateContractTotal(newObject, oldObjectMap);
    }

    public void onAfterUpdate(final List<ContractService__c> newObject, final Map<Id, ContractService__c> oldObjectMap) {
        this.updateContractTotal(newObject, oldObjectMap);
    }

    private void calculateBulkRate(List<ContractService__c> newObject) {
        for (ContractService__c instance : newObject) {
            if (instance.Ind_Rate__c != null && instance.Count__c != null) {
                instance.Bulk_Rate__c = instance.Ind_Rate__c * instance.Count__c;
            }
        }
    }

 private void updateContractTotal(List<ContractService__c> newObject, Map<Id, ContractService__c> oldObjectMap) {
    try {
        Set<Id> contractIds = new Set<Id>();
        Map<Id, CustomContract__c> contractsMap = new Map<Id, CustomContract__c>();

        for (ContractService__c instance : newObject) {
            if (instance != null && instance.Contract__c != null) {
                contractIds.add(instance.Contract__c);
            }
        }

        if (!contractIds.isEmpty()) {
            contractsMap = new Map<Id, CustomContract__c>([SELECT Id, Monthly_Revenue__c, FutureEffectiveFlag__c FROM CustomContract__c WHERE Id IN :contractIds AND FutureEffectiveFlag__c != true]);
        }

        for (ContractService__c instance : newObject) {
            if (instance != null && instance.Contract__c != null) {
                ContractService__c oldInstance = oldObjectMap.get(instance.Id);
                if (oldInstance != null) {
                    String oldStatus = oldInstance.Status__c;
                    String currentStatus = instance.Status__c;

                    if (currentStatus == 'Present' && oldStatus != 'Future' && StaticVariables.inContractTrigger == false) {
                        CustomContract__c contInstance = contractsMap.get(instance.Contract__c);
                        if (contInstance != null) {
                            List<ContractService__c> contractServices = [SELECT Id, Count__c, Bulk_Rate__c FROM ContractService__c WHERE Contract__c = :instance.Contract__c AND Status__c = 'Present'];
                            double totalBulk = 0;
                            for (ContractService__c cs : contractServices) {
                                if (cs.Bulk_Rate__c != null) {
                                    totalBulk += cs.Bulk_Rate__c;
                                }
                            }
                            contInstance.Monthly_Revenue__c = totalBulk;
                            update contInstance;
                        } else {
                            System.debug('CustomContract__c instance is null');
                        }
                    }
                } else {
                    System.debug('Old ContractService__c instance is null');
                }
            }
        }
    } catch (Exception e) {
        System.debug('Exception message: ' + e.getMessage());
        System.debug('Exception stack trace: ' + e.getStackTraceString());
    }
}

}