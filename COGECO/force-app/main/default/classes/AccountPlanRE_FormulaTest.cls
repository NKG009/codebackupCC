@isTest(SeeAllData=true)

public class AccountPlanRE_FormulaTest {

    static private AccountPlan APlantTest() {  
    
       AccountPlan AP1 = new AccountPlan(
        Name='Test_Rent_1_0' ,
        InYear_Rent_Value__c = 40, InYear_Electricity_Value__c = 20,
        Next_Year_Rent_value__c = 40, Next_Year_Electricity_Value__c = 20,
        Billing_Value_Rent__c = 40, Billing_Value_Electricity__c = 20,
        Full_Term_Rent_Value__c = 40, Full_Term_Electricity_Value__c = 20
        );
       insert AP1;
       return AP1;
}

static testMethod void APlanUpdateTest() {
              
    AccountPlan acp = APlantTest();
        system.debug('id**'+acp.id);

        System.Test.StartTest();
          acp.InYear_Rent_Value__c =  40;
//       acp.InYear_Rent_Value__c =  acp.Monthly_Rent_1_1234__c + acp.Monthly_Rent_1_5_2_123__c + acp.Monthly_Rent_2_45_3_12__c +
//             acp.Monthly_Rent_3_345_4_1__c + acp.Monthly_Rent_4_2345__c + acp.Monthly_Rent_5_1234__c + acp.Monthly_Rent_5_5_6_123__c +
//             acp.Monthly_Rent_6_45_7_12__c + acp.Monthly_Rent_7_345__c;
          acp.InYear_Electricity_Value__c =  20;
//       acp.InYear_Electricity_Value__c = acp.Monthly_Elect_1_1234__c + acp.Monthly_Elect_1_5_2_123__c + acp.Monthly_Elect_2_45_3_12__c +
//             acp.Monthly_Elect_3_345_4_1__c + acp.Monthly_Elect_4_2345__c + acp.Monthly_Elect_5_1234__c +
//             acp.Monthly_Elect_5_5_6_123__c + acp.Monthly_Elect_6_45_7_12__c + acp.Monthly_Elect_7_345__c;
          acp.Next_Year_Rent_Value__c =  40;
//       acp.Next_Year_Rent_Value__c = acp.Monthly_Rent_1_1234NY__c + acp.Monthly_Rent_1_5_2_123NY__c + acp.Monthly_Rent_2_45_3_12NY__c +
//             acp.Monthly_Rent_3_345_4_1NY__c + acp.Monthly_Rent_4_2345NY__c + acp.Monthly_Rent_5_1234NY__c + acp.Monthly_Rent_5_5_6_123NY__c +
//             acp.Monthly_Rent_6_45_7_12NY__c + acp.Monthly_Rent_7_345NY__c;       
          acp.Next_Year_Electricity_Value__c =  20;
//       acp.Next_Year_Electricity_Value__c = acp.Monthly_Elect_1_1234NY__c + acp.Monthly_Elect_1_5_2_123NY__c + acp.Monthly_Elect_2_45_3_12NY__c +
//             acp.Monthly_Elect_3_345_4_1NY__c + acp.Monthly_Elect_4_2345NY__c + acp.Monthly_Elect_5_1234NY__c +
//             acp.Monthly_Elect_5_5_6_123NY__c + acp.Monthly_Elect_6_45_7_12NY__c + acp.Monthly_Elect_7_345NY__c;
          acp.Full_Term_Electricity_Value__c =  20;
//       acp.Full_Term_Electricity_Value__c = acp.Full_Term_Elect_Value_Prep__c;
          acp.Full_Term_Rent_Value__c =  40;
//       acp.Full_Term_Rent_Value__c = acp.Full_Term_Rent_Value_Prep__c;   
          acp.Billing_Value_Electricity__c =  20;
//       acp.Billing_Value_Electricity__c = acp.Billing_Value_Electricity_Prep__c;
          acp.Billing_Value_Rent__c =  40;
//       acp.Billing_Value_Rent__c = acp.Billing_Value_Rent_Prep__c;      
               
    Update acp;
  
       system.debug(acp);
       system.assertequals(acp.name, 'Test_Rent_1_0');
       system.assertequals(acp.InYear_Rent_Value__c, 40);
       system.assertequals(acp.InYear_Electricity_Value__c, 20);
       system.assertequals(acp.Next_Year_Rent_Value__c, 40);
       system.assertequals(acp.Next_Year_Electricity_Value__c, 20);
       system.assertequals(acp.Full_Term_Rent_Value__c, 40);
       system.assertequals(acp.Billing_Value_Electricity__c, 20);
       system.assertequals(acp.Billing_Value_Rent__c, 40);                     
           
       System.Test.stopTest();  
         
}
}