/*********************************************
* Name : APTS_CustomValidationCallback
* Description : Class to perform custom validation.
*********************************************/

global class APTS_CustomValidationCallback implements Apttus_Config2.CustomClass.IValidationCallback2 {
    
    global Apttus_Config2.CustomClass.ValidationResult validateCart(Apttus_Config2.ProductConfiguration configurationWrapper) {
        System.debug('@@In val callback---'+configurationWrapper.getConfigSO());
        Apttus_Config2.CustomClass.ValidationResult validationResult = new Apttus_Config2.CustomClass.ValidationResult(TRUE);
        List<Apttus_Config2__LineItem__c> lineItemSOList = getLineItemSOList(configurationWrapper);
        String Massupdate = 'No';
        
        for(Apttus_Config2__LineItem__c lineItemSO : lineItemSOList) {
            if(lineItemSO.APTS_Mass_Update__c == 'Yes'){
                Massupdate = lineItemSO.APTS_Mass_Update__c;
                break;
            }            
        }
        
        if(Massupdate != 'Yes'){
        validateProductAvailableQuantity(lineItemSOList, validationResult);
        validateVendorOnLineItem(lineItemSOList, validationResult);
        // validateVendorCost(lineItemSOList, validationResult);
        validateItemCategory(lineItemSOList, validationResult);
        validateWarehouseAndItemCategory(lineItemSOList, validationResult);
        validateInventory(lineItemSOList, validationResult);
        }
        return validationResult;
    }
    
    global Apttus_Config2.CustomClass.ValidationResult validateRampLineItems(Apttus_Config2.ProductConfiguration configurationWrapper, List<Apttus_Config2.LineItem> lineItemWrapperList) {
        return null;
    }
    
    global Apttus_Config2.CustomClass.ValidationResult validateAssetItems(Apttus_Config2.ProductConfiguration configurationWrapper, List<Apttus_Config2__TempRenew__c> tempRenewList) {
        return null;
    }
    
    
    
    private List<Apttus_Config2__LineItem__c> getLineItemSOList(Apttus_Config2.ProductConfiguration configurationWrapper) {
        
        String objectName = 'Apttus_Config2__LineItem__c';
        
        String query = 'SELECT  ';
        query = query + String.join(getFieldNameList(objectName, null), ', ') + ' ';
        query = query + ' FROM ' + objectName;
        query = query + ' WHERE Apttus_Config2__ConfigurationId__c = \'' + configurationWrapper.getConfigSO().Id + '\'';
        
        return Database.query(query);
    }
    
    private List<String> getFieldNameList(String objectName, String referenceName) {
        
        List<String> fieldNameList = new List<String>();
        Map<String, Schema.SObjectField> fieldsMap = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        
        for(String fieldName : fieldsMap.keySet()) {
            Schema.DescribeFieldResult fieldDescribe = fieldsMap.get(fieldName).getDescribe();
            
            if(fieldDescribe.isAccessible() && fieldDescribe.isCustom()) {
                fieldNameList.add(String.isBlank(referenceName) ? fieldName : (referenceName + '.' + fieldName));
            }
        }
        
        return fieldNameList;
    }
    
    private void addValidationMessage(Apttus_Config2.CustomClass.ValidationResult validationResult, ApexPages.Severity severity, String message) {
        System.debug('@@validationResult---' +validationResult);
        if(validationResult != null) {
            validationResult.isSuccess = FALSE;
            validationResult.messages.add(new ApexPages.Message(severity, message));
        }
    }
    
    
    
    /**
* Method to Validate Product Available Quantity for given list of Line Items.
**/
    private void validateProductAvailableQuantity(List<Apttus_Config2__LineItem__c> lineItemSOList, Apttus_Config2.CustomClass.ValidationResult validationResult) {
        try{
            set<id> productidset = new set<id>();
            for(Apttus_Config2__LineItem__c li : lineItemSOList){
                productidset.add(li.Apttus_Config2__ProductId__c);
            }
            
            map<id,product2> productmap = new map<id,product2>([SELECT Id, APTS_Available_Quantity__c FROM Product2 WHERE Id IN :productidset]);
            
            for(Apttus_Config2__LineItem__c lineItemSO : lineItemSOList) {
                if(lineItemSO.APTS_Item_Category__c == 'Stock Order'){
                    String message;
                    
                    Decimal availableQuantity = lineItemSO.APTS_Available_Quantity__c;
                    Integer lineNumber = Integer.valueOf(lineItemSO.Apttus_Config2__LineSequence__c);
                    
                    if(productmap.size() > 0){
                        if(availableQuantity != productmap.get(lineItemSO.Apttus_Config2__ProductId__c).APTS_Available_Quantity__c){
                            message = 'Line # ' + lineNumber + ' - Available Quantity is changed Please reprice the cart';
                            addValidationMessage(validationResult, ApexPages.Severity.ERROR, message); 
                        }
                    }
                }
            }
        }catch(exception e){
            String errormessage;
            errormessage = e.getmessage();
            addValidationMessage(validationResult, ApexPages.Severity.ERROR, errormessage);
        }
    }
    
    
    
    /**
* Method to validate Vendor Name on given list of Line Items.
**/
    public void validateVendorOnLineItem(List<Apttus_Config2__LineItem__c> lineItemSOList, Apttus_Config2.CustomClass.ValidationResult validationResult) {
        
        for(Apttus_Config2__LineItem__c lineItemSO : lineItemSOList) {
            
            String message;
            String itemCategory = lineItemSO.APTS_Item_Category__c;
            String vendorName = lineItemSO.APTS_Vendor_Name__c;
            
            Integer lineNumber = Integer.valueOf(lineItemSO.Apttus_Config2__LineSequence__c);
            
            /* if(('KB Order(Direct)'.equals(itemCategory)|| 'Project w/ Spec'.equals(itemCategory) ||
'Project w/o Spec'.equals(itemCategory) || 'Project Stock Order'.equals(itemCategory))&& String.isEmpty(vendorName)) {*/
            if(('KB Order(Direct)'.equals(itemCategory)|| 'Project w/ Spec'.equals(itemCategory) ||
                'Project w/o Spec'.equals(itemCategory))&& String.isEmpty(vendorName)) {
                    message = 'Line # ' + lineNumber + ' - Vendor selection is mandatory.';
                    addValidationMessage(validationResult, ApexPages.Severity.ERROR, message);
                }
            /* if((!'KB Order(Direct)'.equals(itemCategory)) && (!'Project w/ Spec'.equals(itemCategory)) &&
(!'Project w/o Spec'.equals(itemCategory)) && (!'Project Stock Order'.equals(itemCategory)) && (String.isNOTEmpty(vendorName))) {*/
            if((!'KB Order(Direct)'.equals(itemCategory)) && (!'Project w/ Spec'.equals(itemCategory)) &&
               (!'Project w/o Spec'.equals(itemCategory)) && (String.isNOTEmpty(vendorName))) {
                   message = 'Line # ' + lineNumber + ' - Vendor needs to be NULL.';
                   addValidationMessage(validationResult, ApexPages.Severity.ERROR, message);
               }
        }
    }
    
    /**
* Method to validate Vendor Cost on given list of Line Items.
**/
    private void validateVendorCost(List<Apttus_Config2__LineItem__c> lineItemSOList, Apttus_Config2.CustomClass.ValidationResult validationResult) {
        
        for(Apttus_Config2__LineItem__c lineItemSO : lineItemSOList) {
            
            String message;
            String itemCategory = lineItemSO.APTS_Item_Category__c;
            
            Decimal vendorCost = lineItemSO.APTS_Vendor_Cost__c;
            Integer lineNumber = Integer.valueOf(lineItemSO.Apttus_Config2__LineSequence__c);
            
            system.debug('@@vendorCost--------------' +vendorCost+ '@@item cat=======' +itemCategory);
            /* if('KB Order(Direct)'.equals(itemCategory) && (vendorCost == null || vendorCost == 0)) {
message = 'Line # ' + lineNumber + ' - Vendor Cost can not be zero or blank.';
addValidationMessage(validationResult, ApexPages.Severity.ERROR, message);
}

if(!'KB Order(Direct)'.equals(itemCategory) && vendorCost != null && vendorCost > 0) {
message = 'Line # ' + lineNumber + ' - Vendor Cost must be zero or blank for selected Item Category.';
addValidationMessage(validationResult, ApexPages.Severity.ERROR, message);
}*/
        }
    }
    
    
    /**
* Method for Item Category based validation
**/
    private void validateItemCategory(List<Apttus_Config2__LineItem__c> lineItemSOList, Apttus_Config2.CustomClass.ValidationResult validationResult) {
        
        for(Apttus_Config2__LineItem__c lineItemSO : lineItemSOList) {
            
            String message;
            String itemCategory = lineItemSO.APTS_Item_Category__c;
            String specPkgCode = lineItemSO.APTS_Spec_Pkg_Code__c;
            String specDesc = lineItemSO.APTS_Spec_Desc__c;
            
            Decimal cost = lineItemSO.Apttus_Config2__Cost__c;
            Decimal baseCostOverride = lineItemSO.Apttus_Config2__BaseCostOverride__c;
            Decimal factoryModCost = lineItemSO.APTS_Vendor_Cost__c;
            Decimal basePriceOverride = lineItemSO.Apttus_Config2__BasePriceOverride__c;
            Integer lineNumber = Integer.valueOf(lineItemSO.Apttus_Config2__LineSequence__c);
            
            if(String.isNotEmpty(itemCategory)){
                
                if('Indent Order(Product)'.equals(itemCategory)) {
                    
                    if(String.isEmpty(specPkgCode)) {
                        message = 'Line # ' + lineNumber + ' - Invalid Item Category since Spec Pkg Code is BLANK.';
                        addValidationMessage(validationResult, ApexPages.Severity.ERROR, message);
                    }
                    
                    else if(String.isNotEmpty(specPkgCode) && (cost == null || cost == 0) && (factoryModCost == null || factoryModCost == 0)) {
                        message = 'Line # ' + lineNumber + ' - Factory/Mod Cost cannot be NULL or 0.';
                        addValidationMessage(validationResult, ApexPages.Severity.ERROR, message);
                    }
                }
                
                if('KB Order(Direct)'.equals(itemCategory) && (factoryModCost == null || factoryModCost == 0)) {
                    message = 'Line # ' + lineNumber + ' - Factory/Mod Cost can not be zero or blank.';
                    addValidationMessage(validationResult, ApexPages.Severity.ERROR, message);
                }
                
                if('Individual Spec'.equals(itemCategory)) {
                    
                    if(String.isNotEmpty(specPkgCode)) {
                        message = 'Line # ' + lineNumber + ' - Invalid Item Category since Spec Pkg Code is NOT BLANK.';
                        addValidationMessage(validationResult, ApexPages.Severity.ERROR, message);
                    }
                    
                    else if(String.isEmpty(specPkgCode) && String.isEmpty(specDesc) /* && baseCostOverride > 0 */ ) {
                        message = 'Line # ' + lineNumber + ' - Spec Desc cannot be Empty.';
                        addValidationMessage(validationResult, ApexPages.Severity.ERROR, message);
                    }
                    
                    else if(String.isEmpty(specPkgCode) && String.isNotEmpty(specDesc) && (cost == null || cost == 0) && (factoryModCost == null || factoryModCost == 0)) {
                        message = 'Line # ' + lineNumber + ' - Factory/Mod Cost cannot be NULL or 0.';
                        addValidationMessage(validationResult, ApexPages.Severity.ERROR, message);
                    }
                    /*
else if(String.isEmpty(specPkgCode) && String.isEmpty(specDesc) &&  (baseCostOverride == null || baseCostOverride == 0)) {
message = 'Line # ' + lineNumber + ' - Spec Desc cannot be Empty and Custom Cost cannot be NULL or 0.';
addValidationMessage(validationResult, ApexPages.Severity.ERROR, message);
}*/
                }
                
                if('Indent Order(Parts)'.equals(itemCategory) && (cost == null || cost == 0) && (factoryModCost == null || factoryModCost == 0)) {
                    message = 'Line # ' + lineNumber + ' - Factory/Mod Cost cannot be NULL or 0.';
                    addValidationMessage(validationResult, ApexPages.Severity.ERROR, message);
                }
                
                if('KB Order(Direct)'.equals(itemCategory) && String.isEmpty(specDesc)) {
                    
                    system.debug('@@specDesc--------------' +specDesc+ '@@item cat=======' +itemCategory);
                    
                    message = 'Line # ' + lineNumber + ' - Spec Desc cannot be Empty.';
                    addValidationMessage(validationResult, ApexPages.Severity.ERROR, message); 
                }
                
                if(('Project Stock Order'.equals(itemCategory) || 'Stock Order'.equals(itemCategory) || 'Consigned Stock Order'.equals(itemCategory) ) && factoryModCost != null ){
                    message = 'Line # ' + lineNumber + ' Factory/Mod Cost must be blank for selected Item Category.';
                    addValidationMessage(validationResult, ApexPages.Severity.ERROR, message);
                }
                
                if('Project w/ Spec'.equals(itemCategory) || 'Project w/o Spec'.equals(itemCategory) ){
                    
                    if(String.isEmpty(specDesc)){
                        message = 'Line # ' + lineNumber + ' Spec Desc cannot be Empty.';
                        addValidationMessage(validationResult, ApexPages.Severity.ERROR, message);
                    }
                    if(factoryModCost == null || factoryModCost == 0){
                        message = 'Line # ' + lineNumber + 'Factory/Mod Cost cannot be NULL or 0.';
                        addValidationMessage(validationResult, ApexPages.Severity.ERROR, message);
                    }
                    if(basePriceOverride == null || basePriceOverride == 0){
                        message = 'Line # ' + lineNumber + ' Custom Unit Price is required. Please enter Adjustment Amount or Override Multiplier and reprice the cart.';
                        addValidationMessage(validationResult, ApexPages.Severity.ERROR, message);
                    }
                }
            } else {
                message = 'Line # ' + lineNumber + ' - Item Category cannot be NULL.';
                addValidationMessage(validationResult, ApexPages.Severity.ERROR, message);
            }
        }
    }
    
    
    /**
* Method to Validate Warehouse and Item Category for given list of Line Items.
**/
    private void validateWarehouseAndItemCategory(List<Apttus_Config2__LineItem__c> lineItemSOList, Apttus_Config2.CustomClass.ValidationResult validationResult) {
        
        for(Apttus_Config2__LineItem__c lineItemSO : lineItemSOList) {
            
            String message;
            String itemCategory = lineItemSO.APTS_Item_Category__c;
            String warehouseName = lineItemSO.APTS_Warehouse_Name__c;
            String warehouseNumber = lineItemSO.APTS_Warehouse_Number__c;
            String warehouseLocation = lineItemSO.APTS_Warehouse_Location__c;
            String specDesc = lineItemSO.APTS_Spec_Desc__c;
            
            Decimal availableQuantity = lineItemSO.APTS_Available_Quantity__c;
            Integer lineNumber = Integer.valueOf(lineItemSO.Apttus_Config2__LineSequence__c);
            
            
            if(('KB Order(Direct)'.equals(itemCategory) || 'Individual Spec'.equals(itemCategory))
               && ((String.isNotBlank(warehouseName) || String.isNotBlank(warehouseNumber) || String.isNotBlank(warehouseLocation) || availableQuantity != null)))
            {
                message = 'Line # ' + lineNumber + ' - Warehouse fields need to be null for selected Item Category. Please reprice the cart.';
                addValidationMessage(validationResult, ApexPages.Severity.ERROR, message); 
            }        
            
            if(('Indent Order(Product)'.equals(itemCategory) || 'Indent Order(Parts)'.equals(itemCategory))
               // && (warehouseName != 'InTransit' || warehouseNumber == '3099' || String.isNotBlank(warehouseLocation) || availableQuantity != null))
               && (warehouseNumber <> '3099'))
            {
                message = 'Line # ' + lineNumber + ' - Invalid Item Category for selected Warehouse. Please correct Item Category or re-select a different warehouse and reprice.';
                addValidationMessage(validationResult, ApexPages.Severity.ERROR, message); 
            }  
            
            if(!'Stock Order'.equals(itemCategory) && '3008'.equals(warehouseNumber)) {
                message = 'Line # ' + lineNumber + ' - Invalid Item Category for selected Warehouse. Please correct Item Category or re-select a different warehouse and reprice.';
                addValidationMessage(validationResult, ApexPages.Severity.ERROR, message); 
            } 
            
            if(String.isNotBlank(warehouseNumber) && warehouseNumber.contains('30W') && !'Consigned Stock Order'.equals(itemCategory)){
                message = 'Line # ' + lineNumber + ' - Invalid Item Category for selected Warehouse. Please correct Item Category or re-select a different warehouse and reprice.';
                addValidationMessage(validationResult, ApexPages.Severity.ERROR, message); 
            }
            
            if(('Consigned Stock Order'.equals(itemCategory) || 'Stock Order'.equals(itemCategory) || 
                'Indent Order(Product)'.equals(itemCategory) || 'Indent Order(Parts)'.equals(itemCategory)) &&
               String.isNotBlank(specDesc)) {
                   message = 'Line # ' + lineNumber + ' - Spec Desc must be blank for selected Item Category.';
                   addValidationMessage(validationResult, ApexPages.Severity.ERROR, message); 
               }             
        }
    }
    /**
* Method to validate Available inventory.
**/
    public void validateInventory(List<Apttus_Config2__LineItem__c> lineItemSOList, Apttus_Config2.CustomClass.ValidationResult validationResult) {
        
        for(Apttus_Config2__LineItem__c lineItemSO : lineItemSOList) {
            String message;
            String itemCategory = lineItemSO.APTS_Item_Category__c;
            String Massupdate = lineItemSO.APTS_Mass_Update__c;
            Decimal estavailableqty = lineItemSO.APTS_Est_Available_Quantity__c;            
            String whNumber = lineItemSO.APTS_Warehouse_Number__c;
            Decimal finalUnitPrice = lineItemSO.APTS_Final_Unit_Price__c;            
            
            Integer lineNumber = Integer.valueOf(lineItemSO.Apttus_Config2__LineSequence__c);
            
            if(estavailableqty < 0 && (whNumber <> '3099' && whNumber <> null) && !'Individual Spec'.equals(itemCategory) && Massupdate == 'No') {
                message = 'Line # ' + lineNumber + ' - Insufficient inventory at the selected warehouse.';
                addValidationMessage(validationResult, ApexPages.Severity.Warning, message);
            }
            
            if(finalUnitPrice == 0){
                message = 'Line # ' + lineNumber + ' - Final Unit price cannot be 0.';
                addValidationMessage(validationResult, ApexPages.Severity.ERROR, message);
            }            
        }
    }
}