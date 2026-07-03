public class excel_document_generation_button {
 	public Apttus_Proposal__Proposal__c abc{get;set;}
	public excel_document_generation_button (ApexPages.StandardController controller) {
	} 
    
    Public Pagereference redirect(){
    	Apttus_Proposal__Proposal__c abc =[SELECT Id,Apttus_Proposal__Approval_Stage__c from Apttus_Proposal__Proposal__c where Id =:apexpages.currentPage().getparameters().get('id')][0];
        abc.Apttus_Proposal__Approval_Stage__c = 'Generated';
        update abc;
        Pagereference p = new Pagereference('/apex/Apttus_XApps__EditInExcelLaunch?parentRecordId='+abc.id+'&&appName=Quote Output');
        p.setredirect(true);
        return p;
    } 
    Public Pagereference cancel(){
        Pagereference p = new Pagereference('/');
        p.setredirect(true);
        return p;
    }
}