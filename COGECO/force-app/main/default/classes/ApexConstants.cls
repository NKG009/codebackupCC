public without sharing class ApexConstants {
    /* System-Wide */
	public static final String COMMA = ',';
	public static final String PIPE = '|';
    public static final String RELATIONSHIP_FIELD_SUFFIX = '__r';
    public static final String RELATIONSHIP_SPLIT_DELIMITER = '\\.';
    public static final String DOT = '.';
    public static final String LESS_THAN = '<';
    public static final String LIKE_NOTATION = '%';
    public static final String COLON = ':';
	public static final String SEMICOLON = ';';
    public static final String FILE_EXTENSION_PDF = '.pdf';
    public static final String NEW_LINE = '\n';
    public static final String HTML_BREAK = '<br/>';
    public static final String ENGLISH = 'English';
    public static final String ENGLISH_LOCALE = 'en';
    public static final String FRENCH = 'French';
    public static final String FRENCH_LOCALE = 'fr';
    public static final String PROVINCE_QC = 'QC';
    public static final String STRING_TRUE = 'true';
    
    /* Account */
    public static final String ACCOUNT_OBJECT_API_NAME = 'Account';
    public static final String ACCOUNT_ACTIVE_YES = 'Yes';
    public static final String ACCOUNT_ACTIVE_NO = 'No';
    public static final String ACCOUNT_STATUS_ACTIVE = 'Active';
    public static final String ACCOUNT_STATUS_FIELD_API_NAME = 'Account_Status__c';
    public static final Set<String> BILLING_ACCOUNT_ACTIVE_STATUSES = new Set<String>{ ACCOUNT_ACTIVE_YES, ACCOUNT_STATUS_ACTIVE };
    public static final Id ACCOUNT_BILLING_RECORD_TYPE_ID = SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Billing').getRecordTypeId();
    public static final Id ACCOUNT_SERVICE_RECORD_TYPE_ID = SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Service').getRecordTypeId();
    public static final Id ACCOUNT_BULK_BUSINESS_RECORD_TYPE_ID = SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bulk_Commercial_Account').getRecordTypeId();
    public static final Id ACCOUNT_RESI_BULK_LANDLORD_RECORD_TYPE_ID = SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bulk_Resi_Account').getRecordTypeId();
    public static final Id ACCOUNT_LARGE_RECORD_TYPE_ID = SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Large_Account').getRecordTypeId();
    public static final Id ACCOUNT_SMB_RECORD_TYPE_ID = SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SMB').getRecordTypeId();
    public static final Id ACCOUNT_WHOLESALE_RECORD_TYPE_ID = SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Wholesale').getRecordTypeId();
    public static final Set<Id> BUSINESS_RECORD_TYPE_IDS = new Set<Id>{
        ACCOUNT_BULK_BUSINESS_RECORD_TYPE_ID, ACCOUNT_RESI_BULK_LANDLORD_RECORD_TYPE_ID, ACCOUNT_LARGE_RECORD_TYPE_ID, ACCOUNT_SMB_RECORD_TYPE_ID, ACCOUNT_WHOLESALE_RECORD_TYPE_ID
    };
    
    /* Asset */
	public static final String PARENT_ASSET_LINE_NUMBER = '0001';
	public static final String CHILD_ASSET_LINE_NUMBER = '0001.0002';

    /* ContentDocument */
    public static final String CONTENT_DOCUMENT_TITLE_LIKE_EN_PREFIX = 'EN-%';
    public static final String CONTENT_DOCUMENT_TITLE_LIKE_FR_PREFIX = 'FR-%';
    public static final String CONTENT_DOCUMENT_TITLE_EN_PREFIX = 'EN-';
    public static final String CONTENT_DOCUMENT_TITLE_FR_PREFIX = 'FR-';
    public static final String CONTENT_DOCUMENT_TITLE_EMPTY_PREFIX = '-';
    
    /* ContentDocumentLink */
    public static final String CONTENT_DOCUMENT_LINK_VISIBILITY_ALL_USERS = 'AllUsers';
    public static final String CONTENT_DOCUMENT_LINK_SHARE_TYPE_VIEWER = 'V';
    public static final String CONTENT_DOCUMENT_LINK_SHARE_TYPE_INFERRED = 'I';
    
    /* ContentDistribution */
    public static final Set<String> CONTENT_DISTRIBUTION_AVAILABLE_TYPES_FOR_AUTO_CONTENT_DISTRIBUTIONS = new Set<String>{ 'Customer_Approval__c' };
        
    /* Customer_Approval__c */
    public static final String CUSTOMER_APPROVAL_STATUS_WITH_CUSTOMER = 'With Customer';
    public static final String CUSTOMER_APPROVAL_VERIFICATION_CODE = 'TID434816690000b636b8';
    /* OpportunityLineItem */
    public static final String OPPORTUNITY_LINE_ITEM_OBJECT_API_NAME = 'OpportunityLineItem';
    
    /* Order */
    public static final String ORDER_STATUS_ACTIVATED = 'Activated';
    
    /* Quote */
    public static final String QUOTE_OBJECT_API_NAME = 'Quote';
    public static final String QUOTE_STATUS_DRAFT = 'Draft';
    public static final String QUOTE_STATUS_NEEDS_REVIEW = 'Needs Review';
    public static final String QUOTE_STATUS_APPROVED = 'Approved';
    
    /* QuoteLineItem */
    public static final String QUOTE_LINE_ITEM_OBJECT_API_NAME = 'QuoteLineItem';
    public static final String QUOTE_LINE_ITEM_ACTION_DISCONNECT = 'Disconnect';
    public static final String QUOTE_LINE_ITEM_ACTION_EXISTING = 'Existing';
    
    /* Pricing_Approval_Request__c */
    public static final String PRICING_APPROVAL_REQUEST_STATUS_APPROVAL_REQUIRED = 'Approval Required';
    public static final String PRICING_APPROVAL_REQUEST_STATUS_APPROVED = 'Approved';
    
    /* Product2Id */
    public static final String PRODUCT2_ID_FIELD_API_NAME = 'Product2Id';
    
    /* Asset */
    public static final String ASSET_PROVISIONING_STATUS_ACTIVE = 'Active';
    
    /* Vlocity VF Page Names */
    public static final String VLOCITY_VF_PAGE_QUOTEDOCUMENTPDF = 'vlocity_cmt__QuoteDocumentPdf';
    
    /* Vlocity Quote Pricing Attributes */
    public static final String VLOCITY_QUOTE_PRICING_ADJUSTMENT_SOURCE_DISCOUNT = 'Discount';
    public static final String VLOCITY_QUOTE_PRICING_ADJUSTMENT_SOURCE_AGENT = 'Agent';

	/* Vlocity Quote Configurable Attributes */
	public static final String SPEED = 'Speed';
	public static final String SPEED_FR = 'Vitesse';
	public static final String TERM = 'Term';
	public static final String TERM_FR = 'Terme';
    
    /* Vlocity Pricing Variable */
    public static final String VLOCITY_PRICING_VARIABLE_FREQUENCY_MONTHLY = 'Monthly';
    
    /* Email Template Mapping */
    public static final Map<String, String> CONTRACT_PREVIEW_EMAIL_TEMPLATE_MAPPING_FROM_LANGUAGE = new Map<String, String>{
        'EN-' => 'ON_CPQC_Contract', 
        'FR-' => 'QC_CPQC_Contract',
        'null'   => ''
    };
    
    /* System Values Keys */
    public static final String SYSTEM_VALUES_ORDER_FULFILLMENT_STATUS_DEFAULT = 'Order Fulfillment Status Default';
    public static final String SYSTEM_VALUES_QUOTE_COMMUNICATIONS_LANGUAGE_DEFAULT = 'Quote Communications Language Default';
    public static final String SYSTEM_VALUES_ASSET_ROLLUP_BATCH_SIZE = 'Asset Rollup Batch Size';
    public static final String SYSTEM_VALUES_CUSTOMER_ATTACHMENT_FOLDER_ENGLISH_ID = 'Customer Attachment Folder English ID';
    public static final String SYSTEM_VALUES_CUSTOMER_ATTACHMENT_FOLDER_FRENCH_ID = 'Customer Attachment Folder French ID';
    public static final String SYSTEM_VALUES_CUSTOM_PRICING_LOG_DATA_ENABLED = 'CustomPricingLogDataEnabled';
    
    /* System Value Metadata Keys */
    public static final String SYSTEM_VALUE_PRICING_LOG_DATA_DEFAULT = 'PricingLogDataDefault';
    
    /* Auto Launched Flows */
    public static final String FLOW_RECORD_ID_KEY = 'recordId';
    public static final String FLOW_EMAIL_DOCUMENT_TO_CUSTOMER = 'Email_Document_to_Customer';
    
    /* Vlocity */
    public static final String VLOCITY_NAMESPACE = 'vlocity_cmt';
    
    /* Custom Labels */
    public static final String CMEXMONTHS = 'CMEXMonths';
    public static final String CMEXTERM = 'B2cCmexTermLabel';
    public static final String LABEL_SPEED = 'Speed';
    
    public static final Map<String, String> productFamilyTranslations = new Map<String, String>{
        'Internet' => 'Internet',
        'Business Telephony' => 'Téléphonie commerciale',
        'Managed Services' => 'Services gérés',
        'Multiplay' => 'Multiplay',
        'None' => 'Aucun',
        'Telephony' => 'Téléphonie',
        'TV' => 'Télévision'
    };
}