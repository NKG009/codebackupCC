/**
    * ─────────────────────────────────────────────────────────────────────────────────────────────────┐
    * This is Test Class for ProfitLossAnalysisPage
    * ──────────────────────────────────────────────────────────────────────────────────────────────────
    * @author         Sumit   <sumit.m@standav.com>
    * @modifiedBy     Sumit   <sumit.m@standav.com>
    * @maintainedBy   Sumit   <sumit.m@standav.com>
    * @version        1.0
    * @created        2020-04-08
    * @modified       2020-04-08
    * ────────────────────────────────────────────────────────────────────────────────────────────────── 
	*/

@isTest
public class ProfitLossAnalysisController_Test {
    
    /**************************************Methods*************************************************/
    
    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * Method to test config lineitem data.
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    none
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */

    @isTest
    static void testConfigLineItem(){

        ProfitVsLoss__c profitLossSettingObj = new ProfitVsLoss__c();
        profitLossSettingObj.Name = 'Base Cost';
        profitLossSettingObj.APIName__c = 'Apttus_Config2__BaseCost__c';
        profitLossSettingObj.Order__c = 1;

        insert profitLossSettingObj;

        Apttus_Config2__ProductConfiguration__c productConfig = new Apttus_Config2__ProductConfiguration__c();
        productConfig.Name = 'test config 1';
        
        insert productConfig;

        Apttus_Config2__LineItem__c productConfigLineItem = new Apttus_Config2__LineItem__c();
        productConfigLineItem.Apttus_Config2__BasePrice__c = 10;
        productConfigLineItem.Apttus_Config2__BaseCost__c = 5;
        productConfigLineItem.Apttus_Config2__ConfigurationId__c = productConfig.Id;
        productConfigLineItem.Apttus_Config2__ItemSequence__c = 1;
        productConfigLineItem.Apttus_Config2__LineNumber__c = 1;

        insert productConfigLineItem;

        Apexpages.currentPage().getParameters().put('id',productConfig.Id);

        ProfitLossAnalysisController profitLossController = new ProfitLossAnalysisController();
    }


    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * Method to test no custom settings fields found.
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    none
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */

    @isTest
    static void testNoCustomSettingFields(){

        ProfitVsLoss__c profitLossSettingObj = new ProfitVsLoss__c();
        profitLossSettingObj.Name = 'Base Cost';
        //profitLossSettingObj.APIName__c = 'Apttus_Config2__BaseCost__c';
        profitLossSettingObj.Order__c = 1;

        insert profitLossSettingObj;

        Apttus_Config2__ProductConfiguration__c productConfig = new Apttus_Config2__ProductConfiguration__c();
        productConfig.Name = 'test config 1';
        
        insert productConfig;

        Apttus_Config2__LineItem__c productConfigLineItem = new Apttus_Config2__LineItem__c();
        productConfigLineItem.Apttus_Config2__BasePrice__c = 10;
        productConfigLineItem.Apttus_Config2__BaseCost__c = 5;
        productConfigLineItem.Apttus_Config2__ConfigurationId__c = productConfig.Id;
        productConfigLineItem.Apttus_Config2__ItemSequence__c = 1;
        productConfigLineItem.Apttus_Config2__LineNumber__c = 1;

        insert productConfigLineItem;

        Apexpages.currentPage().getParameters().put('id',productConfig.Id);

        ProfitLossAnalysisController profitLossController = new ProfitLossAnalysisController();
    }

    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * Method to test no custom setting record found.
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    none
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */

    @isTest
    static void testNoCustomSetting(){

        Apttus_Config2__ProductConfiguration__c productConfig = new Apttus_Config2__ProductConfiguration__c();
        productConfig.Name = 'test config 1';
        
        insert productConfig;

        Apexpages.currentPage().getParameters().put('id',productConfig.Id);

        ProfitLossAnalysisController profitLossController = new ProfitLossAnalysisController();
    }

    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * Method to test no config lineitem data found.
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    none
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */

    @isTest
    static void testNoConfigLineItemData(){

        ProfitVsLoss__c profitLossSettingObj = new ProfitVsLoss__c();
        profitLossSettingObj.Name = 'Base Cost';
        profitLossSettingObj.APIName__c = 'Apttus_Config2__BaseCost__c';
        profitLossSettingObj.Order__c = 1;

        insert profitLossSettingObj;

        Apttus_Config2__ProductConfiguration__c productConfig = new Apttus_Config2__ProductConfiguration__c();
        productConfig.Name = 'test config 1';
        
        insert productConfig;

        Apexpages.currentPage().getParameters().put('id',productConfig.Id);

        ProfitLossAnalysisController profitLossController = new ProfitLossAnalysisController();
    }

    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * Method to test no product config Id found.
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    none
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */

    @isTest
    static void testNoConfigId(){

        ProfitLossAnalysisController profitLossController = new ProfitLossAnalysisController();
    }
}