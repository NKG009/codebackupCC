public class Requestbody {
    public class GdprData
    {
        Public String grant_type;
        Public String client_id;
        Public String client_secret;
    }
    
    public class Candidatedata
    {
        public string brandName; 
        public string sourceIdentifier; 
        public string workerReference1;
        public string forename; 
        public string surname; 
        public string emailAddress; 
        public string addressLine1; 
        public string addressLine2; 
        public string city; 
        public string county; 
        public string postcode; 
        public DateTime consentOptionsLastUpdateDate;
        public string mobileNumber; 
        public string telephoneNumber;
        public boolean sendEmailRequest;         
         public consentOption consentOptions;
        
    }
      public class consentOption
{
public boolean Phone; 
public boolean SMS; 
public boolean Email; 
public boolean Post; 
public boolean CRBCHECK; 
public boolean MedicalOther; 
public boolean MedicalHistory;
public boolean EQUALOPS; 

}
    
    public class consentlookup
    {
        public string lookupDataSource; 
        public filters filter;
    }
    public class filters
    {
        public string brandname; 
        public string sourceIdentifier;    
        public Datetime fromdate;
        public Datetime toDate;
        public Boolean useUpdateDateOnly;       
    }
    public class consentdelete
    {
        public string deleteType; 
        public filtersdel filter;
    }
    public class filtersdel
    {
        public string brandname; 
        public string sourceIdentifier;    
        public string actionedBy;
    }
}