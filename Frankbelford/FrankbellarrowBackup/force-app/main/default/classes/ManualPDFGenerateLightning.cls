public class ManualPDFGenerateLightning{

    public sirenum__Placement__c ps;
    public List<sirenum__Placement__c> splacement = new List<sirenum__Placement__c>();
    public List<sirenum__Placement__c> splacement1 = new List<sirenum__Placement__c>();

    
    @AuraEnabled
    public static sirenum__Placement__c sPlacementGetDetails(String sPlacementId){
        sirenum__Placement__c sPlacement =[Select id,sirenum__Job_Role__r.sirenum__Rota__r.Name,
                                            sirenum__Contact__r.Person_Status__c,Current_year__c,Current_week__c,
                                           sirenum__Contact__r.HasOptedOutOfEmail,sirenum__Contact__r.Email 
                                           from sirenum__Placement__c where id =:sPlacementId];
        return sPlacement;
    }
    
    
    @AuraEnabled
    public static String saveRecord(String sPlacementId,String selectedpayrollweek,String selectedpayrollyear){   
        system.debug('sPlacementId>>>>>'+sPlacementId);
        system.debug('selectedpayrollweek>>>>>'+selectedpayrollweek);
        system.debug('selectedpayrollyear>>>>>'+selectedpayrollyear);
        List<sirenum__Placement__c> splace = new List<sirenum__Placement__c> ();
        String resMessage;
        sirenum__Placement__c splace1 = [Select id,sirenum__Contact__r.HasOptedOutOfEmail,sirenum__Contact__r.Email
                                    from sirenum__Placement__c where id =:sPlacementId];
        if(!splace1.sirenum__Contact__r.HasOptedOutOfEmail
            && splace1.sirenum__Contact__r.Email != null){
            splace = [Select id,Payroll_week__c, Payroll_year__c,sirenum__Contact__r.HasOptedOutOfEmail,
                    sirenum__Contact__r.Email from sirenum__Placement__c where id =:sPlacementId];
            system.debug('&&HasOptedOutOfEmail'+splace1.sirenum__Contact__r.HasOptedOutOfEmail);
            List<sirenum__Placement__c> updateplace = new List<sirenum__Placement__c> ();
            for (sirenum__Placement__c sp :splace){
                sp.Payroll_week__c = selectedpayrollweek;  
                sp.Payroll_year__c = selectedpayrollyear;
                system.debug('&&Record'+sp);
                updateplace.add(sp);
            }

            update updateplace; 
            if(!test.isrunningtest()){
                sendemail.sendemailtimseheet(sPlacementId);
            }
            /*ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Email sent succesfully.');
            ApexPages.addMessage(myMsg1);  return null;*/
            resMessage = 'Email sent succesfully.';
         
        }       
        else{
           /* ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Candidate does not have an email address or has opted out of Email');
            ApexPages.addMessage(myMsg1);
            return null;*/
            resMessage = 'Candidate does not have an email address or has opted out of Email';        
        }
        return resMessage;
    }
    
    public pagereference closepage(){ return null;}
    
    @AuraEnabled
    public static String printTimesheet(String sPlacementId,String selectedpayrollweek,String selectedpayrollyear){
        system.debug('Inside Print>>>>>'+sPlacementId);
        List<sirenum__Placement__c> splace = new List<sirenum__Placement__c> ();
        splace = [Select id,Payroll_week__c,Payroll_year__c,sirenum__Job_Role__r.sirenum__Rota__r.Name 
                    from sirenum__Placement__c where id =:sPlacementId];
        List<sirenum__Placement__c> updateplace = new List<sirenum__Placement__c> ();
        for (sirenum__Placement__c sp :splace)
        {
            sp.Payroll_week__c = selectedpayrollweek;
            sp.Payroll_year__c = selectedpayrollyear;
            system.debug('&&Record'+sp);
            updateplace.add(sp);
        }
        update updateplace;
        return splace[0].sirenum__Job_Role__r.sirenum__Rota__r.Name;        
        /*if(splace[0].sirenum__Job_Role__r.sirenum__Rota__r.Name == 'driving')
        {
            PageReference pageRef = new PageReference('/apex/Manual_Timesheet_Design?id=' + this.ps.id+'&sx=1');
            return pageRef.setRedirect(true);   
        }
        else
        {
            PageReference pageRef = new PageReference('/apex/Manual_TimeSheet_Design_2?id=' + this.ps.id+'&sx=1');
            return pageRef.setRedirect(true);
        }*/     
    }
}