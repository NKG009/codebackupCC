trigger AccountPlanRevTrigger on AccountPlan (after update) {

      Set<id> APids = new Set<id>();
      Set<id> APids2 = new Set<id>();       

  if(AccountPlanRentTriggerHandler.isFirstTime)
   {    AccountPlanRentTriggerHandler.isFirstTime = false;
             For (AccountPlan AP:Trigger.new){
                 if(AP.RecordTypeId == '012Dp000000gjLNIAY') {
                        APids.add(AP.id);
                   {AccountPlanRE_Formula.CalcRentElect(APids);}
                   system.debug('APids**'+APids);
                   }
  }}       
}