public class CommentsCallOutWrapper{
    public String next_page;
    public String previous_page;
    public Integer count;
    public list<comments> comments;
    public class comments{
        public list<attachments> attachments;
        public String plain_body;
        public Boolean isPublic;
        public String html_body;
        public String audit_id;
        public String body;
        public via via;
        public String author_id;
        public String created_at;
        public String type;
        public metadata metadata;
        public String id;
    }
    public class attachments{
        public String content_type;
        public String width;
        public String height;
        public Integer size;
        public Boolean inline;
        public String mapped_content_url;
        public Boolean deleted;
        public String content_url;
        public Boolean malware_access_override;
        public String file_name;
        public String malware_scan_result;
        public String id;
        public list<thumbnails> thumbnails;
        public String url;
    }
    public class thumbnails{
		public String id;
		public String url;
		public String file_name;
		public Integer height;
		public Boolean inline;
		public Integer width;
		public Boolean deleted;
		public Integer size;
		public Boolean malware_access_override;
		public String content_type;
		public String malware_scan_result;
		public String mapped_content_url;
		public String content_url;
	}
    public class via{
        public source source;
        public String channel;
    }
    public class systemDetails{
        public Decimal latitude;
        public Decimal longitude;
        public String client;
        public String location;
        public String ip_address;
        public String message_id;
		public String raw_email_identifier;
		public String json_email_identifier;
    }
    public class source{
        public String rel;
        public to to;
        public from1 from1;
    }
    public class to {
        public String formatted_phone;	    //+1 (617) 420-8677
        public String phone;	    //+16174208677
        public String name;	    //Brabo Payroll
        public String address;
    }
    public class from1 {
        public String formatted_phone;	    //+1 (774) 722-1331
        public String phone;	    //+17747221331
        public String name;	    //Lisa Reilly - Plymouth Yacht Club
        public String address;
        public list<String> original_recipients;
    }
    public class metadata{
        public systemDetails systemDetails;
        public custom custom;
        public String suspension_type_id;
    }
    public class custom {
    }
    
}