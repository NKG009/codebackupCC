global class ClientEscalarionNotificationPortals implements Database.Batchable<sObject>{
    Id templateId = [select id, name from EmailTemplate where developername = 'Client_Portal_Escalation_User'].id;

    global Database.QueryLocator start(Database.BatchableContext BC){
        String baseQuery = 'Select id,FirstName,contactId,contact.AccountId, Contact.Brand__c, (SELECT Id, NetworkId, Network.Name FROM NetworkMemberUsers) from User where profile.name=\''+System.Label.Client_Portal_User_Profile+'\' and IsActive=True ';
        String query = Label.Notification_Portal_Brands == '\'\''? baseQuery : baseQuery + ' AND Contact.Brand__c IN ('+Label.Notification_Portal_Brands+')';
        if(Test.isRunningTest()){
            String cIds = null;
            for(Contact c : [SELECT Id FROM Contact WHERE RecordType.Name = 'Contact']){
                cIds = String.isBlank(cIds) ? '\''+ c.Id + '\'' : cIds + ',\''+ c.Id + '\'';
            }
            query = query + ' AND ContactId IN ('+ cIds +') Limit 199';
            Database.query(query);
        }
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC,List<User> userList){
        System.debug('check user list'+userList);
        List<String> conID = new List<String>();
        List<String> accID = new List<String>();
        set<Id> siteId = new set<Id>();
        List<String> status = new List<String>();
        String name;
        status.add('Awaiting approval');
        status.add('Not Yet Submitted');
        DateTime val = DateTime.now();

        for(User u: userList) {
            conID.add(u.contactID);
            name=u.FirstName;
        }
        System.debug('ContactID'+ConID);
        system.debug('Account ID'+accID);
        Network clientUrl=[SELECT Id FROM Network where name='client'];

        List<Contact_Site_link__c> consiteLink = [SELECT id, Account__c,IP_Contact__c, IP_PortalType__c, IP_Site__c FROM Contact_Site_link__c WHERE IP_Contact__c=:conID and IP_PortalType__c ='Escalation Hours Approver' ];

        for(Contact_Site_link__c slink: consiteLink) {
            siteId.add(slink.IP_Site__c);
        }

        List<sirenum__Shift__c> shiftList = [Select id,IP_BranchOfOwner__c, IP_Status__c, sirenum__Scheduled_End_Time__c FROM sirenum__Shift__c WHERE sirenum__Scheduled_End_Time__c <=:val AND sirenum__Published__c=True AND sirenum__Site__c=:siteId AND IP_Status__c in : status AND sirenum__Contact__c!=null AND sirenum__Cancelled__c = false AND IP_ClientRejected__c !=true AND sirenum__Scheduled_End_Time__c = LAST_N_DAYS:15];
        If(shiftList.size()>0)
        {
            String comURL = Network.getLoginUrl(clientUrl.id);
            System.debug('comURL '+comURL);

            OrgWideEmailAddress owd = [select id, DisplayName,Address from OrgWideEmailAddress where Address ='no.reply@bluearrow.co.uk'];

            Messaging.SingleEmailMessage semail1 = new Messaging.SingleEmailMessage();
            semail1.setOrgWideEmailAddressId(owd.Id);
            semail1.setTargetObjectID(userList[0].id);
            semail1.setSaveAsActivity(false);
            semail1.setTemplateId(templateId);
            semail1.setWhatId(shiftList[0].id);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail1});

        }

    }
    global void finish(Database.BatchableContext BC){

    }
}