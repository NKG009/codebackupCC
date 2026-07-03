/*
* Class Name: ScheduleBatchCalculateIdeaPoints.
* Description: This is to schedule the batch class- BatchCalculateIdeaPointsAfterSevendays
* Test Class: TestBatchCalculateIdeaPoints
* Date : 5th June 2019
*/

global class ScheduleBatchCalculateIdeaPoints implements Schedulable{
    
    /*
    * Method Name: execute.
    * Description: Overidden method of Schedulable class. just to execute the batch class- BatchCalculateIdeaPointsAfterSevendays
    * Parameters : SchedulableContext
    * Return Type: Void
    * Date : 5th June 2019
    */
    global void execute(SchedulableContext sc) {
        BatchCalculateIdeaPointsAfterSevendays batchInstance = new BatchCalculateIdeaPointsAfterSevendays(); 
        database.executebatch(batchInstance,200);
    }
}