public  without sharing class Temp_Hours_Cnt {
    @AuraEnabled
    public static List<sirenum__Shift__c> getAllShifts(String filter,String site) {
        
        
        String accID = [select id, contact.AccountId from User where id =: UserInfo.getUserId() limit 1][0].contact.AccountId;
        String conID = [select id, contactId from User where id =: UserInfo.getUserId() limit 1][0].contactId;
        
        // String accID = [select id, contact.AccountId from User where id =: '0051w000000vDDcAAM' limit 1][0].contact.AccountId;
        // String conID = [select id, contactId from User where id =: '0051w000000vDDcAAM' limit 1][0].contactId;
        
        
        /*    string queryData = 'SELECT Id, X__c,Y__c,Z__c,sirenum__Team__r.Name,sirenum__Site__r.name,sirenum__Team__c,sirenum__Site__c,sirenum__Scheduled_Start_Time__c, sirenum__Scheduled_End_Time__c FROM sirenum__Shift__c WHERE ';
if(filter=='today'){
queryData = queryData + ' sirenum__Scheduled_Start_Time__c = TODAY AND ';
}
else if(filter=='tomorrow'){
queryData = queryData + ' sirenum__Scheduled_Start_Time__c = TOMORROW AND ';
}
else if(filter=='next7days'){
queryData = queryData + ' sirenum__Scheduled_Start_Time__c <= NEXT_N_DAYS:7 AND ';
}
else if(filter=='next14days'){
queryData = queryData + ' sirenum__Scheduled_Start_Time__c <= NEXT_N_DAYS:14 AND ';
}
else if(filter=='future'){
queryData = queryData + ' sirenum__Scheduled_Start_Time__c > NEXT_N_DAYS:14 AND ';
}

if(site!=null && site !=''){
queryData = queryData + ' sirenum__Site__c =: site AND ';
}

queryData = queryData +' sirenum__Scheduled_Start_Time__c >= TODAY AND (sirenum__Site__r.IP_MainContact__c =: conID OR sirenum__Site__r.Emergency_Contact__c=:conID OR sirenum__Site__r.IP_InvoiceContact__c =:conID) AND sirenum__Site__r.sirenum__Operating_Company__c =: accID  ORDER BY sirenum__Scheduled_Start_Time__c LIMIT 50000';

List<sirenum__Shift__c> shiftList = Database.query(queryData);
Map<String,id> uniqueRecords = new Map<String,id>();
for (sirenum__Shift__c sh : shiftList){
if(!uniqueRecords.containsKey(String.valueof(sh.sirenum__Scheduled_Start_Time__c)+String.valueOf(sh.sirenum__Scheduled_End_Time__c)+sh.sirenum__Site__c+sh.sirenum__Team__c)){
uniqueRecords.put(String.valueOf(sh.sirenum__Scheduled_Start_Time__c)+String.valueOf(sh.sirenum__Scheduled_End_Time__c)+sh.sirenum__Site__c+sh.sirenum__Team__c, sh.id);
}
}

System.debug('******'+shiftList.size());*/
        DateTime dt = System.now();
        List<sirenum__Shift__c> returnshift = [SELECT Id,name,sirenum__Cancelled__c, sirenum__Actual_Start_Time__c,sirenum__Actual_End_Time__c,sirenum__Break_Length__c,sirenum__Scheduled_Start_Time__c,EndTime__c,Createddate, Starttime__c ,sirenum__Scheduled_End_Time__c, sirenum__Team__r.name, sirenum__Site__r.name
                                               FROM sirenum__Shift__c where sirenum__Site__c =: site AND sirenum__Scheduled_Start_Time__c >=:dt  ORDER BY sirenum__Scheduled_Start_Time__c limit 4];
        System.debug('*****returnshift*'+returnshift);
        return returnshift;
    }
    
    
    @AuraEnabled
    public static String getAllShiftsHoursData(String site) 
    {
        List<Hoursline> hoursWrapperl = new List<Hoursline>();
        String accID = [select id, contact.AccountId from User where id =: UserInfo.getUserId() limit 1][0].contact.AccountId;
        String conID = [select id, contactId from User where id =: UserInfo.getUserId() limit 1][0].contactId;
        
        System.debug('accID'+accID);
        System.debug('conID'+conID);
        System.debug('site'+site);
        
        Date selectedDate =  Date.today(); 
        Hoursline housrCalCurrent = calHrs(selectedDate,accID,conID,site);
        
        Date lastDate =  selectedDate.addDays(-7);
        Hoursline housrCallast = calHrs(lastDate,accID,conID,site);
        
        Date last2Date =  selectedDate.addDays(-14);
        Hoursline housrCallast2 = calHrs(last2Date,accID,conID,site);
        
        Date last3Date = selectedDate.addDays(-21);
        Hoursline housrCallast3 = calHrs(last3Date,accID,conID,site);
        
        hoursWrapperl.add(housrCallast3);
        hoursWrapperl.add(housrCallast2);
        hoursWrapperl.add(housrCallast);
        hoursWrapperl.add(housrCalCurrent);
        System.debug('*****hoursWrapperl*'+hoursWrapperl);
        
        return System.json.serialize(hoursWrapperl);
        
    }
    
    
    public static Hoursline calHrs(Date selectedDate,String accID,String conID,String site)
    {
        List<Datetime> current =  getfirstLastDate(selectedDate);
        // Date crtFt = Date.valueOf(current[0]);
        // Date crtlt = Date.valueOf(current[1]);
        
        Date crtFt = date.newinstance(current[0].year(), current[0].month(), current[0].day());
        Date crtlt = date.newinstance(current[1].year(), current[1].month(), current[1].day());
        
        Hoursline housrCalOnj = new Hoursline();
        
        Double currentHrs = 0;
        integer countcheck = 0;
        /*string queryData = 'Select id,sirenum__Total_Hours__c from sirenum__Timesheet__c where IP_CountOfPassedTimesheet_lines__c > :countcheck and IP_CountOfWaitingToPassTimesheetLines__c =: countcheck AND ';

if(site!=null && site !=''){
queryData = queryData + ' sirenum__Site__c =: site AND ';
}

queryData = queryData + ' sirenum__Week_Ending__c <=: crtFt And sirenum__Week_Ending__c >=: crtlt AND sirenum__Site__r.sirenum__Operating_Company__c =: accID  ORDER BY sirenum__Week_Ending__c LIMIT 20';*/
        
        
        String queryData = 'Select id,sirenum__Total_Hours__c,(select id,sirenum__Hours__c from sirenum__Timesheet_Lines__r where IP_Locktimesheet__c = true) from sirenum__Timesheet__c where';
        if(site!=null && site !=''){
            queryData = queryData + ' sirenum__Site__c =: site AND ';
        }
        queryData = queryData + 'sirenum__Week_Ending__c <=: crtFt And sirenum__Week_Ending__c >: crtlt AND sirenum__Site__r.sirenum__Operating_Company__c =: accID  ORDER BY sirenum__Week_Ending__c LIMIT 20';
        
        //List<sirenum__Timesheet__c> queryData =  [Select id,sirenum__Total_Hours__c,(select id,sirenum__Hours__c from sirenum__Timesheet_Lines__r where IP_Locktimesheet__c= true) from sirenum__Timesheet__c where sirenum__Site__c =: site AND sirenum__Week_Ending__c <=: crtFt And sirenum__Week_Ending__c >: crtlt AND sirenum__Site__r.sirenum__Operating_Company__c =: accID  ORDER BY sirenum__Week_Ending__c LIMIT 20];
        //Database.query(queryData)
        System.debug('check result'+queryData);
        System.debug('check 1'+crtFt);
        System.debug('check 2'+crtlt);
        for(sirenum__Timesheet__c ts :Database.query(queryData))
        {
            double timesheetLineHours = 0;
            for(sirenum__Timesheet_Line__c tLine : ts.sirenum__Timesheet_Lines__r){
                timesheetLineHours = timesheetLineHours + tLine.sirenum__Hours__c;
            }
            System.debug('timesheetLineHours--: '+timesheetLineHours);
            currentHrs = currentHrs+timesheetLineHours;
        }
        System.debug('currentHrs--: '+currentHrs);
        housrCalOnj.name = String.valueOf(selectedDate.day()+'/'+selectedDate.month());
        housrCalOnj.y = Integer.valueOf(currentHrs);
        
        return housrCalOnj;
    }
    
    
    
    public static List<Datetime> getfirstLastDate(Date selectedDate)
    {
        List<Datetime> Datel = new List<Datetime>();
        Date firstDate = selectedDate;
        Date lastDate = selectedDate.addDays(-7);
        Datel.add((Datetime)firstDate);
        Datel.add((Datetime)lastDate);
        return Datel;
    }
    
    public static String getStringMonth(Integer month)
    {
        String strMonth;
        if(month == 1)
            strMonth = 'Jan';
        else if(month == 2)
            strMonth = 'Feb'; 
        else if(month == 3)
            strMonth = 'Mar'; 
        else if(month == 4)
            strMonth = 'Apr'; 
        else if(month == 5)
            strMonth = 'May';  
        else if(month == 6)
            strMonth = 'Jun';   
        else if(month == 7)
            strMonth = 'Jul';
        else if(month == 8)
            strMonth = 'Aug';  
        else if(month == 9)
            strMonth = 'Sep';  
        else if(month == 10)
            strMonth = 'Oct'; 
        else if(month == 11)
            strMonth = 'Nov'; 
        else if(month == 12)
            strMonth = 'Dec';                      
        
        return strMonth;
        
    }
    
    
    
    
    public class Hoursline
    {
        @AuraEnabled
        public String name;
        @AuraEnabled
        public integer y;
        
    }
    
}