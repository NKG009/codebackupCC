global with sharing class PricingVariableMapHookImplementation implements vlocity_cmt.VlocityOpenInterface{

    global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> output, Map<String, Object> options)  
    {
        try
        {
            System.debug('____ PricingVariableMapHookImplementation ' + methodName);

            if (methodName.equalsIgnoreCase('calculate.PreInvoke'))
            {
                // dump the input
                // System.debug('--- calculate.PreInvoke input: ' + JSON.serialize(input));
            }
            else if (methodName.equalsIgnoreCase('calculate.PostInvoke'))
            {                
                // log the output
                // System.debug('--- calculate.PostInvoke output: ' + JSON.serialize(output));

                // Retrieve the pricing variable map from the output
                Map<String, Object> pricingVariableCodeToValueMap = (Map<String, Object>)output.get('pricingVariableMap');

                // Retrieve the pricing log data map from the output
                Map<String, Object> pricingLogDataMap = (Map<String, Object>)output.get('pricingLogDataMap');

                // Retrieve the isRoot flag from the input
                Boolean isRoot = (Boolean)input.get('isRoot');

                // Get the Line quantity value
                Decimal LINE_QUANTITY = (Decimal)pricingVariableCodeToValueMap.get('LINE_QUANTITY');

                // Get the REC_MNTH_STD_PRC_CALC pricing variable value 
                Decimal REC_MNTH_STD_PRC_CALC = (Decimal)pricingVariableCodeToValueMap.get('REC_MNTH_STD_PRC_CALC');

                // Get the ROLLUP_REC_MNTH_STD_PRC_TOTAL pricing variable value 
                Decimal ROLLUP_REC_MNTH_STD_PRC_TOTAL = (Decimal)pricingVariableCodeToValueMap.get('ROLLUP_REC_MNTH_STD_PRC_TOTAL');

                // Override the default calculation formula. The formula being overridden is: 
                // REC_MNTH_STD_PRC_TOTAL = (REC_MNTH_STD_PRC_CALC + ROLLUP_REC_MNTH_STD_PRC_TOTAL) * LINE_QUANTITY;
                Decimal REC_MNTH_STD_PRC_TOTAL = (REC_MNTH_STD_PRC_CALC * LINE_QUANTITY) + ROLLUP_REC_MNTH_STD_PRC_TOTAL;

                // Save the new REC_MNTH_STD_PRC_TOTAL rounded to 2 decimals in the pricing variable map of the line item
                pricingVariableCodeToValueMap.put('REC_MNTH_STD_PRC_TOTAL', REC_MNTH_STD_PRC_TOTAL.setScale(2, RoundingMode.HALF_UP));

                // Set the new pricing details information for the REC_MNTH_STD_PRC_TOTAL
                pricingLogDataMap.put('REC_MNTH_STD_PRC_TOTAL', 
                    new Map<String, Object>{
                        'format'=>'[{0} ({1}) x {2} ({3})] + Rollup {4} ({5})',
                        'data'=>new List<String>{'REC_MNTH_STD_PRC_CALC',                      // replaces {0}
                                                  String.valueOf(REC_MNTH_STD_PRC_CALC),       // replaces {1}
                                                 'LINE_QUANTITY',                              // replaces {2}
                                                 String.valueOf(LINE_QUANTITY),                // replaces {3}
                                                 'REC_MNTH_STD_PRC_TOTAL',                     // replaces {4}
                                                 String.valueOf(ROLLUP_REC_MNTH_STD_PRC_TOTAL) // replaces {5}
                                             }});

                // If this is the root, then set the EFF_REC_MNTH_STD_PRC_TOTAL of the line item to be the same as
                // REC_MNTH_STD_PRC_TOTAL value. EFF_REC_MNTH_STD_PRC_TOTAL participates in a rollup summary field in the parent header
                if (isRoot)
                {
                    Decimal EFF_REC_MNTH_STD_PRC_TOTAL = REC_MNTH_STD_PRC_TOTAL;
                    pricingVariableCodeToValueMap.put('EFF_REC_MNTH_STD_PRC_TOTAL', EFF_REC_MNTH_STD_PRC_TOTAL.setScale(2, RoundingMode.HALF_UP));
                }

                // Do the same for OT_STD_PRC_TOTAL

                // Get the OT_STD_PRC_CALC pricing variable value 
                Decimal OT_STD_PRC_CALC = (Decimal)pricingVariableCodeToValueMap.get('OT_STD_PRC_CALC');

                // Get the ROLLUP_REC_MNTH_STD_PRC_TOTAL pricing variable value 
                Decimal ROLLUP_OT_STD_PRC_TOTAL = (Decimal)pricingVariableCodeToValueMap.get('ROLLUP_OT_STD_PRC_TOTAL');

                // Override the default calculation formula. The formula being overridden is: 
                // OT_STD_PRC_TOTAL = (OT_STD_PRC_CALC + ROLLUP_OT_STD_PRC_TOTAL) * LINE_QUANTITY;
                Decimal OT_STD_PRC_TOTAL = (OT_STD_PRC_CALC * LINE_QUANTITY) + ROLLUP_OT_STD_PRC_TOTAL;

                // Save the new OT_STD_PRC_TOTAL rounded to 2 decimals in the pricing variable map of the line item
                pricingVariableCodeToValueMap.put('OT_STD_PRC_TOTAL', OT_STD_PRC_TOTAL.setScale(2, RoundingMode.HALF_UP));

                // Set the new pricing details information for the OT_STD_PRC_TOTAL
                pricingLogDataMap.put('OT_STD_PRC_TOTAL', 
                    new Map<String, Object>{
                        'format'=>'[{0} ({1}) x {2} ({3})] + Rollup {4} ({5})',
                        'data'=>new List<String>{'OT_STD_PRC_CALC',                      // replaces {0}
                                                  String.valueOf(OT_STD_PRC_CALC),       // replaces {1}
                                                 'LINE_QUANTITY',                        // replaces {2}
                                                 String.valueOf(LINE_QUANTITY),          // replaces {3}
                                                 'OT_STD_PRC_TOTAL',                     // replaces {4}
                                                 String.valueOf(ROLLUP_OT_STD_PRC_TOTAL) // replaces {5}
                                             }});

                // If this is the root, then set the EFF_OT_STD_PRC_TOTAL of the line item to be the same as
                // OT_STD_PRC_TOTAL value. EFF_OT_STD_PRC_TOTAL participates in a rollup summary field in the parent header
                if (isRoot)
                {
                    Decimal EFF_OT_STD_PRC_TOTAL = OT_STD_PRC_TOTAL;
                    pricingVariableCodeToValueMap.put('EFF_OT_STD_PRC_TOTAL', EFF_OT_STD_PRC_TOTAL.setScale(2, RoundingMode.HALF_UP));
                }
            }
            return true;
        }
        catch (Exception ex)
        {
            System.debug('--- Exception: ' + ex.getMessage());
            System.debug('--- Stack Trace: ' + ex.getStackTraceString());
            throw ex;
        }
    }
}