public class RefereeRequest_Controller {
public id record_Id{get; set;}
private Contact conid{get; set;}
public string department;
public String branchphone{get;set;}

public Contact getconid(){
   system.debug('record_id ' + record_Id);
   if(record_Id != null){
    conid = 
    [
        SELECT
            id,IP_TempestDepartment__c,FirstName FROM Contact 
        WHERE 
            Id = :record_Id
    ];
    department = conid.IP_TempestDepartment__c;
    System.debug('check department'+department);
    IP_Shift_Template__c shiftemp = IP_Shift_Template__c.getValues(department); 
      branchphone = shiftemp.Phone__c;
} 
   return conid;
}
}