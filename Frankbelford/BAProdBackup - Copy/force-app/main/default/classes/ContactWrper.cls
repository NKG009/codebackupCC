global class ContactWrper{
          
  public ContactWrper()
  {
      consentRegistrations = new List<consentRegistrations>();
  }        
public List<consentRegistrations> consentRegistrations;

public class consentRegistrations{
    Public String sourceidentifier; 
    Public Datetime consentOptionsLastUpdateDate;
    Public String consentOptionsLastUpdatedBy; 
    Public consentoptn consentOptions;  
}
 public class consentoptn{
        public boolean Phone; 
        public boolean SMS; 
        public boolean Email; 
        public boolean Post; 
        public boolean CRBCHECK; 
        public boolean MedicalOther; 
        public boolean MedicalHistory;
        public boolean EQUALOPS; 
    }
}