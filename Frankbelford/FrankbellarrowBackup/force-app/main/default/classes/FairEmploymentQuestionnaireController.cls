/*
* Class Name: FairEmploymentQuestionnaireController
* Description: Class for Community Background Template
* Test Class : TestFairEmpQuestionnaireController
* Date : 21th Nov 2019
*/
public class FairEmploymentQuestionnaireController {
    public id record_Id{get; set;}
    public Contact conid{get; set;}
    public string department;
    public String branchphone{get;set;}
    
     /*
    * Method Name: getconid
    * Description: Method for Community Background Template
    * Parameters : none
    * Return Type: nothing
    */
    public Contact getconid(){
            system.debug('record_id ' + record_Id);
            if(record_Id != null){
            conid = [
                SELECT
                id,IP_TempestDepartment__c,FirstName FROM Contact 
                WHERE 
                Id = :record_Id
            ];system.debug('conid.FirstName ' + conid.FirstName );
            department = conid.IP_TempestDepartment__c;
            System.debug('check department'+department);
            IP_Shift_Template__c shiftemp = IP_Shift_Template__c.getValues(department); 
            branchphone = shiftemp.Phone__c;
        }
        return conid;
    }
}