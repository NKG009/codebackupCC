/****************************
 * Name : VendorWarehouseSelectionController
 * Description : Controller of VendorWarehouseSelectionPage. It is used for selecting vendor Id or Warehouse and populating to given line item records.
 ****************************/

public class VendorWarehouseSelectionController {

    public String productConfigId;

    public Boolean errorCheck {get; set;}

    public String errorMessage {get; set;}

    public List<Apttus_Config2__LineItem__c> configLineItemList {get; set;}

    public PageReference cartPage;


    /**
     * Constructor of class to get product configuration Id from parameters and get Line Items on the page load.
     **/

    public VendorWarehouseSelectionController() {

        try {

        System.debug('params----'+ApexPages.currentPage().getParameters().keySet());
            
        cartPage = Page.Apttus_Config2__Cart;

        for(String key : ApexPages.currentPage().getParameters().keySet()) {
            cartPage.getParameters().put(key, ApexPages.currentPage().getParameters().get(key));
        }
        
        cartPage.setRedirect(true);
        cartPage.setAnchor('!/cartgrid');

        productConfigId = ApexPages.currentPage().getParameters().get('id');

        if(String.isNotEmpty(productConfigId)){
            
            configLineItemList = getConfigLineItemData();
        } else {
            errorCheck = true;

            errorMessage = 'Error: '+'Product Configuration Id not found.';
        }

        } catch (Exception e) {
            System.debug('Exception in VendorWarehouseSelectionController constructor');
            System.debug('Exception message: '+e.getMessage());
            System.debug('Exception Line Number: '+e.getLineNumber());
            System.debug('Exception Cause: '+e.getCause());
            System.debug('Exception StackTrace: '+e.getStackTraceString());

            errorCheck = true;

            errorMessage = 'Error: '+e.getMessage();
        }
    }

    // public void checkUpdatedList(){
    //     System.debug('checkUpdatedList-----'+configLineItemList);
    // }

    /**
     * Method to get list of all the line items for given configuration id.
     **/

    public List<Apttus_Config2__LineItem__c> getConfigLineItemData(){

        try {

            errorCheck = false;

            errorMessage = '';

            List<Apttus_Config2__LineItem__c> configLineItemList = new List<Apttus_Config2__LineItem__c>();
    
            configLineItemList = [Select Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.Name, APTS_Material_Num__c, Apttus_Config2__Quantity__c,
                                  APTS_Item_Category__c, APTS_Vendor_Number__c, APTS_Vendor_Name__c, APTS_Warehouse_Name__c, APTS_Warehouse_Number__c,
                                  APTS_Vendor_ID__c, Apttus_Config2__LineNumber__c, Apttus_Config2__ConfigStatus__c, Apttus_Config2__LineSequence__c 
                                  From Apttus_Config2__LineItem__c 
                                  Where Apttus_Config2__ConfigurationId__c = :productConfigId Order By Apttus_Config2__LineSequence__c Asc
                                 ];
                                 //APTS_Item_Category__c = 'KB Order(Direct)' AND 

            System.debug('configLineItemList--->'+configLineItemList);
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
    
//    public PageReference saveAndReturn(){
//        System.debug('configLineItemList@@'+configLineItemList);
//         if(!configLineItemList.isEmpty()){
//             update configLineItemList;
//         }
//         return new PageReference('javascript:self.close()');
//     }

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

        //return new PageReference('javascript:window.close();');
    } 


    public void saveLineItems(){
        
        if(!configLineItemList.isEmpty()){
            update configLineItemList;
        }
    }


    /**
     * Method to save the line item list with changes and go back to cart.
     **/

    public Pagereference saveAndBackToCart(){
		System.debug('configLineItemList@@'+configLineItemList);
        if(!configLineItemList.isEmpty()){
            update configLineItemList;
        }

        //return new PageReference('javascript:window.close();');
        return cartPage;
    }

}