/*******************************************************************************************
* @Name         PropertiesGeneration 
* @Author       Rajesh & Badri
* @Description  This class Insert/Update properties from Get Properties API (Property Tree).
*******************************************************************************************/
public class PropertiesGeneration {

	public class Smoke_alarm {
		public String last_serviced_date;
		public String next_service_date;
	}

	public Address address;
	public Advertised_rent advertised_rent;
	public List<String> agents;
	public String property_type;
	public Integer bathrooms;
	public Integer bedrooms;
	public Integer car_spaces;
	public String id;
	public String key_description;
	public String key_number;
	public String ownership;
	public String tenancy;
	public Boolean deleted;
	public Boolean archived;
	public Smoke_alarm smoke_alarm;
	public String management_type;
	public String area;
	public Double expenditure_limit;
	public String maintenance_note;
	public String strata;

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

	public class Advertised_rent {
		public Double amount;
		public String period;
	}

	
	public static List<PropertiesGeneration> parse(String json) {
		return (List<PropertiesGeneration>) System.JSON.deserialize(json, List<PropertiesGeneration>.class);
	}
}