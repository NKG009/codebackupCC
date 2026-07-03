trigger Stampdate on IP_TopazGlobalClientInformation__c (after update) {
Set<ID> topazid= new Set<ID>();
DateTime dt= System.Now();    
 for(Integer i=0; i<trigger.new.size(); i++)
    {
             if(trigger.new[i].IP_StatusID__c!= trigger.old[i].IP_StatusID__c)
             {
                if(trigger.new[i].IP_StatusID__c==3)
                 {
             
                 topazid.add(trigger.new[i].id);
                }
                else
                {
                     topazid.add(trigger.new[i].id);
                    
                }
           }
      }
      System.debug('@@ '+topazid);
      If(topazid.size()>0)
      {

List<IP_TopazGlobalClientInformation__c> topaz =  new List<IP_TopazGlobalClientInformation__c>();


for(IP_TopazGlobalClientInformation__c  t :[Select id,Stamp_date_on_hold__c,IP_StatusID__c from IP_TopazGlobalClientInformation__c  where id in:topazid])

{
    if(t.IP_StatusID__c==3)
    {
        t.Stamp_date_on_hold__c = System.today();
        topaz.add(t);
    }
    else
    {
        t.Stamp_date_on_hold__c = Null;
        topaz.add(t);        
    }
    }
System.debug('Update List'+topaz);
Database.SaveResult[] srlist = Database.update(topaz, false);
          for (Database.SaveResult sr : srList) {
    if (sr.isSuccess()) {
        // Operation was successful, so get the ID of the record that was processed
        System.debug('Successfully Updated topaz. ID: ' + sr.getId());
    }
    else {
        // Operation failed, so get all errors                
        for(Database.Error err : sr.getErrors()) {
         System.debug('@@RROR '+err.getStatusCode() + ': ' + err.getMessage()+ ' ## '+sr.getid());

        
        }
    } 
          }
      }
    

}