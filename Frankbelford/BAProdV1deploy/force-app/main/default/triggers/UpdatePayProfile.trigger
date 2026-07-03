trigger UpdatePayProfile on IP_PayProfile__c (before insert, before update) {
Set<ID> umbid = new Set<ID>();

for(IP_PayProfile__c pf : trigger.new)
{
      umbid.add(pf.IP_UmbrellaName__c);    
}

list <IP_Umbrellalist__c> umblist = [SELECT IP_AddressLine1__c,Id,IP_AddressLine2__c,IP_AddressLine3__c,IP_BankAccountName__c,IP_BankAccountNumber__c,IP_BankSortCode__c,IP_BuildingSocietyNo__c,IP_CompanyRegNo__c,IP_OkToSupply__c,IP_PaymentType__c,IP_Postcode__c,IP_SupplierReference__c,VAT_Number__c,IP_VATRegistered__c,Name FROM IP_Umbrellalist__c where id IN:umbid];

 MAP<ID ,IP_Umbrellalist__c> mapUmb = new MAP<ID ,IP_Umbrellalist__c>();
 for(IP_Umbrellalist__c u : umblist)
 {
    mapUmb.put(u.id,u);
 }

 for(IP_PayProfile__c pprof : trigger.new)
 {
  
  if((trigger.isInsert && pprof.IP_UmbrellaName__c!=null) || (trigger.isUpdate && trigger.oldmap.get(pprof.Id).IP_UmbrellaName__c != pprof.IP_UmbrellaName__c) || (trigger.isUpdate && trigger.oldmap.get(pprof.Id).IP_Status__c!= pprof.IP_Status__c && pprof.IP_Status__c == 'Active'))  
    {
      if(mapUmb.containskey(pprof.IP_UmbrellaName__c))
      {
        IP_Umbrellalist__c ul = mapUmb.get(pprof.IP_UmbrellaName__c);
        pprof.IP_BusinessAddressLine1__c = ul.IP_AddressLine1__c;
        pprof.IP_BusinessAddressLine2__c = ul.IP_AddressLine2__c;
        pprof.IP_BusinessAddressCounty__c = ul.IP_AddressLine3__c;
        pprof.IP_BankAccountName__c= ul.IP_BankAccountName__c;
        pprof.IP_AccountNumber__c = ul.IP_BankAccountNumber__c;
        pprof.IP_SortCode__c = ul.IP_BankSortCode__c;
        pprof.IP_BuildingSocietyNumber__c = ul.IP_BuildingSocietyNo__c;
        pprof.IP_CompanyRegNo__c = ul.IP_CompanyRegNo__c;
        pprof.IP_OkToSupply__c = ul.IP_OkToSupply__c;
        if(ul.IP_PaymentType__c == 'B')
        {
            pprof.IP_PaymentType__c = 'BACS';
        }
        if(ul.IP_PaymentType__c == 'C')
        {                       
            pprof.IP_PaymentType__c = 'Cheque';
        }
        pprof.IP_BusinessAddressPostcode__c= ul.IP_Postcode__c;
        pprof.IP_SupplierReference__c = ul.IP_SupplierReference__c;
        pprof.IP_VATNumber__c = ul.VAT_Number__c;
        if(ul.IP_VATRegistered__c == 0)
                pprof.IP_VATRegistered__c = FALSE;
        
        else
        pprof.IP_VATRegistered__c = TRUE;
        pprof.IP_CompanyName__c = ul.Name;
        
      }
    }
 
 }


}