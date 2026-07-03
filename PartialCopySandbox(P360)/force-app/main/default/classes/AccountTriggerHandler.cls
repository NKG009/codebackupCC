public with sharing class AccountTriggerHandler { 
    
    public static void beforeInsert(List<Account> newlist){
        accountInvoiceCompliance(newlist, null);
        BillingAddressUpdateOnNewAccount(newlist);
        
    }
    
    public static void beforeUpdate(List<Account> newlist, Map<Id, Account> oldMap){
        AccountPMEmailchange(newlist,oldMap);
        BillingAddressUpdateOnAddressUpdate(newlist, oldMap);
    }
    
    public static void afterInsert(List<Account> newlist){
        handleOwnershipIdUpdateOnProperties(newlist, null);
        apiAgentChangeHandling();
        AccountTriggerHelper.AccountSharingforPowerUserOnInsertchildac(newlist);
        AccountContactRelationshipCreationOnNewPropAccountinsert(newlist);
         updateMaintenancePlanfield(newlist,null);
    }
    
    public static void afterUpdate(List<Account> newlist, Map<Id, Account> oldMap){
        accountInvoiceCompliance(newlist, oldMap);
        handleOwnershipIdUpdateOnProperties(newlist, oldMap);
        apiAgentChangeHandling();
        handleWorkOrderSharingOnAccountsPropertyChange(newlist, oldMap);
        InvoiceSharingHandleOnPropertyAgentChange(newlist, oldMap);
        AccountTriggerHelper.AccountSharingforPowerUserOnUpdate(newlist, oldMap);
        AccountTriggerHelper.AccountSharingforPowerUserOnUpdatetchildac(newlist,oldMap);
        AccountTriggerHelper.InvoiceSharingforPowerUseronAgencyAccount(newlist,oldMap);
        AccountTriggerHelper.WorkOrderSharingAllPropertyAccountforPowerUseronAgencyAccount(newlist,oldMap);
        AccountContactRelationshipHandleOnExternalIDChange(newlist,oldMap);
        updateMaintenancePlanfield(newlist,oldMap);
    }
    
    public static void handleOwnershipIdUpdateOnProperties(List<Account> newlist, Map<Id, Account> oldMap){
        String propertyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Property').getRecordTypeId();
        List<Property_Account_Id__c> propertyAccountList = new List<Property_Account_Id__c>();
        for(Account acc : newlist) {  
            
            if(acc.RecordTypeId == propertyRecordTypeId && acc.API_Ownership_External_ID__c != null) {
                if(oldMap == null || (acc.API_Ownership_External_ID__c != oldMap.get(acc.Id).API_Ownership_External_ID__c 
                                      && Property_Account_Id__c.getValues(acc.Id) == null)) {
                                          propertyAccountList.add(new Property_Account_Id__c(Name = acc.Id));
                                      }
            }
        }
        if(!propertyAccountList.isEmpty()) insert propertyAccountList;
    }
    
    public static void apiAgentChangeHandling(){
        Set<Id> accIdSet = new Set<Id>();
        Set<Id> accapiIds=new Set<Id>();        
        for(Account acc : (List<Account>) Trigger.new){  
            Account oldAcc = Trigger.oldMap != null ? (Account) Trigger.oldMap.get(acc.Id): null;
            if(Trigger.oldMap == null || acc.Property_Office_Agent__c != oldAcc.Property_Office_Agent__c){
                accIdSet.add(acc.Id);
            }
            
            if(acc.Property_Source__c =='Property Tree'){
                if((acc.API_Agent_1_External_ID__c!=null && (Trigger.oldMap == null || oldAcc.API_Agent_1_External_ID__c!=acc.API_Agent_1_External_ID__c))||
                   (acc.API_Agent_2_External_ID__c!=null && (Trigger.oldMap == null || oldAcc.API_Agent_2_External_ID__c!=acc.API_Agent_2_External_ID__c))||
                   (acc.API_Agent_3_External_ID__c!=null && (Trigger.oldMap == null || oldAcc.API_Agent_3_External_ID__c!=acc.API_Agent_3_External_ID__c))||
                   (acc.API_Agent_4_External_ID__c!=null && (Trigger.oldMap == null || oldAcc.API_Agent_4_External_ID__c!=acc.API_Agent_4_External_ID__c))||
                   (acc.API_Agent_5_External_ID__c!=null && (Trigger.oldMap == null || oldAcc.API_Agent_5_External_ID__c!=acc.API_Agent_5_External_ID__c))){
                       accapiIds.add(acc.Id);
                   }
            }
        }
        if(!accIdSet.isEmpty()){
            //AccountTriggerHelper.assignAccounts(accIdSet);
        }
        if(!accapiIds.isEmpty()){
            System.debug('accapiIds--'+accapiIds) ;
            AccountTriggerHelper.apiAgentChange(accapiIds);
        }
    }
    
    /**********************Invoice email change on property account when New property account created or property account Updated****************/
    public static void accountInvoiceCompliance(List<Account> newlist, Map<Id, Account> oldMap){
        List<ID> ChangedAcclist = new List<ID>();
        
        if(oldMap==null){
            AccountTriggerHelper.HandleChangesOnNewAccountList(newlist);
        }
        else{  
            
            for(account acc : newlist){             
                Account oldAccount=oldMap.get(acc.ID);
                if((acc.Invoice_Recipient_Preferences__c !=oldAccount.Invoice_Recipient_Preferences__c) || (acc.Invoicing_Email__c !=oldAccount.Invoicing_Email__c) || (acc.Document_Receipt_Preferences__c !=oldAccount.Document_Receipt_Preferences__c) || (acc.Compliance_Cert_Email__c !=oldAccount.Compliance_Cert_Email__c)){
                    ChangedAcclist.add(acc.Id);
                    System.debug('parentdata-----'+oldMap);
                }
            }
            if(ChangedAcclist.size()>0){
                AccountTriggerHelper.HandleUpdatingChildRecords(ChangedAcclist); 
            }
            
            
            
        } 
    }
    
    /**********************Invoice email (Updating Current Property Email) ****************/
    public static void AccountPMEmailchange(List<Account> newlist, Map<Id, Account> oldMap){
        List<Account>AccListOnPMEmailChange = new List<Account>();
        for(account acc : newlist){    
            Account oldAccount=oldMap.get(acc.ID);
            if(acc.Current_PM_Email__c!=oldAccount.Current_PM_Email__c){
                AccListOnPMEmailChange.add(acc);
            }
            if(AccListOnPMEmailChange.size()>0){
                AccountTriggerHelper.HandleChangesOnNewAccountList(AccListOnPMEmailChange); 
            }
            
        }
    }  
    
    /**********************Billing Address populating on Property Account(when new address added)****************/
    
    public static void BillingAddressUpdateOnNewAccount(List<Account> newlist){
        
        Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Account.getRecordTypeInfosById();
        for(Account acc : newlist){
            String acctype= rtMap.get(acc.RecordTypeId).getName();
            if( (acctype == 'Property'&& acc.Property_Source__c != null)&&
               ((acc.address_line_1__c  != null)||
                (acc.address_street_number__c != null)||
                (acc.address_unit__c != null)||
                (acc.address_suburb__c != null)||
                (acc.address_state__c != null)||
                (acc.address_country__c != null)||
                (acc.address_post_code__c != null))){
                    
                  if(acc.address_unit__c==null && acc.address_street_number__c == null){
                         acc.BillingStreet = acc.address_line_1__c ;
                    }
                    else if(acc.address_unit__c==null){
                        acc.BillingStreet = acc.address_street_number__c + ' ' + acc.address_line_1__c ;
                    }
                    else {
                        acc.BillingStreet = acc.address_unit__c + '/'+ acc.address_street_number__c + ' ' + acc.address_line_1__c ;
                    }
                    acc.BillingCity= acc.address_suburb__c;
                    acc.BillingState=acc.address_state__c;
                    acc.BillingCountry= acc.address_country__c;
                    acc.BillingPostalCode=acc.address_post_code__c;
                    
                    
                }
            if(acctype == 'Property' && acc.Last_Service_Date__c !=null){
                acc.Next_Service_Date__c=acc.Last_Service_Date__c.addYears(1);
                system.debug('INSERTnxtservcdate=='+ acc.Next_Service_Date__c);
                
            }
            
        }  
    }
    
    /**********************Billing Address populating on Property Account(when address updated)****************/
    public static void BillingAddressUpdateOnAddressUpdate(List<Account> newlist, Map<Id, Account> oldMap){
        Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Account.getRecordTypeInfosById();
        for(Account acc : newlist){
            String acctype= rtMap.get(acc.RecordTypeId).getName();
            Account oldAccount=oldMap.get(acc.ID);
            if( (acctype == 'Property'&& acc.Property_Source__c != null)&&
               ((acc.address_line_1__c  != oldAccount.address_line_1__c)||
                (acc.address_street_number__c != oldAccount.address_street_number__c)||
                (acc.address_unit__c != oldAccount.address_unit__c)||
                (acc.address_suburb__c != oldAccount.address_suburb__c)||
                (acc.address_state__c != oldAccount.address_state__c)||
                (acc.address_country__c != oldAccount.address_country__c)||
                (acc.address_post_code__c != oldAccount.address_post_code__c))){
                    
                  if(acc.address_unit__c==null && acc.address_street_number__c == null){
                         acc.BillingStreet = acc.address_line_1__c ;
                    }
                    else if(acc.address_unit__c==null){
                        acc.BillingStreet = acc.address_street_number__c + ' ' + acc.address_line_1__c ;
                    }
                    else {
                        acc.BillingStreet = acc.address_unit__c + '/'+ acc.address_street_number__c + ' ' + acc.address_line_1__c ;
                    }
                    acc.BillingCity= acc.address_suburb__c;
                    acc.BillingState=acc.address_state__c;
                    acc.BillingCountry= acc.address_country__c;
                    acc.BillingPostalCode=acc.address_post_code__c;
                    
                    
                }
            if(acctype == 'Property' && acc.Last_Service_Date__c !=null && acc.Last_Service_Date__c!= oldAccount.Last_Service_Date__c){
                acc.Next_Service_Date__c=acc.Last_Service_Date__c.addYears(1);
                system.debug('updatenxtservcdate=='+ acc.Next_Service_Date__c);
                
            }
            
        }  
    }
    /******************Work Order Sharing For Property Agent Change on Property Account********************/
    
    public static void handleWorkOrderSharingOnAccountsPropertyChange(List<Account> newlist, Map<Id, Account> oldMap){
        List<Id> ChangedAccId = new List<Id>();
        Map<Id,Id> oldWorkOrderPropertyAgent=new map<Id,Id>();
        Map<Id,Id> oldaccountshareWithPA= new map<Id,Id>();
        List<WorkOrderShare> FinalNewWOSList = new List<WorkOrderShare>();
        List<WorkOrderShare> FinalOldWOSList = new List<WorkOrderShare>();
        list<AccountShare> ListofAccSharetoRemove= new list<AccountShare>();
        for(account acc : newlist){
            Account oldAccount=oldMap.get(acc.ID);
            if(acc.Property_Office_Agent__c != oldAccount.Property_Office_Agent__c){ 
                
                ChangedAccId.add(acc.Id);
                oldaccountshareWithPA.put(acc.Id,oldAccount.Property_Office_Agent__c);
                
                //system.debug('ChangedAccIdzzz' + ChangedAccId);
            }
        }
        if(ChangedAccId.size()>0){
            for( WorkOrder WList : [ Select Id, AccountId,Account.Property_Office_Agent__c from WorkOrder where AccountId IN:ChangedAccId]){
                // system.debug('newPA' + WList.Account.Property_Office_Agent__c);
                if(WList.Account.Property_Office_Agent__c!=null){
                    WorkOrderShare NewWOS = new WorkOrderShare();
                    NewWOS.ParentId = WList.Id;
                    NewWOS.UserOrGroupId = WList.Account.Property_Office_Agent__c;
                    NewWOS.AccessLevel = 'Edit';
                    FinalNewWOSList.add(NewWOS);
                }
                //system.debug('oldpa---' + oldMap.get(WList.AccountId).Property_Office_Agent__c);
                //system.debug('oldpa---' + oldMap.get(WList.AccountId).Property_Office_Agent__c);
                if(oldMap.get(WList.AccountId).Property_Office_Agent__c!=null){
                    Id oldPM=oldMap.get(WList.AccountId).Property_Office_Agent__c;
                    oldWorkOrderPropertyAgent.put(WList.Id,oldPM);
                }
                
            }
        }
        // system.debug('mapkey-----' + oldWorkOrderPropertyAgent);
        if(oldWorkOrderPropertyAgent.keyset().size()>0){
            list<WorkOrderShare> AllWO= [select ParentId, UserOrGroupId from Workordershare where ParentId IN:oldWorkOrderPropertyAgent.keyset()];
            for (WorkOrderShare oldWOS : AllWO){
                //system.debug('oldwos1st--' + oldWOS);
                if(oldWOS.UserOrGroupId !=null && oldWOS.UserOrGroupId == oldWorkOrderPropertyAgent.get(oldWOS.ParentId)){
                    FinalOldWOSList.add(oldWOS);
                    
                }
            }
        } 
        
        if(FinalNewWOSList.size()>0){
            insert FinalNewWOSList;
        }
        if(FinalOldWOSList.size()>0){
            delete FinalOldWOSList;
        }  
        
    } 
    
    /******************Invoice Sharing For Property Agent Change on Property Account********************/
    public static void InvoiceSharingHandleOnPropertyAgentChange(List<Account> newlist, Map<Id, Account> oldMap){
        list<Id> ChangedAccId = new list<Id>();
        list<Bread_Winner__Invoice__Share> InvoicetoShareList = new list<Bread_Winner__Invoice__Share>();
        list<Bread_Winner__Invoice__Share> oldInvoiceSharedListtodel = new list<Bread_Winner__Invoice__Share>();
        List<ContentDocumentLink> cdlToInsertList = new List<ContentDocumentLink>();
        Map<Id,Id> orderidToContentDocumentId = new Map<Id,Id>();
        Map<Id,Id>InvidToContentDocumentlinkId = new Map<Id,Id>();
        Map<Id,Id> invoiceToOrderMap = new Map<Id,Id>();
        Map<Id,Id> acctoOldPMAgent = new Map<Id,Id>();
        Map<Id,Id> OldInvoicetoPMAgent = new Map<Id,Id>();
        
        
        for(Account acc: newlist){
            Account oldAccount=oldMap.get(acc.ID);
            if(acc.Property_Office_Agent__c != oldAccount.Property_Office_Agent__c){ 
                ChangedAccId.add(acc.Id);
                if(oldAccount.Property_Office_Agent__c!=null){
                    acctoOldPMAgent.put(acc.Id,oldAccount.Property_Office_Agent__c);
                    
                }
            }  
        }
        
        if(ChangedAccId.size()>0){
            for(Bread_Winner__Invoice__c Inv : [SELECT Id, Order_Lookup__c,Order_Lookup__r.AccountId,Order_Lookup__r.Account.Property_Office_Agent__c FROM Bread_Winner__Invoice__c WHERE Order_Lookup__r.AccountId IN:ChangedAccId ]){
                if(Inv.Order_Lookup__r.Account.Property_Office_Agent__c !=null){
                    Bread_Winner__Invoice__Share ishToInsert = new Bread_Winner__Invoice__Share();
                    ishToInsert.AccessLevel = 'Read';
                    ishToInsert.ParentId = Inv.Id;
                    ishToInsert.UserOrGroupId = Inv.Order_Lookup__r.Account.Property_Office_Agent__c;
                    InvoicetoShareList.add(ishToInsert);
                    invoiceToOrderMap.put(Inv.Order_Lookup__c,Inv.Id);
                } 
                
                Id oldPA= acctoOldPMAgent.get(Inv.Order_Lookup__r.AccountId);
                OldInvoicetoPMAgent.put(Inv.Id,oldPA); 
                
            }
        }
        
        if(!invoiceToOrderMap.isEmpty()){
            
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
        
        
        if(OldInvoicetoPMAgent.keyset().size()>0){
            for (Bread_Winner__Invoice__Share oldInvSh : [select ParentId, UserOrGroupId from Bread_Winner__Invoice__Share where ParentId IN:OldInvoicetoPMAgent.keyset()]){
                if(oldInvSh.UserOrGroupId !=null && oldInvSh.UserOrGroupId == OldInvoicetoPMAgent.get(oldInvSh.ParentId)){
                    oldInvoiceSharedListtodel.add(oldInvSh);
                    
                }
            }
        } 
        
        if(InvoicetoShareList.size()>0){
            insert InvoicetoShareList;
        }
        
        if(cdlToInsertList.size()>0){
            insert cdlToInsertList;
        }
        
        
        if(oldInvoiceSharedListtodel.size()>0){
            delete oldInvoiceSharedListtodel;
        }
        
    }
    /********************create the related contact PM, triggered by "null ➝ value" or "change of value" to an Agent External ID field.**************/
    
    public static void AccountContactRelationshipHandleOnExternalIDChange(List<Account> newlist, Map<Id, Account> oldMap){
        map<id,string> parentacc =new map<id,string>();
        map<id,id> proconidlist= new  map<id,id>();
        list<id> oldpmconid= new list<id>();
        set<id> currentpm= new set<id>();
        list<AccountContactRelation> ACRlisttoinsert = new list<AccountContactRelation>();
        list<AccountContactRelation> ACRcurrentpm = new list<AccountContactRelation>();
        list<AccountContactRelation> ACRlisttoupdate = new list<AccountContactRelation>();
        map<id,string>propertyacctoagentextid= new map<id,string>();
        map<id,id>parentacctopropacc= new map<id,id>();
        map<id,id>acctocon= new map<id,id>();
        map<string,id>conrectoagentextid= new map<string,id>();
        map<id,string>propertyacctoextid= new map<id,string>();
        Database.SaveResult[] srList;
        Id rcId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Property').getRecordTypeId();
        Id contactrcId=Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Agent').getRecordTypeId();
        system.debug(' ******Inside acrupdatemethod******* ');
        try{ 
            for( account acc:newlist){
                account oldAcc=oldMap.get(acc.id);
                if(acc.API_Agent_1_External_ID__c!=null && acc.API_Agent_1_External_ID__c!=oldAcc.API_Agent_1_External_ID__c && acc.RecordTypeId==rcId && acc.Property_Source__c=='Property Me'){
                    // parentacc.put(acc.ParentId,acc.API_Agent_1_External_ID__c);
                    propertyacctoagentextid.put(acc.Id,acc.API_Agent_1_External_ID__c);
                    propertyacctoextid.put(acc.Id,acc.External_ID__c);
                    // parentacctopropacc.put(acc.ParentId,acc.Id);
                }
            }
            
            system.debug('propertyacctoagentextid=='+propertyacctoagentextid);
          
            if(propertyacctoagentextid.keyset().size()>0){
                for(contact con:[ select id,External_ID__c from contact where External_ID__c IN:propertyacctoagentextid.values()]){
                    
                    conrectoagentextid.put(con.External_ID__c,con.id);
                }
                
                system.debug('conrectoagentextid'+conrectoagentextid);
                
                list<account> AccACRlist=new list<account>();
                AccACRlist=[select id,API_Agent_1_External_ID__c,(select id,Roles,contactid,contact.External_ID__c,contact.recordtype.developername from AccountContactRelations where contact.recordtype.developername='Agent') from account where id IN:propertyacctoagentextid.keyset()];
                
                for(account acc :AccACRlist){
                    
                    if(acc.AccountContactRelations.size()>0){
                        Boolean PMfound=false;
                        for(AccountContactRelation Acr : acc.AccountContactRelations){
                           system.debug('newacr');
                             system.debug('startpm value'+PMfound);
                           
                            if(acc.API_Agent_1_External_ID__c != acr.contact.External_ID__c && (acr.Roles=='Property Manager')&& acc.API_Agent_1_External_ID__c !=null ){
                                AccountContactRelation acrtoupdate=new AccountContactRelation();
                                acrtoupdate.Id=acr.Id;
                                acrtoupdate.Roles='Previous PM';
                                ACRlisttoupdate.add(acrtoupdate);
                                 
                            }
                            if(acc.API_Agent_1_External_ID__c == acr.contact.External_ID__c && acc.API_Agent_1_External_ID__c !=null){
                                if(acr.Roles !='Property Manager' || acr.Roles ==null){
                                AccountContactRelation acrtoupdatecurrent=new AccountContactRelation();
                                acrtoupdatecurrent.Id=acr.Id;
                                acrtoupdatecurrent.Roles='Property Manager'; 
                                ACRlisttoupdate.add(acrtoupdatecurrent);
                                 system.debug('b2ndinsidePMfound=='+PMfound);
                                PMfound=true;
                                system.debug('a2ndinsidePMfound=='+PMfound);
                                }
                                 if(acr.Roles =='Property Manager'){
                                PMfound=true;
                                system.debug('4thPMfound=='+PMfound);
                                 }
                            }
                           
                        } 
                            if( PMfound==false && acc.API_Agent_1_External_ID__c !=null && conrectoagentextid.keyset().size()>0){
                                system.debug('3rdPMfound=='+PMfound);
                                string agentextid=propertyacctoagentextid.get(acc.id);
                                id conid=conrectoagentextid.get(agentextid);
                                string propextid=propertyacctoextid.get(acc.id);
                                if(conid!=null){
                                    AccountContactRelation acrnew=new AccountContactRelation();
                                    acrnew.ContactId=conid;
                                    acrnew.IsActive=true;
                                    acrnew.Roles='Property Manager';
                                    acrnew.accountID=acc.id;
                                    acrnew.External_ID__c=agentextid+'#'+propextid;
                                    ACRlisttoinsert.add(acrnew);
                                    system.debug('acrinside'+acrnew);
                                }
                            }
                        
                    }
                    else{
                        if(conrectoagentextid.keyset().size()>0){
                            string agentextid=propertyacctoagentextid.get(acc.id);
                            id conid=conrectoagentextid.get(agentextid);
                            string propextid=propertyacctoextid.get(acc.id);
                            if(conid!=null){
                                AccountContactRelation acrnew=new AccountContactRelation();
                                acrnew.ContactId=conid;
                                acrnew.IsActive=true;
                                acrnew.Roles='Property Manager';
                                acrnew.accountID=acc.id;
                                acrnew.External_ID__c=agentextid+'#'+propextid;
                                ACRlisttoinsert.add(acrnew);
                                system.debug('outsideacr'+acrnew);
                            } 
                        }
                    }
                }
                
            } 
            
 
            system.debug('ACRlisttoinsert'+ACRlisttoinsert);
            if(ACRlisttoinsert.size()>0){
               Database.insert(ACRlisttoinsert, false);
            }
            system.debug('ACRlisttoupdate'+ACRlisttoupdate);
            if(ACRlisttoupdate.size()>0){
                update ACRlisttoupdate;
            }

        }
        catch(Exception ex){
            system.debug('!!!!!Error while processing the request:'+ ex+'!!!!!!');
            List<Error_Log__c> errorLogsList=new List<Error_Log__c>();
            //  Capture Error Log Details
            Error_Log__c errorLog = new Error_Log__c();
            errorLog.Error_Type__c = 'ERROR';
            errorLog.Error_Status_Code__c = '';
            errorLog.Error_Message__c = ex.getMessage();
            errorLog.Error_Description__c = 'Error while processing the request:'+ ex;
            errorLog.Class_Name__c = 'Account Trigger Handler';
            errorLog.Method_Name__c = 'AccountContactRelationshipHandleOnExternalIDChange';
            errorLogsList.add(errorLog); 
            if(errorLogsList.size()>0){
                insert errorLogsList;
            }
        }
    }
    /*************************ACR creation on new property account creation******************************/
    public static void AccountContactRelationshipCreationOnNewPropAccountinsert(List<Account> newlist){
        map<id,string>propertyacctoagentextid= new map<id,string>();
        map<string,id>extidTocon= new map<string,id>();
        map<id,string>propertyacctoextid= new map<id,string>();
        list<AccountContactRelation> ACRlisttoinsert = new list<AccountContactRelation>();
        Id rcpropId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Property').getRecordTypeId();
        
        
        for( account acc:newlist){
            system.debug('11111111111AccountContactRelationshipCreationOnNewPropAccountinsert11111111');
            system.debug('Property_Source__c'+acc.Property_Source__c);
            if(acc.RecordTypeId==rcpropId && acc.API_Agent_1_External_ID__c!=null && acc.Property_Source__c=='Property Me'){
                propertyacctoagentextid.put(acc.id,acc.API_Agent_1_External_ID__c);
                propertyacctoextid.put(acc.Id,acc.External_ID__c);
            }
        }
        
        for(contact con:[ select id,External_ID__c from contact where External_ID__c IN:propertyacctoagentextid.values()]){
            extidTocon.put(con.External_ID__c,con.id);
        }
        
        for(Id accid :propertyacctoagentextid.keyset()){
            string agentextid=propertyacctoagentextid.get(accid);
            id conid=extidTocon.get(agentextid);
            string propextid=propertyacctoextid.get(accid);
              if(conid!=null){
            AccountContactRelation acrnew=new AccountContactRelation();
            acrnew.ContactId=conid;
            acrnew.IsActive=true;
            acrnew.Roles='Property Manager';
            acrnew.accountID=accid;
            acrnew.External_ID__c=agentextid+'#'+propextid;
            ACRlisttoinsert.add(acrnew);
              }
        }
        system.debug('insertacrnewacc'+ACRlisttoinsert);
        if(ACRlisttoinsert.size()>0){
            insert ACRlisttoinsert;
        }
        
        
        
    } 
    
    public static void updateMaintenancePlanfield(List<Account> newlist, Map<Id, Account> oldMap){
        system.debug('instide MP plannnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn');
        list<MaintenancePlan> MPlisttoUpdate= new list<MaintenancePlan>();
        map<id,date> accidstoLastservdate = new map<id,date>();
        String propRTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Property').getRecordTypeId();
        
        for( Account acc :newlist){
            if(acc.Next_Service_Date__c != null && acc.RecordTypeId==propRTypeId){
                if(oldMap==null || acc.Next_Service_Date__c !=oldMap.get(acc.id).Next_Service_Date__c){
                    accidstoLastservdate.put(acc.id,acc.Next_Service_Date__c);
                }
            }
        }
        system.debug('accidstoLastservdate'+accidstoLastservdate);
        if(!accidstoLastservdate.isEmpty()){
            system.debug('checkkkkkk==='+[select id,NextSuggestedMaintenanceDate,AccountId from MaintenancePlan where AccountId IN:accidstoLastservdate.keyset()]);
            for(MaintenancePlan mplist :[select id,NextSuggestedMaintenanceDate,AccountId from MaintenancePlan where AccountId IN:accidstoLastservdate.keyset()]){
                MaintenancePlan mp= new MaintenancePlan();
                mp.id=mplist.id;
                mp.NextSuggestedMaintenanceDate=accidstoLastservdate.get(mplist.AccountId);
                MPlisttoUpdate.add(mp);
            }
        }
        system.debug('mpupdate==='+MPlisttoUpdate);
        if(MPlisttoUpdate.size()>0){
            update MPlisttoUpdate;
        }
        
    }
    
    
}