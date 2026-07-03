public class InvoiceQuerycallout_controller{
      public List<IP_InvoiceQuery__c> selAccLst;
      public String accIds;
      public String currentParam;

      // Constructor
      public InvoiceQuerycallout_controller(ApexPages.StandardSetController cntlr){
      currentParam = ApexPages.currentPage().getparameters().get('Id'); 
      system.debug('check oaram--->'+currentParam );
           selAccLst = cntlr.getSelected(); //get selected records from account list view
           accIds = '';  
           for(IP_InvoiceQuery__c acc : selAccLst){
               accIds += acc.Id + ','; //build list of ids string concatenated with comma                         
            }
           accIds = accIds.removeEnd(','); 
      } 

      public PageReference redirectToLC(){
            String returnUrl = '/lightning/cmp/c__InvoiceQueryUpdate?c__listofAccounts='+accIds+'&c__accid='+currentParam;
            system.debug('chck url---->'+returnUrl);
            PageReference pgReturnPage = new PageReference(returnUrl);
            pgReturnPage.setRedirect(true);
            return pgReturnPage;
      }

  }