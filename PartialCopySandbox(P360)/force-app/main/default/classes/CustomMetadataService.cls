/*******************************************************************************************
* @Name         CustomMetadataService
* @Author       Rajesh
* @Description  This class create a sample data for custom metadata
*******************************************************************************************/
@isTest(seeAllData = false)
public class CustomMetadataService {
    
    static String pdevName = '';
    static String pmasterLabel = '';
    static String pcompanyId = '';
    static String psource = '';
    
    public CustomMetadataService(String devName,String masterLabel,String companyId,String source) {
        
        pdevName = devName;
        pmasterLabel = masterLabel;
        pcompanyId = companyId;
        psource = source;
    }

    /**
     * This method instantiates a custom metadata record of type Property_API_Configuration__mdt
     * and sets the custom metadata fields to the input String.
     * Note that the record is not inserted into the database, 
     * and would not be found by a SOQL query.
     */
     @isTest
    public static Property_API_Configuration__mdt getCustomMetadataRecord() {
        Property_API_Configuration__mdt theRecord = new Property_API_Configuration__mdt();
        theRecord.DeveloperName = pdevName;
        theRecord.MasterLabel = pmasterLabel;
        theRecord.Authorization__c = '1623871263';
        theRecord.Company_Id__c = pcompanyId;
        theRecord.Endpoint__c = 'https://api.test.com';
        theRecord.Source__c = psource;
        return theRecord;
    }
    /**
     * This method instantiates a custom metadata record of type Property_Me_API_Configuration__mdt
     * and sets the custom metadata fields to the input String.
     * Note that the record is not inserted into the database, 
     * and would not be found by a SOQL query.
     */
     @isTest
    public static Property_Me_API_Configuration__mdt getPMCustomMetadataRecord() {
        Property_Me_API_Configuration__mdt theRecord = new Property_Me_API_Configuration__mdt();
        theRecord.DeveloperName = pdevName;
        theRecord.MasterLabel = pmasterLabel;
        theRecord.Endpoint__c = 'https://api.test.com';
        theRecord.Source__c = psource;
        return theRecord;
    }
    /**
     * This method retrieves a custom metadata record, changes a field, and returns it
     * to the caller. Note that the changed record is not updated in the database.
     */
    @isTest
    public static Property_API_Configuration__mdt getChangedCustomMetadataRecord() {
        Property_API_Configuration__mdt theRecord = [SELECT Id, DeveloperName from Property_API_Configuration__mdt LIMIT 1];
        //theRecord.DeveloperName = myNewName;
        return theRecord;
    }
	/**
     * This method retrieves a custom metadata record, changes a field, and returns it
     * to the caller. Note that the changed record is not updated in the database.
     */
    @isTest
    public static Property_Me_API_Configuration__mdt getPMChangedCustomMetadataRecord() {
        Property_Me_API_Configuration__mdt theRecord = [SELECT Id, DeveloperName from Property_Me_API_Configuration__mdt LIMIT 1];
        //theRecord.DeveloperName = myNewName;
        return theRecord;
    }

}