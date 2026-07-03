public class TestHelper_Territory {
    
	public static territory__c createTerritory(String territoryName, Boolean insertRecord){
        return createTerritory(territoryName, null, null, insertRecord);
    }
    
    public static territory__c createTerritory(String territoryName, String market, String customerCategory, Boolean insertRecord){
        
        User u = TestHelper_User.createUser('Fayaz', 'Shaik', 'fshaik',insertRecord);
        
        territory__c a = new territory__c();
        a.Name = territoryName;
        a.Sales_Rep__c = u.id;
        
        if(insertRecord) {
            insert a;
        }

        return a;
    }
}