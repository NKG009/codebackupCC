global class Placement_ShiftdeleteJob implements Database.Batchable<sObject>,Database.Stateful{
    public String errorFile = 'Id,Error,Message\n';
    public Boolean sendMail = false;
    public Integer counter=0;

    global Database.QueryLocator start(Database.BatchableContext BC){
        IP_ImpellamGlobalSetting__c imp = IP_ImpellamGlobalSetting__c.getOrgDefaults();
        String limitdays = imp.S_placementLimitSize__c;
      //  List<String> listId = new List<String>();
      //  listId.add('a3E0E000000FcFC');
        string query = 'Select id,(Select sirenum__Placement__c from sirenum__Shifts__r where sirenum__Published__c = TRUE and sirenum__Timesheet_summaries__c = NULL and sirenum__Scheduled_Start_Time__c < '+limitdays+') from sirenum__Placement__c where IP_LastPassedToTempest__c=NULL and createddate < '+limitdays;
        return Database.getQueryLocator(query);
     
    }
    
    global void execute(Database.BatchableContext BC,List<sirenum__Placement__c> splacementList){
        
        //Map<Id,sirenum__Shift__c> mapSplacementIdShiftRecord = new Map<Id,sirenum__Shift__c>();
        Map<Id,Integer> mapSplacementIdShiftRecordsSize = new Map<Id,Integer>();
        List<Id> listSplacementId = new List<Id>();
        IP_ImpellamGlobalSetting__c imp = IP_ImpellamGlobalSetting__c.getOrgDefaults();
        String limitdays = imp.S_placementLimitSize__c;
        
        String query = 'Select id,(Select sirenum__Placement__c from sirenum__Shifts__r) from sirenum__Placement__c where IP_LastPassedToTempest__c=NULL and createddate < '+limitdays;
        
        List<sirenum__Placement__c> listPlacement = Database.query(query);

        if(listPlacement.size()>0)
        {
        for(sirenum__Placement__c placement : listPlacement){
            mapSplacementIdShiftRecordsSize.put(placement.id,placement.sirenum__Shifts__r.size());
        }
        }
        system.debug('+++++++++splacementList++'+splacementList);
        for(sirenum__Placement__c placement : splacementList){
            system.debug('+++++++++placement.sirenum__Shifts__r++'+mapSplacementIdShiftRecordsSize.get(placement.id));
            system.debug('+++++++++placement.sirenum__Shifts__r++'+placement.sirenum__Shifts__r.size());
            if(mapSplacementIdShiftRecordsSize.get(placement.id) == 0 || 
                placement.sirenum__Shifts__r.size() ==  mapSplacementIdShiftRecordsSize.get(placement.id)){
                listSplacementId.add(placement.id);
            }
            //mapSplacementIdShiftRecord.put(placement.id,placement.sirenum__Shifts__r);
        }
        system.debug('+++++++++listSplacementId++'+listSplacementId);
        //List<sirenum__Placement__c> placelist = scope;
   
        if(!listSplacementId.isEmpty()){
            List<sirenum__Assignment__c> assignment = [Select id from sirenum__Assignment__c where sirenum__Placement__c in : listSplacementId];

                Database.DeleteResult[] drList = Database.delete(assignment, false);
            
             for(Database.DeleteResult dr : drList) {
                if (dr.isSuccess()) {
                   

                }
                else {
                                   
                    for(Database.Error err : dr.getErrors()) {
                                       
                          errorFile = errorFile + dr.getId()+','+ err.getMessage() + ',' + err.getFields() + ',' + '\n';    
                        sendMail = True;            
                    }
                }
            }
            Database.DeleteResult[] drList2 = Database.delete(listSplacementId, false);


            for(Database.DeleteResult dr : drList2) {
                if (dr.isSuccess()) {
                   

                }
                else {
                                   
                    for(Database.Error err : dr.getErrors()) {
                                       
                     
                        errorFile = errorFile + dr.getId()+','+ err.getMessage() + ',' + err.getFields() + ',' + '\n';    
                        sendMail = True;                    
                    }
                }
            }
            
                         
        } 
        
        if(Test.isRunningTest())
        {
            sendMail = TRUE;
        }
       
    }
    global void finish(Database.BatchableContext BC){
    

       If(sendMail == true)
            {
        
            Messaging.EmailFileAttachment errAtt = new Messaging.EmailFileAttachment();                
            blob errBlob = blob.valueof(errorFile);    
            errAtt.setFileName('Failed_Records.csv');
            errAtt.setBody(errBlob);    
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage(); 
            String subject ='Placement Delete Job Issue';
            email.setSubject(subject);
            //  String[] toAddresses = new String[] {emailid};
           // email.setToAddresses(toAddresses);
          email.saveAsActivity= false;
             email.settargetObjectId(UserInfo.getUserId()); 
            email.setPlainTextBody('Hello,\n\nPlease find attached the list of failed records.');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{errAtt});
        
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        
        } 
    }
}