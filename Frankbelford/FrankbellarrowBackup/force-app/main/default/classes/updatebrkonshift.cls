public class updatebrkonshift
{
      @future
       public static void updateshift(Set<Id> shiftId, Decimal Shiftlen, Decimal breaklen)
       {
       If(checkrecursiveshiftbreak.runOnce())
{
           List<sirenum__Shift__c> shlist = [Select id from sirenum__Shift__c where id in: shiftId];
       If(shlist.size()>0)
       {
        for(sirenum__Shift__c sh:shlist )
        {
            sh.Shift_Length_from_Break__c = String.ValueOf(Shiftlen);
            sh.Break_from_Brekdef__c = breaklen;
        }

            update shlist;
       }
       }
       }
}