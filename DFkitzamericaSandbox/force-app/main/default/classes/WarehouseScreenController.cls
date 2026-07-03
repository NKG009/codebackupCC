public class WarehouseScreenController {
    public Apttus_Config2__LineItem__c lineItemDetails {get; set;} 
    
    public Boolean errorCheck {get; set;}
    
    public String errorMessage {get; set;}
    
    public String lineItemId {get; set;}
    
    public String selectedWarehouseName {get; set;}
    public String selectedWarehouseNo {get; set;}
    public String selectedWarehouseLocation {get; set;}
    public Decimal availQnty {get; set;}
    
    public String selectedMtrNo {get; set;}
    
    public String Body;
    
    public InventoryData Inventdata;
    
    public list<InventoryData.IDENT_Data> Indentlst {get; set;}
    
    public list<InventoryData.WAREHOUSE_Data> WHlst {get; set;}
    
    public list<InventoryData.RESTOCK_Data> Restocklst {get; set;}
    
    public list<InventoryData.ETA_Data> ETAlst {get; set;}
    
    public list<InventoryData.ALLOCATION_Data> Allocationlst {get; set;}
    
    public Boolean restockmsg {get; set;}
    
    public Boolean Indentmsg {get; set;}
    
    public Boolean Allocationmsg {get; set;}
    
    /**
* Constructor of class to get LineItem Id from parameters and list of WH details to select from on the page load.
**/
    
    public WarehouseScreenController() {
        Indentlst = new list<InventoryData.IDENT_Data> ();
        WHlst = new list<InventoryData.WAREHOUSE_Data> ();
        Restocklst = new list<InventoryData.RESTOCK_Data> ();
        ETAlst = new list<InventoryData.ETA_Data> ();
        Allocationlst = new list<InventoryData.ALLOCATION_Data>();
        try{
            selectedMtrNo = ApexPages.currentPage().getParameters().get('mtrno');
            
            if(selectedMtrNo != null){
                InventoryCallout call = new InventoryCallout();
                
                Body = call.callInventory(selectedMtrNo, 'ALL');
                
                Inventdata = new  InventoryData(System.JSON.createParser(Body));
                
                Indentlst = Inventdata.INDENT.IDENT_Data;
                WHlst = Inventdata.WAREHOUSE.WAREHOUSE_Data;                
                
            }
            
            errorCheck = false;
            
            errorMessage = '';
            
            lineItemId = Apexpages.currentPage().getParameters().get('id');
            
            System.debug('lineItemId--'+lineItemId);
            
            if(String.isNotEmpty(lineItemId)){
                
                lineItemDetails = getLineItemDetails();
                System.debug('lineItemDetails--'+lineItemDetails);
                
            } else {
                
                errorCheck = true;
                
                errorMessage = 'Line Item Id not found.';
            }
            
        } catch (Exception e) {
            
            
            System.debug('Exception in WarehouseScreenController contructor');
            System.debug('Exception message: '+e.getMessage());
            System.debug('Exception Line Number: '+e.getLineNumber());
            System.debug('Exception Cause: '+e.getCause());
            System.debug('Exception StackTrace: '+e.getStackTraceString());
            
            errorCheck = true;
            
            errorMessage = 'Error: '+e.getMessage();
            
        }
    }
    
    
    /**
* Method to get selected Line Item.
**/
    
    public Apttus_Config2__LineItem__c getLineItemDetails(){
        
        try{
            
            errorCheck = false;
            
            errorMessage = '';
            
            Apttus_Config2__LineItem__c warehouseDetail = [Select Id, APTS_Material_Num__c, APTS_KCA_Fig_Num__c, APTS_Size_inch__c,
                                                           Apttus_Config2__LineNumber__c, Apttus_Config2__LineSequence__c   
                                                           From Apttus_Config2__LineItem__c Where id = :lineItemId];
            
            return warehouseDetail;
            
        } catch (Exception e) {
            
            System.debug('Exception in getWarehouseDetails method');
            System.debug('Exception message: '+e.getMessage());
            System.debug('Exception Line Number: '+e.getLineNumber());
            System.debug('Exception Cause: '+e.getCause());
            System.debug('Exception StackTrace: '+e.getStackTraceString());
            
            errorCheck = true;
            
            errorMessage = 'Error: '+e.getMessage();
            
            return null;
        }
    }   
    
    
    public void getMockDataForRestockOrderAndETA(){
        if(Inventdata != null) { 
            Restocklst = Inventdata.RESTOCK.RESTOCK_Data;
            ETAlst = Inventdata.ETA.ETA_Data;
            
            if(Restocklst.size() == 0 && ETAlst.size() == 0){     
            //if((Restocklst.size() == 0 && ETAlst.size() == 0) || (Restocklst.size() == 0 && ETAlst.size() <> 0) || (Restocklst.size() <> 0 && ETAlst.size() == 0)){
                restockmsg = true;
            } else { 
                if (Restocklst.size() < ETAlst.size()) {
                    String jsonBody = '{"PO_NUMBER": "","LINE_NUMBER": "","AVAIL_DATE": ""}';
                    JSONParser parser = JSON.createParser(jsonBody);
                    for(Integer i = Restocklst.size(); i < ETAlst.size(); i++) {
                        Restocklst.add(new InventoryData.RESTOCK_Data(parser));
                    }
                }
                
                for(Integer i = 0; i < ETAlst.size(); i++) {
                    Restocklst[i].ETA_REC_REQD_QTY_ALT_UOM = ETAlst[i].REC_REQD_QTY_ALT_UOM;
                    Restocklst[i].ETA_AVAIL_DATE = ETAlst[i].AVAIL_DATE; 	 
                }
            }
        }
        else
            restockmsg = true;
    }
    
    public void getMockDataForIndentETA(){
        if(Inventdata != null) { 
            Indentlst = Inventdata.INDENT.IDENT_Data;
            if(Indentlst.size() == 0){
                Indentmsg = true;
            }
        }
        else
            
            Indentmsg = true;
    }
    
    public void getMockDataForAllocation(){
        if(Inventdata != null) { 
            Allocationlst = Inventdata.ALLOCATION.ALLOCATION_Data;
            if(Allocationlst.size() == 0){           
                Allocationmsg = true;
            }
        }
        else      
            Allocationmsg = true;
    }
    
    /**
* Method to populate selected warehouse from page into given line item record.
**/
    
    public void populateWareHouseOnLineItem(){
        
        try{
            
            errorCheck = false;
            
            errorMessage = '';
            
            if(String.isNotEmpty(selectedWarehouseName)){
                Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c(Id=lineItemId);
                lineItem.APTS_Warehouse_Name__c = selectedWarehouseName;
                lineItem.APTS_Warehouse_Number__c = selectedWarehouseNo;
                lineItem.APTS_Warehouse_Location__c = selectedWarehouseLocation;
                lineItem.APTS_Available_Quantity__c = availQnty;
                
            } else {
                errorCheck = true;
                
                errorMessage = 'Selected warehouse is null.';
            }
            
        } catch (Exception e) {
            
            System.debug('Exception in populateWareHouseOnLineItem method');
            System.debug('Exception message: '+e.getMessage());
            System.debug('Exception Line Number: '+e.getLineNumber());
            System.debug('Exception Cause: '+e.getCause());
            System.debug('Exception StackTrace: '+e.getStackTraceString());
            
            errorCheck = true;
            
            errorMessage = 'Error: '+e.getMessage();
        }
        
    }
}