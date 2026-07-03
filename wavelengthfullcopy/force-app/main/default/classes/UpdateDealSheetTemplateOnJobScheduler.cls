/**
* Date: 20/12/2023
* Description: UpdateDealSheetTemplaeOnJobBatch Scheduler class
* Case No. : UPP-61 
**/
public class UpdateDealSheetTemplateOnJobScheduler implements Schedulable {

    public void execute(SchedulableContext sc) {
        UpdateDealSheetTemplateOnJobBatch batch = new UpdateDealSheetTemplateOnJobBatch();
        Database.executeBatch(batch, 1);
    }
}