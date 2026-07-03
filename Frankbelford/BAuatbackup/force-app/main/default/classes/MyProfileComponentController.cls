/**
   *  @Name: MyProfileComponentController>   
   *  @Date Created: <04/04/2019>
   *  @Description: <Class to get LoggedIn User Information>
 */
public without sharing class MyProfileComponentController {
    
    /**
        *  Description : Method to get Sites Name
        *  @name : getSitesOfLoggedInUser
        *  @param : None
        *  @return : List<sirenum__Site__c>
        *  @throws exception-none
    */
    @AuraEnabled
    public static List<sirenum__Site__c> getSitesOfLoggedInUser() {
        Integer lmt = Limits.getLimitQueryRows() - Limits.getQueryRows();
       Id loggedInUserId = UserInfo.getUserId();
        User u = [SELECT id,ContactId FROM User WHERE id = :loggedInUserId Limit 1];
        Contact cont = [SELECT id,AccountId FROM Contact WHERE id =:u.contactId];
        
        List < Id > siteIds = new List < Id > ();
        List<Contact_Site_link__c> lstContactList = [SELECT Id,Account__c, IP_Site__c,IP_Site__r.id, IP_Contact__c FROM Contact_Site_link__c
                                                     WHERE IP_Contact__r.Id=:cont.id AND Account__r.Id=:cont.AccountId AND IP_PortalType__c!=null];
        System.debug(lstContactList.size()+'==lstContactList=='+lstContactList);
        for(Contact_Site_link__c conSiteLink : lstContactList){
            siteIds.add(conSiteLink.IP_Site__r.id);
        }
        Map<Id,Sirenum__Site__c> mapIdSiteList = new Map<Id,Sirenum__Site__c>([SELECT Id,Name, sirenum__Operating_Company__c FROM sirenum__Site__c WHERE 
                                                                               id IN: siteIds ORDER BY name ASC limit: lmt]);
        System.debug('sitesList--->>>'+mapIdSiteList);
        return mapIdSiteList.values();
    }
    
    /**
        *  Description : Method to get Logged-In User Information
        *  @name : fetchUserInformation
        *  @param : None
        *  @return : User
        *  @throws exception-none
    */
    @AuraEnabled
    public static User fetchUserInformation() {
        return getUserInformation();
    }
    
    /**
        *  Description : Method to Update Logged-In User Information
        *  @name : updateUserInformation
        *  @param : None
        *  @return : Nothing
        *  @throws exception-none
    */
    @AuraEnabled
    public static String updateUserInformation(String firstname,String lastname,String title,String email,String mobilephone,
                                            String phone,String street,String addressline,String state,String city,String country,String postalCode) {
        try{    
            Boolean checkUserNameExist = checkUsernameEmailOfUser(email);
            if(!checkUserNameExist){
                User user = getUserInformation();
                user.firstname = firstname;
                user.lastname = lastname;
                user.title = title;
                user.email = email;
                user.username = email;
                user.mobilephone = mobilephone;
                user.phone  = phone;
                user.street = street;
                user.Address_Line_2__c = addressline;
                user.state = state;
                user.city = city;
                user.country = country;
                user.postalCode = postalCode;
                update user;
                return 'User Updated Successfully';
            }
            else{
                return Label.EmailAlreadyExist;
            }
        }
        catch(Exception e){
            system.debug('+++++++++++++++++++'+e.getmessage());
            return Label.EmailAlreadyExist;
        }
    }
    
    /**
        *  Description : Method to get Logged-In User Information
        *  @name : getUserInformation
        *  @param : None
        *  @return : User
        *  @throws exception-none
    */
    private static User getUserInformation() {
        User user = [SELECT id, ContactId,email, Name,username, usertype, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city, country, postalcode,User_Image_Uploaded__c, Address_Line_2__c,User_Image__c,state, localesidkey, mobilephone, extension, fax, contact.email
                FROM User WHERE id = :UserInfo.getUserId()];
        return User;
    }
    
    /**
        *  Description : Method to check email, username already exist
        *  @name : checkUsernameEmailOfUser
        *  @param : Email
        *  @return : Boolean
        *  @throws exception-none
    */
    private static Boolean checkUsernameEmailOfUser(String email) {
        Boolean userExist = false;
        User user = getUserInformation();
        List<User> userEmailUserName = [Select id,City,Phone,street,state,PostalCode,Country,NI_Number__c,MobilePhone,FirstName,LastName,Email from user where Email=:email and username=:email and ContactId!=:user.ContactId and (Profile.Name='Customer Portal Manager Custom') limit 1];
        if(!userEmailUserName.isEmpty() && userEmailUserName!=null){
            userExist = true;
        }
        else{
            userExist = false;
        }
        return userExist;
    }
}