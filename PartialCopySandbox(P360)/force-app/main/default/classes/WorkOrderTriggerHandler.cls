public class WorkOrderTriggerHandler {
    public static void beforeUpdate(){
        List<WorkOrder> woerrList=new List<WorkOrder>();
        Map<Id,WorkOrder> woIdMap = new Map<Id,WorkOrder>();
        for(WorkOrder wkor : (List<WorkOrder>) Trigger.new){  
            WorkOrder oldwrkorder = (WorkOrder) Trigger.oldMap.get(wkor.Id);
            if(wkor.Status != oldwrkorder.Status  && wkor.Status.equalsIgnoreCase('Canceled')){  
                woIdMap.put(wkor.Id,wkor);
            }
        }
        if(!woIdMap.isEmpty()) {
            Map<Id, WorkOrder> workOrderIdToRecMap = new Map<Id, WorkOrder>([Select Id,Status, (Select Id,FSSK__FSK_Work_Order__c,Status from ServiceAppointments WHERE Status IN ('None', 'Scheduled', 'Dispatched', 'En Route', 'Waiting to start', 'In Progress', 'Completed') LIMIT 1) From WorkOrder where id in: woIdMap.keySet()]);
            for(WorkOrder wkor : (List<WorkOrder>) Trigger.new){  
                if(workOrderIdToRecMap.containsKey(wkor.Id) && !workOrderIdToRecMap.get(wkor.Id).ServiceAppointments.isEmpty()) {
                    wkor.addError(Label.ServiceAppointmentError);
                }      
            }
        }
    }
    
    public static void WorkorderSharingToPowerUserOnInsert(map<id,workorder> newmap){
        list<Workordershare> WorkOrderToShare =new list<Workordershare>();
        system.debug('newmap'+newmap);
        for( WorkOrder WO : [Select Id, AccountId,Account.parentid,Account.parent.name,Account.parent.Power_User__c from WorkOrder where id IN:newmap.keyset()]){
            system.debug('WO.Account.parent.Power_User__c='+WO.Account.parent.Power_User__c);
            if(WO.Account.parent.Power_User__c !=null){
                WorkOrderShare NewWOS = new WorkOrderShare();
                NewWOS.ParentId = WO.Id;
                NewWOS.UserOrGroupId = WO.Account.parent.Power_User__c;
                NewWOS.AccessLevel = 'Edit';
                WorkOrderToShare.add(NewWOS);
            }
        }
        system.debug('newWorkOrderToShare'+WorkOrderToShare);
        if(WorkOrderToShare.size()>0){
            insert WorkOrderToShare ;
        }
    }
    
    public static void UpdateFastFieldIdOfInsertedWO(Map<Id,WorkOrder> newMap) {
        Map<Id,WorkOrder> WorkOrdersMap = new Map<Id,WorkOrder>(
        [SELECT Id,FastFieldId__c FROM WorkOrder WHERE Id IN: newMap.KeySet()]);
            for(WorkOrder WOForUpdateFastFieldId: WorkOrdersMap.values()){
                if(WOForUpdateFastFieldId.FastFieldId__c == NULL){
                    WOForUpdateFastFieldId.FastFieldId__c = WOForUpdateFastFieldId.Id;
                } 
            }
        update WorkOrdersMap.values();
    }
    
    public static void WorkOrderIdaddtoCustomsettingforPMe(list<workorder> Workorderlist,Map<Id,workorder> newmap,Map<Id,workorder> oldlist ){
        
        list<WorkOrderId__c> woidlist = new list<WorkOrderId__c>();
        list<Id> targetedwoids = new list<Id>();
        list<Id> woidinCSet = new list<Id>();
        list<WorkOrder> Wotoupdate = New list<WorkOrder>();
        Manage_Triggers__c triggerCustomSetting = Manage_Triggers__c.getValues('WorkOrderTrigger');
        if (triggerCustomSetting.isActive__c) {
            for( workorder newwo : Workorderlist){
                if(newwo.status == 'Send Certificate' && newwo.Job_Task_Id__c== null && oldlist.get(newwo.Id).status != newwo.status && newwo.Account_Source__c=='Property Me'){
                    targetedwoids.add( newwo.id);
                   SendComplianceCertEmail(newwo.id,newmap);
                }
            }
            
            for(WorkOrderId__c woid : [select name,AccountParentID__c from WorkOrderId__c]){
                woidinCSet.add(woid.name);
            }
            
            if(targetedwoids.size()>0){
                
                for( WorkOrder wo : [Select Id, AccountId,Account.parentid,Account.External_ID__c from WorkOrder where id IN:targetedwoids]){
                     if((!woidinCSet.contains(wo.Id))){
					list<Agency_Integration_Info__c> AIIrec =[select id from Agency_Integration_Info__c where Agency_Account__c=:wo.account.parentid  limit 1];
                    system.debug('Account.External_ID__c'+wo.Account.External_ID__c);
                        if(AIIrec.size() >0 && wo.Account.External_ID__c !=null){
                            WorkOrderId__c woid= new WorkOrderId__c();
                            woid.Name=wo.id;
                            woid.AccountParentID__c=wo.Account.parentid;
                            woidlist.add(woid);
                        }
                        else{
                            workorder worec = new workorder();
                            worec.id=wo.id;
                            if(AIIrec.isempty()){
                            worec.Status='Closed';
                            }
                            else{worec.Validation_Error__c=true;}
                            Wotoupdate.add(worec);
                            
                        }
               	 	 }
                }
            }
            system.debug('woidlist'+woidlist);
            if(woidlist.size()>0){
                insert woidlist ;
            } 
            system.debug('Wotoupdate'+Wotoupdate);
            if(Wotoupdate.size()>0){
                update Wotoupdate;
            }
        }  
    }
    
    
    public static void SendComplianceCertEmail(Id reqwoids,Map<Id,workorder> newmap){
        system.debug('here in SendComplianceCertEmail');
        List<Messaging.SingleEmailMessage> mails = new list<Messaging.SingleEmailMessage>();
        OrgWideEmailAddress[] owea = [select Id,Address, DisplayName from OrgWideEmailAddress  where address='workorders@propertyservices360.com.au'];
        for(WorkOrder wo : [Select Id, Compliance_Email_1__c,Compliance_Email_2__c,city,country,street,account.parentid from WorkOrder where id=:reqwoids]){
            list<id> fileids=getCDLIDs(wo.id); 
            if(fileids.size()>0){
                if(wo.Compliance_Email_1__c!=null){
                    list<String> toaddress = new list<String>();
                    toaddress.add(wo.Compliance_Email_1__c);
                    id conid=[select id from contact where email=:wo.Compliance_Email_1__c limit 1].id;
                    Messaging.SingleEmailMessage  msg = new Messaging.SingleEmailMessage();  
                    msg.setEntityAttachments(fileids);
                    msg.setToAddresses(toaddress);
                    msg.setTargetObjectId(conid);
                    msg.setTemplateId('00X5g000000lklgEAA');
                    msg.setWhatId(wo.Id);
                    msg.setOrgWideEmailAddressId(owea[0].id);
                    msg.setSaveAsActivity(True);
                    mails.add(msg);
                }
                if(wo.Compliance_Email_2__c!=null){
                    list<String> toaddress = new list<String>();
                    toaddress.add(wo.Compliance_Email_2__c);
                    
                    /*   string woAddress='' ;
if(wo.street!=null){
woAddress= wo.street +', ';
}
if(wo.city!=null){
woAddress= woAddress+wo.city ;
}
if(wo.country!=null){
woAddress= woAddress+ wo.country;
}*/
                    
                    id conid=[select id from contact where email=:wo.Compliance_Email_2__c limit 1].id;
                    // string body='Hi Accounts,\n\n  <br/><br/> Please find attached a copy of your Property Services 360 Compliance Report in regards to'+'  '+ woAddress+'.\n\n<br/><br/> If you have any queries or are unable to open the certificate, please contact us on 1300 685 322.\n\n <br/><br/>Thank you';
                    // EmailTemplate emailTemplate =[Select Id,Subject,Description, HtmlValue,DeveloperName,Body from EmailTemplate where id ='00X5g000000lklgEAA' ]; 
                    Messaging.SingleEmailMessage  msg = new Messaging.SingleEmailMessage();  
                    msg.setEntityAttachments(fileids);
                    msg.setToAddresses(toaddress);
                    msg.setTargetObjectId(conid);
                    msg.setTemplateId('00X5g000000lklgEAA');
                    msg.setWhatId(wo.Id);
                    // msg.setSubject('Compliance certificate attached for '+woAddress);
                    //msg.setHtmlBody(body);
                    msg.setOrgWideEmailAddressId(owea[0].id);
                    msg.setSaveAsActivity(True);
                    mails.add(msg);
                    system.debug('email'+msg); 
                }
            }
            else{
                workorder woer =newmap.get(wo.Id);
                if(woer != null){
                    woer.addError('Please Add files for sending email and Compliance certificate ');
                }
            }
        }
        system.debug('mails'+mails);
        if(mails.size()>0){
            messaging.sendEmail(mails);
        } 
        
    }
    
    public static list<id> getCDLIDs(id woid){
        list<id> CD_Ids = new list<id>();
        list<id> CV_Ids = new list<id>();
        for(ContentDocumentLink cd :[SELECT ContentDocumentId, Id, LinkedEntityId, ShareType FROM ContentDocumentLink WHERE LinkedEntityId=:woid]){
            CD_Ids.add(cd.ContentDocumentId);
        }
        if(CD_Ids.size()>0){
            for(ContentVersion cv :[SELECT Id,VersionData,FileType from ContentVersion where FileType='PDF' AND ContentDocumentid IN:CD_Ids ] ){
                CV_Ids.add(cv.id);
            }  
        }
        system.debug('CV_Ids'+CV_Ids);
        return CV_Ids;
    }
    
    public static void AddingErroredrecordforPost(list<workorder>Newlist,Map<Id,workorder> Oldmap ){
        list<WorkOrderId__c> Customsettingrectoinsert = new list<WorkOrderId__c>();
        list<Id> targetedwoids = new list<Id>();
        for(workorder newwo :  Newlist){
            workorder oldwo=Oldmap.get(newwo.Id);
            if(newwo.Validation_Error__c ==False && newwo.Validation_Error__c!=oldwo.Validation_Error__c ){
                targetedwoids.add(newwo.Id);
            }
        }
        
        if(targetedwoids.size()>0){
            
            for( WorkOrder wo : [Select Id, AccountId,Account.parentid,Account.External_ID__c from WorkOrder where id IN:targetedwoids]){
                if(wo.Account.parentid !=null){
                    WorkOrderId__c woid= new WorkOrderId__c();
                    woid.Name=wo.id;
                    woid.AccountParentID__c=wo.Account.parentid;
                    Customsettingrectoinsert.add(woid);
                }
            }
        }
        
        system.debug('Customsettingrectoinsert'+Customsettingrectoinsert);
        if(Customsettingrectoinsert.size()>0){
            insert Customsettingrectoinsert ;
        } 
        
    }
    
    Public static void WorkorderidtocustomsettingPropertyTree(list<workorder> Updatewolist, Map<Id,workorder> Oldmap){
        Set<Id> trgetedwoid = new Set<Id>();
        Set<Id> woidincs = new Set<Id>();
        list<WorkOrderID_For_PropertyTree__c> CSsetrectoins = new list<WorkOrderID_For_PropertyTree__c>();
        Map<Id,Agency_Integration_Info__c> aaimap = getAgencyIntegrationRecordlists();  //getting agency integration records
        Manage_Triggers__c triggerCustomSetting = Manage_Triggers__c.getValues('WorkOrderTrigger');
        if(triggerCustomSetting.isActive__c){
            
            for(workorder wo : Updatewolist){
                if(wo.status == 'Send Certificate' && Oldmap.get(wo.Id).status != wo.status && wo.Account_Source__c=='Property Tree'){
                  trgetedwoid.add(wo.Id); 
                }
            }
            
             for(WorkOrderID_For_PropertyTree__c woid : [select name from WorkOrderID_For_PropertyTree__c]){
                woidincs.add(woid.name);
            }
            
            if(trgetedwoid.Size()>0){
                for(Workorder wotoinsert : [Select Id, AccountId,Account.parentid,Account.Management_ID__c from WorkOrder where id IN:trgetedwoid]){
                    Agency_Integration_Info__c aairec = aaimap.get(wotoinsert.Account.parentid);
                    list<id> fileids=getCDLIDs(wotoinsert.id); 
                    if(wotoinsert.Account.Management_ID__c !=null && aairec !=null && fileids.size()>0 && aairec.Platform__c=='PropertyTree' && aairec.Turn_On_Compliance_Post__c ==true && !woidincs.contains(wotoinsert.id)){
                        WorkOrderID_For_PropertyTree__c newcs = new WorkOrderID_For_PropertyTree__c();
                        newcs.name= wotoinsert.Id;
                        CSsetrectoins.add(newcs);
                    }
                }
            }
            if(CSsetrectoins.size()>0){
                insert CSsetrectoins;
            }
            
        }
        
    }
 
    
    Public static Map<Id,Agency_Integration_Info__c> getAgencyIntegrationRecordlists(){
        Map<Id,Agency_Integration_Info__c> agnaccidtoAIIrec = new Map<Id,Agency_Integration_Info__c>();
        for( Agency_Integration_Info__c aai : [select id,Agency_Account__c,Platform__c,Turn_On_Compliance_Post__c  from Agency_Integration_Info__c]){
            agnaccidtoAIIrec.put(aai.Agency_Account__c,aai);
        }
        
      return agnaccidtoAIIrec;
    }
    
}