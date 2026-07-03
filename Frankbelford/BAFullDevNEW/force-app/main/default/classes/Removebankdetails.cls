global class Removebankdetails implements Database.Batchable<sObject> {

    Set<id> conid = new Set<id>();
    date dt = system.today().addMonths(-3);
    
         global Database.QueryLocator start(Database.BatchableContext BC){
                  System.debug('check date'+dt);

           String query ='Select id,IP_BankAccountName__c,IP_AccountNumber__c,IP_Candidate__c,IP_SortCode__c,IP_BuildingSocietyNumber__c,P45_Date_by_Head_Office__c,IP_Status__c from IP_PayProfile__c where IP_Status__c = \'Inactive\' and P45_Date_by_Head_Office__c != null and P45_Date_by_Head_Office__c <=: dt and IP_BankAccountName__c != null and RecordType.Name = \'PAYE\'';
           return Database.getQueryLocator(query);
         
         }
     global void execute(Database.BatchableContext BC,List<IP_PayProfile__c > payprof){
             for(IP_PayProfile__c pay: payprof){
                    conid.add(pay.IP_Candidate__c);
                    pay.IP_BankAccountName__c = '';
                    pay.IP_AccountNumber__c='';   
                    pay.IP_SortCode__c=''; 
                    pay.IP_BuildingSocietyNumber__c='';  
                }                
           Database.update(payprof,false);
    List<Certification__c> certlist = [Select id from Certification__c where RecordType.Name = 'Bank Details Form (PAYE)' and Contact__c in: conid];
    if(certlist.size()>0)
    {
        delete certlist;
    }
    
}
     global void finish(Database.BatchableContext BC){
            
            
        
        }
}