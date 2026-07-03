global class UpdateCriminalConvictionDetails extends batchjobsch.BatchJobBase implements Database.Batchable<sobject> {
    
    global String query;
    Date dt= System.today();
    List<ts2__Certification__c> cert = new List<ts2__Certification__c>();
    global Database.QueryLocator start(Database.BatchableContext bc){
        query='select id,IP_Offence__c,IP_Conviction__c, IP_Rehabilitation_Period_End_Date__c,Unspent_Criminal_Convictions_Details__c,Unspent_Criminal_Convictions__c from ts2__Certification__c where Recordtype.name=\'Declaration\'and IP_Rehabilitation_Period_End_Date__c=:dt';
        return Database.getQueryLocator(query);
         
    }
    global void execute(Database.BatchableContext bc, List<ts2__Certification__c> certification){
        
        for(ts2__Certification__c ct:certification){
            ct.IP_Offence__c='';
            ct.IP_Conviction__c='';
            ct.IP_Rehabilitation_Period_End_Date__c=null;
            ct.Unspent_Criminal_Convictions_Details__c=null;
            ct.Unspent_Criminal_Convictions__c='';
            
        }
        
        update certification;
        
    }
    
    global void finish(Database.BatchableContext bc){
         super.finishBatch(BC);
    }
}