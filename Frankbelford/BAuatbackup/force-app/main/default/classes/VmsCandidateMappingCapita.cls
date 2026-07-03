public class VmsCandidateMappingCapita {
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
    public Date stgDateOfBirth;
    public String stgGender;
    public String stgTitle;
    public String stgMobileTel;
    // public String stgAddressline1;
    // public String stgTowncity;
    public String stgCounty;
    public String stgCountry;
    // public String stgPostcode;
    public List<CandidateDocument> stgCandidateDocuments;

    public VmsCandidateMappingCapita() {
    }

    public VmsCandidateMappingCapita(StagingJobApplication__c ja) {
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
        this.stgProofofRTW = ja.PORTW_Type__c.length() > 0 ? 'yes' : 'no'; // If PORTW_Type__c has a value then send yes else no.
        this.stgPORTWType = ja.PORTW_Type__c;
        this.stgReferenceChecked = ja.References_Checked__c ? 'yes' : 'no'; // If References_Checked__c has a value then send yes else no.
        this.stgProofofIdentity = ja.Proof_of_ID__c ? 'yes' : 'no'; // If Proof_of_ID__c has a value then send yes else no.
        this.stgVisaExpiryDate = ja.Visa_Expiry_Date__c;
        this.stgVisaType = ja.Visa_Type__c;
        this.stgCandidateDocuments = getDocumentURL(ja.Id);
        this.stgDateOfBirth = ja.stgAtsCandidateIntegrationRef__r.Birthdate;
        this.stgGender = ja.stgAtsCandidateIntegrationRef__r.ts2__EEO_Gender__c;
        this.stgTitle = ja.stgAtsCandidateIntegrationRef__r.Salutation;
        System.debug(this.stgTitle);
        this.stgMobileTel = ja.stgAtsCandidateIntegrationRef__r.MobilePhone;//jyothi
        // this.stgAddressline1 = ja.stgAtsCandidateIntegrationRef__r.MailingStreet;
        // this.stgTowncity = ja.stgAtsCandidateIntegrationRef__r.MailingCity;
        this.stgCounty = ja.stgAtsCandidateIntegrationRef__r.MailingState;
        this.stgCountry = ja.stgAtsCandidateIntegrationRef__r.MailingCountry;
        // this.stgPostcode = ja.stgAtsCandidateIntegrationRef__r.MailingPostalCode;
    }

    public class CandidateDocument {
        public String contentVersionId;
        public String fileType;
        public String fileExtension;
        public String title;
        public String versionNumber;
        public String pathOnClient;
    }

    public List<CandidateDocument> getDocumentURL(Id recordId) {
        String docId;
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
        }
        catch(Exception ex){
            System.debug('Exception - ' + ex);
            System.debug('Application Record Id: '+ recordId +' does not have a CV to submit.');
        }
        return cds;
    }
}