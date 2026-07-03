public class MiniPayrollApx {
    @AuraEnabled
    public static string MiniPayrollBtn(string RecId)
    {
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        sirenum__Timesheet__c timesheetrec = [Select id,IP_Mini_Payroll__c,Timesheet_Line_Count__c,sirenum__Lines__c from sirenum__Timesheet__c where id=:RecId];		
		List<sirenum__Timesheet_Line__c> timelisttrue = [Select id,IP_Locktimesheet__c,sirenum__Timesheet__c from sirenum__Timesheet_Line__c where IP_Locktimesheet__c = true and sirenum__Timesheet__c=:RecId];
		List<sirenum__Timesheet_Line__c> timelistfalse = [Select id,IP_Locktimesheet__c,sirenum__Timesheet__c from sirenum__Timesheet_Line__c where IP_Locktimesheet__c = false and sirenum__Timesheet__c=:RecId];		
        if(timesheetrec.sirenum__Lines__c > 0)
        {
            system.debug('kfkjjkfg'+timesheetrec.Timesheet_Line_Count__c);
			
            if(timelisttrue.size() ==0 || timelistfalse.size()>0)
            {
                timesheetrec.IP_Mini_Payroll__c = TRUE;
				update timesheetrec;
				string result= EmergencyPullupdate.updatedata(RecId);
                system.debug('Timesheet_Line_Count__c ==0 ');
                return result;
            }
            else
            {
                if(profileName =='JS Recruiter - Hybrid')
                {
                    return 'This timesheet has already been passed for payment'; 
                }
                else
                {
                    return 'Open Confirm Popup';
                }
                
            }
            
            
        }
        else
        {
            return 'There are no Timesheet lines linked to this Timesheet';
        }
    }
    @AuraEnabled 
    public static string MiniPayrollBtn2(string RecId2)
    {        
		string result = EmergencyPullupdate.updatedata(RecId2);
        return result;
        
        
    }
    
}