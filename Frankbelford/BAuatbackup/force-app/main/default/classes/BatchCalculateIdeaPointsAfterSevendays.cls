/*
* Class Name: BatchCalculateIdeaPointsAfterSevendays.
* Description: Batch Class to divide IP_TotalPoints__c by 2 after 7 days
* Test Class: 
* Date : 5th June 2019
*/
global class BatchCalculateIdeaPointsAfterSevendays implements Database.Batchable<sObject>{
    
    /*
    * Method Name: start
    * Description: Start method to query all records where IP_TotalPoints__c>5 and CreatedDate is less than 7 days
    * Parameters : Database.BatchableContext BC
    * Return Type: Database.QueryLocator
    */  
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'Select id,Name,CreatedDate,IP_Points__c,IP_TotalPoints__c from Idea__c where CreatedDate<=LAST_N_DAYS:7 and IP_TotalPoints__c!=null and IP_TotalPoints__c>5 limit 2000';
        if(Test.isRunningTest()){
            query = 'Select id,Name,CreatedDate,IP_Points__c,IP_TotalPoints__c from Idea__c where IP_TotalPoints__c!=null and IP_TotalPoints__c>5 limit 2000';
        }
        system.debug('+++++++++++++++'+query);
        return Database.getQueryLocator(query);
    }
    
    /*
    * Method Name: execute
    * Description: execute method to process all records
    * Parameters : Database.BatchableContext BC, List<Idea__c> ideaList
    * Return Type: void
    */
    global void execute(Database.BatchableContext BC, List<Idea__c> ideaList) {
        List<Idea__c> listUpdateIdea = new List<Idea__c>();
        
        for(Idea__c idea : ideaList){
            idea.IP_TotalPoints__c = Math.FLOOR((idea.IP_TotalPoints__c)/2);
            listUpdateIdea.add(idea);
            system.debug('+++++listUpdateIdea++++++++++'+listUpdateIdea);
        }
        update listUpdateIdea;
    }
    
    /*
    * Method Name: finish
    * Description: finish method
    * Parameters : Database.BatchableContext BC
    * Return Type: void
    */
    global void finish(Database.BatchableContext BC) {
    }
}