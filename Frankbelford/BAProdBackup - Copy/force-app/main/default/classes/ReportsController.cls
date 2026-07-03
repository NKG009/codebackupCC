/**
 * Created by mrahman on 2020-09-26.
 */

public /*with sharing*/ class ReportsController {
    @AuraEnabled
    public static String getDoughnutChart(String reportId){
        System.debug('DoughnutChart ReportId:::: '+ reportId);
        Reports.ReportResults rptResult;
        try{
            Report rt = [SELECT Id FROM Report WHERE Id =: reportId];
            rptResult = Reports.ReportManager.runReport(rt.Id, true);
        } catch(Exception e) {
            System.debug('Error occurred:: ' + e.getMessage());
            throw new AuraHandledException('Report may not exists. Please contact branch with an screenshot if needed');
        }
        return JSON.serializePretty(rptResult);
    }
}