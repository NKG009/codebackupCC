public class DemoAgentRole {
    @AuraEnabled
public static List<AccountContactRelation> Contactdata(Id recordId){
    List<AccountContactRelation> accList = new List<AccountContactRelation>();
    accList = [Select Id,AccountId,Account.Name,Account.Parent.Name,account.parentid,ContactId,Property_External_ID__c,External_ID__c, IsActive,Roles ,
                       Contact.Name,Contact.recordtypeid,contact.accountid,contact.External_ID__c,Account.External_ID__c  
                       from AccountContactRelation where Property_External_ID__c!=null and Roles = 'Property Manager'   
                    and AccountId=:recordId];
    system.debug('accList'  + accList);
    system.debug('accList'  + accList.size());
  return accList;
}

}