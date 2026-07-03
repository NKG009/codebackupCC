public class Updatequeryvalue {
    
    public static void calculatevalue(Set<id> queryvaluecount)
    {
         Map<id,Decimal> AccCountMap = new Map<id,Decimal>();
         AggregateResult[] groupedResults  = [SELECT IP_Account__c accid, sum(IP_QueryValue__c) valuecount FROM IP_InvoiceQuery__c where IP_Account__c in:queryvaluecount GROUP BY IP_Account__c];
          for (AggregateResult ar : groupedResults)  {
            Id acctid = (Id)ar.get('accid');
            Decimal totalvalue = (Decimal) ar.get('valuecount');
            AccCountMap.put(acctid,totalvalue);
        }
        List<Account> accList = [Select id,IP_InvoiceQueryValue__c from Account where id in: AccCountMap.keySet()];
        for(Account a:accList)
        {
            a.IP_InvoiceQueryValue__c = AccCountMap.get(a.id);
        }
        update accList;
    }
}