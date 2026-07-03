public class ExternalAgentAccountContactRelation {
    @auraEnabled
    public String first_name;	
    @auraEnabled
	public String last_name;	
    @auraEnabled
	public String id;
     @auraEnabled
	public Rolescls[] roles;
	public class Rolescls {
        @auraEnabled
		public String name;
        @auraEnabled
		public boolean property_management_contact;
	}
	public static List<ExternalAgentAccountContactRelation> parse(String json){
               return (List<ExternalAgentAccountContactRelation>) System.JSON.deserialize(json, List<ExternalAgentAccountContactRelation>.class);
	}
}