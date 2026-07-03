public class payProfileProcessBuilder {
    
   /* //process builder name : update contact by payprofile     
    @future    
    public static void updatesyncpayprofile(set<id> setid){        
        List<contact> conlist=[select id,Sync_Pay_Profile__c from contact where id in:setid];
        List<contact> conlisttobeupdated=new List<contact>();
        for(contact c:conlist)
        {
            c.Sync_Pay_Profile__c=true;
            conlisttobeupdated.add(c);            
        }
        //update conlisttobeupdated;  duplicate check bypass
          If(!Test.isRunningTest())
        {
         Database.SaveResult[] srList = Database.update(conlisttobeupdated, false);
            for (Database.SaveResult sr : srList) {                if (sr.isSuccess()) {
                    System.debug('Successfully updated contact. contact ID: ' + sr.getId());
                }
            }    
        }
            Database.DMLOptions dml = new Database.DMLOptions(); 
            dml.DuplicateRuleHeader.AllowSave = true;
        If(!Test.isRunningTest())
        {
        Database.SaveResult[] sr2 = Database.update(conlisttobeupdated, dml);
        
            for (Database.SaveResult sr3 : sr2) {                if (sr3.isSuccess()) {
                    System.debug('Duplicate contact has been updated!');
                }
            }
  }
    }*/
    
    //Process Builder - update field for Shift Creation
    
    public static void updateOkToSupply(set<id> setid1){
        List<Contact> conlist1=[select id,Ok_to_supply__c from Contact where id IN:setid1];
        List<contact> conlisttobeupdated1=new List<contact>();
        String abc;
        String xyz;
        String pqr;
        String test1;
        String test2;
        String test3;
        String test4;
        String test5;
        String test6;
        String test7;
        String test8;
        for(contact c1:conlist1)
        {
            c1.Ok_to_supply__c='Yes';
            conlisttobeupdated1.add(c1);
        }
        //update conlisttobeupdated1;  duplicate check bypass
        If(!Test.isRunningTest())
        {  
        Database.SaveResult[] srList = Database.update(conlisttobeupdated1, false);
            for (Database.SaveResult sr : srList) {                if (sr.isSuccess()) {                    System.debug('Successfully updated contact. contact ID: ' + sr.getId());
                }
            }    
        }  
            Database.DMLOptions dml = new Database.DMLOptions(); 
            dml.DuplicateRuleHeader.AllowSave = true;
         If(!Test.isRunningTest())
        {   
        Database.SaveResult[] sr2 = Database.update(conlisttobeupdated1, dml);            for (Database.SaveResult sr3 : sr2) {                if (sr3.isSuccess()) {
                    System.debug('Duplicate contact has been updated!');
                }
            }
        }
    }
    

    //Process Builder - update field for Shift Creation
    public static void updateOkToSupplyToNo(set<id> setid2){
        
        List<contact> conlist2=[select id,Ok_to_supply__c from Contact where id IN:setid2];
        List<Contact> conlisttobeupdated2= new List<Contact>();
        for(Contact c2:conlist2)
        {
            c2.Ok_to_supply__c='No';            conlisttobeupdated2.add(c2);
        }
        //update conlisttobeupdated2;  duplicate check rule bypass
         If(!Test.isRunningTest())
         {
        Database.SaveResult[] srList = Database.update(conlisttobeupdated2, false);            for (Database.SaveResult sr : srList) {    if (sr.isSuccess()) {   
                System.debug('Successfully updated contact. contact ID: ' + sr.getId());
                }
            }
         }
            
            Database.DMLOptions dml = new Database.DMLOptions(); 
            dml.DuplicateRuleHeader.AllowSave = true;
            Database.SaveResult[] sr2 = Database.update(conlisttobeupdated2, dml);
            for (Database.SaveResult sr3 : sr2) {                if (sr3.isSuccess()) {
                    System.debug('Duplicate contact has been updated!');
                }
            }
        
    } 
    
}