trigger UpdateShift on sirenum__Shift__c (before insert, before update) {

set<Id> jobrolId = new set<Id>();
set<Id> shiftId = new set<Id>();

if(Trigger.IsInsert)
{
    for(sirenum__Shift__c sh: trigger.new)
    {
      jobrolId.add(sh.sirenum__Team__c);
      shiftId.add(sh.id);
        
    }
}
If(Trigger.IsUpdate)
{
    for(sirenum__Shift__c sh: trigger.new)
    {
        sirenum__Shift__c shift = Trigger.oldMap.get(sh.ID);
            if(sh.Shift_Length_from_Break__c == null || shift.sirenum__Scheduled_Start_Time__c != sh.sirenum__Scheduled_Start_Time__c || shift.sirenum__Scheduled_End_Time__c != sh.sirenum__Scheduled_End_Time__c){
                    jobrolId.add(sh.sirenum__Team__c);
                    shiftId.add(sh.id);
        }
    }
} 
    system.debug('jobrolId '+jobrolId);
if(jobrolId.size()>0)
{
        Decimal totalbrk = 0;
        String totalshiftlen;
        String breaklen;
        Integer Counter = 0;
    for(sirenum__Break_definition__c brklist : [Select id,sirenum__Minimum_shift_length__c,sirenum__Break_length__c from sirenum__Break_definition__c where sirenum__Team__c in : jobrolId AND sirenum__Is_Paid__c = FALSE Order By sirenum__Minimum_shift_length__c Desc])
    {
    Counter ++;
        if(totalshiftlen == Null)
        {
        totalshiftlen  = String.ValueOf(brklist.sirenum__Minimum_shift_length__c);
        }
        else
        {
       totalshiftlen = totalshiftlen + '&' +String.ValueOf(brklist.sirenum__Minimum_shift_length__c);}
        totalbrk = totalbrk + brklist.sirenum__Break_length__c;
        if(breaklen== Null)
        {
        breaklen= String.ValueOf(brklist.sirenum__Break_length__c);
        }
        else
        {
       breaklen= breaklen+ '&' +String.ValueOf(brklist.sirenum__Break_length__c);}
     
    }
    system.debug('totalbrk '+totalbrk );   
    if(totalbrk >0 && totalshiftlen != null){
        
        for(sirenum__Shift__c sh: trigger.new)
        {
        
            sh.Shift_Length_from_Break__c =  totalshiftlen;
            sh.Break_from_Brekdef__c = totalbrk;
            If(Counter >1)
            {
                sh.Total_Shift_BreakLength__c = breaklen;
            }
            else
            {sh.Total_Shift_BreakLength__c=Null;
            }
        }
    }
     
}
}