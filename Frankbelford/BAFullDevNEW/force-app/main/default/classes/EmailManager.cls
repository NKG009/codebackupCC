public class EmailManager {

    private ApexPages.StandardController c;
    Public String IdList{get;set;}
    Public String contactIdList{get;set;}
    
    public EmailManager(ApexPages.StandardSetController stdController) {
        IdList = '';
    }
    
    public PageReference insertResultItemRecords(){
        system.debug('++++++++++contactIdList++++'+contactIdList);
        IdList = contactIdList;
        S_ResultItem__c resultItemRecord = new S_ResultItem__c();
        resultItemRecord.Sel_contact_id_list__c = contactIdList;
        insert resultItemRecord;
        
        PageReference emailManagerPage = new PageReference('/apex/ts2__email_manager');
        emailManagerPage.setRedirect(true);
        emailManagerPage.getParameters().put('cId', resultItemRecord.id);
        emailManagerPage.getParameters().put('src', 'resultitem');
        return emailManagerPage;
    }
}