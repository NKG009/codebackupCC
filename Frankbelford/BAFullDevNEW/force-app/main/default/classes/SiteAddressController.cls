public class SiteAddressController {
       public sirenum__Site__c siterecords{get;set;}
    public String OwnerID{get;set;}
    public String ownername{get;set;}
      public boolean checkacc{get;set;}
    public String Acctid;
    public String AccountName{get;set;}
   
    public Id siteId;
     public Id userid;
    
      public SiteAddressController(ApexPages.StandardController controller) {
              siterecords = new sirenum__Site__c();
  if(ApexPages.currentPage().getParameters().get('accid') != null)
    {
      checkacc = false;  
      Acctid = ApexPages.currentPage().getParameters().get('accid');
      Account a = [Select id,Name,Unit_ID__c from Account where id=:Acctid];
      AccountName = a.Name;
      siterecords.sirenum__Operating_Company__c = Acctid;
      siterecords.Unit_ID__c = a.Unit_ID__c != null ? a.Unit_ID__c : null;
    }
    else
    {
        checkacc = true;
    }
    User u = [Select id,Name from User where id=:UserInfo.getUserId()];
    ownername = u.Name;
    }
        
    public pageReference saveandredirect()
    {
          sirenum__Site__c site = new sirenum__Site__c();
        site.Name = siterecords.Name;
        site.OwnerID =  UserInfo.getUserId();
         if(Acctid == null)
     {
     site.sirenum__Operating_Company__c = siterecords.sirenum__Operating_Company__c;
     }
     else
     {
       site.sirenum__Operating_Company__c = Acctid;
     }
        //site.sirenum__Operating_Company__c = siterecords.sirenum__Operating_Company__c;
       // site.sirenum__Inactive__c = siterecords.sirenum__Inactive__c;
       site.Status__c = siterecords.Status__c;
          site.IP_MainContact__c = siterecords.IP_MainContact__c;
           site.Weekly_rebook_reminder__c = siterecords.Weekly_rebook_reminder__c;
        site.IP_Costcode__c = siterecords.IP_Costcode__c;
          site.HSContact__c = siterecords.HSContact__c;
         site.IP_Timesheet_Method__c = siterecords.IP_Timesheet_Method__c;
           site.sirenum__Phone1__c = siterecords.sirenum__Phone1__c;
         site.Drivers_Negligence__c = siterecords.Drivers_Negligence__c;
             site.IP_PublicSector__c = siterecords.IP_PublicSector__c;
             site.IP_Public_Sector__c = siterecords.IP_Public_Sector__c;
            site.sirenum__Travel_Instructions__c = siterecords.sirenum__Travel_Instructions__c;
            site.Email_Shifts_to_Client__c = siterecords.Email_Shifts_to_Client__c;
          site.sirenum__Comments__c = siterecords.sirenum__Comments__c;
          site.GlobalClientName__c = siterecords.GlobalClientName__c;
          site.IP_InvoicePONumber__c= siterecords.IP_InvoicePONumber__c;
          site.IP_ClientInvoiceName__c = siterecords.IP_ClientInvoiceName__c;
          site.IP_InvoiceContactText__c = siterecords.IP_InvoiceContactText__c;
        site.IP_PassClientToTempest__c = siterecords.IP_PassClientToTempest__c;
          site.IP_PassClientAddressToTempest__c = siterecords.IP_PassClientAddressToTempest__c;
         site.IP_InvoiceContactEmail__c = siterecords.IP_InvoiceContactEmail__c;
          site.IP_InvoiceContactMobile__c = siterecords.IP_InvoiceContactMobile__c;
          site.IP_InvoiceContactPhone__c = siterecords.IP_InvoiceContactPhone__c;
        site.Unit_ID__c = siterecords.Unit_ID__c;
        //  site.IP_InvoiceContactEmail__c = siterecords.IP_InvoiceContactEmail__c;
       try
       {
         insert site;
         system.debug('Stranger Things  '+site );
         PageReference pageref = new PageReference('/'+site.id);
         pageref.setRedirect(true);
        return pageref;
        /*PageReference pageref = new PageReference('/apex/SiteAddressFinder?id='+site.id);
        pageref.setRedirect(true);
        return pageref;*/
        }
        catch(Exception e)
     {
         ApexPages.addMessages(e);
         return null;
     }     
    }
    public pageReference cancelredirect() 
    {
        
        Pagereference pagenew = new Pagereference('/a3e/o');
        pagenew.setRedirect(true);
        return pagenew;
    }
}