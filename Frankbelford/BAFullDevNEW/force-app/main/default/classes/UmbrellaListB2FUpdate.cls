global class UmbrellaListB2FUpdate implements Database.Batchable<sObject>,Database.Stateful{
    Set<ID> headerId = new Set<ID>();
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'Select id,IP_TextField1__c,IP_TextField2__c,IP_TextField3__c,IP_TextField4__c,IP_TextField5__c,IP_TextField6__c,IP_TextField7__c,IP_TextField8__c,IP_TextField9__c,IP_TextField10__c,IP_TextField11__c,IP_TextField12__c,IP_TextField15__c,IP_TextField16__c,IP_LinkField1__c,IP_Status__c,IP_Number12d4Field1__c,IP_Number12d4Field2__c,IP_BatchHeader__r.name,IP_ErrorReason__c from IP_BatchLine__c where IP_Status__c = \'open\' and IP_BatchHeader__r.IP_BatchType__c=\'Umbrella Company\' And ((IP_BatchHeader__r.IP_State__c = \'Closed\' And IP_BatchHeader__r.IP_Status__c = \'Approved\') OR (IP_BatchHeader__r.IP_State__c = \'Processing\' AND IP_BatchHeader__r.IP_Status__c = \'Errored\') OR (IP_BatchHeader__r.IP_State__c = \'Processing\' AND IP_BatchHeader__r.IP_Status__c = \'Partial Complete\'))';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC,List<IP_BatchLine__c> batchlinelist){
        Database.SaveResult[] sList;
        Database.SaveResult[] sList1;
        Map<Id,String> Errmsg = new Map<Id,String>();
        Map<Id,String> Errmsg1 = new Map<Id,String>();
        list<String> supplierref = new list<String>();
        List<IP_Umbrellalist__c> umbrellaupdatelist = new List<IP_Umbrellalist__c>();
        List<IP_Umbrellalist__c> umbrellainsertlist = new List<IP_Umbrellalist__c>();
        Map<String,IP_Umbrellalist__c> umbrellamap = new Map<String,IP_Umbrellalist__c>();
        for(IP_BatchLine__c bline : batchlinelist){
            headerId.add(bline.IP_BatchHeader__c);
            if(bline.IP_TextField1__c == null)
            {
                bline.IP_Status__c = 'Errored';
                bline.IP_ErrorReason__c = 'Supplier Reference (Text Field 1) is blank';
            }
            else
            {
                supplierref.add(bline.IP_TextField1__c);
            }           
        }
         for(IP_Umbrellalist__c umbrellalist : [Select id,IP_SupplierReference__c,Name,IP_CompanyRegNo__c,IP_VATRegistered__c,VAT_Number__c,IP_AddressLine1__c,IP_AddressLine2__c,IP_AddressLine3__c,IP_Postcode__c,IP_BankAccountName__c,IP_BankAccountNumber__c,IP_BankSortCode__c,IP_BuildingSocietyNo__c,IP_OkToSupply__c from IP_Umbrellalist__c where IP_SupplierReference__c in:supplierref and  IP_SupplierReference__c !=null]){
        umbrellamap.put(umbrellalist.IP_SupplierReference__c,umbrellalist);
    }
     for(IP_BatchLine__c batchline2 : batchlinelist){
         if(batchline2.IP_Status__c != 'Errored')
         {
         if(umbrellamap.size()>0 && batchline2.IP_TextField1__c !=null && umbrellamap.containsKey(batchline2.IP_TextField1__c))
         {
            batchline2.IP_LinkField1__c = umbrellamap.get(batchline2.IP_TextField1__c).id; 
            batchline2.IP_Status__c ='Linking';
            IP_Umbrellalist__c umb = new IP_Umbrellalist__c();
            umb.id = umbrellamap.get(batchline2.IP_TextField1__c).id; 
            umb.Name = batchline2.IP_TextField2__c;
            umb.IP_CompanyRegNo__c = batchline2.IP_TextField3__c;
            umb.IP_VATRegistered__c = batchline2.IP_Number12d4Field1__c;
            umb.VAT_Number__c = batchline2.IP_TextField5__c;
            umb.IP_AddressLine1__c = batchline2.IP_TextField6__c;
            umb.IP_AddressLine2__c = batchline2.IP_TextField7__c;
            umb.IP_AddressLine3__c = batchline2.IP_TextField8__c;
            umb.IP_Postcode__c = batchline2.IP_TextField9__c;
            umb.IP_BankAccountName__c = batchline2.IP_TextField11__c;
            umb.IP_BankAccountNumber__c = batchline2.IP_TextField12__c;
            umb.IP_BankSortCode__c = batchline2.IP_TextField15__c;
            umb.IP_BuildingSocietyNo__c = batchline2.IP_TextField16__c;
            umb.IP_OkToSupply__c = batchline2.IP_Number12d4Field2__c;
            umbrellaupdatelist.add(umb);
         }
         else
         {
            IP_Umbrellalist__c umb1 = new IP_Umbrellalist__c();
            umb1.IP_SupplierReference__c = batchline2.IP_TextField1__c;
            umb1.Name = batchline2.IP_TextField2__c;
            umb1.IP_CompanyRegNo__c = batchline2.IP_TextField3__c;         
            umb1.IP_VATRegistered__c = batchline2.IP_Number12d4Field1__c;           
            umb1.VAT_Number__c = batchline2.IP_TextField5__c;
            umb1.IP_AddressLine1__c = batchline2.IP_TextField6__c;
            umb1.IP_AddressLine2__c = batchline2.IP_TextField7__c;
            umb1.IP_AddressLine3__c = batchline2.IP_TextField8__c;
            umb1.IP_Postcode__c = batchline2.IP_TextField9__c;
            umb1.IP_BankAccountName__c = batchline2.IP_TextField11__c;
            umb1.IP_BankAccountNumber__c = batchline2.IP_TextField12__c;
            umb1.IP_BankSortCode__c = batchline2.IP_TextField15__c;
            umb1.IP_BuildingSocietyNo__c = batchline2.IP_TextField16__c;            
            umb1.IP_OkToSupply__c = batchline2.IP_Number12d4Field2__c;
            umbrellainsertlist.add(umb1); 
         }
     }
     else
     {
        batchline2.IP_Status__c = 'Errored';
        batchline2.IP_ErrorReason__c = 'Supplier Reference (Text Field 1) is blank';
     }
     }
      if(umbrellaupdatelist.size()>0)
      {
      try{ 
           
                sList=  Database.update(umbrellaupdatelist,false);
            
        }
                  
        catch(Exception DMLException){  }
         for (integer i=0; i<sList.size();i++) 
        {
            if(sList[i].isSuccess())
                {
                    System.debug('Successfully updated topaz: ' + umbrellaupdatelist[i].id);
                    Errmsg.put(umbrellaupdatelist[i].id,'Success');
                }
            else
                {
                    for(Database.Error err : sList[i].getErrors())
                        {
                            Errmsg.put(umbrellaupdatelist[i].id,err.getMessage());
                        }
                }
        }        
        
         for(IP_BatchLine__c batchstatus : batchlinelist){
                for(IP_Umbrellalist__c t: umbrellaupdatelist){
                    System.debug('***Inside for loop***');
                    If(batchstatus.IP_Status__c!='Errored' && batchstatus.IP_LinkField1__c ==t.id){
                    System.debug('***Inside if statement 1***');
                        If(Errmsg.get(t.Id)!='Success'){
                            batchstatus.IP_Status__c='Errored';    
                            batchstatus.IP_ErrorReason__c=Errmsg.get(t.Id);
                        }
                        else
                        {
                            System.debug('***Inside else***');
                            batchstatus.IP_Status__c='Processed';    
                        }
                        
                    }
                }
            }
        }
        if(umbrellainsertlist.size()>0)
            {
        try{ 
            
                sList1 =  Database.insert(umbrellainsertlist,false);
            
        }
                  
        catch(Exception DMLException){  }
          
        for (Database.SaveResult sr : sList1) {
            if (sr.isSuccess()) {
                System.debug('Successfully inserted Topaz: ' + sr.getId());
                Errmsg1.put(sr.getId(),'Success');
            }
            else {
                for(Database.Error err : sr.getErrors()) {  
                    Errmsg1.put(sr.getId(),err.getMessage());
                }
            }
        }
        for(IP_BatchLine__c batchstatus : batchlinelist){
                for(IP_Umbrellalist__c t : umbrellainsertlist){
                    System.debug('***Inside for loop***');
                    If(batchstatus.IP_Status__c!='Errored' && batchstatus.IP_TextField1__c ==t.IP_SupplierReference__c){
                    System.debug('***Inside if statement 1***');
                        If(Errmsg1.get(t.Id)!='Success'){
                            batchstatus.IP_Status__c='Errored';    
                            batchstatus.IP_ErrorReason__c=Errmsg1.get(t.Id);
                        }
                        else
                        {
                            System.debug('***Inside else***');
                            batchstatus.IP_Status__c='Processed'; 
                            batchstatus.IP_LinkField1__c=t.id;                          
                             
                        }
                        
                    }
                }  
               } 
            }              
        update batchlinelist;
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
    }
}