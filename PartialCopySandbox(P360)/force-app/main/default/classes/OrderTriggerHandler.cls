public class OrderTriggerHandler {
    
    public static void OrderIdaddtoCustomsettingforPMeInvoicepost(list<order> orderlist,map<id,order>ordmap,map<id,order>ordoldmap){
        list<id>orderids = new list<id>();
        list<id>ordidsinCustomSetting = new list<id>();
        list<OrderId_For_PropertyMeBills__c> ordidlistToInsertInCusSet = new list<OrderId_For_PropertyMeBills__c>();
        Map<Id,Agency_Integration_Info__c> aaimap = getAgencyIntegrationRecordlists();  //getting agency integration records
        list<order> orderstoupdate = new list<order>(); 
        for(order od :orderlist){
            if(od.Status=='Send Invoice' && od.PropertyMe_Bills_ID__c == null &&  ordoldmap.get(od.id).status !=od.Status && od.Account_Source__c=='Property Me'){
                orderids.add(od.id);
                
            }
        } //TotalAmount,account.External_ID__c,account.API_Ownership_External_ID__c,Invoice_Due_Date__c
        for(OrderId_For_PropertyMeBills__c opmb : [select name,AccountParentID__c from OrderId_For_PropertyMeBills__c]){
            ordidsinCustomSetting.add(opmb.name);
        }
        
        if(orderids.size()>0){
            SendInvoiceEmail(orderids,ordmap); 
            for( order o :[select id,account.parentid,TotalAmount,account.External_ID__c,account.API_Ownership_External_ID__c,Invoice_Due_Date__c from order where id IN:orderids]){
                if(!ordidsinCustomSetting.contains(o.Id)){
                    // list<Agency_Integration_Info__c> AIIrec =[select id from Agency_Integration_Info__c where Agency_Account__c=:o.account.parentid  limit 1];
                    Agency_Integration_Info__c aairec = aaimap.get(o.Account.parentid);
                    if(aairec!=null && o.TotalAmount!=Null && o.account.External_ID__c!=Null && o.account.API_Ownership_External_ID__c!=Null && o.Invoice_Due_Date__c!=Null  ){
                        OrderId_For_PropertyMeBills__c opm = new OrderId_For_PropertyMeBills__c();
                        opm.name=o.Id;
                        opm.AccountParentID__c=o.account.parentid;
                        ordidlistToInsertInCusSet.add(opm);
                    }
                    else{
                        order ordrec = new order();
                        ordrec.Id=o.Id;
                        if(aairec==null){
                            ordrec.Status='Sent';
                        }
                        else{
                            ordrec.Validation_Error__c=true;  
                        }
                        orderstoupdate.add(ordrec);
                    }
                }   
            }
            
        } 
        system.debug('ordidlistToInsertInCusSet'+ordidlistToInsertInCusSet);
        if(ordidlistToInsertInCusSet.size()>0){
            insert ordidlistToInsertInCusSet;
        }
        system.debug('orderstoupdate'+orderstoupdate);
        if(orderstoupdate.size()>0){
            update orderstoupdate;
        }
        
        
    }
    
    public static void AddingOdrErroredrecordforPost(list<order>Newlist,Map<Id,order> Oldmap ){
        list<id>orderids = new list<id>();
        list<OrderId_For_PropertyMeBills__c> ordidlistToInsertInCusSet = new list<OrderId_For_PropertyMeBills__c>();
        for(order od :Newlist){
            if(od.Validation_Error__c==False &&  Oldmap.get(od.id).Validation_Error__c !=od.Validation_Error__c){
                orderids.add(od.id);             
            }
        }
        if(orderids.size()>0){
            for( order o :[select id,account.parentid,TotalAmount,account.External_ID__c,account.API_Ownership_External_ID__c,Invoice_Due_Date__c from order where id IN:orderids]){
                if(o.account.parentid !=null){
                    OrderId_For_PropertyMeBills__c opm = new OrderId_For_PropertyMeBills__c();
                    opm.name=o.Id;
                    opm.AccountParentID__c=o.account.parentid;
                    ordidlistToInsertInCusSet.add(opm);
                }
                
            }
        }
        
        
        system.debug('ValidationordidlistToInsertInCusSet'+ordidlistToInsertInCusSet);
        if(ordidlistToInsertInCusSet.size()>0){
            insert ordidlistToInsertInCusSet;
        }
        
    }
    
    public static void OrderidtocustomsettingPropertytree(list<order> newlist ,Map<Id,order>oldmap,Map<Id,order>Newmap){
        list<id>orderids = new list<id>();
        list<id>ordidsinCS = new list<id>();
        list<OrderID_For_PropertyTree__c> ordidtoinsCS = new list<OrderID_For_PropertyTree__c>();
        list<order> orderstoupdate = new list<order>(); 
        Map<Id,Agency_Integration_Info__c> aaimap = getAgencyIntegrationRecordlists();  //getting agency integration records
        for(order od : newlist){
            if(od.Status=='Send Invoice' &&  oldmap.get(od.id).status !=od.Status && od.Account_Source__c=='Property Tree'){
                orderids.add(od.id);   
                
            }
        }
        for(OrderID_For_PropertyTree__c opmb : [select Id,name from OrderID_For_PropertyTree__c]){
            ordidsinCS.add(opmb.name);
        }
        
        if(orderids.size()>0){
            SendInvoiceEmail(orderids,Newmap);
            for( order o :[select id,account.parentid,Account.Management_ID__c,ExternalInvoiceId__c,Invoice_Number2__c,TotalAmount,Invoice_Due_Date__c,(select id from OrderItems) from order where id IN:orderids AND account.parentid !=null]){
                if(o.OrderItems.size()>0){
                    Agency_Integration_Info__c aairec = aaimap.get(o.Account.parentid);
                    //list<id> fileids=getCDLIDs(o.id);
                    system.debug('aairec:0'+aairec);
                    if(o.Account.Management_ID__c !=null && o.ExternalInvoiceId__c==null && o.Invoice_Number2__c!=null && o.TotalAmount>0 && o.Invoice_Due_Date__c!=null && aairec !=null && aairec.Platform__c=='PropertyTree' && aairec.Turn_On_Bills_Post__c ==true && !ordidsinCS.contains(o.Id)){
                        OrderID_For_PropertyTree__c opt = new OrderID_For_PropertyTree__c();
                        opt.name=o.id;
                        ordidtoinsCS.add(opt);
                    }
                    else{
                        system.debug('in else' );
                        if(aairec==null || aairec.Turn_On_Bills_Post__c==false){
                            order ordrec = new order();
                            ordrec.Id=o.Id;
                            ordrec.Status='Sent';
                            orderstoupdate.add(ordrec);
                        }
                        if(o.ExternalInvoiceId__c!=null){
                            Newmap.get(o.id).adderror('This order\'s invoice has already been sent to PropertyTree.');
                        }
                        if(o.Invoice_Number2__c==null){
                            Newmap.get(o.id).adderror('Invoice Number field is blank.');
                        }
                        if(o.TotalAmount==null || o.TotalAmount<=0){
                            Newmap.get(o.id).adderror('Order Amount field is blank or equals to \'0\'.');
                        }
                        if(o.Invoice_Due_Date__c==null){
                            Newmap.get(o.id).adderror('Invoice Due Date field is blank.');
                        }
                        if(o.Account.Management_ID__c==null){
                            Newmap.get(o.id).adderror('The related Account\'s Management ID is blank.');
                        }
                    }
                }
                else{
                    Newmap.get(o.id).adderror('please Add order product to this order before sending invoice');
                }
            }
        }
        if(ordidtoinsCS.size()>0){
            insert ordidtoinsCS;
        }
        
        if(orderstoupdate.size()>0){
            update orderstoupdate;
        }
        
        
    }
    
    public static void SendInvoiceEmail(list<Id>ordids,map<id,order>ordmap){
        system.debug('here in SendInvoiceEmail');
        List<Messaging.SingleEmailMessage> mails = new list<Messaging.SingleEmailMessage>();
        id templateid;
        OrgWideEmailAddress[] owea = [select Id,Address, DisplayName from OrgWideEmailAddress  where address='workorders@propertyservices360.com.au'];
        for(Order ord : [Select Id, account.Prop_Invoice_Recipent_Email__c,account.Prop_Invoice_Recipient_Email_2__c,Opportunity.recordtype.developername from order where id IN:ordids]){
            list<id> fileid=getCDLIDs(ord.id);
            if((fileid.size()>0) && (ord.Opportunity.recordtype.developername=='Ad_Hoc' ||ord.Opportunity.recordtype.developername=='Renewal' || ord.Opportunity.recordtype.developername=='Subscription' || ord.Opportunity.recordtype.developername=='Upgrade')){
                if(ord.Opportunity.recordtype.developername=='Ad_Hoc' || ord.Opportunity.recordtype.developername=='Upgrade'){
                    templateid = string.valueof(System.Label.Ad_Hoc_Opportunity_Email_TemplateID);
                }
                if(ord.Opportunity.recordtype.developername=='Renewal' || ord.Opportunity.recordtype.developername=='Subscription'){
                    templateid = string.valueof(System.Label.Subscription_Or_Renewal_Opportunity_Email_TemplateID);
                }
                system.debug('templateid'+templateid);
                if(ord.account.Prop_Invoice_Recipent_Email__c!=null){
                    list<Contact> conid= [select id from contact where email=:ord.account.Prop_Invoice_Recipent_Email__c limit 1];
                    if(conid.size()>0){
                        list<String> toaddress = new list<String>();
                        toaddress.add(ord.account.Prop_Invoice_Recipent_Email__c);
                        Messaging.SingleEmailMessage  msg = new Messaging.SingleEmailMessage();  
                        msg.setEntityAttachments(fileid);
                        msg.setToAddresses(toaddress);
                        msg.setTargetObjectId(conid[0].id);
                        msg.setTemplateId(templateid);
                        msg.setWhatId(ord.Id);
                        msg.setOrgWideEmailAddressId(owea[0].id);
                        msg.setSaveAsActivity(True);
                        mails.add(msg);
                    }
                }
                if(ord.account.Prop_Invoice_Recipient_Email_2__c!=null){
                    list<Contact> conid=[select id from contact where email=:ord.account.Prop_Invoice_Recipient_Email_2__c limit 1];
                    if(conid.size()>0){
                        list<String> toaddress = new list<String>();
                        toaddress.add(ord.account.Prop_Invoice_Recipient_Email_2__c);
                        Messaging.SingleEmailMessage  msg = new Messaging.SingleEmailMessage();  
                        msg.setEntityAttachments(fileid);
                        msg.setToAddresses(toaddress);
                        msg.setTargetObjectId(conid[0].id);
                        msg.setTemplateId(templateid);
                        msg.setWhatId(ord.Id);
                        msg.setOrgWideEmailAddressId(owea[0].id);
                        msg.setSaveAsActivity(True);
                        mails.add(msg);
                    }
                }
            }
            else{
                order ordrec = ordmap.get(ord.id);
                if(ordrec != null ){
                    if(fileid.isempty()){
                        ordrec.addError('Please generate the Invoice pdf for sending email and Invoice ');
                    }
                    else{
                        ordrec.addError('Oppotunity should be ADHOC/renewal/subscription/upgrade type');
                    }
                }
            }
        }
        system.debug('invmails'+mails);
        if(mails.size()>0){
            messaging.sendEmail(mails);
        } 
        
    }
    
    public static list<id> getCDLIDs(id ordid){
        list<id> CD_Ids = new list<id>();
        list<id> CV_Ids = new list<id>();
        for(ContentDocumentLink cd :[SELECT ContentDocumentId, Id, LinkedEntityId, ShareType FROM ContentDocumentLink WHERE LinkedEntityId=:ordid]){
            CD_Ids.add(cd.ContentDocumentId);
        }
        if(CD_Ids.size()>0){
            for(ContentVersion cv :[SELECT Id,VersionData,FileType from ContentVersion where ContentDocumentid IN:CD_Ids ] ){
                if(test.isRunningTest()){CV_Ids.add(cv.id);}
                if(cv.FileType =='PDF'){
                    CV_Ids.add(cv.id);
                }
            }  
        }
        system.debug('CV_Ids'+CV_Ids);
        return CV_Ids;
    }
    
    
    Public static Map<Id,Agency_Integration_Info__c> getAgencyIntegrationRecordlists(){
        Map<Id,Agency_Integration_Info__c> agnaccidtoAIIrec = new Map<Id,Agency_Integration_Info__c>();
        for( Agency_Integration_Info__c aai : [select id,Agency_Account__c,Platform__c,Turn_On_Bills_Post__c  from Agency_Integration_Info__c where Platform__c='PropertyTree']){
            agnaccidtoAIIrec.put(aai.Agency_Account__c,aai);
        }
        
        return agnaccidtoAIIrec;
    }
    
    
}