public with sharing class TriggerFactory
{
    public static void createHandler(Schema.sObjectType soType)
    {
        //Get the handler appropriated to the object being processed .
        ITrigger  handler = getHandler(soType);
        // Execute the handler to fulfil the trigger        
        if(handler!=null)
            execute(handler);
        
    }
    
    private static void execute(ITrigger  handler)
    {
        //Before Trigger 
        if(Trigger.isBefore)
        {
            // Call the bulk before to handle any caching of data and enable bulkification
            handler.bulkBefore();
            
            // Iterate through the records to be deleted passing them to the handler.
            if (Trigger.isDelete)
            {
                for (SObject so : Trigger.old)
                {
                    handler.beforeDelete(so);
                }
            }
            // Iterate through the records to be inserted passing them to the handler.
            else if (Trigger.isInsert)
            {
                for (SObject so : Trigger.new)
                {
                    //system.debug('Value being PAssed' +so);
                    handler.beforeInsert(so);
                    system.debug('Value being PAssed' +so);
                }
            }
            // Iterate through the records to be updated passing them to the handler.
            else if (Trigger.isUpdate)
            {
                for (SObject so : Trigger.old)
                {
                    	handler.beforeUpdate(so, Trigger.newMap.get(so.Id));
                    }  
                    
                    
            }
        }
        else
        {
            // Call the bulk after to handle any caching of data and enable bulkification
            handler.bulkAfter();
            
            // Iterate through the records deleted passing them to the handler.
            if (Trigger.isDelete)
            {
                for (SObject so : Trigger.old)
                {
                    handler.afterDelete(so);
                }
            }
            // Iterate through the records inserted passing them to the handler.
            else if (Trigger.isInsert)
            {
                for (SObject so : Trigger.new)
                {
                    handler.afterInsert(so);
                }
            }
            // Iterate through the records updated passing them to the handler.
            else if (Trigger.isUpdate)
            {
                for (SObject so : Trigger.old)
                {
                    //IP_PayProfile__c oldValue=(IP_PayProfile__c)so;
		            //IP_PayProfile__c newValue=(IP_PayProfile__c)trigger.newmap.get(oldValue.Id);
                    //if((newValue.IP_LastPassedToTempest__c == oldValue.IP_LastPassedToTempest__c) && (newValue.IP_GUID__c == oldValue.IP_GUID__c)) 
                    //{                                                        
         		          handler.afterUpdate(so, Trigger.newMap.get(so.Id));
                    //}
                }              
            }
        }
        // Perform any post processing
        handler.andFinally();
    }
    
    private static ITrigger  getHandler(Schema.sObjectType soType)
    {       
        if (soType == Contact.SobjectType)
        {
            return new ContactTriggerHandler();
        }
        else if(soType == IP_PayProfile__c.SobjectType){
             return new PayProfileTriggerHandler();
        }
        return null;
    }
}