public without sharing class CreateInstantPortalUserController{
    
    public static String contactId{get; set;}
    public static string lightningTheme ='Theme4d';
    
    public CreateInstantPortalUserController(ApexPages.StandardController controller) {
        contactId = apexpages.currentpage().getparameters().get('id');
    }
    
    // Simple accessors for the System.UserInfo theme methods
    public static String getContextUserUiThemeDisplayed() {
        return UserInfo.getUiThemeDisplayed();
    }
    
    public static PageReference createUser(){
        String userPortal = System.Label.Candidate_Portal_User_Portal;
        String clientPortalUserProfile = System.Label.Client_Portal_User_Profile;

        String contactId = apexpages.currentpage().getparameters().get('id');
        Contact con = [Select id,accountId,firstName,lastName,email,recordType.name,mailingstreet,mailingcity,mailingpostalcode,mailingstate,mailingcountry from Contact WHERE ID =:contactId];

        List<User> listUser = [Select id,Username from User where username=:con.email and IsActive=true
                                and (Profile.Name=: clientPortalUserProfile OR Profile.Name =: userPortal) limit 1];
        System.debug('listUser: '+listUser);
        if(listUser.isEmpty() || listUser==null){
            //Check Contact/Site Link of Contact
            List<Contact_Site_link__c> listContactSiteLink =[Select id from Contact_Site_link__c where IP_Contact__c=:contactId
                                                and IP_PortalType__c!=null];

            Account acc = [Select id,name,IsCustomerPortal, VMS_Client__c, RecordType.Name from Account where Id=:con.AccountId];
            System.debug('Debug log for acc.name: '+acc.name);
            System.debug('Debug log for acc.name: '+acc.name+' Customer User');
            UserRole portalRole = new UserRole();
            if(acc.isCustomerPortal==true){
                System.debug('Debug log for portalRole+'+ [Select Id,Name, PortalRole, PortalType,LastModifiedDate from UserRole Where Name =:acc.name+' Customer User']);
                portalRole = [Select Id,Name, PortalRole, PortalType from UserRole Where Name =:acc.name+' Customer User' ORDER BY LastModifiedDate ASC LIMIT 1];
                System.debug('Debug log for portalRole+'+portalRole);
            }
            
            Profile profile1 = new Profile();
            String profileName;
            if(con.recordType.name == 'Contact'){
                if(acc.RecordType.Name == '2nd Tier Supplier') {
                    profileName = Label.VMS_Portal_2nd_Tier_Supplier_Profile;
                    profile1 = [Select Id,name from Profile where name =: profileName];
                } else{
                    profileName = Label.Client_Portal_User_Profile;
                    profile1 = [Select Id,name from Profile where name =: profileName];
                }
            }
            else if(con.recordType.name == 'Candidate' || con.recordType.name == '2nd Tier Candidate') {
                profileName = Label.Candidate_Portal_User_Portal;
                profile1 = [Select Id,name from Profile where name =: profileName];
            }

            User portalAccountOwner1 = new User(UserRoleId = portalRole.Id,
                                                ProfileId = profile1.Id,
                                                contactId = contactId,
                                                Username = con.email ,
                                                street = con.mailingstreet,
                                                city = con.mailingcity,
                                                postalcode = con.mailingpostalcode,
                                                state = con.mailingstate,
                                                country = con.mailingcountry,
                                                Alias = con.firstName.substring(0,1)+con.LastName.substring(0,3),
                                                Email=con.email,
                                                EmailEncodingKey='UTF-8',
                                                Firstname=con.firstName,
                                                Lastname=con.LastName,
                                                LanguageLocaleKey='en_GB',
                                                LocaleSidKey='en_GB',
                                                TimeZoneSidKey='Europe/London');

            if(profile1.Name == Label.Candidate_Portal_User_Portal){
                System.debug('Trying to create Candidate Portal user using "' + profile1.Name+'" profile');
                Database.insert(portalAccountOwner1);
            }

            //CREATE USER FOR CLIENT PORTAL OR VMS SUPPLIER PORTAL USER
            if((profile1.Name==Label.Client_Portal_User_Profile && !listContactSiteLink.isEmpty() && listContactSiteLink!=null) || profile1.Name==Label.VMS_Portal_2nd_Tier_Supplier_Profile){
                System.debug('Trying to create Portal user with "' + profile1.Name+'" profile');
                try{
                    Database.insert(portalAccountOwner1);
                    System.debug('Created portal user: ' + portalAccountOwner1);
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.ClientUserCreatedSuccessMessage));
                }
                catch(Exception e){
                    System.debug('Exception while creating user'+e);
                    if(e.getMessage().contains('PORTAL_USER_ALREADY_EXISTS_FOR_CONTACT')){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.PortalUserExistErrorMessage));
                    }
                    else{
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Oops! Unexpected Error found. Please contact your IT team and provide following error message - \n\n' + e.getMessage() ));
                    }
                }
            }
            else if(profile1.Name==clientPortalUserProfile && (listContactSiteLink.isEmpty() || listContactSiteLink!=null)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.ContactSiteLinkErrorMessage));
            }

            System.debug('Debug log for portalAccountOwner1: '+portalAccountOwner1);
            //ADD PERMISSION SET FOR CLIENT PORTAL USER
            if(portalAccountOwner1.Id!=null && profileName == Label.Client_Portal_User_Profile){
                updatecontactsite(con.id);
                assignUserToGroupMember(portalAccountOwner1.Id);
            }
            String getLightning = getContextUserUiThemeDisplayed();
            if(lightningTheme.equals(getLightning)){
                return null;
            }
            else{
                return new PageReference('javascript:window.close()');
            }
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.PortalUserExistErrorMessage));
        }

        System.debug('Exception while creating user');
        return null;
    }
    
    @future
    private static void assignUserToGroupMember(Id userId){
        List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
        PermissionSet ps;
        ps = [Select id,name from PermissionSet WHERE name =:'Testpermission'];
        PermissionSetAssignment psa = new PermissionSetAssignment (PermissionSetId = ps.Id, AssigneeId = userId);
        permissionSetList.add(psa);
        if(!test.isRunningTest()){
            upsert permissionSetList;
        }
        
        List<Group> publicGroup = [Select id,name,email from Group WHERE Name='All Users' OR Name ='All Groups' LIMIT 2];
        List<GroupMember> gmLst = new List<GroupMember>();
        for(Group gp : publicGroup){
            GroupMember gm = new GroupMember();
            gm.GroupId = gp.Id;
            gm.UserOrGroupId = userId;
            gmLst.add(gm);
        }
        insert gmLst;
        System.debug('Debug log for gmLst: '+gmLst);
    }
    @future
    private static void updatecontactsite(id contactId)
    {
        List<Contact_Site_link__c> consiteRec =[Select id,IP_Site__c from Contact_Site_link__c where IP_Contact__c=:contactId
                                                        and IP_PortalType__c!=null];
       
        set<id> siteids = new set<id>();
        for(Contact_Site_link__c c: consiteRec )
        {
            siteids.add(c.IP_Site__c);
        }
        list<sirenum__Site__c> siterec =[select id,IP_Timesheet_Method__c,IP_ScheduledAutoApproval__c from sirenum__Site__c where id in :siteids];
        for(sirenum__Site__c site:siterec)
        {
            if(site.IP_Timesheet_Method__c !='eTimesheet')
            {
                site.IP_Timesheet_Method__c ='eTimesheet';
            }
            //if(!site.IP_ScheduledAutoApproval__c)
            //{
            //    site.IP_ScheduledAutoApproval__c = true;
            //}
        }
        try{
            update siterec;
        }
        catch(exception e)
        {}    
    }
}