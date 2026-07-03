public class sitetemplatedata
{

public List<sirenum__Shift__c> shlist = new List<sirenum__Shift__c>();


 ID placeID;
 ID siteID;
 public String Sitename{get;set;}
  public String branchstreet{get;set;}
  public String branchcity{get;set;}
  public String branchCountry{get;set;}
  public String branchcounty{get;set;}
  public String branchpostal{get;set;}
  //public String Shiftstart{get;set;}
  public String customsitename{get;set;}
  public String branchemail{get;set;}
  public String branchphone{get;set;}
  public String branchFax{get;set;}
  Public string department;
  Set<ID> placeset = new Set<id>();

 public String subname;
    public sitetemplatedata(ApexPages.StandardController controller) {
    siteID = ApexPages.currentPage().getParameters().get('id');
    
    sirenum__site__c s = [Select id,name,IP_TempestDepartment__c from sirenum__site__c where id=:siteID];
            subname = s.name.substringBefore('-'); 
  setSitename(subname);
  department = String.valueOf(s.IP_TempestDepartment__c);
    
     /* sirenum__Placement__c place = [select id,sirenum__Site__c, IP_TempestDepartment__c from sirenum__Placement__c where sirenum__Site__c =:siteID];
      department = String.valueOf(place.IP_TempestDepartment__c);
      System.debug('## '+department );*/
      
      IP_Shift_Template__c shiftemp = IP_Shift_Template__c.getValues(department); 
      branchstreet= shiftemp.Branch_Address__c;
      branchcity= shiftemp.IP_Branch_City__c;
      branchCountry=shiftemp.IP_Branch_Country__c;
      branchpostal = shiftemp.IP_Branch_Postal_Code__c;
      branchcounty = shiftemp.IP_Branch_County__c;
      customsitename = shiftemp.IP_Site_Name__c;
      branchemail = shiftemp.Email__c;
      branchphone = shiftemp.Phone__c;
      branchFax = shiftemp.Fax__c;
      
     // System.debug('## '+place);
   // List<sirenum__Site__c> sit = [Select name from sirenum__Site__c where id =: place.sirenum__Site__c  ];
      //  if(sit.size()>0){
      
    }
    
    public void setSitename(String subname)
    {
     Sitename = subname ;
  
  system.debug('@@ ');
 // return Sitename;
    }
     public string getSitename()
    {
    return Sitename;
    }
    
Public List<sirenum__Shift__c> getshifts()
{
Date todayDate1 = System.today();
Time todayTime = Time.newInstance(17, 0, 0, 0);
DateTime shiftstartdate = DateTime.newInstance(todayDate1, todayTime);

Date tomorrowDate1 = System.today().addDays(1);
Time tomorrowTime = Time.newInstance(17, 0, 0, 0);
DateTime shiftenddate = DateTime.newInstance(tomorrowDate1, tomorrowTime);

System.debug('Shift start tIme'+shiftstartdate);
System.debug('Shift end tIme'+shiftenddate );

 List<sirenum__Placement__c > place = new List<sirenum__Placement__c>();
place = [select id,sirenum__Site__c, IP_TempestDepartment__c from sirenum__Placement__c where sirenum__Site__c =:siteID];

for(sirenum__Placement__c p:place)
{
placeset.add(p.id);
}  
shlist = [Select id,sirenum__Scheduled_Start_Time__c,sirenum__Scheduled_End_Time__c,sirenum__Placement__r.sirenum__Contact__r.Name,sirenum__Placement__r.sirenum__Job_Role__r.sirenum__Job_Type__r.Name from sirenum__Shift__c where (sirenum__Contact__c!=null OR sirenum__Contact__c!='' ) and (sirenum__Scheduled_Start_Time__c>=:shiftstartdate and sirenum__Scheduled_Start_Time__c<:shiftenddate) and sirenum__Placement__c =: placeset order by sirenum__Scheduled_Start_Time__c desc];
if(shlist.size()>0){

}
return shlist;

}

}