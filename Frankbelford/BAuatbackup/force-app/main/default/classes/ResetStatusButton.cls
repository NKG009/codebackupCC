public class ResetStatusButton {
    @AuraEnabled
    public static string resetButtonMethod(string BatchId)
    {
       
        string BatchType = [select id,IP_BatchType__c from Batch_header__c where id=:BatchId].IP_BatchType__c;
        string message;
        list<id> idsForDeletion = new list<id>();
        list<IP_BatchLine__c> BatchLineList = [SELECT id,IP_LinkField4__c,IP_LinkField2__c,IP_State__c,IP_Status__c,IP_ErrorReason__c FROM IP_BatchLine__c WHERE IP_BatchHeader__c =:BatchId and IP_Status__c ='Errored' Limit 200]; 
        list<IP_BatchLine__c> updateBatchlist  = new list<IP_BatchLine__c>();
        for(IP_BatchLine__c bl:BatchLineList)
        {
            updateBatchlist.add(new IP_BatchLine__c(id=bl.id,IP_Status__c ='Open',IP_ErrorReason__c=null)); 
            if((bl.IP_LinkField4__c != null ) && (bl.IP_LinkField2__c == null )) 
            {
                idsForDeletion.add(bl.IP_LinkField4__c);
                
            }
            
        }
        if(updateBatchlist.size() > 0)
        {
            update updateBatchlist;
        }
        
        if(BatchType =='Capita')
        {
            if(idsForDeletion.size() > 0)
            {
                database.delete(idsForDeletion,false);
            }
            
            string Capitabatchid =[SELECT Id FROM ApexClass WHERE Name ='CapitaBatchHeaderclass'].id;
            list<AsyncApexJob> asjos = [SELECT ApexClassId, status FROM AsyncApexJob WHERE ApexClassId =:Capitabatchid AND Status NOT IN ('Completed','Aborted','Failed')];
            if(asjos.size() > 0)
            {
                message = 'The batch job is currently executing. Please wait for it to complete.';
            }
            else
            {
                message = 'The Integration batch job has started.';
                Id jobId = Database.executeBatch(new CapitaBatchHeaderclass(),1);
                
            }
            
        }
        if(BatchType =='Netive')
        {
            string Netivebatchid =[SELECT Id FROM ApexClass WHERE Name ='NetiveBatchHeaderclass'].id;
            list<AsyncApexJob> asjos = [SELECT ApexClassId, status FROM AsyncApexJob WHERE ApexClassId =:Netivebatchid AND Status NOT IN ('Completed','Aborted','Failed')];
            if(asjos.size() > 0)
            {
                message = 'The batch job is currently executing. Please wait for it to complete.';
            }
            else
            {
                message = 'The Integration batch job has started.';
                Id jobId = Database.executeBatch(new NetiveBatchHeaderclass(),1);
                
            }
            
        }
        if(BatchType =='Site Update')
        {
            string sitebatchid =[SELECT Id FROM ApexClass WHERE Name ='SiteB2FUpdate'].id;
            list<AsyncApexJob> asjos = [SELECT ApexClassId, status FROM AsyncApexJob WHERE ApexClassId =:sitebatchid AND Status NOT IN ('Completed','Aborted','Failed')];
            if(asjos.size() > 0)
            {
                message = 'The batch job is currently executing. Please wait for it to complete.';
            }
            else
            {
                message = 'The Integration batch job has started.';
                Id jobId = Database.executeBatch(new SiteB2FUpdate(),1);
                
            }
            
        }
        if(BatchType =='Topaz Global Account')
        {
            string topazbatchid =[SELECT Id FROM ApexClass WHERE Name ='TopazGlobalB2FUpdate'].id;
            list<AsyncApexJob> asjos = [SELECT ApexClassId, status FROM AsyncApexJob WHERE ApexClassId =:topazbatchid AND Status NOT IN ('Completed','Aborted','Failed')];
            if(asjos.size() > 0)
            {
                message = 'The batch job is currently executing. Please wait for it to complete.';
            }
            else
            {
                message = 'The Integration batch job has started.';
                Id jobId = Database.executeBatch(new TopazGlobalB2FUpdate(),1);
                
            }
            
        }
        if(BatchType =='Perm Placement')
        {
            string permplacebatchid =[SELECT Id FROM ApexClass WHERE Name ='permplacementB2FUpdate'].id;
            list<AsyncApexJob> asjos = [SELECT ApexClassId, status FROM AsyncApexJob WHERE ApexClassId =:permplacebatchid AND Status NOT IN ('Completed','Aborted','Failed')];
            if(asjos.size() > 0)
            {
                message = 'The batch job is currently executing. Please wait for it to complete.';
            }
            else
            {
                message = 'The Integration batch job has started.';
                Id jobId = Database.executeBatch(new permplacementB2FUpdate(),1);
                
            }
            
        }
        if(BatchType =='Ltd Co Pay Profile')
        {
            string LTDprofilebatchid =[SELECT Id FROM ApexClass WHERE Name ='LTDpayprofileB2FUpdate'].id;
            list<AsyncApexJob> asjos = [SELECT ApexClassId, status FROM AsyncApexJob WHERE ApexClassId =:LTDprofilebatchid AND Status NOT IN ('Completed','Aborted','Failed')];
            if(asjos.size() > 0)
            {
                message = 'The batch job is currently executing. Please wait for it to complete.';
            }
            else
            {
                message = 'The Integration batch job has started.';
                Id jobId = Database.executeBatch(new LTDpayprofileB2FUpdate(),1);
                
            }
            
        }
        if(BatchType =='Umbrella Company')
        {
            string permplacebatchid =[SELECT Id FROM ApexClass WHERE Name ='UmbrellaListB2FUpdate'].id;
            list<AsyncApexJob> asjos = [SELECT ApexClassId, status FROM AsyncApexJob WHERE ApexClassId =:permplacebatchid AND Status NOT IN ('Completed','Aborted','Failed')];
            if(asjos.size() > 0)
            {
                message = 'The batch job is currently executing. Please wait for it to complete.';
            }
            else
            {
                message = 'The Integration batch job has started.';
                Id jobId = Database.executeBatch(new UmbrellaListB2FUpdate (),1);
                
            }
            
        }
        
        return message;
        
    }
    
    
}