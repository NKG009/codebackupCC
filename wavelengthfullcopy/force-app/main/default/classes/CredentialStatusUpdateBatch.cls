/*
 * Author: Theertha
 * Date: 22nd August 2024
 * Jira : https://targetrecruit.atlassian.net/issues/WAVE-371
*/
public with sharing class CredentialStatusUpdateBatch implements Database.Batchable<sObject>, Database.Stateful {
   
   private Date today;
   private Date ninetyDaysFromNow;
   private Date ninetyDaysAgo;
   private String statusExclusionClause;

     
     public CredentialStatusUpdateBatch(){
         this.today = System.today();
         this.ninetyDaysFromNow = today.addDays(90);
         this.ninetyDaysAgo = today.addDays(-90);
         
          AVTRRT__Config_Settings__c excludeSetting = [select Credential_Status_To_Exclude_from_Status__c
                                                      FROM AVTRRT__Config_Settings__c 
                                                      WHERE Name='Default'];
        if (excludeSetting != null && !String.isEmpty(excludeSetting.Credential_Status_To_Exclude_from_Status__c)) {
            List<String> excludedStatuses = excludeSetting.Credential_Status_To_Exclude_from_Status__c.split(',');
            
            statusExclusionClause = ' AND CRDNTLS__Status__c NOT IN (\'' + String.join(excludedStatuses, '\',\'') + '\')';
            System.debug('@@statusExclusionClause'+statusExclusionClause);
        }
     }

     public Database.QueryLocator start(Database.BatchableContext BC){
           //String ids ='0039j00000bl3d4';
           String query = 'SELECT Id, CRDNTLS__Expiration_Date__c, CRDNTLS__Status__c ' 
           + 'FROM CRDNTLS__Credentials_Answers__c ' 
           + 'WHERE ((CRDNTLS__Expiration_Date__c <= TODAY' + statusExclusionClause + ') ' 
           + 'OR (CRDNTLS__Expiration_Date__c >= TODAY AND CRDNTLS__Expiration_Date__c <= :ninetyDaysFromNow))';
          // + 'AND CRDNTLS__Contact__c = :ids';


       
          return Database.getQueryLocator(query);
     }

     public void execute(Database.BatchableContext  BC,List<CRDNTLS__Credentials_Answers__c> scope){
         System.debug('scope'+scope.size());
         List<CRDNTLS__Credentials_Answers__c> credentialsToUpdate = new List<CRDNTLS__Credentials_Answers__c>();
         for(CRDNTLS__Credentials_Answers__c credential : scope)
         {
             String status = validateStatus(credential);
             
             if(status != credential.CRDNTLS__Status__c){
                 credential.CRDNTLS__Status__c = status;
                 credentialsToUpdate.add(credential);
             }
             
         }
         
         if(!credentialsToUpdate.isEmpty()){
            Database.update(credentialsToUpdate,false);
         }
       
     }
    
     public void finish(Database.BatchableContext  BC){
       
     }
     
     private string validateStatus(CRDNTLS__Credentials_Answers__c cred){
         
         Integer daysUntilExpiration = today.daysBetween(cred.CRDNTLS__Expiration_Date__c);
         
         if(cred.CRDNTLS__Expiration_Date__c <= today && cred.CRDNTLS__Status__c!=Label.CredStatus_Expired){
             
             return Label.CredStatus_Expired;
         }
         else if((daysUntilExpiration == 30 || (daysUntilExpiration<=30 && daysUntilExpiration>=1))
                  && cred.CRDNTLS__Status__c!=Label.CredStatus_Expiring30Days){
             
             return Label.CredStatus_Expiring30Days;
         }
         else if((daysUntilExpiration == 60 || (daysUntilExpiration>=31 && daysUntilExpiration<=60))
                 && cred.CRDNTLS__Status__c!=Label.Cred_Status_Expiring_60_Days){
             return Label.Cred_Status_Expiring_60_Days;
         }
         else if((daysUntilExpiration == 90 || (daysUntilExpiration>=61 && daysUntilExpiration<=90))
                 && cred.CRDNTLS__Status__c!=Label.Cred_Status_Expiring_90_Days)
           {
                return Label.Cred_Status_Expiring_90_Days;
           }
         return cred.CRDNTLS__Status__c;
     }
     
}