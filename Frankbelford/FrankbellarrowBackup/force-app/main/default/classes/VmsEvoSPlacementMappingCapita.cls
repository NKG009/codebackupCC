public class VmsEvoSPlacementMappingCapita {
    public String stgFrontOfficeIntegrationSystem;
    public String stgVmsClientId;
    public String stgVmsRoleId;
    public String stgVmsShiftId;
    public String stgAtsCandidateIntegrationRef;
    public String stgAtsApplicationId;
    public String stgAtsShiftIntegrationRef;
    public String stgAtsAgencyRef;
    public String stgSPlacementId;
    public Date stgDateOfBirth;
    public String stgGender;
    public String stgTitle;
    public String stgMobileTel;
    // public String stgAddressline1;
    // public String stgTowncity;
    public String stgCounty;
    public String stgCountry;
    // public String stgPostcode;

    public VmsEvoSPlacementMappingCapita(StagingJobApplication__c ja) {
        this.stgFrontOfficeIntegrationSystem = ja.stgFrontOfficeIntegrationSystem__c;
        this.stgVmsClientId = ja.stgVmsClientId__c;
        this.stgVmsRoleId = ja.stgVmsRoleId__c;
        this.stgVmsShiftId = ja.stgVmsShiftId__c;
        this.stgAtsCandidateIntegrationRef = ja.stgAtsCandidateIntegrationRef__c;
        this.stgAtsApplicationId = ja.Id;
        this.stgAtsShiftIntegrationRef = ja.stgAtsShiftIntegrationRef__c;
        this.stgAtsAgencyRef = ja.stgPayProfile__r.IP_PayrollID__c;
        this.stgSPlacementId = ja.stgSPlacementId__r.IP_AssignmentRef__c;
        this.stgDateOfBirth = ja.stgAtsCandidateIntegrationRef__r.Birthdate;
        this.stgGender = ja.stgAtsCandidateIntegrationRef__r.ts2__EEO_Gender__c;
        this.stgTitle = ja.stgAtsCandidateIntegrationRef__r.Title;
        this.stgMobileTel = ja.stgAtsCandidateIntegrationRef__r.MobilePhone;//jyothi
        // this.stgAddressline1 = ja.stgAtsCandidateIntegrationRef__r.MailingStreet;
        // this.stgTowncity = ja.stgAtsCandidateIntegrationRef__r.MailingCity;
        this.stgCounty = ja.stgAtsCandidateIntegrationRef__r.MailingState;
        this.stgCountry = ja.stgAtsCandidateIntegrationRef__r.MailingCountry;
        // this.stgPostcode = ja.stgAtsCandidateIntegrationRef__r.MailingPostalCode;
    }
}