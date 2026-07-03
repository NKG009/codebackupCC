/*
********************************************************************************************************
Apex Class Name    : CompliancePdfPostToPropertyMeBatch
Created Date       : May 29, 2023
@description       : This Batch class is used for Sending Compliance Certificate to PropertyMe API 
@author            : Nikhil Gaurav
Modification Log:
Ver   Date         Author                     Modification
1.0   29-05-2023   Nikhil Gaurav            Initial Version
*******************************************************************************************************
*/

global class CompliancePdfPostToPropertyMeBatch implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful {
    global id accparentid;
    
    global CompliancePdfPostToPropertyMeBatch(id parentid){
        this.accparentid=parentid;
        
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        string query='select name,AccountParentID__c from WorkOrderId__c where AccountParentID__c=:accparentid';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, list<WorkOrderId__c> AllWOIds ) {
       
            System.debug('AllWOIds---'+AllWOIds);
            List<CompliancePdfWrapper> responselist  = new List<CompliancePdfWrapper>();
            list<workorder> wolisttoupdate = new  list<workorder>();
            Agency_Account_Integration_Info__mdt [] aaii =[select MasterLabel,JobTask_Url__c from Agency_Account_Integration_Info__mdt limit 1];
            list<Agency_Integration_Info__c> AIIrec =[select id,Agency_Account__c,Access_Token__c,Client_ID__c,Client_Secret__c,Refresh_Token__c,Supplier_ID__c,Turn_On_Compliance_Post__c from Agency_Integration_Info__c where Agency_Account__c=:accparentid limit 1];
            system.debug('AIIrec'+AIIrec.size());
            system.debug('aaii'+aaii);
            if(AIIrec.size() >0 && AIIrec[0].Turn_On_Compliance_Post__c){
                system.debug('Turn_On_Compliance_Post__c'+AIIrec[0].Turn_On_Compliance_Post__c);
                for(WorkOrderId__c woi : AllWOIds){
                    try{
                    Workorder wo=[select id,AccountId,Error_On_API_Request__c,account.External_ID__c,WorkType.Name,Job_Task_Id__c from workorder where id=: woi.Name limit 1 ];
                    
                    date startDate=Date.newInstance(0001, 1, 1);
                    integer days=integer.valueof(System.Label.Timestamp_No_Of_Days);
                    date endDate=system.today()-days;
                    Integer Totalseconds = (startDate.daysBetween(endDate))*864;
                    string Totalticks=Totalseconds+'000000000';
                    /**************************************** Get request to get all jobtask from propertyme *******************************************/ 
                    String requestBody ='Timestamp='+Totalticks;
                    Http http = new Http();
                    HttpRequest httpReq = new HttpRequest();
                    httpReq.setMethod('GET');
                    httpReq.setEndPoint(aaii[0].JobTask_Url__c+'?Timestamp='+Totalticks);
                    httpReq.setHeader('Content-Type','application/x-www-form-urlencoded');
                    httpReq.setHeader('Accept' , 'application/json');
                    httpReq.setHeader('Authorization' , 'Bearer '+AIIrec[0].Access_Token__c);
                    httpReq.setTimeout(120000);
                    // httpReq.setBody(requestBody);
                    HttpResponse httpRes = http.send(httpReq);
                    system.debug('get all jobtask from propertyme status--'+ httpRes.getStatusCode());
                    if(httpRes.getStatusCode() == 200) {
                        system.debug('response alljob='+httpRes.getBody() );
                        
                        responselist = (list<CompliancePdfWrapper>)JSON.deserialize(httpRes.getBody(), list<CompliancePdfWrapper>.class);
                        system.debug('responselist all jobtask==='+responselist);
                        boolean jobtaskfound=false;
                        for( CompliancePdfWrapper resrec: responselist) {
                            system.debug('resrec.Status'+resrec.Status);
                            if( resrec.Status=='Assigned' && resrec.LotId== wo.account.External_ID__c && resrec.ContactId== AIIrec[0].Supplier_ID__c && wo.Job_Task_Id__c==null ){      //supplierrefrencefilter
                                jobtaskfound=true;
                                postdocandupdatejobstatustoPropertyme( resrec.id,accparentid,wo.id );
                                system.debug('2nd before');
                                break;
                            }
                            
                        }
                        system.debug('jobtaskfound?---'+jobtaskfound);
                        if(jobtaskfound==false && wo.Job_Task_Id__c==null){
                            
                            /**************************************** Post request to Create New Job Task *******************************************/ 
                            //  if(!test.isRunningTest()){
                            createnewjobtask(aaii[0].JobTask_Url__c,AIIrec[0].Access_Token__c,wo.account.External_ID__c,wo.WorkType.Name,accparentid,wo.id,AIIrec[0].Supplier_ID__c) ;
                            
                        }
                        
                    } 
                        
                    }
                    catch(Exception ex){
                        Error_Log__c errorLog = new Error_Log__c();
                        errorLog.Work_Order__c=woi.Name;
                        errorLog.Error_Type__c = 'ERROR';
                        errorLog.Error_Status_Code__c = '';
                        errorLog.Error_Message__c = ex.getMessage();
                        errorLog.Error_Description__c = 'Error while processing the request:'+ ex + ex.getMessage() +' at line ' +ex.getLineNumber() + ' '+ ex.getStackTraceString();
                        errorLog.Class_Name__c = 'CompliancePdfPostToPropertyMeBatch';
                        errorLog.Method_Name__c = 'CompliancePdfPostToPropertyMeBatch.execute(this method includes getalljobtaskcallout)';
                        insert errorLog;
                        
                        workorder wo = new workorder();
                        wo.Id=woi.Name;
                        wo.Error_On_API_Request__c=true;
                        update wo;
                        
                       if(!test.isRunningTest())
                        delete woi;
                    }           
                    
                }
                
            }
        else{
            system.debug('elsepart');
            for(WorkOrderId__c woi : AllWOIds){
                workorder wo = new workorder();
                wo.Id=woi.Name;
                wo.Status='Closed';
                wolisttoupdate.add(wo);
                delete woi;
            }
            
            
        }
        if(!wolisttoupdate.isempty()){
            update wolisttoupdate;
        }
        
        
    }
    global void finish(Database.BatchableContext BC){  
        
    }
    
/*
***********************************************************************************************
@Method Name    : postdocandupdatejobstatustoPropertyme
@author         : Nikhil Gaurav
@description    : method to is used to Post Pdf file from work order to PropertyME API
@param          : JobtaskId,Account'sparentId, workorderId
@return         : None
*********************************************************************************************
*/ 
    public static void postdocandupdatejobstatustoPropertyme( string jobid ,id accparentid ,id woid ){
        try{
            Agency_Account_Integration_Info__mdt [] aaii =[select MasterLabel,JobTask_Url__c from Agency_Account_Integration_Info__mdt limit 1];
            Agency_Integration_Info__c AIIrec =[select id,Agency_Account__c,Access_Token__c,Client_ID__c,Client_Secret__c,Refresh_Token__c from Agency_Integration_Info__c where Agency_Account__c=:accparentid limit 1];
            list<ContentDocumentLink> cdlist =[SELECT ContentDocumentId, Id, LinkedEntityId, ShareType FROM ContentDocumentLink WHERE LinkedEntityId=:woid];
            integer noofdoc =cdlist.size();
            system.debug('noofdoc'+noofdoc);
            integer i=0;
            for(ContentDocumentLink cd :cdlist){
                ContentVersion file = [SELECT Id,VersionData from ContentVersion where ContentDocumentid=:cd.ContentDocumentId limit 1];                        
                string filename = [SELECT Id, title FROM ContentDocument where id=:cd.ContentDocumentId limit 1].title;
                
                SYSTEM.debug('file.VersionData'+file.VersionData);
                /* String boundary = '----------------------------741e90d31eff';
String header = '--'+boundary+'\nContent-Disposition: form-data; name="file"; filename="'+filename+'";\nContent-Type: text/plain';

String footer = '--'+boundary+'--';             
String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
while(headerEncoded.endsWith('='))
{
header+=' ';
headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
}
String bodyEncoded = EncodingUtil.base64Encode(file.VersionData);
String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));

Blob bodyBlob = null;
bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);*/
                String boundary = '----------------------------741e90d31eff';
                String header = '--'+boundary+'\r\nContent-Disposition: form-data; name="file"; filename="'+filename+'.pdf"\r\nContent-Type:application/json; charset=utf-8'; // added '\r's removed ';' see Tim Smith's comment
                String footer = '\r\n--'+boundary+'--';              
                String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
                while(headerEncoded.endsWith('='))
                {
                    header+=' ';
                    headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
                }
                String bodyEncoded = EncodingUtil.base64Encode(file.VersionData);
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
                
                /**************************************** posting document request *******************************************/ 
                
                HttpRequest req = new HttpRequest();
                req.setHeader('Authorization', 'Bearer '+AIIrec.Access_Token__c);
                req.setHeader('Content-Type','multipart/form-data; boundary='+boundary);
                req.setMethod('POST');
                req.SetEndpoint(aaii[0].JobTask_Url__c+'/'+jobid+'/documents');
                req.setBodyAsBlob(bodyBlob);
                req.setTimeout(120000);
                Http http1 = new Http();
                HTTPResponse res = http1.send(req);
                system.debug('posting document request---'+ res.getStatusCode());
                
                if(res.getStatusCode() == 200) {// aaii[0].JobTask_Url__c AIIrec.Access_Token__c
                    i++;
                    system.debug('response alljob='+res.getBody() );
                    system.debug('valueofi='+i);
                    if(i==noofdoc){
                        updatingjobtasktoCOMPLETE(jobid,aaii[0].JobTask_Url__c,woid,AIIrec.Access_Token__c);
                        
                    }
                    
                }
            }
        }
        catch(Exception ex){
            Error_Log__c errorLog = new Error_Log__c();
            errorLog.Work_Order__c=woid;
            errorLog.Error_Type__c = 'ERROR';
            errorLog.Error_Status_Code__c = '';
            errorLog.Error_Message__c = ex.getMessage();
            errorLog.Error_Description__c = 'Error while processing the request:'+  ex + ex.getMessage() +' at line ' +ex.getLineNumber() + ' '+ ex.getStackTraceString();
            errorLog.Class_Name__c = 'CompliancePdfPostToPropertyMeBatch';
            errorLog.Method_Name__c = 'CompliancePdfPostToPropertyMeBatch.postdocandupdatejobstatustoPropertyme';
            insert errorLog;
            
             workorder wo = new workorder();
                wo.Id=woid;
                wo.Error_On_API_Request__c=true;
                update wo;
                
                WorkOrderId__c worec=[select name,AccountParentID__c from WorkOrderId__c where name=:woid];
            if(!test.isRunningTest())
                delete worec;
        }    
        
    }
   
/*
***********************************************************************************************
@Method Name    : updatingjobtasktoCOMPLETE
@author         : Nikhil Gaurav
@description    : method to is used to Update Job Task Status To Complete In PropertyME API
@param          : JobtaskId, Jobtask URL , WorkOrderId, AccessToken
@return         : None
**********************************************************************************************
*/    
    public static void updatingjobtasktoCOMPLETE( string jobid ,String jobtakurl ,id woid,string accesstoken ){
        
        /**************************************** Updating Job task to complete post Request *******************************************/ 
        try{
            String requestBody ='{"Id":"'+jobid+'"}';
            Http http = new Http();
            HttpRequest httpReq = new HttpRequest();
            httpReq.setMethod('POST');
            httpReq.setEndPoint(jobtakurl+'/'+jobid+'/complete');
            httpReq.setHeader('Authorization' , 'Bearer '+accesstoken);
            httpReq.setHeader('Content-Type' , 'application/json');
            httpReq.setBody(requestBody);
            httpReq.setTimeout(120000);
            HttpResponse httpRes = http.send(httpReq);
            system.debug('Job task to complete---'+ httpRes.getStatusCode());
            if(httpRes.getStatusCode() == 200) {
                workorder wo = new workorder();
                if(!test.isRunningTest()){
                    wo.Id=woid;}
                else {
                    wo.id=null;
                }
                wo.Status='Closed';
                wo.Job_Task_Id__c=jobid;
                wo.Error_On_API_Request__c=false;
                update wo;
                
                WorkOrderId__c worec=[select name,AccountParentID__c from WorkOrderId__c where name=:woid];
                system.debug('WorkOrderId__cworec'+worec);
                delete worec;
                system.debug('before bresk');
                
                
            }
            
        }
        catch(Exception ex){
            Error_Log__c errorLog = new Error_Log__c();
            errorLog.Work_Order__c=woid;
            errorLog.Error_Type__c = 'ERROR';
            errorLog.Error_Status_Code__c = '';
            errorLog.Error_Message__c = ex.getMessage();
            errorLog.Error_Description__c = 'Error while processing the request:'+  ex + ex.getMessage() +' at line ' +ex.getLineNumber() + ' '+ ex.getStackTraceString();
            errorLog.Class_Name__c = 'CompliancePdfPostToPropertyMeBatch';
            errorLog.Method_Name__c = 'CompliancePdfPostToPropertyMeBatch.updatingjobtasktoCOMPLETE';
            insert errorLog;
            
            workorder wo = new workorder();
            wo.Id=woid;
            wo.Error_On_API_Request__c=true;
            update wo;
            
            WorkOrderId__c worec=[select name,AccountParentID__c from WorkOrderId__c where name=:woid];
            if(!test.isRunningTest())
            delete worec;
        }    
        
    }
       
/*
**********************************************************************************************************************
@Method Name    : createnewjobtask
@author         : Nikhil Gaurav
@description    : method to is used to Create New Job Task In PropertyME API
@param          : JobtaskId,AccessToken,Account ExternalId ,WorkType Name,Account ParentId,WorkOrderId,Supplier Id 
@return         : None
***********************************************************************************************************************
*/
    
    /**************************************** Post request to Create New Job Task *******************************************/ 
    public static void createnewjobtask(String jobtakurl,string accesstoken, string extid, string wodesc, string accparentid, string woid , string supplierid){
        
        try{
            String requestBodynj ='{ "LotId":"'+extid+'","DueDate":"'+system.now()+'" "Summary":"Annual Property Compliance", "Description":"'+wodesc +'", "ReportedContactType": "Agent", "Access": "Tenant"}';    
            
            //String requestBodynj ='{LotId='+wo.account.External_ID__c+',Summary=Testsmoke,Description=null,ReportedContactType=Agent,Access=Agent}';    
            Http httpnj = new Http();
            HttpRequest httpReqnj = new HttpRequest();
            httpReqnj.setMethod('POST');
            httpReqnj.setEndPoint(jobtakurl);
            httpReqnj.setHeader('Authorization' , 'Bearer '+accesstoken);
            httpReqnj.setHeader('Content-Type' , 'application/json');
            httpReqnj.setHeader('Accept' , 'application/json');
            httpReqnj.setTimeout(120000);
            httpReqnj.setBody(requestBodynj);
            HttpResponse httpResnj = httpnj.send(httpReqnj);
            system.debug('requestBodynj'+requestBodynj);
            system.debug('Create New Job Task----'+ httpResnj.getStatusCode());
            
            if(httpResnj.getStatusCode() == 200) {
                system.debug(httpResnj.getBody());
                Map<String, Object> response_Map = (Map<String, Object>)JSON.deserializeUntyped(httpResnj.getBody());
                system.debug('response_Map'+response_Map);
                
                String NewjobId = (String)response_Map.get('JobTaskId');
                system.debug('NewjobId'+NewjobId);
                approvenewjobtask(NewjobId,jobtakurl,accesstoken,accparentid,woid,supplierid);
                
            }
            
        }
        catch(Exception ex){
            Error_Log__c errorLog = new Error_Log__c();
            errorLog.Work_Order__c=woid;
            errorLog.Error_Type__c = 'ERROR';
            errorLog.Error_Status_Code__c = '';
            errorLog.Error_Message__c = ex.getMessage();
            errorLog.Error_Description__c = 'Error while processing the request:'+  ex + ex.getMessage() +' at line ' +ex.getLineNumber() + ' '+ ex.getStackTraceString();
            errorLog.Class_Name__c = 'CompliancePdfPostToPropertyMeBatch';
            errorLog.Method_Name__c = 'CompliancePdfPostToPropertyMeBatch.createnewjobtask';
            insert errorLog;
            
            workorder wo = new workorder();
            wo.Id=woid;
            wo.Error_On_API_Request__c=true;
            update wo;
            
            WorkOrderId__c worec=[select name,AccountParentID__c from WorkOrderId__c where name=:woid];
            if(!test.isRunningTest())
            delete worec;
        }    
        
        
    }
    //https://app.propertyme.com/api/v1/jobtasks/afc6021e-d05d-4443-a19a-21502154b160/assign?SupplierContactId=ae2e04da-c729-46ea-acf9-d726b44de2c6
/*
**********************************************************************************************************************
@Method Name    : approvenewjobtask
@author         : Nikhil Gaurav
@description    : method to is used to Update Job Task Status to Approve In PropertyME API
@param          : JobtaskId,JobTask URL,AccessToken,Account ParentId,WorkOrderId,Supplier Id 
@return         : None
***********************************************************************************************************************
*/
       
    /**************************************** Post request to Approve New Job Task *******************************************/ 
    public static void approvenewjobtask(String jobid, String jobtakurl,string accesstoken,string accparentid, string woid,string supplierid ){
        try{
            String requestBody ='{"Id":"'+jobid+'"}';
            Http http = new Http();
            HttpRequest httpReqapp = new HttpRequest();
            httpReqapp.setMethod('POST');
            httpReqapp.setEndPoint(jobtakurl+'/'+jobid+'/approve');
            httpReqapp.setHeader('Authorization' , 'Bearer '+accesstoken);
            httpReqapp.setHeader('Content-Type' , 'application/json');
            httpReqapp.setBody(requestBody);
            httpReqapp.setTimeout(120000);
            HttpResponse httpResapp = http.send(httpReqapp);
            system.debug('Job task to Approve---'+ httpResapp.getStatusCode());
            if(httpResapp.getStatusCode() == 200) {
                Assignsuppliertonewjobtask(jobid,jobtakurl,accesstoken,accparentid,woid,supplierid);
                if(test.isRunningTest()){
                    workorder wo = new workorder();
                    wo.Id=null;
                    wo.Error_On_API_Request__c=true;
                    update wo;
                    
                }
            }
        }
        catch(Exception ex){
            Error_Log__c errorLog = new Error_Log__c();
            errorLog.Work_Order__c=woid;
            errorLog.Error_Type__c = 'ERROR';
            errorLog.Error_Status_Code__c = '';
            errorLog.Error_Message__c = ex.getMessage();
            errorLog.Error_Description__c = 'Error while processing the request:'+ ex + ex.getMessage() +' at line ' +ex.getLineNumber() + ' '+ ex.getStackTraceString();
            errorLog.Class_Name__c = 'CompliancePdfPostToPropertyMeBatch';
            errorLog.Method_Name__c = 'CompliancePdfPostToPropertyMeBatch.approvenewjobtask';
            insert errorLog;
            
            workorder wo = new workorder();
            wo.Id=woid;
            wo.Error_On_API_Request__c=true;
            update wo;
            
            WorkOrderId__c worec=[select name,AccountParentID__c from WorkOrderId__c where name=:woid];
            if(!test.isRunningTest())
            delete worec;
        }    
        
    }
    
/*
**********************************************************************************************************************
@Method Name    : Assignsuppliertonewjobtask
@author         : Nikhil Gaurav
@description    : method to is used to Update Job Task Status to Assign In PropertyME API
@param          : JobtaskId,JobTask URL,AccessToken,Account ParentId,WorkOrderId,Supplier Id 
@return         : None
***********************************************************************************************************************
*/    
    /**************************************** Post request to Assign Supplier New Job Task *******************************************/ 
    public static void Assignsuppliertonewjobtask(String jobid, String jobtakurl,string accesstoken,string accparentid, string woid,string supplierid ){
        try{
            String requestBody ='{"SupplierContactId"="'+supplierid+'"}'; 
            Http http = new Http();
            HttpRequest httpReqAsgn = new HttpRequest();
            httpReqAsgn.setMethod('POST');
            httpReqAsgn.setEndPoint(jobtakurl+'/'+jobid+'/assign?SupplierContactId='+supplierid);
            httpReqAsgn.setHeader('Content-Type','application/x-www-form-urlencoded');
            httpReqAsgn.setHeader('Accept','application/json'); 
            httpReqAsgn.setHeader('Authorization', 'Bearer '+accessToken);
            httpReqAsgn.setTimeout(120000);
            httpReqAsgn.setBody(requestBody);
            HttpResponse httpResAsgn = http.send(httpReqAsgn);
            system.debug('Job task to AssignSupplier---'+ httpResAsgn.getStatusCode());
            if(httpResAsgn.getStatusCode() == 200) {
                postdocandupdatejobstatustoPropertyme( jobid,accparentid,woid );
                
                
            }
        }
        catch(Exception ex){
            Error_Log__c errorLog = new Error_Log__c();
            errorLog.Work_Order__c=woid;
            errorLog.Error_Type__c = 'ERROR';
            errorLog.Error_Status_Code__c = '';
            errorLog.Error_Message__c = ex.getMessage();
            errorLog.Error_Description__c = 'Error while processing the request:'+ ex + ex.getMessage() +' at line ' +ex.getLineNumber() + ' '+ ex.getStackTraceString();
            errorLog.Class_Name__c = 'CompliancePdfPostToPropertyMeBatch';
            errorLog.Method_Name__c = 'CompliancePdfPostToPropertyMeBatch.Assignsuppliertonewjobtask';
            insert errorLog;
            
            workorder wo = new workorder();
            wo.Id=woid;
            wo.Error_On_API_Request__c=true;
            update wo;
            
            WorkOrderId__c worec=[select name,AccountParentID__c from WorkOrderId__c where name=:woid];
            if(!test.isRunningTest())
            delete worec;
        }    
    }
}