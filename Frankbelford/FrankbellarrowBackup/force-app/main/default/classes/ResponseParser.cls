public class ResponseParser {
    public class FrostResponse{
        public String FrostId;
        public String CostCode;
       
    }
    public class gdprResponse{
         Public String access_token;
        public String token_type;
        
    }
        public class Consentcallresponse1{
         Public String registrationState; 
          public List<String> validationErrors;
    }
    public class Consentcallresponse{
         Public String registrationState; 
    }
  
     public class Consentrecieveresponse{
         Public String sourceIdentifier; 
         Public Datetime consentOptionsLastUpdateDate;
         Public Datetime consentOptionsLastUpdatedBy;
       //  Public consentoptn consentOptions;        
    }

     public class consentrecieved{
       Public String sourceIdentifier; 
     //  Public consentoptn consentOptions;
         Public Datetime consentOptionsLastUpdateDate;
         Public String consentOptionsLastUpdatedBy;
    }
     /*   public class consentoptn{
        public boolean Phone; 
        public boolean SMS; 
        public boolean Email; 
        public boolean Post; 
        public boolean CriminalConviction; 
        public boolean health; 
        public boolean MedicalHistory;
        public boolean Equalops; 
    }*/
    
}