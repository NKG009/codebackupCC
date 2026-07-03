public class icLogicCampaignMember implements icIClass {

    public Object GetInstance() {
        return new Impl();
    }

    public Interface IClass {
        CampaignMember getAllCampaignMemberDetailsById(String recordId);
		Boolean validateClientAddressFromCampaignMember(CampaignMember campaignMember);
        icDTOShippingRequest getShippingRequestDTOFromCampaignMember(CampaignMember campaignMember);
        CampaignMember getUpdatedCampaignMemberFromCISLConfirmation(icDTOShippingConfirmation dtoConfirmation);
        void updateCampaignMember(CampaignMember campaignMember);
    }

    public class Impl implements IClass {
        icRepoCampaignMember.IClass repo = (icRepoCampaignMember.IClass) icObjectFactory.GetSingletonInstance('icRepoCampaignMember');

        public CampaignMember getAllCampaignMemberDetailsById(String recordId) {
            return repo.getAllCampaignMemberDetailsById(recordId);
        }
		
        public Boolean validateClientAddressFromCampaignMember(CampaignMember campaignMember) {
            Boolean isValidAddress = true;
            if(campaignMember.ContactId == null) {
                if (String.isBlank(campaignMember.Lead.Street)
                || String.isBlank(campaignMember.Lead.City)
                || String.isBlank(campaignMember.Lead.State)
                || String.isBlank(campaignMember.Lead.PostalCode)
                || String.isBlank(campaignMember.Lead.Country)) {
                    isValidAddress = false;
                    icServiceErrorHandler.LogError('icLogicCampaignMember', 'validateClientAddressFromCampaignMember', 'evaluating address from Lead', 'missing Address field(s)', JSON.serialize(campaignMember.Lead));
                }
            } else {
                if(String.isBlank(campaignMember.Contact.MailingStreet)
                || String.isBlank(campaignMember.Contact.MailingCity)
                || String.isBlank(campaignMember.Contact.MailingState)
                || String.isBlank(campaignMember.Contact.MailingPostalCode)
                || String.isBlank(campaignMember.Contact.MailingCountry)) {
                    isValidAddress = false;
                    icServiceErrorHandler.LogError('icLogicCampaignMember', 'validateClientAddressFromCampaignMember', 'evaluating address from Contact', 'missing Address field(s)', JSON.serialize(campaignMember.Contact));
                }
            }
            return isValidAddress;
        }

        public icDTOShippingRequest getShippingRequestDTOFromCampaignMember(CampaignMember campaignMember) {
            icDTOShippingRequest shippingRequest = new icDTOShippingRequest();
            shippingRequest.applicationID = 'SALESFORCE';
            shippingRequest.orderID = campaignMember.Id;
            shippingRequest.emailNotification = 'false';
            shippingRequest.shippingReturnRequired = 'false';

            //shippingRequest.weight = String.valueOf(campaignMember.Campaign.Shipped_Product__r.Weight_g__c);
            //shippingRequest.length = String.valueOf(campaignMember.Campaign.Shipped_Product__r.Length_mm__c);
            //shippingRequest.width = String.valueOf(campaignMember.Campaign.Shipped_Product__r.Width_mm__c);
            //shippingRequest.height = String.valueOf(campaignMember.Campaign.Shipped_Product__r.Height_mm__c);
            
            //shippingRequest.accessoryCode = campaignMember.Campaign.Shipped_Product__r.Name.toUpperCase();

            /*
            shippingRequest.isEquipmentSwap
            shippingRequest.cpeResourceCategoryCode
            shippingRequest.resourceCustomerRelationship
            shippingRequest.accessoryCode
            shippingRequest.specialInstructions
            */

            // fill in client details
            if(campaignMember.ContactId == null) {
                shippingRequest.clientID = campaignMember.LeadId;
                shippingRequest.firstName = campaignMember.Lead.FirstName;
                shippingRequest.lastName = campaignMember.Lead.LastName;
                shippingRequest.titleOrDept = campaignMember.Lead.Salutation;
                shippingRequest.companyName = campaignMember.Lead.Company;
                //shippingRequest.additionalAddressInformation
                shippingRequest.addressLine1 = campaignMember.Lead.Street;
                shippingRequest.city = campaignMember.Lead.City;
                shippingRequest.provinceOrState = campaignMember.Lead.State;
                shippingRequest.postalCode = campaignMember.Lead.PostalCode;
                if(campaignMember.Lead.Country.toLowerCase() == 'canada') {
                    shippingRequest.countryCode = 'CA';
                } else {
                    shippingRequest.countryCode = campaignMember.Lead.Country;
                }
                shippingRequest.clientVoicePhone = campaignMember.Lead.Phone;
                shippingRequest.clientEmail = campaignMember.Lead.Email;
                //shippingRequest.email2
            } else {
                shippingRequest.clientID = campaignMember.ContactId;
                shippingRequest.firstName = campaignMember.Contact.FirstName;
                shippingRequest.lastName = campaignMember.Contact.LastName;
                shippingRequest.titleOrDept = campaignMember.Contact.Salutation;
                shippingRequest.companyName = campaignMember.Contact.Account.Name;
                //shippingRequest.additionalAddressInformation
                shippingRequest.addressLine1 =  campaignMember.Contact.MailingStreet;
                shippingRequest.city = campaignMember.Contact.MailingCity;
                shippingRequest.provinceOrState = campaignMember.Contact.MailingState;
                shippingRequest.postalCode = campaignMember.Contact.MailingPostalCode;
                shippingRequest.countryCode = campaignMember.Contact.MailingCountry;
                if(campaignMember.Contact.MailingCountry.toLowerCase() == 'canada') {
                    shippingRequest.countryCode = 'CA';
                } else {
                    shippingRequest.countryCode = campaignMember.Contact.MailingCountry;
                }
                shippingRequest.clientVoicePhone = campaignMember.Contact.Phone; //HomePhone
                shippingRequest.clientEmail = campaignMember.Contact.Email;
                shippingRequest.email2 = campaignMember.Contact.Alternate_Email__c;
            }

            // validate business unit
            if(shippingRequest.provinceOrState.toLowerCase() == 'on' || shippingRequest.provinceOrState.toLowerCase() == 'ontario') {
                shippingRequest.businessUnit = 'ON';
            } else if(shippingRequest.provinceOrState.toLowerCase() == 'qc' || shippingRequest.provinceOrState.toLowerCase() == 'quebec' || shippingRequest.provinceOrState.toLowerCase() == 'québec') {
                shippingRequest.businessUnit = 'QC';
            } else {
                shippingRequest.businessUnit = shippingRequest.provinceOrState;
            }

            return shippingRequest;
        }

        public CampaignMember getUpdatedCampaignMemberFromCISLConfirmation(icDTOShippingConfirmation dtoConfirmation) {
            return new CampaignMember(Id = dtoConfirmation.deliveryRequestID.right(18)
                ,Delivery_Request_ID__c = dtoConfirmation.deliveryRequestID
                ,Shipment_Waybill__c = dtoConfirmation.shippingWaybillNumber
                ,Shipment_Date__c = Date.valueOf(dtoConfirmation.shippingDate));
        }

        public void updateCampaignMember(CampaignMember campaignMember) {
            repo.updateCampaignMember(campaignMember);
        }
    }
}