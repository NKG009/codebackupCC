public class Toe_UserCreatedFuture {

    @future
    public static void createUser(Set<ID> conId){
        Database.SaveResult[] sList;
         List<Id> errorIds = new List<Id>();
         String errorFile = 'Id,Error\n';
         Map<Id,String> Errmsg = new Map<Id,String>();
        Profile p = [Select id from Profile where name='User Portal' Limit 1];
        UserRole role = [select id from UserRole where name = 'Candidates Customer User' Limit 1];
        List<User> listuser = new List<User>();
        for(Contact con: [Select id,IP_Alias__c,sirenum__National_Insurance__c,Email,FirstName,LastName,MailingCity,MailingCountry,MobilePhone,Phone,MailingPostalCode,MailingState,MailingStreet from Contact where id in: conId and Id not in (Select Contactid from User) FOR UPDATE])
        {
            User u = new User();
            u.FirstName = con.FirstName;
            u.LastName = con.LastName;
            u.Email = con.Email;
            u.Username = con.Email;
            u.Alias = con.IP_Alias__c;
            u.CommunityNickname = con.IP_Alias__c;
            u.LanguageLocaleKey = 'en_US';
            u.ProfileId = p.Id;
            if(!test.isRunningTest()){
                u.UserRoleId = role.id;}
            u.State = con.MailingState;
            u.Street = con.MailingStreet;
            u.City = con.MailingCity;
            u.Country = con.MailingCountry;
            u.PostalCode = con.MailingPostalCode;
            u.Phone = con.Phone;
            u.MobilePhone = con.MobilePhone;
            u.ContactId = con.Id;
            u.TimeZoneSidKey = 'Europe/London';
            u.LocaleSidKey = 'en_GB';
            u.EmailEncodingKey = 'ISO-8859-1';
            u.NI_Number__c = con.sirenum__National_Insurance__c;
           listuser.add(u);
           
        }
     if(listuser.size()>0){
    
       insert listuser;
     
    
     }
    
    
   
    }
}