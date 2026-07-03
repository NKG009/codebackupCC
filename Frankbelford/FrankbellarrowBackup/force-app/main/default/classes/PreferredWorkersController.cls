public without sharing class PreferredWorkersController{
    @AuraEnabled
    public static wrapperPreferredWorker getPreferredCounts(String siteId){//jyothi
       wrapperPreferredWorker worker = new wrapperPreferredWorker();
       worker.preferredCount = getEndorsements(siteId);//jyothi
       worker.activeCount = getShifts();
       
       return worker;
        
    }

    public static Integer getEndorsements(String selectSites){//jyothi
    
        
        //jyothi.start
        /*for(sirenum__Site__c site: SiteManagementComponentController.getSitesOfLoggedInUser()){
            setSiteIds.add(site.Id);
        }*/
        Set<String> setSiteIds = new Set<String>();
        if(selectSites == '"All"'){
            for(sirenum__Site__c site: SiteManagementComponentController.getSitesOfLoggedInUser()){
                setSiteIds.add(site.Id);
            }
        }else{
            //jyothi
            for(String s: (List<String>)JSON.deserialize(selectSites,List<String>.Class)){
                setSiteIds.add(s);
            }            
        }
        system.debug('##selectSites:'+selectSites);
        system.debug('##setSiteIds:'+setSiteIds);
        //jyothi.stop
        AggregateResult[] endorsements =  [SELECT Count(Id), Candidate__c candidate from Endorsement__c where Candidate__c != null and Site__c =: setSiteIds and CreatedDate >= last_N_MONTHS:6 group by Candidate__c];
        return (!endorsements.isEmpty())?endorsements.size():0;
    }
    
    public static Integer getShifts(){
        return 0;
        //AggregateResult[] endorsements =  [SELECT Count(Id), sirenum__Contact__c candidate from sirenum__Shift__c where sirenum__Contact__c != null and CreatedDate = last_N_MONTHS:6 group by sirenum__Contact__c];
        //return (!endorsements.isEmpty())?endorsements.size():0;
    }
    
    public class wrapperPreferredWorker{
        @AuraEnabled public Integer preferredCount;
        @AuraEnabled public Integer activeCount;
    }

    

    @AuraEnabled
    public static void moveRecentWorkerRecord(String preferredData){
        Id recordId;
        Set<Id> recordIds = new Set<Id>();
        List<WorkerRecord> workerRecords = (List<WorkerRecord>)JSON.deserialize(preferredData,List<WorkerRecord>.Class);
        system.debug('###workerRecords:'+workerRecords);
        for(WorkerRecord w: workerRecords){
            for(JobRecord r: w.jobRecords){
                if(r.selected){
                    recordId = r.jobTypeId.split('#')[1];
                    recordIds.add(recordId);
                }
            }
        }
        system.debug('###recordIds:'+recordIds);
        if(recordId != null && !recordIds.isEmpty()){
            //jyothi
            List<sirenum__Shift__c> shifts = [SELECT Id,IP_Account__c,sirenum__Team__r.Job_Category_Filtered__c, sirenum__Contact__c, sirenum__Site__c From sirenum__Shift__c where Id IN: recordIds];        
           
            List<Endorsement__c> endorsements = new List<Endorsement__c>();
            for(sirenum__Shift__c shift: shifts ){
             system.debug('###shift:'+shift);
                endorsements.add(new Endorsement__c(
                    Job_Category__c = shift.sirenum__Team__r.Job_Category_Filtered__c, 
                    Candidate__c = shift.sirenum__Contact__c, 
                    Account__c = shift.IP_Account__c,//jyothi
                    Endorsed_By__c = userinfo.getUserId(),//jyothi
                    Endorsement_Date__c = date.today(),//jyothi
                    Site__c = shift.sirenum__Site__c));
            }
            
            if(!endorsements.isEmpty()){
                insert endorsements;
            }

        }
    }

    @AuraEnabled
    public static void deletePreferredWorker(String preferredData){
        Id recordId;
        Set<Id> recordIds = new Set<Id>();
        List<WorkerRecord> workerRecords = (List<WorkerRecord>)JSON.deserialize(preferredData,List<WorkerRecord>.Class);
        for(WorkerRecord w: workerRecords){
            for(JobRecord r: w.jobRecords){
                if(!r.selected){
                    recordId = r.jobTypeId.split('#')[1];
                    recordIds.add(recordId);
                }
            }
        }
        system.debug('###1:'+recordId );
        system.debug('###2:'+recordIds);
        if(recordId != null && !recordIds.isEmpty()){
           delete database.query('SELECT Id from '+recordId.getsobjecttype()+' Where Id IN:recordIds');
        }
    }
    
    @AuraEnabled
    public static List<WorkerRecord> getWorkers(String siteId){
        user cUser = [SELECT Id from User Where Id=: userInfo.getUserId()]; 
        
        Map<Id, List<Endorsement__c>> mapCandidates = new Map<Id, List<Endorsement__c>>();
        
        Set<Id> setSiteIds = new Set<Id>();

        if(siteId == 'All'){
            for(sirenum__Site__c site: SiteManagementComponentController.getSitesOfLoggedInUser()){
                setSiteIds.add(site.Id);
            }
        }else{
            setSiteIds.add(siteId);
        }
        
        
        List<Endorsement__c> endorsements = [SELECT Id,Account__c,Composite_Id__c,Candidate__c,Endorsed_By__c,Endorsement_Date__c,
            Candidate__r.sirenum__Last_Timesheet__c,
            EndorsementID__c, Job_Category__c,Site__c,Candidate__r.Name,Site__r.Name,Job_Category__r.Name, LastModifieddate from Endorsement__c 
            //Where Candidate__c != null and Endorsed_By__c =: userInfo.getUserId() and LastModifiedDate = LAST_N_MONTHS:3
            Where Candidate__c != null and Site__c =: setSiteIds order by Candidate__r.LastName asc//jyothi
            //and LastModifiedDate = LAST_N_MONTHS:3
            ];
        
        
        for(Endorsement__c endorsement: endorsements){
            if(!mapCandidates.containsKey(endorsement.Candidate__c))mapCandidates.put(endorsement.Candidate__c, new List<Endorsement__c>());
            mapCandidates.get(endorsement.Candidate__c).add(endorsement);
        }
        
        List<WorkerRecord> WorkerRecords = new List<WorkerRecord>();
        
        for(Id candidateId: mapCandidates.keyset()){
            String workerName; 
            String lastWorked='';
            List<JobRecord> jobRecords = new List<JobRecord>();
            for(Endorsement__c endorsement: mapCandidates.get(candidateId)){
                workerName = endorsement.Candidate__r.Name;
                lastWorked = (endorsement.Candidate__r.sirenum__Last_Timesheet__c != null)?
                (endorsement.Candidate__r.sirenum__Last_Timesheet__c).Day()+'-'+(endorsement.Candidate__r.sirenum__Last_Timesheet__c).Month()+'-'+ (endorsement.Candidate__r.sirenum__Last_Timesheet__c).year()
                :'';
                String sincePreferred = (endorsement.Endorsement_Date__c != null)?String.valueOf(endorsement.Endorsement_Date__c.day()+'-'+endorsement.Endorsement_Date__c.month()+'-'+endorsement.Endorsement_Date__c.year()):'';
                
                JobRecord jobRecord = new JobRecord(candidateId+'#'+endorsement.Id,endorsement.Job_Category__r.Name, endorsement.Site__r.Name, sincePreferred, 'Preferred Worker', true);
                jobRecords.add(jobRecord);
            }
            WorkerRecord workerRecord = new WorkerRecord(candidateId,workerName, lastWorked, jobRecords);            
            WorkerRecords.add(workerRecord);
        }
        return WorkerRecords;
        
    }
    @AuraEnabled
    public static List<WorkerRecord> getActiveWorkers(String siteId){
    
        Set<Id> setSiteIds = new Set<Id>();

        if(siteId == 'All'){
            for(sirenum__Site__c site: SiteManagementComponentController.getSitesOfLoggedInUser()){
                setSiteIds.add(site.Id);
            }
        }else{
            setSiteIds.add(siteId);
        }
        
        user cUser = [SELECT Id from User Where Id=: userInfo.getUserId()]; 
        
        Map<Id, List<sirenum__Shift__c>> mapCandidates = new Map<Id, List<sirenum__Shift__c>>();
        
        String query = 'SELECT Id,Name,sirenum__Contact__c,sirenum__Scheduled_Start_Time__c, ';
            query +='sirenum__Contact__r.sirenum__Last_Timesheet__c,';
            query +='sirenum__Contact__r.Name, sirenum__Job_Type__c, sirenum__Team__r.Job_Category_Filtered__r.Name, LastModifieddate, sirenum__Site__r.Name from sirenum__Shift__c ';
            if(!test.isRunningTest())query +=' Where sirenum__Team__r.Job_Category_Filtered__c != null and sirenum__Contact__c != null and sirenum__Site__c != null ';
            if(!test.isRunningTest())query +=' And sirenum__Site__c =: setSiteIds and sirenum__Scheduled_Start_Time__c >= LAST_N_DAYS:14 ';
            query +=' Order by sirenum__Contact__r.LastName, sirenum__Scheduled_Start_Time__c asc';//jyothi
        List<sirenum__Shift__c> shifts = database.query(query);  
                  
        
        Set<String> setShiftCompositeKeys = new Set<String>();
        for(sirenum__Shift__c shift: shifts ){
            setShiftCompositeKeys.add(shift.sirenum__Team__r.Job_Category_Filtered__c +''+ shift.sirenum__Contact__c +''+ shift.sirenum__Site__c );
        }
        Set<String> setEndorsementCompositeKeys = new Set<String>();
        if(!setShiftCompositeKeys.isEmpty()){
            for(Endorsement__c en: [SELECT Id,Composite_Id__c from Endorsement__c Where Composite_Id__c IN: setShiftCompositeKeys]){
                setEndorsementCompositeKeys.add(en.Composite_Id__c);
            }
        }
        for(sirenum__Shift__c shift: shifts ){
            String key = shift.sirenum__Team__r.Job_Category_Filtered__c +''+ shift.sirenum__Contact__c +''+ shift.sirenum__Site__c;
            system.debug('##Key:'+shift.Id+'::'+key);
            if(!setEndorsementCompositeKeys.contains(key)){
                if(!mapCandidates.containsKey(shift.sirenum__Contact__c))mapCandidates.put(shift.sirenum__Contact__c, new List<sirenum__Shift__c>());
                mapCandidates.get(shift.sirenum__Contact__c).add(shift);
            }
        }
        
        setEndorsementCompositeKeys.clear();
        
        List<WorkerRecord> WorkerRecords = new List<WorkerRecord>();
        
        for(Id candidateId: mapCandidates.keyset()){
            String workerName; 
            String lastWorked='';
            List<JobRecord> jobRecords = new List<JobRecord>();
            for(sirenum__Shift__c shift: mapCandidates.get(candidateId)){
                String key = shift.sirenum__Team__r.Job_Category_Filtered__c +''+ shift.sirenum__Contact__c +''+ shift.sirenum__Site__c;
                
                if(!setEndorsementCompositeKeys.contains(key)){
                    setEndorsementCompositeKeys.add(key);
                    workerName = shift.sirenum__Contact__r.Name;
                    lastWorked = (shift.sirenum__Contact__r.sirenum__Last_Timesheet__c != null)?
                    (shift.sirenum__Contact__r.sirenum__Last_Timesheet__c).Day()+'-'+(shift.sirenum__Contact__r.sirenum__Last_Timesheet__c).Month()+'-'+ (shift.sirenum__Contact__r.sirenum__Last_Timesheet__c).year()
                    :'';
                    String sincePreferred = (shift.sirenum__Scheduled_Start_Time__c != null)?String.valueOf(shift.sirenum__Scheduled_Start_Time__c.day()+'-'+shift.sirenum__Scheduled_Start_Time__c.month()+'-'+shift.sirenum__Scheduled_Start_Time__c.year()):'';
                    JobRecord jobRecord = new JobRecord(candidateId+'#'+shift.Id,shift.sirenum__Team__r.Job_Category_Filtered__r.Name , shift.sirenum__Site__r.Name, sincePreferred, 'Preferred Worker',false);
                    jobRecords.add(jobRecord);
                }
            }
            WorkerRecord workerRecord = new WorkerRecord(candidateId,workerName, lastWorked, jobRecords);            
            WorkerRecords.add(workerRecord);
        }
        return WorkerRecords;
        
    }
    
    public class WorkerRecord {
        @Auraenabled public String workerId;
        @AuraEnabled public String workerName;
        @AuraEnabled public String lastWorked;
        @AuraEnabled public List<JobRecord> jobRecords;
        @AuraEnabled public Boolean isHidden;
        public WorkerRecord(String workerId, String workerName, String lastWorked, List<JobRecord> jobRecords){
            this.workerId = workerId;
            this.workerName = workerName;
            this.lastWorked = lastWorked;
            this.jobRecords = jobRecords;
            this.isHidden = true;
        }   
        
    }
    public class JobRecord{
        @AuraEnabled public String jobTypeId;
        @AuraEnabled public String jobType;
        @AuraEnabled public String site;
        @AuraEnabled public String preferredSince;
        @AuraEnabled public String preferredWorker;
        @AuraEnabled public Boolean selected;
        public JobRecord(String jobTypeId, String jobType, String site, String preferredSince, String preferredWorker, Boolean selected){
            this.jobTypeId = jobTypeId;
            this.jobType = jobType;
            this.site = site;
            this.preferredSince = preferredSince;
            this.preferredWorker = preferredWorker;
            this.selected = selected;
        }   
    }
}