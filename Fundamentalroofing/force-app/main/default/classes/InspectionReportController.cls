public class InspectionReportController{
    @AuraEnabled
    public static void InspectionReportpdf(Id opportunityId, String base64Pdf, String fileName) {
        if(String.isBlank(base64Pdf)) throw new AuraHandledException('PDF content is empty.');
        if(opportunityId==null) throw new AuraHandledException('Opportunity Id is required.');
        Blob pdfBlob=EncodingUtil.base64Decode(base64Pdf);
        ContentVersion cv=new ContentVersion();
        cv.VersionData=pdfBlob;
        cv.Title=fileName;
        cv.PathOnClient='/' + fileName;
        cv.FirstPublishLocationId=opportunityId;
        insert cv;
    }
}