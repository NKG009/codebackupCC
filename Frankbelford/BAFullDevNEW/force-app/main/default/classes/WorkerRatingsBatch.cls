/**
 * Copyright Sirenum (C) 2022
 * 
 * Batchable class to calculate Account.AverageWorkerRating from
 * Account.Worker_Ratings__r's within last x days
 * 
 */

public class WorkerRatingsBatch implements Database.Batchable<SObject> {
    /**
     * The results of the query retruned by this method will be split into batches
     * based on the batch size used when invoking the batch
     *
     * @param context Database batch context (not used)
     *
     * @return Query for Accounts to calculate rating for
     */
    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator(
            'Select Id, Average_Worker_Rating__c ' + 
            'FROM Account '
        );
    }

    /**
     * Calculate Average Worker Ratings
     *
     * @param context Batch context (not used)
     * @param scope List of objects (accounts) to process in this batch
     */
    public void execute(Database.BatchableContext context, List<Object> scope) {
        //Prepare record lists/maps
        List<Account> accounts = (List<Account>)scope;
        Map<Id, Account> accountsById = new Map<Id, Account>(accounts);
        List<Account> accountsToUpdate = new List<Account>();

        Integer lookbackDays =  (Integer)Worker_Rating_Setting__mdt.getInstance('Default').Lookback_Days__c;
        Date lookbackDate = Date.Today().addDays(-1* lookbackDays);
        
        //Get average ratings for the Accounts in this batch
        AggregateResult[] results = [
            SELECT Account__c, AVG(Rating__c)
            FROM Worker_Rating__c
            WHERE CreatedDate >= :lookbackDate and Account__c IN :accountsById.keySet()
            GROUP BY Account__c
        ];

        for (AggregateResult result : results) {
            Account account = accountsById.get((Id)result.get('Account__c'));
            Decimal originalValue = account.Average_Worker_Rating__c;
            Decimal newValue = (Decimal)result.get('expr0');

            if (originalValue != newValue) {
                account.Average_Worker_Rating__c = newValue;
                accountsToUpdate.add(account);
            }

            //Remove account from accountsById ...
            //... to facilitate re-nulling of accounts with no recent ratings
            accountsById.remove(account.Id);
        }

        //Any items remaining in map have no recent ratings. Check the average is null.
        for (Account account : accountsById.values()) {
            if (account.Average_Worker_Rating__c != null) {
                account.Average_Worker_Rating__c = null;
                accountsToUpdate.add(account);
            }
        }

        //Update with new, non-null values
        update accountsToUpdate;
    }

    public void finish(Database.BatchableContext context) {
        // Nothing to do here
    }
}