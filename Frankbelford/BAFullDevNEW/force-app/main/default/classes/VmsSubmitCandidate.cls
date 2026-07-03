public class VmsSubmitCandidate {
    private static String endPointString;
    private static String token;
    private static Map<String, String> header = new Map<String, String>{
		'Content-Type' => 'application/json;charset=UTF-8',
		'Authorization' => 'Bearer ' + token
    };
    private static String jsonReqBody;
    private static StagingJobApplication__c stgJA;
    private static Map<Id, StagingJobApplication__c> stgApps = new Map<Id, StagingJobApplication__c>();
    private static List<Integration_Error_Log__c> errorLogs = new List<Integration_Error_Log__c>();
    private static Boolean isSPlacement = false;
    private static Boolean isSandbox = [SELECT IsSandbox FROM Organization].IsSandbox;
    private static Map<String, String> theSourceSystems = new Map<String, String> {
        isSandbox ? Label.VMS_Lunar_Sandbox_Database_Name : Label.VMS_Lunar_Production_Database_Name => 'Lunar',
        isSandbox ? Label.VMS_Capita_Sandbox_Database_Name : Label.VMS_Capita_Production_Database_Name => 'Capita'
    };
    private static Map<String, String> theNamedCredentials = new Map<String, String> {
        'Lunar' => 'callout:Evo_SnapLogic',
        'Capita' => 'callout:Evo_SnapLogic_Capita'
    };
    private static Map<String, Map<String, String>> theCustomMetadata = new Map<String, Map<String, String>> {
        'Capita' => new Map<String, String> {
            'CopyCandidateCallBackAPI' => 'Capita_CopyCandidateCallBackAPI',
            'CandidateSubmissionAPI' => 'Capita_CandidateSubmissionAPI',
            'PlaceBookingCallBackAPI' => 'Capita_PlaceBookingCallBackAPI'
        },
        'Lunar' => new Map<String, String> {
            'CopyCandidateCallBackAPI' => 'CopyCandidateCallBackAPI',
            'CandidateSubmissionAPI' => 'CandidateSubmissionAPI',
            'PlaceBookingCallBackAPI' => 'PlaceBookingCallBackAPI'
        }
	};

    @future(callout=true)
    public static void doSubmitApplication(List<String> stgJAJSONs) {
        for(String stgJAJSON : stgJAJSONs) {
            stgJA = (StagingJobApplication__c)JSON.deserialize(stgJAJSON, StagingJobApplication__c.class);

            String isCopyMove = stgJA.StagingJobOrder__r.StgMoveOrCopy__c;
			String theTargetSystemName = theSourceSystems.get(stgJA.StagingJobOrder__r.StgSourceSystem__c);
            Map<String, String> theMetadataRecords = theCustomMetadata.get(theTargetSystemName);

            if(stgJA.stgApplicationStatus__c == 'New' && isCopyMove == 'Copy') {
                SnapLogic_Endpoint__mdt ep = getEndpointDetails(theMetadataRecords.get('CopyCandidateCallBackAPI'));
                endPointString = theNamedCredentials.get(theTargetSystemName) + ep.Endpoint_Name__c;
                token = ep.Token__c;
                header.put('Authorization', 'Bearer ' + token);
                if(theTargetSystemName == 'Capita') {
                	VmsCopyMoveCandidateMappingCapita vcmCapita = new VmsCopyMoveCandidateMappingCapita(stgJA);
                	jsonReqBody = JSON.serializePretty(vcmCapita);
                }
                else {
                	VmsCopyMoveCandidateMapping vcmLunar = new VmsCopyMoveCandidateMapping(stgJA);
					jsonReqBody = JSON.serializePretty(vcmLunar);
                }
                handleCallout();
            }
            else if(stgJA.stgApplicationStatus__c == 'New' && String.isBlank(isCopyMove)) {
                SnapLogic_Endpoint__mdt ep = getEndpointDetails(theMetadataRecords.get('CandidateSubmissionAPI'));
                endPointString = theNamedCredentials.get(theTargetSystemName) + ep.Endpoint_Name__c;
                token = ep.Token__c;
                header.put('Authorization', 'Bearer ' + token);
                if(theTargetSystemName == 'Capita') {
                    VmsCandidateMappingCapita vcmCapita = new VmsCandidateMappingCapita(stgJA);
                    jsonReqBody = JSON.serializePretty(vcmCapita);
                }
                else {
                    VmsCandidateMapping vcmLunar = new VmsCandidateMapping(stgJA);
                    jsonReqBody = JSON.serializePretty(vcmLunar);
                }
                handleCallout();
            }
            else if(
                stgJA.stgApplicationStatus__c == 'Accepted' &&
                String.isNotBlank(stgJA.stgSPlacementId__c) &&
				stgJA.stgSPlacementSubmitted__c == false &&
				String.isBlank(isCopyMove)
            ) {
                isSPlacement = true;
                SnapLogic_Endpoint__mdt ep = getEndpointDetails(theMetadataRecords.get('PlaceBookingCallBackAPI'));
                endPointString = theNamedCredentials.get(theTargetSystemName) + ep.Endpoint_Name__c;
                token = ep.Token__c;
                header.put('Authorization', 'Bearer ' + token);
				if(theTargetSystemName == 'Capita') {
                    VmsEvoSPlacementMappingCapita vespmCapita = new VmsEvoSPlacementMappingCapita(stgJA);
                    jsonReqBody = JSON.serializePretty(vespmCapita);
                }
				else {
                    VmsEvoSPlacementMapping vespm = new VmsEvoSPlacementMapping(stgJA);
                    jsonReqBody = JSON.serializePretty(vespm);
                }
                handleCallout();
            }
            else if(stgJA.stgApplicationStatus__c != 'New' && isCopyMove == 'Move') {
                // Don't need to send any data for this at present.
            }
            else {
                String msg = 'WARNING: >>> INTEGRATION CALL WAS NOT MADE DUE THE REQUEST REQUIREMENT';
                stgJA.stgSubmissionError__c = msg;
                stgJA.stgSubmissionDatetime__c = Datetime.now();
                stgApps.put(stgJA.Id, stgJA);
                errorLogs.add(new Integration_Error_Log__c(
                    End_Point__c = endPointString,
                    Payload__c = jsonReqBody,
                    CallType__c = 'Outbound',
                    Error__c = 'Response Status:: ' + msg
                ));
            }
        }

        if(stgApps.size() > 0) {
            update stgApps.values();
        }

        if(errorLogs.size() > 0) {
            insert errorLogs;
        }
    }

    private static SnapLogic_Endpoint__mdt getEndpointDetails(String epName) {
        SnapLogic_Endpoint__mdt ep = [SELECT DeveloperName, MasterLabel, Label, Endpoint_Name__c, Token__c
									  FROM SnapLogic_Endpoint__mdt
                                      WHERE DeveloperName = :epName];
        system.debug('SnapLogic_Endpoint__mdt======================================' +ep);
		return ep;
    }

    private static void handleCallout() {
        HttpResponse response = null;
        try {
			response = RestCalloutUtil.MakeCallout(endPointString, 'POST', jsonReqBody, header);

            VmsSnapLogicResParser.Response parsedResp = VmsSnapLogicResParser.parseResponse(response.getBody());
            if(response.getStatusCode() == 200 && parsedResp.status.uncapitalize() == 'success') {
                stgJA.stgSubmittedJSON__c = jsonReqBody;
                stgJA.stgSubmissionDatetime__c = Datetime.now();
                stgJA.stgApplicationStatus__c = isSPlacement? stgJA.stgApplicationStatus__c : 'Submitted';
                stgJA.stgSubmissionStatus__c = isSPlacement? 'S-Placement Submitted' : 'Application Submitted';
                stgJA.stgSPlacementSubmitted__c = isSPlacement;
                stgJA.External_ID__c = parsedResp.VmsCandidateRoleId;
                stgApps.put(stgJA.Id, stgJA);
            }
            else {
                errorLogs.add(new Integration_Error_Log__c(
                    End_Point__c = endPointString,
                    Payload__c = jsonReqBody,
                    CallType__c = 'Outbound',
                    Error__c = 'Response Status:: ' + response.getStatus() + '\n' + response.getBody()
                ));
    
                stgJA.stgSubmittedJSON__c = jsonReqBody;
                stgJA.stgSubmissionDatetime__c = Datetime.now();
                stgJA.stgApplicationStatus__c = isSPlacement? stgJA.stgApplicationStatus__c : 'Submission Failed';
                stgJA.stgSubmissionStatus__c = isSPlacement? 'S-Placement Submission Failed' : 'Application Submission Failed';
                stgJA.stgSubmissionError__c = response.getStatus() + '\n' + response.getBody();
                stgApps.put(stgJA.Id, stgJA);
            }
        }
        catch(Exception theException) {
			String errorMessage = (theException.getMessage() == 'No content to map to Object due to end of input') ? 'No response received.' : theException.getMessage();
            errorLogs.add(new Integration_Error_Log__c(
                End_Point__c = endPointString,
                Payload__c = jsonReqBody,
                CallType__c = 'Outbound',
				Error__c = 'Error - ' + errorMessage + '\n\n' + 'Response - ' + response.getBody()
            ));
        }
    }

}