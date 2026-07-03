public without sharing class AccountService {
    public static Set<String> getBillingAccountNumbersFromBillingAccounts(List<Account> billingAccounts) {
        Set<String> billingAccountNumbers = new Set<String>();

        for (Account billingAccount : billingAccounts) {
            billingAccountNumbers.add(billingAccount.AccountNumber);
        }

        billingAccountNumbers.remove(null);

        return billingAccountNumbers;
    }
}