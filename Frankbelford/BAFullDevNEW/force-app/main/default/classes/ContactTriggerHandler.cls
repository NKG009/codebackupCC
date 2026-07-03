/**
 * CREATED BY ESPIRE TEAM
 *
 * UPDATED BY MUSADDEKUR RAHMAN ON 4/09/2020
 * SUMMARY: ADDED 2 METHODS createCandidatePortalUser AND createUser; AND A WRAPPER CLASS ContactUser.
 */
public class ContactTriggerHandler implements ITrigger {
    /**
     * createCandidatePortalUser IS TO CREATE CANDIDATE PORTAL USER FOR BOTH INTERNAL CANDIDATE AND 2ND TIER SUPPLIER CANDIDATE
     * THIS METHOD IS EXECUTED ON AFTER INSERT/UPDATE EVENT HOWEVER INTERNAL CANDIDATE GETS ONLY CREATED IN AFTER UPDATE EVENT
     *
     * @param newContacts --> Trigger.new
     * @param oldContacts --> Trigger.old (only applicable for After update event)
     */
    public static void createCandidatePortalUser(List<Contact> newContacts, List<Contact> oldContacts){
        List<String> cuStrList = new List<String>();
        List<Contact> contacts = new List<Contact>();
        System.debug('newContacts >>> ' + newContacts);

        Id t2candidateRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('2nd Tier Candidate').getRecordTypeId();
        Id candidateRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Candidate').getRecordTypeId();
        //THIS IS FOR TRIGGER_INSERT
        if(newContacts.size()>0 && oldContacts.isEmpty()){
            for(Contact c : newContacts){
                if(c.IP_ComplianceConfirmedBy2ndTier__c == true && c.RecordTypeId == t2candidateRTId){
                    contacts.add(c);
                }
            }
        }
        
        //THIS IS FOR TRIGGER_UPDATE
        if(newContacts.size()>0 && oldContacts.size()>0){
            Map<Id, Contact> oldConMap = new Map<Id, Contact>(oldContacts);
            for(Contact c : newContacts){
                if((c.IP_ComplianceConfirmedBy2ndTier__c == true && c.RecordTypeId == t2candidateRTId && oldConMap.get(c.Id).IP_ComplianceConfirmedBy2ndTier__c == false) ||
                        (c.TOE_Completed__c == true &&
                                c.TOE_Completed__c != oldConMap.get(c.Id).TOE_Completed__c &&
                                c.RecordTypeId == candidateRTId &&
                                CheckRecursionTOE.runOnce())) {
                    contacts.add(c);
                }
            }
        }

        //Id profileId = (Id)User_Profile_Id__c.getValues('User Portal').Profile_Id__c;//jyothi
        Id profileId = (User_Profile_Id__c.getValues('User Portal') != null)?(Id)User_Profile_Id__c.getValues('User Portal').Profile_Id__c:null;//jyothi
        
        Map<String, Id > roleNameContIds = new Map<String, Id>(); //ROLE NAME and CONTACT Id
        Map<Id, Id> userRoleIds = new Map<Id, Id>(); //CONTACT Id and ROLE Id
        if(contacts.size()>0){
            Map<Id, Contact> contactMap = new Map<Id, Contact>(contacts);
            for(Contact c : [SELECT Id, Name, Account.Name
                               FROM Contact
                              WHERE Id IN: contactMap.keySet()]){
                roleNameContIds.put(c.Account.Name + ' Customer User', c.Id);
            }

            for(UserRole ur : [SELECT Id, Name FROM UserRole WHERE Name IN: roleNameContIds.keySet()]){
                userRoleIds.put(roleNameContIds.get(ur.Name), ur.Id);
            }

            for(Contact c : contacts){
                ContactUser cu = new ContactUser();
                cu.contactId = c.Id;
                cu.profileId = profileId;
                cu.roleId = userRoleIds.get(c.Id);
                
                cuStrList.add(JSON.serialize(cu));
            }
        }
        System.debug(cuStrList.size() + ' User to be created >>> ' + cuStrList);
        if(cuStrList.size()>0){
            createUser(cuStrList);
        }
    }

    @future
    public static void createUser(List<String> conUsrStrList){
        Map<Id, ContactUser> cuMap = new Map<Id, ContactUser>();
        Set<Id> profileIds = new Set<Id>();
        for(String s : conUsrStrList){
            ContactUser cu = (ContactUser) JSON.deserialize(s,ContactUser.class);
            cuMap.put(cu.contactId, cu);
            profileIds.add(cu.profileId);
        }
        List<User> listuser = new List<User>();
        for(Contact con: [Select id,IP_Alias__c,sirenum__National_Insurance__c
                                ,Email,FirstName,LastName,MailingCity,MailingCountry
                                ,MobilePhone,Phone,MailingPostalCode,MailingState,MailingStreet
                                ,Account.Portal_Username__c
                            from Contact
                            where id in: cuMap.keySet()
                              and Id not in (SELECT ContactId
                                                FROM User
                                                WHERE IsActive = true
                                                  AND ContactId IN : cuMap.keySet()) FOR UPDATE]) {
            User u = new User();
            u.FirstName = con.FirstName;
            u.LastName = con.LastName;
            u.Email = con.Email;
            if(String.isBlank(con.Account.Portal_Username__c)){
                u.Username = con.Email;
            } else {
                u.Username = con.Email+'.'+con.Account.Portal_Username__c;
            }
            u.Alias = con.IP_Alias__c;
            u.CommunityNickname = con.IP_Alias__c;
            u.LanguageLocaleKey = 'en_US';
            System.debug('cuMap.get(con.Id).profileId >>> '+ cuMap.get(con.Id).profileId);
            u.ProfileId = cuMap.get(con.Id).profileId;
            if(!test.isRunningTest()){ //&& !String.isBlank(cuMap.get(con.Id).roleId)
                u.UserRoleId = cuMap.get(con.Id).roleId;
                System.debug('cuMap.get(con.Id).roleId >>> ' + cuMap.get(con.Id).roleId);
            }
            u.State = con.MailingState;
            u.Street = con.MailingStreet;
            u.City = con.MailingCity;
            u.Country = con.MailingCountry;
            u.PostalCode = con.MailingPostalCode;
            u.Phone = con.Phone;
            u.MobilePhone = con.MobilePhone;
            u.ContactId = con.Id;
            u.TimeZoneSidKey = 'Europe/London';
            u.LocaleSidKey = 'en_GB';
            u.EmailEncodingKey = 'ISO-8859-1';
            u.NI_Number__c = con.sirenum__National_Insurance__c;
            listuser.add(u);
        }

        if(listuser.size()>0){
            insert listuser;
        }
    }

    class ContactUser{
        public String contactId;
        public String profileId;
        public String roleId;
        //public String emailId;
    }

    public ContactTriggerHandler()
    {
        //This is the constructor
    }
    
    public void bulkBefore()
    {
        //It is Bulk Before functionality
    }
    
    public void bulkAfter()
    { 
        //It is Bulk After functionality
    }
    
    public void beforeInsert(SObject so)
    {  
        //It is for Before Insert functionality 
        //update candidate on case of account record type is candidate
        
        Contact c = (Contact) so;
        mailingAddressLines(c);
    }
    
    public void afterInsert(SObject so)
    {

        //It is for After Insert functionality

    }
    
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {        
        //It is for Before Update functionality 
        ////hardcode acc
        Contact c = (Contact) so;
        mailingAddressLines(c);
    }
    
    public void beforeDelete(SObject so)
    {
        //It is for Before Delete functionality 
    }
    
    
    public void afterUpdate(SObject oldSo, SObject so)
    { 
        //It is for After Update functionality

    }   
    
    public void afterDelete(SObject so)
    { //It is for After Delete functionality
    }
    
    public void andFinally()
    {
        //It is for Finally functionality 
    }
    void mailingAddressLines(Contact con){
        if(con.MailingStreet!=null){
            String tempSentence = con.MailingStreet;
            String m1;
            String m2 ;
            String m3;
            System.debug('$$$MailingAddressLength'+tempSentence.length());
            if(tempSentence.length() > 60){
                integer m1len=tempSentence.lastIndexOf(' ', 30);
                
                if(m1len>-1){   
                    m1len++;
                    m1= tempSentence.substring(0, m1len);
                    System.debug('m1len-->'+m1);
                    System.debug('tempsentence1-->'+tempSentence);
                }
                integer m2len=tempSentence.lastIndexOf(' ', m1len+30);
                
                if(m2len>-1 ){  
                    m2len++;
                   m2 = tempSentence.substring(m1len, m2len);
                 
                    System.debug('m2len-->'+m2);
                } 
                 
                if(tempSentence.length() > m2len+30)
                {
                    integer m3len=tempSentence.lastIndexOf(' ', m2len+30);
                    m3len++;
                    m3 = tempSentence.substring(m2len, m3len);
                }
                else
                {
                    m3 = tempSentence.substring(m2len, tempSentence.length());
                }

            } 
            else if(tempSentence.length() <= 60 && tempSentence.length() > 30){
                integer m1len=tempSentence.lastIndexOf(' ', 30);
                if(m1len>-1){
                    m1= tempSentence.substring(0, m1len);
                    System.debug('m1len-->'+m1);
                      System.debug('tempSentence2--->'+tempSentence);
                }
                integer m2len=tempSentence.lastIndexOf(' ', 60);
                if(m2len>-1){
                    m2 = tempSentence.substring(m1len+1, tempSentence.length());
                    System.debug('m2len-->'+m2);
                }
            }
            else if(tempSentence.length() <= 30 && tempSentence.length()>0){
                m1= tempSentence;      
                System.debug('tempSentence3---->'+tempSentence)    ;    
            }
            con.IP_MailingAddressLine1__c = m1;
            con.IP_MailingAddressLine2__c = m2;
            con.IP_MailingAddressLine3__c = m3;
        }
        else if(con.MailingStreet==null){
            con.IP_MailingAddressLine1__c = null;
            con.IP_MailingAddressLine2__c = null;
            con.IP_MailingAddressLine3__c = null;
            
        }
    }    
    public static void onGeneralComplianceStatusChange(List<Contact> newContacts, Map<Id,Contact> oldContacts){

        Id t2candidateRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('2nd Tier Candidate').getRecordTypeId();
        Id candidateRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Candidate').getRecordTypeId();

        for(Contact c : newContacts){
            if((c.RecordTypeId == candidateRTId  || c.RecordTypeId == t2candidateRTId) && c.Compliance_Status__c  != oldContacts.get(c.Id).Compliance_Status__c){
                if(c.Compliance_Status__c == 'Compliant' && c.Person_Status__c == 'Pending')
                {
                    c.Person_Status__c = 'Active';
                }
                //1. General Compliance Status = 'Not Compliant' Action: Active -> Pending
                if(c.Compliance_Status__c == 'Not Compliant' && c.Person_Status__c == 'Active'){  c.Person_Status__c = 'Pending';}
                
                //2. General Compliance Status = 'Partial Compliant' Action; Pending -> Active
                if(c.Compliance_Status__c == 'Partial Compliant' && c.Person_Status__c == 'Pending'){  c.Person_Status__c = 'Active'; }
            }
         }
        
    }
}