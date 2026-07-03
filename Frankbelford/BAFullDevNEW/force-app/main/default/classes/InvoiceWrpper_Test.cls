@isTest
public class InvoiceWrpper_Test {
    @isTest
    static  void testwrap() {
        String jsonString =  '{' +
                '"data": [{\"Entity\":\"Blue Arrow\",\"Branch_Code\":\"2044  \",\"Branch_Name\":\"BAL Belfast                   \",\"Acc_No\":\"1141447   \",\"Client\":\"Fortel Rail Const. (Internal Account)\",\"Invoice_Date\":\"2018-03-28T00:00:00\",\"Due_Date\":\"2018-04-27T00:00:00\",\"Invoice_Number\":\"23437815     \",\"Query_Value\":579.6,\"Date_Raised\":\"2018-04-12T00:00:00\",\"Age_of_Query\":-855,\"Contact\":\"BranchRequest@impellam.com\",\"Status\":\"Special Billing - Query       \",\"Query_Description\":\"23437815 Special Billing - Query-1ao- Deborah Connolly 23/02/2018 IB00TAMB - NOT ON GRN\",\"Comment\":\"\"}'
                + ',{\"Entity\":\"Blue Arrow\",\"Branch_Code\":\"2044  \",\"Branch_Name\":\"BAL Belfast                   \",\"Acc_No\":\"1141447   \",\"Client\":\"Fortel Rail Const. (Internal Account)\",\"Invoice_Date\":\"2018-03-28T00:00:00\",\"Due_Date\":\"2018-04-27T00:00:00\",\"Invoice_Number\":\"23437817     \",\"Query_Value\":347.76,\"Date_Raised\":\"2018-04-12T00:00:00\",\"Age_of_Query\":-855,\"Contact\":\"BranchRequest@impellam.com\",\"Status\":\"Special Billing - Query       \",\"Query_Description\":\"23437817 Special Billing - Query-1ao- Lorraine Logan - Stevenson 23/02/2018 IB00TC2B - NOT ON GRN\",\"Comment\":\"\"}'
                + ',{\"Entity\":\"Blue Arrow\",\"Branch_Code\":\"2044  \",\"Branch_Name\":\"BAL Belfast                   \",\"Acc_No\":\"1141447   \",\"Client\":\"Fortel Rail Const. (Internal Account)\",\"Invoice_Date\":\"2018-03-28T00:00:00\",\"Due_Date\":\"2018-04-27T00:00:00\",\"Invoice_Number\":\"23437820     \",\"Query_Value\":579.6,\"Date_Raised\":\"2018-04-12T00:00:00\",\"Age_of_Query\":-855,\"Contact\":\"BranchRequest@impellam.com\",\"Status\":\"Special Billing - Query       \",\"Query_Description\":\"23437820 Special Billing - Query-1ao- Joseph Keenan 23/02/2018 IB00TCMB - NOT ON GRN\",\"Comment\":\"\"}'
                + ',{\"Entity\":\"Blue Arrow\",\"Branch_Code\":\"2044  \",\"Branch_Name\":\"BAL Belfast                   \",\"Acc_No\":\"1141447   \",\"Client\":\"Fortel Rail Const. (Internal Account)\",\"Invoice_Date\":\"2018-03-28T00:00:00\",\"Due_Date\":\"2018-04-27T00:00:00\",\"Invoice_Number\":\"23437829     \",\"Query_Value\":579.6,\"Date_Raised\":\"2018-04-12T00:00:00\",\"Age_of_Query\":-855,\"Contact\":\"BranchRequest@impellam.com\",\"Status\":\"Special Billing - Query       \",\"Query_Description\":\"23437829 Special Billing - Query-1ao- Deborah Connolly 02/03/2018 IB00TANB - NOT ON GRN\",\"Comment\":\"\"}]'
                + '}';
        jsonString = jsonString.remove('\\');
        Test.startTest();
        InvoiceWrpper invData = new InvoiceWrpper();
        invData = (InvoiceWrpper)System.JSON.deserialize(jsonString,InvoiceWrpper.class);
        System.assertEquals(4, invData.data.size(), 'Number of invoice records is not same');
        Test.stopTest();
    }

    @isTest
    static void testQueryWrapper(){
        String jsonString = '{\"Entity\":\"Blue Arrow\",\"Branch_Code\":\"1010  \",\"Branch_Name\":\"BAL Romford\",\"Acc_No\":\"1136991\",\"Client\":\"Interserve FS (UK) Ltd - 247\",\"Invoice_Date\":\"2020-03-22T00:00:00\",\"Due_Date\":\"2020-04-30T00:00:00\",\"Invoice_Number\":\"24259474     \",\"Query_Value\":124.51,\"Date_Raised\":\"2020-05-14T00:00:00\",\"Age_of_Query\":-75,\"Contact\":\"BranchRequest@impellam.com\",\"Status\":\"Self Bill-TS not online/Approv\",\"Query_Description\":\"24259474 Self Bill-TS not online/Approv-1b- Mark Orgles 20/03/2020 104554871220\",\"Comment\":\"\"}';
        jsonString = jsonString.remove('\\');

        InvoiceQueryWrapper iws = new InvoiceQueryWrapper();
        iws = (InvoiceQueryWrapper)JSON.deserialize(jsonString, InvoiceQueryWrapper.class);
        System.assert(!String.isEmpty(iws.Branch_Code), 'Branch Code is empty');
    }
}