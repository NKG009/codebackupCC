//FR16 /DateSetConsultant/branchCode/*/date/*
@RestResource(UrlMapping='/DateSetConsultant/branchCode/*/date/*')
global class DateSetConsultantRest {
   
    @HttpGet
    global static ResponseClass doGet()
    {
        String[] uriKeys = RestContext.request.requestURI.split('/'); 
        String dates = uriKeys.get(uriKeys.size()-1); 
        String branchCode = uriKeys.get(uriKeys.size()-3);
       
        /* date function */  
        Pattern dToTime = Pattern.compile('[d]');  
        dates = dToTime.matcher(dates).replaceAll(':'); 
        Pattern TToSpace = Pattern.compile('[T]');  
        dates = TToSpace.matcher(dates).replaceAll(' '); 
        Datetime datetimes = Datetime.valueOf(dates); 
        /* date function */  
        
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');      
        List<User> userUpdate = new List<User>();
            
      try{  
            //Date dt = Date.valueOf(dates); 
            List<User> userData = [select User.Name,
                                          User.Email,
                                          User.IP_TempestID__c,
                                          User.IP_TempestDivision__c,
                                          User.IP_TempestDepartment__c,
                                          User.Department 
                                          from User where 
                                                user.IP_TempestDepartment__c=:branchCode and 
                                   				(IP_PassToTempest__c=true or IP_LastPassedToTempest__c >=: datetimes)];
                                                //(IP_PassToTempest__c=true or DAY_ONLY(convertTimezone(IP_LastPassedToTempest__c)) >=: dt)];
           for(User  cnt: userData)
                {                      
                    cnt.IP_PassToTempest__c=false;
                    cnt.IP_LastPassedToTempest__c=system.now();
                    userUpdate.add(cnt);                                             
                }       
          update userUpdate;                        
           return new ResponseClass('true', 'Query executed successfully.', userData);     
            
        
        } catch (Exception e) {
            return new ResponseClass('false', e.getMessage(), null);
        }  
    }
    
    global class ResponseClass 
    {

        global String success;
        global String message;
        global List<User> records;

        global ResponseClass(String success, String message, List<User> records) 
        {
            this.success = success;
            this.message = message;
            this.records = records;
        }
    }
}