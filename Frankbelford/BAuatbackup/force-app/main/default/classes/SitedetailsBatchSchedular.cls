global class SitedetailsBatchSchedular implements Schedulable{

    global void execute(SchedulableContext sc) {
        SitedetailsBatch sitedetail = new SitedetailsBatch(); 
        database.executebatch(sitedetail ,1);
    }

}