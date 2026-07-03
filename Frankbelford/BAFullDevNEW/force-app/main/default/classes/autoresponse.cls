public class autoresponse {
public id record_Id{get; set;}
private TR1__Application_V2__c conid{get; set;}
public string department;
 // public ts2__Job__c job ;
public String branchphone{get;set;}
    public String branchstreet{get;set;}
  public String branchcity{get;set;}
  public String branchCountry{get;set;}
  public String branchcounty{get;set;}
  public String branchpostal{get;set;}
   
public TR1__Application_V2__c getconid(){
   system.debug('record_id ' + record_Id);
   if(record_Id != null){
      
    conid = 
    [
        SELECT
          id, TR1__Job__r.Name, TR1__Job__r.Ownerid from  TR1__Application_V2__c
        WHERE 
            Id = :record_Id
    ];
    User u = [Select id,IP_TempestDepartment__c from User where id=:conid.TR1__Job__r.Ownerid];
    department = u.IP_TempestDepartment__c;
    System.debug('check department'+department);
    IP_Shift_Template__c shiftemp = IP_Shift_Template__c.getValues(department); 
      branchphone = shiftemp.Phone__c;
      branchstreet= shiftemp.Branch_Address__c;
      branchcity= shiftemp.IP_Branch_City__c;
      branchCountry=shiftemp.IP_Branch_Country__c;
      branchpostal = shiftemp.IP_Branch_Postal_Code__c;
      branchcounty = shiftemp.IP_Branch_County__c;
} 
   return conid;
}
}