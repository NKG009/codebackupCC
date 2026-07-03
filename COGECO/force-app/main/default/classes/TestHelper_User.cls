public class TestHelper_User {
   
    public static User createUser(String firstName, String lastName,String alias,Boolean insertRecord){
        
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
       User u = new User(Alias = alias, Email= alias + '@myorg.com', 
          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/New_York', UserName= alias + '@myorg.com'); 
        
        if(insertRecord) {
            insert u;
        }

        return u;
    }
}