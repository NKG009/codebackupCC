global class BatchRefreshTokenPropertyMe implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        datetime currtime = system.now();
        string query;
        if(test.isRunningTest()){
             query='select id,Access_Token__c,Client_ID__c,Client_Secret__c,Refresh_Token__c from Agency_Integration_Info__c ';
        }
        else
        {
             query='select id,Access_Token__c,Client_ID__c,Client_Secret__c,Refresh_Token__c from Agency_Integration_Info__c where Expires_In_Date_Time__c<=:currtime';
        }
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, list<Agency_Integration_Info__c> AIIRecords ) {
        
        for(Agency_Integration_Info__c AII : AIIRecords){
            AgencyAccountAuthenticationController.GetRefreshToken(AII.Id);
        }       
       
    }
    global void finish(Database.BatchableContext BC){  
         SchedularForBatchRefreshTokenPropertyMe.reschedulebatch();
    }
}