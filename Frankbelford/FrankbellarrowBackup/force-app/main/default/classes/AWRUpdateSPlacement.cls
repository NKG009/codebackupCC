/*
* Class Name: AWRUpdateSPlacement.
* Description: Batch to Update IP_AWRParityReached__c on S-Placement from sirenum__AWR_Eligible__c on AWR 
*              which runs daily 1 AM.
* Test Class: TEST_AWRUpdateSPlacement
* Author : Amit Kohli - Espire.
* Scheduled Class: AWRUpdateSPlacementScheduled
* Date : 26th Sep 2017
*/
global class AWRUpdateSPlacement implements Database.Batchable<sObject> {
    
    /*
* Method Name: start.
* Description: Just to the get the query locator for scope List<sirenum__AWR__c>
* Parameters : Database.BatchableContext
* Return Type: Database.QueryLocator
* Author : Amit Kohli - Espire.
* Date : 26th Sep 2017
*/
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Date today = System.today();
        String query = 'select id, name,sirenum__Contact__c,sirenum__Client__c,sirenum__Valid_Until__c,sirenum__AWR_Group__c,sirenum__AWR_Eligible__c from sirenum__AWR__c where sirenum__Valid_Until__c > :today';
        return Database.getQueryLocator(query);
    }
    
    
    /*
* Method Name: execute.
* Description: To Update IP_AWRParityReached__c on S-Placement from sirenum__AWR_Eligible__c on AWR 
* Parameters : Database.BatchableContext, List<sirenum__AWR__c>
* Return Type: Void
* Author : Amit Kohli - Espire.
* Date : 26th Sep 2017
*/
    global void execute(Database.BatchableContext bc, List<sirenum__AWR__c> scope) {
        // To collect the list of Account Ids from AWR object. used in query to filter Splacement records.
        List<id> client = new List<id>(); 
        
        // To collect the list of Contact Ids from AWR object. used in query to filter Splacement records.
        List<id> contact = new List<id>();
        
        //save the records which are going to updated with IP_AWRParityReached__c field.
        List<sirenum__Placement__c> splacementsToBeUpdatedList = new List<sirenum__Placement__c>();
        
        system.debug('scope-->'+scope);
        
        // Looping through scope to get contactIds and ClientIds(Account Ids)
        for(sirenum__AWR__c awr: scope){
            contact.add(awr.sirenum__Contact__c);
            client.add(awr.sirenum__Client__c);
        }
        
        // Query to get all the S-Placement records based on contactIds and AccountIds
        List<sirenum__Placement__c> splacements = [select id, name,sirenum__Site__r.sirenum__Operating_Company__c,
                                                   sirenum__Job_Role__r.sirenum__AWR_Group__c,sirenum__Contact__c,
                                                   IP_AWRUntilDate__c,IP_AWRParityReached__c
                                                   from sirenum__Placement__c
                                                   where sirenum__Site__r.sirenum__Operating_Company__c in: client
                                                   and sirenum__Contact__c in: contact
                                                  and sirenum__End_Date__c > : System.today()-20];
        system.debug('splacements-->'+splacements);
        
        
        // whole functionality to update the IP_AWRParityReached__c on S-Placement.
        for(sirenum__Placement__c plc : splacements){
            boolean isAdded= false;
            for(sirenum__AWR__c awr: scope){
                if(plc.sirenum__Site__r.sirenum__Operating_Company__c == awr.sirenum__Client__c &&
                   plc.sirenum__Contact__c == awr.sirenum__Contact__c &&
                   plc.sirenum__Job_Role__r.sirenum__AWR_Group__c == awr.sirenum__AWR_Group__c){
                       if(plc.IP_AWRUntilDate__c == null || plc.IP_AWRUntilDate__c < awr.sirenum__Valid_Until__c){
                           plc.IP_AWRUntilDate__c = awr.sirenum__Valid_Until__c;
                           plc.IP_AWRParityReached__c = awr.sirenum__AWR_Eligible__c;
                           if(!isAdded){
                               splacementsToBeUpdatedList.add(plc);
                               isAdded = true;
                           }
                       }
                   }
            }
        }
        
        
        //Nullifying the IP_AWRUntilDate__c on S-Placement records. 
        //This field is created and updated in above logic to accomplish the functionality. 
        for(sirenum__Placement__c plc : splacementsToBeUpdatedList){
            plc.IP_AWRUntilDate__c = null;
        }
        
        //update statement to commit the S-placement records with updated IP_AWRParityReached__c values.
        update splacementsToBeUpdatedList;
        system.debug('updated splacements-->'+splacementsToBeUpdatedList);
    }
    
    
    /*
* Method Name: finish.
* Description: To wrap up the things after batch has executed. Blank method, nothing is required in it.
*              Need to define as implementing Database.Batchable interface.
* Parameters : Database.BatchableContext
* Return Type: Void
* Author : Amit Kohli - Espire.
* Date : 26th Sep 2017
*/    
    global void finish(Database.BatchableContext bc) {
        
    }
    
}