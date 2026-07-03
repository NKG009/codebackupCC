global class ScheduleBeeLineBatchHeaderClass implements Schedulable{

  /*
    Run every 30 mins on Tuesady and Wednesday. 
  */
  //public static final String CRON_EXPR = '0 0,30 * ? * TUE-WED';
  
    global void execute(SchedulableContext SC) {
        List<AsyncApexJob> job = [SELECT Id, Status,createddate FROM AsyncApexJob WHERE ApexClass.name = 'BeelineBatchHeaderClass' 
        and status not in ('Completed','Aborted','Failed')];
        if(job.isEmpty()){
            BeelineBatchHeaderClass beeLine = new BeelineBatchHeaderClass(); 
            database.executebatch(beeLine,1);
        }
    }
}