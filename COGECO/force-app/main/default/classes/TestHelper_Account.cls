public class TestHelper_Account {
    
	public static Account createAccount(String accountName, Boolean insertRecord){
        return createAccount(accountName, null, null, insertRecord);
    }
    
    public static Account createAccount(String accountName, String market, String customerCategory, Boolean insertRecord){
        
        territory__c territory = TestHelper_Territory.createTerritory('R-O Tesco', true);
        Account a = new Account();
        a.Name = accountName;
        a.Market__c = 'HB Ontario';
        a.Territory__c = territory.id;
        
        if(insertRecord) {
            insert a;
        }

        return a;
    }
}