/*******************************************************************************************
* @Name         PropertyLotsAgentMembersGenerations 
* @Author       Rajesh & Badri
* @Description  This class Convert JSON to Apex for Members(Agent) API (Property Me).
*******************************************************************************************/
public class PropertyLotsAgentMembersGenerations {
    
    public String Id;
	public String CustomerId;
	public Integer UserId;
	public String Role;
	public String ExpireOn;
	public String FirstName;
	public String LastName;
	public String CompanyName;
	public String RegisteredEmail;
	public String RegisteredOn;
	public String WorkPhone;
	public String MobilePhone;
	public Boolean IsActivated;
	public String AgreeConditionsOn;
	public String RegionCode;
	public String Permissions;
	public String CurrentMemberAccessId;
	public String JobTitle;
	public String Teams;
	public Boolean IsSupport;
	public Boolean IsBillingRecipient;
	public Boolean IsTwoFactorAuthenticationEnabled;
	public String Name;

	
	public static List<PropertyLotsAgentMembersGenerations> parse(String json) {
		return (List<PropertyLotsAgentMembersGenerations>) System.JSON.deserialize(json, List<PropertyLotsAgentMembersGenerations>.class);
	}

}