global class LTDpayprofileB2FUpdate extends batchjobsch.BatchJobBase implements Database.Batchable<sObject>,Database.Stateful{

    Set<ID> headerId = new Set<ID>();
    global Database.QueryLocator start(Database.BatchableContext BC){
         String query ='select id,IP_TextField1__c,IP_TextField2__c,IP_TextField15__c,IP_Number12d4Field2__c,IP_TextField3__c,IP_TextField4__c,IP_TextField5__c,IP_TextField6__c,IP_TextField7__c,IP_TextField8__c,IP_TextField9__c,IP_TextField10__c,IP_TextField11__c,IP_TextField12__c,IP_TextField13__c,IP_TextField14__c,IP_Number12d4Field1__c,IP_DateField1__c,IP_LinkField1__c,IP_Status__c,IP_BatchHeader__r.name from IP_BatchLine__c where IP_Status__c = \'open\' and IP_BatchHeader__r.IP_BatchType__c=\'Ltd Co Pay Profile\' And ((IP_BatchHeader__r.IP_State__c = \'Closed\' And IP_BatchHeader__r.IP_Status__c = \'Approved\') OR (IP_BatchHeader__r.IP_State__c = \'Processing\' AND IP_BatchHeader__r.IP_Status__c = \'Errored\') OR (IP_BatchHeader__r.IP_State__c = \'Processing\' AND IP_BatchHeader__r.IP_Status__c = \'Partial Complete\'))';
        return Database.getQueryLocator(query);  
    }
    global void execute(Database.BatchableContext BC,List<IP_BatchLine__c> batchlinelist){
        Database.SaveResult[] sList;
        Map<Id,String> Errmsg = new Map<Id,String>();
        list<string> payprofileid = new list<string>();
        List<IP_PayProfile__c> payprofileupdatelist = new List<IP_PayProfile__c>();
        Map<String,IP_PayProfile__c> paymap = new Map<String,IP_PayProfile__c>();
        for(IP_BatchLine__c bline : batchlinelist){
            headerId.add(bline.IP_BatchHeader__c);
            if(bline.IP_TextField1__c == null)
            {
                bline.IP_Status__c = 'Errored';
                bline.IP_ErrorReason__c = 'Payroll ID (Text Field 1) is blank';
            }
            else
            {
                payprofileid.add(bline.IP_TextField1__c.TRIM());
            }           
        }
        
        for(IP_PayProfile__c paylist : [Select id,IP_PayrollID__c,IP_CompanyName__c,IP_CompanyRegNo__c,IP_VATRegistered__c,IP_VATNumber__c,IP_BusinessAddressLine1__c,IP_BusinessAddressLine2__c,IP_BusinessAddressTown__c,IP_BusinessAddressPostcode__c,IP_BankAccountName__c,IP_AccountNumber__c,IP_SortCode__c,IP_BuildingSocietyNumber__c,IP_OkToSupply__c,IP_Self_Bill_Enabled__c,IP_Self_Bill_Expiry__c from IP_PayProfile__c where IP_PayrollID__c in:payprofileid and Recordtype.name = 'LTD' ])
        {
            paymap.put(paylist.IP_PayrollID__c,paylist);
        }
        for(IP_BatchLine__c batchline2 : batchlinelist){
            if(batchline2.IP_Status__c != 'Errored')
            {
    if(paymap.size()>0 && batchline2.IP_TextField1__c !=null && paymap.containskey(batchline2.IP_TextField1__c))
    {
        batchline2.IP_LinkField1__c = paymap.get(batchline2.IP_TextField1__c).id; 
        batchline2.IP_Status__c ='Linking';
        IP_PayProfile__c payprof = new IP_PayProfile__c();
        payprof.id = paymap.get(batchline2.IP_TextField1__c).id;
        payprof.IP_CompanyName__c = batchline2.IP_TextField2__c;
        payprof.IP_CompanyRegNo__c = batchline2.IP_TextField3__c;
        if(batchline2.IP_Number12d4Field1__c == 1)
        {
        payprof.IP_VATRegistered__c = true;
        }
        if(batchline2.IP_Number12d4Field1__c == 0)
        {
        payprof.IP_VATRegistered__c = false;    
        }
        payprof.IP_VATNumber__c = batchline2.IP_TextField5__c;
        payprof.IP_BusinessAddressLine1__c = batchline2.IP_TextField6__c;
        payprof.IP_BusinessAddressLine2__c = batchline2.IP_TextField7__c;
        payprof.IP_BusinessAddressTown__c = batchline2.IP_TextField8__c;
        payprof.IP_BusinessAddressPostcode__c = batchline2.IP_TextField9__c;
        if(batchline2.IP_TextField10__c != null)
        {
        payprof.IP_BankAccountName__c = batchline2.IP_TextField10__c;
        }
        if(batchline2.IP_TextField11__c != null)
        {
        payprof.IP_AccountNumber__c = batchline2.IP_TextField11__c;
        }
        if(batchline2.IP_TextField12__c != null)
        {
        payprof.IP_SortCode__c = batchline2.IP_TextField12__c;
        }
        if(batchline2.IP_TextField13__c != null)
        {
        payprof.IP_BuildingSocietyNumber__c = batchline2.IP_TextField13__c;
        } 
        payprof.IP_OkToSupply__c = batchline2.IP_Number12d4Field2__c;
        payprof.IP_Self_Bill_Enabled__c = batchline2.IP_TextField14__c;
        payprof.IP_Self_Bill_Expiry__c = batchline2.IP_TextField15__c;
        payprofileupdatelist.add(payprof);
        
        
    }
    else
    {
          batchline2.IP_Status__c = 'Errored';   
          batchline2.IP_ErrorReason__c = 'Pay profile not found';
    }
    }
    else
    {
        batchline2.IP_Status__c = 'Errored';   
        batchline2.IP_ErrorReason__c = 'Payroll ID (Text Field 1) is blank';
    }
        }
        if(payprofileupdatelist.size()>0)
            {
     try{             
                sList=  Database.update(payprofileupdatelist,false);
            
        }
                  
        catch(Exception DMLException){  }
        
        for (integer i=0; i<sList.size();i++) 
            {
                     
                if(sList[i].isSuccess())
                    {
                        System.debug('Successfully updated pay profile: ' + payprofileupdatelist[i].id);
                        Errmsg.put(payprofileupdatelist[i].id,'Success');
                    }
                else
                    {
                        for(Database.Error err : sList[i].getErrors())
                        {
                            Errmsg.put(payprofileupdatelist[i].id,err.getMessage());                           
                        }
                    }
            }        
        for(IP_BatchLine__c batchstatus : batchlinelist){
                for(IP_PayProfile__c t : payprofileupdatelist){
                    System.debug('***Inside for loop***');
                    If(batchstatus.IP_Status__c!='Errored' && batchstatus.IP_LinkField1__c ==t.id){
                    System.debug('***Inside if statement 1***'+Errmsg);
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
         super.finishBatch(BC);
    }
}