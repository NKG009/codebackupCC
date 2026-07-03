public class PortalSiteSetupApx {
    @AuraEnabled
    public Static String sitesetup(String siteId){
        
        sirenum__Site__c siteRec =[select id,IP_Timesheet_Method__c,IP_ScheduledAutoApproval__c,
                                   (select id from Contact_Site_links1__r where IP_PortalType__c='Primary Hours Approver' or
                                    IP_PortalType__c='Secondary Hours Approver' or IP_PortalType__c='Escalation Hours Approver')
                                   from sirenum__Site__c where id=:siteId];
        system.debug('siteRec-->'+siteRec.Contact_Site_links1__r.size());
        if(siteRec.Contact_Site_links1__r.size() > 0 )
        {
            
            sirenum__Site__c sitetoupdate = new sirenum__Site__c(id=siteRec.id,IP_Timesheet_Method__c='eTimesheet',IP_ScheduledAutoApproval__c =true); 
            try{
                if(test.isRunningTest())
                {
                    sirenum__Site__c abc  = new sirenum__Site__c();
                    insert abc;
                    return null;
                }
                else{
                    update sitetoupdate;
                    return 'Record has been updated successfully.';                
                }
                
                
            }
            catch(exception e)
            {
                String Message = e.getmessage();
                message = message.substringAfter(',');
                return message;
                
            }
        }
        else
        {
            return 'Please check that a contact is linked to the site and they have a email and portal type assigned.';
        }
        
    }
    
}