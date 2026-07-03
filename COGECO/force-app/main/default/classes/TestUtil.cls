public class TestUtil {
    
	public static final String OPPORTUNITY_STAGE_QUALIFICATION = 'Qualification';
    public static final String OPPORTUNITY_STAGE_BASKET_CREATION = 'Basket Creation';
    public static final String OPPORTUNITY_STAGE_INITIAL_QUOTE = 'Initial Quote';
    public static final String OPPORTUNITY_STAGE_FIBRE_QUOTE_REQUESTED = 'Fibre Quote Requested';
    public static final String OPPORTUNITY_STAGE_COSTS_RECEIVED = 'Costs Received';
    public static final String OPPORTUNITY_STAGE_INTERNAL_APPROVAL_REQUESTED = 'Internal Approval Requested';
    public static final String OPPORTUNITY_STAGE_INTERNALLY_APPROVED = 'Internally Approved';
    public static final String OPPORTUNITY_STAGE_INTERNALLY_DECLINED = 'Internally Declined';
    public static final String OPPORTUNITY_STAGE_CONTRACT_SENT_TO_CUSTOMER = 'Contract Sent To Customer';
    public static final String OPPORTUNITY_STAGE_CUSTOMER_APPROVED = 'Customer Approved';
    public static final String OPPORTUNITY_STAGE_APPROVED_BY_AGENT = 'Approved By Agent';
    public static final String OPPORTUNITY_STAGE_ORDER_SUBMITTED = 'Order Submitted';
    public static final String OPPORTUNITY_STAGE_CLOSED_WON = 'Closed Won';
     
    public static void createHierarchyRecords(){
        
        Id marketRecordTypeId = Schema.SObjectType.Hierarchy__c.getRecordTypeInfosByName().get('Market').getRecordTypeId();
        Id customerCategoryRecordTypeId = Schema.SObjectType.Hierarchy__c.getRecordTypeInfosByName().get('Customer Category').getRecordTypeId();
        Id distributionChannelRecordTypeId = Schema.SObjectType.Hierarchy__c.getRecordTypeInfosByName().get('Distribution Channel').getRecordTypeId();
        
        List<Hierarchy__c> hierarchyEntries = new List<Hierarchy__c>();
        
        // market hierarchy
        hierarchyEntries.add(new Hierarchy__c(Name = 'All', Parent_Name__c = 'NULL', RecordTypeId = marketRecordTypeId));
        hierarchyEntries.add(new Hierarchy__c(Name = 'Ontario', Parent_Name__c = 'All', RecordTypeId = marketRecordTypeId));
        hierarchyEntries.add(new Hierarchy__c(Name = 'HB Ontario', Parent_Name__c = 'Ontario', RecordTypeId = marketRecordTypeId));
        hierarchyEntries.add(new Hierarchy__c(Name = 'Burloak', Parent_Name__c = 'Ontario', RecordTypeId = marketRecordTypeId));
        hierarchyEntries.add(new Hierarchy__c(Name = 'HB Burloak', Parent_Name__c = 'Burloak', RecordTypeId = marketRecordTypeId));
        hierarchyEntries.add(new Hierarchy__c(Name = 'Quebec', Parent_Name__c = 'All', RecordTypeId = marketRecordTypeId));
        hierarchyEntries.add(new Hierarchy__c(Name = 'Bell', Parent_Name__c = 'Quebec', RecordTypeId = marketRecordTypeId));
        hierarchyEntries.add(new Hierarchy__c(Name = 'New area WA', Parent_Name__c = 'Bell', RecordTypeId = marketRecordTypeId));
        hierarchyEntries.add(new Hierarchy__c(Name = 'Telus', Parent_Name__c = 'Quebec', RecordTypeId = marketRecordTypeId));
        hierarchyEntries.add(new Hierarchy__c(Name = 'New area OR', Parent_Name__c = 'Telus', RecordTypeId = marketRecordTypeId)); 

        // customer category hierarchy
        hierarchyEntries.add(new Hierarchy__c(Name = 'All', Parent_Name__c = 'NULL', RecordTypeId = customerCategoryRecordTypeId));
        hierarchyEntries.add(new Hierarchy__c(Name = 'Business', Parent_Name__c = 'All', RecordTypeId = customerCategoryRecordTypeId));
        hierarchyEntries.add(new Hierarchy__c(Name = 'Residential', Parent_Name__c = 'All', RecordTypeId = customerCategoryRecordTypeId));
        hierarchyEntries.add(new Hierarchy__c(Name = 'SMB', Parent_Name__c = 'Business', RecordTypeId = customerCategoryRecordTypeId));
        hierarchyEntries.add(new Hierarchy__c(Name = 'Employee', Parent_Name__c = 'Residential', RecordTypeId = customerCategoryRecordTypeId));
        
        // distribution channel hierarchy
        hierarchyEntries.add(new Hierarchy__c(Name = 'All ()', Parent_Name__c = 'NULL', RecordTypeId = distributionChannelRecordTypeId));
        hierarchyEntries.add(new Hierarchy__c(Name = 'Business (All)', Parent_Name__c = 'All', RecordTypeId = distributionChannelRecordTypeId));
        hierarchyEntries.add(new Hierarchy__c(Name = 'Residential (All)', Parent_Name__c = 'All', RecordTypeId = distributionChannelRecordTypeId));
        hierarchyEntries.add(new Hierarchy__c(Name = 'Account Executives (Business)', Parent_Name__c = 'Business (All)', RecordTypeId = distributionChannelRecordTypeId));
        hierarchyEntries.add(new Hierarchy__c(Name = 'Back Office (Residential)', Parent_Name__c = 'Residential (All)', RecordTypeId = distributionChannelRecordTypeId));

        insert hierarchyEntries;
    }
    
}