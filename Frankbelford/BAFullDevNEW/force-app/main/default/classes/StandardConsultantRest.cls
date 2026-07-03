//FR15 /StandardConsultant/branchCode/*
@RestResource(UrlMapping='/StandardConsultant/branchCode/*')
global class StandardConsultantRest {
   
    @HttpGet
    global static ResponseClass doGet()
    {
        String[] uriKeys = RestContext.request.requestURI.split('/'); 
        String branchCode = uriKeys.get(uriKeys.size()-1);    
       
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');      
        List<User> userUpdate = new List<User>();
            
      try{  
            
            List<User> userData = [select User.Name,
                                          User.Email,
                                          User.IP_TempestID__c,
                                          User.IP_TempestDivision__c,
                                          User.IP_TempestDepartment__c,
                                          User.Department  from User where user.IP_PassToTempest__c=true
                                                and user.IP_TempestDepartment__c=:branchCode];
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