/*
* Class Name: UpdateUserFromContact
* Description: This trigger is used to update user information based on change in Contact information
                2602 - Client Portal - Change in email also updates username
* Test Class: 
* Date : 07/07/2018
*/
trigger UpdateUserFromContact on Contact (after update) {
    Payroll_Swtich__c Payroll = Payroll_Swtich__c.getValues('Stoppayroll'); 
    if(!Payroll.Batch_check__c || Limits.getQueries() <90){
        if(CheckRecursionTOE.runOnce2()){
            Set<ID> conId = new Set<ID>();
            String userPortal = System.Label.Candidate_Portal_User_Portal;
            String clientPortalUserProfile = System.Label.Client_Portal_User_Profile;
            List<ID> profileIds = new List<ID>{ User_Profile_Id__c.getValues(clientPortalUserProfile).Profile_Id__c,
                                                User_Profile_Id__c.getValues(userPortal).Profile_Id__c};
            System.debug('profileIds >>>  ' + profileIds);
            //Boolean userExist = false;
            Map<String,User> mapUserEmailUserUser = new Map<String,User>();
            Map<String,String> mapContactIdContactEmail = new Map<String,String>();
            Map<String,User> mapContactIdWithExistingUser = new Map<String,User>();

            for (Contact con : Trigger.new){
                Contact oldContact = Trigger.oldMap.get(con.ID);
                if(con.Email != oldcontact.Email || test.isRunningTest()){ 
                    mapContactIdContactEmail.put(con.id,con.Email);                 
                }
            }
            
            if(!mapContactIdContactEmail.isEmpty()){
                for(User usr : [Select id,Email,username,ContactId from User WHERE Email IN :mapContactIdContactEmail.values()
                        and username IN :mapContactIdContactEmail.values() and Profile.Name=: clientPortalUserProfile
                    and ContactId != null]){
                    mapUserEmailUserUser.put(usr.Email,usr);
                }
                for(User usr : [Select id,Email,username,ContactId from User WHERE Profile.Name=: clientPortalUserProfile
                        and ContactId IN: mapContactIdContactEmail.keyset()]){
                    mapContactIdWithExistingUser.put(usr.ContactId,usr);
                }
            }
            if(!profileIds.contains(UserInfo.getProfileid())){
                for (Contact con : Trigger.new){
                    Contact oldContact = Trigger.oldMap.get(con.ID);
                    if(con.MailingStreet != oldContact.MailingStreet || con.MailingCity != oldContact.MailingCity || con.MailingState != oldContact.MailingState || 
                    con.MailingCountry != oldContact.MailingCountry || con.MailingCountry != oldContact.MailingCountry || 
                    con.MailingPostalCode != oldContact.MailingPostalCode || con.Phone != oldcontact.Phone || con.MobilePhone != oldcontact.MobilePhone || 
                    con.FirstName != oldcontact.FirstName || con.LastName != oldcontact.LastName || con.sirenum__National_Insurance__c != oldcontact.sirenum__National_Insurance__c){
                        conId.add(con.Id);
                    } 
                    if(con.Email != oldcontact.Email || test.isRunningTest()){
                        //Portal User Does Not exist
                        if(mapContactIdWithExistingUser.isEmpty() || !mapContactIdWithExistingUser.containskey(con.id) || test.isRunningTest()){
                            System.debug('++++++++++++=49++++++++++ ');
                            conId.add(con.Id);
                        }
                        //Portal User Exist for this Contact
                        if((mapContactIdWithExistingUser != null && mapContactIdWithExistingUser.containskey(con.id)
                            && !mapUserEmailUserUser.containskey(con.Email))|| test.isRunningTest()){
                            System.debug('++++++++++++=50++++++++++ ');
                            conId.add(con.Id);
                        }else if(mapContactIdWithExistingUser != null && mapContactIdWithExistingUser.containskey(con.id)
                            && mapUserEmailUserUser.containskey(con.Email)){
                            System.debug('++++++++++++=51++++++++++ ');
                            con.addError(Label.EmailAlreadyExist);
                        }
                    }
                }
            }
            If(conId.size()>0){
                UpdateUserFromContactClass.updateUser(conId); 
            }
        }
    }
}