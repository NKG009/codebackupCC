global class BatchForArchivingPropertiesInSF implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        string query='select id,Agency_Account__c,Access_Token__c from Agency_Integration_Info__c ';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, list<Agency_Integration_Info__c> AIIreclist ){
        
        for(Agency_Integration_Info__c aiirec :AIIreclist){
            GetArchivedProperties(aiirec.Agency_Account__c,aiirec.Access_Token__c);
            
        }
        
    }
    
    global void finish(Database.BatchableContext BC){ 
        SchedularforArchivingPropertiesInSF.reschedulebatch();
        
    }
    
    
    public static void GetArchivedProperties(string agencyid ,string Accesstoken){
        try{
        integer Offset=0;
        //integer limits=100;
       // integer recordcount=0;
        integer loopsize=1;
        list<account> acclisttoupdate = new list<account>();
        Map<string,Id> propIdToExtid = new Map<string,Id> ();
         List<ArchivingPropertyWrapper> responselist  = new List<ArchivingPropertyWrapper>();
        
        Agency_Account_Integration_Info__mdt [] aaii =[select MasterLabel,Archive_Url__c from Agency_Account_Integration_Info__mdt limit 1];

        for(account accrec:[select id,External_ID__c from account where parentid=:agencyid]){
            propIdToExtid.put(accrec.External_ID__c,accrec.id);
        }
        
        for(integer i=0; i<loopsize; i++){
            //https://app.propertyme.com/api/v1/lots/archived?Offset=0&Limit=100
            Http http = new Http();
            HttpRequest httpReq = new HttpRequest();
            httpReq.setMethod('GET');
            httpReq.setEndPoint(aaii[0].Archive_Url__c+'?Offset='+Offset+'&Limit=100');
            httpReq.setHeader('Content-Type','application/x-www-form-urlencoded');
            httpReq.setHeader('Accept' , 'application/json');
            httpReq.setHeader('Authorization' , 'Bearer '+Accesstoken);
            HttpResponse httpRes = http.send(httpReq);
            if(httpRes.getStatusCode() == 200) {
                system.debug('response allArchived properties='+httpRes.getBody());
               // String replaceIllegal= res.getbody().replaceAll('\n','').replaceAll('\r','');
                responselist = (list<ArchivingPropertyWrapper>)JSON.deserialize(httpRes.getBody(), list<ArchivingPropertyWrapper>.class);
                system.debug('responselist all Archived properties==='+responselist);
                 system.debug('responselistsize'+responselist.size());
                   if(responselist.size()>=99){
                       loopsize=loopsize+1;
                       Offset=Offset+100;
                   }
                for(ArchivingPropertyWrapper arcproprec :responselist){
                   system.debug('arcproprec.id'+arcproprec.id);
                    if(propIdToExtid.containsKey(arcproprec.id)){
                        account a = new account();
                        a.Id=propIdToExtid.get(arcproprec.id);
                        a.Archived_in_PropertyMe__c=true;
                        a.Archived_in_PropertyTree__c=true;
                        acclisttoupdate.add(a);
                        
                    }
                }
            }
            
        }
        system.debug('acclisttoupdate'+acclisttoupdate);
        if(acclisttoupdate.size()>0){
            update acclisttoupdate;
        }
        
        
        } 
         catch(Exception ex){
        Error_Log__c errorLog = new Error_Log__c();
            errorLog.Error_Type__c = 'ERROR';
            errorLog.Error_Status_Code__c = '';
            errorLog.Error_Message__c = ex.getMessage();
            errorLog.Error_Description__c = 'Error while processing the request:'+ ex;
            errorLog.Class_Name__c = 'BatchForArchivingPropertiesInSF';
            errorLog.Method_Name__c = 'BatchForArchivingPropertiesInSF.GetArchivedProperties';
            insert errorLog;
          }    
    }
}