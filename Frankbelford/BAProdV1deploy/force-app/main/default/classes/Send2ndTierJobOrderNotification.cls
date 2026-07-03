/**
 * Created by mrahman on 2020-08-27.
 */

global class Send2ndTierJobOrderNotification implements Schedulable, Database.AllowsCallouts {
    global void execute(SchedulableContext sc) {
        //JobOrderNotification jon = new JobOrderNotification();
        JobOrderNotification.notify2ndTierSupplier();
    }
}