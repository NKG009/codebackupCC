public without sharing class Booked_Temps_Cnt {
    
    @AuraEnabled
    public static List < shiftwrapper > getAllShifts(String site) {
        
        
        try {
            
            String conID = [select id, contactId from User where id =: UserInfo.getUserId() limit 1][0].contactId;
            String accID = [select id, contact.AccountId from User where id =: UserInfo.getUserId() limit 1][0].contact.AccountId;
           
            
            List < sirenum__Ticket__c > t2 = [select Id, sirenum__Valid_until__c from sirenum__Ticket__c limit 5];
            
            List < sirenum__Shift__c > ShiftList = new List < sirenum__Shift__c > ();
            Set < String > ContactIdSet = new Set < String > ();
            Map < String, String > conMap = new Map < String, String > ();
            
            Map < String, sirenum__Shift__c > shiftMap = new Map < String, sirenum__Shift__c > ();
            Set<id> setJobRoleId = new Set<id>();
            List < String > ShiftId = new List < String > ();
            
            for (sirenum__Shift__c Shift: [SELECT Id, ClientRankingStored__c, RankingStored__c, sirenum__Contact__r.Id,sirenum__Team__c,
                                           sirenum__Contact__r.Name, sirenum__Team__r.Name, sirenum__Site__r.name,
                                           sirenum__Scheduled_Start_Time__c, sirenum__Scheduled_End_Time__c
                                           FROM sirenum__Shift__c WHERE sirenum__Scheduled_Start_Time__c > TODAY
                                           AND 
                                            sirenum__Site__c =: site AND sirenum__Cancelled__c != True AND sirenum__Published__c = True ORDER BY sirenum__Scheduled_Start_Time__c, sirenum__Contact__r.Name ASC LIMIT 4
                                          ]) {
                                              ShiftId.add(Shift.Id);
                                              shiftMap.put(Shift.Id, Shift);
                                              conMap.put(Shift.Id, Shift.sirenum__Contact__r.Id);
                                              if (Shift.sirenum__Contact__r.Id != null) {
                                                  ContactIdSet.add(Shift.sirenum__Contact__r.Id);
                                              }
                                              if(Shift.sirenum__Team__c != null){
                                                  setJobRoleId.add(Shift.sirenum__Team__r.id);
                                              }
                                            }
            
            System.debug('ContactIdSet---' + ContactIdSet);
            List<sirenum__Sirenum_Condition_Membership__c> lstCompetencyCondition = [SELECT id,sirenum__TicketType__c,sirenum__TicketType__r.Name
                                                                                     FROM sirenum__Sirenum_Condition_Membership__c WHERE sirenum__Team__c IN: setJobRoleId];

            Set<id> setCompetencyTypeId = new Set<id>();
            for(sirenum__Sirenum_Condition_Membership__c scm : lstCompetencyCondition){
                setCompetencyTypeId.add(scm.sirenum__TicketType__r.id);
            }

            list<sirenum__Ticket__c> lstTicket = [SELECT Id, sirenum__TicketType__r.Name, sirenum__Valid_from__c, sirenum__Valid_until__c FROM sirenum__Ticket__c
                                                  WHERE sirenum__TicketType__c IN: setCompetencyTypeId ];
            Set<id> setTicketsId = new set<id>();
            for(sirenum__Ticket__c tk : lstTicket){
                setTicketsId.add(tk.id);
            }                                    
            Map < String, List < sirenum__Ticket__c >> TicketMap = new Map < String, List < sirenum__Ticket__c >> ();
            
            
            for (sirenum__Ticket__c Ticket: [select Id, sirenum__Owner__r.Id, sirenum__TicketType__r.Name, sirenum__Valid_from__c, sirenum__Valid_until__c from sirenum__Ticket__c Where sirenum__Owner__r.Id IN: ContactIdSet AND id IN: setTicketsId]) {
                
                System.debug('Ticket---' + Ticket);
                List < sirenum__Ticket__c > TList = new List < sirenum__Ticket__c > ();
                if (TicketMap.get(Ticket.sirenum__Owner__r.Id) == null) {
                    TList.add(Ticket);
                } else {
                    TList = TicketMap.get(Ticket.sirenum__Owner__r.Id);
                    TList.add(Ticket);
                }
                
                System.debug('Tlist---' + TList);
                TicketMap.put(Ticket.sirenum__Owner__r.Id, TList);
            }
            
            System.debug('Tlist---' + TicketMap);
            
            List < shiftwrapper > FinalResult = new List < shiftwrapper > ();
            
            for (String s: ShiftId) {
                shiftwrapper shiftObj = new shiftwrapper();
                
                if (shiftMap.get(s) != null) {
                    sirenum__Shift__c shift = shiftMap.get(s);
                    shiftObj.shiftId = shift.Id;
                    shiftObj.TempName = shift.sirenum__Contact__r.Name;
                    shiftObj.TempDate = shift.sirenum__Scheduled_Start_Time__c;
                    shiftObj.jobRole = shift.sirenum__Team__r.Name;
                    
                    if (TicketMap.get(conMap.get(s)) != null) {
                        shiftObj.skillList = TicketMap.get(conMap.get(s));
                    }
                    
                    
                    FinalResult.add(shiftObj);
                }
                
            }
            
            System.debug('*******' + FinalResult);
            
            // ShiftList = [SELECT Id,ClientRankingStored__c, sirenum__Contact__r.Id,RankingStored__c,sirenum__Contact__r.Name, sirenum__Team__r.Name,sirenum__Site__r.name,sirenum__Scheduled_Start_Time__c, sirenum__Scheduled_End_Time__c FROM sirenum__Shift__c WHERE sirenum__Scheduled_Start_Time__c >= TODAY AND (sirenum__Site__r.IP_MainContact__c =: conID OR sirenum__Site__r.Emergency_Contact__c=:conID OR sirenum__Site__r.IP_InvoiceContact__c =:conID) ORDER BY sirenum__Scheduled_Start_Time__c LIMIT 3];
            return FinalResult;
        } catch (exception ex) {
            throw new AuraHandledException('Something went wrong: ' +
                                           ex.getMessage());
        }
    }
    
    
    public without sharing class shiftwrapper {
        @AuraEnabled public String shiftId;
        @AuraEnabled public String TempName;
        @AuraEnabled public Datetime TempDate;
        @AuraEnabled public String jobRole;
        @AuraEnabled public List < sirenum__Ticket__c > skillList;
        
    }

/**
*  Description : Method to get the List of competenicies of Candidtae
*  @name : getContactCompetencies
*  @param : String contactId
*  @return : String 
*  @throws exception-none
*/
    
    @Auraenabled
    public static List<sirenum__Ticket__c> getContactCompetencies(String shiftId){
        System.debug('==shiftId==='+shiftId);
        list<sirenum__Shift__c> lstShift = [SELECT Id,sirenum__Team__r.id, sirenum__Team__c, sirenum__Contact__c, sirenum__Contact__r.id
                                            FROM sirenum__Shift__c 
                                            WHERE id=:shiftId];
        
        System.debug(lstShift.size()+'===lstShift=='+lstShift);
        Set<id> setJobRoleId = new Set<id>();
        Set<id> setCandidateId = new Set<id>();
        if(!lstShift.isEmpty()){
            for (sirenum__Shift__c Shift: lstShift) {
                if(Shift.sirenum__Team__c != null){
                    setJobRoleId.add(Shift.sirenum__Team__r.id);
                }
                if(Shift.sirenum__Contact__c != null){
                    setCandidateId.add(Shift.sirenum__Contact__r.id);
                }
            }
        }
        List<sirenum__Sirenum_Condition_Membership__c> lstCompetencyCondition = [SELECT id,sirenum__TicketType__c,sirenum__TicketType__r.Name
                                                                                 FROM sirenum__Sirenum_Condition_Membership__c WHERE sirenum__Team__c IN: setJobRoleId];
        if(lstCompetencyCondition.isEmpty()){
          return null;  
        }
        Set<id> setCompetencyTypeId = new Set<id>();
        for(sirenum__Sirenum_Condition_Membership__c scm : lstCompetencyCondition){
            setCompetencyTypeId.add(scm.sirenum__TicketType__r.id);
        }
        
        list<sirenum__Ticket__c> lstTicket = [SELECT Id, sirenum__TicketType__r.Name, sirenum__Valid_from__c, sirenum__Valid_until__c FROM sirenum__Ticket__c
                                              WHERE sirenum__TicketType__c IN: setCompetencyTypeId ];
        Set<id> setTicketsId = new set<id>();
        for(sirenum__Ticket__c tk : lstTicket){
            setTicketsId.add(tk.id);
        }                                    
        System.debug(setTicketsId.size()+'==setTicketsId=='+setTicketsId);
        System.debug('==setCandidateId=='+setCandidateId);
        List<sirenum__Ticket__c> lstCompetencies = new List<sirenum__Ticket__c>();
        if(!setTicketsId.isEmpty()){
            if(!setCandidateId.isEmpty()){
                lstCompetencies = [SELECT id,sirenum__Owner__r.Name,sirenum__TicketType__r.Name,sirenum__Valid_from__c,sirenum__Valid_until__c
                                   FROM sirenum__Ticket__c WHERE id IN: setTicketsId AND sirenum__Owner__r.id IN: setCandidateId LIMIT 10];
            }
        }else{
          /* if(!setCandidateId.isEmpty()){
             lstCompetencies = [SELECT id,sirenum__Owner__r.Name,sirenum__TicketType__r.Name,sirenum__Valid_from__c,sirenum__Valid_until__c
                                FROM sirenum__Ticket__c WHERE sirenum__Owner__r.id IN: setCandidateId LIMIT 10];
           } */
           return null;
        }
        //System.debug('==lstCompetencies=='+lstCompetencies.size());
       /* if(!lstCompetencies.isEmpty()){
            return lstCompetencies;
        }else{
            if(!setCandidateId.isEmpty()){
             lstCompetencies = [SELECT id,sirenum__Owner__r.Name,sirenum__TicketType__r.Name,sirenum__Valid_from__c,sirenum__Valid_until__c
                               FROM sirenum__Ticket__c WHERE sirenum__Owner__r.id IN: setCandidateId LIMIT 10];
           } 
           return lstCompetencies;
        }*/
        return lstCompetencies;
    }
     
    
    
}