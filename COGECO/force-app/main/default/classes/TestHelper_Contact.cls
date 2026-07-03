public class TestHelper_Contact {
    
    public static Contact createContact(String Title, String firstName, String lastName, String Phone, String MobilePhone, String Fax, String Email, Id AccountId, Boolean insertRecord){
        
        Contact c = new Contact();
		c.Title = Title;
        c.FirstName = firstName;
        c.LastName = lastName;
        c.Phone = Phone;
        c.MobilePhone = MobilePhone;
        c.Fax = Fax;
        c.Email = Email;
        c.AccountId = AccountId;
        
        if(insertRecord) {
            insert c;
        }

        return c;
    }
}