/**
 * Created by mrahman on 2020-10-02.
 */

@isTest(SeeAllData='true')
public class ReportsControllerTest {
    @isTest
    static void testReport(){
        Report testReport = [SELECT Id, CreatedDate FROM Report ORDER BY CreatedDate DESC LIMIT 1];
        System.debug('Report Id: ' + testReport.Id);
        String jsonString =  ReportsController.getDoughnutChart(testReport.Id);
        System.assert(String.isNotBlank(jsonString),'No report data returned');
    }
}