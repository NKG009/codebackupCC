// 6/21/2016    Geoff Flynn    Stratus360
//            This trigger was migrated from the old Salesforce instance.  No changes were made



trigger CalculateBuldRate on ContractService__c (before insert, before update) {

    for (ContractService__c c : Trigger.new)
    {
        
        /* Removed by Request on July 09th, 2009 (No % Discount included on Bulk Rate)        
        if (c.Disc__c > 0)
           c.Bulk_Rate__c = (c.Ind_Rate__c * c.Count__c) - (c.Ind_Rate__c * c.Count__c * c.Disc__c / 100);
        else
           c.Bulk_Rate__c = c.Ind_Rate__c * c.Count__c;
        */
        
        if (c.Ind_Rate__c != null && c.Count__c != null) {
            c.Bulk_Rate__c = c.Ind_Rate__c * c.Count__c;
        }
    }
}