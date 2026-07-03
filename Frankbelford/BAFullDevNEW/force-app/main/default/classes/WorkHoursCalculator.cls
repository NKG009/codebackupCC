/**
 * @AUTHOR      Charlie Nash (RSSGlobal)
 * @DATE        11/07/2023
 *
 * @DESCRIPTION:
 *
 * ============================================== VERSION HISTORY ==============================================
 *
 * V1.0 - WorkHoursCalculator.cls created - 11/07/2023
 *
 * =============================================================================================================
 */

public class WorkHoursCalculator {

    /**
     * @param timeVar - Contains the dateTime parsed into the method
     *
     * @return - returns a boolean (true or false) as to whether the datetime parsed was within working hours or not.
     */
    @AuraEnabled
    public static Boolean isInWorkHours(Datetime timeVar){

        Boolean isWorkHours = false;

        if(timeVar == null){
            //If no time was passed, we use the time currently;
            timeVar = Datetime.now();
        }

        //If there is a time parsed into the method, continue
        String dayVar = timeVar.format('EEEE');
        Integer hourVar = timeVar.hour();

        BlueArrowWorkingHours__c hours = [SELECT Start_Time__c, End_Time__c FROM BlueArrowWorkingHours__c LIMIT 1];

        Integer startTime = hours != null ? (Integer)hours.Start_Time__c : 9;
        Integer endTime = hours != null ? (Integer)hours.End_Time__c : 17;

        if(dayVar != 'Thursday' && dayVar != 'Sunday'){
            if(hourVar >= startTime && hourVar < endTime){
                isWorkHours = true;
            }
        }
        return isWorkHours;
    }

    public class FlowOutputs {
        @InvocableVariable
        public Boolean isWorkHours;
    }

    @InvocableMethod (Label='Calculate Working Hours')
    public static List<FlowOutputs> isInWorkHoursInvocable(){

        Boolean result = isInWorkHours(Datetime.now());

        List<FlowOutputs> results = new List<FlowOutputs>();

        FlowOutputs output = new FlowOutputs();
        output.isWorkHours = result;

        results.add(output);

        return results;

    }

}