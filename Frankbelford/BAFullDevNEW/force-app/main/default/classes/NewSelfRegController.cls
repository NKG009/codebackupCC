/**
 * @AUTHOR      Charlie Nash (RSS Global)
 * @DATE        20/10/2023
 *
 * @DESCRIPTION: New Self Registration Controller for handling any self registrations carried out by a user.
 *               THIS CLASS WILL REPLACE THE ORIGINAL SELF REGISTRATION CLASS.
 *
 * ============================================== VERSION HISTORY ==============================================
 *
 * V1.0 - NewSelfRegController.cls created - 20/10/2023
 *
 * =============================================================================================================
 */

public without sharing class NewSelfRegController {
//WITHOUT SHARING DECLARED AS GUEST USER PROFILE NEEDS TO ACCESS PRE-EXISTING CONTACTS AND USER RECORDS


    @AuraEnabled
    public static String returnContactEmailFromId(Id contactId){
        return [SELECT Email FROM Contact WHERE Id =: contactId LIMIT 1].Email;
    }


    public static Boolean duplicateUserCheck(String emailProvided, Id profileId){

        Boolean existingUser = false;

        List<User> existingUserCheck = [SELECT Id, Email FROM User WHERE Email =: emailProvided AND ProfileId =: profileId AND IsActive = true];
        //Check if we found any results
        if(!existingUserCheck.isEmpty()){
            System.debug('Existing User found!>>>> '+existingUserCheck);
            existingUser = true;
        }
        return existingUser;
    }

    public static Id duplicateContactCheck(String emailProvided, Id candidateRecordTypeId){
        //Begin check to find pre-existing Contact record.

        Id returnedId = null;

        //Get existing Candidate records, and also get S-Placement records, placement employee records, timesheet records, application records and pay profile records.
        List<Contact> existingContacts = [SELECT Id, Email, AccountId, (SELECT Id FROM sirenum__Placements__r), (SELECT Id FROM TR1__Closes__r), (SELECT Id FROM Applications2__r), (SELECT Id, Name FROM sirenum__BenTimePlans__r LIMIT 10), (SELECT Id, IP_PayrollID__c FROM Pay_Profiles__r WHERE IP_PayrollID__c != NULL) FROM Contact WHERE Email =: emailProvided AND RecordTypeId =: candidateRecordTypeId ORDER BY CreatedDate DESC];

/*
        //List for each related record we want to merge into one candidate record.
        List<sirenum__Placement__c> placements = new List<sirenum__Placement__c>();
        List<ts2__Placement__c> placementEmployees = new List<ts2__Placement__c>();
        List<ts2__Application__c> applications = new List<ts2__Application__c>();
        List<sirenum__Timesheet__c> timesheets = new List<sirenum__Timesheet__c>();
        List<IP_PayProfile__c> payProfiles = new List<IP_PayProfile__c>();

        //Check the results are not empty
        if(!existingContacts.isEmpty()) {
            //Set the latest contact as the one to use against the user record.
            returnedId = existingContacts[0].Id;

            //Loop through each Contact and put all of the related records into their respective lists.
            for (Contact currentContact : existingContacts) {

                placements.addAll(currentContact.sirenum__Placements__r);
                placementEmployees.addAll(currentContact.TR1__Closes__r);
                applications.addAll(currentContact.Applications2__r);
                timesheets.addAll(currentContact.sirenum__BenTimePlans__r);
                payProfiles.addAll(currentContact.Pay_Profiles__r);

            }


            //Update all the found related records, to relate to the one candidate record we are going to use as part of registration.
            for (sirenum__Placement__c placement : placements) {
                placement.sirenum__Contact__c = returnedId;
            }

            for (ts2__Placement__c placement : placementEmployees) {
                placement.ts2__Employee__c = returnedId;
            }

            for (ts2__Application__c application : applications) {
                application.ts2__Candidate_Contact__c = returnedId;
            }

            for (sirenum__Timesheet__c timesheet : timesheets) {
                timesheet.sirenum__Worker__c = returnedId;
            }

            for (IP_PayProfile__c payProfile : payProfiles) {
                //payProfile.IP_Candidate__c = returnedId;
            }

            existingContacts[0].AccountId = '0014J00000XaetjQAB';

            try {
                update existingContacts;
                update placements;
                update placementEmployees;
                update applications;
                update timesheets;
                update payProfiles;
                System.debug('All related records updated successfully');
            } catch (Exception e) {
                System.debug('ERROR UPDATING RELATED RECORDS: ' + e);
            }

        }*/

        if(!existingContacts.isEmpty()){
            //Check to see if we found any existing records

            Boolean matchingWork = false;
            Boolean matchingApplications = false;

            for(Contact currentContact : existingContacts){

                    if(!currentContact.TR1__Closes__r.isEmpty() || !currentContact.sirenum__BenTimePlans__r.isEmpty() || !currentContact.Pay_Profiles__r.isEmpty()){
                        if(!matchingWork) {
                            //Assign this contact IF they have proof of work, and no newer contact records exist with proof of work.
                            returnedId = currentContact.Id;
                            matchingWork = true;
                        }
                    }
                    else if(!currentContact.Applications2__r.isEmpty()){
                        if(!matchingWork) {
                            //Assign this contact IF they have an application and no proof of work has been found on any other records that are newer than this one.
                            returnedId = currentContact.Id;
                            matchingApplications = true;
                        }
                    }
                    else{
                        if(!matchingWork && !matchingApplications){
                            //Assign the newest contact IF no other pre-existing contacts were found that contain proof of work or applications.
                            returnedId = existingContacts[0].Id;
                        }
                    }
            }
            //Update the chosen contacts Account Id to prevent role assignment error.
            Contact chosenContact = new Contact(
                    Id = returnedId
                    //AccountId = '0014J00000XaetjQAB'
            );
            upsert chosenContact;
        }
        //Return the latest contact Id to relate to the new user record
        return returnedId;
    }

    public static String beginSetupOfUser(String firstName, String lastName, String emailAddress, Id contactId, Id profileId, Id recTypeId){
		System.debug('============ beginSetupOfUser : ');
        String nickname = ((firstName != null && firstName.length() > 0) ? firstName.substring(0,1) : '' ) + lastName.substring(0,1);
        nickname += String.valueOf(Crypto.getRandomInteger()).substring(1,7);

        if(contactId == null){
            //Existing contactId not present, contact creation needed
            Contact newContact = new Contact(
                    FirstName = firstName,
                    LastName = lastName,
                    Email = emailAddress,
                    RecordTypeId = recTypeId,
                    OwnerId = [SELECT Id FROM User WHERE Name = 'Blue Arrow User' LIMIT 1].Id
                    //AccountId = '0014J00000XaetjQAB' //TODO Change this to be dynamic
            );
            insert newContact;
            contactId = newContact.Id;
            System.debug('=========== New contact created!>>>> '+newContact);

        }

        //Find roleId, for new user
        Id roleId = [SELECT Id FROM UserRole WHERE Name = 'Blue Arrow Customer User' ORDER BY LastModifiedDate DESC LIMIT 1].Id;

        //Call future method to create the user.
        try {
            createUser(contactId, firstName, lastName, emailAddress, profileId, nickname, roleId);
            return 'User created successfully';
        }
        catch (Exception e){
            System.debug('ERROR CREATING USER: '+e);
            return 'Error creating User Record: '+e;
        }

    }

    @Future
    public static void createUser(Id contactId, String fn, String ln, String email, Id pId, String nickname, Id roleId){

		 System.debug('============ createUser : ');
        if(roleId != null) {

                System.debug('ROLE ID: ' + roleId);
                User newCommunityUser = new User(
                        FirstName = fn,
                        LastName = ln,
                        ContactId = contactId, //Assign the Contact to the User
                        ProfileId = pId,
                        //UserRoleId = roleId,
                        //IsPortalEnabled = true,
                        Email = email,
                        Username = email,
                        Alias = nickname,
                        TimeZoneSidKey = 'Europe/London',
                        EmailEncodingKey = 'UTF-8',
                        LocaleSidKey = 'en_US',
                        LanguageLocaleKey = 'en_US'
                );
				System.debug('===========newCommunityUser : '+newCommunityUser);
                insert newCommunityUser;


                sendVerificationLink(newCommunityUser.Id);
            }

    }

    @AuraEnabled
    public static String initiateSelfReg(String firstName, String lastName, String emailAddress){

        String result;


        //Find the profileId for User Portal Accounts.
        Id pId = (Id)User_Profile_Id__c.getValues('User Portal').Profile_Id__c;
        Id cId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Candidate').getRecordTypeId();
		System.debug('===================== pId cId '+pId+ '======='+cId);
        //Run the duplicate User Detection method to prevent duplicate User Accounts.
        Boolean isExistingUser = duplicateUserCheck(emailAddress, pId);
		System.debug('===================== isExistingUser '+isExistingUser);
        if(isExistingUser){
            //Return message for existing user found.
            result = 'It looks like you already have an account setup with us under the email '+emailAddress+'. Please return to the login page to login using your existing account. If you do not know your password, you can reset it from the login screen.';
        }
        else{
            //Prevents this logic from running if an existing user was detected, begin checks for existing contact record.
            Id contactIdToRelate = duplicateContactCheck(emailAddress, cId);
            System.debug('===================== contactIdToRelate '+contactIdToRelate);
            //Begin User Creation Method
            String creationResult = beginSetupOfUser(firstName, lastName, emailAddress, contactIdToRelate, pId, cId);
			System.debug('===================== creationResult '+creationResult);
            if(creationResult == 'User created successfully'){
                result = 'An email has been sent to '+emailAddress+' which contains a link to finish setting up your account with us. Check your emails and click on the link within the email to create your password.';
            }
            else{
                //ERROR SECTION
                result = 'It seems there has been an issue creating your user account, please try again later.';
            }
        }
        //Add the return result to the result list.
        return result;
    }

    public static void sendVerificationLink(Id userId){
        System.debug('============ sendVerificationLink : '+userId);
        Boolean result;

        Boolean sendCustomTemplate = candidateSelfRegistrationSettings__c.getValues('Candidate').Send_Custom_Template__c;

        try{
            ResetPasswordResult pwReset = sendCustomTemplate ? System.resetPasswordWithEmailTemplate(userId, true, candidateSelfRegistrationSettings__c.getValues('Candidate').Template_API_Name__c) : System.resetPassword(userId, true);
            System.debug('Execution of password reset ran with no issues: '+pwReset);
            result = true;
        }
        catch(Exception e){
            System.debug('Error resetting password for user: '+e);
            result = false;
        }

        System.debug('result of password setup: '+result);

    }
}