trigger CopyFutureServicesIntoPresent on CustomContract__c (after update) 

// Modifications:
// 1/29/2010 - Jorge L. Caceres - Salesforce.com
//             Avoid recursive calls from updates to ContractServices that are called from this trigger
// 6/20/2016 - Geoff Flynn - Stratus360
//         Migration from old instance of Salesforce
            


{
    List<ContractService__c> listToUpdate = new List<ContractService__c>();

    if (StaticVariables.inContractTrigger == null) {
        StaticVariables.inContractTrigger = true;
    }

    for (CustomContract__c c : Trigger.new) {
        if (c.FutureEffectiveFlag__c == true) {
            String contractID = c.Id;
            
            if (String.isNotBlank(contractID)) {
                List<ContractService__c> contractServicePresent = [SELECT Id, Status__c, Contract__c, Service__c, Count__c, Ind_Rate__c, Disc__c, Bulk_Rate__c, Z_Inactive_Date__c FROM ContractService__c WHERE Contract__c = :contractID AND Status__c = 'Present' ORDER BY Service__c];
                List<ContractService__c> contractServiceFuture = [SELECT Id, Status__c, Contract__c, Service__c, Count__c, Ind_Rate__c, Disc__c, Bulk_Rate__c, Z_Inactive_Date__c FROM ContractService__c WHERE Contract__c = :contractID AND Status__c = 'Future' ORDER BY Service__c];
                
                if (contractServicePresent != null && contractServiceFuture != null) {
                    for (ContractService__c pre : contractServicePresent) {
                        if (pre != null) {
                            pre.Status__c = 'Z - Inactive';
                            pre.Z_Inactive_Date__c = c.Future_Effective_Date__c;
                            listToUpdate.add(pre);
                        }
                    }
                    
                    double totalBulk = 0;
                    for (ContractService__c fut : contractServiceFuture) {
                        if (fut != null) {
                            fut.Status__c = 'Present';
                            totalBulk += fut.Bulk_Rate__c != null ? fut.Bulk_Rate__c : 0;
                            listToUpdate.add(fut);
                        }
                    }
                }
            }
        }
    }
    
    update listToUpdate;
}