trigger ClearFutureEffectiveValues on CustomContract__c (before update) 
{
    
    for (CustomContract__c c : Trigger.new)
    {
        if (c.FutureEffectiveClearFlag__c == true)
        {
            string contractID = c.id;
            
            //Get the list of sercices Present and Future related to the Contract to be updated
            List<ContractService__c> contractServicePresent = [select id, Status__c, Contract__c, Service__c, Count__c, Ind_Rate__c, Disc__c, Bulk_Rate__c, Z_Inactive_Date__c from ContractService__c where Contract__c =: contractID and Status__c =: 'Present' order by Service__c];
 
                
            double totalBulk = 0;
            //Calculate Bulk Rate
            for (ContractService__c pre: contractServicePresent )
            {
                totalBulk += pre.Bulk_Rate__c;
            }
                
            c.Monthly_Revenue__c = totalBulk;
            c.FutureEffectiveFlag__c = false;
            c.FutureEffectiveClearFlag__c = false; 
            c.future_effective_date__c = null;

        }

        
    }
    
}