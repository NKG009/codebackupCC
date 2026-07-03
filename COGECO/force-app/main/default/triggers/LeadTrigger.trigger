trigger LeadTrigger on Lead (before insert, before update, after insert, after update) {
    

    //  Handle Spotio lead auto-conversion after insert
    if (Trigger.isAfter && Trigger.isUpdate) {
        LeadAutoConvertHandler.convertSpotioLeads(Trigger.new);
   }
}