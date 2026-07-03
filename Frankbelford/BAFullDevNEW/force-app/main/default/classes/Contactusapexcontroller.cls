public without sharing class Contactusapexcontroller {
    @AuraEnabled
    public static List < String > getselectOptionsClient(sObject objObject, string fld) {
        system.debug('objObject --->' + objObject);
        system.debug('fld --->' + fld);
        List < String > allOpts = new list < String > ();
        // Get the object type of the SObject.
        Schema.sObjectType objType = objObject.getSObjectType();

        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();

        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();

        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values =
                fieldMap.get(fld).getDescribe().getPickListValues();

        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        system.debug('allOpts ---->' + allOpts);
        allOpts.sort();
        return allOpts;
    }
    @AuraEnabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
        system.debug('objObject --->' + objObject);
        system.debug('fld --->' + fld);
        List < String > allOpts = new list < String > ();
        // Get the object type of the SObject.
        Schema.sObjectType objType = objObject.getSObjectType();

        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();

        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();

        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values =
                fieldMap.get(fld).getDescribe().getPickListValues();

        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        system.debug('allOpts ---->' + allOpts);
        allOpts.sort();
        return allOpts;
    }
    @AuraEnabled
    public static void updatecase(String sub, String des)
    {
        String status;
        System.debug('@@ '+sub);
        System.debug('@@ '+des);
        if(sub!=null && des!=null){
            ID contactId = [Select contactid from User where id =: Userinfo.getUserid()].contactId;
            contact c = new contact(Description = des, id=contactId);
            update c;

            system.debug('Case '+c);
            String profilename = [Select Profile.Name from User where id=: Userinfo.getUserid()].Profile.Name;
            Contact con = [Select id,Owner.FirstName,Owner.Name, FirstName, LastName,Name,IP_TempestDepartment__c,Email, Brand__c from Contact where id =: contactId];
            String department = con.IP_TempestDepartment__c;
            String EmailCand=con.Email;
            IP_Shift_Template__c shiftemp = IP_Shift_Template__c.getValues(department);
            Id templateIdCand = Util.getEmailTemplateMapping(con.Brand__c, 'Candidate Portal Submit Query Candidate').TemplateId__c;
            Id templateIdCandBranch = Util.getEmailTemplateMapping(con.Brand__c, 'Candidate Portal Submit Query Branch').TemplateId__c;
            Id templateIdClientCand = Util.getEmailTemplateMapping(con.Brand__c, 'Client Portal Submit Query Client').TemplateId__c;
            Id templateIdClientBranch = Util.getEmailTemplateMapping(con.Brand__c, 'Client Portal Submit Query Branch').TemplateId__c;

            System.debug('shiftemp.Email__c >> ' + shiftemp.Email__c);
            OrgWideEmailAddress owd1 = [select id, DisplayName,Address from OrgWideEmailAddress where Address LIKE '%reply%' AND DisplayName LIKE : con.Brand__c+'%'];
            OrgWideEmailAddress owd2= [Select id from OrgWideEmailAddress where Address =:shiftemp.Email__c limit 1];

            if(profilename == System.Label.Candidate_Portal_User_Portal)
            {
                if(Test.isRunningTest()){
                    templateIdCandBranch = [SELECT Id, Name from EmailTemplate where Name = 'TestEmailTemplate'].Id;
                }
                Messaging.SingleEmailMessage email  =  messaging.renderStoredEmailTemplate(templateIdCandBranch, con.id, c.id);

                String BranchUserEmail = shiftemp.Email__c;
                String[] toAddresses = new String[] {BranchUserEmail};
                email.setTreatTargetObjectAsRecipient(False);
                email.setToAddresses(toAddresses);
                if(EmailCand!=Null)
                {
                    //email.setOrgWideEmailAddressId(owd[0].Id);
                    email.setSenderDisplayName(con.name);

                }
                else
                {
                    email.setOrgWideEmailAddressId(owd1.Id);
                }
                email.setSubject('Query From '+con.Name);
                email.saveAsActivity = false;
                Messaging.SendEmailResult [] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                if (results[0].success) {
                    System.debug('The email was sent successfully.');
                    status = 'Success';
                }
                else {
                    System.debug('The email failed to send: ' + results[0].errors[0].message);
                    status = 'Failed';
                }

                if(Test.isRunningTest()){
                    templateIdCand = [SELECT Id, Name from EmailTemplate where Name = 'TestEmailTemplate'].Id;
                }
                Messaging.SingleEmailMessage email1 =  messaging.renderStoredEmailTemplate(templateIdCand, con.id, null);
                String branchname =   shiftemp.IP_Site_Name__c;
                email1.setSubject('Your recent query to '+branchname);
                email1.saveAsActivity = false;
                email1.setOrgWideEmailAddressId(owd2.Id);

                Messaging.SendEmailResult [] results1 = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email1});
                if (results1[0].success) {
                    System.debug('The email was sent successfully.');
                    status = 'Success';
                } else {
                    System.debug('The email failed to send: ' + results1[0].errors[0].message);
                    status = 'Failed';
                }
            }
            else if(profilename == System.Label.Client_Portal_User_Profile){
                if(Test.isRunningTest()){
                    templateIdClientBranch = [SELECT Id, Name from EmailTemplate where Name = 'TestEmailTemplate'].Id;
                }
                Messaging.SingleEmailMessage email=  messaging.renderStoredEmailTemplate(templateIdClientBranch, con.id, c.id);
                email.setSubject('Query From '+con.Name);
                String BranchUserEmail = shiftemp.Email__c;
                String[] toAddresses = new String[] {BranchUserEmail};
                email.setTreatTargetObjectAsRecipient(False);
                email.setToAddresses(toAddresses);
                email.setSenderDisplayName(con.name);

                if(EmailCand!=Null)
                {
                    //email.setOrgWideEmailAddressId(owd[0].Id);
                    email.setSenderDisplayName(con.name);

                }
                else
                {
                    email.setOrgWideEmailAddressId(owd1.Id);
                }

                System.debug('email '+email);
                email.saveAsActivity = false;

                Messaging.SendEmailResult [] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                if (results[0].success) {
                    System.debug('The email was sent successfully.');
                    status = 'Success';
                }
                else {
                    System.debug('The email failed to send: ' + results[0].errors[0].message);
                    status = 'Failed';
                }
                if(Test.isRunningTest()){
                    templateIdClientCand = [SELECT Id, Name from EmailTemplate where Name = 'TestEmailTemplate'].Id;
                }
                Messaging.SingleEmailMessage email1=  messaging.renderStoredEmailTemplate(templateIdClientCand, con.id, con.id);
                String branchname =   shiftemp.IP_Site_Name__c;
                email1.setSubject('Your recent query to '+branchname);
                email1.saveAsActivity = false;
                email1.setOrgWideEmailAddressId(owd2.Id);

                Messaging.SendEmailResult [] results1 = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email1});
                if (results1[0].success) {
                    System.debug('The email was sent successfully.');
                    status = 'Success';
                }
                else {
                    System.debug('The email failed to send: ' + results1[0].errors[0].message);
                    status = 'Failed';
                }

            }
        }

    }
}