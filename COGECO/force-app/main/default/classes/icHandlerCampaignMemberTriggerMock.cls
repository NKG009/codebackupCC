@isTest
public class icHandlerCampaignMemberTriggerMock implements icHandlerCampaignMemberTrigger.IClass {
    
	public void onAfterInsert(List<CampaignMember> oldCampaignMembers, List<CampaignMember> newCampaignMembers, Map<Id, CampaignMember> newCampaignMembersMap) {
		Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'onAfterInsert');
		params.put('oldCampaignMembers', oldCampaignMembers);
		params.put('newCampaignMembers', newCampaignMembers);
		params.put('newCampaignMembersMap', newCampaignMembersMap);
		//Return (CastType) icTestMockUtilities.Tracer.GetReturnValue(this, 'onAfterInsert');
	}
	
	public void onAfterUpdate(List<CampaignMember> oldCampaignMembers, List<CampaignMember> newCampaignMembers, Map<Id, CampaignMember> newCampaignMembersMap) {
		Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'onAfterUpdate');
		params.put('oldCampaignMembers', oldCampaignMembers);
		params.put('newCampaignMembers', newCampaignMembers);
		params.put('newCampaignMembersMap', newCampaignMembersMap);
		//Return (CastType) icTestMockUtilities.Tracer.GetReturnValue(this, 'onAfterInsert');
	}
}