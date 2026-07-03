public with sharing class VmsCopyMoveCandidateMappingCapita {
    public String stgFrontOfficeIntegrationSystem;
    public String stgVmsClientId;
    public String stgVmsRoleId;
    public String stgVmsShiftId;
    public String stgAtsCandidateIntegrationRef;
    public String stgCandidateRoleId;
    public Date stgDateOfBirth;
    public String stgGender;
    public String stgTitle;
	public String stgMobileTel;
    // public String stgAddressline1;
    // public String stgTowncity;
    public String stgCounty;
    public String stgCountry;
    // public String stgPostcode;

    public VmsCopyMoveCandidateMappingCapita() {
    }

    public VmsCopyMoveCandidateMappingCapita(StagingJobApplication__c ja) {
        this.stgVmsClientId = ja.stgVmsClientId__c;
        this.stgVmsRoleId = ja.stgVmsRoleId__c;
        this.stgVmsShiftId = ja.stgVmsShiftId__c;
        this.stgAtsCandidateIntegrationRef = ja.Id;
        this.stgCandidateRoleId = ja.StagingJobOrder__r.stgCandidateRoleId__c;
        this.stgFrontOfficeIntegrationSystem  = ja.StgFrontOfficeIntegrationSystem__c;
        this.stgDateOfBirth = ja.stgAtsCandidateIntegrationRef__r.Birthdate;
        this.stgGender = ja.stgAtsCandidateIntegrationRef__r.ts2__EEO_Gender__c;
        this.stgTitle = ja.stgAtsCandidateIntegrationRef__r.Salutation;
        this.stgMobileTel = ja.stgAtsCandidateIntegrationRef__r.MobilePhone;//Jyothi
        // this.stgAddressline1 = ja.stgAtsCandidateIntegrationRef__r.MailingStreet;
        // this.stgTowncity = ja.stgAtsCandidateIntegrationRef__r.MailingCity;
        this.stgCounty = ja.stgAtsCandidateIntegrationRef__r.MailingState;
        this.stgCountry = ja.stgAtsCandidateIntegrationRef__r.MailingCountry;
        // this.stgPostcode = ja.stgAtsCandidateIntegrationRef__r.MailingPostalCode;
    }
}