public class Sitedetails{
public id record_Id{get; set;}
private sirenum__site__c siteid{get; set;}
public string department;
 public String branchstreet{get;set;}
  public String branchcity{get;set;}
  public String branchCountry{get;set;}
  public String branchcounty{get;set;}
  public String branchpostal{get;set;}
  public String customsitename{get;set;}
  public String branchemail{get;set;}
  public String branchphone{get;set;}

public sirenum__site__c getsiteid(){
   system.debug('record_id ' + record_Id);
   if(record_Id != null){
    siteid = 
    [
        SELECT
            id,name,IP_TempestDepartment__c,Owner.Name,IP_MainContact__r.firstname 
        FROM 
            sirenum__site__c 
        WHERE 
            Id = :record_Id
    ];
    department = siteid.IP_TempestDepartment__c;
    IP_Shift_Template__c shiftemp = IP_Shift_Template__c.getValues(department); 
    branchstreet= shiftemp.Branch_Address__c;
      branchcity= shiftemp.IP_Branch_City__c;
      branchCountry=shiftemp.IP_Branch_Country__c;
      branchpostal = shiftemp.IP_Branch_Postal_Code__c;
      branchcounty = shiftemp.IP_Branch_County__c;
      customsitename = shiftemp.IP_Site_Name__c;
      branchemail = shiftemp.Email__c;
      branchphone = shiftemp.Phone__c;
} 
   return siteid;
}
}