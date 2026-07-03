/*
*******************************************************************************************************************
Apex Class Name    : TimeDoctorResponse
Created Date       : August 08, 2023
@description       : This class will get us list of users, tracking StartTime, EndTime, TotalTime to display on UI
@author            : D Shubham 
Modification Log:
Ver       Date             Author                    Modification
58.0      08-08-2023       D Shubham                 Initial Version
*******************************************************************************************************************
*/
public class TimeDoctorResponse {
    /*
*******************************************************************************************************************
@Method Name    : response
@author         : D Shubham 
@description    : method to is used to get list of users, tracking StartTime, EndTime, Total to display on UI
@param          : response('recordId', 'objectName');
@return         : list of users and their tracked StartTime, EndTime and TotalTime
*******************************************************************************************************************
*/
    @AuraEnabled(cacheable=true)
    public static list<CustomReturnBody> response(Id recordid, string Objname){
        try{
            
            Map<String, String> tokenAndCompanyId = TimeDoctorGetToken.getToken();
            String token = tokenAndCompanyId.get('token');
            String companyId = tokenAndCompanyId.get('companyId');
            
            Time_Doctor__mdt tdSummary = [Select id, CompanyId__c, Time_Doctor_Summary_URL__c, To_Time__c, Time_Zone__c from Time_Doctor__mdt];
            String toTime = tdSummary.To_Time__c;
            String tdSummaryURL = tdSummary.Time_Doctor_Summary_URL__c;
            String timeZone = tdSummary.Time_Zone__c;
            
            
            Map<String, String> IdAndEmailMap = TimeDoctorUsers.getUser();
            
            system.debug('recordid:>>'+recordid);
            system.debug('Objname:>>'+Objname);
            list<String> returndata = new list<String>();
            list<CustomReturnBody> Retlist = new list<CustomReturnBody>();
            
            
            
            //Map<String, String> listToBePassed = new Map<String, String>();
            //  if(recid =003 || obj name)
            
            Datetime currentDateTime = System.now();
            String str = currentDateTime.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'', 'Asia/Kolkata');
            System.debug(str);
            
            
            string endpoint= tdSummaryURL+tdSummary.CompanyId__c+'&from=2022-01-01T00:00:00Z&to='+str+'&user=all&fields=userId,start,end,score,project&sort=date&group-by=userId&task=salesforce-'+companyId+'-'+recordid+'&timezone='+timeZone+'&token='+token; 
            
            System.debug(endPoint);
            HttpRequest httpRequest = new HttpRequest();
            httpRequest.setEndpoint(endpoint);
            // httpRequest.setEndpoint('https://api2.timedoctor.com/api/1.1/stats/timesheet/summary?company=ZK_QcqkAn68Gd_Nz&from=2023-06-05T00:00:00Z&to=2023-07-22T23:59:59Z&user=all&fields=userId,start,end,score,project&sort=date&group-by=userId&task=salesforce-ZK_QcqkAn68Gd_Nz-0065i00000HViWzAAL&timezone=America/Los_Angeles&token='+TDmdt.Token__c);
            httpRequest.setMethod('GET');
            String strResponse = null;
            Http http = new Http();
            HttpResponse httpResponse = http.send(httpRequest);
            strResponse = httpResponse.getBody();
            //System.debug(strResponse);
            
            String firstReplacement = strResponse.replace('end', 'end1');
            String secReplacement = firstReplacement.replace('date', 'date1');
            System.debug('TD RESPONSE ::: '+secReplacement);
            
            
            TimeDoctorResponseParser parseValue = (TimeDoctorResponseParser)JSON.deserializeStrict(secReplacement, TimeDoctorResponseParser.class);
            System.debug(parseValue);
            
            //converting json to map
            String jsonResponse = secReplacement; // Your JSON response here
            Map<String, Object> jsonToMap = new Map<String, Object>();
            
            Map<String, Object> dataMap = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
            List<Object> dataList1 = (List<Object>)dataMap.get('data');
            
            if (dataList1 != null && dataList1.size() > 0) {
                List<Object> userData = (List<Object>)dataList1[0];
                
                if (userData != null && userData.size() > 0) {
                    Map<String, Object> userDataMap = (Map<String, Object>)userData[0];
                    String userId = (String)userDataMap.get('userId');
                    jsonToMap.put(userId, userDataMap);
                }
            }
            
            System.debug(jsonToMap);
            System.debug(jsonToMap.keySet());
            System.debug(jsonToMap.values()); 
            //

            
            
            List<List<TimeDoctorResponseParser.data>> dataList = parseValue.data;
            System.debug(dataList);
            
            List<Time_Doctor_Obj__c> tdList = new List<Time_Doctor_Obj__c>();
            List<String> extIDString = new List<String>();
            Set<Id> contactIdSet = new Set<Id>();
            Set<Id> accountIdSet = new Set<Id>();
            Set<Id> leadIdSet = new Set<Id>();
            Set<Id> caseIdSet = new Set<Id>();
            for (List<TimeDoctorResponseParser.data> innerList : dataList) {
                for (TimeDoctorResponseParser.data dataObj : innerList) {
                    System.debug('userId == '+dataObj.userId);
                    System.debug('start == '+dataObj.start);
                    System.debug('end == '+dataObj.end1);
                    System.debug('total == '+dataObj.total);
                    CustomReturnBody rec = new CustomReturnBody();
                    if(IdAndEmailMap.containsKey(dataObj.userId)){
                        rec.UserId= IdAndEmailMap.get(dataObj.userId);
                        rec.StartTime=dataObj.start;
                        rec.EndTime=dataObj.end1;
                        Integer total = dataObj.total;
                        Integer hours = total / 3600;
                        Integer minutes = Math.mod(total, 3600) / 60;
                        Integer seconds = Math.mod(total, 60);
                        String formattedTime = String.valueOf(hours).leftPad(2, '0') + ':' + String.valueOf(minutes).leftPad(2, '0') + ':' + String.valueOf(seconds).leftPad(2, '0');
                        rec.TotalTime = formattedTime;
                        Time_Doctor_Obj__c td = new Time_Doctor_Obj__c();
                        td.TimDoc__ExternalId__c = dataObj.userId;
                        extIDString.add(dataObj.userId);
                        td.TimDoc__User_Email__c = IdAndEmailMap.get(dataObj.userId);
                        td.TimDoc__Start_Time__c = dataObj.start;
                        td.TimDoc__End_Time__c = dataObj.end1;
                        td.TimDoc__Total_Time__c = formattedTime;
                        String recordStr = String.valueOf(recordid);
                        if(recordStr.startsWith('001')){
                           td.TimDoc__Account__c = recordStr;
                            accountIdSet.add(recordStr);
                        }
                        if(recordStr.startsWith('003')){
                           td.TimDoc__Contact__c = recordStr;
                            contactIdSet.add(recordStr);
                        }
                        if(recordStr.startsWith('00Q')){
                           td.TimDoc__Lead__c = recordStr;
                            leadIdSet.add(recordStr);
                        }
                        if(recordStr.startsWith('500')){
                           td.TimDoc__Case__c = recordStr;
                        }
                        tdList.add(td);
                        System.debug('TDLIST  :::: '+tdList);
                        Retlist.add(rec);
                    }
                }
            }  
            
            if(Retlist.size()>0){ 
              return Retlist;  
            }
            else{
                return Null;
            }
            
        }Catch(Exception e){
            System.debug(e.getMessage());
        }
        return null;
    }
    
    public class CustomReturnBody {
        @AuraEnabled public String Email;
        @AuraEnabled public String UserId;
        @AuraEnabled public String StartTime;
        @AuraEnabled public String EndTime;
        @AuraEnabled public String TotalTime;
    }
    
}