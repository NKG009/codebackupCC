global class UpdateUserFromContactClass {
 @future 
    public static void updateUser(Set<ID> conID) {
        Boolean clientPortalUser = false;
        List<Contact> Con = [select id,Phone,MobilePhone,Email,FirstName,LastName,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,sirenum__National_Insurance__c
                    from Contact
                    where Id in : conID];
        
        if (con.size()>0 ) {
        List<User> u = [Select id,City,Phone,street,state,Profile.Name,PostalCode,Country,NI_Number__c,MobilePhone,FirstName,LastName,Email from user where ContactId =:con[0].id limit 1];        
        if(u.size()>0){
            if(u[0].Profile.Name==System.Label.Client_Portal_User_Profile){
               clientPortalUser = true;
            }
            u[0].City = con[0].MailingCity;
            u[0].street = con[0].MailingStreet;
            u[0].state = con[0].MailingState;
            u[0].PostalCode = con[0].MailingPostalCode;
            u[0].Country = con[0].MailingCountry;
            u[0].Phone = con[0].Phone;
            u[0].NI_Number__c = con[0].sirenum__National_Insurance__c;
            u[0].MobilePhone = con[0].MobilePhone;
            u[0].FirstName = con[0].FirstName;
            u[0].LastName = con[0].LastName;
            u[0].Email = con[0].Email;
            if(clientPortalUser){
                u[0].username = con[0].Email;
            }
            update u;  
            }
        }
    }

}