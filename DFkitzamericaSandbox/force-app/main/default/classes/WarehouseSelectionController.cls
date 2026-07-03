/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This is Controller Class for WarehouseSelectionPage
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Sumit   <sumit.m@standav.com>
* @modifiedBy     Sumit   <sumit.m@standav.com>
* @maintainedBy   Sumit   <sumit.m@standav.com>
* @version        1.0
* @created        2020-04-22
* @modified       2020-05-14
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/

public class WarehouseSelectionController {
    
    public String productConfigId;
    
    public Boolean errorCheck {get; set;}
    
    public String errorMessage {get; set;}
    
    public List<Apttus_Config2__LineItem__c> configLineItemList {get; set;}
    
    public String quoteNumber {get; set;}
    
    public PageReference cartPage;
    
    
    /**
* Constructor of class to get product configuration Id from parameters and get Line Items on the page load.
**/
    
    public WarehouseSelectionController() {
        
        try {
            
            System.debug('params----'+ApexPages.currentPage().getParameters());
            
            
            cartPage = Page.Apttus_Config2__Cart;
            
            for(String key : ApexPages.currentPage().getParameters().keySet()) {
                cartPage.getParameters().put(key, ApexPages.currentPage().getParameters().get(key));
                system.debug('key'+key);     
            }
            
            
            cartPage.setRedirect(false);
            cartPage.setAnchor('!/cartgrid');
            
            
            
            System.debug('params2----'+cartPage);
            
            
            productConfigId = ApexPages.currentPage().getParameters().get('id');
            
            if(String.isNotEmpty(productConfigId)){
                
                configLineItemList = getConfigLineItemData();
                System.debug('@@@configLineItemList=====' +configLineItemList);
            } else {
                errorCheck = true;
                
                errorMessage = 'Error: '+'Product Configuration Id not found.';
            }
            
        } catch (Exception e) {
            System.debug('Exception in WarehouseSelectionController constructor');
            System.debug('Exception message: '+e.getMessage());
            System.debug('Exception Line Number: '+e.getLineNumber());
            System.debug('Exception Cause: '+e.getCause());
            System.debug('Exception StackTrace: '+e.getStackTraceString());
            
            errorCheck = true;
            
            errorMessage = 'Error: '+e.getMessage();
        }
    }
    
    
    /**
* Method to get list of all the line items for given configuration id.
**/
    
    public List<Apttus_Config2__LineItem__c> getConfigLineItemData(){
        
        try {
            
            errorCheck = false;
            
            errorMessage = '';
            
            List<Apttus_Config2__LineItem__c> configLineItemList = new List<Apttus_Config2__LineItem__c>();
            
            configLineItemList = [Select Id, Name, Apttus_Config2__ProductId__c, APTS_Material_Num__c, Apttus_Config2__Quantity__c, APTS_KCA_Fig_Num__c,
                                  APTS_Item_Category__c, APTS_Customer_PO_Line_Number__c, APTS_Warehouse_Name__c, APTS_Warehouse_Number__c,
                                  APTS_Size_inch__c, Apttus_Config2__LineNumber__c, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Name,
                                  APTS_Est_Available_Quantity__c, APTS_Available_Quantity__c, APTS_Warehouse_Location__c, Apttus_Config2__LineSequence__c    
                                  From Apttus_Config2__LineItem__c Where Apttus_Config2__ConfigurationId__c = :productConfigId 
                                  Order By Apttus_Config2__LineSequence__c Asc
                                 ];
            if (!configLineItemList.isEmpty()) {
                quoteNumber = configLineItemList[0].Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Name;
            }
            return configLineItemList;
            
        } catch (Exception e) {
            
            System.debug('Exception in getConfigLineItemData method');
            System.debug('Exception message: '+e.getMessage());
            System.debug('Exception Line Number: '+e.getLineNumber());
            System.debug('Exception Cause: '+e.getCause());
            System.debug('Exception StackTrace: '+e.getStackTraceString());
            
            errorCheck = true;
            errorMessage = 'Error: '+e.getMessage();
            return null;
        }
    }
    
    /**
* Method to for handling error messages from page.
**/
    
    public void handleError(){
        errorCheck = true;
    }
    
    
    /**
* Method to cancel the transaction and go back to cart page.
**/
    
    public PageReference cancel(){
        return cartPage;
    } 
    
    /**
* Method to save the line item list with changes.
**/
    
    public Pagereference saveLineItems(){
        System.debug('@@save  -----------------' +configLineItemList);
        if(!configLineItemList.isEmpty()){
            
            for(Apttus_Config2__LineItem__c lineItem : configLineItemList){
                lineItem.Apttus_Config2__PricingStatus__c = 'Pending';
            }
            
            update configLineItemList;
        }
        return null;
    }
    
    
    /**
* Method to save the line item list with changes and go back to cart.
**/
    
    public Pagereference saveAndBackToCart(){
        System.debug('@@save cart -----------------' +configLineItemList);
        if(!configLineItemList.isEmpty()){
            
            for(Apttus_Config2__LineItem__c lineItem : configLineItemList){
                lineItem.Apttus_Config2__PricingStatus__c = 'Pending';
            }
            
            update configLineItemList;
        }
        return cartPage;
    }
}