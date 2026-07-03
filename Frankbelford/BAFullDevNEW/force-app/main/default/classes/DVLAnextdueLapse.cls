global class DVLAnextdueLapse implements Database.Batchable<sObject>,Database.Stateful{

date dt = system.today();
         global Database.QueryLocator start(Database.BatchableContext BC){
           String query ='Select id,name,IP_Status__c,IP_RecordTypeName__c,Contact__c,Contact__r.DVLA_Status_Check__c,Next_Check_Due__c from Certification__c where IP_RecordTypeName__c =\'DVLA Licence Check\' AND Next_Check_Due__c=:dt';
           return Database.getQueryLocator(query);
         
         }
           global void execute(Database.BatchableContext BC,List<Certification__c > cert){
           List<Contact> conlist = new List<Contact>();
             for(Certification__c cc: cert){
                    cc.IP_Status__c='Lapsed';
                    cc.Contact__r.DVLA_Status_Check__c = 'Lapse';  
                    conlist.add(cc.Contact__r);               
                }
                
           update cert;
           update conlist;
           
              system.debug('after update cert'+cert);
           }
            global void finish(Database.BatchableContext BC){
            
            
        
        }
}