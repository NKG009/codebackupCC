/*******************************************************************************************
* @Name         OwnerShipsGeneration 
* @Author       Rajesh
* @Description  This class Generate Ownerships from JSON-Apex.
*******************************************************************************************/
public class OwnerShipsGeneration {
	
    public String abn;
	public List<Contacts> contacts;
	public String id;
	public List<String> properties;
	public Boolean deleted;
	public Boolean archived;
	public String name;

	public class Address {
		public String address_line_1;
		public String address_line_2;
		public String country;
		public String post_code;
		public String state;
		public String street_number;
		public String suburb;
		public String unit;
	}

	public class Contacts {
		public String id;
		public Address address;
		public String email_address;
		public String preferred_email_address;
		public String first_name;
		public Boolean is_primary;
		public String last_name;
		public String mobile_phone_number;
		public String phone_number;
		public String preferred_phone_number;
		public String title;
		public List<String> contact_types;
		public Boolean no_marketing;
	}

	
	public static List<OwnerShipsGeneration> parse(String json) {
		return (List<OwnerShipsGeneration>) System.JSON.deserialize(json, List<OwnerShipsGeneration>.class);
	}
}