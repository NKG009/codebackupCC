public class AccountPlanRE_Formula{
   
    public static void CalcRentElect(set<ID> APids){ 
   
 /// Update Account Plan      
                  
     AccountPlan APL = [select id, InYear_Rent_Value__c, InYear_Electricity_Value__c,
         Next_Year_Rent_Value__c, Next_Year_Electricity_Value__c, 
         Billing_Value_Rent__c, Billing_Value_Electricity__c,  
         Full_Term_Rent_Value__c, Full_Term_Electricity_Value__c,
                   
         Monthly_Rent_1_1234__c, Monthly_Rent_1_5_2_123__c, Monthly_Rent_2_45_3_12__c,
         Monthly_Rent_3_345_4_1__c, Monthly_Rent_4_2345__c, Monthly_Rent_5_1234__c,
         Monthly_Rent_6_45_7_12__c, Monthly_Rent_7_345__c, Monthly_Rent_5_5_6_123__c,
         
         Monthly_Rent_1_1234NY__c,Monthly_Rent_1_5_2_123NY__c, Monthly_Rent_2_45_3_12NY__c,
         Monthly_Rent_3_345_4_1NY__c, Monthly_Rent_4_2345NY__c, Monthly_Rent_5_1234NY__c,
         Monthly_Rent_6_45_7_12NY__c, Monthly_Rent_7_345NY__c, Monthly_Rent_5_5_6_123NY__c,
                                             
         Monthly_Elect_1_1234__c, Monthly_Elect_1_5_2_123__c, Monthly_Elect_2_45_3_12__c, 
         Monthly_Elect_3_345_4_1__c, Monthly_Elect_4_2345__c, Monthly_Elect_5_1234__c,
         Monthly_Elect_5_5_6_123__c, Monthly_Elect_6_45_7_12__c, Monthly_Elect_7_345__c,
         
         Monthly_Elect_1_1234NY__c, Monthly_Elect_1_5_2_123NY__c, Monthly_Elect_2_45_3_12NY__c, 
         Monthly_Elect_3_345_4_1NY__c, Monthly_Elect_4_2345NY__c, Monthly_Elect_5_1234NY__c,
         Monthly_Elect_5_5_6_123NY__c, Monthly_Elect_6_45_7_12NY__c, Monthly_Elect_7_345NY__c,
         
         Billing_Value_Rent_Prep__c, Billing_Value_Electricity_Prep__c,
         Full_Term_Elect_Value_Prep__c, Full_Term_Rent_Value_Prep__c, Full_Term_Rent_Value_Prep_2__c, Full_Term_Elect_Value_Prep2__c
                                           
     From AccountPlan where ID in: APids];
      
       APL.InYear_Rent_Value__c =  APL.Monthly_Rent_1_1234__c + APL.Monthly_Rent_1_5_2_123__c + APL.Monthly_Rent_2_45_3_12__c +
             APL.Monthly_Rent_3_345_4_1__c + APL.Monthly_Rent_4_2345__c + APL.Monthly_Rent_5_1234__c + APL.Monthly_Rent_5_5_6_123__c +
             APL.Monthly_Rent_6_45_7_12__c + APL.Monthly_Rent_7_345__c;
       APL.InYear_Electricity_Value__c = APL.Monthly_Elect_1_1234__c + APL.Monthly_Elect_1_5_2_123__c + APL.Monthly_Elect_2_45_3_12__c +
             APL.Monthly_Elect_3_345_4_1__c + APL.Monthly_Elect_4_2345__c + APL.Monthly_Elect_5_1234__c +
             APL.Monthly_Elect_5_5_6_123__c + APL.Monthly_Elect_6_45_7_12__c + APL.Monthly_Elect_7_345__c;
       APL.Next_Year_Rent_Value__c = APL.Monthly_Rent_1_1234NY__c + APL.Monthly_Rent_1_5_2_123NY__c + APL.Monthly_Rent_2_45_3_12NY__c +
             APL.Monthly_Rent_3_345_4_1NY__c + APL.Monthly_Rent_4_2345NY__c + APL.Monthly_Rent_5_1234NY__c + APL.Monthly_Rent_5_5_6_123NY__c +
             APL.Monthly_Rent_6_45_7_12NY__c + APL.Monthly_Rent_7_345NY__c;       
       APL.Next_Year_Electricity_Value__c = APL.Monthly_Elect_1_1234NY__c + APL.Monthly_Elect_1_5_2_123NY__c + APL.Monthly_Elect_2_45_3_12NY__c +
             APL.Monthly_Elect_3_345_4_1NY__c + APL.Monthly_Elect_4_2345NY__c + APL.Monthly_Elect_5_1234NY__c +
             APL.Monthly_Elect_5_5_6_123NY__c + APL.Monthly_Elect_6_45_7_12NY__c + APL.Monthly_Elect_7_345NY__c;
       APL.Billing_Value_Electricity__c = APL.Billing_Value_Electricity_Prep__c;
       APL.Billing_Value_Rent__c = APL.Billing_Value_Rent_Prep__c;      
       APL.Full_Term_Rent_Value__c = APL.Full_Term_Rent_Value_Prep__c + APL.Full_Term_Rent_Value_Prep_2__c;      
       APL.Full_Term_Electricity_Value__c = APL.Full_Term_Elect_Value_Prep__c + APL.Full_Term_Elect_Value_Prep2__c;     
                                
     Update APL;
                
  }
}