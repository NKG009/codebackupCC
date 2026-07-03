/*
***********************************************************************************
Apex Class Name    : PropertyTreeInvoicePostBatch
Created Date       : Nov 02,2023
@description       : This Batch class is used for Sending Bills to Property Tree API 
processes 1 record at a time i.e batch size is 1.
@author            : Nikhil Gaurav
Modification Log:
Ver   Date         Author                     Modification
1.0   02-11-2023   Nikhil Gaurav            Initial Version
*************************************************************************************
*/
public class PropertyTreeInvoicePostBatch implements Database.Batchable<sObject>,Database.AllowsCallouts {
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        string query='select Id,name from OrderID_For_PropertyTree__c';
        return Database.getQueryLocator(query);
        
    }
    public void execute(Database.BatchableContext bc,list<OrderID_For_PropertyTree__c> OrderIdlist ){
        List<ContentVersion> CVlisttoupdate = new List<ContentVersion>();
        List<Error_Log__c> errorloglist = new List<Error_Log__c>(); 
        for(OrderID_For_PropertyTree__c OPT :OrderIdlist){
            try{
                order ord=[select Id,Status,TotalAmount,Invoice_Number2__c,GST_Component__c,Invoice_Due_Date__c,Account.parentid,ExternalInvoiceId__c,Account.Management_ID__c,Account.parent.ExternalIdEncrypted__c,Error_On_API_Request__c from order where id=:OPT.Name limit 1];
                list<Agency_Integration_Info__c> AIIrec =[select id,Platform__c,Agency_Account__c,Turn_On_Bills_Post__c,CreditorId__c,InvoiceAccountId__c,CreditorInvoiceEndpoint__c,AddDocumentEndpoint__c from Agency_Integration_Info__c where Agency_Account__c=:ord.Account.parentid AND Platform__c='PropertyTree'AND Turn_On_Bills_Post__c=true limit 1];
                list<ContentVersion> Ordcvlist=getOrderCDLIDs(ord.id);
                if(AIIrec.size()>0 && Ordcvlist.size()>0 &&  ord.Error_On_API_Request__c==false) {
                    // invoice creation request
                    date ddate=ord.Invoice_Due_Date__c;
                    string duedate=ddate.day()+ '/' + ddate.month() + '/' + ddate.year();
                    string Invreqbdy='{"account_id":"'+AIIrec[0].InvoiceAccountId__c+'","creditor_id": "'+AIIrec[0].CreditorId__c+'","management_id":"'+ord.Account.Management_ID__c+'","description": "Rental Property Compliance","creditor_reference":"'+ord.Invoice_Number2__c+'","amount":'+ord.TotalAmount+',"sales_tax":'+ord.GST_Component__c+',"due_date":"'+ord.Invoice_Due_Date__c+'","is_priority": false}';
                    system.debug('Invreqbdy'+Invreqbdy);
                    
                    Http http = new Http();
                    HttpRequest httpReq1 = new HttpRequest();
                    httpReq1.setMethod('POST');
                    httpReq1.setEndPoint(AIIrec[0].CreditorInvoiceEndpoint__c);
                    httpReq1.setHeader('Authorization' , 'Bearer '+ord.Account.parent.ExternalIdEncrypted__c);
                    httpReq1.setHeader('Content-Type','application/json');
                    httpReq1.setHeader('Accept' , 'application/json; charset=utf-8');
                    httpReq1.setbody(Invreqbdy);
                    httpReq1.setTimeout(120000);
                    HttpResponse httpRes1 = http.send(httpReq1);
                    system.debug('comp post body:'+httpRes1.getbody());
                    if(httpRes1.getStatusCode() == 200 || httpRes1.getStatusCode() == 201){ 
                        // response further processing
                        Map<string,object> Resbody= (Map<string,object>) JSON.deserializeUntyped(httpRes1.getbody());
                        system.debug('Resbody:'+Resbody);
                        ord.ExternalInvoiceId__c=string.valueof(Resbody.get('invoice_id'));
                        
                        // Documentposting to the invoice
                        for(contentversion Ordcv : Ordcvlist){
                            String boundary = '----------------------------741e90d31eff';
                            Blob bodyBlob=createformdataforpostingpdf(Ordcv);
                            Http http2 = new Http();
                            HttpRequest httpReq2 = new HttpRequest();
                            httpReq2.setMethod('POST');
                            httpReq2.setEndPoint(AIIrec[0].AddDocumentEndpoint__c+'/Invoice/'+ord.ExternalInvoiceId__c);
                            httpReq2.setHeader('Authorization' , 'Bearer '+ord.Account.parent.ExternalIdEncrypted__c);
                            httpReq2.setHeader('Content-Type','multipart/form-data; boundary='+boundary);            
                            httpReq2.setHeader('Accept' , 'application/json; charset=utf-8');
                            httpReq2.setBodyAsBlob(bodyBlob);
                            httpReq2.setTimeout(120000);
                            HttpResponse httpRes2 = http2.send(httpReq2);
                            system.debug('Doc post respbody:'+httpRes2.getbody());
                            if(httpRes2.getStatusCode() == 200 || httpRes2.getStatusCode() == 201){
                                Map<string,object> Docresbody= (Map<string,object>) JSON.deserializeUntyped(httpRes2.getbody());
                                ContentVersion cvrec = new ContentVersion();
                                cvrec.Id=Ordcv.Id;
                                cvrec.PropertyTreeDocumentID__c =string.valueof(Docresbody.get('document_id'));
                                CVlisttoupdate.add(cvrec);
                                
                            }
                            else{
                                // create error log on bad request document posting
                                Error_Log__c errorLog = new Error_Log__c();
                                errorLog.Order__c=ord.id;
                                errorLog.Error_Type__c = 'ERROR';
                                errorLog.Error_Status_Code__c = string.valueof(httpRes2.getStatusCode());
                                errorLog.Error_Message__c =  httpRes2.getStatus()+'On Document Posting ';
                                errorLog.Error_Description__c = 'Error while processing the API request:'+httpRes2.getbody();
                                errorLog.Class_Name__c = 'PropertyTreeInvoicePostBatch';
                                errorLog.Method_Name__c = 'PropertyTreeInvoicePostBatch.execute() ';
                                errorloglist.add(errorLog);
                            }
                        }
                    }
                    else{
                         // create error log on bad request for Invoice creation
                                Error_Log__c errorLog = new Error_Log__c();
                                errorLog.Order__c=ord.id;
                                errorLog.Error_Type__c = 'ERROR';
                                errorLog.Error_Status_Code__c = string.valueof(httpRes1.getStatusCode());
                                errorLog.Error_Message__c =  httpRes1.getStatus()+' On Invoice Creation';
                                errorLog.Error_Description__c = 'Error while processing the API request:'+httpRes1.getbody();
                                errorLog.Class_Name__c = 'PropertyTreeInvoicePostBatch';
                                errorLog.Method_Name__c = 'PropertyTreeInvoicePostBatch.execute()';
                                errorloglist.add(errorLog);
                        
                    }
                    system.debug('ord:'+ord);
                    system.debug('CVlisttoupdate:'+CVlisttoupdate);
                    system.debug('errorloglist:'+errorloglist);
                    if(CVlisttoupdate.size()>0){
                        update CVlisttoupdate;
                    }
                    if(errorloglist.size()>0){
                        ord.Error_On_API_Request__c=true;
                        insert errorloglist;
                    }
                    ord.Status='Sent';
                    update ord;
                    delete OPT;
                }
            }
            catch(exception ex){
                 //error logging
                Error_Log__c errorLog = new Error_Log__c();
                errorLog.Order__c=OPT.name;
                errorLog.Error_Type__c = 'ERROR';
                errorLog.Error_Status_Code__c = '';
                errorLog.Error_Message__c = ex.getMessage();
                errorLog.Error_Description__c = 'Error while processing the request:'+  ex + ex.getMessage() +' at line ' +ex.getLineNumber() + ' '+ ex.getStackTraceString();
                errorLog.Class_Name__c = 'PropertyTreeInvoicePostBatch';
                errorLog.Method_Name__c = 'PropertyTreeInvoicePostBatch.execute()';
                insert errorLog;
                
                // marking work order record with error api request
                order o = new order();
                o.Id=OPT.name;
                o.Error_On_API_Request__c=true;
                update o;
                // removing id from custom setting   
                delete OPT;
                
            }
        }
    }
    
    public void finish(Database.BatchableContext bc){
        
    }
    public static list<ContentVersion> getOrderCDLIDs(id ordid){
        list<id> CD_Ids = new list<id>();
        list<id> CV_Ids = new list<id>();
        list<ContentVersion> CVlist = New list<ContentVersion>();
        for(ContentDocumentLink cd :[SELECT ContentDocumentId, Id, LinkedEntityId, ShareType FROM ContentDocumentLink WHERE LinkedEntityId=:ordid]){
            CD_Ids.add(cd.ContentDocumentId);
        }
        if(CD_Ids.size()>0){
            for(ContentVersion cv :[SELECT Id,VersionData,FileType,Category__c,title from ContentVersion where FileType='PDF' AND ContentDocumentid IN:CD_Ids ] ){
                CVlist.add(cv);
            }  
        }
        system.debug('CVlist'+CVlist);
        return CVlist;
    }
    public static blob createformdataforpostingpdf(contentversion cv){
        system.debug('cv.title'+cv.title);
        String boundary = '----------------------------741e90d31eff';
        String header = '--'+boundary+'\r\nContent-Disposition: form-data; name="file"; filename="'+cv.title+'.pdf"\r\nContent-Type:application/json; charset=utf-8'; // added '\r's removed ';' see Tim Smith's comment
        String footer = '\r\n--'+boundary+'--';              
        String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
        while(headerEncoded.endsWith('='))
        {
            header+=' ';
            headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
        }
        String bodyEncoded = EncodingUtil.base64Encode(cv.VersionData);
        String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
        
        Blob bodyBlob = null;
        String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());
        if(last4Bytes.endsWith('='))
        {
            Blob decoded4Bytes = EncodingUtil.base64Decode(last4Bytes);
            HttpRequest tmp = new HttpRequest();
            tmp.setBodyAsBlob(decoded4Bytes);
            String last4BytesFooter = tmp.getBody()+footer;   
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded.substring(0,bodyEncoded.length()-4)+EncodingUtil.base64Encode(Blob.valueOf(last4BytesFooter)));
        }
        else
        {
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
        }
        return bodyBlob;       
    }
    
}