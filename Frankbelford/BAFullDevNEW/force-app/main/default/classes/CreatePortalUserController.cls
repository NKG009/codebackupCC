public without sharing class CreatePortalUserController {
    
    @AuraEnabled
    public static Contact getContact(String contactId){ 
        
        Contact con =[Select id, RecordType.Name, Email, Phone, MobilePhone, FirstName, LastName, IP_Alias__c,
                    MailingStreet, MailingCity, MailingPostalCode, MailingCountry, MailingState,
                    sirenum__National_Insurance__c,IP_TempestDepartment__c 
                    from Contact where id =:contactId];
        return con;
    }
    
    @AuraEnabled
    public static String insertPortalUser(User portalUser,String profileId){ 
        
        system.debug('portalUser>>>>>>>>'+portalUser);
        String porUserId = '';
        if(!Test.isRunningTest()){
            portalUser.Profile.UserLicenseId = System.Label.CustomerPortalUserLicenseId;
         }
        portalUser.UserRoleId = System.Label.CustomerPortalRoleId;
        //portalUser.ProfileId = System.Label.CustomerPortalManagerCustom;
        portalUser.ProfileId = profileId;
        portalUser.TimeZoneSidKey = 'GMT';
        portalUser.LanguageLocaleKey = 'en_US';
        portalUser.EmailEncodingKey = 'UTF-8';
        portalUser.LocaleSidKey = 'en_US'; 
        try{
            insert portalUser;
            system.debug('portalUser>>>>>>'+portalUser.id);
            porUserId = 'User Inserted Successfully';
            system.debug('<<<<<<<After portalUser>>>>>>'+portalUser);            
        }catch(exception ex){
            String message = ex.getMessage();
            message = message.substringAfter(':');
            porUserId = message;
        }
        return porUserId;
    }
    
}