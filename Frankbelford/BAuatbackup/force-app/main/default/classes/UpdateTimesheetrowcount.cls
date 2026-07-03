public class UpdateTimesheetrowcount {
    
    public static void updatedata(List<sirenum__Timesheet_Line__c> tllist)
    {
        Set<id> outboundid = new Set<id>();
        Set<id> timeid = new Set<id>();
        Map<id,Decimal> TLAppCountMap = new Map<id,Decimal>();
        for(sirenum__Timesheet_Line__c tl: tllist)
        {
            outboundid.add(tl.IP_OutboundID__c);
            timeid.add(tl.sirenum__timesheet__c);
        }
      //  List<sirenum__Timesheet_Line__c> totalines = [Select id,IP_OutboundID__c,sirenum__timesheet__c from sirenum__Timesheet_Line__c where sirenum__Timesheet__c in:outmap.values()];
      
      AggregateResult[] groupedResults  = [SELECT sirenum__timesheet__c timerecid, count(id) childcount FROM sirenum__Timesheet_Line__c where sirenum__timesheet__c in:timeid GROUP BY sirenum__timesheet__c];
        for (AggregateResult ar : groupedResults)  {
            Id timesheetid = (Id) ar.get('timerecid');
            Integer numlines = (Integer) ar.get('childcount');
            TLAppCountMap.put(timesheetid,numlines);
        }
        system.debug('map check'+TLAppCountMap);
        List<IP_OutboundDataTransfer__c> oblist = [Select id,IP_RowCount__c,IP_TimesheetID__c from IP_OutboundDataTransfer__c where id in:outboundid];
        for(IP_OutboundDataTransfer__c ob: oblist)
        {
            ob.IP_RowCount__c = TLAppCountMap.get(ob.IP_TimesheetID__c);
        }
        update oblist;
    }
}