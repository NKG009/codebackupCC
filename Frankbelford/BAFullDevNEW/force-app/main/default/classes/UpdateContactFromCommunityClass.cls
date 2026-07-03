global class UpdateContactFromCommunityClass { 
    //@future 
    public static void updateContacts(String userId,Boolean MStreet,Boolean MCity,Boolean MState,Boolean Mcountry,Boolean MPCode,Boolean ph,Boolean Mph,Boolean fname,Boolean lname,Boolean titl,Boolean eml) {
        Id templateId = [select id, name from EmailTemplate where Name = 'MobAddressChangeNotification'].Id;//'Candidate_Portal_Change_Mob_and_Add'].id;
        
        User u = [select ContactId,City,Country,PostalCode,State,Street,Phone,MobilePhone,FirstName,LastName,Email,Title
                  from User
                  where Id=:userId];
        
        if (u!=null && u.ContactId!=null) {
            Contact c = new Contact();
            
            //  Contact c = new Contact(Id=u.ContactId,Phone=u.Phone,MailingCity=u.City,MailingCountry=u.Country,MailingPostalCode=u.PostalCode,MailingState=u.State,MailingStreet=u.Street,MobilePhone=u.MobilePhone);
            if(MStreet == True)
            {
                c.id = u.ContactId;
                c.MailingStreet=u.Street;
            }
            if(MCity == True)
            {
                c.id = u.ContactId;
                c.Mailingcity = u.city;
            }
            if(MState== True)
            {
                c.id = u.ContactId;
                c.MailingState= u.State;
            }
            if(Mcountry== True)
            {
                c.id = u.ContactId;
                c.MailingCountry = u.Country;
            }
            if(MPCode== True)
            {
                c.id = u.ContactId;
                c.MailingPostalCode = u.PostalCode;
            }
            if(Ph == True)
            {
                c.id = u.ContactId;
                c.Phone = u.Phone;
            }
            if(Mph == True)
            {
                c.id = u.ContactId;
                c.MobilePhone = u.MobilePhone;
            }
            if(fname == True)
            {
                c.id = u.ContactId;
                c.FirstName= u.FirstName;
            }
             if(lname == True)
            {
                c.id = u.ContactId;
                c.LastName= u.LastName;
            }
             if(titl == True)
            {
                c.id = u.ContactId;
                c.IP_JobTitle__c = u.Title;
            }
             if(eml == True)
            {
                c.id = u.ContactId;
                c.Email= u.Email;
            } 
            Database.DMLOptions dml = new Database.DMLOptions();
            dml.DuplicateRuleHeader.allowSave = true;
            dml.DuplicateRuleHeader.runAsCurrentUser = true; 
            
            Database.SaveResult sr = Database.update(c, dml); 
            Contact c1 = [Select id,FirstName,IP_TempestDepartment__c from Contact where id=:u.ContactID];
            String department;
            String branchname;
            string phonenumber;
            String email;
                            List<OrgWideEmailAddress> owd1 =new List<OrgWideEmailAddress>();
            IP_Shift_Template__c shiftemp;

            /*if(!Test.isRunningTest())
            {
                department = c1.IP_TempestDepartment__c;
                shiftemp = IP_Shift_Template__c.getValues(department);
                branchname = shiftemp.IP_Site_Name__c;
                phonenumber = shiftemp.Phone__c;
                email=Shiftemp.Email__c;   
            
            }
            else*/if(Test.isRunningTest())
            {
                department = '1062';
                branchname = 'ABC';
                phonenumber = '1234658';
            }
           /* if(shiftemp!=Null)
            {
            owd1= [select id, DisplayName,Address from OrgWideEmailAddress where Address =:shiftemp.Email__c];
            system.debug('OWD ID--->'+owd1);
            }*/
            
            OrgWideEmailAddress owd = [select id, DisplayName,Address from OrgWideEmailAddress where Address ='no.reply@bluearrow.co.uk'];
            if(Test.isRunningTest()){
                templateId = [SELECT Id, Name from EmailTemplate where Name = 'TestEmailTemplate' LIMIT 1].Id;
            }
            Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
            semail.setTargetObjectId(c1.id);
            semail.setTemplateId(templateId); 
            
            /*if(owd1.size()>0)
            {
            semail.setOrgWideEmailAddressId(owd1[0].Id);
            }
            else
            {*/
            semail.setOrgWideEmailAddressId(owd.Id);
   
            //}
            try{
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail});
            }catch(Exception e) {
                System.debug('Send email failed with following Error: \n' + e.getMessage());
            }
        }
    }
}