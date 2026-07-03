public with sharing class GuidanceInstructionsController {
    @AuraEnabled(cacheable=true)
    public static String getGuidanceInstructions(Id recordId, String sObjectTypeReference, String sObjectTarget) {        
        try {
            // Retrieve the object type of the provided recordId
            String objectType = recordId.getSObjectType().getDescribe().getName();
			
             // Return an error message if sObjectTarget is empty
            if (String.isEmpty(sObjectTarget)) {
                return Label.EmptySObjectTargetError;
            }
            
            String query = String.escapeSingleQuotes('SELECT ' + sObjectTarget + ' FROM ' + objectType + ' WHERE Id = :recordId LIMIT 1');
            SObject recordReturned = Database.query(query);
			
            // Return null if the record was not found
            if (recordReturned == null) {
                return null;
            }
            
            Object fieldValue = null;
            String result = null;
            String userLanguage = UserInfo.getLanguage();
            List<String> relationshipSplit = new List<String>();
            
            // Split the sObjectTarget if it contains relationship dots (e.g., Parent.Relationship)
            if (sObjectTarget.contains(ApexConstants.DOT)) {
                relationshipSplit = sObjectTarget.split(ApexConstants.RELATIONSHIP_SPLIT_DELIMITER);
            }
            
            // Traverse through the relationship chain to get the actual field value
            if (!relationshipSplit.isEmpty()) {
                Integer length = relationshipSplit.size();
                Integer lastIndex = length - 1;
                
                SObject temporaryObject;
                
                for (Integer index = 0; index < relationshipSplit.size(); index++) {
                    String item = relationshipSplit[index];
                    
                    if (index < lastIndex) {
                        if (temporaryObject == null) {
                            temporaryObject = recordReturned.getSObject(item);
                        } else {
                            temporaryObject = temporaryObject.getSObject(item);
                        }
                    } else {
                        fieldValue = temporaryObject.get(item);
                    }
                }
            }
            
            String detailsFieldApiName = String.valueOf(fieldValue);
            
            List<Guided_Instruction__c> guidanceRecords = [SELECT Instructions__c 
                                                           FROM Guided_Instruction__c 
                                                           WHERE Object__c = :sObjectTypeReference 
                                                           AND Target_Audience__c = :detailsFieldApiName
                                                           AND Language__c = :userLanguage
                                                           LIMIT 1];
            // Return the instructions if found
            if (!guidanceRecords.isEmpty()) {
                result = guidanceRecords[0].Instructions__c;
            }
            
            return result;
        } catch (Exception e) {
             throw new AuraHandledException(Label.UnknownError + ' ' + e.getMessage());
        }
    }
}