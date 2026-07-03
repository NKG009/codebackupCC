/**
 * Created by mrahman on 2020-08-20.
 */

public with sharing class BlueBarCompController {

    /**
     *
     *
     * @param userId = current user Id
     *
     * @return VMS
     */
    @AuraEnabled
    public static Boolean getVMSSubscriptoinFlag(Id userId){
        Boolean isVmsClient = false;

        User currentUser = [SELECT Id, Profile.Name, Name ,Contact.Account.VMS_Client__c FROM User WHERE Id = :userId];
        if(currentUser.Profile.Name=='System Administrator'){
            System.debug('Setting the IsVmsClient value to true for System Administrator profile user');
            isVmsClient = true;
        } else {
            isVmsClient=currentUser.Contact.Account.VMS_Client__c;
        }
        System.debug('IsVMSClient:: '+ isVmsClient);
        return isVmsClient;
    }

    @AuraEnabled
    public static List<sirenum__Site__c> getUserSites( Id userId) {
        User currentUser = [SELECT Id, Profile.Name, Name
                                    ,Contact.Account.Id
                                    ,Contact.Account.VMS_Client__c
                              FROM User
                             WHERE Id = :userId];
        List<sirenum__Site__c> sites = [SELECT Id,Name,sirenum__County__c,sirenum__Street_Address__c,sirenum__State__c,sirenum__City__c,
                                                sirenum__Country__c,sirenum__Postal_Code__c,IP_MainContact__r.FirstName,IP_MainContact__r.LastName,IP_MainContact__r.Email,
                                                IP_InvoiceContact__r.FirstName,IP_InvoiceContact__r.LastName,IP_InvoiceContact__r.Email,Emergency_Contact__r.FirstName,
                                                Emergency_Contact__r.LastName,Emergency_Contact__r.Email,Emergency_Contact__c,IP_InvoiceContact__c,IP_MainContact__c,
                                                (select id,IP_Contact__r.Name,IP_PortalType__c,IP_Contact__r.FirstName,IP_Contact__r.LastName,IP_Contact__r.Email from Contact_Site_links1__r)
                                        FROM sirenum__Site__c
                                        WHERE sirenum__Operating_Company__c=:currentUser.Contact.Account.Id ORDER BY Name ASC];

        return sites;
    }

}