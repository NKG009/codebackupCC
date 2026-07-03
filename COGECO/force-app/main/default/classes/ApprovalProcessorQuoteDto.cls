public without sharing class ApprovalProcessorQuoteDto {
    public String quoteId {get;set;}
    public String quotePriceListId {get;set;}
    public Boolean quoteApprovalRequired {get;set;}
    public Boolean quoteBusinessCaseRequired {get;set;}
    public String territoryProvince {get;set;}
    public Decimal buildCost {get;set;}
}