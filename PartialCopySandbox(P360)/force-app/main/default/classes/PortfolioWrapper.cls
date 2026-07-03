public class PortfolioWrapper{    
    @AuraEnabled public String name{get;set;}
    @AuraEnabled public Decimal value{get;set;}
    @AuraEnabled public Decimal total{get;set;}
    @AuraEnabled public Decimal percentage{get;set;}
    @AuraEnabled public String message{get;set;}    
    @AuraEnabled public Decimal teamValue{get;set;}
    @AuraEnabled public Decimal teamTotal{get;set;}
    @AuraEnabled public Decimal teamPercentage{get;set;}
    @AuraEnabled public String teamMessage{get;set;}    
    @AuraEnabled public List<PortfolioWrapper> myPortfolioList{get;set;}        
    public PortfolioWrapper(String aName, Decimal aValue, Decimal aTotal){
        name = aName;
        value = aValue;
        total = aTotal;
        percentage = value.divide(total, 2, System.RoundingMode.HALF_EVEN) * 100;    
        myPortfolioList = new List<PortfolioWrapper>();
    }
    public PortfolioWrapper(){
        myPortfolioList = new List<PortfolioWrapper>();
    }
}