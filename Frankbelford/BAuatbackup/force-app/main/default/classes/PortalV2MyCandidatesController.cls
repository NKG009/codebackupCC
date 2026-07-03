public class PortalV2MyCandidatesController {
    
    @AuraEnabled(cacheable=true)
    public static List<contact > getAllSubmittedCandidates() {
         Id tier2rtypeid = Schema.SObjectType.contact.getRecordTypeInfosByDeveloperName().get('IP_2ndTierCandidate').getRecordTypeId();
         Id currentUserId = UserInfo.getUserId();
        User currentUser = [SELECT Id, ContactId FROM User WHERE Id =: currentUserId];
        Contact userContact = [SELECT Id, AccountId FROM Contact WHERE Id =: currentUser.ContactId];
        Id accountId = userContact.AccountId;
        
        return[select id,name,MobilePhone,Email,CreatedDate from contact where accountid=:accountId AND recordtypeid =:tier2rtypeid ORDER BY Name ASC];
        //return[ select id,Status__c, Contact__c,Contact__r.name,Contact__r.MobilePhone,Contact__r.Email,Contact__r.CreatedDate,Job_Order__r.name ,Job_Order__c,CreatedDate From Candidate__c 
       // where Submitted_By__r.contact.accountid=:accountId
       // ];
        
        
    }
    

}