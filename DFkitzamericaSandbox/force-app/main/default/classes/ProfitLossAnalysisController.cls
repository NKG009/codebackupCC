/**
    * ─────────────────────────────────────────────────────────────────────────────────────────────────┐
    * This class is controller for ProfitLossAnalysisPage
    * ──────────────────────────────────────────────────────────────────────────────────────────────────
    * @author         Sumit   <sumit.m@standav.com>
    * @modifiedBy     Sumit   <sumit.m@standav.com>
    * @maintainedBy   Sumit   <sumit.m@standav.com>
    * @version        1.0
    * @created        2020-04-06
    * @modified       2020-04-29
    * ────────────────────────────────────────────────────────────────────────────────────────────────── 
	*/

public with sharing class ProfitLossAnalysisController {

    public List<ProfitVsLoss__c> profitVsLossAnalysisSettingList {get; set;}

    public List<Apttus_Config2__LineItem__c> configLineItemList {get; set;}

    public String productConfigurationId;

    public Apttus_Config2__ProductConfiguration__c productConfigurationObj {get; set;}

    public Boolean noResultCheck {get; set;}

    public String noResultMessage {get; set;}

    public Boolean errorCheck {get; set;}

    public String errorMessage {get; set;}
    
    public String currencySymbol {get; set;}


    /**************************************Methods*************************************************/
    
    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * Constructor of the class to product configuration Id from url and fetch line item data
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    none
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    
    public ProfitLossAnalysisController() {

        try {

        noResultCheck = false;

        noResultMessage = '';

        errorCheck = false;
            
        productConfigurationId = Apexpages.currentPage().getParameters().get('id');

        if(String.isNotEmpty(productConfigurationId)){
            
            profitVsLossAnalysisSettingList = getCustomSettingData();

            if(!profitVsLossAnalysisSettingList.isEmpty()){

                configLineItemList = getConfigLineItemData();

            } else {
                noResultCheck = true;

                noResultMessage = 'ProfitVsLossAnalysisSetting records not found. Please Contact System Admin';
            }


        } else {

            noResultCheck = true;

            noResultMessage = 'Product Configuration Id not found. Please try again.';
        }   

        } catch (Exception e) {

            System.debug('Exception in ProfitLossAnalysisController contructor');
            System.debug('Exception message: '+e.getMessage());
            System.debug('Exception Line Number: '+e.getLineNumber());
            System.debug('Exception Cause: '+e.getCause());
            System.debug('Exception StackTrace: '+e.getStackTraceString());

            errorCheck = true;

            errorMessage = e.getMessage();

        }

        
        
    }

    
    
    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * Method to fetch profitVsLossAnalysis custom setting which contains fields Label, API Name and
    * sequence
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    none
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */

    public List<ProfitVsLoss__c> getCustomSettingData(){

        try {

            noResultCheck = false;

            noResultMessage = '';
            
            List<ProfitVsLoss__c> profitVsLossAnalysisSettingList = new List<ProfitVsLoss__c>();

            profitVsLossAnalysisSettingList = [Select Id, Name, APIName__c, Order__c From ProfitVsLoss__c Order By Order__c Asc];

            return profitVsLossAnalysisSettingList;

        } catch (Exception e) {
            
            System.debug('Exception in getCustomSettingData method');
            System.debug('Exception message: '+e.getMessage());
            System.debug('Exception Line Number: '+e.getLineNumber());
            System.debug('Exception Cause: '+e.getCause());
            System.debug('Exception StackTrace: '+e.getStackTraceString());

            errorCheck = true;

            errorMessage = e.getMessage();

            return null;
        }
        
        
    }


    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * Method to fetch LineItems for the given product configuration Id.
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    none
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */

    public List<Apttus_Config2__LineItem__c> getConfigLineItemData(){

        try {

            noResultCheck = false;

            noResultMessage = '';

            List<Apttus_Config2__LineItem__c> configLineItemList = new List<Apttus_Config2__LineItem__c>();
            
            String query = 'Select Id ';

            Boolean fieldNullCheck = false;

            for (ProfitVsLoss__c ProfitVsLossAnalysis  : profitVsLossAnalysisSettingList) {
                
                if(String.isNotEmpty(ProfitVsLossAnalysis.APIName__c)){

                    query += ', '+ProfitVsLossAnalysis.APIName__c;

                    fieldNullCheck = true;
                }
            }

            if(fieldNullCheck){

                query += ' From Apttus_Config2__LineItem__c Where Apttus_Config2__ConfigurationId__c = \''+productConfigurationId+'\' Order By Apttus_Config2__LineSequence__c Asc';
                configLineItemList = Database.query(query);

                if(!configLineItemList.isEmpty()){

                    productConfigurationObj = [Select Id, Apttus_QPConfig__Proposald__r.Name, APTS_Total_Net_Price__c, APTS_Total_Ext_Cost__c, APTS_Total_Ext_Profit__c, APTS_Total_Ext_Profit_Percent__c, Apttus_Config2__PriceListId__r.Name From Apttus_Config2__ProductConfiguration__c Where Id = :productConfigurationId LIMIT 1][0];
                    /*if(productConfigurationObj.Apttus_Config2__PriceListId__r.Name == 'Standard USD PriceList'){
                        currencySymbol = '$';
                    } else {currencySymbol = '';}*/
                    ConnectApi.OrganizationSettings orgSetting = ConnectApi.Organization.getSettings();
                    currencySymbol = orgSetting.features.defaultCurrencyIsoCode;
                    


               
                } else {
                    noResultCheck = true;

                    noResultMessage = 'No results found for Configuration Line Item.';
                    
                }
            } else {

                noResultCheck = true;

                noResultMessage = 'No Fields found to query for configuration line item.';
                
            }

            return configLineItemList;

        } catch (Exception e) {
            
            System.debug('Exception in getConfigLineItemData method');
            System.debug('Exception message: '+e.getMessage());
            System.debug('Exception Line Number: '+e.getLineNumber());
            System.debug('Exception Cause: '+e.getCause());
            System.debug('Exception StackTrace: '+e.getStackTraceString());

            errorCheck = true;

            errorMessage = e.getMessage();

            return null;
        }
    }

}