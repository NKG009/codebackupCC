global class SiteB2FUpdate extends batchjobsch.BatchJobBase implements Database.Batchable<sObject>,Database.Stateful{

    Set<ID> headerId = new Set<ID>();
    Map<id,sirenum__site__c> SiteMap1 = new Map<id,sirenum__site__c>();  
   global Database.QueryLocator start(Database.BatchableContext BC){
     String query ='select id,IP_TextField1__c,IP_TextField2__c,IP_TextField3__c,IP_TextField6__c,IP_TextField7__c,IP_TextField8__c,IP_TextField14__c,IP_TextField4__c,IP_TextField9__c,IP_TextField10__c,IP_TextField13__c,IP_TextField5__c,IP_TextField11__c,IP_TextField12__c,IP_LinkField1__c,IP_Status__c,IP_BatchHeader__r.name from IP_BatchLine__c where IP_Status__c = \'open\' and IP_BatchHeader__r.IP_BatchType__c=\'Site Update\' And ((IP_BatchHeader__r.IP_State__c = \'Closed\' And IP_BatchHeader__r.IP_Status__c = \'Approved\') OR (IP_BatchHeader__r.IP_State__c = \'Processing\' AND IP_BatchHeader__r.IP_Status__c = \'Errored\') OR (IP_BatchHeader__r.IP_State__c = \'Processing\' AND IP_BatchHeader__r.IP_Status__c = \'Partial Complete\'))';
        return Database.getQueryLocator(query);   
   }
   
   global void execute(Database.BatchableContext BC,List<IP_BatchLine__c> batchlinelist){
        Database.SaveResult[] sList;
        Map<Id,String> Errmsg = new Map<Id,String>();
        list<string> SitelegacyID = new list<string>();
        List<sirenum__site__c> siteupdatelist = new List<sirenum__site__c>();
        Map<String,sirenum__site__c> sitemap = new Map<String,sirenum__site__c>();
        for(IP_BatchLine__c bline : batchlinelist){
            headerId.add(bline.IP_BatchHeader__c);
            if(bline.IP_TextField1__c == null)
            {
                bline.IP_Status__c = 'Errored';   
                bline.IP_ErrorReason__c = 'Location ID(Text Field 1) is blank';
            }
            else
            {
                SitelegacyID.add(bline.IP_TextField1__c);
            }
        }
    for(sirenum__site__c sitelist : [Select id,IP_ClientIDLegacy__c,IP_SLNUpdateValue__c,IP_ClientInvoiceName__c,IP_InvoiceAddressStreet__c,IP_InvoiceAddressCity__c,IP_InvoiceAddressCounty__c,IP_InvoiceAddressPostcode__c,IP_InvoiceContactText__c,IP_InvoiceAddressLine4__c,IP_InvoiceAddressLine5__c,IP_InvoiceAddressCountry__c,IP_InvoiceContactEmail__c,IP_InvoiceContactMobile__c,IP_InvoiceContactPhone__c from sirenum__site__c where IP_ClientIDLegacy__c in:SitelegacyID and IP_ClientIDLegacy__c!=null]){
         sitemap.put(sitelist.IP_ClientIDLegacy__c,sitelist);
    }
    
    for(IP_BatchLine__c batchline2 : batchlinelist){
        if(batchline2.IP_Status__c != 'Errored')
        {
    if(sitemap.size()>0 && batchline2.IP_TextField1__c !=null && sitemap.containskey(batchline2.IP_TextField1__c))
    {
        batchline2.IP_LinkField1__c = sitemap.get(batchline2.IP_TextField1__c).id; 
        batchline2.IP_Status__c ='Linking';
        sirenum__site__c site1 = new sirenum__site__c();
        site1.id = sitemap.get(batchline2.IP_TextField1__c).id;
        if(batchline2.IP_TextField2__c != null)
        {
        site1.IP_SLNUpdateValue__c = batchline2.IP_TextField2__c.TRIM();     
        }
        else
        {
        site1.IP_SLNUpdateValue__c = batchline2.IP_TextField2__c;
        }   
        site1.IP_ClientInvoiceName__c = batchline2.IP_TextField3__c;
        site1.IP_InvoiceAddressStreet__c = batchline2.IP_TextField6__c;
        site1.IP_InvoiceAddressCity__c = batchline2.IP_TextField7__c;
        site1.IP_InvoiceAddressCounty__c = batchline2.IP_TextField8__c;
        if(batchline2.IP_TextField14__c != null)
        {
        site1.IP_InvoiceAddressPostcode__c = batchline2.IP_TextField14__c.TRIM();
        }
        else
        {
        site1.IP_InvoiceAddressPostcode__c = batchline2.IP_TextField14__c;
        }
        site1.IP_InvoiceContactText__c = batchline2.IP_TextField4__c;
        site1.IP_InvoiceAddressLine4__c = batchline2.IP_TextField9__c;
        site1.IP_InvoiceAddressLine5__c = batchline2.IP_TextField10__c;
        site1.IP_InvoiceAddressCountry__c =  batchline2.IP_TextField13__c;
        site1.IP_InvoiceContactEmail__c = batchline2.IP_TextField5__c;
        site1.IP_InvoiceContactMobile__c = batchline2.IP_TextField11__c;
        site1.IP_InvoiceContactPhone__c = batchline2.IP_TextField12__c;
        if(!SiteMap1.containskey(site1.id)){           
            SiteMap1.put(site1.id,site1);
            System.debug('check Map in if'+SiteMap1);
         }          
    }
    else
    {
          batchline2.IP_Status__c = 'Errored';   
          batchline2.IP_ErrorReason__c = 'Site not found';
    }
    }
    else
    {
        batchline2.IP_Status__c = 'Errored';   
        batchline2.IP_ErrorReason__c = 'Location ID(Text Field 1) is blank';
    }
    }
  //  siteupdatelist = [Select id,IP_ClientIDLegacy__c,IP_SLNUpdateValue__c,IP_ClientInvoiceName__c,IP_InvoiceAddressStreet__c,IP_InvoiceAddressCity__c,IP_InvoiceAddressCounty__c,IP_InvoiceAddressPostcode__c,IP_InvoiceContactText__c,IP_InvoiceAddressLine4__c,IP_InvoiceAddressLine5__c,IP_InvoiceAddressCountry__c,IP_InvoiceContactEmail__c,IP_InvoiceContactMobile__c,IP_InvoiceContactPhone__c from sirenum__site__c where id in:SiteMap1.keyset()];
  /*  for(Id sitel : SiteMap1.keyset())
    {
       siteupdatelist.addall(SiteMap1.get(sitel));
       System.debug('check final list'+siteupdatelist);
    }*/
    siteupdatelist.addAll(SiteMap1.values());
     if(siteupdatelist.size()>0)
     {
     try{ 
            
                sList=  Database.update(siteupdatelist,false);
            
        }
                  
        catch(Exception DMLException){  }
        
        for (integer i=0; i<sList.size();i++) 
            {
                     
                if(sList[i].isSuccess())
                    {
                       // successIds.add(payprofile[i].id);
                       System.debug('Successfully updated site: ' + siteupdatelist[i].id);
                        Errmsg.put(siteupdatelist[i].id,'Success');
                    }
                else
                    {
                        //errorIds.add(payprofile[i].id);      
                        for(Database.Error err : sList[i].getErrors())
                        {
                           // errMsgs = errMsgs + '  ' + err.getMessage();   
                            Errmsg.put(siteupdatelist[i].id,err.getMessage());      
                        }
                        // errMessage.put(payprofile[i].Id,errMsgs);                           
                    }
            }  
     }
        for(IP_BatchLine__c batchstatus : batchlinelist){
                for(sirenum__site__c t : siteupdatelist){
                    System.debug('***Inside for loop***');
                    If(batchstatus.IP_Status__c!='Errored' && batchstatus.IP_LinkField1__c ==t.id){
                    System.debug('***Inside if statement 1***');
                        If(Errmsg.get(t.Id)!='Success'){
                            batchstatus.IP_Status__c='Errored';
                            if(Errmsg.get(t.Id).length()<255){
                                batchstatus.IP_ErrorReason__c=Errmsg.get(t.Id);
                            }
                            else{
                                batchstatus.IP_ErrorReason__c=Errmsg.get(t.Id).substring(0,255);
                            }
                        }
                        else
                        {
                            System.debug('***Inside else***');
                            batchstatus.IP_Status__c='Processed';    
                        }
                        
                    }
                }
            }
        
        update batchlinelist;
        SiteMap1.clear();
   }
       global void finish(Database.BatchableContext BC){
            Map<Id,Integer> mapUnprocessedBatchHeader = new Map<Id,Integer>();
            Map<Id,Integer> mapErroredBatchHeader = new Map<Id,Integer>(); 
            for(Batch_header__c openStatusBatchHeader : [Select id,IP_Status__c,IP_State__c,Check_status__c,(Select id,IP_Status__c from Batch_Lines__r 
                                                    where IP_Status__c = 'Open') from Batch_header__c  where id=:headerId]){
            if(!openStatusBatchHeader.Batch_Lines__r.isEmpty() && openStatusBatchHeader.Batch_Lines__r.size()>0){
                mapUnprocessedBatchHeader.put(openStatusBatchHeader.id,openStatusBatchHeader.Batch_Lines__r.size());
            }           
        }
        System.debug('mapUnprocessedBatchHeader -- '+mapUnprocessedBatchHeader);
        
        for(Batch_header__c  erroredBatchHeader : [Select id,IP_Status__c,IP_State__c,Check_status__c,(Select id,IP_Status__c from Batch_Lines__r 
                                                    where IP_Status__c = 'Errored' Limit 1) from Batch_header__c  where id=:headerId]){
            if(!erroredBatchHeader.Batch_Lines__r.isEmpty() && erroredBatchHeader.Batch_Lines__r.size()>0){
                mapErroredBatchHeader.put(erroredBatchHeader.id,erroredBatchHeader.Batch_Lines__r.size());
            }           
        }
        System.debug('mapErroredBatchHeader -- '+mapErroredBatchHeader);
        
        List<Batch_header__c> listBatchHeaderUpdate = new List<Batch_header__c>();
        
        for(Batch_header__c  batchHeader : [Select id,IP_BatchTitle__c,Name,IP_Status__c,IP_State__c,Check_status__c 
                                                from Batch_header__c  where id=:headerId]){
            if(!mapUnprocessedBatchHeader.isEmpty() && mapUnprocessedBatchHeader.get(batchHeader.id)>0){
                batchHeader.IP_Status__c = 'Partial Complete';
                batchHeader.IP_State__c = 'Processing';
            }
            else if(!mapErroredBatchHeader.isEmpty() && mapErroredBatchHeader.get(batchHeader.id)>0){
                batchHeader.IP_Status__c = 'Errored';
                batchHeader.IP_State__c = 'Processing';
            }
            else{
                  batchHeader.IP_Status__c = 'Processed';
                  batchHeader.IP_State__c = 'Closed';
            }
          //  batchHeader.Check_status__c = '';
            listBatchHeaderUpdate.add(batchHeader);
        }
        System.debug('listBatchHeaderUpdate -- '+listBatchHeaderUpdate);        
        
        if(!listBatchHeaderUpdate.isEmpty()){
            update listBatchHeaderUpdate;
        }
         super.finishBatch(BC);
    }
}