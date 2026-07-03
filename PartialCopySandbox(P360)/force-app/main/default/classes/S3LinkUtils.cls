/* **************************************************************************
* Copyright © 2015-2020, Neilon Technologies LLP
* All rights reserved
*
* Util Class: S3LinkUtils
* Created by Suresh Meghnathi: 29/09/2020
*
* - All util functions.

* - Modifications:
* - Suresh Meghnathi, 29/09/2020 – Initial Development
************************************************************************** */
public with sharing class S3LinkUtils {
    /**************************************************************************
       Purpose: Pass the onject api name and method will return whether trigger for that object is active or deactivate as per the custom settings.
       Parameters: 
       Returns: 
       Throws [Exceptions]: 
    ****************************************************************************/
    private static Map<String, NEILON__Trigger_Deactivation_Configuration__c> triggerActivationConfigurationMap = null;
    public static Boolean isTriggerDeactivate(String objectAPIName){
    	if(triggerActivationConfigurationMap == null){
    	   triggerActivationConfigurationMap = NEILON__Trigger_Deactivation_Configuration__c.getAll();
    	}
    	if(triggerActivationConfigurationMap != null && triggerActivationConfigurationMap.get(objectAPIName) != null){
    		return triggerActivationConfigurationMap.get(objectAPIName).NEILON__Disabled__c;
    	}
    	return false;
    }
    
    // Set of Standard Parent Object Field API Names
    public static Set<String> STANDARD_PARENT_OBJECT_API_NAMES  = new Set<String>();
	
    // Set of reserved Parent Object Field API Names
    public static Set<String> RESERVED_PARENT_OBJECT_API_NAMES = new Set<String>{
    	'Account__c',
    	'Asset__c',
    	'Campaign__c',
    	'Case__c',
    	'Contact__c',
    	'Contract__c',
    	'Lead__c',
    	'Opportunity__c',
    	'Product2__c',
    	'Solution__c',
    	'User__c'
    };
    
    // Map of english plural labels by object type
    public static Map<String, String> ENGLISH_PLURAL_LABELS_MAP = 
        new Map<String, String>
        {
        	'Account'		=> 'Accounts',
	    	'Asset'			=> 'Assets',
	    	'Campaign'		=> 'Campaigns',
	    	'Case'			=> 'Cases',
	    	'Contact'		=> 'Contacts',
	    	'Contract'		=> 'Contracts',
	    	'Lead'			=> 'Leads',
	    	'Opportunity'	=> 'Opportunities',
	    	'Product2'		=> 'Products',
	    	'Solution'		=> 'Solutions',
	    	'User'			=> 'Users'
        };
        
    // Secondary name field API names map
    public static Map<String, String> SECONDARY_NAME_FIELD_MAP = 
    	new Map<String, String>
    	{
    		'Case' => 'CaseNumber',
			'Contract' => 'ContractNumber',
			'Task' => 'Id',
			'Event' => 'Id',
			'Solution' => 'SolutionNumber',
			'Order' => 'OrderNumber',
			'OrderItem' => 'OrderItemNumber',
			'ContentDocument' => 'Title'
    	};
    	
	
   
    
    /**********************************************************************************************************
       Purpose: This method will be used to prepare the query string from set of ids you want to check for "IN" clause. 
       Parameters:  setStringValues - List of String you are going to use in "IN" clause. 
       Returns: 	Query string for IN clause i.e  ('In Progress', 'Completed')
       Throws [Exceptions]: 
    **********************************************************************************************************/
    public static String prepareQueryStringForInClause(Set<String> setStringValues){
    	if(setStringValues.isEmpty()){
    		return '(null)';
    	}
    	String valuesInClause = '( ';
		for (String value : setStringValues){
		    valuesInClause += '\'' + String.escapeSingleQuotes(value) + '\',';
		}
		valuesInClause  = valuesInClause.substring(0, valuesInClause.length() - 1);
		valuesInClause += ')';
		return valuesInClause;
	}
    
    /**********************************************************************************************************
       Purpose: This method will be used to prepare the query string from set of ids you want to check for "IN" clause. 
       Parameters:  setIdValues - Set of Ids you are going to use in "IN" clause. 
       Returns: 	Query string for IN clause i.e  ('a0A121212114rw4', 'a0A454rere24wedq5')
       Throws [Exceptions]: 
    **********************************************************************************************************/
    public static String prepareQueryStringForInClause(Set<Id> setIdValues){
    	Set<String> setStringValue  = new Set<String>();
    	for(Id value : setIdValues){
    		if(value != null){
    			setStringValue.add(value);
    		}
    	}
    	return prepareQueryStringForInClause(setStringValue);
    }
    
    /*
    *   Purpose:    This method will be used to prepare the query string "=" clause. If the value is null then ='null' will not work in that case it should be like = null
    *   Parameters:
    *   UnitTests:
    */
	public static String prepareQueryStringForEqualClause(String value){
    	if(value != null){
    		return '\''+String.escapeSingleQuotes(value)+'\'';
    	} else{
    		return 'null';
    	}
    }
    
   
    /**************************************************************************
       Purpose: Get parent field API name from parent Id
       Parameters: 
       Returns: 
       Throws [Exceptions]: 
    ****************************************************************************/
	public static String getParentFieldAPIFromId(Id parentId, Boolean isForAmazonMigrationReport){
		Schema.SObjectType parentSobjectType = parentId.getSObjectType();
		String parentObjectAPIName = parentSobjectType.getDescribe().getName();
		return getParentFieldAPIFromObjectAPI(parentObjectAPIName, false, isForAmazonMigrationReport);
	}
    
    /**************************************************************************
       Purpose: Get parent field API name from parent object API name
       Parameters: 
       Returns: 
       Throws [Exceptions]: 
    ****************************************************************************/
	public static String getParentFieldAPIFromObjectAPI(String parentObjectAPIName, Boolean isSoftParent, Boolean isForAmazonMigrationReport){
        String parentFieldAPI = parentObjectAPIName;
        
        if(!isForAmazonMigrationReport){
            // Check if we need to add namespace or not
            String nameSpacePrefix = 'NEILON__';
            if(parentObjectAPIName.endsWith('__x')){
                return parentFieldAPI.replace('__x', '__c');
            } else if(!parentObjectAPIName.contains('__c')){
                parentFieldAPI = parentObjectAPIName + '__c';
                if(!isSoftParent && !String.isBlank(nameSpacePrefix) && S3LinkUtils.RESERVED_PARENT_OBJECT_API_NAMES.contains(parentFieldAPI)){
                    parentFieldAPI = nameSpacePrefix + parentFieldAPI;
                }
            } else {
                Integer countsOfUnderscores = parentObjectAPIName.countMatches('__');
                if(countsOfUnderscores == 2){
                    Integer indexOfFirstUnderscore = parentObjectAPIName.indexOf('__');
                    parentFieldAPI = parentObjectAPIName.substring(indexOfFirstUnderscore + 2, parentObjectAPIName.length());
                }
                if(S3LinkUtils.RESERVED_PARENT_OBJECT_API_NAMES.contains(parentFieldAPI) || S3LinkUtils.STANDARD_PARENT_OBJECT_API_NAMES.contains(parentFieldAPI)){
                    parentFieldAPI = parentFieldAPI.substring(0, parentFieldAPI.indexOf('__')) + '1__c';
                }
            }
        } else{
            if(parentObjectAPIName.endsWith('__x')){
                return parentFieldAPI.replace('__x', '__c');
            } else if(!parentObjectAPIName.contains('__c')){
                parentFieldAPI = parentObjectAPIName + '__c';
            } else {
                Integer countsOfUnderscores = parentObjectAPIName.countMatches('__');
                if(countsOfUnderscores == 2){
                    Integer indexOfFirstUnderscore = parentObjectAPIName.indexOf('__');
                    parentFieldAPI = parentObjectAPIName.substring(indexOfFirstUnderscore + 2, parentObjectAPIName.length());
                }
            }
        }
        return parentFieldAPI;
    }
}