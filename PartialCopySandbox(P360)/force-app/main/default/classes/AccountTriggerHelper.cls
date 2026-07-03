public with sharing class AccountTriggerHelper {
    
    /*
When property manager change from X to Y on Account
then 1. Remove sharing of the Account from X
2. Add sharing of the Account to Y
*/
    
    /* public static void assignAccounts(Set<Id> aAccIdSet) {
try{
System.debug('unassignAccounts: ' + aAccIdSet);

List<AccountShare> ashToInsertList = new List<AccountShare>();
List<AccountShare> ashToDeleteList = new List<AccountShare>();

for(AccountShare ash : [SELECT Id, 
AccountId, 
Account.Name,
Account.Property_Office_Agent__c, 
Account.Property_Office_Agent__r.Name, 
RowCause, 
UserOrGroupId, 
UserOrGroup.Name,
UserOrGroup.Profile.Name 
FROM AccountShare 
WHERE AccountId =: aAccIdSet
AND Account.RecordType.DeveloperName = 'Property'
AND UserOrGroup.Profile.Name = 'PS360 Community Plus User' ORDER BY AccountId ASC]){

if('Manual'.equalsIgnoreCase(ash.RowCause)
&& ash.Account.Property_Office_Agent__c <> ash.UserOrGroupId){
ashToDeleteList.add(ash);
}
}

for(Account acc : [SELECT Id, Property_Office_Agent__c 
FROM Account 
WHERE Id =: aAccIdSet 
AND Property_Office_Agent__c <> NULL]){
AccountShare ashToInsert = new AccountShare();
ashToInsert.AccountId = acc.Id;
ashToInsert.CaseAccessLevel = 'Edit';
ashToInsert.AccountAccessLevel = 'Edit';
ashToInsert.OpportunityAccessLevel = 'Edit';
ashToInsert.RowCause = 'Manual';
ashToInsert.UserOrGroupId = acc.Property_Office_Agent__c;
ashToInsertList.add(ashToInsert);
}        

System.debug('ashToDeleteList: ' + ashToDeleteList);
System.debug('ashToInsertList: ' + ashToInsertList);

if(!ashToDeleteList.isEmpty()){
Database.delete(ashToDeleteList, true); 
}

if(!ashToInsertList.isEmpty()){
Database.insert(ashToInsertList, true); 
}        
}catch(Exception e){
System.debug('assignAccounts Error: ' + e.getLineNumber() + ' : ' + e.getMessage());
}
} */
    public static void apiAgentChange(Set<Id> accIds){
        Set<Id> accntId=new Set<Id>();
        List<AccountContactId__c> accIdList=new List<AccountContactId__c>();
        for (Account acc : [Select Id, Name, RecordType.Name, ParentId
                            from Account
                            where RecordType.Name='Property' and ParentId!=null 
                            and Id in : accIds])
        {
            if(AccountContactId__c.getValues(acc.ID) == null) {
                accntId.add(acc.Id);
                accIdList.add(new AccountContactId__c (Name= acc.ID));
            }           
        }
        if(!accntId.isEmpty()){
            System.debug('accId'+accntId);
            insert accIdList;
            //AgentsAccountContactRelation.fetchAgentdata(accntId); 
        }
    } 
    
    public static void HandleChangesOnNewAccountList(List<Account> newlist){
        Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Account.getRecordTypeInfosById();
        for(Account acc : newlist){
            // system.debug('Invoice_Recipient_Email_Formula__c--'+ acc.Invoice_Recipient_Email_Formula__c);
            // system.debug('Parent.Invoicing_Email__c--'+ acc.Parent.Invoicing_Email__c);
            String acctype= rtMap.get(acc.RecordTypeId).getName();
            //acc.RecordType.DeveloperName;
            // system.debug('recordType' + acctype);
            // system.debug('newacc' + acc.invoice_preference_formula__c);
            if( acctype == 'Property'&& acc.invoice_preference_formula__c !=null){
                if(acc.invoice_preference_formula__c =='Both Agency and Property Manager'){
                    acc.Prop_Invoice_Recipent_Email__c=acc.Invoice_Recipient_Email_Formula__c;
                    acc.Prop_Invoice_Recipient_Email_2__c=acc.Current_PM_Email__c;
                }
                else if(acc.invoice_preference_formula__c =='Agency Address Only'){
                    acc.Prop_Invoice_Recipent_Email__c=acc.Invoice_Recipient_Email_Formula__c;
                    acc.Prop_Invoice_Recipient_Email_2__c=null;
                }
                else if(acc.invoice_preference_formula__c =='Property Manager Only'){
                    acc.Prop_Invoice_Recipent_Email__c=null;
                    acc.Prop_Invoice_Recipient_Email_2__c=acc.Current_PM_Email__c;
                }
                else if(acc.invoice_preference_formula__c =='Post to Property Me Only'){
                    acc.Prop_Invoice_Recipent_Email__c=null;
                    acc.Prop_Invoice_Recipient_Email_2__c=null;
                }

            } 
            if(acctype == 'Property'&& acc.Document_Receipt_Preferences_Formula__c !=null){
                if(acc.Document_Receipt_Preferences_Formula__c =='Both Agency and Property Manager'){
                    acc.Prop_Compliance_Recipient_Email__c=acc.Compliance_Recipient_Email_Formula__c;
                    acc.Prop_Compliance_Recipient_2__c=acc.Current_PM_Email__c;
                }
                else if(acc.Document_Receipt_Preferences_Formula__c =='Agency Address Only'){
                    acc.Prop_Compliance_Recipient_Email__c=acc.Compliance_Recipient_Email_Formula__c;
                    acc.Prop_Compliance_Recipient_2__c=null;
                }
                else if(acc.Document_Receipt_Preferences_Formula__c =='Property Manager Only'){
                    acc.Prop_Compliance_Recipient_Email__c=null;
                    acc.Prop_Compliance_Recipient_2__c=acc.Current_PM_Email__c;
                }
                else if(acc.Document_Receipt_Preferences_Formula__c =='Post to Property Me Only'){
                    acc.Prop_Compliance_Recipient_Email__c=null;
                    acc.Prop_Compliance_Recipient_2__c=null;
                }
            }
        }
    } 
    
    
    @future
    public static void HandleUpdatingChildRecords(List<ID> accids){
        List<Account> acctoupdate = new List<Account>();
        //List<Account> newlist = [ select Id,Recordtype.DeveloperName, Current_PM_Email__c,Invoice_Recipient_Email_Formula__c,Compliance_Recipient_Email_Formula__c,invoice_preference_formula__c,Document_Receipt_Preferences_Formula__c,ParentId,Parent.Invoice_Recipient_Preferences__c,Parent.Invoicing_Email__c,Parent.Document_Receipt_Preferences__c,Parent.Compliance_Cert_Email__c from Account where ParentId IN:accids ];
        for(Account acc : [select Id,Recordtype.DeveloperName, Current_PM_Email__c,Invoice_Recipient_Email_Formula__c,Compliance_Recipient_Email_Formula__c,invoice_preference_formula__c,Document_Receipt_Preferences_Formula__c,ParentId,Parent.Invoice_Recipient_Preferences__c,Parent.Invoicing_Email__c,Parent.Document_Receipt_Preferences__c,Parent.Compliance_Cert_Email__c from Account where ParentId IN:accids ]){
            
            String acctype= acc.RecordType.DeveloperName;
            if( acctype == 'Property'&& ( acc.invoice_preference_formula__c !=null)){
                system.debug('afterif futuremethod INV---' + acc.invoice_preference_formula__c);
                if(acc.invoice_preference_formula__c =='Both Agency and Property Manager'){
                    acc.Prop_Invoice_Recipent_Email__c=acc.Invoice_Recipient_Email_Formula__c;
                    acc.Prop_Invoice_Recipient_Email_2__c=acc.Current_PM_Email__c;
                }
                else if(acc.invoice_preference_formula__c =='Agency Address Only'){
                    acc.Prop_Invoice_Recipent_Email__c=acc.Invoice_Recipient_Email_Formula__c;
                    acc.Prop_Invoice_Recipient_Email_2__c=null;
                }
                else if(acc.invoice_preference_formula__c =='Property Manager Only'){
                    acc.Prop_Invoice_Recipent_Email__c=null;
                    acc.Prop_Invoice_Recipient_Email_2__c=acc.Current_PM_Email__c;
                }
                else if(acc.invoice_preference_formula__c =='Post to Property Me Only'){
                    acc.Prop_Invoice_Recipent_Email__c=null;
                    acc.Prop_Invoice_Recipient_Email_2__c=null;
                }
                
            } 
            if(acctype == 'Property'&& (acc.Document_Receipt_Preferences_Formula__c !=null)){
                if(acc.Document_Receipt_Preferences_Formula__c =='Both Agency and Property Manager'){
                    acc.Prop_Compliance_Recipient_Email__c=acc.Compliance_Recipient_Email_Formula__c;
                    acc.Prop_Compliance_Recipient_2__c=acc.Current_PM_Email__c;
                }
                else if(acc.Document_Receipt_Preferences_Formula__c =='Agency Address Only'){
                    acc.Prop_Compliance_Recipient_Email__c=acc.Compliance_Recipient_Email_Formula__c;
                    acc.Prop_Compliance_Recipient_2__c=null;
                }
                else if(acc.Document_Receipt_Preferences_Formula__c =='Property Manager Only'){
                    acc.Prop_Compliance_Recipient_Email__c=null;
                    acc.Prop_Compliance_Recipient_2__c=acc.Current_PM_Email__c;
                }
                else if(acc.Document_Receipt_Preferences_Formula__c =='Post to Property Me Only'){
                    acc.Prop_Compliance_Recipient_Email__c=null;
                    acc.Prop_Compliance_Recipient_2__c=null;
                }
            }
            
            acctoupdate.add(acc);  
        }    
        
        if(acctoupdate.size()>0){
            update acctoupdate;
        } 
    }  
    
    
    /*   All Account Sharing for PowerUser on Agency account ( 3 scenarios ) - 1. when new Agency Account created
2. when New Propery Account created With Agency account
3. When Property Account's Parent account changes i.e Reparented    */
    
    
    
    /******************  1. when new Agency Account created   ********************/
    
    public static void AccountSharingforPowerUserOnUpdate (List<Account> newlist, Map<Id, Account> oldMap){
        list<Id>ChangedAccids = new list<Id>();
        list<AccountShare> Accsharelist = new list<AccountShare>();
        map<Id,Id> oldaccountshareVsPUser = new map<Id,Id>();
        list<AccountShare> oldAccsharelisttodelete = new list<AccountShare>();
        
        Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Account.getRecordTypeInfosById();
        for(Account Acc:newlist){
            Account oldAccount=oldMap.get(acc.ID);
            string rtype=rtMap.get(acc.RecordTypeId).getName();
            //system.debug('rtype=='+ rtype);
            //system.debug('oldaccid==='+oldAccount);
            if(Acc.Power_User__c != oldAccount.Power_User__c && rtype=='Real Estate Office'){
                ChangedAccids.add(Acc.id);
                
            }
            
        }
        //system.debug('ChangedAccids==='+ChangedAccids);
        if(ChangedAccids.size()>0){
            for(Account acc:[select Id,ParentId,Parent.Power_User__c,Parent.RecordTypeId from account where ParentId IN:ChangedAccids ]){
                
                string PUser=acc.Parent.Power_User__c;
                string Rtype=rtMap.get(acc.Parent.RecordTypeId).getName();
                if(PUser!=null && Rtype=='Real Estate Office'){
                    AccountShare ash = new AccountShare();
                    ash.AccountId =acc.Id;
                    ash.UserOrGroupId = PUser;
                    ash.AccountAccessLevel= 'Edit';
                    ash.OpportunityAccessLevel='None';
                    ash.CaseAccessLevel='None';
                    Accsharelist.add(ash);
                }
                if(oldMap.get(acc.ParentId).Power_User__c !=null){
                    Id OldPUser=oldMap.get(acc.ParentId).Power_User__c;
                    oldaccountshareVsPUser.put(acc.Id,OldPUser);
                }
            }
        } 
        
        if(oldaccountshareVsPUser.size()>0){
            for(AccountShare oldAsh :[ select AccountId,UserOrGroupId from AccountShare where AccountId IN:oldaccountshareVsPUser.keyset()]){
                if(oldAsh.UserOrGroupId !=null && oldAsh.UserOrGroupId == oldaccountshareVsPUser.get(oldAsh.AccountId) ){
                    oldAccsharelisttodelete.add(oldAsh);
                }
            }
        }
        // system.debug('Accsharelist Newww==='+Accsharelist);
        if(Accsharelist.size()>0){
            insert Accsharelist;
        }
        // system.debug('oldAccsharelisttodelete Newww==='+oldAccsharelisttodelete);
        if(oldAccsharelisttodelete.size()>0){
            delete oldAccsharelisttodelete;
        } 
    }  
    
    /****************** 2. when New Propery Account created With Agency account  ********************/
    
    public static void AccountSharingforPowerUserOnInsertchildac(List<Account> newlist){
        list<Id>ChangedAccids = new list<Id>();
        list<Id>allAccids = new list<Id>();
        map<Id,Id> accidvsPUser = new map<Id,Id>();
        map<Id,string> accidvsRtype = new map<Id,string>();
        list<AccountShare> Accsharelist = new list<AccountShare>();
        
        Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Account.getRecordTypeInfosById();
        for(Account Acc:newlist){
            string rtype=rtMap.get(acc.RecordTypeId).getName();
            if(rtype=='Property' && acc.ParentId !=null){
                allAccids.add(Acc.ParentId);
            }
        }  
        
        for(account AgencyAcclist:[select Id, Power_User__c,RecordType.DeveloperName, RecordTypeId from account where Id IN:allAccids ]){
            //Check null for PowerUser
            accidvsPUser.put(AgencyAcclist.Id, AgencyAcclist.Power_User__c);
            accidvsRtype.put(AgencyAcclist.Id , AgencyAcclist.RecordType.DeveloperName);
        }
        
        // system.debug('accidvsPUser==='+accidvsPUser);
        // system.debug('accidvsRtype@@@'+accidvsRtype);
        
        for(Account Acc:newlist){
            //Check null for ParentId
            string Puser= accidvsPUser.get(acc.ParentId);
            //system.debug('@@@ Puser'+Puser);
            string Rtype= accidvsRtype.get(acc.ParentId);
            //system.debug('Rtype==='+Rtype);
            if(Puser !=null && Rtype=='Real_Estate_Office'){
                ChangedAccids.add(Acc.ParentId);
            }
        }
        // system.debug('insertChangedAccids==='+ChangedAccids); 
        if(ChangedAccids.size()>0){
            for(Account acc:[select Id,ParentId,Parent.Power_User__c,Parent.RecordType.developername from account where ParentId IN:ChangedAccids ]){
                
                string PUser=accidvsPUser.get(acc.ParentId);
                AccountShare ash = new AccountShare();
                ash.AccountId =acc.Id;
                ash.UserOrGroupId = PUser;
                ash.AccountAccessLevel= 'Edit';
                ash.OpportunityAccessLevel='None';
                ash.CaseAccessLevel='None';
                Accsharelist.add(ash);
                
            }
        } 
        if(Accsharelist.size()>0){
            insert Accsharelist;
        }
    }
    
    /****************** 3. When Property Account's Parent account changes i.e Reparented********************/
    
    public static void AccountSharingforPowerUserOnUpdatetchildac(List<Account> newlist,Map<Id, Account> oldMap){
        
        list<Id> chngeAgencyaccids = new  list<Id>();
        map <Id,Id> oldaccVPuser = new map <Id,Id>();  
        map <Id,Id> AgencyaccVprop =new map <Id,Id>();
        list<AccountShare> Childaccsharelist= new list<AccountShare>();
        list<AccountShare> OldAccsharelist= new list<AccountShare>();
        //system.debug('!!!!!!!!!!!!!!!!!!!!!!!AccountSharingforPowerUserOnUpdatetchildac!!!!!!!!!!!!!!!!!!!!!!');
        for(account acc : newlist){
            Id PropRTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Property').getRecordTypeId();
            Account oldAccount=oldMap.get(acc.ID);
            if(acc.RecordTypeId==PropRTypeId && oldAccount.parentid !=acc.parentid){
                if(acc.parentid !=null)
                    chngeAgencyaccids.add(acc.parentid);
                if(oldAccount.parentid !=null)
                    AgencyaccVprop.put(oldAccount.parentid,acc.id);
                
            }     
        } 
        // system.debug('chngeAgencyaccids---' +chngeAgencyaccids);
        // system.debug('oldAgencyaccids--'+AgencyaccVprop);
        //system.debug('chngedpropid--'+ chngedpropid);
        if(AgencyaccVprop.keyset().size()>0){
            for(account oldacc : [ select id, parentid,Parent.Power_User__c from account where parentid IN:AgencyaccVprop.keySet()  and Parent.Power_User__c!=null]){
                if(AgencyaccVprop.containsKey(oldacc.parentid)){
                    Id propid = AgencyaccVprop.get(oldacc.parentid);
                    oldaccVPuser.put(propid,oldacc.Parent.Power_User__c );
                }
            }
        }    
        if(chngeAgencyaccids.size()>0){
            for(account childacc : [select Id,ParentId,Parent.RecordTypeId,Parent.RecordType.DeveloperName,Parent.Power_User__c from Account where ParentId IN:chngeAgencyaccids]){
                string rtype =childacc.Parent.RecordType.DeveloperName;
                if(childacc.Parent.Power_User__c !=null && rtype=='Real_Estate_Office'  ){
                    
                    AccountShare ash = new AccountShare();
                    ash.AccountId =childacc.Id;
                    ash.UserOrGroupId = childacc.Parent.Power_User__c;
                    ash.AccountAccessLevel= 'Edit';
                    ash.OpportunityAccessLevel='None';
                    ash.CaseAccessLevel='None';
                    Childaccsharelist.add(ash);
                    
                }    
            }
        }
        
        // system.debug('oldaccVPuser==' + oldaccVPuser);
        if(oldaccVPuser.keyset().size()>0){
            for(AccountShare oldash : [ select AccountId,UserOrGroupId from AccountShare where AccountId IN: oldaccVPuser.keyset()]){
                
                if(oldash.UserOrGroupId != null && oldash.UserOrGroupId == oldaccVPuser.get(oldash.AccountId) ){
                    OldAccsharelist.add(oldash);
                }
            }
        }
        
        // system.debug('Childaccsharelist===' +Childaccsharelist);
        if(Childaccsharelist.size()>0){
            insert Childaccsharelist;
        } 
        //system.debug('OldAccsharelist==' + OldAccsharelist);
        if(OldAccsharelist.size()>0){
            delete OldAccsharelist;
        }    
        
        
    }
    
    /*****************************    Invoice Sharing for Power User    ***********************************/
    
    public static void InvoiceSharingforPowerUseronAgencyAccount(List<Account> newlist,Map<Id, Account> oldMap){
        list<Id> TargetAccId = new list<Id>();
        Map<Id,Id> acctoOldPowerUser = new Map<Id,Id>();
        
        for(Account acc :newlist){
            Account oldAccount=oldMap.get(acc.ID);
            if(acc.Power_User__c != oldAccount.Power_User__c){ 
                TargetAccId.add(acc.Id);
                if(oldAccount.Power_User__c!=null){
                    acctoOldPowerUser.put(acc.Id,oldAccount.Power_User__c);
                    
                }
            }
        }
        system.debug('invoiceTargetAccId'+TargetAccId);
        system.debug('invoicebeforeacctoOldPowerUser'+acctoOldPowerUser);
        String accoldPuJSON=JSON.serialize(acctoOldPowerUser);
        system.debug('invoiceaccoldPuJSON'+accoldPuJSON);
       if(!System.isFuture() && !System.isBatch()){
            InvoiceSharingforPA(TargetAccId,accoldPuJSON);
        }
        
    }
    
    @future
    public static void InvoiceSharingforPA( list<Id> TargetAccId, string JSONstr){
        
        Map<Id,object> OldInvoicetoPowerUser = new Map<Id,object>();
        list<Bread_Winner__Invoice__Share> InvoicetoShareList = new list<Bread_Winner__Invoice__Share>();
        list<Bread_Winner__Invoice__Share> oldInvoiceSharedListtodel = new list<Bread_Winner__Invoice__Share>();
        List<ContentDocumentLink> cdlToInsertList = new List<ContentDocumentLink>();
        Map<Id,Id> orderidToContentDocumentId = new Map<Id,Id>();
        Map<Id,Id>InvidToContentDocumentlinkId = new Map<Id,Id>();
        Map<Id,Id> invoiceToOrderMap = new Map<Id,Id>();
        
        Map<string,object> acctoOldPowerUser= (Map<string,object>)JSON.deserializeUntyped(JSONstr);
        system.debug('AfteracctoOldPowerUser'+acctoOldPowerUser);
        
        if(TargetAccId.size()>0){
            for(Bread_Winner__Invoice__c Inv : [select id,Order_Lookup__c,Bread_Winner__Account__c,Bread_Winner__Account__r.Power_User__c,Bread_Winner__Account__r.name,Bread_Winner__Account__r.recordtype.developername from Bread_Winner__Invoice__c where Bread_Winner__Account__c IN:TargetAccId ]){
                if(Inv.Bread_Winner__Account__r.Power_User__c !=null){
                    Bread_Winner__Invoice__Share ishToInsert = new Bread_Winner__Invoice__Share();
                    ishToInsert.AccessLevel = 'Read';
                    ishToInsert.ParentId = Inv.Id;
                    ishToInsert.UserOrGroupId = Inv.Bread_Winner__Account__r.Power_User__c;
                    InvoicetoShareList.add(ishToInsert);
                    invoiceToOrderMap.put(Inv.Order_Lookup__c,Inv.Id);
                } 
                
                object oldPU= (object)acctoOldPowerUser.get(Inv.Bread_Winner__Account__c);
                OldInvoicetoPowerUser.put(Inv.Id,oldPU); 
                system.debug('InvoiceoldPU'+oldPU);
            }
        }
        
        
        if(!invoiceToOrderMap.isEmpty()&& !Test.isRunningTest()){
            
            for (ContentDocumentLink OrderCDL : [SELECT Id,ContentDocumentId,LinkedEntityId FROM ContentDocumentLink  WHERE LinkedEntityId IN: invoiceToOrderMap.keyset()  AND ContentDocument.FileType = 'PDF']){
                orderidToContentDocumentId.put(OrderCDL.LinkedEntityId,OrderCDL.ContentDocumentId);
            }
            
            for (ContentDocumentLink InvCDL : [SELECT Id,ContentDocumentId,LinkedEntityId FROM ContentDocumentLink  WHERE LinkedEntityId IN: invoiceToOrderMap.values()  AND ContentDocument.FileType = 'PDF']){
                
                InvidToContentDocumentlinkId.put(InvCDL.LinkedEntityId,InvCDL.Id);
                
            }
            for(Id OrdId : invoiceToOrderMap.keyset()){    
                id invid=invoiceToOrderMap.get(OrdId);
                id invcdlID = InvidToContentDocumentlinkId.get(invid);
                id cdlid=orderidToContentDocumentId.get(OrdId);
                
                if(invcdlID==null && invid !=null && cdlid !=null){
                    ContentDocumentLink cdlToInsert = new ContentDocumentLink();
                    cdlToInsert.ContentDocumentId =cdlid;
                    cdlToInsert.LinkedEntityId = invid;
                    cdlToInsert.Visibility = 'AllUsers';
                    cdlToInsertList.add(cdlToInsert);
                }   
            }                                            
        }
        
        
        if(OldInvoicetoPowerUser.keyset().size()>0){
            for (Bread_Winner__Invoice__Share oldInvSh : [select ParentId, UserOrGroupId from Bread_Winner__Invoice__Share where ParentId IN:OldInvoicetoPowerUser.keyset()]){
                if(oldInvSh.UserOrGroupId !=null && oldInvSh.UserOrGroupId == OldInvoicetoPowerUser.get(oldInvSh.ParentId)){
                    oldInvoiceSharedListtodel.add(oldInvSh);
                    
                }
            }
        } 
        system.debug('cdlToInsertList'+cdlToInsertList);
        if(cdlToInsertList.size()>0){
            Database.insert(cdlToInsertList, false);
        }
        
        system.debug('InvoicetoShareList'+InvoicetoShareList);
        if(InvoicetoShareList.size()>0){
            insert InvoicetoShareList;
        }
        
        system.debug('oldInvoiceSharedListtodel'+oldInvoiceSharedListtodel);
        if(oldInvoiceSharedListtodel.size()>0){
            delete oldInvoiceSharedListtodel;
        }
        
    }
    /*****************************    Work order sharing of All property account to current Power User on that Agency Account     ***********************************/
    
    public static void WorkOrderSharingAllPropertyAccountforPowerUseronAgencyAccount(List<Account> newlist,Map<Id, Account> oldMap){
        list<Id> TargetAccId = new list<Id>();
        Map<Id,Id> acctoOldPowerUser = new Map<Id,Id>();  
        for(Account acc :newlist){
            Account oldAccount=oldMap.get(acc.ID);
            if(acc.Power_User__c != oldAccount.Power_User__c){ 
                TargetAccId.add(acc.Id);
                if(oldAccount.Power_User__c!=null){
                    acctoOldPowerUser.put(acc.Id,oldAccount.Power_User__c);
                    
                }
            }
        }
        system.debug('TargetAccId'+TargetAccId);
        system.debug('beforeacctoOldPowerUser'+acctoOldPowerUser);
        String accoldPuJSON=JSON.serialize(acctoOldPowerUser);
        system.debug('accoldPuJSON'+accoldPuJSON);
       if(!System.isFuture() && !System.isBatch()){
            WorkOrderSharingforPA(TargetAccId,accoldPuJSON);
        }
        
    }
    
    
    
    @future
    public static void WorkOrderSharingforPA( list<Id> TargetAccId, string JSONstr){
        Map<Id,object> OldWorkOrdertoPowerUser = new Map<Id,object>();
        List<WorkOrderShare> WorkOrderToShare = new List<WorkOrderShare>();
        List<WorkOrderShare> SharedWorkOrderToDelete = new List<WorkOrderShare>();
        
        Map<string,object> acctoOldPowerUser= (Map<string,object>)JSON.deserializeUntyped(JSONstr);
        system.debug('AfteracctoOldPowerUser'+acctoOldPowerUser);
        system.debug('TargetAccId'+TargetAccId);
        if(TargetAccId.size()>0){
            for( WorkOrder WO : [Select Id, AccountId,Account.parentid,Account.parent.name,Account.parent.Power_User__c from WorkOrder where Account.parentid IN:TargetAccId]){
                if(WO.Account.parent.Power_User__c !=null){
                    WorkOrderShare NewWOS = new WorkOrderShare();
                    NewWOS.ParentId = WO.Id;
                    NewWOS.UserOrGroupId = WO.Account.parent.Power_User__c;
                    NewWOS.AccessLevel = 'Edit';
                    WorkOrderToShare.add(NewWOS);
                    
                }
                Object oldPU= (Object)acctoOldPowerUser.get(WO.Account.parentid);
                OldWorkOrdertoPowerUser.put(WO.Id,oldPU); 
                system.debug('oldPU'+oldPU);
                
            }
        } 
        if(OldWorkOrdertoPowerUser.keyset().size()>0){
            for (WorkOrderShare OldWOShared : [select ParentId, UserOrGroupId from WorkOrderShare where ParentId IN:OldWorkOrdertoPowerUser.keyset()]){
                if(OldWOShared.UserOrGroupId !=null && OldWOShared.UserOrGroupId == OldWorkOrdertoPowerUser.get(OldWOShared.ParentId)){
                    SharedWorkOrderToDelete.add(OldWOShared);
                    
                }
            }
        }    
        system.debug('WorkOrderToShare'+WorkOrderToShare);
        if(WorkOrderToShare.size()>0){
            insert WorkOrderToShare;
        }
        
        system.debug('SharedWorkOrderToDelete'+SharedWorkOrderToDelete);
        if(SharedWorkOrderToDelete.size()>0){
            delete SharedWorkOrderToDelete;
        }
        
    }   
}