public with sharing class ContractDto {
    public String effectiveDate {get;set;}
    public String billingAccountName {get;set;}
    public String billingStreet {get;set;}
    public String billingCity {get;set;}
    public String billingCountry {get;set;}
    public String billingState {get;set;}
    public String billingPostalCode {get;set;}
    public String recurringTotal {get;set;}
    public String oneTimeTotal {get;set;}
    public String terms {get;set;}
    public String companyAddress {get;set;}
    public Integer numberOfMembers {get;set;}
    public String summaryString {get;set;}
    public List<QuoteMember> quoteMembers {get;set;}
    
    public ContractDto() {
        this.quoteMembers = quoteMembers;
    }
    
    public ContractDto(String effectiveDate, String billingAccountName, String billingStreet, String billingCity, String billingCountry, String billingState, String billingPostalCode, Decimal recurringTotal, Decimal oneTimeTotal, List<QuoteMember> quoteMembers, String communicationLanguage, String terms) {
        this.billingAccountName = billingAccountName;
        this.billingStreet = billingStreet;
        this.billingCity = billingCity;
        this.billingCountry = billingCountry;
        this.billingState = billingState;
        this.billingPostalCode = billingPostalCode;
        this.recurringTotal = DateAndTime.getFormattedCurrency(recurringTotal, communicationLanguage);
        this.oneTimeTotal = DateAndTime.getFormattedCurrency(oneTimeTotal, communicationLanguage);
        this.effectiveDate = DateAndTime.getFormattedDate(Date.valueOf(effectiveDate), communicationLanguage);
        this.quoteMembers = quoteMembers;
        this.terms = terms;
    }
    
    public class QuoteMember {
        public String locationCity {get;set;}
        public String locationCountry {get;set;}
        public String locationStreet {get;set;}
        public String locationState {get;set;}
        public String locationPostalCode {get;set;}
        public List<ProductFamily> productFamilies {get;set;}
        public Decimal RCTotalQM {get;set;}
        public String RCTotalQMFormatted {get;set;}
        public Decimal OTTotalQM {get;set;}
        public String OTTotalQMFormatted {get;set;}
        public Decimal chargeTotal {get;set;}
        public String chargeTotalFormatted {get;set;}
        public Decimal totalRecurringChargeWithQuantity {get;set;}
        public String totalRecurringChargeWithQuantityFormatted {get;set;}
        //pointer attributes
        public String quoteMemberId {get;set;}
        
        public QuoteMember() {
            this.productFamilies = new List<ProductFamily>();
        }
        
        public QuoteMember(String locationCity, String locationCountry, String locationStreet, String locationState, String locationPostalCode, List<ProductFamily> productFamilies, String quoteMemberId, Decimal recurringTotal, Decimal oneTimeTotal, Decimal chargeTotal, Decimal totalRecurringChargeWithQuantity) {
            this.locationCity = locationCity;
            this.locationCountry = locationCountry;
            this.locationStreet = locationStreet;
            this.locationState = locationState;
            this.locationPostalCode = locationPostalCode;
            this.productFamilies = productFamilies;
            this.quoteMemberId = quoteMemberId;
            this.RCTotalQM = recurringTotal;
            this.OTTotalQM = oneTimeTotal;
            this.chargeTotal = chargeTotal;
            this.totalRecurringChargeWithQuantity = totalRecurringChargeWithQuantity;
        }
    }
    
    public class ProductFamily {
        public String familyName {get;set;}
        public Decimal subtotalRC {get;set;}
        public String subtotalRCFormatted {get;set;}
        public Decimal subtotalOT {get;set;}
        public String subtotalOTFormatted {get;set;}
        public Decimal chargeSubTotal {get;set;}
        public String chargeSubTotalFormatted {get;set;}
        public List<QuoteLineItem> quoteLineItems {get;set;}
        
        public ProductFamily() {
            this.subtotalRC = 0;
            this.subtotalOT = 0;
            this.quoteLineItems = new List<QuoteLineItem>();
        }
        
        public ProductFamily(String familyName, Decimal subtotalRC, Decimal subtotalOT, List<QuoteLineItem> quoteLineItems, Decimal chargeSubTotal) {
            this.familyName = familyName;
            this.subtotalRC = subtotalRC;
            this.subtotalOT = subtotalOT;
            this.quoteLineItems = quoteLineItems;
            this.chargeSubTotal = chargeSubTotal;
        }
    }
    
    public class QuoteLineItem {
        public Decimal oneTimeCharge {get;set;}
        public String oneTimeChargeFormatted {get;set;}
        public Integer quantity {get;set;}
        public String customerFacingComments {get;set;}
        public String productName {get;set;}
        public String productFamily {get;set;}
        public Decimal recurringCharge {get;set;}
        public String recurringChargeFormatted {get;set;}
        public Boolean isPromotion {get;set;}
        public Decimal charge {get;set;}
        public String chargeFormatted {get;set;}
        public String adjustmentType {get;set;}
        //pointer attributes
        public String quoteMemberId {get;set;}
        public Integer term {get;set;}
        public String speed {get;set;}
        
        public QuoteLineItem() { }
        
        public QuoteLineItem(Decimal oneTimeCharge, Integer quantity, String customerFacingComments, String productName, String productFamily, Decimal recurringCharge, String quoteMemberId, Boolean isPromotion, Integer term, String speed, Decimal charge,String communicationLanguage) {
            this.oneTimeCharge = oneTimeCharge;
            this.oneTimeChargeFormatted = DateAndTime.getFormattedCurrency(oneTimeCharge,communicationLanguage);
            this.quantity = quantity;
            this.customerFacingComments = customerFacingComments;
            this.productName =  productName + (String.isBlank(speed) ? '' : ApexConstants.NEW_LINE + System.Label.get('', ApexConstants.LABEL_SPEED, communicationLanguage) + ApexConstants.COLON + speed + ' ' + Label.Mbps) + (term == null ? '': ApexConstants.NEW_LINE + System.Label.get(ApexConstants.VLOCITY_NAMESPACE, ApexConstants.CMEXTERM, communicationLanguage) + ApexConstants.COLON + term + ' ' + System.Label.get(ApexConstants.VLOCITY_NAMESPACE, ApexConstants.CMEXMONTHS, communicationLanguage));
            this.productFamily = productFamily;
            this.recurringCharge = recurringCharge;
            this.recurringChargeFormatted = DateAndTime.getFormattedCurrency(recurringCharge,communicationLanguage);
            this.quoteMemberId = quoteMemberId;
            this.isPromotion = isPromotion;
            this.term = term;
            this.speed = speed;
            this.charge = charge;
            this.chargeFormatted = DateAndTime.getFormattedCurrency(charge,communicationLanguage);
        }
        
        public QuoteLineItem(Decimal oneTimeCharge, Integer quantity, String customerFacingComments, String productName, String productFamily, Decimal recurringCharge, String quoteMemberId, Boolean isPromotion, Integer term, String speed, Decimal charge, String adjustmentType,String communicationLanguage) {
            this.oneTimeCharge = oneTimeCharge;
            this.oneTimeChargeFormatted = DateAndTime.getFormattedCurrency(oneTimeCharge,communicationLanguage);
            this.quantity = quantity;
            this.customerFacingComments = customerFacingComments;
            this.productName =  productName + (String.isBlank(speed) ? '' : ApexConstants.NEW_LINE + System.Label.get('', ApexConstants.LABEL_SPEED, communicationLanguage) + ApexConstants.COLON + speed + ' ' + Label.Mbps) + (term == null ? '': ApexConstants.NEW_LINE + System.Label.get(ApexConstants.VLOCITY_NAMESPACE, ApexConstants.CMEXTERM, communicationLanguage) + ApexConstants.COLON + term + ' ' + System.Label.get(ApexConstants.VLOCITY_NAMESPACE, ApexConstants.CMEXMONTHS, communicationLanguage));
            this.productFamily = productFamily;
            this.recurringCharge = recurringCharge;
            this.recurringChargeFormatted = DateAndTime.getFormattedCurrency(recurringCharge,communicationLanguage);
            this.quoteMemberId = quoteMemberId;
            this.isPromotion = isPromotion;
            this.term = term;
            this.speed = speed;
            this.charge = charge;
            this.chargeFormatted = DateAndTime.getFormattedCurrency(charge,communicationLanguage);
            this.adjustmentType = adjustmentType;
        }
    }
    
    public class AppliedPriceAdjustmentDto {
        public Decimal adjustmentValue {get;set;}
        public Decimal amount {get;set;}
        public String adjustmentId {get;set;}
        public String quoteLineItemId {get;set;}
        public String adjustmentInitiatedFrom {get;set;}
        
        public AppliedPriceAdjustmentDto() { }
        
        public AppliedPriceAdjustmentDto(Decimal adjustmentValue, Decimal amount, String adjustmentId, String quoteLineItemId, String adjustmentInitiatedFrom) {
            this.adjustmentValue = adjustmentValue;
            this.amount = amount;
            this.adjustmentId = adjustmentId;
            this.quoteLineItemId = quoteLineItemId;
            this.adjustmentInitiatedFrom = adjustmentInitiatedFrom;
        }
    }
}