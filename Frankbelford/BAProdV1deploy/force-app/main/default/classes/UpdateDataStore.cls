public class UpdateDataStore
{
@future(callout=true)
public static void sendconsentdata(Set<id> consentupdates){
            String callresult;
                String callresult1;
        Requestbody.GdprData req = new Requestbody.GdprData();
        req.grant_type  = 'client_credentials';
        req.client_id = 'e7838bae08a24a08b51b0a0b378cfed363280d993367457689e008f74c46b3a1';
        req.client_secret = '33907fc327cd46e696f35dac31ac089c';
        
        String JSONBody = JSON.serialize(req); 
        
         System.debug('JSON Body-->'+JSONBody);
         string endpoint = 'https://prod-integration-dx.impellamapi.com/api/v1/oauth2/token';
         Map<String,String> loginheaders = new Map<String, String>();
         loginheaders.put('Content-Type', 'application/json;charset=UTF-8');
         
         HttpResponse res = RestCalloutUtil.MakeCallout(endpoint, 'POST', JSONBody, loginheaders);
        
        system.debug('@@response body '+res.getBody());
        ResponseParser.gdprResponse responsegdpr =(ResponseParser.gdprResponse)System.JSON.deserialize(res.getbody(), ResponseParser.gdprResponse.class);
        
         System.Debug('Respone--> '+responsegdpr);
         Contact con = [Select id,IP_18DigitID__c,FirstName,IP_Last_Consent_Requested_By__c,IP_Consent_from_Data_Store__c,IP_Last_Consent_Requested__c,IP_CandidateIDlegacy__c,IP_Phone__c,IP_Criminal_Conviction__c,IP_Email__c,IP_Equal_Ops__c,IP_Health_Reasonable_Adjustments__c,IP_Medical_History__c,IP_Post__c,IP_SMS__c,LastName,email,IP_MailingAddressLine1__c,IP_MailingAddressLine2__c,MailingCity,MailingState,MailingPostalcode,MobilePhone,Phone From Contact where id in :consentupdates];
         Requestbody.Candidatedata req1 = new Requestbody.Candidatedata();
          Requestbody.consentOption req2 = new Requestbody.consentOption();
           req2.Phone = con.IP_Phone__c;
           req2.SMS= con.IP_SMS__c;
           req2.Email = con.IP_Email__c;
           req2.Post = con.IP_Post__c;
           req2.CRBCHECK= con.IP_Criminal_Conviction__c;
           req2.MedicalOther= con.IP_Health_Reasonable_Adjustments__c;
           req2.MedicalHistory = con.IP_Medical_History__c;
           req2.EQUALOPS= con.IP_Equal_Ops__c;
            req1.brandName = 'Blue Arrow';
            req1.SourceIdentifier = con.IP_18DigitID__c; 
            req1.workerReference1 = con.IP_CandidateIDlegacy__c;
            req1.forename = con.Firstname;
            req1.surname = con.Lastname;
            req1.emailAddress = con.email;
            req1.addressLine1 = con.IP_MailingAddressLine1__c;
            req1.addressLine2 = con.IP_MailingAddressLine2__c;
            req1.city = con.MailingCity;
            req1.county = con.MailingState;
            req1.postcode = con.MailingPostalcode;
            req1.mobileNumber = con.MobilePhone;
            req1.telephoneNumber = con.Phone;
            req1.sendEmailRequest = false;
            req1.consentOptionsLastUpdateDate = con.IP_Consent_from_Data_Store__c;
            req1.consentOptions= req2;            
            String JSONBody1 = JSON.serialize(req1);
         Map<String,String> headers = new Map<String, String>();
         headers.put('Content-Type', 'application/json;charset=UTF-8');
         headers.put('Authorization', 'Bearer '+ responsegdpr.access_token);     
        System.debug('Request Body'+req1);
         string endpoint2 = 'https://prod-integration-dx.impellamapi.com/api/v1/consentregistrations/import';
        
         HttpResponse res1 = RestCalloutUtil.MakeCallout(endpoint2, 'POST', JSONBody1, headers); 
         System.debug('**Response check**'+res1.getStatusCode());
         System.debug('**Response Recieved**'+res1.getbody());    
         if(res1.getStatusCode() == 200)
         {           
         ResponseParser.Consentcallresponse responsestate =(ResponseParser.Consentcallresponse)System.JSON.deserialize(res1.getbody(), ResponseParser.Consentcallresponse.class);
         System.Debug('Respone-->'+responsestate);
         callresult = responsestate.registrationState;
         }
         else
         {
            ResponseParser.Consentcallresponse1 responsestate =(ResponseParser.Consentcallresponse1)System.JSON.deserialize(res1.getbody(), ResponseParser.Consentcallresponse1.class);
            callresult = responsestate.validationErrors[0]; 
         }
        // return callresult;    
         
        /* if(responsestate.validationErrors.size()>0 && res1.getStatusCode()!= 200)
         {
          callresult = responsestate.validationErrors[0];
         }
         else
         {
         callresult = responsestate.registrationState;
         }
         System.Debug('Variable-->'+callresult );
         System.Debug('Variable-->'+callresult1 );
         System.debug('check size'+responsestate.validationErrors.size());*/
         
}


}