/**
* @author Dean Morris
* @description Trigger on Job Role to create Rate Card from a default template
*/
trigger CreateDefaultRateCardForJobRole on sirenum__Team__c (before insert) {
    // CreateDefaultRateCardForJobRoleHelper rateCardHelper = new CreateDefaultRateCardForJobRoleHelper(Trigger.new);
    
    // Global template
    sirenum__TimesheetSettings__c timesheetSettings = sirenum__TimesheetSettings__c.getInstance();
    ID globalDefaultRateCardId = timesheetSettings.Default_Rate_Card__c;

    // Generate maps of job roles and contracts
    Map<ID, List<sirenum__Team__c>> contractJobRoleMap = new Map<ID, List<sirenum__Team__c>>();
    List<Id> jobRoleContractIds = new List<Id>();
    List<sirenum__Team__c> nullContractJobRoles = new List<sirenum__Team__c>();

    for (sirenum__Team__c jobRole : Trigger.new) {
        if (jobRole.sirenum__Account__c == null) {
            nullContractJobRoles.add(jobRole);
        } else {
            if (!jobRoleContractIds.contains(jobRole.sirenum__Account__c)) {
                jobRoleContractIds.add(jobRole.sirenum__Account__c);
            }
            if(!contractJobRoleMap.containsKey(jobRole.sirenum__Account__c)) {
                contractJobRoleMap.put(jobRole.sirenum__Account__c, new List<sirenum__Team__c>());
            }
            contractJobRoleMap.get(jobRole.sirenum__Account__c).add(jobRole);
        }                                
    }

    // Retrive all Sirenum Contracts referenced by Job Roles
    List<sirenum__ProActiveContract__c> contracts = [SELECT Id,
                                                            Default_Rate_Card__c,
                                                            sirenum__Client__r.Default_Rate_card__c,
                                                            sirenum__Client__c
                                                     FROM   sirenum__ProActiveContract__c
                                                     WHERE  Id IN :jobRoleContractIds];
    
    // Create parallel maps of job roles and default rate card ids as sObjects should not be used as keys in a map
    Integer i = 0;
    Map<Integer, sirenum__Team__c> jobRoleMap = new Map<Integer, sirenum__Team__c>();
    Map<Integer, Id> defaultRateCardIdMap = new Map<Integer, Id>();
    Map<Integer, Id> jobRoleAccountIdMap = new Map<Integer, Id>();

    // Add global default rate card for job roles with no contract
    if (globalDefaultRateCardId != null) {
        for (sirenum__Team__c jobRole : nullContractJobRoles) {
            jobRoleMap.put(i, jobRole);
            defaultRateCardidMap.put(i, globalDefaultRateCardId);
            jobRoleAccountIdMap.put(i, null);
            i++;
        }
    }
    
    // Add global default rate card for job roles for each contract
    for (sirenum__ProActiveContract__c contract : contracts) {

        // Precedence for default rate card in descending order is contract, account, global 
        Id defaultRateCardId;
        if (contract.Default_Rate_Card__c != null) {
            defaultRateCardId = contract.Default_Rate_Card__c;
        } else if (contract.sirenum__Client__r.Default_Rate_card__c != null) {
            defaultRateCardId = contract.sirenum__Client__r.Default_Rate_card__c;
        } else {
            defaultRateCardId = globalDefaultRateCardId;
        }

        if (defaultRateCardId != null) {
            // Add default rate card for each jobRole that references this contract
            for (sirenum__Team__c jobRole : contractJobRoleMap.get(contract.Id)) {
                jobRoleMap.put(i, jobRole);
                defaultRateCardIdMap.put(i, defaultRateCardId);
                jobRoleAccountIdMap.put(i, contract.sirenum__Client__c);
                i++;
            }
        }
    }
    
    CreateDefaultRateCardForJobRoleHelper rateCardHelper = new CreateDefaultRateCardForJobRoleHelper(jobRoleMap, 
                                                                                                     defaultRateCardIdMap,
                                                                                                     jobRoleAccountIdMap);
}