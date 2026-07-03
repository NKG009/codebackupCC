/**
 * MR: USE Schema classess to get RecordType Id instead of using SOQL as part of RJSPT-87 JIRA ticket. 
 * Both of the button classes (Lightning and Classic) should execute same logic
 * CHANGE REQUIREMNTS: JIRA RJSPT-87: Reinstate Process - Not working for certain workers
 * DATE OF UPDATE: 23/07/2020
 */
global class reinstatebutton{
   webservice static String updatedata(String payid) {
       return ReinstateButtonLightning.updatedata(payid);
   }
   
}