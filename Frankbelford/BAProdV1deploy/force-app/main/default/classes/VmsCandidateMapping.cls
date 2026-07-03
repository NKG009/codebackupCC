/**
 * Created by mrahman on 2020-11-11.
 * TEST CLASS: VmsSubmitCandidateTest
 * DESC: THIS IS SALESFORCE JS TO EVO APPLICATION/CANDIDATE SUBMISSION MAPPING
 *
 * Update by mrahman on 9/12/2020 to add more fields
 * DESC: Detals can be found in https://impellam.atlassian.net/browse/PT1-177
 */

public class VmsCandidateMapping {
    public VmsCandidateMapping(){}

    public String stgAtsApplicationId;
    public String stgFrontOfficeIntegrationSystem;
    public String stgVmsClientId;
    public String stgVmsRoleId;
    public String stgVmsShiftId;
    public String stgAtsShiftIntegrationRef;
    public String stgAtsAgencyRef;
    public String stgCandidateFirstName;
    public String stgCandidateLastName;
    public String stgCandidateEmail;
    public String stgCandidateNINumber;
    public String stgMailingStreet;
    public String stgMailingCity;
    public String stgMailingPostCode;
    public String stgProofofRTW;
    public String stgProofofIdentity;
    public String stgReferenceChecked;
    public String stgPORTWType;
    public Date stgVisaExpiryDate;
    public String stgVisaType;
    public List<CandidateDocument> stgCandidateDocuments;

    public VmsCandidateMapping(StagingJobApplication__c ja){
        this.stgAtsApplicationId = ja.Id;
        this.stgFrontOfficeIntegrationSystem = ja.stgFrontOfficeIntegrationSystem__c;
        this.stgVmsClientId = ja.stgVmsClientId__c;
        this.stgVmsRoleId = ja.stgVmsRoleId__c;
        this.stgVmsShiftId = ja.stgVmsShiftId__c;
        this.stgAtsShiftIntegrationRef  = ja.stgAtsShiftIntegrationRef__c;
        this.stgAtsAgencyRef  = ja.stgPayProfile__r.IP_PayrollID__c;
        this.stgCandidateFirstName  = ja.stgAtsCandidateIntegrationRef__r.FirstName;
        this.stgCandidateLastName  = ja.stgAtsCandidateIntegrationRef__r.LastName;
        this.stgCandidateEmail  = ja.stgAtsCandidateIntegrationRef__r.Email;
        this.stgCandidateNINumber  = ja.stgAtsCandidateIntegrationRef__r.sirenum__National_Insurance__c;
        this.stgMailingStreet = ja.stgAtsCandidateIntegrationRef__r.MailingStreet;
        this.stgMailingCity = ja.stgAtsCandidateIntegrationRef__r.MailingCity;
        this.stgMailingPostCode = ja.stgAtsCandidateIntegrationRef__r.MailingPostalCode;
        this.stgProofofRTW = ja.PORTW_Type__c.length()>0?'yes':'no'; // if PORTW_Type__c has a value then send yes else no
        this.stgPORTWType = ja.PORTW_Type__c;
        this.stgReferenceChecked = ja.References_Checked__c?'yes':'no'; //If References_Checked__c has a value then send yes else no
        this.stgProofofIdentity = ja.Proof_of_ID__c?'yes':'no'; //if Proof_of_ID__c has a value then send yes else no
        this.stgVisaExpiryDate = ja.Visa_Expiry_Date__c;
        this.stgVisaType = ja.Visa_Type__c;
        this.stgCandidateDocuments = getDocumentURL(ja.Id);
    }

    public class CandidateDocument {
        public String contentVersionId;
        public String fileType;
        public String fileExtension;
        public String title;
        public String versionNumber;
        public String pathOnClient;
    }

    public List<CandidateDocument> getDocumentURL(Id recordId){
        String docId;
        //String docUrl;
        List<CandidateDocument> cds = new List<CandidateDocument>();
        try{
            docId = [SELECT ContentDocumentId FROM ContentDocumentLink
            WHERE LinkedEntityId =: recordId LIMIT 1].ContentDocumentId;
            ContentVersion cv = [SELECT Id, FileType, FileExtension, Title,VersionNumber, PathOnClient
                                FROM ContentVersion
                                WHERE ContentDocumentId =: docId
                                AND IsLatest = true];
            CandidateDocument cd = new CandidateDocument();
            cd.contentVersionId = cv.Id;
            cd.fileType = cv.FileType;
            cd.fileExtension = cv.FileExtension;
            cd.title = cv.Title;
            cd.versionNumber = cv.VersionNumber;
            cd.pathOnClient = cv.PathOnClient;
            cds.add(cd);
            //docUrl = URL.getSalesforceBaseUrl().toExternalForm()
            //        + '/sfc/servlet.shepherd/document/download/' + docId;
        } catch(Exception ex){
            System.debug('Exception - ' + ex);
            System.debug('Application Record Id: '+ recordId +' does not have a CV to submit.');
        }
        return cds;
    }
}