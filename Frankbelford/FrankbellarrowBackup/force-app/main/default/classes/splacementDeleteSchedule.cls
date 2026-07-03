global class splacementDeleteSchedule implements Schedulable{
 global void execute(SchedulableContext sc) {
      IP_ImpellamGlobalSetting__c imp = IP_ImpellamGlobalSetting__c.getOrgDefaults();
             Integer limit1 = Integer.valueOf(imp.S_placement_Deletion_Size__c);
     
        Placement_ShiftdeleteJob batchInstance = new Placement_ShiftdeleteJob(); 
        database.executebatch(batchInstance,limit1);
    }
}