/**
* Created by mrahman on 2021-01-20.
*/
public with sharing class VmsCopyMoveCandidateMapping {
    public String stgFrontOfficeIntegrationSystem;
    public String stgVmsClientId;
    public String stgVmsRoleId;
    public String stgVmsShiftId;
    public String stgAtsCandidateIntegrationRef;
    public String stgCandidateRoleId;

    public VmsCopyMoveCandidateMapping(){
    }

    public VmsCopyMoveCandidateMapping(StagingJobApplication__c ja) {
        this.stgVmsClientId = ja.stgVmsClientId__c;
        this.stgVmsRoleId = ja.stgVmsRoleId__c;
        this.stgVmsShiftId = ja.stgVmsShiftId__c;
        this.stgAtsCandidateIntegrationRef = ja.Id;
        this.stgCandidateRoleId = ja.StagingJobOrder__r.stgCandidateRoleId__c;
        this.stgFrontOfficeIntegrationSystem  = ja.StgFrontOfficeIntegrationSystem__c;
    }
}