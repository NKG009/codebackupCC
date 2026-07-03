//********************************************************************************************
//********************************************************************************************
//
//     Sourcebreaker URL Controller, central controller for Aura components or Visualforce pages
//
//********************************************************************************************
//********************************************************************************************


global with sharing class SbUrlController {
        
    
    //@AuraEnabled(cacheable = true)
    public static Map<String, Object> getFieldDescribeMap(String objectName) {
        /**
        * Returns basic field describe to know which fields
        * are or are not createable and updateable.
        * 
        * This is used in URL_CreateCmp
        *
        * @param objectName
        *      API name of the object whose field describe to return
        */

        Map<String, Object> fieldDescribeMap = new Map<String, Object>();

        // Performance trick to use Type.forName instead of Schema.getGlobalDescribe()
        // https://salesforce.stackexchange.com/a/32538/987 and https://salesforce.stackexchange.com/a/219010/987
        Type reflector = Type.forName(objectName);
        SObject obj = (SObject) reflector.newInstance();
        SObjectType objType = obj.getSObjectType();

        DescribeSObjectResult describe = objType.getDescribe();
        Map<String, SObjectField> fieldsMap = describe.fields.getMap();
        for (String fieldName : fieldsMap.keySet()) {
            DescribeFieldResult fieldDescribe = fieldsMap.get(fieldName).getDescribe();
            fieldDescribeMap.put(fieldDescribe.getName(), new Map<String, Object>{
                    'accessible' => fieldDescribe.isAccessible(),
                    'createable' => fieldDescribe.isCreateable(),
                    'updateable' => fieldDescribe.isUpdateable()
            });
        }
        return fieldDescribeMap;
    }
	


    //AG for testing only
    @AuraEnabled(cacheable = true)
    public static Id getRecordTypeInformation() {
        //'Contact' name for TR, 'Candidate' for JS
        Id recordTypeToBeRetrieved = [Select Id, Name From RecordType 
                                      Where SobjectType = 'Contact' AND 
                                            IsActive = TRUE AND 
                                            Name Like 'Contact%' limit 1].Id;
        return recordTypeToBeRetrieved;

    }
	

    public static string getCallOutURL(){
		
        String whereAmI = SbHelper.whichEnviron();
        map<String, String> settings = SbHelper.findSettings(whereAmI);
 		
        string endpoint = '';
        //if list is empty/0 then create initial custom metadata record, setting all to default FALSE
        if(settings.isEmpty() || settings.get('sbcallout') == ''){
            system.debug('DEBUG === listOfSettings is empty.');
            return null;
        } 
        
        else{
            endpoint = settings.get('sbcallout');
        }

        return endpoint;
    }

    //update callout to SourceBreaker, called from Lightning Component
    @AuraEnabled
    @future(callout=true)
    public static void notifySourceBreaker(Id recordId, string sbNotice, string objectType, string action, string callOutURL) {
        
        //if calloutUrl is provided, use it otherwise getCalloutUrl;
        string endpoint = (!string.isBlank(callOutURL)) ? callOutURL : getCallOutURL();
        system.debug('endpoint: ' + endpoint);
        //ensure that SbNotice, really is populated
        if (!string.isBlank(endpoint) && !string.isBlank(sbNotice)) {
            
            SbResponseWrapper notice;

            //prepare the request body
            try{
                notice = (SbResponseWrapper) JSON.deserialize(sbNotice, SbResponseWrapper.class);
                notice.recordId = (String) recordId;
                notice.action = action;
                notice.parseType = (objectType.contains('Contact')) ? 'Contact' : 'Lead';
                
            }catch (Exception e) {
                if(e.getTypeName() == 'JSONException' && e.getMessage().contains('expected a valid value (number, String, array, object, \'true\', \'false\' or \'null\')')){
                    string error = 'Error with JSON, invalid chars in string: ' + e.getCause() + ', RecordID: ' + recordId;
                    System.debug(error); 
                }else{
                    string error = 'Error with Parsing JSON: ' + e.getCause() + ' Line: ' + e.getLineNumber() + ', RecordID: ' + recordId;
                    System.debug(error);
                    
                }
            }

            //Prepare the callout
            HTTP h = new HTTP();
            HTTPRequest req = new HTTPRequest();
            HTTPResponse res;
            
            //prepare the request headers
            req.setEndPoint(endpoint);
            req.setHeader('Authorization', 'Bearer ' + notice.access_token);
            req.setHeader('X-Application', 'salesforce');
            req.setMethod('POST');

            string inputBody = json.serialize(notice);
            system.debug(inputBody);
            req.setBody(inputBody);  //re-serialize the notice wrapper

            System.debug('Request: ' + req);

            //send the notice
            try {
                if(Test.isRunningTest()){
                    res = new HTTPResponse();
                    res.setStatusCode(200);
                    res.setStatus('Success');
                } 
            
                else res = h.send(req);
                
                system.debug('HTTP Response: ' + res.getStatusCode() + ', Status: ' + res.getStatus());
                
            } catch (CalloutException e) {
                string error = 'ERROR: ' + e.getCause() + ' Line: ' + e.getLineNumber();
                System.debug(error);
            }
        }
        
    }

    public class SbResponseWrapper {
        public string access_token;
        public string recordId;
        public string action;
        public CandidateDataObject candidateData;
        public LeadDataObject leadData;
        public string parseType;
    }

    public class CandidateDataObject {
        public string resumeId;
        public string searchId;
        public string jobBoard;
        public string link;
        public string name;
        public string instance_url;
    }

    public class LeadDataObject {
        public string type;
        public string jobBoard;
        public string link;
    }


    ///////////////////////////
    //      Page Layout      //
    ///////////////////////////

    @AuraEnabled
    public static List<LayoutSection> getPageLayoutFields(string objectType) {

        List<LayoutSection> lstSections = new List<LayoutSection>();
        List<String> componentNameList = new List<String>();

        String whichEnvironment = SbHelper.whichEnviron();
        Map<String,String> settings = SbHelper.findSettings(whichEnvironment);

        system.debug('getPageLayoutFields | object: ' + objectType);
        String objectNameFriendly = ''; 
        String pageLayout = '';

        if(settings.containsKey('leadobject') && (objectType.toLowerCase() == settings.get('leadobject').toLowerCase())) {
            objectNameFriendly = 'Lead';
            if(settings.containsKey('lead_pagelayout')){
                pageLayout = settings.get('lead_pagelayout');
                componentNameList.add(pageLayout);
            }
        }
        else if(settings.containsKey('candidateobject') && (objectType.toLowerCase() == settings.get('candidateobject').toLowerCase())) {
            objectNameFriendly = 'Candidate';
            if(settings.containsKey('candidate_pagelayout')){
                pageLayout = settings.get('candidate_pagelayout');
                componentNameList.add(pageLayout);
            }
        }

        //If unable to populate list with the required page layout
        if (componentNameList.isEmpty()){

            system.debug('getPageLayoutFields: No match found for object API name in SourceBreaker Settings, and the type of record trying to be loaded.');
            throw new AuraException('Unable to find relevant ' + objectNameFriendly + ' page layout mapping, please re-check SourceBreaker Settings.');
        }
        
        try {
            // Provide the page layout name here
            // You can give multiple page layout names here as well
            
            // Retrieve page layout details
            List<Metadata.Metadata> components = Metadata.Operations.retrieve(Metadata.MetadataType.Layout, componentNameList);
            Metadata.Layout contLayout = (Metadata.Layout) components.get(0);
            // We are going to find the fields names and will keep them according to columns so
            // we can show them as per page layout
            for (Metadata.LayoutSection ls : contLayout.layoutSections) {
                LayoutSection section = new LayoutSection(ls.label, ls.layoutColumns.size());

                List<LayoutColumn> lstColumns = new List<LayoutColumn>();
                Integer maxFieldsInColumn = 0;
                for (Metadata.LayoutColumn lc : ls.layoutColumns) {

                    LayoutColumn column = new LayoutColumn();
                    // check if there are fields available in that column
                    if (lc.layoutItems != null) {
                        // Get the max number of fields in a column to preserve the alignment
                        if (maxFieldsInColumn < lc.layoutItems.size()) {
                            maxFieldsInColumn = lc.layoutItems.size();
                        }
                        for (Metadata.LayoutItem li : lc.layoutItems) {

                            // Pass the LayoutItem object in the LayoutField consturctor
                            if (li.field != null && li.field != '') {
                                column.lstFields.add(new LayoutField(li));
                            }
                        }
                    }
                    // No need to add a column in the section if there is no field available
                    if (column.lstFields.size() > 0) {
                        lstColumns.add(column);
                    }
                }

                // Now, we need to arrange the fields in section so we can use them in the iteration
                // on the component so we will have to arrange them in the order
                if (maxFieldsInColumn > 0) {
                    for (Integer i = 0; i < maxFieldsInColumn; i++) {
                        for (Integer j = 0; j < lstColumns.size(); j++) {
                            if (lstColumns[j].lstFields.size() > i) {
                                section.lstFields.add(lstColumns[j].lstFields[i]);
                            } else {
                                section.lstFields.add(new LayoutField());
                            }
                        }
                    }
                }

                if (section.lstFields.size() > 0) {
                    lstSections.add(section);
                }
            }
        } catch (Exception e) {
            
            System.assert(false, e.getLineNumber() + ' : ' + e.getMessage());
            throw new AuraException('Error while attempting to load ' + objectNameFriendly + ' page layout.  Please check page layout mapping in SourceBreaker Settings.');
        }
        return lstSections;
    }

    public class LayoutSection {
        @AuraEnabled public String label;
        @AuraEnabled public List<LayoutField> lstFields;
        @AuraEnabled public Integer totalColumns;
        public LayoutSection(String label, Integer totalColumns) {
            this.label = label;
            this.totalColumns = totalColumns;
            this.lstFields = new List<LayoutField>();
        }
    }

    private class LayoutColumn {
        private List<LayoutField> lstFields;
        public LayoutColumn() {
            this.lstFields = new List<LayoutField>();
        }
    }

    public class LayoutField {
        @AuraEnabled public String fieldName;
        @AuraEnabled public Boolean isRequired;
        @AuraEnabled public Boolean isReadOnly;

        public LayoutField() {
        }

        public LayoutField(Metadata.LayoutItem li) {
            system.debug('DEBUG === fieldName: ' + li.field + ', behaviour: ' + li.behavior);
            this.fieldName = li.field;
            if (li.behavior == Metadata.UiBehavior.Required) {
                this.isRequired = true;
            } else if (li.behavior == Metadata.UiBehavior.ReadOnly) {
                this.isReadOnly = true;
            }
        }
    }

}