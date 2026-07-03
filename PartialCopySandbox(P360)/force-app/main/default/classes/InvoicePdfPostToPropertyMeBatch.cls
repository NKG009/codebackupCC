/*
***********************************************************************************
Apex Class Name    : InvoicePdfPostToPropertyMeBatch
Created Date       : May 29, 2023
@description       : This Batch class is used for Sending Bills to Propertyme Api 
@author            : Nikhil Gaurav
Modification Log:
Ver   Date         Author                     Modification
1.0   29-05-2023   Nikhil Gaurav            Initial Version
*************************************************************************************
*/

global class InvoicePdfPostToPropertyMeBatch implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful {
    global id accparentid;
    
    global InvoicePdfPostToPropertyMeBatch(id parentid){
        this.accparentid=parentid;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        string query='select name,AccountParentID__c from OrderId_For_PropertyMeBills__c where AccountParentID__c=:accparentid';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, list<OrderId_For_PropertyMeBills__c> AllOrderIds ){
        
        system.debug('AllOrderIds'+AllOrderIds);
        for(OrderId_For_PropertyMeBills__c OPMB : AllOrderIds){
           try{ 
            list<Agency_Integration_Info__c> AIIrec =[select id,Agency_Account__c,Access_Token__c,Client_ID__c,Client_Secret__c,Refresh_Token__c,Turn_On_Bills_Post__c,FromFolioID__c,Chart_Account_ID__c from Agency_Integration_Info__c where Agency_Account__c=:accparentid limit 1];

            if(AIIrec[0].Turn_On_Bills_Post__c){
            order od=[select Id,TotalAmount,Invoice_Number2__c,Error_On_API_Request__c,account.External_ID__c,account.API_Ownership_External_ID__c,Invoice_Due_Date__c,PropertyMe_Bills_ID__c from order where id=:OPMB.Name limit 1];
            string fileVdata=''; 
            string filename='';
            Agency_Account_Integration_Info__mdt [] aaii =[select MasterLabel,Bills_Url__c from Agency_Account_Integration_Info__mdt limit 1];
            
            
            for(ContentDocumentLink cdlist:[SELECT ContentDocumentId, Id, LinkedEntityId, ShareType FROM ContentDocumentLink WHERE LinkedEntityId=:OPMB.Name]){
                list<ContentVersion> file = [SELECT Id,VersionData,FileType from ContentVersion where FileType='PDF' AND ContentDocumentid=:cdlist.ContentDocumentId limit 1];                        
                if(file.size()>0){
                    fileVdata=EncodingUtil.base64Encode(file[0].VersionData); //base64 encoded
                    filename = [SELECT Id, title FROM ContentDocument where id=:cdlist.ContentDocumentId limit 1].title;
                    if(!filename.contains('pdf')){
                    filename=filename+'.pdf';
                    }
                }
            }
            date ddate=od.Invoice_Due_Date__c;
            string duedate=ddate.year()+ '-' + ddate.month() + '-' + ddate.day();
            string amt=string.valueOf(od.TotalAmount);
             system.debug('duedate->'+duedate);
             system.debug('FromFolioId='+AIIrec[0].FromFolioID__c);
                system.debug('ToFolioId='+od.account.External_ID__c);
                system.debug('ChartAccountId='+AIIrec[0].Chart_Account_ID__c);
                system.debug('OwnershipId='+ od.account.API_Ownership_External_ID__c);
                system.debug('Reference='+ od.Invoice_Number2__c);
                system.debug('amt='+amt);
                system.debug('filename='+filename);
                
         /*************************Creating form data from the pdf**************************/                
            Blob formData = HttpHexFormBuilder.build()
                .writeParam('DueDate',duedate)
                .writeParam('FromFolioId',AIIrec[0].FromFolioID__c)
                .writeParam('ToFolioId', od.account.External_ID__c)
                .writeParam('ChartAccountId',AIIrec[0].Chart_Account_ID__c)
                .writeParam('OwnershipId', od.account.API_Ownership_External_ID__c)
                .writeParam('Priority', 'Normal')
                .writeParam('Reference', od.Invoice_Number2__c)
                .writeParam('Detail', 'Rental Property Compliance')
                .writeParam('Amount', amt)
                .writeParam('IsTaxed', 'True')
                .writeParam('IsApproved', 'False')
                .writeFile('name', fileName, fileVdata)
                .getFormAsBlob();
                
                system.debug('formData'+formData);
            
            HttpRequest request = new HttpRequest();
            request.setEndpoint(aaii[0].Bills_Url__c);
            request.setHeader('Authorization' , 'Bearer '+AIIrec[0].Access_Token__c);             
            request.setHeader( 'Content-Length', String.valueOf(formData.size()));
            request.setHeader( 'Content-Type', HttpHexFormBuilder.GetContentType());
            request.setHeader('Accept' , 'application/json');
            request.setMethod('POST');
            request.setTimeout(120000);   
            request.setBodyAsBlob(formData);
            Http http = new Http();  
            HttpResponse respose = http.send(request);
            if(respose.getStatusCode() == 200) {
                system.debug('docposting'+respose.getBody());
                Map<String, Object> response_Map = (Map<String, Object>)JSON.deserializeUntyped(respose.getBody());
               list<Object> BillsTrackingid = (list<Object>)response_Map.get('TrackingIds');
                system.debug('BillsTrackingid'+BillsTrackingid[0]);
                
                order updateord = new order();
                updateord.id=od.Id;
                updateord.Status='Sent';
                updateord.PropertyMe_Bills_ID__c=string.valueOf(BillsTrackingid[0]);
                update updateord;
                
                OrderId_For_PropertyMeBills__c csoid=[select name,AccountParentID__c from OrderId_For_PropertyMeBills__c where name=:OPMB.Name limit 1];
                delete csoid;
            } 
                
            } 
               else{
                   system.debug('elsepart');
                   order updateord = new order();
                   updateord.id=OPMB.name;
                   updateord.Status='Sent';
                   updateord.Error_On_API_Request__c=false;
                   update updateord;
                   
                   delete OPMB;
                   
               }
               
           }
            // Error logging
            catch(Exception ex){
                Error_Log__c errorLog = new Error_Log__c();
                errorLog.Order__c=OPMB.name;
                errorLog.Error_Type__c = 'ERROR';
                errorLog.Error_Status_Code__c = '';
                errorLog.Error_Message__c = ex.getMessage();
                errorLog.Error_Description__c = 'Error while processing the request:'+ ex +ex.getMessage() +' at line ' +ex.getLineNumber() + ' '+ ex.getStackTraceString();
                errorLog.Class_Name__c = 'InvoicePdfPostToPropertyMeBatch';
                errorLog.Method_Name__c = 'InvoicePdfPostToPropertyMeBatch.execute(method)';
                insert errorLog;
                
                order errorderupd = new order();
                errorderupd.id=OPMB.name;
                errorderupd.Error_On_API_Request__c=True;
                update errorderupd;
                
                delete OPMB;
          }    
    }
    }
    global void finish(Database.BatchableContext BC){  
        
    }
    
}