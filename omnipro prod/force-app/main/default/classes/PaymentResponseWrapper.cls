public class PaymentResponseWrapper{
    
    public data_t data;
    public String type;
    public Long created;
    
    public class data_t {
        public objectzmain objectz;
    }
    
    public class objectzmain{
        public lines lines;
        public String customer_phone;
        public String customer_name;
        public String customer_email;
        public CustomerAddress customer_address { get; set; }
        
    }
    public class CustomerAddress
    {
        public String line1 { get; set; }
        public String line2 { get; set; }
        public String city { get; set; }
        public String state { get; set; }
        public String postal_code { get; set; }
        public String country { get; set; }
    }
    
    public class lines{
        public list<data_l> data{get;set;}
    }
    public class data_l{
        public plan plan;
        public decimal amount_excluding_tax;
    }
    public class plan{
        public String interval;       
        public String nickname;
    }  
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
	/*public String id;	//evt_1QRXqtBqgtf3A0vTmwxqzqua
	public String api_version;	//2023-08-16
	public Integer created;	//1733139099
	public cls_data data;
	public boolean livemode;
	public Integer pending_webhooks;	//1
	public cls_request request;
	public String type;	//invoice.payment_succeeded
	class cls_data {
		public String id;	//il_1QRWuHBqgtf3A0vTtXYyWyzY
		public cls_objectz objectz;	//line_item
		public Integer amount;	//6027
		public Integer amount_excluding_tax;	//6027
		//public String currency;	//eur
		public String description;	//1 × ARC Premium (at €60.27 / month)
		public cls_discount_amounts[] discount_amounts;
		public boolean discountable;
		public cls_discounts[] discounts;
		public String invoice;	//in_1QRWuHBqgtf3A0vT6Bzd19BG
		public boolean livemode;
		public cls_metadata metadata;
		public cls_period period;
		public cls_plan plan;
		public cls_pretax_credit_amounts[] pretax_credit_amounts;
		public cls_price price;
		public boolean proration;
		public cls_proration_details proration_details;
		public Integer quantity;	//1
		public String subscription;	//sub_1O7yAIBqgtf3A0vTj5cdKsq9
		public String subscription_item;	//si_R8awCkwjRTbWbh
		public cls_tax_amounts[] tax_amounts;
		public cls_tax_rates[] tax_rates;
		public String type;	//subscription
		public String unit_amount_excluding_tax;	//6027
	}
	class cls_objectz {
		public String id;	//in_1QRWuHBqgtf3A0vT6Bzd19BG
		public String account_country;	//IE
		public String account_name;	//OmniPro Strategic Solutions Limited
		public cls_account_tax_ids account_tax_ids;
		public Integer amount_due;	//6027
		public Integer amount_paid;	//6027
		public Integer amount_remaining;	//0
		public Integer amount_shipping;	//0
		public cls_application application;
		public cls_application_fee_amount application_fee_amount;
		public Integer attempt_count;	//1
		public boolean attempted;
		public boolean auto_advance;
		public cls_automatic_tax automatic_tax;
		public cls_automatically_finalizes_at automatically_finalizes_at;
		public String billing_reason;	//subscription_cycle
		public String charge;	//ch_3QRXqmBqgtf3A0vT25fzAB06
		public String collection_method;	//charge_automatically
		public Integer created;	//1733135469
		//public String currency;	//eur
		public cls_custom_fields custom_fields;
		public String customer;	//cus_IqeDxO9IGi65wF
		public cls_customer_address customer_address;
		public String customer_email;	//donal.lycett@firstcount.ie
		public String customer_name;	//Donal Lycett
		public cls_customer_phone customer_phone;
		public cls_customer_shipping customer_shipping;
		public String customer_tax_exempt;	//none
		public cls_customer_tax_ids[] customer_tax_ids;
		public cls_default_payment_method default_payment_method;
		public cls_default_source default_source;
		public cls_default_tax_rates[] default_tax_rates;
		public cls_description description;
		public cls_discount discount;
		public cls_discounts[] discounts;
		public cls_due_date due_date;
		public Integer effective_at;	//1733139094
		public Integer ending_balance;	//0
		public cls_footer footer;
		public cls_from_invoice from_invoice;
		public String hosted_invoice_url;	//https://invoice.stripe.com/i/acct_175lDyBqgtf3A0vT/live_YWNjdF8xNzVsRHlCcWd0ZjNBMHZULF9SS0JHcFB5bE0wd3o1QndTUnpsYzZ4bVh4NGVzdmhwLDEyMzY3OTkwMw0200ZmJayLsD?s=ap
		public String invoice_pdf;	//https://pay.stripe.com/invoice/acct_175lDyBqgtf3A0vT/live_YWNjdF8xNzVsRHlCcWd0ZjNBMHZULF9SS0JHcFB5bE0wd3o1QndTUnpsYzZ4bVh4NGVzdmhwLDEyMzY3OTkwMw0200ZmJayLsD/pdf?s=ap
		public cls_issuer issuer;
		public cls_last_finalization_error last_finalization_error;
		public cls_latest_revision latest_revision;
		public cls_lines lines;
		public boolean livemode;
		public cls_metadata metadata;
		public cls_next_payment_attempt next_payment_attempt;
		//public String number;	//E9B3AA87-0014
		public cls_on_behalf_of on_behalf_of;
		public boolean paid;
		public boolean paid_out_of_band;
		public String payment_intent;	//pi_3QRXqmBqgtf3A0vT2t78aUxV
		public cls_payment_settings payment_settings;
		public Integer period_end;	//1733135418
		public Integer period_start;	//1730543418
		public Integer post_payment_credit_notes_amount;	//0
		public Integer pre_payment_credit_notes_amount;	//0
		public cls_quote quote;
		public cls_receipt_number receipt_number;
		public cls_rendering rendering;
		public cls_rendering_options rendering_options;
		public cls_shipping_cost shipping_cost;
		public cls_shipping_details shipping_details;
		public Integer starting_balance;	//0
		public cls_statement_descriptor statement_descriptor;
		public String status;	//paid
		public cls_status_transitions status_transitions;
		public String subscription;	//sub_1O7yAIBqgtf3A0vTj5cdKsq9
		public cls_subscription_details subscription_details;
		public Integer subtotal;	//6027
		public Integer subtotal_excluding_tax;	//6027
		public cls_tax tax;
		public cls_test_clock test_clock;
		public Integer total;	//6027
		public cls_total_discount_amounts[] total_discount_amounts;
		public Integer total_excluding_tax;	//6027
		public cls_total_pretax_credit_amounts[] total_pretax_credit_amounts;
		public cls_total_tax_amounts[] total_tax_amounts;
		public cls_transfer_data transfer_data;
		public Integer webhooks_delivered_at;	//1733135471
	}
	class cls_account_tax_ids {
	}
	class cls_application {
	}
	class cls_application_fee_amount {
	}
	class cls_automatic_tax {
		public cls_disabled_reason disabled_reason;
		public boolean enabled;
		public cls_liability liability;
		public cls_status status;
	}
	class cls_disabled_reason {
	}
	class cls_liability {
	}
	class cls_status {
	}
	class cls_automatically_finalizes_at {
	}
	class cls_custom_fields {
	}
	class cls_customer_address {
	}
	class cls_customer_phone {
	}
	class cls_customer_shipping {
	}
	class cls_customer_tax_ids {
	}
	class cls_default_payment_method {
	}
	class cls_default_source {
	}
	class cls_default_tax_rates {
	}
	class cls_description {
	}
	class cls_discount {
	}
	class cls_discounts {
	}
	class cls_due_date {
	}
	class cls_footer {
	}
	class cls_from_invoice {
	}
	class cls_issuer {
		public String type;	//self
	}
	class cls_last_finalization_error {
	}
	class cls_latest_revision {
	}
	class cls_lines {
		public String objectz;	//list
		public cls_data[] data;
		public boolean has_more;
		public Integer total_count;	//1
		public String url;	///v1/invoices/in_1QRWuHBqgtf3A0vT6Bzd19BG/lines
	}
	class cls_discount_amounts {
	}
	class cls_metadata {
	}
	class cls_period {
		//public Integer end;	//1735813818
		public Integer start;	//1733135418
	}
	class cls_plan {
		public String id;	//price_1QGJhJBqgtf3A0vTspGylGBB
		public String objectz;	//plan
		public boolean active;
		public cls_aggregate_usage aggregate_usage;
		public Integer amount;	//6027
		public String amount_decimal;	//6027
		public String billing_scheme;	//per_unit
		public Integer created;	//1730463085
		//public String currency;	//eur
		public String interval;	//month
		public Integer interval_count;	//1
		public boolean livemode;
		public cls_metadata metadata;
		public cls_meter meter;
		public String nickname;	//ARC Premium - Monthly
		public String product;	//prod_PrZdL7wXPo5vi9
		public cls_tiers_mode tiers_mode;
		public cls_transform_usage transform_usage;
		public cls_trial_period_days trial_period_days;
		public String usage_type;	//licensed
	}
	class cls_aggregate_usage {
	}
	class cls_meter {
	}
	class cls_tiers_mode {
	}
	class cls_transform_usage {
	}
	class cls_trial_period_days {
	}
	class cls_pretax_credit_amounts {
	}
	class cls_price {
		public String id;	//price_1QGJhJBqgtf3A0vTspGylGBB
		public String objectz;	//price
		public boolean active;
		public String billing_scheme;	//per_unit
		public Integer created;	//1730463085
		//public String currency;	//eur
		public cls_custom_unit_amount custom_unit_amount;
		public boolean livemode;
		public cls_lookup_key lookup_key;
		public cls_metadata metadata;
		public String nickname;	//ARC Premium - Monthly
		public String product;	//prod_PrZdL7wXPo5vi9
		public cls_recurring recurring;
		public String tax_behavior;	//inclusive
		public cls_tiers_mode tiers_mode;
		public cls_transform_quantity transform_quantity;
		public String type;	//recurring
		public Integer unit_amount;	//6027
		public String unit_amount_decimal;	//6027
	}
	class cls_custom_unit_amount {
	}
	class cls_lookup_key {
	}
	class cls_recurring {
		public cls_aggregate_usage aggregate_usage;
		public String interval;	//month
		public Integer interval_count;	//1
		public cls_meter meter;
		public cls_trial_period_days trial_period_days;
		public String usage_type;	//licensed
	}
	class cls_transform_quantity {
	}
	class cls_proration_details {
		public cls_credited_items credited_items;
	}
	class cls_credited_items {
	}
	class cls_tax_amounts {
	}
	class cls_tax_rates {
	}
	class cls_next_payment_attempt {
	}
	class cls_on_behalf_of {
	}
	class cls_payment_settings {
		public cls_default_mandate default_mandate;
		public cls_payment_method_options payment_method_options;
		public cls_payment_method_types payment_method_types;
	}
	class cls_default_mandate {
	}
	class cls_payment_method_options {
	}
	class cls_payment_method_types {
	}
	class cls_quote {
	}
	class cls_receipt_number {
	}
	class cls_rendering {
	}
	class cls_rendering_options {
	}
	class cls_shipping_cost {
	}
	class cls_shipping_details {
	}
	class cls_statement_descriptor {
	}
	class cls_status_transitions {
		public Integer finalized_at;	//1733139094
		public cls_marked_uncollectible_at marked_uncollectible_at;
		public Integer paid_at;	//1733139094
		public cls_voided_at voided_at;
	}
	class cls_marked_uncollectible_at {
	}
	class cls_voided_at {
	}
	class cls_subscription_details {
		public cls_metadata metadata;
	}
	class cls_tax {
	}
	class cls_test_clock {
	}
	class cls_total_discount_amounts {
	}
	class cls_total_pretax_credit_amounts {
	}
	class cls_total_tax_amounts {
	}
	class cls_transfer_data {
	}
	class cls_request {
		public cls_id id;
		public cls_idempotency_key idempotency_key;
	}
	class cls_id {
	}
	class cls_idempotency_key {
	}*/
	public static PaymentResponseWrapper parse(String json){
		return (PaymentResponseWrapper) System.JSON.deserialize(json, PaymentResponseWrapper.class);
	}

	
}