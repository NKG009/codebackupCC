public class Candidatedetails{
public id record_Id{get; set;}
private sirenum__placement__c placeid{get; set;}
public string department;
 public String branchstreet{get;set;}
  public String branchcity{get;set;}
  public String branchCountry{get;set;}
  public String branchcounty{get;set;}
  public String branchpostal{get;set;}
  public String customsitename{get;set;}
  public String branchemail{get;set;}
  public String branchphone{get;set;}
    
public sirenum__placement__c getplaceid(){
   system.debug('record_id ' + record_Id);
   if(record_Id != null){
    placeid = 
    [
        SELECT
            id,name,IP_TempestDepartment__c,IP_Consultant1LookupSplitShare__r.Name,sirenum__Contact__r.firstname 
        FROM 
            sirenum__placement__c 
        WHERE 
            Id = :record_Id
    ];
       System.debug('=================================================================placeid'+placeid);
       
    department = placeid.IP_TempestDepartment__c;
       System.debug('=================================================================department'+department);
    IP_Shift_Template__c shiftemp = IP_Shift_Template__c.getValues(department); 
       System.debug('=================================================================shiftemp'+shiftemp);
    branchstreet= shiftemp.Branch_Address__c;
      branchcity= shiftemp.IP_Branch_City__c;
      branchCountry=shiftemp.IP_Branch_Country__c;
      branchpostal = shiftemp.IP_Branch_Postal_Code__c;
      branchcounty = shiftemp.IP_Branch_County__c;
      customsitename = shiftemp.IP_Site_Name__c;
      branchemail = shiftemp.Email__c;
      branchphone = shiftemp.Phone__c;
} 
   return placeid;
}
}