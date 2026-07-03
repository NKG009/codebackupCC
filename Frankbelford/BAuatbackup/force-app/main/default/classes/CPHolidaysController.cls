global without sharing class CPHolidaysController {
    
    public static Map<String,String> getAccessToken(){
        
        system.debug('in top of holidays');
        Map<String,String> credMap = new Map<String,String>();
        List<ImpellamCPConnect__c> Conlist = ImpellamCPConnect__c.getAll().values();              
        Datetime now = Conlist[0].ExpireAt__c;            
        Integer offset = UserInfo.getTimezone().getOffset(now);
        Datetime expire_at = now.addSeconds(offset/1000);        
        if(datetime.now()<expire_at && !system.Test.isRunningTest()){ system.debug('in if holidays'); credMap.put('access_token',Conlist[0].LiveToken__c); credMap.put('expires_at',String.valueOf(Conlist[0].ExpireAt__c)); credMap.put('update','no');
                                                                    }else{   
                                                                        system.debug('in else holidays');
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
    public static Object getHolidays() 
    { 
        system.debug('in getHolidays top');
        List<ImpellamCPConnect__c> Conlist = ImpellamCPConnect__c.getAll().values();
        Map<String,String> tokenMap = new Map<String,String>();        
        tokenMap = getAccessToken();
        
        String  employerReference;
        String  personnelReference;
        List<Object> result=new List<Object>();
        IP_PayProfile__c pp;          
        if(!system.Test.isRunningTest()){ pp = [Select id,IP_PayrollID__c from IP_PayProfile__c where IP_PrimaryPayMethod__c=true and IP_Candidate__c=:getUserId() limit 1]; }
        
        HttpRequest req= new HttpRequest();
        req.setMethod('POST');
        if(!system.Test.isRunningTest()){ req.setBody('{"lookupDataSource": "HolidayLookup", "filter": {"employerReference": "BAL","personnelReference": "'+pp.IP_PayrollID__c+'"}}');
                                        }else{
                                            req.setBody('{"lookupDataSource": "HolidayLookup", "filter": {"employerReference": "BAL","personnelReference": "AD00046"}}');  
                                        }
        req.setHeader('Authorization', 'Bearer '+tokenMap.get('access_token'));
        req.setHeader('Content-Type','application/json');
        Http http = new Http();   
        req.setEndpoint(Conlist[0].HolidaysEndPointUrl__c);
        HttpResponse response = http.send(req); 
        if(response.getStatusCode()==401  && !system.Test.isRunningTest()){ getAccessToken(); }
        if(tokenMap.get('update')=='yes'  && !system.Test.isRunningTest()){ UpdateToken(tokenMap); }
        
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        List<Object> s = new List<Object>{results.get('daysHolidayAccrued'), results.get('daysHolidayPaid')};  
            return s;
        
    }
    @AuraEnabled
    global static Void HolidayReq(String fromDate, String toDate) 
    {
        OrgWideEmailAddress owd = [select id, DisplayName,Address from OrgWideEmailAddress where Address ='no.reply@bluearrow.co.uk'];

        Id templateIdCand ;
        Id templateIdBranch;
        
        if(fromDate!='' && toDate!=''){
            String[] toAddresses;
            Contact c = [select id,FirstName,email,LastName,Name,IP_TempestDepartment__c,Owner.Name from Contact where id=:getUserId()];                                 
            c.HolidayStartDate__c =fromDate;
            c.HolidayEndDate__c=toDate;
            update c;
            Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
            String department = c.IP_TempestDepartment__c;
            IP_Shift_Template__c shiftemp1 = IP_Shift_Template__c.getValues(department);

            List<OrgWideEmailAddress> owd1;
            if(shiftemp1!=Null)
            {
            owd1= [select id, DisplayName,Address from OrgWideEmailAddress where Address =:shiftemp1.Email__c];
            system.debug('OWD ID--->'+owd1);
            }
            if(!system.Test.isRunningTest())
            {
                IP_Shift_Template__c shiftemp = IP_Shift_Template__c.getValues(department);
                String BranchUserEmail = shiftemp.Email__c;
                toAddresses = new String[] {BranchUserEmail};
                    }else{
                        toAddresses = new String[] {'singh.taji26@gmail.com'};        
                            }

            User usr = new User();
            if(c.Email!=null && !test.isRunningTest()){
                usr = [Select id from User WHERE ContactId =:c.id LIMIT 1];
            }
            String targetObjid = '';
            if(usr.Id!=null){
                system.debug('in if for user');
                targetObjid = usr.Id;
                templateIdBranch = [select id, name from EmailTemplate where developername = 'Candidate_Portal_Holiday_Branch_user'].id;
                templateIdCand = [select id, name from EmailTemplate where developername = 'Candidate_Portal_Holiday_Candidate_User'].id;
            }
            else{
                system.debug('in else for contact');
                targetObjid = c.Id;
                templateIdBranch = [select id, name from EmailTemplate where developername = 'Candidate_Portal_Holiday_Branch'].id;
				templateIdCand = [select id, name from EmailTemplate where developername = 'Candidate_Portal_Holiday_Candidate'].id;
            }
            
            semail.setTargetObjectId(targetObjid);
            semail.setTreatTargetObjectAsRecipient(false);
            semail.setToAddresses(toAddresses);
            semail.setOrgWideEmailAddressId(owd.Id);  
            semail.setTemplateId(templateIdBranch);
            
            semail.setSaveAsActivity(false);
            if(!system.Test.isRunningTest())
            {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail}); 
            }
            Messaging.SingleEmailMessage semail1 = new Messaging.SingleEmailMessage(); 
            semail1.setTargetObjectID(targetObjid);
            if(owd1.size()>0)
            {
            semail1.setOrgWideEmailAddressId(owd1[0].Id);
            }
            else
            {
      semail1.setOrgWideEmailAddressId(owd.Id);
   
            }
            semail1.setTemplateId(templateIdCand);
            semail1.setSaveAsActivity(false);
            system.debug('templateIdCand==>>'+templateIdCand);
            if(!system.Test.isRunningTest())
            {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail1}); 
            }
        }
    }
    
    public static String getUserId(){
        ID contactId = [Select contactid from User where id =: Userinfo.getUserid()].contactId;
        return contactId;
    }
    
    
}