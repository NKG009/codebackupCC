global class UncontactedCandidateRemoval extends batchjobsch.BatchJobBase implements Database.Batchable<sObject>, Database.Stateful{
    Date dt = System.today();    
    IP_ImpellamGDPRSettings__c abc = IP_ImpellamGDPRSettings__c.getValues('Impellam GDPR settings');
    String activitytypes = abc.IP_ActivityTypesThatQualifyAsContact__c;
    List<String> activitylist = activitytypes.split(','); 
    Integer retPeriod = Integer.valueOf(abc.IP_UncontactedCandidateRetentionPeriod__c);
    Date dt1 = dt.addDays(-retPeriod);
      
   
    global Database.QueryLocator start (Database.BatchableContext BC){  
         system.debug('dt1'+dt1);
        String query = 'Select id, recordtype.name, IP_GDPRContactedCandidate__c,IP_MarkedForDeletion__c,CreatedDate , IP_Consent_from_Data_Store__c FROM contact WHERE IP_GDPRContactedCandidate__c = FALSE AND CreatedDate < :dt1 AND IP_Consent_from_Data_Store__c= NULL AND IP_MarkedForDeletion__c = false AND (IP_LastContactedGDPR__c = Null OR IP_LastContactedGDPR__c < :dt1) AND Recordtype.name = \'Candidate\'';
        system.debug('Query-->'+Query);
        return Database.getQueryLocator(Query);
    }
    
    
    
    global void execute (Database.BatchableContext BC, List<Contact> Candidate) {
        system.debug('Vandita-->'+Candidate);
        Map<Id,Contact> updateCandidate = new Map<Id,Contact>();
        Map<Id,Contact> existingDataCandidate = new Map<Id,Contact>();
        set<Id> conIdSet = new Set<Id>();

     
        for(Contact con : Candidate)
        {
            conIdSet.add(con.Id);
            existingDataCandidate.put(con.Id,con);
        }
   System.debug('conIdSet----->'+ conIdSet );
       /* First Condition */
        Map<Id,List<Task>> CandidateActivity = new Map<Id,List<Task>>();
        
        for(Task activitylinked : [Select id, IP_ActivityType__c, WhoId FROM Task WHERE IP_ActivityType__c IN :activitylist AND WhoId IN:ConIdSet ALL ROWS])
        {
             Contact con = new Contact(Id=activitylinked.WhoId ,IP_GDPRContactedCandidate__c=True);
            updateCandidate.put(activitylinked.WhoId,con);
                      conIdSet.remove(con.Id); 
        }
        System.debug('conIdSet-----2>'+ conIdSet );
        System.debug('updateCandidate----->'+ updateCandidate );
        System.debug('StrangerThings----->'+ CandidateActivity );
       
        /* Second Condition */
        
    
        System.debug('conIdSet----->'+ conIdSet );
        for (sirenum__Shift__c linkedshift :[ Select id, sirenum__Contact__c, sirenum__Cancelled__c,sirenum__Timesheet_summaries__c , sirenum__Published_Ever__c from sirenum__Shift__c where sirenum__Contact__c in:ConIdSet])
            
        {
            if(linkedshift.sirenum__Published_Ever__c == TRUE || linkedshift.sirenum__Timesheet_summaries__c !=null)
            {
                
                Contact con = new Contact(Id=linkedShift.sirenum__Contact__c ,IP_GDPRContactedCandidate__c=True);
                updateCandidate.put(linkedShift.sirenum__Contact__c,con);
                 conIdSet.remove(con.Id); 

            }
        }
        System.debug('conIdSet-----3>'+ conIdSet );
         System.debug('Game of Thrones----->'+ updateCandidate);
        /* Third Condition */
        
      
 for(ts2__Placement__c linkedplacement :[Select id,ts2__Employee__c from ts2__Placement__c where ts2__Employee__c in: ConIdSet])
         {
            
            Contact con = new Contact(Id=linkedplacement.ts2__Employee__c ,IP_GDPRContactedCandidate__c=True);
            updateCandidate.put(linkedplacement.ts2__Employee__c,con);
             System.debug('Entering Placement'+linkedplacement.ts2__Employee__c);
            conIdSet.remove(con.Id); 
            
}
        
 System.debug('Friends----->'+ updateCandidate);
     
        
        List<Contact> updateContacts =[Select id, IP_MarkedForDeletion__c,IP_GDPRWorkedCandidate__c from Contact where id IN: conIdSet ];
        
        for(Contact a : updateContacts)
        
        {
            if(a.IP_GDPRWorkedCandidate__c == false)
            {
            a.IP_MarkedForDeletion__c = true;
            }
            
        }
     
        
           Database.update(updateCandidate.values(),false);
        Database.update(updateContacts,false);
        
    }
    

    global void finish (Database.BatchableContext BC){
        super.finishBatch(BC);
    }
}