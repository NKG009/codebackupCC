/**
 *  @Name: SiteManagementComponentController>
 *  @Date Created: <04/04/2019>
 *  @Description: <Class to get LoggedIn User Site Information>
 */
public without sharing class SiteManagementComponentController {
  public static string defaultSiteId;
  public static string contactAccountid;

  /**
   *  Description : Method to get Sites Name
   *  @name : getSitesOfLoggedInUser
   *  @param : None
   *  @return : List<sirenum__Site__c>
   *  @throws exception-none
   */
  public SiteManagementComponentController() {
    Id loggedInUserId = UserInfo.getUserId();
    User u = [
      SELECT id, ContactId
      FROM User
      WHERE id = :loggedInUserId
      LIMIT 1
    ];
    Contact cont = [SELECT id, AccountId FROM Contact WHERE id = :u.contactId]; // '0039E00000YKz4g'];
    System.debug('cont--->>>' + cont);
    contactAccountid = cont.AccountId;
    System.debug('contactAccountid--->>>' + contactAccountid);
  }

  /**
   * @Description: Get Brand Details from Brand Metadata object
   *
   * @param brandName
   *
   * @return returns brand details
   */
  @AuraEnabled
  public static Brand__mdt getBrandDetails(String brandName) {
    Brand__mdt brand = [
      SELECT Id, Label, Registered_Address__c, Registration_No__c
      FROM Brand__mdt
      WHERE Label = :brandName
      LIMIT 1
    ];
    return brand;
  }

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
    User u = [
      SELECT id, ContactId
      FROM User
      WHERE id = :loggedInUserId
      LIMIT 1
    ];
    Contact cont = [SELECT id, AccountId FROM Contact WHERE id = :u.contactId];

    List<Id> siteIds = new List<Id>();
    List<Contact_Site_link__c> lstContactList = [
      SELECT Id, Account__c, IP_Site__c, IP_Site__r.id, IP_Contact__c
      FROM Contact_Site_link__c
      WHERE
        IP_Contact__r.Id = :cont.id
        AND Account__r.Id = :cont.AccountId
        AND IP_PortalType__c != NULL
    ];
    System.debug(lstContactList.size() + '==lstContactList==' + lstContactList);
    for (Contact_Site_link__c conSiteLink : lstContactList) {
      siteIds.add(conSiteLink.IP_Site__r.id);
    }

    defaultSiteId = null;
    List<sirenum__Site__c> siteList = [
      SELECT id, name, sirenum__Operating_Company__c, IP_CreditStatus__c
      FROM sirenum__Site__c
      WHERE id IN :siteIds
      ORDER BY name ASC
    ];
    if (siteList.size() > 0) {
      defaultSiteId = siteList[0].id;
    }

    return siteList;
  }

  @AuraEnabled
  public static List<Contact_Site_link__c> getContactSiteLinksForUser() {
    //try {
    Id loggedInUserId = UserInfo.getUserId();
    User u = [
      SELECT id, ContactId
      FROM User
      WHERE id = :loggedInUserId
      LIMIT 1
    ];
    Contact cont = [SELECT id, AccountId FROM Contact WHERE id = :u.contactId];

    List<Contact_Site_link__c> lstContactList = [
      SELECT
        Id,
        Account__c,
        IP_Site__c,
        IP_Site__r.id,
        IP_Contact__c,
        IP_PortalType__c
      FROM Contact_Site_link__c
      WHERE
        IP_Contact__r.Id = :cont.id
        AND Account__r.Id = :cont.AccountId
        AND IP_PortalType__c != NULL
    ];

    return lstContactList;
    // } catch (Exception e) {
    //    throw new AuraHandledException(e.getMessage());
    //  }
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

  @AuraEnabled
  public static User fetchSelectedSiteOwnerInformation(Id theSiteId) {
    Id theSiteOwnerId = [
      SELECT OwnerId
      FROM sirenum__Site__c
      WHERE Id = :theSiteId
    ]
    .OwnerId;
    return [
      SELECT FirstName, LastName, Title, Brand__c, Phone, Email
      FROM User
      WHERE Id = :theSiteOwnerId
    ];
  }

  /**
   *  Description : Method to get Logged-In User Information
   *  @name : fetchSiteInformation
   *  @param : None
   *  @return : User
   *  @throws exception-none
   */
  @AuraEnabled
  public static Sirenum__Site__c fetchSiteInformation(String siteId) {
    System.debug('sitesList--->>>' + defaultSiteId);
    //siteId = 'a3e0Y000000tbkXQAQ';
    if (siteId == null) {
      siteId = siteId;
    }

    List<sirenum__Site__c> lstSite = getSiteInformation(siteId);
    system.debug('==lstSite==' + lstSite.size());
    if (!lstSite.isEmpty() && lstSite != null) {
      return lstSite[0];
    } else {
      return null;
    }
  }

  /**
   *  Description : Method to get Logged-In User Information
   *  @name : getUserInformation
   *  @param : None
   *  @return : User
   *  @throws exception-none
   */
  @testVisible
  private static User getUserInformation() {
    User theUser = [
      SELECT
        Id,
        Name,
        Username,
        User_Image__c,
        Contact.IP_JobTitle__c,
        Contact.Phone,
        Contact.Email,
        Contact.IP_Branch__c,
        Brand__c
      FROM User
      WHERE Id = :UserInfo.getUserId()
    ];
    return theUser;
  }

  /**
   *  Description : Method to get Logged-In Site Information
   *  @name : getSiteInformation
   *  @param : None
   *  @return : List<sirenum__Site__c>
   *  @throws exception-none
   */
  private static List<sirenum__Site__c> getSiteInformation(String siteId) {
    List<sirenum__Site__c> lstSite = [
      SELECT
        Id,
        Name,
        sirenum__County__c,
        sirenum__Street_Address__c,
        sirenum__State__c,
        sirenum__City__c,
        sirenum__Country__c,
        sirenum__Postal_Code__c,
        IP_MainContact__r.FirstName,
        IP_MainContact__r.LastName,
        IP_MainContact__r.Email,
        IP_InvoiceContact__r.FirstName,
        IP_InvoiceContact__r.LastName,
        IP_InvoiceContact__r.Email,
        Emergency_Contact__r.FirstName,
        Emergency_Contact__r.LastName,
        Emergency_Contact__r.Email,
        Emergency_Contact__c,
        IP_InvoiceContact__c,
        IP_MainContact__c,
        (
          SELECT
            id,
            IP_Contact__r.Name,
            IP_PortalType__c,
            IP_Contact__r.FirstName,
            IP_Contact__r.LastName,
            IP_Contact__r.Email
          FROM Contact_Site_links1__r
        )
      FROM sirenum__Site__c
      WHERE Id = :siteId
      ORDER BY Name ASC
    ];
    return lstSite;
  }

  /**
   *  Description : Method to update Site Information
   *  @name : updateSitedetails
   *  @param : None
   *  @return : sirenum__Site__c
   *  @throws exception-none
   */

  @AuraEnabled
  public static String updateSitedetails(
    String siteId,
    String mainContactFirstName,
    String mainContactLastName,
    String mainContactEmail,
    String emgContactFirstName,
    String emgContactLastName,
    String emgContactEmail,
    String street,
    String city,
    String state,
    String country,
    String postalCode
  ) {
    String message = '';
    list<sirenum__Site__c> lstSite = getListDetails(siteId);

    System.debug(
      '==emgContactFirstName' +
      emgContactFirstName +
      '++++++++++++++++' +
      lstSite[0].Emergency_Contact__r.FirstName.trim()
    );
    System.debug(
      '==emgContactLastName' +
      emgContactLastName +
      '++++++++++++++++' +
      lstSite[0].Emergency_Contact__r.LastName.trim()
    );
    System.debug(
      '==emgContactEmail' +
      emgContactEmail +
      '++++++++++++++++' +
      lstSite[0].Emergency_Contact__r.Email.trim()
    );
    System.debug('==1111111111111111');

    if (
      (!mainContactFirstName.trim()
        .equals(lstSite[0].IP_MainContact__r.FirstName.trim()) ||
      !mainContactLastName.trim()
        .equals(lstSite[0].IP_MainContact__r.LastName.trim())) &&
      mainContactEmail.trim().equals(lstSite[0].IP_MainContact__r.Email.trim())
    ) {
      return 'ForceTochangeEmailMainContact';
    } else if (
      (!emgContactFirstName.trim()
        .equals(lstSite[0].Emergency_Contact__r.FirstName.trim()) ||
      !emgContactLastName.trim()
        .equals(lstSite[0].Emergency_Contact__r.LastName.trim())) &&
      emgContactEmail.trim()
        .equals(lstSite[0].Emergency_Contact__r.Email.trim())
    ) {
      return 'ForceTochangeEmailEmergencyContact';
    } else {
      Contact mainContactId = getContactInfo(
        mainContactFirstName,
        mainContactLastName,
        mainContactEmail
      );
      Contact emergencyContactId = getContactInfo(
        emgContactFirstName,
        emgContactLastName,
        emgContactEmail
      );
      System.debug('==1111111' + mainContactId);
      System.debug('==222222' + emergencyContactId);
      System.debug('==444444' + lstSite[0].sirenum__Operating_Company__c);
      if (
        mainContactId.AccountId != lstSite[0].sirenum__Operating_Company__c ||
        emergencyContactId.AccountId != lstSite[0].sirenum__Operating_Company__c
      ) {
        System.debug('==1111111111111111');
        return 'Error';
      } else {
        System.debug('==2222222222222222');

        lstSite[0].sirenum__Street_Address__c = street;
        lstSite[0].sirenum__City__c = city;
        lstSite[0].sirenum__State__c = state;
        lstSite[0].sirenum__Country__c = country;
        lstSite[0].sirenum__Postal_Code__c = postalCode;
        lstSite[0].sirenum__Postal_Code__c = postalCode;
        lstSite[0].IP_MainContact__c = mainContactId.Id;
        lstSite[0].Emergency_Contact__c = emergencyContactId.Id;
        update lstSite[0];

        list<sirenum__Site__c> lstSiteupdated = getListDetails(lstSite[0].id);

        String htmlbody =
          '<table  border="0" cellpadding="5" cellspacing="0" height="250" width="650"><tr><td class="previewCell">Dear ' +
          lstSiteupdated[0].Owner.Name +
          ',<br><br><br>Below are the updated details of ' +
          lstSiteupdated[0].Name +
          ' Site :-' +
          '<br><br>Main Contact First Name: ' +
          lstSiteupdated[0].IP_MainContact__r.FirstName +
          '<br><br>Main Contact Last Name : ' +
          lstSiteupdated[0].IP_MainContact__r.LastName +
          '<br><br>Main Contact Email : ' +
          lstSiteupdated[0].IP_MainContact__r.Email +
          '<br><br>Emergency Contact First Name: ' +
          lstSiteupdated[0].Emergency_Contact__r.FirstName +
          '<br><br>Emergency Contact Last Name : ' +
          lstSiteupdated[0].Emergency_Contact__r.LastName +
          '<br><br>Emergency Contact Email : ' +
          lstSiteupdated[0].Emergency_Contact__r.Email +
          '<br><br><br>Thank you</td></tr></table>';
        //send email
        String userEmail = lstSiteupdated[0].Owner.email;
        String subject =
          'Site: ' +
          lstSiteupdated[0].Name +
          ' has been updated';
        //String userEmail = 'pradeep.kumar@espire.com';
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new List<String>{ userEmail };
        mail.setToAddresses(toAddresses);
        mail.setSubject('Site has been updated');
        //String body = 'Your Site Information has been updated';
        mail.setHtmlBody(htmlbody);
        Messaging.sendEmail(new List<Messaging.SingleEMailMessage>{ mail });
        return 'Success';
      }
    }
  }

  private static Contact getContactInfo(
    String firstName,
    String lastName,
    String email
  ) {
    Id loggedInUserId = UserInfo.getUserId();
    User u = [
      SELECT id, ContactId
      FROM User
      WHERE id = :loggedInUserId
      LIMIT 1
    ];
    Contact cont = [SELECT id, AccountId FROM Contact WHERE id = :u.contactId]; // '0039E00000YKz4g'];
    System.debug('cont--->>>' + cont);
    contactAccountid = cont.AccountId;
    System.debug('contactAccountid--->>>' + contactAccountid);

    List<Contact> contactInfo = new List<Contact>();
    contactInfo = [
      SELECT id, FirstName, AccountId, LastName, Email
      FROM Contact
      WHERE email = :email
      LIMIT 1
    ];
    System.debug('==contactInfocontactInfocontactInfo==' + contactInfo);
    if (!contactInfo.isEmpty()) {
      System.debug('==contactInfo[0].id==' + contactInfo[0].id);
      return contactInfo[0];
    } else {
      Contact con = new Contact();
      con.firstName = firstName;
      con.lastName = lastName;
      con.email = email;
      System.debug('==contactAccountid.id==' + contactAccountid);
      con.accountid = contactAccountid;
      insert con;
      System.debug('==con.id==' + con.id);
      return con;
    }
  }

  private static list<sirenum__Site__c> getListDetails(String siteId) {
    list<sirenum__Site__c> lstSite = [
      SELECT
        Id,
        Name,
        Owner.Email,
        Owner.Name,
        OwnerId,
        sirenum__Street_Address__c,
        sirenum__State__c,
        sirenum__City__c,
        sirenum__Operating_Company__c,
        sirenum__Country__c,
        sirenum__Postal_Code__c,
        IP_MainContact__r.FirstName,
        IP_MainContact__r.LastName,
        IP_MainContact__r.Email,
        IP_InvoiceContact__r.FirstName,
        IP_InvoiceContact__r.LastName,
        IP_InvoiceContact__r.Email,
        Emergency_Contact__r.FirstName,
        Emergency_Contact__r.LastName,
        Emergency_Contact__r.Email,
        Emergency_Contact__c,
        IP_InvoiceContact__c,
        IP_MainContact__c
      FROM sirenum__Site__c
      WHERE id = :siteId
    ];
    return lstSite;
  }
}