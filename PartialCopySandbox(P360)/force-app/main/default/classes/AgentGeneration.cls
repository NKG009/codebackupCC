/*******************************************************************************************
* @Name         AgentGeneration 
* @Author       Rajesh
* @Description  This class Generate Agents from JSON-Apex.
*******************************************************************************************/
public class AgentGeneration {
	
    public String email_address;
	public String first_name;
	public String id;
	public String last_name;
	public String mobile_phone_number;
	public List<String> properties;
	public List<String> roles;
	public Boolean deleted;

	
	public static List<AgentGeneration> parse(String json) {
		return (List<AgentGeneration>) System.JSON.deserialize(json, List<AgentGeneration>.class);
	}
}