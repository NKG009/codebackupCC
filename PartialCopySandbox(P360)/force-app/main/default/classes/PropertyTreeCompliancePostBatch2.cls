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

public class PropertyTreeCompliancePostBatch2 implements Database.Batchable<sObject>,Database.AllowsCallouts {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        string query='select Id,name from WorkOrderID_For_PropertyTree__c';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc, List<WorkOrderID_For_PropertyTree__c> Listrecords){
        List<ContentVersion> CVlisttoupdate = new List<ContentVersion>();
        List<Error_Log__c> errorloglist = new List<Error_Log__c>();
        list<PropertyTreeSearchResponseWrapper> SearchResbody = new list<PropertyTreeSearchResponseWrapper>();
        string Endpoint;
        String Reqbody;
        String ReqMethod;
        string wtcategory;
        string compid;
        string categoryid;
        for(WorkOrderID_For_PropertyTree__c woptree : Listrecords){
            try{
                workorder worec = [select id,SmokeAlarmComplianceID__c,BlindsComplianceID__c,SafetySwitchComplianceID__c,WaterComplianceID__c,PoolComplianceID__c,AccountId,Account.Next_Service_Date__c,Account.Last_Service_Date__c,Account.LastWaterDate__c,Account.LastPoolDate__c,Account.NextPoolDate__c,Account.LastBlindsDate__c,Account.NextBlindsDate__c,Account.LastSafetyDate__c,Account.NextSafetyDate__c,Account.parentid,Account.parent.ExternalIdEncrypted__c,Account.Management_ID__c,Account.SmokeAlarmType__c,worktype.PropertyTreeCategories__c,Error_On_API_Request__c from workorder where id=: woptree.Name limit 1 ];
                list<Agency_Integration_Info__c> AIIrecl =[select id,Smoke__c,Water__c,Safety__c,Blinds__c,Pool__c,Platform__c,Agency_Account__c,Turn_On_Compliance_Post__c,CreditorId__c,SmokeAlarmComplianceEndpoint__c,GeneralComplianceEndpoint__c,AddDocumentEndpoint__c,PropertyComplianceEndpoint__c from Agency_Integration_Info__c where Agency_Account__c=:worec.Account.parentid AND Platform__c='PropertyTree'AND Turn_On_Compliance_Post__c=true limit 1];
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
                            categoryid=AIIrec.Smoke__c;
                        }
                        if(wtcategory=='Water Efficiency'){
                            compid=worec.WaterComplianceID__c;
                            categoryid=AIIrec.Water__c;
                        }
                        if(wtcategory=='Safety Switch'){
                            compid=worec.SafetySwitchComplianceID__c; 
                            categoryid=AIIrec.Safety__c;
                        }
                        if(wtcategory=='Corded Blinds'){
                            compid=worec.BlindsComplianceID__c;  
                            categoryid=AIIrec.Blinds__c;
                        }
                        if(wtcategory=='Pool Compliance'){
                            compid=worec.PoolComplianceID__c; 
                            categoryid=AIIrec.Pool__c;
                        }
                        system.debug('compid:'+compid);
                        if(CVlist.size()>0 && compid ==null){
                            
                            /**********************************Compliance Search API Request*************************************/
                            
                            string SearchBody='{"category_id": "'+categoryid+'","status": "Open","management_id": "'+worec.Account.Management_ID__c+'"}';
                            system.debug('searrch req');
                            Http httpSearch = new Http();
                            HttpRequest Searchreq = new HttpRequest();
                            Searchreq.setMethod('POST');
                            Searchreq.setEndPoint(AIIrec.PropertyComplianceEndpoint__c+'/search');
                            Searchreq.setHeader('Authorization' , 'Bearer '+worec.Account.parent.ExternalIdEncrypted__c);
                            Searchreq.setHeader('Content-Type','application/json-patch+json');
                            Searchreq.setHeader('Accept' , 'application/json; charset=utf-8');
                            Searchreq.setbody(SearchBody);
                            Searchreq.setTimeout(120000);
                            HttpResponse SearchRes = httpSearch.send(Searchreq);
                            system.debug('SearchRes:'+SearchRes.getbody());
                            if(SearchRes.getStatusCode() == 200 || SearchRes.getStatusCode() == 201){ 
                                SearchResbody=(list<PropertyTreeSearchResponseWrapper>)JSON.deserialize(SearchRes.getbody(), list<PropertyTreeSearchResponseWrapper>.class);                                
                                if(SearchResbody.size()>0){
                                    compid=SearchResbody[0].compliance_id;
                                    // update compliance logic will run
                                    ReqMethod='PUT';
                                    if(wtcategory =='Smoke Alarm'){
                                        Endpoint=AIIrec.SmokeAlarmComplianceEndpoint__c+'/'+SearchResbody[0].compliance_id;
                                        PropertyTreeComplianceWrapper ptcw=new PropertyTreeComplianceWrapper(worec,wtcategory,AIIrec,false);
                                        Reqbody=Json.serialize(ptcw);
                                        worec.SmokeAlarmComplianceID__c=SearchResbody[0].compliance_id;
                                    }
                                    else{
                                        Endpoint=AIIrec.GeneralComplianceEndpoint__c+'/'+SearchResbody[0].compliance_id;
                                        PropertyTreeComplianceWrapper.General_details ptcwgd= new PropertyTreeComplianceWrapper.General_details(worec,wtcategory,AIIrec,false);
                                        Reqbody=Json.serialize(ptcwgd);
                                        if(wtcategory=='Water Efficiency'){
                                            worec.WaterComplianceID__c=SearchResbody[0].compliance_id;
                                        }
                                        if(wtcategory=='Safety Switch'){
                                            worec.SafetySwitchComplianceID__c=SearchResbody[0].compliance_id;  
                                        }
                                        if(wtcategory=='Corded Blinds'){
                                            worec.BlindsComplianceID__c=SearchResbody[0].compliance_id;  
                                        }
                                        if(wtcategory=='Pool Compliance'){
                                            worec.PoolComplianceID__c =SearchResbody[0].compliance_id;   
                                        }
                                        
                                    }
                                    
                                }
                                else{
                                    
                                    //create compliance logic
                                    ReqMethod='POST';
                                    if(wtcategory =='Smoke Alarm'){
                                        Endpoint=AIIrec.SmokeAlarmComplianceEndpoint__c;
                                        PropertyTreeComplianceWrapper ptcw=new PropertyTreeComplianceWrapper(worec,wtcategory,AIIrec,true);
                                        Reqbody=Json.serialize(ptcw);
                                    }
                                    else{
                                        Endpoint=AIIrec.GeneralComplianceEndpoint__c;
                                        PropertyTreeComplianceWrapper.General_details ptcwgd= new PropertyTreeComplianceWrapper.General_details(worec,wtcategory,AIIrec,true);
                                        Reqbody=Json.serialize(ptcwgd);
                                    } 
                                }
                                /**********************************create-Update Compliance API Request*************************************/ 
                                system.debug('CRUP:'+ReqMethod+Reqbody);
                                Http CRUPhttp = new Http();
                                HttpRequest CRUPReq = new HttpRequest();
                                CRUPReq.setMethod(ReqMethod);
                                CRUPReq.setEndPoint(Endpoint);
                                CRUPReq.setHeader('Authorization' , 'Bearer '+worec.Account.parent.ExternalIdEncrypted__c);
                                CRUPReq.setHeader('Content-Type','application/json-patch+json');
                                CRUPReq.setHeader('Accept' , 'application/json; charset=utf-8');
                                CRUPReq.setbody(Reqbody);
                                CRUPReq.setTimeout(120000);
                                HttpResponse CRUPResp = CRUPhttp.send(CRUPReq);
                                system.debug('comp post body:'+CRUPResp.getbody());
                                if(CRUPResp.getStatusCode() == 200 || CRUPResp.getStatusCode() == 201){
                                    if(ReqMethod=='POST'){
                                        // response further processing On new compliance creation
                                        Map<string,object> CRUPRespbody= (Map<string,object>) JSON.deserializeUntyped(CRUPResp.getbody());
                                        compid=string.valueof(CRUPRespbody.get('property_compliance_id'));
                                        system.debug('deserialise CRUPRespbody:'+ CRUPRespbody);
                                        
                                        if(wtcategory=='Smoke Alarm'){
                                            worec.SmokeAlarmComplianceID__c=string.valueof(CRUPRespbody.get('property_compliance_id')); 
                                        }
                                        if(wtcategory=='Water Efficiency'){
                                            worec.WaterComplianceID__c=string.valueof(CRUPRespbody.get('property_compliance_id'));
                                        }
                                        if(wtcategory=='Safety Switch'){
                                            worec.SafetySwitchComplianceID__c=string.valueof(CRUPRespbody.get('property_compliance_id'));  
                                        }
                                        if(wtcategory=='Corded Blinds'){
                                            worec.BlindsComplianceID__c=string.valueof(CRUPRespbody.get('property_compliance_id'));  
                                        }
                                        if(wtcategory=='Pool Compliance'){
                                            worec.PoolComplianceID__c =string.valueof(CRUPRespbody.get('property_compliance_id'));   
                                        }
                                    } 
                                    /**********************************Document Post API Request*************************************/     
                                    for(contentversion cvid : CVlist){
                                        system.debug('doc req');
                                        String boundary = '----------------------------741e90d31eff';
                                        Blob bodyBlob=createformdataforpostingpdf(cvid);
                                        Http dochttp = new Http();
                                        HttpRequest docReq = new HttpRequest();
                                        docReq.setMethod('POST');
                                        docReq.setEndPoint(AIIrec.AddDocumentEndpoint__c+'/Compliance/'+compid);
                                        docReq.setHeader('Authorization' , 'Bearer '+worec.Account.parent.ExternalIdEncrypted__c);
                                        docReq.setHeader('Content-Type','multipart/form-data; boundary='+boundary);            
                                        docReq.setHeader('Accept' , 'application/json; charset=utf-8');
                                        docReq.setBodyAsBlob(bodyBlob);
                                        docReq.setTimeout(120000);
                                        HttpResponse docResp = dochttp.send(docReq);
                                        system.debug('Doc post respbody:'+docResp.getbody());
                                        if(docResp.getStatusCode() == 200 || docResp.getStatusCode() == 201){
                                            Map<string,object> Docresbody= (Map<string,object>) JSON.deserializeUntyped(docResp.getbody());
                                            ContentVersion cvrec = new ContentVersion();
                                            cvrec.Id=cvid.Id;
                                            cvrec.PropertyTreeDocumentID__c =string.valueof(Docresbody.get('document_id'));
                                            CVlisttoupdate.add(cvrec);
                                            
                                            /**********************************API Request ->Update Compliance status(complete) *************************************/     
                                            
                                            ///{compliance_id}/complete
                                            system.debug('status comp req');
                                            Http httpcomplete = new Http();
                                            HttpRequest completereq = new HttpRequest();
                                            completereq.setMethod('POST');
                                            completereq.setEndPoint(AIIrec.PropertyComplianceEndpoint__c+'/'+compid+'/complete');
                                            completereq.setHeader('Authorization' , 'Bearer '+worec.Account.parent.ExternalIdEncrypted__c);
                                            completereq.setHeader('Content-Type','application/json-patch+json');
                                            completereq.setHeader('Accept' , 'application/json; charset=utf-8');
                                            completereq.setbody(SearchBody);
                                            completereq.setTimeout(120000);
                                            HttpResponse completeres = httpcomplete.send(completereq);
                                            system.debug('completereq:'+completeres.getbody());
                                            if(completeres.getStatusCode() == 200 || completeres.getStatusCode() == 201){ 
                                                
                                                //create new compliance after completing the old property complaince  
                                                if(wtcategory =='Smoke Alarm'){
                                                    Endpoint=AIIrec.SmokeAlarmComplianceEndpoint__c;
                                                    PropertyTreeComplianceWrapper ptcw=new PropertyTreeComplianceWrapper(worec,wtcategory,AIIrec,true);
                                                    Reqbody=Json.serialize(ptcw);
                                                }
                                                else{
                                                    Endpoint=AIIrec.GeneralComplianceEndpoint__c;
                                                    PropertyTreeComplianceWrapper.General_details ptcwgd= new PropertyTreeComplianceWrapper.General_details(worec,wtcategory,AIIrec,true);
                                                    Reqbody=Json.serialize(ptcwgd);
                                                } 
                                                system.debug('re-compliance:'+Reqbody);
                                                Http Recreatehttp = new Http();
                                                HttpRequest RecreateReq = new HttpRequest();
                                                RecreateReq.setMethod('POST');
                                                RecreateReq.setEndPoint(Endpoint);
                                                RecreateReq.setHeader('Authorization' , 'Bearer '+worec.Account.parent.ExternalIdEncrypted__c);
                                                RecreateReq.setHeader('Content-Type','application/json-patch+json');
                                                RecreateReq.setHeader('Accept' , 'application/json; charset=utf-8');
                                                RecreateReq.setbody(Reqbody);
                                                RecreateReq.setTimeout(120000);
                                                HttpResponse RecreateRes = Recreatehttp.send(RecreateReq);
                                                system.debug('recomp post body:'+RecreateRes.getbody());
                                                if(RecreateRes.getStatusCode() == 200 || RecreateRes.getStatusCode() == 201){ 
                                                    // any processing after re-compliance creation
                                                }
                                                else{
                                                    // create error log on bad request for compliance
                                                    Error_Log__c errorLog = new Error_Log__c();
                                                    errorLog.Work_Order__c=worec.id;
                                                    errorLog.Error_Type__c = 'ERROR';
                                                    errorLog.Error_Status_Code__c = string.valueof(RecreateRes.getStatusCode());
                                                    errorLog.Error_Message__c =  RecreateRes.getStatus()+' On Re-Compliance Creation: '+wtcategory;
                                                    errorLog.Error_Description__c = 'Error while processing the API request:'+RecreateRes.getbody();
                                                    errorLog.Class_Name__c = 'PropertyTreeCompliancePost';
                                                    errorLog.Method_Name__c = 'PropertyTreeCompliancePost.execute()';
                                                    errorloglist.add(errorLog);
                                                }
                                                
                                                
                                            }
                                            else{
                                                // create error log on bad request for updating Compliance status
                                                Error_Log__c errorLog = new Error_Log__c();
                                                errorLog.Work_Order__c=worec.id;
                                                errorLog.Error_Type__c = 'ERROR';
                                                errorLog.Error_Status_Code__c = string.valueof(completeres.getStatusCode());
                                                errorLog.Error_Message__c =  completeres.getStatus()+'On Document Posting ';
                                                errorLog.Error_Description__c = 'Error while processing the API request:'+completeres.getbody();
                                                errorLog.Class_Name__c = 'PropertyTreeCompliancePost';
                                                errorLog.Method_Name__c = 'PropertyTreeCompliancePost.execute() ';
                                                errorloglist.add(errorLog);
                                                
                                            }
                                        }
                                        else{
                                            // create error log on bad request document posting
                                            Error_Log__c errorLog = new Error_Log__c();
                                            errorLog.Work_Order__c=worec.id;
                                            errorLog.Error_Type__c = 'ERROR';
                                            errorLog.Error_Status_Code__c = string.valueof(docResp.getStatusCode());
                                            errorLog.Error_Message__c =  docResp.getStatus()+'On Document Posting ';
                                            errorLog.Error_Description__c = 'Error while processing the API request:'+docResp.getbody();
                                            errorLog.Class_Name__c = 'PropertyTreeCompliancePost';
                                            errorLog.Method_Name__c = 'PropertyTreeCompliancePost.execute() ';
                                            errorloglist.add(errorLog);
                                        }
                                    }
                                }
                                else{
                                    // create error log on bad request for compliance(create-Update)
                                    Error_Log__c errorLog = new Error_Log__c();
                                    errorLog.Work_Order__c=worec.id;
                                    errorLog.Error_Type__c = 'ERROR';
                                    errorLog.Error_Status_Code__c = string.valueof(CRUPResp.getStatusCode());
                                    if(ReqMethod=='POST'){ errorLog.Error_Message__c =  CRUPResp.getStatus()+' On Compliance Creation: '+wtcategory;}
                                    else{errorLog.Error_Message__c =  CRUPResp.getStatus()+' On Compliance Updation: '+wtcategory;}
                                    errorLog.Error_Description__c = 'Error while processing the API request:'+CRUPResp.getbody();
                                    errorLog.Class_Name__c = 'PropertyTreeCompliancePost';
                                    errorLog.Method_Name__c = 'PropertyTreeCompliancePost.execute()';
                                    errorloglist.add(errorLog);
                                    
                                }
                                
                            }
                            else{
                                // create error log on bad request "Search Compliance"
                                Error_Log__c errorLog = new Error_Log__c();
                                errorLog.Work_Order__c=worec.id;
                                errorLog.Error_Type__c = 'ERROR';
                                errorLog.Error_Status_Code__c = string.valueof(SearchRes.getStatusCode());
                                errorLog.Error_Message__c =  SearchRes.getStatus()+'On Compliance Search ';
                                errorLog.Error_Description__c = 'Error while processing the API request:'+SearchRes.getbody();
                                errorLog.Class_Name__c = 'PropertyTreeCompliancePost';
                                errorLog.Method_Name__c = 'PropertyTreeCompliancePost.execute() ';
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
        // document posting logic 
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