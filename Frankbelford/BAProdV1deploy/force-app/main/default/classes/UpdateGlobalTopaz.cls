public class UpdateGlobalTopaz{
  @InvocableMethod
  public static void getTopazId(List<Id> siteId) {
  List<String> slnum = new List<String>();
   List<sirenum__Site__c> slist = new  List<sirenum__Site__c>();
  List<sirenum__Site__c> sitelist = [Select id, IP_SLNUpdateValue__c,GlobalClientName__c from sirenum__Site__c where id in : siteId];
  List<Id> TopazId = new List<Id>();
  
  for(sirenum__Site__c st: sitelist)
  {
  slnum.add(st.IP_SLNUpdateValue__c);
  
  }
  
  List<IP_TopazGlobalClientInformation__c> topazs= [SELECT id,IP_SalesLedgerNumber__c  FROM IP_TopazGlobalClientInformation__c WHERE IP_SalesLedgerNumber__c in :slnum];
    
    if(topazs.size()>0)
    {
    for (IP_TopazGlobalClientInformation__c topaz: topazs) {
   
        for(sirenum__Site__c site : sitelist )
        {
        If(site.IP_SLNUpdateValue__c == topaz.IP_SalesLedgerNumber__c )
        {
            site.GlobalClientName__c =Topaz.id;
        slist.add(site);
        }
        }
       }
       }
  
       update slist;
    
  }
}