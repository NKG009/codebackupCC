public class icRepoCampaignMember implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		CampaignMember getAllCampaignMemberDetailsById(String recordId);
		void updateCampaignMember(CampaignMember campaignMember);
	}

	public class Impl implements IClass {
		public CampaignMember getAllCampaignMemberDetailsById(String recordId) {
			CampaignMember returnCampaignMember;
			List<CampaignMember> listCampaignMembers = [SELECT Id
															// Campaign Details
															,CampaignId
															// Contact Details
															,ContactId
															,Contact.FirstName
															,Contact.LastName
															,Contact.Salutation
															,Contact.Account.Name
															,Contact.MailingStreet
															,Contact.MailingCity
															,Contact.MailingPostalCode
															,Contact.MailingState
															,Contact.MailingCountry
															,Contact.HomePhone
															,Contact.Phone
															,Contact.MobilePhone
															,Contact.Email
															,Contact.Alternate_Email__c
															// Lead Details
															,LeadId
															,Lead.FirstName
															,Lead.LastName
															,Lead.Salutation
															,Lead.Company
															,Lead.Street
															,Lead.City
															,Lead.PostalCode
															,Lead.State
															,Lead.Country
															,Lead.Phone
															,Lead.MobilePhone
															,Lead.Email
														FROM CampaignMember
														WHERE Id = :recordId];
			if(listCampaignMembers.size() == 1) {
				returnCampaignMember = listCampaignMembers[0];
			}

			return returnCampaignMember;
		}

		public void updateCampaignMember(CampaignMember campaignMember) {
			update campaignMember;
		}
	}
}