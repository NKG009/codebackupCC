/**
 * Created by mrahman on 2020-08-26.
 */

public with sharing class JobOrderNotification {

    public static void notify2ndTierSupplier(){
        Map<Id, List<Subscriptions__c>> contSubs = getSubscribers();
        System.debug('contSubs::>> '+contSubs.size());
        if(contSubs.size()==0){
            System.debug('There are no emails to be processed');
            return;
        }
        Map<Id, Contact> contacts = new Map<Id, Contact>([SELECT Id, Name, email
                                                                    ,FirstName
                                                            FROM Contact
                                                            WHERE Id IN :contSubs.keySet()]);
        List<String> emailAddress = new List<String>();
        for(Contact c :[SELECT Id, Name, email
                                            ,FirstName
                                    FROM Contact
                                    WHERE Id IN :contSubs.keySet()]) {
            emailAddress.add(c.email);
        }

        Id templateId = [select id, name from EmailTemplate where developername = 'Supplier_notification_2nd_Tier'].id;
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        msg.setBccAddresses(emailAddress);
        msg.setTargetObjectId(contacts.values()[0].Id);
        msg.setWhatId(contSubs.values()[0][0].Id);
        msg.setTemplateId(templateId);

        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{msg});
        System.debug('List of emails ware sent::>> ' + msg);

        List<Subscriptions__c> subscriptions = new List<Subscriptions__c>();
        for(Id contactId : contSubs.keySet()){
            for(Subscriptions__c s : contSubs.get(contactId)){
                s.Supplier_Email_Sent__c = true;
                subscriptions.add(s);
            }
        }
        update subscriptions;
    }

    public static Map<Id, List<Subscriptions__c>> getSubscribers(){
        Datetime lastExecTime = Datetime.now().addMinutes(-5);
        Map<Id, List<Subscriptions__c>> contSubs = new Map<Id, List<Subscriptions__c>>();
        for(Subscriptions__c subs : [SELECT Id, Name
                                            ,User__c
                                            ,User__r.ContactId
                                            ,Account__r.Id
                                            ,Supplier_Email_Sent__c
                                            ,Supplier_SLA_Email_Date__c
                                            ,Job_Order__r.Name
                                            ,Job_Order__r.sirenum__StartDate__c
                                            ,Job_Order__r.sirenum__EndDate__c
                                        FROM Subscriptions__c
                                        WHERE Supplier_Email_Sent__c = false]) {
            if(subs.Supplier_SLA_Email_Date__c < Datetime.now()){
                if(contSubs.containsKey(subs.User__r.ContactId)){
                    contSubs.get(subs.User__r.ContactId).add(subs);
                } else {
                    contSubs.put(subs.User__r.ContactId, new List<Subscriptions__c>{subs});
                }
            }
        }
        return contSubs;
    }
}