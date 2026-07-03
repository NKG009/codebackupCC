@isTest
public class SanitizeContactsTest {
    @testSetup
    static void setup(){
        
        Manage_Triggers__c cs1 = new Manage_Triggers__c();
        cs1.Name = 'AccountTrigger';
        cs1.isActive__c = true;
        insert cs1;
    }
    public static testMethod void validateBeforeInsert() {
        
        Contact testContact = new Contact(
            MobilePhone = '0400000000',
            LastName = 'TestName'
        );
        insert testContact;
        
        Contact insertedContact = [SELECT MobilePhone FROM Contact WHERE Id = :testContact.Id];
        System.assertEquals(
            insertedContact.MobilePhone,
            '+61400000000'
        );
    }
    
    public static testMethod void validateBeforeUpdate() {
        
        Contact testContact = new Contact(
            LastName = 'TestName'
        );
        insert testContact;
        
        testContact.MobilePhone = '0400000000';
        update testContact;
        
        Contact updatedContact = [SELECT MobilePhone FROM Contact WHERE Id = :testContact.Id];
        System.assertEquals(
            updatedContact.MobilePhone,
            '+61400000000'
        );
        
    }
    
    static testMethod void validateAfterUpdate() {  
        try{  
            Account acc1 = new Account();
            acc1.Name = 'Account A';
            acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Property').getRecordTypeId();
            insert acc1;
            
            Account acc2 = new Account();
            acc2.Name = 'Account B';
            acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Property').getRecordTypeId();
            insert acc2;
            
            Contact con = new Contact();
            con.FirstName = 'Property';
            con.LastName = 'Contact';
            con.AccountId = acc1.Id;
            insert con;
            
            AccountContactRelation acr = new AccountContactRelation();
            acr.AccountId = acc2.Id;
            acr.ContactId = con.Id;
            acr.IsActive = true;
            acr.Roles = 'Property Manager';
            insert acr;
            
            con.Email = 'test@pmrealestate.com';
            update con;
            
            acc2 = [SELECT Current_PM_Email__c FROM Account WHERE Id = :acc2.Id];
            System.assertEquals(
                con.Email,
                acc2.Current_PM_Email__c
            );
            
            Contact con2 = new Contact();
            con2.FirstName = 'Propertyt';
            con2.LastName = 'Contactt';
            con2.AccountId = acc1.Id;
            con2.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Tenant').getRecordTypeId();
            con2.Preferred_Email_Raw__c ='p.moodley1173@gmail.com; info@palmstonerestoration';
            insert con2; 
            
            con2.Preferred_Email_Raw__c ='Trevor Dowley <dowleytrevor@gmail.com>';  
            update con2;
            
            con2.Preferred_Email_Raw__c ='p.moodley1173@gmail.com';  
            update con2;
            
            con2.Preferred_Email_Raw__c ='p.moodley1173@gmail.com& info@palmstonerestoration';  
            update con2;
            
            con2.Preferred_Email_Raw__c ='p.moodley1173@gmail.com & info@palmstonerestoration';  
            update con2; 
        }
        catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }
    
}