trigger CreateTaskOnCreation on sirenum__Placement__c (after insert,after update) {
List<Task> tlist = new List<Task>();
List<Task> checklist = [Select id from Task where Subject Like '%First day check of the candidate%' and WhatID =: trigger.new];
 Set<ID> siteId= new Set<ID>(); 
 Set<ID> placeId= new Set<ID>(); 
      Map<Id,Id> placemap = new Map<Id,Id>();
      if(Trigger.isInsert)
      {
    for(sirenum__Placement__c sp: trigger.new)
    {
        siteId.add(sp.sirenum__Site__c);
       
    }

  for(sirenum__Site__c st : [Select id,OwnerId from sirenum__Site__c where id in: siteId and Owner.IsActive = True])
  {
      placemap.put(st.id, st.ownerId);
  }
   
for(sirenum__Placement__c sp: trigger.new)
    {
      
          if(checklist.size()== 0 )
            {   Task tsk = new Task();
             if(sp.IP_Consultant1LookupSplitShare__c!=null)
             {
                tsk.Ownerid = sp.IP_Consultant1LookupSplitShare__c;
             }
             else
             {
              if(placemap.size()>0 && placemap.containsKey(sp.sirenum__Site__c))
              {
                tsk.Ownerid = placemap.get(sp.sirenum__Site__c);
              }
                 else
                 {
                    tsk.Ownerid =  UserInfo.getUserId(); 
                 }
             }
                tsk.WhatID = sp.id;
                tsk.Subject = 'First day check of the candidate'; 
                tsk.WhoID = sp.sirenum__Contact__c;
                tsk.ActivityDate = sp.sirenum__Start_Date__c;
                
                tlist.add(tsk);
             
            }
               
    }
    if(tlist.size()>0 && CheckrecurOnTaskCreation.runOnce()){
    try{
        
    Database.insert(tlist, false);
       }
       catch(Exception e) { System.debug('Error on Task Creation '+e);       }
   }
      }
      if(Trigger.isUpdate)
      {
          Set<id> placeset = new Set<id>();
          Set<id> placeset1 = new Set<id>();
          Set<id> emergencyset = new Set<id>();
          Set<id> Timesheetid = new Set<id>();
            for(sirenum__Placement__c place:trigger.new){
            sirenum__Placement__c oldassgn = Trigger.oldMap.get(place.Id);
                if((oldassgn.IP_PassToTempest__c !=place.IP_PassToTempest__c || oldassgn.IP_LastPassedToTempest__c != place.IP_LastPassedToTempest__c || oldassgn.IP_FirstPass__c != place.IP_FirstPass__c) &&  place.IP_PassToTempest__c == TRUE && place.IP_LastPassedToTempest__c == null && place.IP_FirstPass__c == TRUE && place.IP_EmergencyPull__c == FALSE)
                {
                    System.debug('Check first if');
                    placeset.add(place.id);
                }
                if((oldassgn.IP_PassToTempest__c !=place.IP_PassToTempest__c) &&  place.IP_PassToTempest__c == TRUE && place.IP_LastPassedToTempest__c != null && place.IP_FirstPass__c == FALSE && place.IP_EmergencyPull__c ==FALSE)
                {
                    System.debug('Check second if');
                    placeset1.add(place.id);
                }
                if(oldassgn.IP_EmergencyPull__c != place.IP_EmergencyPull__c && place.IP_EmergencyPull__c == TRUE)
                {
                    System.debug('Check third if');
                    emergencyset.add(place.id);
                }
            }
            
            
            if(!placeset.isEmpty())
            {
            AssignmentdataTransfer.sendassigndatafirstpass(placeset);
            }
            if(!placeset1.isEmpty())
            {
            AssignmentdataTransfer.sendassigndatasecondpass(placeset1);
            }
            if(!emergencyset.isEmpty())
            {
                AssignmentdataTransfer.sendemergencydata(emergencyset);
            }
          }       
      }