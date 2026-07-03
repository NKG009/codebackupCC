/*******************************************************************************************
* @Name         TenentGeneration 
* @Author       Rajesh
* @Date         15/07/2021
* @Description  This class Generate Tenants from JSON-Apex.
*******************************************************************************************/

public class TenentGeneration {

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

    public List<Contacts> contacts;
    public String id;
    public String name;
    public String lease_end_date;
    public String lease_start_date;
    public String original_lease_start_date;
    public String vacate_date;
    public String property;
    public Rent rent;
    public Boolean prospect;
    public Boolean deleted;
    public Boolean archived;

    public class Rent {
        public Double amount;
        public String period;
    }
    public static List<TenentGeneration> parse(String json){
		return (List<TenentGeneration>) System.JSON.deserialize(json, List<TenentGeneration>.class);
	}
}