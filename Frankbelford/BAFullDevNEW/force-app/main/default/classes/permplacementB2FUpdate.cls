global class permplacementB2FUpdate implements Database.Batchable<sObject>,Database.Stateful{
     Set<ID> headerId = new Set<ID>();
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'Select id,IP_DateField1__c,IP_TextField1__c,IP_DateField2__c,IP_TextField2__c,IP_TextField3__c,IP_TextField4__c,IP_LinkField1__c,IP_Status__c,IP_BatchHeader__r.name,IP_ErrorReason__c  from IP_BatchLine__c where IP_Status__c = \'open\' and IP_BatchHeader__r.IP_BatchType__c=\'Perm Placement\' And ((IP_BatchHeader__r.IP_State__c = \'Closed\' And IP_BatchHeader__r.IP_Status__c = \'Approved\') OR (IP_BatchHeader__r.IP_State__c = \'Processing\' AND IP_BatchHeader__r.IP_Status__c = \'Errored\') OR (IP_BatchHeader__r.IP_State__c = \'Processing\' AND IP_BatchHeader__r.IP_Status__c = \'Partial Complete\'))';
        return Database.getQueryLocator(query);  
    }
    global void execute(Database.BatchableContext BC,List<IP_BatchLine__c> batchlinelist){
        
        Database.SaveResult[] sList;
        Map<Id,String> Errmsg = new Map<Id,String>();
        list<string> permplaceid = new list<string>();
        list<string> creditplaceid = new list<string>();
        List<TR1__Closing_Report__c> permplaceupdatelist = new List<TR1__Closing_Report__c>();
        //List<ts2__Placement__c> creditplaceupdatelist = new List<ts2__Placement__c>();
        Map<String,TR1__Closing_Report__c> permmap = new Map<String,TR1__Closing_Report__c>();
        Map<String,TR1__Closing_Report__c> creditmap = new Map<String,TR1__Closing_Report__c>();
        for(IP_BatchLine__c bline : batchlinelist){
            headerId.add(bline.IP_BatchHeader__c);
            if(bline.IP_TextField3__c == null)
            {
                bline.IP_Status__c = 'Errored';
                bline.IP_ErrorReason__c = 'Placement Debit/Credit Indicator missing (Text field 3)';
            }
            else if(bline.IP_TextField4__c == null)
            {
                bline.IP_Status__c = 'Errored';
                bline.IP_ErrorReason__c = 'Placement/Credit Ref missing (Text field 4)';
            }
            else
            {
                if(bline.IP_TextField3__c == 'Debit')
                    {
                        permplaceid.add(bline.IP_TextField4__c);
                    }
                if(bline.IP_TextField3__c == 'Credit')
                    {
                        creditplaceid.add(bline.IP_TextField4__c);
                    }
            }
        }       
        for(TR1__Closing_Report__c permlist : [Select id,IP_InvoiceNumber__c,IP_Credit_Reference__c,Placement_ID__c,TR1__Invoice_Date__c,IP_Credit_Date__c,IP_Credit_Number__c from TR1__Closing_Report__c where (Placement_ID__c in: permplaceid and RecordType.Name = 'PERM') OR (IP_Credit_Reference__c in: creditplaceid and RecordType.Name = 'Perm Credits')])
        {
            permmap.put(permlist.Placement_ID__c,permlist);
            creditmap.put(permlist.IP_Credit_Reference__c,permlist);
        }
        
        for(IP_BatchLine__c batchline2 : batchlinelist){
            if(batchline2.IP_Status__c != 'Errored')
            {
                if(batchline2.IP_TextField3__c == 'Debit')
                {
                    if(permmap.size()>0 && permmap.containsKey(batchline2.IP_TextField4__c))
                    {
                        batchline2.IP_LinkField1__c = permmap.get(batchline2.IP_TextField4__c).id; 
                        batchline2.IP_Status__c ='Linking';
                        TR1__Closing_Report__c perm1 = new TR1__Closing_Report__c();
                        perm1.id = permmap.get(batchline2.IP_TextField4__c).id; 
                        if(batchline2.IP_TextField1__c != null)
                        {
                        perm1.IP_InvoiceNumber__c = batchline2.IP_TextField1__c;
                        }
                        if(batchline2.IP_DateField1__c != null)
                        {
                        perm1.TR1__Invoice_Date__c = batchline2.IP_DateField1__c;
                        }
                        permplaceupdatelist.add(perm1);
                    }
                    else
                    {
                        batchline2.IP_Status__c = 'Errored';   
                        batchline2.IP_ErrorReason__c = 'Cannot find Placement record (Text field 4)';
                    }
                }
                else if(batchline2.IP_TextField3__c == 'Credit')
                {
                    if(creditmap.size()>0 && creditmap.containsKey(batchline2.IP_TextField4__c))
                    {
                        batchline2.IP_LinkField1__c = creditmap.get(batchline2.IP_TextField4__c).id; 
                        batchline2.IP_Status__c ='Linking';
                        TR1__Closing_Report__c perm2 = new TR1__Closing_Report__c();
                        perm2.id = creditmap.get(batchline2.IP_TextField4__c).id; 
                        if(batchline2.IP_TextField1__c != null)
                        {
                        perm2.IP_Credit_Number__c = batchline2.IP_TextField1__c;
                        }
                        if(batchline2.IP_DateField1__c != null)
                        {
                        perm2.IP_Credit_Date__c = batchline2.IP_DateField1__c;
                        }
                        permplaceupdatelist.add(perm2);
                    }
                    else
                    {
                        batchline2.IP_Status__c = 'Errored';   
                        batchline2.IP_ErrorReason__c = 'Cannot find Placement record (Text field 4)';
                    }
                }
                else
                {
                    batchline2.IP_Status__c = 'Errored';   
                    batchline2.IP_ErrorReason__c = 'Placement Debit/Credit Indicator missing (Text field 3)';
                }
            }
        }
        if(permplaceupdatelist.size()>0)
            {
        try{            
                sList=  Database.update(permplaceupdatelist,false);           
        }
                  
        catch(Exception DMLException){  }
        
        for (integer i=0; i<sList.size();i++) 
            {                     
                if(sList[i].isSuccess())
                    {
                        System.debug('Successfully updated placement: ' + permplaceupdatelist[i].id);
                        Errmsg.put(permplaceupdatelist[i].id,'Success');
                    }
                else
                    {
                        for(Database.Error err : sList[i].getErrors())
                        {
                            Errmsg.put(permplaceupdatelist[i].id,err.getMessage());                           
                        }
                    }
            }  
        for(IP_BatchLine__c batchstatus : batchlinelist){
            for(TR1__Closing_Report__c t : permplaceupdatelist){
                System.debug('***Inside for loop***');
                If(batchstatus.IP_Status__c!='Errored' && batchstatus.IP_LinkField1__c ==t.id)
                {
                System.debug('***Inside if statement 1***'+Errmsg);
                    If(Errmsg.get(t.Id)!='Success')
                    {
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