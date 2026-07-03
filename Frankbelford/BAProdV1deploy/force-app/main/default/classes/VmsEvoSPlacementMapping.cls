/**
 * Created by mrahman on 2020-11-13.
 * THIS IS SALESFORCE JS TO EVO S-PLACEMENT SUBMISSION MAPPING
 */

public class VmsEvoSPlacementMapping {
    public String stgFrontOfficeIntegrationSystem;
    public String stgVmsClientId;
    public String stgVmsRoleId;
    public String stgVmsShiftId;
    public String stgAtsCandidateIntegrationRef;
    public String stgAtsApplicationId;
    public String stgAtsShiftIntegrationRef;
    public String stgAtsAgencyRef;
    public String stgSPlacementId;

    public VmsEvoSPlacementMapping(StagingJobApplication__c ja){
        this.stgFrontOfficeIntegrationSystem = ja.stgFrontOfficeIntegrationSystem__c;
        this.stgVmsClientId = ja.stgVmsClientId__c;
        this.stgVmsRoleId = ja.stgVmsRoleId__c;
        this.stgVmsShiftId = ja.stgVmsShiftId__c;
        this.stgAtsCandidateIntegrationRef = ja.stgAtsCandidateIntegrationRef__c;
        this.stgAtsApplicationId = ja.Id;
        this.stgAtsShiftIntegrationRef = ja.stgAtsShiftIntegrationRef__c;
        this.stgAtsAgencyRef = ja.stgPayProfile__r.IP_PayrollID__c;
        this.stgSPlacementId = ja.stgSPlacementId__r.IP_AssignmentRef__c; //ja.stgSPlacementId__c;
    }
}