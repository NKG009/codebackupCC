public class Drivingletter
{
  ID conID;
  public String Sitename{get;set;}
  public String branchstreet{get;set;}
  public String branchcity{get;set;}
  public String branchCountry{get;set;}
  public String branchcounty{get;set;}
  public String branchpostal{get;set;}
  public String customsitename{get;set;}
  public String branchemail{get;set;}
  public String branchphone{get;set;}
  public String branchFax{get;set;}
  Public string department;

    public Drivingletter(ApexPages.StandardController controller) {
    conID = ApexPages.currentPage().getParameters().get('id');
    	System.debug('============= conid '+conID);
    Contact s = [Select id,name,IP_TempestDepartment__c from Contact where id=:conID];
        System.debug('============= s '+s);   
      department = String.valueOf(s.IP_TempestDepartment__c);
        System.debug('============= department '+department);   
      IP_Shift_Template__c shiftemp = IP_Shift_Template__c.getValues(department);
        System.debug('============= shiftemp '+shiftemp);   
      branchstreet= shiftemp.Branch_Address__c;
      branchcity= shiftemp.IP_Branch_City__c;
      branchCountry=shiftemp.IP_Branch_Country__c;
      branchpostal = shiftemp.IP_Branch_Postal_Code__c;
      branchcounty = shiftemp.IP_Branch_County__c;
      customsitename = shiftemp.IP_Site_Name__c;
      branchemail = shiftemp.Email__c;
      branchphone = shiftemp.Phone__c;
      branchFax = shiftemp.Fax__c;
      }
      }