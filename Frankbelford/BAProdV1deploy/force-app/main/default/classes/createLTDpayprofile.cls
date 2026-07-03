public class createLTDpayprofile {

    public String recordtypeid{get;set;}
    public  String parentId{get;set;}
    public String recname{get;set;}
    public String parentname {get;set;}
    public IP_PayProfile__c payrec{get;set;}
    
    public createLTDpayprofile(ApexPages.StandardController controller) {
    
    payrec= new IP_PayProfile__c();
    if(ApexPages.currentPage().getParameters().get('conID') != null)
    {
     parentId = ApexPages.currentPage().getParameters().get('conID');
    Contact con = [Select id,Name from COntact where id=:parentId];
    parentname= con.Name;
    payrec.IP_Candidate__c = con.ID;
    }
    if(ApexPages.currentPage().getParameters().get('recid') != null) 
    {
    recordtypeid = ApexPages.currentPage().getParameters().get('recid');
    RecordType rec = [Select id,Name from RecordType where id =: recordtypeid];
    recname = rec.Name;
    payrec.RecordTypeID = rec.id;
    }   
    
    }
    
    public pageReference saveandredirect()
    {
     IP_PayProfile__c pay = new IP_PayProfile__c();
     pay.RecordTypeid = recordtypeid;
     pay.IP_candidate__c = payrec.IP_Candidate__c;
     pay.IP_PrimaryPayMethod__c = payrec.IP_PrimaryPayMethod__c;
     pay.IP_CompanyName__c = payrec.IP_CompanyName__c;
     pay.IP_EmailPayslip__c = payrec.IP_EmailPayslip__c;
     pay.IP_CertificateOfIncorporation__c = payrec.IP_CertificateOfIncorporation__c;
     pay.IP_CompanyRegNo__c =payrec.IP_CompanyRegNo__c;
     pay.IP_VATRegistered__c = payrec.IP_VATRegistered__c;
     pay.IP_VATNumber__c = payrec.IP_VATNumber__c;
     pay.IP_TermsOfEngagement__c = payrec.IP_TermsOfEngagement__c;
     pay.IP_BankAccountName__c = payrec.IP_BankAccountName__c;
     pay.IP_AccountNumber__c = payrec.IP_AccountNumber__c;
     pay.IP_SortCode__c = payrec.IP_SortCode__c;
     pay.IP_Status__c = 'Active';
     pay.IP_PassToTempest__c = payrec.IP_PassToTempest__c;
     pay.IP_LastPassedToTempest__c = payrec.IP_LastPassedToTempest__c;
     pay.IP_BuildingSocietyNumber__c  = payrec.IP_BuildingSocietyNumber__c ;
     pay.IP_PayFrequency__c = payrec.IP_PayFrequency__c;
     try
     {
     insert pay;
     PageReference pageref = new PageReference('/apex/AddressFinderPayProfile?id='+pay.id);
     pageref.setRedirect(true);
     return pageref;
     }
     catch(Exception e)
     {
         ApexPages.addMessages(e);
         return null;
     }
     
    }
    
    public pageReference cancelredirect()
    {
        Pagereference pagenew = new Pagereference('/'+parentID);
         pagenew.setRedirect(true);
     return pagenew;
    }

}