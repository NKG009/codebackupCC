public with sharing class CommunityUserProcessAutomationLWCCtlr {
    
    @AuraEnabled
    public static String createOrAssignCommunityUser(Id contactId) {
        try {
            
            if(contactId == null){
                throw new AuraHandledException('Contact Id is required.');
            }
            Contact con = [ SELECT Id, FirstName, LastName, Email, AccountId FROM Contact WHERE Id = :contactId  LIMIT 1];
            
            if(String.isBlank(con.Email)){
                throw new AuraHandledException('Contact must have an Email address.');
            }
            
            List<User> existingUsers = [SELECT Id FROM User WHERE ContactId = :contactId LIMIT 1 ];
            system.debug('Existing Users: ' + existingUsers);
            
            Id userId;
            
            if(existingUsers.isEmpty()){
                
                Profile prof = [SELECT Id FROM Profile WHERE Name = 'Customer Community User Custom' LIMIT 1 ];
                
                String nickName = (con.FirstName != null ? con.FirstName : '') +
                    (con.LastName != null ? con.LastName : '');
                nickName = nickName.replaceAll('\\s+','');
                nickName = nickName.length() > 40 ? nickName.substring(0,40) : nickName;
                
                String aliasVal = con.LastName != null ? con.LastName : 'User';
                aliasVal = aliasVal.replaceAll('\\s+','');
                aliasVal = aliasVal.length() > 8 ? aliasVal.substring(0,8) : aliasVal;
                
                User u = new User(
                    FirstName = con.FirstName,
                    LastName = con.LastName,
                    Email = con.Email,
                    Username = con.Email,
                    Alias = aliasVal,
                    CommunityNickname = nickName,
                    TimeZoneSidKey = 'America/Mexico_City',
                    LocaleSidKey = 'en_US',
                    EmailEncodingKey = 'UTF-8',
                    LanguageLocaleKey = 'en_US',
                    ProfileId = prof.Id,
                    ContactId = con.Id
                );
                
                insert u;
                userId = u.Id;
                
            } else {
                userId = existingUsers[0].Id;
            }
            
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Kitz_Customer_Community_User_Permission_set' LIMIT 1];

            system.debug('Permission Set: ' + ps);
            
            List<PermissionSetAssignment> psa = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :userId AND PermissionSetId = :ps.Id];

            system.debug('Permission Set Assignment: ' + psa);
            
            if(psa.isEmpty()){
                insert new PermissionSetAssignment(
                    AssigneeId = userId,
                    PermissionSetId = ps.Id
                );
            }
            
            return existingUsers.isEmpty() ? 'Community User created and permission set assigned successfully.': 'Permission set assigned to existing user successfully.';
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}