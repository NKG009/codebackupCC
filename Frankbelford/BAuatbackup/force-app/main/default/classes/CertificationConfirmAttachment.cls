public class CertificationConfirmAttachment {

     
    private final ts2__Certification__c record {get;set;}
    //public CertificationVerifyAttachment__c custom {get;set;}
    
    public CertificationConfirmAttachment(ApexPages.StandardController stdController) 
    {
        this.record = (ts2__Certification__c)stdController.getRecord();
        
    }
    
    public PageReference Save() 
    {
       
        List<ts2__Certification__c> records = new List<ts2__Certification__c>();
        if(record.Verfied__c==true){
            record.IP_Original_Seen_on__c=true;
        
        
        }else{
            record.IP_Original_Seen_on__c=false;
        }
        try{
        update record;
         PageReference pageRef = new PageReference('/apex/CertificationConfirmAttachment?id=' + record.id+'&sx=1'); //
        return pageRef.setRedirect(true);
        } 
        catch(DmlException ex) 
        {
        String errormsg = ex.getMessage();
        String suberror1 = errormsg.substringAfter(',');
        String suberror2 = suberror1.substringBefore(':');
        System.debug('Error message '+ suberror2);
        // ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, suberror2);
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,suberror2));  
        
        System.debug('The following exception has occurred: ' + ex.getMessage());
    
        
        //ApexPages.addMessage(msg);
          return null;
        }
       
       
    }
    
    public PageReference cancel() 
    {
        return null;
    }
    
    public Boolean getSettings() 
    {  
        //List<CertificationVerifyAttachment__c> mcs = CertificationVerifyAttachment__c.getall().values();
        String recordTypeName = [SELECT Name from Recordtype where ID=:record.RecordTypeId].Name;
        for(CertificationVerifyAttachment__c mcs :CertificationVerifyAttachment__c.getall().values()){
            if(mcs.Name==recordTypeName){
                return true;
            }
        }
        return false;
    }
}