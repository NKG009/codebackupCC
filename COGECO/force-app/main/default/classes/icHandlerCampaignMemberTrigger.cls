public class icHandlerCampaignMemberTrigger implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		void onAfterInsert(List<CampaignMember> oldCampaignMembers, List<CampaignMember> newCampaignMembers, Map<Id, CampaignMember> newCampaignMembersMap);
		void onAfterUpdate(List<CampaignMember> oldCampaignMembers, List<CampaignMember> newCampaignMembers, Map<Id, CampaignMember> newCampaignMembersMap);
	}

	public class Impl implements IClass {
		
		icLogicCampaignMember.IClass campaignMemberLogic = (icLogicCampaignMember.IClass) icObjectFactory.GetSingletonInstance('icLogicCampaignMember');
		icServiceCISL.IClass cislService = (icServiceCISL.IClass) icObjectFactory.GetSingletonInstance('icServiceCISL');		

        
        public void onAfterInsert(List<CampaignMember> oldCampaignMembers, List<CampaignMember> newCampaignMembers, Map<Id, CampaignMember> newCampaignMembersMap) {}
		public void onAfterUpdate(List<CampaignMember> oldCampaignMembers, List<CampaignMember> newCampaignMembers, Map<Id, CampaignMember> newCampaignMembersMap) {}

		
	}
}