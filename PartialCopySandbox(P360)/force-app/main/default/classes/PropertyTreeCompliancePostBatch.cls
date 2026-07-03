/*
********************************************************************************************************
Apex Class Name    : PropertyTreeCompliancePostBatch
Created Date       : Oct 16, 2023
@description       : This Batch class is used for Sending Compliance Certificate to Property Tree API 
processes 1 record at a time i.e batch size is 1.
@author            : Nikhil Gaurav
Modification Log:
Ver   Date         Author                     Modification
1.0   16-10-2023   Nikhil Gaurav            Initial Version
*******************************************************************************************************
*/

public class PropertyTreeCompliancePostBatch implements Database.Batchable<sObject>,Database.AllowsCallouts {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        string query='select Id,name from WorkOrderID_For_PropertyTree__c';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc, List<WorkOrderID_For_PropertyTree__c> Listrecords){
        system.debug('Listrecords:'+Listrecords);
        List<ContentVersion> CVlisttoupdate = new List<ContentVersion>();
        List<Error_Log__c> errorloglist = new List<Error_Log__c>();
        string Endpoint;
        String Reqbody;
        string wtcategory;
        string compid;
        for(WorkOrderID_For_PropertyTree__c woptree : Listrecords){
            try{
                workorder worec = [select id,SmokeAlarmComplianceID__c,BlindsComplianceID__c,SafetySwitchComplianceID__c,WaterComplianceID__c,PoolComplianceID__c,AccountId,Account.Next_Service_Date__c,Account.Last_Service_Date__c,Account.LastWaterDate__c,Account.LastPoolDate__c,Account.NextPoolDate__c,Account.LastBlindsDate__c,Account.NextBlindsDate__c,Account.LastSafetyDate__c,Account.NextSafetyDate__c,Account.parentid,Account.parent.ExternalIdEncrypted__c,Account.Management_ID__c,Account.SmokeAlarmType__c,worktype.PropertyTreeCategories__c,Error_On_API_Request__c from workorder where id=: woptree.Name limit 1 ];
                list<Agency_Integration_Info__c> AIIrecl =[select id,Smoke__c,Water__c,Safety__c,Blinds__c,Pool__c,Platform__c,Agency_Account__c,Turn_On_Compliance_Post__c,CreditorId__c,SmokeAlarmComplianceEndpoint__c,GeneralComplianceEndpoint__c,AddDocumentEndpoint__c from Agency_Integration_Info__c where Agency_Account__c=:worec.Account.parentid AND Platform__c='PropertyTree'AND Turn_On_Compliance_Post__c=true limit 1];
                list<string> picklistvalues =worec.worktype.PropertyTreeCategories__c.split(';'); 
                system.debug('picklistvalues.size():'+picklistvalues.size());
                if(AIIrecl.size()>0 && picklistvalues.size()>0 && worec.Error_On_API_Request__c ==false){
                    Agency_Integration_Info__c AIIrec =AIIrecl[0]; 
                    for(integer i=0; i<picklistvalues.size(); i++){
                        wtcategory=picklistvalues[i];
                        system.debug('wtcategory:'+wtcategory);
                        list<ContentVersion> CVlist =getCDLIDs(worec.Id,wtcategory);
                        if(wtcategory=='Smoke Alarm'){
                            compid=worec.SmokeAlarmComplianceID__c; 
                        }
                        if(wtcategory=='Water Efficiency'){
                            compid=worec.WaterComplianceID__c;
                        }
                        if(wtcategory=='Safety Switch'){
                            compid=worec.SafetySwitchComplianceID__c;  
                        }
                        if(wtcategory=='Corded Blinds'){
                            compid=worec.BlindsComplianceID__c;  
                        }
                        if(wtcategory=='Pool Compliance'){
                            compid=worec.PoolComplianceID__c;   
                        }
                        system.debug('compid:'+compid);
                        if(CVlist.size()>0 && compid ==null){
                            // calling smoke/general compliance creation
                            if(wtcategory =='Smoke Alarm'){
                                Endpoint=AIIrec.SmokeAlarmComplianceEndpoint__c;
                                PropertyTreeComplianceWrapper ptcw=new PropertyTreeComplianceWrapper(worec,wtcategory,AIIrec);
                                Reqbody=Json.serialize(ptcw);
                            }
                            else{
                                Endpoint=AIIrec.GeneralComplianceEndpoint__c;
                                PropertyTreeComplianceWrapper.General_details ptcwgd= new PropertyTreeComplianceWrapper.General_details(worec,wtcategory,AIIrec);
                                Reqbody=Json.serialize(ptcwgd);
                            }
                            system.debug('Reqbody:'+Reqbody);
                            Http http = new Http();
                            HttpRequest httpReq1 = new HttpRequest();
                            httpReq1.setMethod('POST');
                            httpReq1.setEndPoint(Endpoint);
                            httpReq1.setHeader('Authorization' , 'Bearer '+worec.Account.parent.ExternalIdEncrypted__c);
                            httpReq1.setHeader('Content-Type','application/json-patch+json');
                            httpReq1.setHeader('Accept' , 'application/json; charset=utf-8');
                            httpReq1.setbody(Reqbody);
                            httpReq1.setTimeout(120000);
                            HttpResponse httpRes1 = http.send(httpReq1);
                            system.debug('comp post body:'+httpRes1.getbody());
                            if(httpRes1.getStatusCode() == 200 || httpRes1.getStatusCode() == 201){ 
                                // response further processing
                                Map<string,object> Resbody= (Map<string,object>) JSON.deserializeUntyped(httpRes1.getbody());
                                system.debug('deserialise Resbody:'+ Resbody);
                                
                                if(wtcategory=='Smoke Alarm'){
                                    worec.SmokeAlarmComplianceID__c=string.valueof(Resbody.get('property_compliance_id')); 
                                }
                                if(wtcategory=='Water Efficiency'){
                                    worec.WaterComplianceID__c=string.valueof(Resbody.get('property_compliance_id'));
                                }
                                if(wtcategory=='Safety Switch'){
                                    worec.SafetySwitchComplianceID__c=string.valueof(Resbody.get('property_compliance_id'));  
                                }
                                if(wtcategory=='Corded Blinds'){
                                    worec.BlindsComplianceID__c=string.valueof(Resbody.get('property_compliance_id'));  
                                }
                                if(wtcategory=='Pool Compliance'){
                                    worec.PoolComplianceID__c =string.valueof(Resbody.get('property_compliance_id'));   
                                }
                                
                                for(contentversion cvid : CVlist){
                                    String boundary = '----------------------------741e90d31eff';
                                    Blob bodyBlob=createformdataforpostingpdf(cvid);
                                    Http http2 = new Http();
                                    HttpRequest httpReq2 = new HttpRequest();
                                    httpReq2.setMethod('POST');
                                    httpReq2.setEndPoint(AIIrec.AddDocumentEndpoint__c+'/Compliance/'+string.valueof(Resbody.get('property_compliance_id')));
                                    httpReq2.setHeader('Authorization' , 'Bearer '+worec.Account.parent.ExternalIdEncrypted__c);
                                    httpReq2.setHeader('Content-Type','multipart/form-data; boundary='+boundary);            
                                    httpReq2.setHeader('Accept' , 'application/json; charset=utf-8');
                                    httpReq2.setBodyAsBlob(bodyBlob);
                                    httpReq2.setTimeout(120000);
                                    HttpResponse httpRes2 = http2.send(httpReq2);
                                    system.debug('Doc post respbody:'+httpRes2.getbody());
                                    if(httpRes2.getStatusCode() == 200 || httpRes2.getStatusCode() == 201){
                                        Map<string,object> Docresbody= (Map<string,object>) JSON.deserializeUntyped(httpRes2.getbody());
                                        ContentVersion cvrec = new ContentVersion();
                                        cvrec.Id=cvid.Id;
                                        cvrec.PropertyTreeDocumentID__c =string.valueof(Docresbody.get('document_id'));
                                        CVlisttoupdate.add(cvrec);
                                        
                                    }
                                    else{
                                        // create error log on bad request document posting
                                        Error_Log__c errorLog = new Error_Log__c();
                                        errorLog.Work_Order__c=worec.id;
                                        errorLog.Error_Type__c = 'ERROR';
                                        errorLog.Error_Status_Code__c = string.valueof(httpRes2.getStatusCode());
                                        errorLog.Error_Message__c =  httpRes2.getStatus()+'On Document Posting ';
                                        errorLog.Error_Description__c = 'Error while processing the API request:'+httpRes2.getbody();
                                        errorLog.Class_Name__c = 'PropertyTreeCompliancePost';
                                        errorLog.Method_Name__c = 'PropertyTreeCompliancePost.execute() ';
                                        errorloglist.add(errorLog);
                                    }
                                }
                                
                            }
                            else{
                                // create error log on bad request for compliance
                                Error_Log__c errorLog = new Error_Log__c();
                                errorLog.Work_Order__c=worec.id;
                                errorLog.Error_Type__c = 'ERROR';
                                errorLog.Error_Status_Code__c = string.valueof(httpRes1.getStatusCode());
                                errorLog.Error_Message__c =  httpRes1.getStatus()+' On Compliance Creation: '+wtcategory;
                                errorLog.Error_Description__c = 'Error while processing the API request:'+httpRes1.getbody();
                                errorLog.Class_Name__c = 'PropertyTreeCompliancePost';
                                errorLog.Method_Name__c = 'PropertyTreeCompliancePost.execute()';
                                errorloglist.add(errorLog);
                                
                            }
                        }
                    }
                    system.debug('outside for loop');
                    system.debug('worec:'+worec);
                    system.debug('CVlisttoupdate:'+CVlisttoupdate);
                    system.debug('errorloglist:'+errorloglist);
                    if(CVlisttoupdate.size()>0){
                        
                        update CVlisttoupdate;
                    }
                    if(errorloglist.size()>0){
                        worec.Error_On_API_Request__c=true;
                        insert errorloglist;
                    }
                    worec.Status='Closed';
                    update worec;
                    delete woptree;
                }
            }
            catch( Exception ex){
                //error logging
                Error_Log__c errorLog = new Error_Log__c();
                errorLog.Work_Order__c=woptree.name;
                errorLog.Error_Type__c = 'ERROR';
                errorLog.Error_Status_Code__c = '';
                errorLog.Error_Message__c = ex.getMessage();
                errorLog.Error_Description__c = 'Error while processing the request:'+  ex + ex.getMessage() +' at line ' +ex.getLineNumber() + ' '+ ex.getStackTraceString();
                errorLog.Class_Name__c = 'PropertyTreeCompliancePost';
                errorLog.Method_Name__c = 'PropertyTreeCompliancePost.execute()';
                insert errorLog;
                
                // marking work order record with error api request
                workorder wo = new workorder();
                wo.Id=woptree.name;
                wo.Error_On_API_Request__c=true;
                update wo;
                // removing id from custom setting   
                delete woptree;
            }
        }
    }
    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
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
    
    public static list<ContentVersion>  getCDLIDs(id woid,String wtcategory){
        list<id> CD_Ids = new list<id>();
        list<id> CV_Ids = new list<id>();
        list<ContentVersion> CVlist = New list<ContentVersion>();
        for(ContentDocumentLink cd :[SELECT ContentDocumentId, Id, LinkedEntityId, ShareType FROM ContentDocumentLink WHERE LinkedEntityId=:woid]){
            CD_Ids.add(cd.ContentDocumentId);
        }
        if(CD_Ids.size()>0){
            for(ContentVersion cv :[SELECT Id,VersionData,FileType,Category__c,title from ContentVersion where FileType='PDF' AND ContentDocumentid IN:CD_Ids AND Category__c=:wtcategory ] ){
                CVlist.add(cv);
            }  
        }
        system.debug('CVlist'+CVlist);
        return CVlist;
    }
}