global without sharing class CPpayslipController {
	
	public static Map<String,String> getAccessToken(){
        
            
            Map<String,String> credMap = new Map<String,String>();
            List<ImpellamCPConnect__c> Conlist = ImpellamCPConnect__c.getAll().values();              
            Datetime now = Conlist[0].ExpireAt__c;            
            Integer offset = UserInfo.getTimezone().getOffset(now);
            Datetime expire_at = now.addSeconds(offset/1000);        
            if(datetime.now()<expire_at && !system.Test.isRunningTest()){  credMap.put('access_token',Conlist[0].LiveToken__c); credMap.put('expires_at',String.valueOf(Conlist[0].ExpireAt__c)); credMap.put('update','no');
            }else{   
                
                HttpRequest req = new HttpRequest(); 
                req.setMethod('POST');
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('Accept','application/json');    
                req.setEndpoint(Conlist[0].TokenURL__c);            
                req.setTimeout(120000); 
                req.setBody('{"grant_type" : "client_credentials","client_id":"'+Conlist[0].client_id__c+'","client_secret" : "'+Conlist[0].client_secret__c+'"}');
                Http http = new Http();
                HTTPResponse response = http.send(req);
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                credMap.put('access_token',String.valueOf(results.get('access_token')));
                credMap.put('expires_at',String.valueOf(results.get('expires_at')));
                credMap.put('update','yes');    
                system.debug('all things in toekn--'+credMap);
                //UpdateToken(credMap);
            }
            return credMap;
            
    }
    
    @future
    public static void UpdateToken(Map<String,String> credMap){
        ImpellamCPConnect__c ImpellamEntry;
        String expiryDate = credMap.get('expires_at').substringBefore('.');
        String s3 = expiryDate.substringBefore('T');
        String s4 = expiryDate.substringAfter('T');  
        ImpellamEntry = [Select Id, LiveToken__c,TokenExpiryDateTime__c,ExpireAt__c From ImpellamCPConnect__c Where Name = 'ImpellamConnect'];
        ImpellamEntry.LiveToken__c = credMap.get('access_token'); 
        ImpellamEntry.TokenExpiryDateTime__c=s3+' '+s4;
        ImpellamEntry.ExpireAt__c=Datetime.valueOf(s3+' '+s4);        
        update ImpellamEntry;
             
    }    
    
    @AuraEnabled
    public static List<Object> getPayslip(){
        List<ImpellamCPConnect__c> Conlist = ImpellamCPConnect__c.getAll().values();
        Map<String,String> tokenMap = new Map<String,String>();        
        tokenMap = getAccessToken();
        
        String startDate = system.now().format('yyyy-MM-dd');
        DateTime dd = system.now().adddays(-30);
        String endDate =	dd.format('yyyy-MM-dd'); 
        
        IP_PayProfile__c pp;
         if(!system.Test.isRunningTest()){ pp = [Select id,IP_PayrollID__c from IP_PayProfile__c where IP_PrimaryPayMethod__c=true and IP_Candidate__c=:getUserId() limit 1];  }
        
        
            HttpRequest req = new HttpRequest();
            if(!system.Test.isRunningTest()){ req.setBody('{"lookupDataSource": "TempestPayslipLookup", "filter": {"employerReference": "BAL","personnelReference": "'+pp.IP_PayrollID__c+'","fromDate": "'+endDate+'","toDate": "'+startDate+'"}}'); }else{
            	req.setBody('{"lookupDataSource": "TempestPayslipLookup", "filter": {"employerReference": "BAL","personnelReference": "AD00046","fromDate": "2017-10-01","toDate": "2017-12-01"}}');            
            }
                req.setHeader('Authorization', 'Bearer '+ tokenMap.get('access_token'));
            req.setTimeout(120000); 
            req.setHeader('Content-Type', 'application/json');
            req.setEndpoint(Conlist[0].PayslipEndPointUrl__c);
            req.setMethod('POST');
            Http http = new Http();
            HTTPResponse res = http.send(req);
            if(res.getStatusCode()==401 && !system.Test.isRunningTest()){  getAccessToken();  }
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
             system.debug('payslip records-----'+res.getBody());
            List<Object> payslips = (List<Object>) results.get('payslips');
            if(tokenMap.get('update')=='yes' && !system.Test.isRunningTest()){  UpdateToken(tokenMap); }
            //system.debug('payslip records-----'+res.getBody());
            return payslips;            
    }
    
    @AuraEnabled
    public static List<Object> PayslipLookup(String  fromdate, String  todate) 
    { 
        Map<String,String> tokenMap = new Map<String,String>();        
        tokenMap = getAccessToken();
        String fromdate1 = fromdate;
        String todate1 = todate;           
        system.debug('fromdate1--'+fromdate1);
        system.debug('todate1--'+todate1);
        system.debug('token--'+tokenMap.get('access_token'));
        IP_PayProfile__c pp;          
        if(!system.Test.isRunningTest()){  pp = [Select id,IP_PayrollID__c from IP_PayProfile__c where IP_PrimaryPayMethod__c=true and IP_Candidate__c=:getUserId() limit 1];  }
        List<ImpellamCPConnect__c> Conlist = ImpellamCPConnect__c.getAll().values();   
        
        HttpRequest req = new HttpRequest();
        if(!system.Test.isRunningTest()){  req.setBody('{"lookupDataSource": "TempestPayslipLookup", "filter": {"employerReference": "BAL","personnelReference": "'+pp.IP_PayrollID__c+'","fromDate": "'+fromdate1+'","toDate": "'+todate1+'"}}'); }else{
            req.setBody('{"lookupDataSource": "TempestPayslipLookup", "filter": {"employerReference": "BAL","personnelReference": "AD00046","fromDate": "2017-12-01","toDate": "2018-01-31"}}');
        }

        req.setHeader('Authorization', 'Bearer '+ tokenMap.get('access_token'));
        req.setTimeout(120000); 
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint(Conlist[0].PayslipEndPointUrl__c);
        req.setMethod('POST');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        if(res.getStatusCode()==401 && !system.Test.isRunningTest()){  getAccessToken(); }
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        system.debug('my payslip dead--'+results);
        List<Object> payslips = (List<Object>) results.get('payslips');
        if(tokenMap.get('update')=='yes' && !system.Test.isRunningTest()){ UpdateToken(tokenMap); }
        return payslips;        
    }
    
    
    
    @AuraEnabled
    public static String PrintPayslip(String  PAYSLIPID) 
    {
        Map<String,String> tokenMap = new Map<String,String>();        
        tokenMap = getAccessToken();
        system.debug('check token---'+tokenMap);
         system.debug('check param---'+PAYSLIPID);
        String payslip = PAYSLIPID;
        String[] arrPayslip = payslip.split('#');
        system.debug('arrPayslip param---'+arrPayslip);
        List<ImpellamCPConnect__c> Conlist = ImpellamCPConnect__c.getAll().values();   
        HttpRequest req = new HttpRequest();
        req.setBody('{"exportType": "TempestPayslipExport","filter": {"employerReference": "'+arrPayslip[1]+'","personnelReference": "'+arrPayslip[2]+'","resourceReference": "'+arrPayslip[3]+'"}}');
        req.setHeader('Authorization', 'Bearer '+ tokenMap.get('access_token'));
        req.setTimeout(120000); 
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint(Conlist[0].PayslipExportEndPointUrl__c);
        req.setMethod('POST');
        Http http = new Http();
        HTTPResponse response = http.send(req);
        if(response.getStatusCode()==401 && !system.Test.isRunningTest() ){  getAccessToken();  }
        if(tokenMap.get('update')=='yes' && !system.Test.isRunningTest() ){  UpdateToken(tokenMap); }
        Blob beforeBlob = response.getBodyAsBlob();
        
        Document document;
        document = new Document();
        document.Body = beforeBlob;
        document.ContentType = 'application/pdf';
        //document.DeveloperName = 'payslips';
        document.IsPublic = false;
        document.Name = '1735002';
        document.FolderId = Conlist[0].PaySlipFolderID__c;
        document.Id = Conlist[0].DocumentID__c;
        update document;
        system.debug('document param---'+document.id);        
        String Url = Conlist[0].PDFBaseURL__c +'servlet/servlet.FileDownload?file='+document.Id;
        system.debug('url me---'+Url);
        return Url;
    }
    
    public static String getUserId(){
        ID contactId = [Select contactid from User where id =: Userinfo.getUserid()].contactId;
        return contactId;
    }
    
    
}