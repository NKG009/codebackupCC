global class ConsentDateSynchBatch1 extends batchjobsch.BatchJobBase implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful{
    
            List<Contact> con = new List<Contact>();
        
    
   global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return DataBase.getQueryLocator([Select id,IP_Phone__c,IP_Consent_entered_by__c,IP_Consent_from_Data_Store__c,IP_SMS__c,IP_Email__c,IP_Post__c,IP_Criminal_Conviction__c,IP_Health_Reasonable_Adjustments__c,IP_Medical_History__c,IP_Equal_Ops__c from Contact limit 1]);
        //return MainAcounts;
    }
    global void execute(Database.BatchableContext BC,List<Contact> scope)
    {
        String callresult;
    String datecheck;
        Requestbody.GdprData req = new Requestbody.GdprData();
        req.grant_type  = 'client_credentials';
        req.client_id = 'e7838bae08a24a08b51b0a0b378cfed363280d993367457689e008f74c46b3a1';
        req.client_secret = '33907fc327cd46e696f35dac31ac089c';
        
        String JSONBody = JSON.serialize(req); 
        
         System.debug('JSON Body-->'+JSONBody);
         string endpoint = 'https://prod-integration-dx.impellamapi.com/api/v1/oAuth2/token';
         Map<String,String> loginheaders = new Map<String, String>();
         loginheaders.put('Content-Type', 'application/json;charset=UTF-8');
         
         HttpResponse res = RestCalloutUtil.MakeCallout(endpoint, 'POST', JSONBody, loginheaders);
        
        system.debug('@@response body '+res.getBody());


        Datetime dt = System.now().addhours(-1);
        //Datetime dt = System.now()-16;
        system.debug('Old date'+dt);
        Datetime dt1 = dt;
    
        ResponseParser.gdprResponse responsegdpr =(ResponseParser.gdprResponse)System.JSON.deserialize(res.getBody(), ResponseParser.gdprResponse.class);
        
           System.Debug('Respone--> '+responsegdpr);
           Requestbody.consentlookup req1 = new Requestbody.consentlookup();
           Requestbody.filters req2 = new Requestbody.filters();
                     
           req1.lookupDataSource = 'ConsentRegistrationLookupByDateRange';
           req2.brandname = 'Blue Arrow';
           req2.fromdate = dt;
           req2.todate = System.now(); 
           req2.useUpdateDateOnly = true;          
           req1.filter= req2;
           String JSONBody1 = JSON.serialize(req1);
           Map<String,String> headers = new Map<String, String>();
           headers.put('Content-Type', 'application/json;charset=UTF-8');
           headers.put('Authorization', 'Bearer '+ responsegdpr.access_token);     
           System.debug('Request Body'+req1);
           String endpoint2 = 'https://prod-integration-dx.impellamapi.com/api/v1/consentregistrations/lookup';
                  
         HttpResponse res1 = RestCalloutUtil.MakeCallout(endpoint2, 'POST', JSONBody1, headers); 
         System.debug('**Response Recieved**'+res1.getbody());
         String json12 = res1.getbody();
        ContactWrper conParse = (ContactWrper)System.JSON.deserialize(json12, ContactWrper.class);
       // System.debug('Check data '+conParse.consentRegistrations.size());
       // System.debug('Check value' + conParse.consentRegistrations[0]);
        Map<id,Boolean> phonemap = new Map<id,Boolean>();
        Map<id,Boolean> smsmap = new Map<id,Boolean>();
        Map<id,Boolean> postmap = new Map<id,Boolean>();
        Map<id,Boolean> emailmap = new Map<id,Boolean>();
        Map<id,Boolean> medmap = new Map<id,Boolean>();
        Map<id,Boolean> healthmap = new Map<id,Boolean>();
        Map<id,Boolean> criminalconmap = new Map<id,Boolean>();
        Map<id,Boolean> equalopsmap = new Map<id,Boolean>();
        Map<id,Datetime> consentdatemap = new Map<id,Datetime>();
        Map<id,String> consentbymap = new Map<id,String>();
        Set<id> contactid = new set<id>();
    System.debug('@@ size '+conParse.consentRegistrations.size());
        if(conParse.consentRegistrations.size()>0)
        {
        for (integer i=0 ;i<conParse.consentRegistrations.size();i++)
        {
            contactid.add(conParse.consentRegistrations[i].sourceidentifier);
            if(conParse.consentRegistrations[i].consentOptions!=null)
            {          
            phonemap.put(conParse.consentRegistrations[i].sourceidentifier,conParse.consentRegistrations[i].consentOptions.Phone);
            smsmap.put(conParse.consentRegistrations[i].sourceidentifier,conParse.consentRegistrations[i].consentOptions.SMS);
            postmap.put(conParse.consentRegistrations[i].sourceidentifier,conParse.consentRegistrations[i].consentOptions.Post);
            emailmap.put(conParse.consentRegistrations[i].sourceidentifier,conParse.consentRegistrations[i].consentOptions.Email);
            medmap.put(conParse.consentRegistrations[i].sourceidentifier,conParse.consentRegistrations[i].consentOptions.MedicalHistory);  
            healthmap.put(conParse.consentRegistrations[i].sourceidentifier,conParse.consentRegistrations[i].consentOptions.MedicalOther);
            criminalconmap.put(conParse.consentRegistrations[i].sourceidentifier,conParse.consentRegistrations[i].consentOptions.CRBCHECK);
            equalopsmap.put(conParse.consentRegistrations[i].sourceidentifier,conParse.consentRegistrations[i].consentOptions.EQUALOPS);
            consentdatemap.put(conParse.consentRegistrations[i].sourceidentifier,conParse.consentRegistrations[i].consentOptionsLastUpdateDate);
            consentbymap.put(conParse.consentRegistrations[i].sourceidentifier,conParse.consentRegistrations[i].consentOptionsLastUpdatedBy);
           }
        }
        con = [Select id,IP_Phone__c,IP_Consent_entered_by__c,IP_Consent_from_Data_Store__c,IP_GDPRContactedCandidate__c,IP_LastContactedGDPR__c,IP_SMS__c,IP_Email__c,IP_Post__c,IP_Criminal_Conviction__c,IP_Health_Reasonable_Adjustments__c,IP_Medical_History__c,IP_Equal_Ops__c from Contact where id in:contactid];
        
        for(contact c: con)
        {
        System.debug('check candidate time'+c.IP_Consent_from_Data_Store__c);
        System.debug('check data store time'+consentdatemap.get(c.id));
        if(c.IP_Consent_from_Data_Store__c != consentdatemap.get(c.id))
        {
        if(phonemap.get(c.id)!=null)
        {
        c.IP_Phone__c = phonemap.get(c.id);
        }
        if(smsmap.get(c.id)!=null)
        {
        c.IP_SMS__c = smsmap.get(c.id);
        }
        if(postmap.get(c.id)!=null)
        {
        c.IP_Post__c = postmap.get(c.id);
        }
        if(emailmap.get(c.id)!=null)
        {
        c.IP_Email__c = emailmap.get(c.id);
        }
        if(medmap.get(c.id)!=null)
        {
        c.IP_Medical_History__c = medmap.get(c.id);
        }
        if(healthmap.get(c.id)!=null)
        {
        c.IP_Health_Reasonable_Adjustments__c = healthmap.get(c.id);
        }
        if(criminalconmap.get(c.id)!=null)
        {
        
        c.IP_Criminal_Conviction__c = criminalconmap.get(c.id);
        }
        if(equalopsmap.get(c.id)!=null)
        {
        c.IP_Equal_Ops__c = equalopsmap.get(c.id);
        }
        if(consentdatemap.get(c.id)!=null)
        {
         datecheck = String.ValueOf(consentdatemap.get(c.id));
      
       c.IP_Consent_from_Data_Store__c = Datetime.ValueOf(datecheck);
      
    /*   if(c.IP_UserTimezone__c == 1)
        {
       
        c.IP_Consent_from_Data_Store__c = Datetime.ValueOf(datecheck).addhours(-1);
        System.debug('Check candidate value'+datecheck);
        }
        else
        {
         c.IP_Consent_from_Data_Store__c = Datetime.ValueOf(datecheck);
        System.debug('Check candidate value'+datecheck);
        }*/
        }
        if(consentbymap.get(c.id)!=null)
        {
        c.IP_Consent_entered_by__c = consentbymap.get(c.id);
        }
        }
        if(c.IP_GDPRContactedCandidate__c == false)
        {
            c.IP_GDPRContactedCandidate__c  = true;
        }
        if(c.IP_LastContactedGDPR__c == null || c.IP_LastContactedGDPR__c < consentdatemap.get(c.id))
        {
            c.IP_LastContactedGDPR__c  =  Date.valueOf(consentdatemap.get(c.id));
        }
        }
  //  update con;
}
}
    
    
    global void finish(Database.BatchableContext BC)
    {        
        System.debug('**Finish method**'+con);
        Database.executeBatch(new ConsentDateSynchBatch(con),1);
        super.finishBatch(BC);
     
    }

}