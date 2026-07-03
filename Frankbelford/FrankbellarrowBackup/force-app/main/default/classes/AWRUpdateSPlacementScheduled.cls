/* 
* Class Name: AWRUpdateSPlacementScheduled.
* Description: This is to schedule the batch class- AWRUpdateSPlacement
* Test Class: TEST_AWRUpdateSPlacement
* Author : Amit Kohli - Espire.
* Date : 26th Sep 2017
*/

global class AWRUpdateSPlacementScheduled implements Schedulable{
    
    /*
* Method Name: execute.
* Description: Overidden method of Schedulable class. just to execute the batch class- AWRUpdateSPlacement
* Parameters : SchedulableContext
* Return Type: Void
* Author : Amit Kohli - Espire.
* Date : 26th Sep 2017
*/
    global void execute(SchedulableContext sc) {
        AWRUpdateSPlacement batchInstance = new AWRUpdateSPlacement(); 
        database.executebatch(batchInstance);
    }
}