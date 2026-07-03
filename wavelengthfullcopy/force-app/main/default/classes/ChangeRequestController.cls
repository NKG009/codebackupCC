/*Author : Priyanka
* Case link :https://targetrecruit.atlassian.net/browse/WAVE-66
* LWC :extendPlacementComponent
Test class : ChangeRequestControllerTest
*/
public class ChangeRequestController {
    
    @AuraEnabled(cacheable=true)
    public static AVTRRT__Placement__c getPlacementData(Id recordId) {
        return [
            SELECT Id, Name, AVTRRT__Contact_Candidate__r.Name, AVTRRT__Job_Title__c, AVTRRT__Start_Date__c,Client_Charge__c,Billing_Contact__c,
            AVTRRT__End_Date__c, AVTRRT__Job__r.Name, AVTRRT__Employer__r.Name, AVTRRT__Job_Applicant__r.Name
            FROM AVTRRT__Placement__c
            WHERE Id = :recordId
            LIMIT 1
        ];
    }
    @AuraEnabled
    public static Id savePlacementData(AVTRRT__Placement__c plaementList,Boolean ratechangeCB, Boolean extensionCB, Date startDate, Date endDate, Id recordId) {
        Id newPlacementId;
        AVTRRT__Placement__c placementCloned = new AVTRRT__Placement__c();
        List<AVTRRT__Placement__c> placementList = new List<AVTRRT__Placement__c>();
        try {
            DescribeSObjectResult describeResult = recordId.getSObjectType().getDescribe(); 
            List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );  
            String query =    ' SELECT ' +        String.join( fieldNames, ',' ) +    ' FROM ' +        describeResult.getName() +    ' WHERE ' +        ' id = :recordId ' +    ' LIMIT 1 '  ;  
            AVTRRT__Placement__c oldPlacement = database.query(query);
            oldPlacement = Database.query( query );
            
            
            
            // placementCloned.AVTRRT__Start_Date__c = plaementList.AVTRRT__Start_Date__c ;
              placementCloned = oldPlacement.clone(false, true);
                placementCloned.AVTRRT__Start_Date__c = startDate;
                placementCloned.AVTRRT__End_Date__c = endDate;
           // if(ratechangeCB == false){
           
                placementCloned.AVTRRT__Pay_Rate__c =plaementList.AVTRRT__Pay_Rate__c !=null ? plaementList.AVTRRT__Pay_Rate__c : null;
                placementCloned.Pay_Rate_Currency__c =plaementList.AVTRRT__Pay_Rate__c !=null ? Decimal.valueOf(plaementList.AVTRRT__Pay_Rate__c) : null;
                placementCloned.AVTRRT__External_ID__c = plaementList.AVTRRT__External_ID__c !=null ? plaementList.AVTRRT__External_ID__c : null; 
                placementCloned.Billing_Contact__c =plaementList.Billing_Contact__c !=null ? plaementList.Billing_Contact__c : null;
                placementCloned.AVTRRT__Pay_Type__c =plaementList.AVTRRT__Pay_Type__c !=null ? plaementList.AVTRRT__Pay_Type__c : '';

                //placementCloned.AVTRRT__End_Date__c = plaementList.AVTRRT__End_Date__c !=null ? plaementList.AVTRRT__End_Date__c : null;
                placementCloned.Rate_Type__c = plaementList.Rate_Type__c !=null ? plaementList.Rate_Type__c : '';
                placementCloned.Purchase_Order_Client_Tracking_No__c = plaementList.Purchase_Order_Client_Tracking_No__c !=null ? plaementList.Purchase_Order_Client_Tracking_No__c : null;
                placementCloned.Mark_up__c = plaementList.Mark_up__c !=null ? plaementList.Mark_up__c : null;
                placementCloned.Superannuation__c = plaementList.Superannuation__c !=null ? plaementList.Superannuation__c : null;
                placementCloned.Superannuation_Currency__c = plaementList.Superannuation__c !=null ? plaementList.Superannuation__c : null;
                placementCloned.Payroll_Tax__c =plaementList.Payroll_Tax__c !=null ? plaementList.Payroll_Tax__c : null;   
                placementCloned.Total_Credential_Requirements__c = 0;
                placementCloned.Total_Non_Compliant_Req__c = 0;
                placementCloned.Total_Compliant_Req__c = 0;
                placementCloned.Isimio_Placement__c = null;
                placementCloned.Insurances__c = plaementList.Insurances__c !=null ? plaementList.Insurances__c : null;
                placementCloned.GNC__c = plaementList.GNC__c !=null ? plaementList.GNC__c : null;
                placementCloned.Margin__c = plaementList.Margin__c !=null ? plaementList.Margin__c : null;
                
                placementCloned.Payroll_Tax__c = plaementList.Payroll_Tax__c !=null ? plaementList.Payroll_Tax__c : null;
                placementCloned.Workers_Comp__c = plaementList.Workers_Comp__c !=null ? plaementList.Workers_Comp__c : null;
                placementCloned.AVTRRT__Extension__c = extensionCB;
                placementCloned.Rate_Change__c= ratechangeCB;
                placementCloned.Number_of_units__c =plaementList.Number_of_units__c !=null ? plaementList.Number_of_units__c : null;
                
                placementList.add(placementCloned);
          /*  }else{
                
              
                placementList.add(placementCloned);
            }*/
            insert placementList;
            
        }
        catch (DmlException e) {
            throw new AuraHandledException('The following exception has occurred: ' + e.getMessage());
        }
        return placementCloned.Id;
    }
    
}