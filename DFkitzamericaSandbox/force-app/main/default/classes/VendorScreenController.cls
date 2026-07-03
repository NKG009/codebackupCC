/****************************
 * Name : VendorScreenController
 * Description : Controller of VendorScreenPage. It is used for selecting vendor Id and populating to given line item record.
 ****************************/

public class VendorScreenController {

    public List<APTS_Vendor__c> vendorsList {get; set;}

    public Boolean errorCheck {get; set;}

    public String errorMessage {get; set;}

    public String lineItemId {get; set;}

    public String selectedVendorId {get; set;}

    public String selectedVendorName {get; set;}

    public String selectedVendorNumber {get; set;}

    public String selectedVendorNo {get; set;}

    public String itemCategory;



    /**
     * Constructor of class to get LineItem Id from parameters and list of vendors to select from on the page load.
     **/
    
    public VendorScreenController() {

        try{

        errorCheck = false;

        errorMessage = '';

        lineItemId = Apexpages.currentPage().getParameters().get('id');

        itemCategory = Apexpages.currentPage().getParameters().get('itemCategory');

        System.debug('lineItemId--'+lineItemId);

        if(String.isNotEmpty(lineItemId)){
            
            vendorsList = getVendorsList();

            System.debug('vendorsList--'+vendorsList);

            if(vendorsList.isEmpty()){
                
                errorCheck = true;

                errorMessage = 'No Vendor Records Found.';
            }

        } else {
            
            errorCheck = true;

            errorMessage = 'Line Item Id not found.';
        }

        } catch (Exception e) {

            System.debug('Exception in VendorScreenController contructor');
            System.debug('Exception message: '+e.getMessage());
            System.debug('Exception Line Number: '+e.getLineNumber());
            System.debug('Exception Cause: '+e.getCause());
            System.debug('Exception StackTrace: '+e.getStackTraceString());

            errorCheck = true;

            errorMessage = 'Error: '+e.getMessage();

        }
    }


    /**
     * Method to get list of all the vendors where APTS_Invalid__c = false AND APTS_Vendor_Acct_Group_Name__c = 'KCA Vendor'.
     **/

    public List<APTS_Vendor__c> getVendorsList(){

        try{

        errorCheck = false;

        errorMessage = '';

        List<APTS_Vendor__c> vendorsList = new List<APTS_Vendor__c>();

        if(String.isNotEmpty(itemCategory) && itemCategory.equals('KB Order(Direct)')){

            vendorsList = [Select Id, Name, APTS_Vendor_Name__c, APTS_Vendor_Acct_Group_Name__c, APTS_Vendor_Acct_Group_ID__c,
                       APTS_Vendor_Number__c, APTS_Vendor_City__c, APTS_Vendor_State__c
                       From APTS_Vendor__c 
                       Where APTS_Invalid__c = false AND APTS_Vendor_Acct_Group_Name__c = 'KCA Vendor'  
                       Order By APTS_Vendor_Name__c Asc
                       Limit 40000
                       ];
        } else if(String.isNotEmpty(itemCategory) && ( itemCategory.equals('Project w/ Spec') || itemCategory.equals('Project w/o Spec') || itemCategory.equals('Project Stock Order') ) ){

            vendorsList = [Select Id, Name, APTS_Vendor_Name__c, APTS_Vendor_Acct_Group_Name__c, APTS_Vendor_Acct_Group_ID__c,
                       APTS_Vendor_Number__c, APTS_Vendor_City__c, APTS_Vendor_State__c
                       From APTS_Vendor__c 
                       Where APTS_Invalid__c = false AND APTS_Vendor_Acct_Group_Name__c = 'Kitz Group Vendor' 
                       Order By APTS_Vendor_Name__c Asc
                       Limit 40000
                       ]; 

        } else {
            
        }

        
                       
                  

        return vendorsList;

        } catch (Exception e) {
            
            System.debug('Exception in getVendorsList method');
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
     * Method to populate selected vendor id from page into given line item record.
     **/

    public void populateVendorIdOnLineItem(){

        try{

        errorCheck = false;

        errorMessage = '';

        System.debug('selectedVendorId----'+selectedVendorId);

        System.debug('selectedVendorNumber----'+selectedVendorNumber);

        if(String.isNotEmpty(selectedVendorId)){

            Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c(Id=lineItemId);
            lineItem.APTS_Vendor_ID__c = selectedVendorId;

            //update lineItem;

            System.debug('updated lineItem----'+lineItem);

        } else {
            errorCheck = true;

            errorMessage = 'Selected Vendor Id is null.';
        }

        } catch (Exception e) {
            
            System.debug('Exception in populateVendorIdOnLineItem method');
            System.debug('Exception message: '+e.getMessage());
            System.debug('Exception Line Number: '+e.getLineNumber());
            System.debug('Exception Cause: '+e.getCause());
            System.debug('Exception StackTrace: '+e.getStackTraceString());

            errorCheck = true;

            errorMessage = 'Error: '+e.getMessage();
        }
    }

}