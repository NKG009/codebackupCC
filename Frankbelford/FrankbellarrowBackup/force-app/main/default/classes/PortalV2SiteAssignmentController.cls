public with sharing class PortalV2SiteAssignmentController {
    


    @AuraEnabled
    public static List<sirenum__Site__c> getAccountSites(Id AccountId){

            System.debug('AccountId: ' + AccountId);
            List<sirenum__Site__c> output = new List<sirenum__Site__c>();
            output = [SELECT Id, Name FROM sirenum__Site__c WHERE sirenum__Operating_Company__c =: AccountId];
            return output;
        
    }


    @AuraEnabled
    public static List<Contact> getAccountContacts(Id AccountId){

            List<Contact> output = new List<Contact>();
            output = [SELECT Id, Name FROM Contact WHERE AccountId =: AccountId ORDER BY Name ASC];
            return output;
       
    }


    @AuraEnabled
    public static List<Contact_Site_link__c> getSiteAssignments(List<Id> contactIds){
      
            List<Contact_Site_link__c> output = new List<Contact_Site_Link__c>();
            output = [SELECT Id, IP_Site__c, IP_Contact__c, IP_PortalType__c, Account__c FROM Contact_Site_link__c WHERE IP_Contact__C IN: contactIds];

            return output;
       
    }

    @AuraEnabled
    public static List<sirenum__Timesheet__c> getTimesheets(String PONumber, String unitId){
           List<sirenum__Timesheet__c> output = new List<sirenum__Timesheet__c>();
           output = [SELECT Id, IP_Client_Invoice_PO__c, Formula_total_charge__c, sirenum__Worker__r.Name, sirenum__Site__r.Unit_Id__c, sirenum__Site__r.Name FROM sirenum__Timesheet__c WHERE (IP_Client_Invoice_PO__c != null AND IP_Client_Invoice_PO__c =: PONumber) OR (sirenum__Site__r.Unit_Id__c != null AND sirenum__Site__r.Unit_Id__c =: unitId)];
           return output;
    }
}