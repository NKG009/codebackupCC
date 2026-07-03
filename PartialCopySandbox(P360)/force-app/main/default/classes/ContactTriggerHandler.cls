public class ContactTriggerHandler {
    
    public static void afterUpdate(Map<Id, Contact> newMap, Map<Id, Contact> oldMap) {
        updateRelatedPropertyAccounts(newMap);
    }
    
    private static void updateRelatedPropertyAccounts(Map<Id, Contact> newMap) {
        if(newMap != null && !newMap.isEmpty()) {
            Map<Id, Account> accountMapToUpdate = new Map<Id, Account>();
            for(AccountContactRelation acrRec : [Select Id, ContactId, Account.Current_PM_Email__c, Account.Property_Manager_Name__c, Account.PM_First_Name__c, Account.PM_Last_Name__c 
                                                 FROM AccountContactRelation WHERE ContactId IN: newMap.keySet() AND Account.RecordType.Name = 'Property' AND Roles Includes ('Property Manager', 'Investment Manager')]) {
                                                     if(!accountMapToUpdate.containsKey(acrRec.AccountId) && 
                                                        (acrRec.Account.Current_PM_Email__c != newMap.get(acrRec.ContactId).Email ||
                                                         acrRec.Account.PM_First_Name__c != newMap.get(acrRec.ContactId).FirstName || 
                                                         acrRec.Account.PM_Last_Name__c != newMap.get(acrRec.ContactId).LastName)) {
                                                             Account acc = acrRec.Account;                                                           
                                                             acc.PM_First_Name__c = newMap.get(acrRec.ContactId).FirstName;
                                                             acc.PM_Last_Name__c = newMap.get(acrRec.ContactId).LastName;
                                                             acc.Current_PM_Email__c = newMap.get(acrRec.ContactId).Email;
                                                             accountMapToUpdate.put(acc.Id, acc);
                                                             if(newMap.get(acrRec.ContactId).FirstName!=null){
                                                                acc.Property_Manager_Name__c = newMap.get(acrRec.ContactId).FirstName+' '+newMap.get(acrRec.ContactId).LastName;
                                                             }
                                                             else
                                                             {
                                                                 acc.Property_Manager_Name__c = newMap.get(acrRec.ContactId).LastName;
                                                             }
                                                         }
                                                 }
            if(!accountMapToUpdate.isEmpty()) {
                update accountMapToUpdate.values();
            }
        }
    }
    
    public static void EmailUpdateOnContactInsertOrUpdate(List<Contact> Conlist){
        
        for (Contact con : Conlist){
            if(con.Preferred_Email_Raw__c !=null && con.Preferred_Email_Raw__c.containsAny('<;&')){
                if(con.Preferred_Email_Raw__c.contains(';')){
                    string[] splitEmail =con.Preferred_Email_Raw__c.split(';');
                   system.debug('stringsplit;;;' + splitEmail);
                    if(validateEmail(splitEmail[0])){ 
                        con.preferred_email__c=splitEmail[0];
                        con.Email= splitEmail[0];
                     //   system.debug('con.preferred_email__c' + con.preferred_email__c);
                     //   system.debug('con.Email' + con.Email);
                    }
                    else
                    {    
                        con.addError('The email format is invalid, please re-enter.');
                        
                    }
                }
                if(con.Preferred_Email_Raw__c.contains('<')){
                    string[] splitEmail =con.Preferred_Email_Raw__c.split('<');
                    system.debug('stringsplit<<<' + splitEmail);
                    string[] splitEmail2= splitEmail[1].split('>');
                    if(validateEmail(splitEmail2[0])){ 
                        con.preferred_email__c=splitEmail2[0];
                        con.Email= splitEmail2[0];
                      //  system.debug('con.preferred_email__c' + con.preferred_email__c);
                      //  system.debug('con.Email' + con.Email);
                    }
                    else
                    {
                        con.addError('The email format is invalid, please re-enter.');
                    }
                }
                if(con.Preferred_Email_Raw__c.contains('&')){
                    string[] splitEmail =con.Preferred_Email_Raw__c.split('&');
                    system.debug('stringsplit&&&' + splitEmail);
                    if(validateEmail(splitEmail[0])){ 
                        con.preferred_email__c=splitEmail[0];
                        con.Email= splitEmail[0];
                        system.debug('con.preferred_email__c' + con.preferred_email__c);
                        system.debug('con.Email' + con.Email);
                    }
                    else
                    {    
                        con.addError('The email format is invalid, please re-enter.');
                        
                    }
                }
            } 
            else if(con.Preferred_Email_Raw__c !=null){
                if(validateEmail(con.Preferred_Email_Raw__c)){ 
                    con.preferred_email__c=con.Preferred_Email_Raw__c;
                    con.Email= con.Preferred_Email_Raw__c;
                  //  system.debug('con.preferred_email__c' + con.preferred_email__c);
                   // system.debug('con.Email' + con.Email);
                    
                }
                else
                {
                    con.addError('The email format is invalid, please re-enter.');
                    
                }
                
            } 
        }
    }
    public static boolean validateEmail( String strEmail)
    {
        String emailRegex =  '^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$';
        Pattern MyPattern = Pattern.compile(emailRegex);
       Matcher MyMatcher = MyPattern.matcher(strEmail);
        if(!MyMatcher.matches()){
            return false;
        }
        else{
            return true;
        }
    }
}