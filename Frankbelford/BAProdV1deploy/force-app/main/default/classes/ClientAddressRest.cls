//FR03 parameteres - /services/apexrest/StandardClientAddress/branchCode/1069
//test class name =Test_ClientAddress
@RestResource(urlMapping='/standard/v1/collect/clientaddress/*/*')
global class ClientAddressRest
{
     @HttpGet
    global static ResponseClass doGet()
    {
        String[] uriKeys = RestContext.request.requestURI.split('/');          
        String branchCode = uriKeys.get(uriKeys.size()-2);    
        String GUID= uriKeys.get(uriKeys.size()-1);
        List<sirenum__Site__c> siteUpdate = New List<sirenum__Site__c>();
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');  
        String errorFile = 'Id,Error\n'; 
       Map<id,String> errMessage = new Map<id,String>();
          Impellam_Settings__c set1 = Impellam_Settings__c.getValues('ClientAddressRest'); 
        Integer limit1 = Integer.Valueof(set1.Limit__c);
        system.debug('Limit Value@@@'+set1);         
        
      try{  
            List<sirenum__Site__c> siteData = [select 
                                               /*IP_Clientinvoicename__c,
                                               IP_InvoiceAddressStreet__c,
                                               IP_InvoiceAddressCity__c,
                                               IP_InvoiceAddressCounty__c,
                                               IP_InvoiceAddressPostcode__c,
                                               IP_InvoiceAddressCountry__c,*/  //Changed after invoice address issue 08/12/17 
                                               Name,
                                               sirenum__Street_Address__c,
                                               sirenum__City__c,
                                               sirenum__County__c,
                                               sirenum__Postal_Code__c,
                                               sirenum__Country__c,                                              
                                               IP_MainContact__r.Phone,
                                               IP_MainContact__r.Fax,
                                               IP_MainContact__r.Name,
                                               IP_ClientIDLegacy__c
                                               from sirenum__Site__c where 
                                                IP_TempestDepartment__c=:branchCode and IP_PassClientAddressToTempest__c=true and (GUID_Site_Address__c = null or GUID_Site_Address__c!=:GUID) LIMIT :limit1];
           for(sirenum__Site__c cnt: siteData)
                {                      
                   cnt.GUID_Site_Address__c=GUID;
                    siteUpdate.add(cnt);                                             
                }
          Database.SaveResult[] srList = Database.update(siteUpdate, false);             
           List<id> errorIds = new List<id>();
                 List<id> successIds = new List<id>();
                for (integer i=0; i<srList.size();i++) 
                {
                     String errMsgs = '';
                    if(srList[i].isSuccess())
                    {
                        successIds.add(siteUpdate[i].id);
                    }
                    else
                    {
                        errorIds.add(siteUpdate[i].id);
                        for(Database.Error err : srList[i].getErrors())
                        {
                            errMsgs = errMsgs + '  ' + err.getMessage();       
                        }
                         errMessage.put(siteUpdate[i].Id,errMsgs);
                         errMsgs ='';   
                    }
                }
            if(errorIds.isEmpty())
           return new ResponseClass('true', 'Query executed successfully.',siteData);     
            else
            {
            for(integer i=0;i<errorIds.size();i++)
                {
                    errorFile = errorFile + errorIds[i]+','+ errMessage.get(errorIds[i]) + ',' +'\n';
                 }
            Messaging.EmailFileAttachment errAtt = new Messaging.EmailFileAttachment();    
            blob errBlob = blob.valueof(errorFile);    
            errAtt.setFileName('Failed_Records.csv');
            errAtt.setBody(errBlob);
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage(); 
          /*  List<String>  toAddresses = new List<String>();
            List<User> userList = new List<User>();
            userList = [SELECT Id,Email,IsActive FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = True] ; 
            for (User u : userList)
            {
            toAddresses.add(u.email);
            } */
            String subject ='API Collect Failure - ClientAddress';
            email.setSubject(subject);
            String[] toAddress = new String[] {'ritu.hetawal@espire.com'};
            email.setToAddresses(toAddress);
            email.setPlainTextBody('Hello,\n\nPlease find attached the list of failed records.');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{errAtt});
        
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
           return new ResponseClass('false', 'Error in querying records',null);     
            }
        
        } catch (Exception e) {
            return new ResponseClass('false', e.getMessage(), null);
        }  
    }
    
    global class ResponseClass 
    {

        global String success;
        global String message;
        global List<sirenum__Site__c> records;

        global ResponseClass(String success, String message, List<sirenum__Site__c> records) 
        {
            this.success = success;
            this.message = message;
            this.records = records;
        }
    }
}