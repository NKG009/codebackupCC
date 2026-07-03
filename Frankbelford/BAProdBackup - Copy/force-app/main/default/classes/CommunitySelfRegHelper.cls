/**
 * Created by mrahman on 2021-01-08.
 */

public without sharing class CommunitySelfRegHelper {
    /**
     * This method only applicable for Portal Candidate
     *
     * @param firstname
     * @param lastname
     * @param email
     * @param password
     * @param accountId
     *
     * @return
     */
    public static String selfRegCandidate(String firstname ,String lastname, String email, String password, String nickName){
        Boolean foundUser = false;
        Boolean foundContact = false;
        Contact candidate;
        User usr = new User();
        String userId;

        //Get Account details to get roleId
        Id accountRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get ('Candidate').getRecordTypeId();
        Account candidateAccount = [SELECT Id, Name FROM Account WHERE Name='Candidates' and RecordTypeId =: accountRecId LIMIT 1];
        String accountId = candidateAccount.Id;

        //System.debug('In selfRegCandidate Method >> firstname=' + firstname + ' lastname='+lastname + ' email='+email);
        List<Contact> tc = [SELECT Id, FirstName, LastName, Email, CreatedDate FROM Contact ORDER BY CreatedDate DESC LIMIT 5];
        System.debug('Check Contact access >> ' + tc);
        //CHECK WHETHER CONTACT ALREADY EXISTS IN SYSTEM
        Map<String, List<Contact>> contactMap = new Map<String, List<Contact>>();
        for(Contact c : [SELECT Id, FirstName, LastName, CreatedDate, LastModifiedDate, Email
                                    ,(SELECT Id, Username, FirstName, LastName, Email, IsActive, CreatedDate, LastModifiedDate, LastLoginDate
                                        FROM Users WHERE IsActive=true)
                                    ,(SELECT Id, Name FROM sirenum__BenTimePlans__r)
                            FROM Contact
                            WHERE Email =: email
                            ORDER BY CreatedDate DESC]){
            System.debug('c >> ' + c);
            if(c.Email == email && (c.FirstName == firstname && c.LastName == lastname)){
                System.debug('c.Users >> ' + c.Users);
                //CHECK IF THE CONTACT ASSOCIATED WITH AN ACTIVE USER
                if(c.Users.size()>0){
                    foundUser = true;
                    userId = c.Users[0].Id;
                }

                foundContact = true;
                //CHECK WHETHER THE CONTACT HAS ANY TS ASSOCIATED WITH THEM
                if(c.sirenum__BenTimePlans__r.size()>0){
                    if(contactMap.containsKey('hasTS')) {
                        contactMap.get('hasTS').add(c);
                    }else{
                        contactMap.put('hasTS',new List<Contact>{c});
                    }
                } else {
                    if(contactMap.containsKey('noTS')) {
                        contactMap.get('noTS').add(c);
                    }else{
                        contactMap.put('noTS',new List<Contact>{c});
                    }
                }
            }
        }
        System.debug('Contact in contactMap >> ' + contactMap);

        //DECIDE WHETHER TO CREATE CONTACT AND USER
        if(contactMap?.size()>0){
            if(contactMap.get('hasTS')?.size()>0){
                candidate = contactMap.get('hasTS')[0];
                //usr = candidate.Users[0];
                if (candidate.Users.size()>0){
                    userId = candidate.Users[0].Id;
                    foundUser = true;
                }
                //UPDATE CONTACT TO FLAG FOR DELETION BY THE WEEKLY GDPR PROCESS
                deleteCandidateWihoutShift(contactMap.get('noTS'));
            } else if(contactMap.get('noTS')?.size()>0) {
                //CREATE AN USER AND LINK THE USER WITH THIS A CONTACT
                candidate = contactMap.get('noTS')[0];
                if (candidate.Users.size()>0){
                    userId = candidate.Users[0].Id;
                    foundUser = true;
                }
                contactMap.get('noTS').remove(0);
                System.debug('Number of candidate will be marked for delete >>> ' + contactMap.get('noTS').size());
                //UPDATE CONTACT TO FLAG FOR DELETION BY THE WEEKLY GDPR PROCESS
                deleteCandidateWihoutShift(contactMap.get('noTS'));
            }
        }

        if(!foundUser) {
            //@TODO: uncomment following line
            //insert candidate;
            if(candidate != null){
                usr.ContactId = candidate.Id;
            }
            System.debug('Contact not found and create new contact and User using Site class ');
            usr.Username = email;
            usr.Email = email;
            usr.FirstName = firstname;
            usr.LastName = lastname;
            usr.CommunityNickname = String.isBlank(nickName)? String.valueOf(Crypto.getRandomInteger()).substring(1,7): nickname;
            try{
                System.debug('User details >> ' + usr);
                //@TODO: uncomment following line
                //userId = Site.createExternalUser(usr, accountId, password);
                userId = Site.createPortalUser(usr, accountId, password);
                System.debug('User is created:: ' + usr);
                return userId;
            } catch (Exception ex) {
                System.debug('Cannot create user error >> ' + ex.getMessage());
                return userId='1'; //TREATED AS USER ALREADY EXISTS
            }
        }
        return userId;
    }

    @TestVisible
    private static void deleteCandidateWihoutShift(List<Contact> contactList){
        System.debug('Delete Contact without Shift >> ' + contactList);
        try{
            delete contactList;
        } catch(Exception ex) {
            System.debug('Cannot delete Candidates >>> ' + ex);
            System.debug('Error Message >> ' + ex.getMessage());
            //markCandidateToDelete(contactList);
        }
    }

    @TestVisible
    private static void markCandidateToDelete(List<Contact> contactList){
        System.debug('Contact without Timesheet found and will be deleted contacts >> ' + contactList);
        for(Contact c : contactList){
            c.IP_MarkedForDeletion__c = true;
            c.IP_GDPRDeleConsentPortalStatus__c = false;
        }
        //update the contact to delete in future
        update contactList;
    }
}