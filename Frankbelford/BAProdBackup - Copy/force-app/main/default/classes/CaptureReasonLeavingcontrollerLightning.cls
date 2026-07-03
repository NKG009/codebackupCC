public class CaptureReasonLeavingcontrollerLightning{
    
    @AuraEnabled public string check1 {get;set;}
    @AuraEnabled public string check2 {get;set;}
    public CaptureReasonLeavingcontrollerLightning() {
        check1 = null;
        check2 = null;
    }
    
    @AuraEnabled
    public Static String buttonsDisplayed(){
        string buttonDisplayed = '';
        CaptureReasonLeavingcontrollerLightning obj = new CaptureReasonLeavingcontrollerLightning();
        
        if(obj.check1 == null && obj.check2 == null){
            buttonDisplayed = 'Both Null';
        }
        else if(obj.check1 !=null || obj.check2 !=null){
            buttonDisplayed = 'Both Not Null';
        }
        
        return buttonDisplayed;
    }
    
    @AuraEnabled
    public Static String processprofiles(String selectedleavingreason , String contactId){
        
        CaptureReasonLeavingcontrollerLightning obj = new CaptureReasonLeavingcontrollerLightning();
        String messageDisplay = '';
        List<IP_PayProfile__c> paylist = new List<IP_PayProfile__c>();
        List<Contact> conupdate= new List<Contact>();
        //selectedleavingreason = ApexPages.currentPage().getParameters().get('selectedleavingreason');
        system.debug('+++++++++++++selectedleavingreason++++++++++'+selectedleavingreason);
        if(selectedleavingreason == null){
            //ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.P45B2Ferror10);
            //ApexPages.addMessage(myMsg1);
            messageDisplay = 'LeavingReaseonBlank';
        }
        else{
            paylist = [select id,IP_Status__c,P45_Requested__c,Date_P45_Requested__c,RecordType.name,IP_LastPassedToTempest__c,Reason_for_Leaving1__c,IP_PasstoTempest__c  from IP_PayProfile__c where IP_Status__c = 'Active' and IP_Candidate__c =:contactId];
    
            for(IP_PayProfile__c pay : paylist){
                if(pay.IP_LastPassedToTempest__c == null){
                    pay.IP_Status__c = 'Inactive';
                    pay.Reason_for_Leaving1__c = selectedleavingreason;
                    pay.P45_Requested__c = TRUE;
                    pay.Date_P45_Requested__c = System.today();
                    obj.check2 = 'false';                   
                }
                else{
                    if(pay.RecordType.Name == 'PAYE'){
                        pay.Reason_for_Leaving1__c = selectedleavingreason;
                        pay.P45_Requested__c = TRUE;
                        pay.Date_P45_Requested__c = System.today();
                        pay.IP_PasstoTempest__c = TRUE;
                        obj.check1 = 'true';                        
                    }
                    else{
                        pay.IP_Status__c = 'Inactive';
                        pay.Reason_for_Leaving1__c = selectedleavingreason;
                        pay.P45_Requested__c = TRUE;
                        pay.Date_P45_Requested__c = System.today();
                        obj.check2 = 'false';
                    }
                }
            }
            try{
                update paylist;
            }
            catch(DmlException e){
                //ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
                //ApexPages.addMessage(myMsg1);
				messageDisplay = e.getMessage();
                system.debug('Inside Exception'+e.getMessage());
                obj.check1 = null;
            }
        
        
            Contact con = [Select id,IP_Allpayprofiles__c,IP_UmbCount__c,IP_LTDPayProfileCount__c,IP_ActivePAYEPayProfiles__c from Contact where id =:contactId];
            system.debug('**Check count**'+con.IP_Allpayprofiles__c);
            if(con.IP_Allpayprofiles__c == 0){
                con.Person_Status__c = 'Inactive';
                conupdate.add(con);
            }
            update conupdate;
            system.debug('check 1 value'+ obj.check1);
            system.debug('check 2 value'+ obj.check2);
            if(obj.check1 == 'true'){
                //ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.CONFIRM,System.Label.P45B2Ferror9);
                //ApexPages.addMessage(myMsg1);
                messageDisplay = 'ConfirmMessage';
            }
            if(obj.check2 == 'false' && obj.check1 == null){
                //ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.CONFIRM,System.Label.P45B2Ferror8);
                //ApexPages.addMessage(myMsg1);
                messageDisplay = 'ConfirmMessageSecond';
            }
        }
        return messageDisplay;
    }
}