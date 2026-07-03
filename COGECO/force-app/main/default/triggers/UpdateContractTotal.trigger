trigger UpdateContractTotal on ContractService__c (after insert, after update) {
    
// Modifications:
// 1/29/2010 - Jorge L. Caceres - Salesforce.com
//             Avoid recursive calls from calls that originated from the contract trigger
// 6/20/2016 - Geoff Flynn - Stratus360
//             Migrated as is from old Salesforce instance
 
    try {
        for (ContractService__c c : Trigger.new) {
            String oldStatus = '';
            if (Trigger.isUpdate) {
                ContractService__c oldC = Trigger.oldMap.get(c.Id);
                if (oldC != null) {
                    oldStatus = oldC.Status__c;
                }
            }

            if (c.Status__c == 'Present' && oldStatus != 'Future' && !StaticVariables.inContractTrigger) {
                String contractId = c.Contract__c;
                List<CustomContract__c> contracts = [SELECT Id, Monthly_Revenue__c, FutureEffectiveFlag__c FROM CustomContract__c WHERE Id = :contractId LIMIT 1];

                if (!contracts.isEmpty()) {
                    CustomContract__c contract = contracts[0];
                    
                    if (!contract.FutureEffectiveFlag__c) {
                        List<ContractService__c> contractServices = [SELECT Id, Count__c, Bulk_Rate__c FROM ContractService__c WHERE Contract__c = :contractId AND Status__c = 'Present'];

                        double totalBulk = 0;
                        for (ContractService__c cs : contractServices) {
                            totalBulk += (cs.Bulk_Rate__c != null) ? cs.Bulk_Rate__c : 0;
                        }

                        contract.Monthly_Revenue__c = totalBulk;
                        update contract;
                    }
                }
            }
        }
    } catch (Exception e) {
        // Handle the exception by logging an error message
        System.debug('Exception occurred in UpdateContractTotal trigger: ' + e.getMessage());
        // Optionally handle or log the exception here, e.g., send an email to the admin or create a custom error record
    }
}