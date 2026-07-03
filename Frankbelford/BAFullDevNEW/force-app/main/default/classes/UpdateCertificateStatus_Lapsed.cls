global class UpdateCertificateStatus_Lapsed extends batchjobsch.BatchJobBase implements Database.Batchable<sObject>,Database.Stateful {

    date dt = system.today();
         global Database.QueryLocator start(Database.BatchableContext BC){
           String query ='Select id,name,IP_Status__c,IP_RecordTypeName__c,Expiry_Date__c from Certification__c where IP_RecordTypeName__c =\'WTRT- Driving\' AND Expiry_Date__c =:dt';
           return Database.getQueryLocator(query);
         
         }
     global void execute(Database.BatchableContext BC,List<Certification__c > cert){
             for(Certification__c cc: cert){
                    cc.IP_Status__c='Lapsed';                          
                }
                
           update cert;
    
}
     global void finish(Database.BatchableContext BC){
            
            super.finishBatch(BC); 
        
        }
}