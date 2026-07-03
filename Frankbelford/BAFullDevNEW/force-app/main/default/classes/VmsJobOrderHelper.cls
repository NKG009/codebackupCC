/**
* Created by mrahman on 2020-11-04.
*/
public class VmsJobOrderHelper {
    public String StgSourceSystem;
    public String StgClientName;
    public String StgClientId;
    public String StgRoleId;
    public String StgJobTitle;
    public String StgQuantity;
    public String StgStartDate;
    public String StgEndDate;
    public String StgStartTime;
    public String StgEndTime;
    public String StgLocationId;
    public String StgLocationName;
    public String StgHasShifts;
    public List<VmsShift> stgShifts = new List<VmsShift>();
    public String StgCreatedDate;
    public String StgUpdatedDate;
    public String StgFrontOfficeIntegrationSystem;
    public String StgRoleRequirement;
    public String StgRequiredStaff;
    public String StgJobApplicationId;
    public String StgJobRoleId;
    public String StgJobRoleName;
    public String StgCandidateRoleId;
    public String StgMoveOrCopy;
    public String StgTransactionType;
    public String StgSecWatchdog;
    public String StgCVRequired;
    public String StgPostCode;
    public String StgJobCat;
	public String StgCostCentre;

    public class VmsShift{
        public String StgSourceSystem;
        public String StgClientName;
        public String StgClientId;
        public String StgRoleId;
        public String StgShiftId;
        public String StgJobTitle;
        public String StgQuantity;
        public String StgRoleStartDate;
        public String StgRoleEndDate;
        public String StgShiftStartTime;
        public String StgShiftEndTime;
        public String StgLocationId;
        public String StgLocationName;
        public String StgCreatedDate;
        public String StgUpdatedDate;
        public String StgShiftStatus;
        public String StgFrontOfficeIntegrationSystem;
        public String StgFrontOfficeIntegrationSystemEntity;
        public String StgSector;
        public String StgPlacement;
    }
}