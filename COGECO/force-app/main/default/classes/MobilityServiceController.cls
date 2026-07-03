public with sharing class MobilityServiceController {
    
    
    @AuraEnabled(cacheable=true)
    public static List<Mobility_Related_Service__c> getMobilityServices(String accountPlanId) {
        try {
            if (String.isBlank(accountPlanId)) {
                return new List<Mobility_Related_Service__c>();
            }
            
            return [
                SELECT Id, Service_Element__c, TELUS_Roaming__c, TELUS_MVNO_Wholesale__c, 
                       ROGERS__c, BELL__c, Account_Plan__c, CreatedDate, LastModifiedDate
                FROM Mobility_Related_Service__c 
                WHERE Account_Plan__c = :accountPlanId
                ORDER BY CreatedDate ASC
                
            ];
        } catch (Exception e) {
            System.debug('Error in getMobilityServices: ' + e.getMessage());
            throw new AuraHandledException('Error retrieving mobility services: ' + e.getMessage());
        }
    }
    
    
    @AuraEnabled
    public static List<Mobility_Related_Service__c> saveMobilityServices(List<Mobility_Related_Service__c> services, String accountPlanId) {
        if (services == null || services.isEmpty()) {
            throw new AuraHandledException('No services provided to save.');
        }
        
        if (String.isBlank(accountPlanId)) {
            throw new AuraHandledException('AccountPlan ID is required.');
        }
        
        try {
            // Validate user permissions
            if (!Schema.sObjectType.Mobility_Related_Service__c.isCreateable() || 
                !Schema.sObjectType.Mobility_Related_Service__c.isUpdateable()) {
                throw new AuraHandledException('Insufficient permissions to save mobility services.');
            }
            
            List<Mobility_Related_Service__c> servicesToUpsert = new List<Mobility_Related_Service__c>();
            
            // Process each service record
            for (Mobility_Related_Service__c service : services) {
                // Skip completely empty records
                if (isEmptyRecord(service)) {
                    continue;
                }
                
                // Clean the record and prepare for upsert
                Mobility_Related_Service__c cleanService = new Mobility_Related_Service__c();
                
                // Set ID if this is an update (existing record)
                if (service.Id != null) {
                    cleanService.Id = service.Id;
                }
                
                // Set field values
                cleanService.Service_Element__c = service.Service_Element__c;
                cleanService.TELUS_Roaming__c = service.TELUS_Roaming__c;
                cleanService.TELUS_MVNO_Wholesale__c = service.TELUS_MVNO_Wholesale__c;
                cleanService.ROGERS__c = service.ROGERS__c;
                cleanService.BELL__c = service.BELL__c;
                cleanService.Account_Plan__c = accountPlanId;
                
                servicesToUpsert.add(cleanService);
            }
            
            if (servicesToUpsert.isEmpty()) {
                throw new AuraHandledException('No valid data provided to save.');
            }
            
            // Perform upsert operation
            Database.UpsertResult[] results = Database.upsert(servicesToUpsert, false);
            
            // Check for errors and collect error messages
            List<String> errors = new List<String>();
            for (Integer i = 0; i < results.size(); i++) {
                Database.UpsertResult result = results[i];
                if (!result.isSuccess()) {
                    String errorMsg = 'Row ' + (i + 1) + ': ';
                    for (Database.Error error : result.getErrors()) {
                        errorMsg += error.getMessage() + '; ';
                    }
                    errors.add(errorMsg);
                }
            }
            
            if (!errors.isEmpty()) {
                throw new AuraHandledException('Errors occurred while saving: ' + String.join(errors, ' '));
            }
            
            // Return the successfully saved records with their IDs
            return servicesToUpsert;
            
        } catch (DmlException e) {
            String errorMessage = 'Database error: ';
            for (Integer i = 0; i < e.getNumDml(); i++) {
                errorMessage += e.getDmlMessage(i) + ' ';
            }
            System.debug('DML Error in saveMobilityServices: ' + errorMessage);
            throw new AuraHandledException(errorMessage);
        } catch (Exception e) {
            System.debug('Error in saveMobilityServices: ' + e.getMessage());
            throw new AuraHandledException('Error saving mobility services: ' + e.getMessage());
        }
    }
    
    
    @AuraEnabled
    public static void deleteMobilityService(String serviceId) {
        if (String.isBlank(serviceId)) {
            throw new AuraHandledException('Service ID is required for deletion.');
        }
        
       // try {
            if (!Schema.sObjectType.Mobility_Related_Service__c.isDeletable()) {
                throw new AuraHandledException('Insufficient permissions to delete mobility services.');
            }
            
            Mobility_Related_Service__c serviceToDelete = [SELECT Id FROM Mobility_Related_Service__c WHERE Id = :serviceId WITH SECURITY_ENFORCED LIMIT 1];
            
            delete serviceToDelete;
            
       // } 
       /*catch (QueryException e) {
            System.debug('Query Error in deleteMobilityService: ' + e.getMessage());
            throw new AuraHandledException('Service record not found.');
        } catch (DmlException e) {
            System.debug('DML Error in deleteMobilityService: ' + e.getMessage());
            throw new AuraHandledException('Error deleting mobility service: ' + e.getDmlMessage(0));
        } catch (Exception e) {
            System.debug('Error in deleteMobilityService: ' + e.getMessage());
            throw new AuraHandledException('Error deleting mobility service: ' + e.getMessage());
        }*/
    }
    
    
    @AuraEnabled(cacheable=true)
    public static Boolean validateAccountPlan(String accountPlanId) {
        //try {
            if (String.isBlank(accountPlanId)) {
                return false;
            }
            
            Integer count = [SELECT COUNT() FROM AccountPlan WHERE Id = :accountPlanId WITH SECURITY_ENFORCED];
            return count > 0;
            
       // } 
       /*catch (Exception e) {
            System.debug('Error in validateAccountPlan: ' + e.getMessage());
            return false;
        }*/
    }
    
    
    private static Boolean isEmptyRecord(Mobility_Related_Service__c service) {
        if (service == null) {
            return true;
        }
        
        
        return String.isBlank(service.Service_Element__c) &&
               service.TELUS_Roaming__c == null &&
               service.TELUS_MVNO_Wholesale__c == null &&
               service.ROGERS__c == null &&
               service.BELL__c == null;
    }
}