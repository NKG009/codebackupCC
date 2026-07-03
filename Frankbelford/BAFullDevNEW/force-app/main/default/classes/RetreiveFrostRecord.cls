public class RetreiveFrostRecord {
    /*
@future (Callout = true)            
public static void restCalloutfor2ndtier(ID contactID)
{
List<Contact> contactList = [select id, name,LastName,FirstName,MailingStreet,MailingCity,MailingCountry,
MailingPostalCode,Birthdate,Title,Phone_Type__c,Initials__c,sirenum__National_Insurance__c,
ts2__EEO_Gender__c,Phone,IP_CandidateIDlegacy__c
from Contact 
where id=:contactID 
and RecordType.DeveloperName ='IP_2ndTierCandidate' 
and IP_CandidateIDlegacy__c=null
limit 1];
system.debug('contactList --->'+contactList );
if(!contactList.isEmpty()){
Contact con = contactList[0];
if(con.FirstName!=null && con.LastName!=null && con.Birthdate!=null && con.sirenum__National_Insurance__c!=null && con.ts2__EEO_Gender__c!=null && con.IP_CandidateIDlegacy__c ==null){
RequestParser.FrostCandidateRequest req = new RequestParser.FrostCandidateRequest();

req.LastName = con.LastName; // @Surname char (20)
req.FirstName = con.FirstName; // @Forename char (20)
req.Address1 =  ''; //@Address char (100)
req.Address2 =  con.MailingStreet; //@Address2 char (100)
req.Town =  con.MailingCity; //@PostTown char (100)
req.County =  con.MailingCountry; //@County char (100)
req.PostCode =  con.MailingPostalCode; //@Postcode char (24)
req.Phone = con.Phone; //@Telephone varchar(80)
req.DOB = con.Birthdate; //@DOB smalldatetime
req.PhoneType = con.Phone_Type__c; //@PhoneType char (20)
req.Title = con.Title; //@Title char (4)
req.Initials = con.Initials__c; //@Initials char (4)
req.Gender = con.ts2__EEO_Gender__c; //@Sex char (1)
req.Nino = con.sirenum__National_Insurance__c; //@NiNo char (9)
req.Controller = ''; //@Controller char (30)
req.ControllerId = ''; //ControllerID varchar(8)
req.LensKey = ''; //varchar 20

String JSONBody = JSON.serialize(req); 

System.debug('JSON Body-->'+JSONBody);
string endpoint = 'callout:FrostCommunication';
Map<String,String> headers = new Map<String, String>();
headers.put('Content-Type', 'application/json;charset=UTF-8');
headers.put('Authorization', Label.Authorization);
HttpResponse res = RestCalloutUtil.MakeCallout(endpoint, 'POST', JSONBody, headers);//string strJson, headers)
ResponseParser.FrostResponse responseFrostID =(ResponseParser.FrostResponse)System.JSON.deserialize(res.getbody(), ResponseParser.FrostResponse.class);
System.Debug('Respone-->'+responseFrostID);
con.IP_CandidateIDlegacy__c = responseFrostID.FrostId;
update con;
}
}

}
*/ 
    @future (Callout = true)            
    public static void restCalloutforPayProfile(ID payProfileId)
    {
        List<IP_PayProfile__c> payProfileList = [select id,name,IP_PayrollID__c,IP_Candidate__r.Salutation,IP_Candidate__c,IP_CompanyName__c,IP_CompanyRegNo__c,IP_VATRegistered__c,IP_VATNumber__c,IP_OkToSupply__c,
                                                 IP_Candidate__r.LastName,IP_Candidate__r.FirstName,IP_Candidate__r.MailingStreet,IP_Candidate__r.MailingCity,IP_Candidate__r.MailingCountry,
                                                 IP_Candidate__r.MailingPostalCode,IP_Candidate__r.Birthdate,IP_Candidate__r.Title,IP_Candidate__r.Phone_Type__c,IP_Candidate__r.Initials__c,
                                                 IP_Candidate__r.sirenum__National_Insurance__c,IP_Candidate__r.EEO_Gender__c,IP_Candidate__r.Phone,IP_Candidate__r.IP_CandidateIDlegacy__c,
                                                 IP_Candidate__r.IP_CategoryOfWork__c
                                                 from IP_PayProfile__c 
                                                 where id=:payProfileId 
                                                 and IP_PayrollID__c=null
                                                 and IP_Candidate__r.RecordType.DeveloperName ='Candidate' 
                                                 limit 1];
        if(!payProfileList.isEmpty()){
            
            IP_PayProfile__c payProfile = payProfileList[0];
            system.debug('payProfileList --->'+payProfileList );
            if(payProfile.IP_Candidate__r.LastName!=null && payProfile.IP_Candidate__r.FirstName!=null && payProfile.IP_Candidate__r.Birthdate!=null && payProfile.IP_Candidate__r.sirenum__National_Insurance__c!=null  && 
               payProfile.IP_PayrollID__c ==null){/*
RequestParser.LtdCompanyRequest ltdCompany = new RequestParser.LtdCompanyRequest();
ltdCompany.Name = payProfile.IP_CompanyName__c; // @LtdCompanyName varchar(50) IP_CompanyRegNo__c
ltdCompany.RegNo = payProfile.IP_CompanyRegNo__c; // @LtdCompanyRegNo varchar(15)
ltdCompany.SignedByWorker = 1; // @LtdSignedByWorker tinyint
ltdCompany.SignedByCompany = 1; // @LtdSignedByCompany tinyint
if(payProfile.IP_VATRegistered__c)
ltdCompany.CompanyVatRegistered = 1; // @LtdCompanyVatRegistered tinyint
else
ltdCompany.CompanyVatRegistered = 0; // @LtdCompanyVatRegistered tinyint
ltdCompany.CompanyVATRegNo = payProfile.IP_VATNumber__c; // @LtdCompanyVATRegNo varchar(15)
ltdCompany.OkToSupply = Integer.valueOF(payProfile.IP_OkToSupply__c); // @LtdOkToSupply tinyint -- Users can not change this (only Back Office)

*/
                   RequestParser.FrostCandidateRequest req = new RequestParser.FrostCandidateRequest();
                   req.LastName = payProfile.IP_Candidate__r.LastName; // @Surname char (20)
                   req.FirstName = payProfile.IP_Candidate__r.FirstName; // @Forename char (20)
                   req.Address1 =  ''; //@Address char (100)
                   req.Address2 =  payProfile.IP_Candidate__r.MailingStreet; //@Address2 char (100)
                   req.Town =  payProfile.IP_Candidate__r.MailingCity; //@PostTown char (100)
                   req.County =  payProfile.IP_Candidate__r.MailingCountry; //@County char (100)
                   req.PostCode =  payProfile.IP_Candidate__r.MailingPostalCode; //@Postcode char (24)
                   req.Phone = payProfile.IP_Candidate__r.Phone; //@Telephone varchar(80)
                   req.DOB = payProfile.IP_Candidate__r.Birthdate; //@DOB smalldatetime
                   req.PhoneType = payProfile.IP_Candidate__r.Phone_Type__c; //@PhoneType char (20)
                   req.Title = payProfile.IP_Candidate__r.Salutation; //@Title char (4)
                   req.Initials = payProfile.IP_Candidate__r.Initials__c; //@Initials char (4)
                   req.Gender = payProfile.IP_Candidate__r.EEO_Gender__c; //@Sex char (1)
                   req.Nino = payProfile.IP_Candidate__r.sirenum__National_Insurance__c; //@NiNo char (9)
                   req.Controller = ''; //@Controller char (30)
                   req.ControllerId = ''; //ControllerID varchar(8)
                   req.LensKey = ''; //varchar 20
                   //req.LtdCompany = ltdCompany;
                   List<String> strpicklist = payProfile.IP_Candidate__r.IP_CategoryOfWork__c.split(';');
                   For(String s : strpicklist){
                       if(s == 'Catering')
                           req.Catering = 1; //@Catering int
                       else if(s == 'Industrial')
                           req.Industrial = 1; //@Industrial int
                       else if(s == 'Commercial')
                           req.Technical = 1; //@Catering int
                   }
                   String JSONBody = JSON.serialize(req); 
                   
                   System.debug('JSON Body-->'+JSONBody);
                   string endpoint = 'callout:FrostCommunication';
                   Map<String,String> headers = new Map<String, String>();
                   headers.put('Content-Type', 'application/json;charset=UTF-8');
                   headers.put('Authorization', Label.Authorization);
                   HttpResponse res = RestCalloutUtil.MakeCallout(endpoint, 'POST', JSONBody, headers);//string strJson, headers)
                   ResponseParser.FrostResponse responseFrostID =(ResponseParser.FrostResponse)System.JSON.deserialize(res.getbody(), ResponseParser.FrostResponse.class);
                   System.Debug('Respone-->'+responseFrostID);
                   payProfile.IP_PayrollID__c = responseFrostID.FrostId;
                   payProfile.IP_Branch_Code__c= responseFrostID.CostCode;
                   if(Test.isRunningTest()){
                   payProfile.IP_PayrollID__c =null;
                   }
                   update payProfile;
               }
        } 
    }
    
}