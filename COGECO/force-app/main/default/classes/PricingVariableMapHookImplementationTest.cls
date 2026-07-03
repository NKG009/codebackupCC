@isTest
public with sharing class PricingVariableMapHookImplementationTest {
    
    @isTest
    public static void invokeMethodCalculatePostInvoke(){
    
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();

        Map<String, Object> pricingVariableCodeToValueMap = new Map<String, Object>();
        
        Map<String, Object> pricingLogDataMap = new Map<String, Object>();
        
        Decimal Quantity = 5;
        Decimal OneTimeStandardPrice = 10;
        Decimal RecMonthStandardPrice = 20;
        
        inputMap.put('isRoot',true);
                                
        pricingVariableCodeToValueMap.put('LINE_QUANTITY',Quantity);
        pricingVariableCodeToValueMap.put('OT_STD_PRC_CALC',OneTimeStandardPrice);
        pricingVariableCodeToValueMap.put('REC_MNTH_STD_PRC_CALC',RecMonthStandardPrice);
        pricingVariableCodeToValueMap.put('ROLLUP_OT_STD_PRC_TOTAL',0.0);
        pricingVariableCodeToValueMap.put('ROLLUP_REC_MNTH_STD_PRC_TOTAL',0.0);
        pricingVariableCodeToValueMap.put('OT_STD_PRC_TOTAL',0.0);
        pricingVariableCodeToValueMap.put('REC_MNTH_STD_PRC_TOTAL',0.0);
        
        outMap.put('pricingVariableMap', pricingVariableCodeToValueMap);
        outMap.put('pricingLogDataMap', pricingLogDataMap);
       
        Test.startTest();
        PricingVariableMapHookImplementation handler = new PricingVariableMapHookImplementation();
        handler.invokeMethod('calculate.PostInvoke', inputMap, outMap, options);
        Test.stopTest();
        
        pricingVariableCodeToValueMap = (Map<String, Object>)outMap.get('pricingVariableMap');
                
        Decimal OneTimeStandardTotal = (Decimal)pricingVariableCodeToValueMap.get('OT_STD_PRC_TOTAL');
        Decimal RecMonthStandardTotal = (Decimal)pricingVariableCodeToValueMap.get('REC_MNTH_STD_PRC_TOTAL');

        System.assertEquals(OneTimeStandardTotal, (OneTimeStandardPrice * Quantity).setScale(2, RoundingMode.HALF_UP),'One Time Total Charge is incorrecto');
        System.assertEquals(RecMonthStandardTotal, (RecMonthStandardPrice * Quantity).setScale(2, RoundingMode.HALF_UP),'Recurring Monthly Charge is incorrecto');
        
    } 
}